Return-Path: <kvm+bounces-36276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86CB3A196A4
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:37:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF3021643A1
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57974215166;
	Wed, 22 Jan 2025 16:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y+RD8U/T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A562147F0
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 16:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737563815; cv=none; b=f9UEi0KFoE/g3ImWdZxDZ2jqr58sbHyJ29hE5k2zdE06oY67z214VwjvXE/auocyUz8KloEbBgm5FWUM6ZwsRjoAnny3eorQGFXb73vOFQgdoNmk9BWxyMRzO6Twyc96SGScaGyjnsx+k/iYwF9zgvJnRWUSt9LqE8WF8wkN9bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737563815; c=relaxed/simple;
	bh=bF1/M7+QtTc4d1f/oQT6ljNfgA3tp39zCQEonkjGnxg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J8AV3oDoIt+JmZtahcAUxQ4YYmgmtHEPP0o2WH3kxs0+51ExTe6/K5R9E5F5J2IjIpeWgLIYENBndfLa87xZfrVeyOPR5g1BjZ312rL5VHHy6tvwOZWQ9ZUsomR84SQUZrVhxj/llyV3I2HP7FsxOrO61dF0JUDfG9D3C5Ui2Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y+RD8U/T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737563812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6uwv6oUI+K7hg2DZpgsM9xyiOHyPUQuUW9kepSMaYec=;
	b=Y+RD8U/TwqlFceoN/gk2omvqde+1JnBVkGbV+eRuyHkG4tHJsWv5rvUz6M60IVcyYFoABl
	YJlqaonvUfHBOVWkxZdF/gmvuV/Wrct7OJrNWW7jcYXjD/OwPzYPJftJXAIAxzo1EptCtU
	B25gCqTFexJe5nRfxEquqhKqcrjH42o=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-zg0jW0PUPtmBft_8mvFAAw-1; Wed, 22 Jan 2025 11:36:49 -0500
X-MC-Unique: zg0jW0PUPtmBft_8mvFAAw-1
X-Mimecast-MFC-AGG-ID: zg0jW0PUPtmBft_8mvFAAw
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d884999693so233696d6.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 08:36:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737563809; x=1738168609;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6uwv6oUI+K7hg2DZpgsM9xyiOHyPUQuUW9kepSMaYec=;
        b=GCveXi8GzUe057pvK7uNpYMt416vawKvJO2/wjKt35D4XmfUrRgaEYNpfO5z1kATHj
         cjP3u6sItIkc0UVeSBf5jltXgpEJ83uMcT0prUiOyZpxhReUz99CaRQrYD1SRdiq0/ue
         1I9bP1uwg4V+ijEU02qe8Q1hnwlbbp2RppNqmhsf5GdKVYydFtXQz1D4iNxpQEGd4yju
         jarYYlELiXVrw5O4eAgYTeuCsOd4aeF8JJEdsrK9Upgw/FXpapA2gaQQH6iVyUKMNCDy
         Ec7DdVbJDURedbcSR8s2xhTm34KYo6cvmX5IlrbteLgwaTZhY8Hf7eZthlo8dU3VQRfn
         6DOA==
X-Gm-Message-State: AOJu0YyoElC7fN3t3LtLXu2NFdXCyDZHvfhLKFVreXEJixxmQcrBkONT
	nXOZNiqiAwTvVqAbvwA1bMrRw5atFyp2DL5Nqzk47R131Q11SOwW/0n2vctWHxJbTZ5O9SYIrN8
	LNl8bbA8sfKy0gbfIqGV5E4c9cjDodk6oZwOua1ZGXOywmZjKBg==
X-Gm-Gg: ASbGncu4nxMNyyZZAugYmH1z9g7FJkoEtSPp/Sm2ROBDneR2QZxX+ueINj19uz746+r
	04tOamh5Y6sShESo1zjHQWyk6YLGB8MdfVsOeKZPutVp+Qy2YZEg2bv43lOO2S2kCdCA9Z4ksxa
	TZSNAjU8ATN0AjXPj90upCMHjRIRMvGDrHgmFDRFnb6laXbz5HbyCWKCtx/kvIODQcroTasQZfR
	NjSN0YJWTE3t3s76xrBNMwFZflBbn7ivsyqmA/pNcy5f+mwxojnXfuLqwQTsvf3haJAxw==
X-Received: by 2002:a05:6214:408:b0:6d8:9b20:64e8 with SMTP id 6a1803df08f44-6e1b2172e5amr410864336d6.10.1737563808283;
        Wed, 22 Jan 2025 08:36:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKBIv547V44IDQlj8LC6hdSs+dY7ysIRth8GtUW1IbIBSmO1B2euImtO7Cy/s3dnqm6bNg6g==
X-Received: by 2002:a05:6214:408:b0:6d8:9b20:64e8 with SMTP id 6a1803df08f44-6e1b2172e5amr410864006d6.10.1737563807834;
        Wed, 22 Jan 2025 08:36:47 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e1afce4695sm62579726d6.104.2025.01.22.08.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 08:36:47 -0800 (PST)
Message-ID: <dd128607c0306d21e57994ffb964514728b92f29.camel@redhat.com>
Subject: Re: vmx_pmu_caps_test fails on Skylake based CPUS due to read only
 LBRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 22 Jan 2025 11:36:46 -0500
In-Reply-To: <Z5BDr2mm57F0vfax@google.com>
References: <c9d8269bff69f6359731d758e3b1135dedd7cc61.camel@redhat.com>
	 <Zx-z5sRKCXAXysqv@google.com>
	 <948408887cbe83cbcf05452a53d33fb5aaf79524.camel@redhat.com>
	 <Z5BDr2mm57F0vfax@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-01-21 at 17:02 -0800, Sean Christopherson wrote:
