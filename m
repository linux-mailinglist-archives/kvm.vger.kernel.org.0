Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD842EEA72
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 01:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbhAHAdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 19:33:15 -0500
Received: from mail-dm6nam11on2075.outbound.protection.outlook.com ([40.107.223.75]:19297
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729569AbhAHAdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 19:33:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVd+YNgyGGu+TNqbnkfnrBect6BUboeEw5/jKL8Riw4fRR269eDdJ6TGNcr4fSmzrideuZRt0cuJBswNc+7ep1ag8GPiNMXBwv5Ld1VLgJDjrx5iZN3ImzMsHrzegeFjFrOyx+UFHWZ3yWjk7JXE5V+Ls4jCBOWA8dQvTjCh8lDhFxtMfT+F+x8mr0pYX7iVYwtkrRvE0JKf5fHdDnHMVNIxbmodUox0IRdDWi4X8pN9mc9gPM29IUjIBRtcUX0jy2azPu+Lnb4C86//uwiv4yOIscD6wiz3ph/kDIPu2/oZBnWZO5b4D3UcsgWr91LN5VZ8V3xubdPCNCZ02Tx54w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpYVhPcqQy1RWh0Yczdx51udwvbXVlewbquSOZUq62s=;
 b=HB/002ieWOWfyDkDO8xx+h8buwJ+l5o/tzl6MEGbkva9JCxUV1XLYwDYYSpHiQINRqam9Y+U0xIQH5dOnK0r8KTdb5ebcBVLXVMQucUBou9zol6EkA1zPL1mTg7bJR8QI6UDOWJKk+OrqpDdLBkjc+52IOUo4J8vsV5za7IutHLwCHF+a55sc5XYCPi5J1Yz/Qcwdoa69TbhDXrToIM874o9dWcDTbBPXhmDgn4fDYEm+QcEail5wmIDqwa0J4G8ELDjT5UMLY2Uv+1T6CTcaCaVc9Gq7VGdowkRP9icdUCfktfzKu/KRaV0BIxVw0N/a8bGgJDm60ZgjajDS7MRsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpYVhPcqQy1RWh0Yczdx51udwvbXVlewbquSOZUq62s=;
 b=aCL3e9NV9j5Vzbpv4/1YUCPjWKIfB36P8kPJ1sdQEFe2zqJeRWykSlVAqirLcosL2L/6yaqS/ThhC240kl6ZpPV3okIABEWuA5lK/hSGD+HFTOMgAWt7JAUPVqH9PehT6uTv0nupIuDiZ9vWMlyz8hLc6o1eBpV9OpcHNz6xgCY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13)
 by BYAPR12MB3288.namprd12.prod.outlook.com (2603:10b6:a03:130::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Fri, 8 Jan
 2021 00:32:21 +0000
Received: from BY5PR12MB4131.namprd12.prod.outlook.com
 ([fe80::2432:5fa6:a1f:61f0]) by BY5PR12MB4131.namprd12.prod.outlook.com
 ([fe80::2432:5fa6:a1f:61f0%5]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 00:32:21 +0000
Date:   Thu, 7 Jan 2021 18:32:11 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 1/3] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
Message-ID: <20210108003211.qsarrzb3uwjq4wu5@amd.com>
References: <20210105143749.557054-1-michael.roth@amd.com>
 <20210105143749.557054-2-michael.roth@amd.com>
 <X/Sfw15OWarseivB@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/Sfw15OWarseivB@google.com>
X-Originating-IP: [165.204.10.250]
X-ClientProxiedBy: MN2PR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::12) To BY5PR12MB4131.namprd12.prod.outlook.com
 (2603:10b6:a03:212::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.10.250) by MN2PR07CA0002.namprd07.prod.outlook.com (2603:10b6:208:1a0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 00:32:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60f4d17f-c0d5-48c1-7a95-08d8b36cdcda
X-MS-TrafficTypeDiagnostic: BYAPR12MB3288:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB3288B16F7B5B5729367F372195AE0@BYAPR12MB3288.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AzEdj/yN1EfwuBulKQl2bNCDjvIYe/yu8EXd/VSAZ9MCQ6AwgxBQccbpP+Rwa8ko6VSeSZtgXo63zn4uj8gT7jx4VrpDVFJ110UrkSldEYuToSVEQx5qlZdfhI+zbpyspjiECV1SRXPCV4k1X2oExQ9C7Dz9c7DGkaX499pVv+KaOWMZHS+LMlTnMZiCMNt8WfUw9/cruJXwr8Ia8SNZNSOwU2S/nrVoECY/M5ZK1/Sak8zWF425frIWc96HFHkbQeot9Qw+gVykrdgq7pO/HFc8wgtcLOz4eHX3XhNxbOxOJOMhm3zIZ6kiz4EBzQOEW/wmpO+jPs6AgydvNwo6GBa+17DPHSa6d1YNFqcDMqPXkFd8dyRGhooERV3Oiln75Ob2EXiAFZtS6JVVwdG3Ldv+GFlDydJgt3L/mXDcde1MR9VWaSpO9Wt787ZYywr5YoY9V8cRTTmn08KWc1bYpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(6486002)(2616005)(7416002)(6916009)(52116002)(83380400001)(45080400002)(66946007)(66476007)(6496006)(8676002)(6666004)(86362001)(956004)(8936002)(54906003)(66556008)(1076003)(478600001)(966005)(2906002)(5660300002)(44832011)(26005)(316002)(186003)(16526019)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jR3LUg/co833xZsIuBS3y0rG1iKTRUtDEE88fEiK82HsAwUvSFpzvovXPfmE?=
 =?us-ascii?Q?eLPU67hadbgbuzljqJaKpuBON+DK3tDq0WjfgPXeSeZyx6Za2QIKUfkJHhlc?=
 =?us-ascii?Q?F33S9xblA2RwXWUV7z4NpBFvXU8old84kSdVXpVDRtyLCSjE/wLfl/fvoHMC?=
 =?us-ascii?Q?3mEczKBUWJMrwafJC26OnpmeWAkKRmLQ7nOcLPyOhaC8NutdXCj6oDl0ZzDS?=
 =?us-ascii?Q?7YLxVfALb2lEhJ75s0ynOTiok0UfL7qmMQiLDMYQ49BnBkp4si5R02q4dEQ6?=
 =?us-ascii?Q?Y0Bdcam5Xe6e5rSrEDhZxOg/g5KV9V9y6T+U/w0zAgMKAX4dwy+alZqP59/P?=
 =?us-ascii?Q?czGqT4kwRTSL+GyUyiLMrvptxtGhc9eHFWxb3r6YdNod8BsX27t/g2K09sw1?=
 =?us-ascii?Q?HERrZdGYe5rE2LacXCaAAu08VlSDoaIibwNolK3Hrr0ZOXneIPBvHFRdUvaZ?=
 =?us-ascii?Q?7n/PMd2QY+Pn/hqb2pRAT+coTh5/jHqVlI0MWkugwYmoASb0r9m2QqDncSl+?=
 =?us-ascii?Q?HeDqSuZP+MFL4JxqWkvsybNbvFGrsAQ6nddEopjbdJCduNx4nFPqt3SiIrdZ?=
 =?us-ascii?Q?6zFiahjj0PHVwbvD0GSDxAAcm2QsuLAuO4VErtd38bVMKeM+Ky9yTMPZDFT9?=
 =?us-ascii?Q?0vL7Ziu3XMaRvSCTHLAW1DBHfCdVCqXI1obELYPuZ6pkHu0WQbEbGk25WjYV?=
 =?us-ascii?Q?aO/u10cXAA9dFW74cVepBr1U2t8HKUEkPydu9/TJ3VRvdLFourD+NSxaqMSb?=
 =?us-ascii?Q?ptVeUKGGzFrkKFHAeUUFTHP3Wa1CrYJbXyfZzFwHbm85AgNmTcwYTZ3GcUEq?=
 =?us-ascii?Q?U8mwehvsWwRzxCks/aRwujxGyDJ+3bIoD5I5wYcE9qwnN2lof2XsIvixnjeT?=
 =?us-ascii?Q?4f9NnCNYW9qj7N6wIh8YkAO+uNBBptkh5NLghaktposj0Wse5y7LIft2C7I8?=
 =?us-ascii?Q?bC9GJHv84AzLvGeqqIqkn9NwYUC+mOT6jgwtF/YLnBpb4MHpconRm6Dz9NcQ?=
 =?us-ascii?Q?ey+z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 00:32:21.5164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f4d17f-c0d5-48c1-7a95-08d8b36cdcda
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rdRb8vErBNjSrFPjsAjQdnoHXD2oCiBkcmuptf23tRZX3HrctAXhwyntc9L40MjPa753PN0/4gbK3kpbe9mUQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3288
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 05, 2021 at 09:20:03AM -0800, Sean Christopherson wrote:
> On Tue, Jan 05, 2021, Michael Roth wrote:
> > @@ -3703,16 +3688,9 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> >  	if (sev_es_guest(svm->vcpu.kvm)) {
> >  		__svm_sev_es_vcpu_run(svm->vmcb_pa);
> >  	} else {
> > -		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
> > -
> > -#ifdef CONFIG_X86_64
> > -		native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
> > -#else
> > -		loadsegment(fs, svm->host.fs);
> > -#ifndef CONFIG_X86_32_LAZY_GS
> > -		loadsegment(gs, svm->host.gs);
> > -#endif
> > -#endif
> > +		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs,
> > +			       page_to_phys(per_cpu(svm_data,
> > +						    vcpu->cpu)->save_area));
> 
> Does this need to use __sme_page_pa()?

Oddly enough the current patch seems to work even with SME enabled. Not
sure why though since as Tom pointed out we do use it elsewhere with the
SME bit set. But should be setting it either way.

> 
> >  	}
> >  
> >  	/*
> 
> ...
> 
> > diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> > index 6feb8c08f45a..89f4e8e7bf0e 100644
> > --- a/arch/x86/kvm/svm/vmenter.S
> > +++ b/arch/x86/kvm/svm/vmenter.S
> > @@ -33,6 +33,7 @@
> >   * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
> >   * @vmcb_pa:	unsigned long
> >   * @regs:	unsigned long * (to guest registers)
> > + * @hostsa_pa:	unsigned long
> >   */
> >  SYM_FUNC_START(__svm_vcpu_run)
> >  	push %_ASM_BP
> > @@ -47,6 +48,9 @@ SYM_FUNC_START(__svm_vcpu_run)
> >  #endif
> >  	push %_ASM_BX
> >  
> > +	/* Save @hostsa_pa */
> > +	push %_ASM_ARG3
> > +
> >  	/* Save @regs. */
> >  	push %_ASM_ARG2
> >  
> > @@ -154,6 +158,12 @@ SYM_FUNC_START(__svm_vcpu_run)
> >  	xor %r15d, %r15d
> >  #endif
> >  
> > +	/* "POP" @hostsa_pa to RAX. */
> > +	pop %_ASM_AX
> > +
> > +	/* Restore host user state and FS/GS base */
> > +	vmload %_ASM_AX
> 
> This VMLOAD needs the "handle fault on reboot" goo.  Seeing the code, I think

