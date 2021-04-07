Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDFD356E0A
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352727AbhDGOBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:01:21 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:9952
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242411AbhDGOBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 10:01:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pyt2eELc2RwGNTtRKTRzPL/Y4ZvSmetZXWxQuo330caQHHr/roH1643SirROpXxkHkgyH/8uV+iV9/+wlHqj6imeJMDWnrwp1GY3ERr462Ryc34Jb7TMXVX4GCGL1p2zou+SCjevTkMJdUaFhbywhGgElOlkBQdHjg5tyRByvXiMqxXlMg/vg9Dnk/Sg6ulk6Noti6P0LwlZvLieishXRcjq5fMobCMVr7KhZ4gSDJ4JBbRqW0Qj32rhejAQbfD4S+ILO9GkxqIXUksJHWmuV8pfearxG9XRrv7m07ZvpN4ZOevL4orW77DbT0tEUna/DXsKVpJ143/LXsbPQgWIAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdKB3hDX0lFpidW+dtxWkYpgenVqNJY7lNs/DFDhJYQ=;
 b=UTPY+lTmQbYpj/959+n0LP8w0ZSFjGNszvMjC89R9wlISqG+V+5eSiMduy51RkvXa6qmUc1KUclQ+JpTuVEPPpQ7cc1aO9CrmV+TidA61N8wYHAaPlsdKHpmV97fQTrS55fozKfUExb+QzdV6LomPEhgfmX75QWePT755wuwR/CjZLGLbysmxsvpFA+rXB85Lj6JequvNlNKTvQWiVe236H0Ka+2sVhRBJNqiuxKwt4O2lKftORwpaZaJAXFjkSuT1MpjxLicszt7yF+5P4fRR5TR0IsTT/GF2TQBdAS3XyI1eEKm0M+YncZX1F3ALc/6xEBU6ifogUnv4wplY3eKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdKB3hDX0lFpidW+dtxWkYpgenVqNJY7lNs/DFDhJYQ=;
 b=ASPayxiXoBkF3TdduJyS8zA8E72jV8mLT2mYkLZ2TWRV8o5UY84Gx2uRMqmC+8kspMmKMWR1pZRPjtX7XnwymhhGNJ7p6c2xO5mGwOnY0b5pPGhpxNmJ7lwEnc/BZnFQMI6dHM7gTgzhYHu64atSLXmeeqoxhkfCULgKZcWhrUo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Wed, 7 Apr
 2021 14:01:08 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 14:01:08 +0000
Date:   Wed, 7 Apr 2021 14:01:01 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com, will@kernel.org,
        maz@kernel.org, qperret@google.com
