Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8722336F4
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 18:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgG3QiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 12:38:12 -0400
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:45685
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbgG3QiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 12:38:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZ//ti6FoYSmCggvWerSSzHb4jbMooQAHnMISqIHeNiKgVAkP++Mx7sYSZcUMGbjl1C19Vt6aYOqD8piLjt3F6TiQDAuINsowoRNAEPzij7PHPHCKIzKFRyPz9zF6A2/lbC/7QRqPnCeAHY7ApbFM4iguXJsmsh314AHSMZX9K+E8Hy36nwVG5WANTmsSJIUDqC86qBTs2QQnlbeXEDZ178heeQR/WQ5kGzDamBvrxr7I9TcF4258bg9iNuvTN5NtWfBjYLN5XCyH3lMPj8ESYwza3KebQBTt18Fo+rorFosCsvc2b6b9bn9YOZtzXtC+K+U9rp7/hIu2dTz/nMylA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBYjKOTHnKTUFXuGdIU0TJ2NyRGmf/Dyh0LKfZO1TIA=;
 b=GJ5+hDAJUAJ2CoP5p/KXaJnYkFrWFAIj9sUbxPDwRW9zG5IhPB9GMg9FbwVe5LffwS+NjEKkbul0cQud99q+y9qLI6kCTMt4njxCuJVxMvOX331uEihqBH0NKg0Bp6U0InEXyADbpiAF5ebcx8esclAVa4mPBpSF4fWx9m0yZL33EHcWx9I9TpJtLtxxLRHKBLUsCQi9E9fwDzQ3jshMT79Mif7BgOA6hEuLQGOogyNYhsaRyIssLp7YyTl/R/UWCh6FpBO8CtjMv9XCoI236gF7r3+BXcULmKLysoiuMEEaj5Lrpxgn0myUut5FScjJPASoe171jIGC3/E3tNeICQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBYjKOTHnKTUFXuGdIU0TJ2NyRGmf/Dyh0LKfZO1TIA=;
 b=Rhg1GJu0XITN6vX/YRUktRawxtPdHx4IgPM6t+EkrzywKDO8s9HpiDA4Xc2KhEWmgSqi5XIckQIOZzwwI/RmWFBJw5Gtoa78IfokB+mCpN7JvIdSKANBuS9g79XalbgmANkauDIq9J9oxK6LZ+P3m2MGznyZznbHpBCJSR9HoHI=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2735.namprd12.prod.outlook.com (2603:10b6:805:69::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.19; Thu, 30 Jul
 2020 16:38:09 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Thu, 30 Jul 2020
 16:38:09 +0000
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
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <2987e401-f021-a3a7-b4fa-c24ff6d0381b@amd.com>
Date:   Thu, 30 Jul 2020 11:38:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <3841a638-eb9e-fae6-a6b6-04fec0e64b50@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR06CA0044.namprd06.prod.outlook.com
 (2603:10b6:3:5d::30) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by DM5PR06CA0044.namprd06.prod.outlook.com (2603:10b6:3:5d::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18 via Frontend Transport; Thu, 30 Jul 2020 16:38:07 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc25bafc-8bf4-4b09-2fba-08d834a6f116
X-MS-TrafficTypeDiagnostic: SN6PR12MB2735:
X-Microsoft-Antispam-PRVS: <SN6PR12MB27352E6E245B340DA997D21495710@SN6PR12MB2735.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /YlHw2270mt1Bo5S4pUtz5CCA/Um4PrxuP1PNqq6UXQIInzyZpiDH9pbyVSkpTuBG3wxFyze2scgv1Nk5kKs0pncBZ+CFOXAJ77BG3Mtb/uVU4pNrOeJ+mVimMUyhVhET96xwyYnomfuqcPU4bLedpCn8AiZCYvh6uXDLMrwDwpfmElBtGleew95SipSg7cxMS9tSc+b/YxUpPmbkBBAqmzBunTC+0x3WmWVAja0yV7OrN3qOzpYiKtMUqqXbtXBWZh0cnKTRzX+5bjVhbnPLdE9/OAGGvktuMEAIf53JDXUmQEjGcJ2L9rhvv8Xoxpky4r8liQAXxqFRN84R6LUR2GeMLoex4DiYW67lTnD8ZF037NPvJ3c5v2dOFGBInOiiaEB91tdVrnAas9n9IAM1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(2906002)(53546011)(86362001)(31696002)(83380400001)(52116002)(6486002)(16526019)(8936002)(66476007)(66946007)(186003)(8676002)(4326008)(26005)(66556008)(316002)(36756003)(5660300002)(16576012)(54906003)(110136005)(478600001)(31686004)(956004)(44832011)(2616005)(7416002)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8BGlUn66AbONHWI76ASjZFIndKkPpUdNFC6tWRBzIGqi+qVK8Nh4ZJTk34RVZpQojaite0M3aIIjVOkSGrwcpS93H3ZPSEVmlXWblqwKNPBpKBNt6eX81LQfv5UL+Z1F9TX3RTy8ZTfPHrj5rIyx3WBID8IzIJx+4LumiZEKykeB+U8fJESuXrJomqMTugCmPeGGN3zY3L/5+HaHi6L/AXPAJZuRsW7oW8YCQSlcfj6/LcEng1fMbjG5iBfJrGsBesnqf7WIaHA9LxCNvKhI1VqI9W256uTpvEjbrvlLNC964eENihrR7/7wNnR82XS3YnZmd62XobYNVZGs7/dINRo3LoX6cbUU+udUIgPVuMhKs520mLMQJp9IkeRV/1t0PCRszYToXb/iaxV92GaMueRw59HXjz0mgor358WZETWmaEfDx3kfkLlQGRp3lHbtaq9O1VSEoPMMmHAfVS1Y6+obG8zn6q0KsGOPUHnR1E+mhXAW322EBmQpOws9YyXI90Ww6nGKdomOznraQvwF0vaPK/bDe9mJiC0hB9XbLWQ65nxs/nmVd+orxpYBl9yEJEQ7YKyUqP71hof1vHx5UV+MYGqHeEPClgQgv5DFFwMMYNOOe22vdW5RSzSO5AcYzumrIZHdXTmGoxLECZlRMw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc25bafc-8bf4-4b09-2fba-08d834a6f116
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 16:38:08.9052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: usQep8kA6GOUdZydRM2uHzeDoHsR3/buwUCa7YXf8KEjAykDHeCJELZ5vwhPsJwf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2735
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini <pbonzini@redhat.com>
> Sent: Wednesday, July 29, 2020 6:12 PM
> To: Jim Mattson <jmattson@google.com>; Moger, Babu
> <Babu.Moger@amd.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng Li
> <wanpengli@tencent.com>; Sean Christopherson
> <sean.j.christopherson@intel.com>; kvm list <kvm@vger.kernel.org>; Joerg
> Roedel <joro@8bytes.org>; the arch/x86 maintainers <x86@kernel.org>; LKML
> <linux-kernel@vger.kernel.org>; Ingo Molnar <mingo@redhat.com>; Borislav
> Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Thomas Gleixner
> <tglx@linutronix.de>
> Subject: Re: [PATCH v3 03/11] KVM: SVM: Change intercept_dr to generic
> intercepts
> 
> On 29/07/20 01:59, Jim Mattson wrote:
> >>         case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
> >> -               u32 bit = 1U << (exit_code - SVM_EXIT_READ_DR0);
> >> -               if (svm->nested.ctl.intercept_dr & bit)
> >> +               if (__is_intercept(&svm->nested.ctl.intercepts,
> >> + exit_code))
> > Can I assume that all of these __<function> calls will become
> > <function> calls when the grand unification is done? (Maybe I should
> > just look ahead.)
> >
> 
> The <function> calls are reserved for the active VMCB while these take a vector.
> Probably it would be nicer to call them vmcb_{set,clr,is}_intercept and make
> them take a struct vmcb_control_area*, but apart from that the concept is fine
> 
> Once we do the vmcb01/vmcb02/vmcb12 work, there will not be anymore
> &svm->nested.ctl (replaced by &svm->nested.vmcb12->ctl) and we will be able
> to change them to take a struct vmcb*.  Then is_intercept would for example be
> simply:
Yea. True. It makes the code even cleaner. Also we can avoid calling
recalc_intercepts every time we set or clear a bit inside the same
function(like init_vmcb).

Let me try to understand.

vmcb01 is &svm->vmcb->control;l
vmcb02 is &svm->nested.hsave->control
vmcb12 is  &svm->nested.ctl;

The functions set_intercept and clr_intercept calls get_host_vmcb to get
the vmcb address.

static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
{
        if (is_guest_mode(&svm->vcpu))
                return svm->nested.hsave;
        else
                return svm->vmcb;
}

I need to study little bit when is_guest_mode Is on or off.  Let me take a
look at.

Thanks

> 
> 	return vmcb_is_intercept(svm->vmcb, nr);
> 
> as expected.
> 
> Paolo

