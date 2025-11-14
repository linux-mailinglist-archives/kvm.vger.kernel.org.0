Return-Path: <kvm+bounces-63244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E788C5EE64
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 19:41:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1149A34C544
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 18:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17DD333FE28;
	Fri, 14 Nov 2025 18:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSppAGM8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B25F2D23BC;
	Fri, 14 Nov 2025 18:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763144963; cv=none; b=DdBofmsyd/33kNfErS5za+F8Jx4rXqy3qP/Cj0w8b+Yz+lrq0MrL1JN0VHQM0C0L6scFxBLvUGW0xw0yxGRNTSev6VVucJBKJhvFKmB6HcqPwjiSKtacwqU4LkZJ8w0WChS3TE1MGHfl/uh8vmY7ROKQsrVtlvDoPTO5d1rVS7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763144963; c=relaxed/simple;
	bh=rP9BSNP+ovAO1fIgrv5d8V7K8tR1TOA9Quyxq1Q0E8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vC+WdhfZYuxWF+BLw14U9wsiSAmYWgCZMWmVViDoqPtrv5EV/xSU10w6Lz6vFN3iMNQhSd0yZEUaf1TkAyqRQsWT/9ZH/DnRDF8/WqLIiqiSH0UFFj2qqVRwhmKIg3Zz0QB0StYDTVQ5BlF1EYwzewuLfx6s9uCtQqxxDzSCg04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSppAGM8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5B8C4CEF1;
	Fri, 14 Nov 2025 18:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763144962;
	bh=rP9BSNP+ovAO1fIgrv5d8V7K8tR1TOA9Quyxq1Q0E8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JSppAGM8gMDPkTsw1+NjjHOQmZONqtmtUjhj425MTDR3UbxJG83iHFjYHloJMsMh0
	 WqJjRinIfyPLteJlGBVsJTBF5MEzhdq3BAifCbj6vAIYplJwfAZcQV8PdpmdHci/8K
	 vTdMDZ+isKIy6jkWH3veoTiJb9Mha+x4XY2S1K/OV4/lA4+1GCPzPo8BbggFzzM9UY
	 7ITh/kn43blguPNVyI5GS/TsViyayGzw7iKqqw0T7YEsoZWFUk78XYIpI8Ng0COKSK
	 JA0ET7MndxqNXGJafRwurD+0JExZz6a9XSCrW/FUkNHeWCITEc3FYd8w9DP375mZOG
	 XiSjNmicMS28Q==
Date: Fri, 14 Nov 2025 18:29:21 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Kelley <mhklinux@outlook.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH 7/9] KVM: SVM: Treat exit_code as an unsigned 64-bit
 value through all of KVM
Message-ID: <20251114182921.GB1725668@liuwe-devbox-debian-v2.local>
References: <20251113225621.1688428-1-seanjc@google.com>
 <20251113225621.1688428-8-seanjc@google.com>
 <SN6PR02MB4157AF057CC8539AD47F6D66D4CAA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <aRdJQQ7_j6RcHwjJ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRdJQQ7_j6RcHwjJ@google.com>

On Fri, Nov 14, 2025 at 07:22:41AM -0800, Sean Christopherson wrote:
> On Fri, Nov 14, 2025, Michael Kelley wrote:
> > From: Sean Christopherson <seanjc@google.com> Sent: Thursday, November 13, 2025 2:56 PM
> > > 
> > 
> > Adding Microsoft's Nuno Das Neves to the "To:" line since he
> > originated the work to keep the Linux headers such as hvgdk.h in
> > sync with the Windows counterparts from which they originate.
> 
> ...
> 
> > >  /* Exit code reserved for hypervisor/software use */
> > > -#define SVM_EXIT_SW				0xf0000000
> > > +#define SVM_EXIT_SW				0xf0000000ull
> > > 
> > > -#define SVM_EXIT_ERR           -1
> > > +#define SVM_EXIT_ERR           -1ull
> > > 
> > 
> > [snip]
> > 
> > > diff --git a/include/hyperv/hvgdk.h b/include/hyperv/hvgdk.h
> > > index dd6d4939ea29..56b695873a72 100644
> > > --- a/include/hyperv/hvgdk.h
> > > +++ b/include/hyperv/hvgdk.h
> > > @@ -281,7 +281,7 @@ struct hv_vmcb_enlightenments {
> > >  #define HV_VMCB_NESTED_ENLIGHTENMENTS		31
> > > 
> > >  /* Synthetic VM-Exit */
> > > -#define HV_SVM_EXITCODE_ENL			0xf0000000
> > > +#define HV_SVM_EXITCODE_ENL			0xf0000000u
> > 
> > Is there a reason for making this Hyper-V code just "u", while
> > making the SVM_VMGEXIT_* values "ull"? I don't think
> > "u" vs. "ull" shouldn't make any difference when assigning to a
> > u64, but the inconsistency piqued my interest ....
> 
> I hedged and went for a more "minimal" change because it isn't KVM code, and at
> the time because I thought the value isn't defined by the APM.  Though looking
> again at the APM, it does reserve that value for software
> 
>   F000_000h    Unused    Reserved for Host.
> 
> and I can't find anything in the TLFS.  Ah, my PDF copy is just stale, it's indeed
> defined as a synthetic exit.
> 
>   https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/nested-virtualization#synthetic-vm-exit
> 
> Anyways, I'm in favor of making HV_SVM_EXITCODE_ENL an ull, though part of me
> wonders if we should do:
> 
>   #define HV_SVM_EXITCODE_ENL	SVM_EXIT_SW

I know this is very tempting, but these headers are supposed to mirror
Microsoft's internal headers, so we would like to keep them
self-contained for ease of tracking.

It should be fine to add the "ull" suffix here. I briefly talked to a
hypervisor developer and they agreed.

Thanks,
Wei

