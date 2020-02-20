Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFEF1656E6
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 06:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgBTF2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 00:28:31 -0500
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:24152
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbgBTF2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 00:28:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QC2+RfX+buMuctQ1JyF1xNjP7a72MFmCkOSZ28j6WUiK5GqxRMyk7AszJVaYjt/xJVY1NaIeN9zXfgaZK3TFBr/Qhfwv3C/e1trNOhLIYn2ah9+wDPNq2EZJT1RAcDJnvpb3hNS9bmE3wfgzMjuIyYdGrI6xHWSnRQFJ4F6mq20v0A+fWCBNiV/ahpB0VVCm9axhhYVCE4WcRIvDIvIWaMylqZNeqGLzPyRhHlFYhLXrXH6cDA/hqyc/0jxbXsPWdo2mOIQlvIgg1bb1OkWDI/jaSYay3Ipzj/WrRfqkRCc5IdqJ90JHiqM23MPqm5YxS1bB6q6hJNcvj7AL3QG+zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTle8A0VvPamz1sfF3pVweMmHDxmSbvqckyJCx3kbyw=;
 b=Rk56QGY0qrU8fCAEnqTqTjFQJ4kkPDVcbSbCODjIhCUvZEq7a5/SijW7WH7SbqCjY46x22XOQi3MHG/Suf8VvKyCaCcuWBVPd6LBkSVv44beuWef4kA8f1ksJcMy46cnNlUIxLiCswT2Kh+QUpddfzIdYsdmIqlEALGsrU246zGxDry9bHgXBx7+KKONd2jH80IJ3KjbUBN0eerLbyGh3DRSSG1MBqIhzwwTm/ELd4++1pN+p848oiOrBg+Jk1TH7sC4cyM3nx/HZMY5ccRUgyvG2+0M20NHs0gx7Un8sJ5Lzj7uGFHotZpwCkukwqK+NC9vf/7LDtMXDzzIM7bwVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTle8A0VvPamz1sfF3pVweMmHDxmSbvqckyJCx3kbyw=;
 b=W4w1z4s5NJpngHapDS+FIdRinbv68Gw+Pf3Obzqi+2vr7bT4EDs/9qV1ZbEQBHCB+IPdIschbNNRYt5ZxXbkG6LbhhLaEbiStmvZzGLhwf1J8+J8Awh/oB5H9TIt4WhyTSHVrmUCKPHH0yPgj0x7api6F0sQ7eZbFNcaZ0IpBNg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (2603:10b6:802:28::33)
 by SN1SPR01MB0002.namprd12.prod.outlook.com (2603:10b6:802:23::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22; Thu, 20 Feb
 2020 05:28:27 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2729.033; Thu, 20 Feb 2020
 05:28:26 +0000
Date:   Thu, 20 Feb 2020 05:28:21 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, x86@kernel.org,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, brijesh.singh@amd.com
Subject: Re: [PATCH 08/12] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20200220052821.GA21598@ashkalra_ubuntu_server>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <fc5e111e0a4eda0e6ea1ee3923327384906aff36.1581555616.git.ashish.kalra@amd.com>
 <CABayD+fM-s0+j6JXN5qb0zce2Kqi6AC8+c+7qbqKr0NgC-QYiQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+fM-s0+j6JXN5qb0zce2Kqi6AC8+c+7qbqKr0NgC-QYiQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN2PR01CA0029.prod.exchangelabs.com (2603:10b6:804:2::39)
 To SN1PR12MB2528.namprd12.prod.outlook.com (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0029.prod.exchangelabs.com (2603:10b6:804:2::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend Transport; Thu, 20 Feb 2020 05:28:26 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b9b22cca-766d-4513-11bb-08d7b5c5b631
X-MS-TrafficTypeDiagnostic: SN1SPR01MB0002:|SN1SPR01MB0002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1SPR01MB0002EED6484C4632B1A91A598E130@SN1SPR01MB0002.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 031996B7EF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(199004)(189003)(26005)(1076003)(53546011)(9686003)(54906003)(186003)(16526019)(44832011)(316002)(5660300002)(55016002)(81156014)(6666004)(66946007)(52116002)(6496006)(66556008)(7416002)(66476007)(81166006)(2906002)(478600001)(86362001)(33716001)(8936002)(33656002)(956004)(4326008)(8676002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1SPR01MB0002;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vw72KdY6KlyTv15Xi3/fOHt77Vyk5+qE/huBSQaRlq2bi6sWFatW6UgGpavaQjaXLZ9OuMmqXzwCaCdb5m1TBJuPneE4qTfyK/QzQLBoyw/tuONReie5cRuemzWVC+OA8N5gLU7Wiv18duwr74sT51949mOCTfraK0YrJ9+JcHgZ3SgtpSn4sgY2MWSzzsfjhhvVl12iS71uRyKvVs8lNMgBMvuTf77vfLOWUtinSbea1/XMe1448FQ3XEpYbgsMcX4Raz9dYLGSctmYpnX8Moh9zigOLaCr1zN6HnEW4Q57Fb24OnE63nA57Q/DBM99HljBsnz5xBl0v8JUC4cKKQxjYq2f7xW+fRc3en8bRJhRrD4rpwlI4mtH1A/8shoWc77dqeC9CibDOSpJWwZwJohFTp3x3Vk9qdRRUnQQ6E3Oh1vYSUs2Fj85bc8D8WTN
X-MS-Exchange-AntiSpam-MessageData: Q3AweIfFNnZfcGCOp/7290LMautAlwjiyyXFELfzXCGtSWzw99YtWVqfascCpNH2xzDqCakCYKZKXqMABtxJDDsHb04b32PJSNBjlJSNrI38tRhg4/2Zth3EiKmMSBaGdRMBoyQFiIP62R1bbv3ItQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b22cca-766d-4513-11bb-08d7b5c5b631
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2020 05:28:26.8277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWX8q9LE5Dp0/rRkubOTdkbyJzME7VALjw8sJf5c5pomLV2dJx/L/ddJW46Mi4laOyu+RTxGajftDQoCe41XNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1SPR01MB0002
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 19, 2020 at 06:39:39PM -0800, Steve Rutherford wrote:
> On Wed, Feb 12, 2020 at 5:17 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> >  static void vmx_cleanup_l1d_flush(void)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index fbabb2f06273..298627fa3d39 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7547,6 +7547,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >                 kvm_sched_yield(vcpu->kvm, a0);
> >                 ret = 0;
> >                 break;
> > +       case KVM_HC_PAGE_ENC_STATUS:
> > +               ret = -KVM_ENOSYS;
> > +               if (kvm_x86_ops->page_enc_status_hc)
> > +                       ret = kvm_x86_ops->page_enc_status_hc(vcpu->kvm,
> > +                                       a0, a1, a2);
> > +               break;
> >         default:
> >                 ret = -KVM_ENOSYS;
> >                 break;
> Add a cap to kvm_vm_ioctl_enable_cap so that the vmm can configure
> whether or not this hypercall is offered. Moving to an enable cap
> would also allow the vmm to pass down the expected size of the c-bit
> tracking buffer, so that you don't need to handle dynamic resizing in
> response to guest hypercall, otherwise KVM will sporadically start
> copying around large buffers when working with large VMs.
> 

Yes, that is something we have been looking at adding.

But, how will VMM know the expected size of the c-bit tracking buffer ?

The guest kernel and firmware make the hypercall to mark page encryption
status and depending on the GPA range being marked, the kernel's page
encryption bitmap needs to be dynamically resized as response to the guest
hypercall.

> Stepping back a bit, I'm a little surprised by the fact that you don't
> treat the c-bit buffers the same way as the dirty tracking buffers and
> put them alongside the memslots. That's probably more effort, and the
> strategy of using one large buffer should work fine (assuming you
> don't need to support non-zero as_ids).

Thanks,
Ashish