> On Sun, Nov 03, 2024, Maxim Levitsky wrote:
> > On Mon, 2024-10-28 at 08:55 -0700, Sean Christopherson wrote:
> > > On Fri, Oct 18, 2024, Maxim Levitsky wrote:
> > > > Our CI found another issue, this time with vmx_pmu_caps_test.
> > > > 
> > > > On 'Intel(R) Xeon(R) Gold 6328HL CPU' I see that all LBR msrs (from/to and
> > > > TOS), are always read only - even when LBR is disabled - once I disable the
> > > > feature in DEBUG_CTL, all LBR msrs reset to 0, and you can't change their
> > > > value manually.  Freeze LBRS on PMI seems not to affect this behavior.
> 
> ...
> 
> > When DEBUG_CTL.LBR=1, the LBRs do work, I see all the registers update,
> > although TOS does seem to be stuck at one value, but it does change
> > sometimes, and it's non zero.
> > 
> > The FROM/TO do show healthy amount of updates 
> > 
> > Note that I read all msrs using 'rdmsr' userspace tool.
> 
> I'm pretty sure debugging via 'rdmsr', i.e. /dev/msr, isn't going to work.  I
> assume perf is clobbering LBR MSRs on context switch, but I haven't tracked that
> down to confirm (the code I see on inspecition is gated on at least one perf
> event using LBRs).  My guess is that there's a software bug somewhere in the
> perf/KVM exchange.
> 
> I confirmed that using 'rdmsr' and 'wrmsr' "loses" values, but that hacking KVM
> to read/write all LBRs during initialization works with LBRs disabled.

Hi,

OK, this is a very good piece of the puzzle.

I didn't expect context switch to interfere with this because I thought that perf code won't touch LBRs if
they are not in use. 
rdmsr/wrmsr programs don't do much except doing the instruction in the kernel space.

Is it then possible that the the fact that LBRs were left enabled by BIOS is the
culprit of the problem?

This particular test never enables LBRs, not anything in the system does this,

I do some more code digging, lets see if I find anything odd.

Thanks for the info,
Best regards,
	Maxim Levitsky

> 
> ---
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f72835e85b6d..c68a5a79c668 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7907,6 +7907,8 @@ static __init u64 vmx_get_perf_capabilities(void)
>  {
>         u64 perf_cap = PMU_CAP_FW_WRITES;
>         u64 host_perf_cap = 0;
> +       u64 debugctl, val;
> +       int i;
>  
>         if (!enable_pmu)
>                 return 0;
> @@ -7954,6 +7956,39 @@ static __init u64 vmx_get_perf_capabilities(void)
>                 perf_cap &= ~PERF_CAP_PEBS_BASELINE;
>         }
>  
> +       if (!vmx_lbr_caps.nr) {
> +               pr_warn("Uh, what?  No LBRs...\n");
> +               goto out;
> +       }
> +
> +       rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> +       if (debugctl & DEBUGCTLMSR_LBR) {
> +               pr_warn("Huh, LBRs enabled at KVM load?  debugctl = %llx\n", debugctl);
> +               wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl & ~DEBUGCTLMSR_LBR);
> +       }
> +
> +       for (i = 0; i < vmx_lbr_caps.nr; i++) {
> +               wrmsrl(vmx_lbr_caps.from + i, 0xbeef0000 + i);
> +               wrmsrl(vmx_lbr_caps.to + i, 0xcafe0000 + i);
> +       }
> +
> +       for (i = 0; i < vmx_lbr_caps.nr; i++) {
> +               rdmsrl(vmx_lbr_caps.from + i, val);
> +               if (val != 0xbeef0000 + i)
> +                       pr_warn("MSR 0x%x Expected %x, got %llx\n",
> +                               vmx_lbr_caps.from + i, 0xbeef0000 + i, val);
> +               rdmsrl(vmx_lbr_caps.to + i, val);
> +               if (val != 0xcafe0000 + i)
> +                       pr_warn("MSR 0x%x Expected %x, got %llx\n",
> +                               vmx_lbr_caps.from + i, 0xcafe0000 + i, val);
> +       }
> +
> +       pr_warn("Done validating %u from/to LBRs\n", vmx_lbr_caps.nr);
> +
> +       if (debugctl & DEBUGCTLMSR_LBR)
> +               wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> +
> +out:
>         return perf_cap;
>  }
> --
> 
> And given that perf explicitly disables LBRs (see __intel_pmu_lbr_disable())
> before reading LBR MSRs (see intel_pmu_lbr_read()) when taking a snaphot, and
> AFAIK no one has complained, I would be very surprised if this is hardware doing
> something odd.
> 
> ---
> static noinline int
> __intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries,
> 				  unsigned int cnt, unsigned long flags)
> {
> 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
> 
> 	intel_pmu_lbr_read();
> 	cnt = min_t(unsigned int, cnt, x86_pmu.lbr_nr);
> 
> 	memcpy(entries, cpuc->lbr_entries, sizeof(struct perf_branch_entry) * cnt);
> 	intel_pmu_enable_all(0);
> 	local_irq_restore(flags);
> 	return cnt;
> }
> 
> static int
> intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int cnt)
> {
> 	unsigned long flags;
> 
> 	/* must not have branches... */
> 	local_irq_save(flags);
> 	__intel_pmu_disable_all(false); /* we don't care about BTS */
> 	__intel_pmu_lbr_disable();
> 	/*            ... until here */
> 	return __intel_pmu_snapshot_branch_stack(entries, cnt, flags);
> }
> ---
> 