Ah, yes, I overlooked that with the rework.

> I'd prefer to handle this in C code, especially if Paolo takes the svm_ops.h
> patch[*].  Actually, I think with that patch it'd make sense to move the
> existing VMSAVE+VMLOAD for the guest into svm.c, too.  And completely unrelated,
> the fault handling in svm/vmenter.S can be cleaned up a smidge to eliminate the
> JMPs.
> 
> Paolo, what do you think about me folding these patches into my series to do the
> above cleanups?  And maybe sending a pull request for the end result?  (I'd also
> like to add on a patch to use the user return MSR mechanism for MSR_TSC_AUX).

No complaints on my end at least :) But happy to send a v4 with SME bit fix
and reboot handling if you think that's worthwhile (and other suggested changes
as well, but not sure exactly what you have in mind there). Can also help with
any testing of course.

Thanks,

Mike

> 
> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20201231002702.2223707-8-seanjc%40google.com&amp;data=04%7C01%7Cmichael.roth%40amd.com%7C78b8a6cc557c4b7cda2e08d8b19e28e4%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637454640153346851%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=r2dX27RJ569gloShKvha%2BUtcf0%2B5vNc%2Fn6E1dREJDm0%3D&amp;reserved=0
> 
> > +
> >  	pop %_ASM_BX
> >  
> >  #ifdef CONFIG_X86_64
> > -- 
> > 2.25.1
> > 