Subject: Re: [PATCH v11 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20210407140044.GA25499@ashkalra_ubuntu_server>
References: <cover.1617302792.git.ashish.kalra@amd.com>
 <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
 <YGyCxGsC2+GAtJxy@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGyCxGsC2+GAtJxy@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0187.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA0PR11CA0187.namprd11.prod.outlook.com (2603:10b6:806:1bc::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 14:01:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5812c60-efa2-42ce-2e62-08d8f9cd971d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB443141CFA6C5024E47BBC0418E759@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +gkp8OzoCpq7GUUycnPm0J38ksRLdVesXTtvgiFi+wnJuVJWPsyKh24+nXA65HLx/FkHQK0teKCQULDlj4RKn8r9eNhXSrC/0Obg7vNukPFQS4HHlFqP8eU36GFO1vc4pJ7tT+0PAMUtXM2Qxidqbe+5YP/qrH8UjgON00Ur4CQ7aSX1rNgL0bZaIEnL2ITL8O9tMZt+vuwRA7Db/TjOH486pIAV3FBywJ5Sw13PsZ8WoJgObxrVv1cFivWRDWbeNBOU4KbP7qTktEHCGxTe8LKnreyLNOeQ+H9FfQcUeWIbQIDv8kCwMVehoxMCt8O9WWqNWnl3nyLrGSUybQ3bpGEf7Kd1xYelbdE1EKVY52mI8lNGfJlq1fSIOpHWt4YD07/Ly3eM42tSZ6J6xpmPCOGUJ4eAylwrvDWtZ4Szosm1UMVOoiYKVBV5SwdZgn46qxs6nooO9Baq8SaZdkcCKpxrZhvcG72jToTPD8JXGDh7Yf1kY4rdIo9s2DtFV2eTUnC++oT/sQjfClsrtsiYiSA+HN14LlgwwsAedYyEHv/QyHnUXw9rhZUOhyKAvtVRR7+DyMh/KrH2/aR3RBprV8Y5zW8QZHKbpOhEltuVaRwy0olgS6O0JnTXOnVjStGzsOzf+3l94ztNXMPGsd4iGs/sjN0L8HbH7fg/K7GXA/oHuLkoKc4Oo+CtMx1XCZtn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(6496006)(9686003)(2906002)(16526019)(83380400001)(1076003)(8936002)(55016002)(7416002)(6916009)(44832011)(52116002)(26005)(33656002)(6666004)(8676002)(186003)(316002)(38100700001)(38350700001)(478600001)(5660300002)(66946007)(66556008)(66476007)(33716001)(956004)(86362001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cAnwue/BnjCHM+JyovhGn1bxgqZN/lpeR3dojjc283LuHEKCp3heSUCvn1cG?=
 =?us-ascii?Q?Fbnlnp+roSn94JdVtbFlGK8t8rhxb3f62RGbR+C0Qg87zWi746IMLj4I7c3r?=
 =?us-ascii?Q?3ukYG6NE+4xEelA2pDMpYTTNwU0HUipphO60kw3Wu2o8qg1JhfZjSfZEg1pi?=
 =?us-ascii?Q?USq0pM7sbxTuV2Jn/mF2h6YZjivsjHfBmW2O1eb9pw2k/CYt8g9jXkMS48OM?=
 =?us-ascii?Q?A6dMg19TETlBzHCdHwK6y0ggfw/YetBJNao7MyLQbcYws6zjUP7naN7Z+4qF?=
 =?us-ascii?Q?tZRaN6oq4UF1OSt6QAWYiM4hMDxQiZtRUSdV9ynMocJZpgYZcfXL1lj3FDBZ?=
 =?us-ascii?Q?aTkuKxHzyWKYZQQ8BTHyUqqS1A2m9Sj/djhzuo8jd9wwUe/s3xhPOlboDCIs?=
 =?us-ascii?Q?bxpLqxvIE3OLHfd+qBm6x08WRcyIHPEZxDUnRAKw3Kz4ETlX3nY/tyUU37DM?=
 =?us-ascii?Q?fXPQKr1hq3a5qMb5KzUkpuT+LgXIpfMlXBwdPzwzh3vOYVKiu8+5jT0H27Bt?=
 =?us-ascii?Q?3DfnDx9NTkqKqcZaorFxqndC1COsfV9KoaDn6Q48vOSrRfYBqPb5Yuds8TKz?=
 =?us-ascii?Q?fgLlHcIqYeY9yaeahk9CavK7qod9CY7s+6dTuf/oQAMiSJzoRvpFHGWA7RpG?=
 =?us-ascii?Q?5bdelT9ed0ZXJCY/z+13Zb0i3wRrFKOJV9fEyUf24j2MRFCb3Z/aS2sHuNBr?=
 =?us-ascii?Q?CuMleMmXBq6YVXTX86vPa1KlJMt2pUPqlZKTcO8EpPU6HXK16Hx8usrvEcDc?=
 =?us-ascii?Q?deL4nqO5TksALhCbMFXAcKxKB43/4A0ec7f40K8XbUlaZSRe5T+1+yt8vzSX?=
 =?us-ascii?Q?rg6Hz+redVuA8F1Hg3CEUvWe/W+tr8ZSNK9dHapp6ysc8DAgnH8TtLkf/knv?=
 =?us-ascii?Q?upvwRuW3jRab2MMxj6cO9w3/zJ1kR4ng+u3LrHPrKl8T0nPOnbcDxCgqth2p?=
 =?us-ascii?Q?AsuGiQ5mUcmxblZyYXp7sQ4iiXcVtjmN0cvOB+0Svg8MAgml8TtGaVbU5Wl3?=
 =?us-ascii?Q?p+q9/qWsta53bSQ3q6ZiEimgkXehgAE6r6ZcKmdG2TFDWN/JIGDA6+BMHZE0?=
 =?us-ascii?Q?3qxURbG08G4fPcn9vIFd56EAItea05CHK2noJJE99MIS/k5UKi6ef0CxX7Vy?=
 =?us-ascii?Q?CqquBsraDvlvA8eIm0jtEh3VNHlgBqrKCYY5iMezBzShbIY+Gy4gn01h8GEG?=
 =?us-ascii?Q?Q7bo2xGv7WszqTm0GuRvdUQlKQl3TsShUAc2xEC2fLeYd59Y+N/8zAkGobnX?=
 =?us-ascii?Q?j27d57VlR2O5ZkMvmUuoZ57XVC37u4WT0DtAYudVnQ8OcgnMxvA5Bqpqnvi7?=
 =?us-ascii?Q?BDMDRrkYIR9UhJzmHKVDEWxP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5812c60-efa2-42ce-2e62-08d8f9cd971d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 14:01:08.2932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PUHI4mkAvnz2I4t0ZPPUYrnxkqXb5PnrwwySrln3GFRKTSQOEgnUCWL/qCArov4nMSjIgtHNsOgV/E1g05ccaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 03:48:20PM +0000, Sean Christopherson wrote:
> On Mon, Apr 05, 2021, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> 
> ...
> 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 3768819693e5..78284ebbbee7 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1352,6 +1352,8 @@ struct kvm_x86_ops {
> >  	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> >  
> >  	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> > +	int (*page_enc_status_hc)(struct kvm_vcpu *vcpu, unsigned long gpa,
> > +				  unsigned long sz, unsigned long mode);
> >  };
> >  
> >  struct kvm_x86_nested_ops {
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index c9795a22e502..fb3a315e5827 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1544,6 +1544,67 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >  	return ret;
> >  }
> >  
> > +static int sev_complete_userspace_page_enc_status_hc(struct kvm_vcpu *vcpu)
> > +{
> > +	vcpu->run->exit_reason = 0;
> > +	kvm_rax_write(vcpu, vcpu->run->dma_sharing.ret);
> > +	++vcpu->stat.hypercalls;
> > +	return kvm_skip_emulated_instruction(vcpu);
> > +}
> > +
> > +int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
> > +			   unsigned long npages, unsigned long enc)
> > +{
> > +	kvm_pfn_t pfn_start, pfn_end;
> > +	struct kvm *kvm = vcpu->kvm;
> > +	gfn_t gfn_start, gfn_end;
> > +
> > +	if (!sev_guest(kvm))
> > +		return -EINVAL;
> > +
> > +	if (!npages)
> > +		return 0;
> 
> Parth of me thinks passing a zero size should be an error not a nop.  Either way
> works, just feels a bit weird to allow this to be a nop.
> 
> > +
> > +	gfn_start = gpa_to_gfn(gpa);
> 
> This should check that @gpa is aligned.
> 
> > +	gfn_end = gfn_start + npages;
> > +
> > +	/* out of bound access error check */
> > +	if (gfn_end <= gfn_start)
> > +		return -EINVAL;
> > +
> > +	/* lets make sure that gpa exist in our memslot */
> > +	pfn_start = gfn_to_pfn(kvm, gfn_start);
> > +	pfn_end = gfn_to_pfn(kvm, gfn_end);
> > +
> > +	if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
> > +		/*
> > +		 * Allow guest MMIO range(s) to be added
> > +		 * to the shared pages list.
> > +		 */
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> > +		/*
> > +		 * Allow guest MMIO range(s) to be added
> > +		 * to the shared pages list.
> > +		 */
> > +		return -EINVAL;
> > +	}
> 
> I don't think KVM should do any checks beyond gfn_end <= gfn_start.  Just punt
> to userspace and give userspace full say over what is/isn't legal.
> 
> > +
> > +	if (enc)
> > +		vcpu->run->exit_reason = KVM_EXIT_DMA_UNSHARE;
> > +	else
> > +		vcpu->run->exit_reason = KVM_EXIT_DMA_SHARE;
> 
> Use a single exit and pass "enc" via kvm_run.  I also strongly dislike "DMA",
> there's no guarantee the guest is sharing memory for DMA.
> 
> I think we can usurp KVM_EXIT_HYPERCALL for this?  E.g.
> 
> 	vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
> 	vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
> 	vcpu->run->hypercall.args[0]  = gfn_start << PAGE_SHIFT;
> 	vcpu->run->hypercall.args[1]  = npages * PAGE_SIZE;
> 	vcpu->run->hypercall.args[2]  = enc;
> 	vcpu->run->hypercall.longmode = is_64_bit_mode(vcpu);
> 
> > +
> > +	vcpu->run->dma_sharing.addr = gfn_start;
> 
> Addresses and pfns are not the same thing.  If you're passing the size in bytes,
> then it's probably best to pass the gpa, not the gfn.  Same for the params from
> the guest, they should be in the same "domain".
> 
> > +	vcpu->run->dma_sharing.len = npages * PAGE_SIZE;
> > +	vcpu->arch.complete_userspace_io =
> > +		sev_complete_userspace_page_enc_status_hc;
> 
> I vote to drop the "userspace" part, it's already quite verbose.
> 
> 	vcpu->arch.complete_userspace_io = sev_complete_page_enc_status_hc;
> 
> > +
> > +	return 0;
> > +}
> > +
> 
> ..
> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f7d12fca397b..ef5c77d59651 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8273,6 +8273,18 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  		kvm_sched_yield(vcpu->kvm, a0);
> >  		ret = 0;
> >  		break;
> > +	case KVM_HC_PAGE_ENC_STATUS: {
> > +		int r;
> > +
> > +		ret = -KVM_ENOSYS;
> > +		if (kvm_x86_ops.page_enc_status_hc) {
> > +			r = kvm_x86_ops.page_enc_status_hc(vcpu, a0, a1, a2);
> 
> Use static_call().
> 
> > +			if (r >= 0)
> > +				return r;
> > +			ret = r;
> > +		}
> 
> Hmm, an alternative to adding a kvm_x86_ops hook would be to tag the VM as
> supporting/allowing the hypercall.  That would clean up this code, ensure VMX
> and SVM don't end up creating a different userspace ABI, and make it easier to
> reuse the hypercall in the future (I'm still hopeful :-) ).  E.g.
> 
> 	case KVM_HC_PAGE_ENC_STATUS: {
> 		u64 gpa = a0, nr_bytes = a1;
> 
> 		if (!vcpu->kvm->arch.page_enc_hc_enable)
> 			break;
> 
> 		if (!PAGE_ALIGNED(gpa) || !PAGE_ALIGNED(nr_bytes) ||
> 		    !nr_bytes || gpa + nr_bytes <= gpa)) {
> 			ret = -EINVAL;
> 			break;
> 		}
> 
> 	        vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL; 
>         	vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS; 
> 	        vcpu->run->hypercall.args[0]  = gpa;
>         	vcpu->run->hypercall.args[1]  = nr_bytes;
> 	        vcpu->run->hypercall.args[2]  = enc;                                    
>         	vcpu->run->hypercall.longmode = op_64_bit;
> 		vcpu->arch.complete_userspace_io = complete_page_enc_hc;
> 		return 0;
> 	}

I really like the above approach, but one thing that concerns me above
is the addition of architecture specific code, for example, the page
encryption stuff as part of the generic x86 KVM code ? 

Especially bits like the page enc hypercall completion callback and
testing the architecture specific page encryption hypercall enabled
flag, probably the hypercall completion callback can be named
something as complete_userspace_hypercall(), as anyway what it does
inside the callback is all very generic.

The above naming may also go well with KVM_EXIT_HYPERCALL exitcode 
interface.

Thanks,
Ashish

> 
> 
> > +		break;
> > +	}
> >  	default:
> >  		ret = -KVM_ENOSYS;
> >  		break;
