Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9242B233B79
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 00:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbgG3Wl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 18:41:58 -0400
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:33664
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728588AbgG3Wl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 18:41:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/mBkrMmAeaXgyjfv0qCkV5IUgoynXd7Gj3/pi9oVAb0A4eqKMfnQXaJNWmZf0r1rTmNEFUgRwjg1vPtbYOM+sbBRQ8O8xqDe+VmINI3sP+NJsDNOJyC74KGXo1SFp+t/wOzq4aPfR0+iK2rQ4wUw+XWVa/rOEudJtnGDzl8jQppH0W8ybLroXYBfh9z2OnFlvDdDRfSJptSTDTSVeiX3M6UYaNQ8peyFI3h8GFlHQhsIr56A97MVAqRzDItYEbOnO7EvTUMGQ5JWcGwy/GAbIwl2FbeZILysy9E2WN5v3DA7ccw29Q1bzCOCkr96FdJlByV+o3Pt7PHuK1LX/0pRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0q90Il21xMxD4Fq5QNwEdy7EnAdBR/1ghyCSOXM6YU=;
 b=ExXODfi/7uTr8wjfb+wH6Lo2zQqI9rg5ArwMjxPSfJt9UGgYkF7EEPxcc4SWcZ0nK5UvXuQaDGgCbJAnVQhwxxSx9wbHiRfRKmgdtbcIRnMqb8bZ+TIBbcU+9sgbOnLf/FBfq6pLUL7vG5FB0KqDiR/fMG5si1PcXcf9UUXnKh6KIIoAS4EzGIhyneX4go1FNYmIfVK30p5sqRR4S/2TfPIalrtD2+tFoU9Jeup8llqKdLlzBoEA5f0ASxAiNsL1W7Yd/lh/JM1chdq+tpw1BGNIXh3o4FA/W6BWEW4f48ik0K7LbPPdvxBS4FSoOohmed/UZluZqqpgAI4UHYRxRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0q90Il21xMxD4Fq5QNwEdy7EnAdBR/1ghyCSOXM6YU=;
 b=uam2K6xVJ4PfNQ1Df8d73WoeVwn4YfRb/5kgUkv8obUIyKwdT0rpQu9YDsGnoUgQbqalOwl+PEHzFxXERz1I5lDen8ud4lkit3X20wTmrifhNzJkGWI77z9Hw4Re1ah/ocKvAD/ZhS7RzsYdTa9uzhbw9A7i0wsCu0xTFfevEd0=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2733.namprd12.prod.outlook.com (2603:10b6:805:77::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18; Thu, 30 Jul
 2020 22:41:54 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Thu, 30 Jul 2020
 22:41:54 +0000
Subject: RE: [PATCH v3 03/11] KVM: SVM: Change intercept_dr to generic
 intercepts
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
 <159597948692.12744.7037992839778140055.stgit@bmoger-ubuntu>
 <CALMp9eRF-ScqaWG7vn2mxKmR4jWo7LYZiiicHksiZR9hh+G=-A@mail.gmail.com>
 <3841a638-eb9e-fae6-a6b6-04fec0e64b50@redhat.com>
 <2987e401-f021-a3a7-b4fa-c24ff6d0381b@amd.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <560456cc-0cda-13f6-d152-3dca4896e27f@amd.com>
Date:   Thu, 30 Jul 2020 17:41:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <2987e401-f021-a3a7-b4fa-c24ff6d0381b@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0158.namprd07.prod.outlook.com
 (2603:10b6:3:ee::24) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by DM5PR07CA0158.namprd07.prod.outlook.com (2603:10b6:3:ee::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Thu, 30 Jul 2020 22:41:53 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5873a445-b973-4a76-6fe3-08d834d9c244
X-MS-TrafficTypeDiagnostic: SN6PR12MB2733:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2733D46FF8221C76FFAEA6D595710@SN6PR12MB2733.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vyP96+lks6EOMxxWwSjgbnyZZq6m78kaYOPdSbEyg+DszJg9FoJgcjzNSL0pe5Ini2W7Er90mJb4JowNeXYo6l6y3yy3SBw5LZc98+OQRDHcF7n0BmoC73yMSpdcakvs+Sga5BkxQFOYM9UVFfI6lMH1YB/68BMUT/qgFFiAEM7IOeovRbkBfn2cmsgsGWDLtPdpUL8P1QEMGV5Tiowjq0RrP/9o6Z3f5hGDoaUUhur33W6QiOIp5WB/sbLv2h9TkHfgmFYuRHGi2Lr1xKl8pSIv6PtXvy8m8uY5dF7D5T5T3LjBCE7uY2wcnCOh1gwejzqnLfvh8IGDkkZuiO6Ic2PaTgTr8lo8Uvk2Gt2aDJqqtw1OsI+rs97uga/uX9mAGmyciRe+m/2VKv+K3xw2PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(44832011)(16526019)(7416002)(16576012)(8676002)(4326008)(6486002)(186003)(2906002)(31696002)(31686004)(36756003)(2616005)(53546011)(86362001)(5660300002)(110136005)(316002)(66946007)(66476007)(66556008)(26005)(83380400001)(956004)(478600001)(54906003)(8936002)(52116002)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DOjo3dlS8FRWhCpLB7ClOUqDTfyCf7Ug3tHXl7Uf2NjiGM775QOpGikSSZAx+5+FkyZq8Ij8Q33SJoW2go8+Gq+iQ3nIm2MzQELBN8AGawNKOydUL1qGJJ39XePOUF6Tceuab1r2/0yltRsg243Pvmbuer6UbvNOfFa1MTI4rO/iHr9O7qXaZSqXKe5vtaDsQ4pIeMKxzX36LgAEKZe/WqZSYHANk4p2AbnlmXo/SAIbeTjAKA4L6lbaJiCm6f08KUEytCuIxyhrIoB56jFIXnUFMfi19udWxgtrQsb2NDjpzsNuQDg3hnSgsY0DTFYKczQDEE8lt+HX8UFtYefVauN8b47PHXTTtEg9TaOYIL+627diz0RyM0Jc3QcLOGzSiWQ1iU9IJISXmDxw2OJhOas2c1nEH5iz5K6kNT+33GoGLc9pXoEfDM+mX6l7zB08NX1zQjS/NZwljymE9GFqO4at6f1ZnzQyo4UQfZejgfjDqmJ/v6CZR4Zx356i9cX7o7IStwhK/dU3/wDVfaWsE/eDW/z6zsnagwYU7WkTYswXHnvveVHWh45FCTBgaezUMvgUy6gEONhhT0j2/DQepsbML57Cqq+7YPHD4G8wZAPq+vjh/VxAEt++dHRcm35HQMkwDepZUJJl/083Pvf5Qg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5873a445-b973-4a76-6fe3-08d834d9c244
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 22:41:54.6926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yn9vij1qTmpALIK/uZ/TocYdAOgzyftYf52LlKBf/DhAEWptPgATiAPW/CN6Q/v+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2733
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Babu Moger
> Sent: Thursday, July 30, 2020 11:38 AM
> To: Paolo Bonzini <pbonzini@redhat.com>; Jim Mattson
> <jmattson@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng Li
> <wanpengli@tencent.com>; Sean Christopherson
> <sean.j.christopherson@intel.com>; kvm list <kvm@vger.kernel.org>; Joerg
> Roedel <joro@8bytes.org>; the arch/x86 maintainers <x86@kernel.org>; LKML
> <linux-kernel@vger.kernel.org>; Ingo Molnar <mingo@redhat.com>; Borislav
> Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Thomas Gleixner
> <tglx@linutronix.de>
> Subject: RE: [PATCH v3 03/11] KVM: SVM: Change intercept_dr to generic
> intercepts
> 
> 
> 
> > -----Original Message-----
> > From: Paolo Bonzini <pbonzini@redhat.com>
> > Sent: Wednesday, July 29, 2020 6:12 PM
> > To: Jim Mattson <jmattson@google.com>; Moger, Babu
> > <Babu.Moger@amd.com>
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng Li
> > <wanpengli@tencent.com>; Sean Christopherson
> > <sean.j.christopherson@intel.com>; kvm list <kvm@vger.kernel.org>;
> > Joerg Roedel <joro@8bytes.org>; the arch/x86 maintainers
> > <x86@kernel.org>; LKML <linux-kernel@vger.kernel.org>; Ingo Molnar
> > <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; H . Peter Anvin
> > <hpa@zytor.com>; Thomas Gleixner <tglx@linutronix.de>
> > Subject: Re: [PATCH v3 03/11] KVM: SVM: Change intercept_dr to generic
> > intercepts
> >
> > On 29/07/20 01:59, Jim Mattson wrote:
> > >>         case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
> > >> -               u32 bit = 1U << (exit_code - SVM_EXIT_READ_DR0);
> > >> -               if (svm->nested.ctl.intercept_dr & bit)
> > >> +               if (__is_intercept(&svm->nested.ctl.intercepts,
> > >> + exit_code))
> > > Can I assume that all of these __<function> calls will become
> > > <function> calls when the grand unification is done? (Maybe I should
> > > just look ahead.)
> > >
> >
> > The <function> calls are reserved for the active VMCB while these take a
> vector.
> > Probably it would be nicer to call them vmcb_{set,clr,is}_intercept
> > and make them take a struct vmcb_control_area*, but apart from that
> > the concept is fine
> >
> > Once we do the vmcb01/vmcb02/vmcb12 work, there will not be anymore
> > &svm->nested.ctl (replaced by &svm->nested.vmcb12->ctl) and we will be
> > able to change them to take a struct vmcb*.  Then is_intercept would
> > for example be
> > simply:
> Yea. True. It makes the code even cleaner. Also we can avoid calling
> recalc_intercepts every time we set or clear a bit inside the same function(like
> init_vmcb).
> 
> Let me try to understand.
> 
> vmcb01 is &svm->vmcb->control;l
> vmcb02 is &svm->nested.hsave->control
> vmcb12 is  &svm->nested.ctl;
> 
> The functions set_intercept and clr_intercept calls get_host_vmcb to get the
> vmcb address.

I will move the get_host_vmcb inside the caller and then call
vmcb_set_intercept/vmcb_clr_intercept/vmcb_is_intercept directly.
I will re post the series. This will change the whole series a little bit.

Jim has already reviewed some of the patches. But I probably cannot use
"Reviewed-by" if I change the patches too much. thanks

> 
> static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm) {
>         if (is_guest_mode(&svm->vcpu))
>                 return svm->nested.hsave;
>         else
>                 return svm->vmcb;
> }
> 
> I need to study little bit when is_guest_mode Is on or off.  Let me take a look at.


> 
> Thanks
> 
> >
> > 	return vmcb_is_intercept(svm->vmcb, nr);
> >
> > as expected.
> >
> > Paolo

