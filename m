Return-Path: <kvm+bounces-59941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C980CBD64E4
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 22:59:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEA3F18A7DCB
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 21:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E2E92F1FD5;
	Mon, 13 Oct 2025 20:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BDVoypSt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2533D2F0C48
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 20:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760389164; cv=none; b=egZeMwzdZmmK49izb/vJ8xf+ZJzGqsU43UhKdyG2DhN50Es+72oMdSeAIvBjZ94sTsscavreS4lKchfH8rStwdEmOTR4Me6QBqzpgS03W7BaEi6WTWO9bQ002PaoaQj2V1T3V2PNwrhQ6GfxyWP8smStZv5KS7cGJOg+OXW34BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760389164; c=relaxed/simple;
	bh=V0o0YdnKfawFG0S/LxD4c2ONmIHjSbuWqAGiMW/MfF8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GsNJY6eS4B4dFgbNw+michyJ59H1Abxz20W/UW6mEvQbcDy35LPDk05HTiFBbWAL6xjxaPKaIVHBk8JWsPHi55Y9hIb7mDcnU21Tz/ovj9W/mlvp6cKBCzy73N7a4KHGWxZUX/C4lukHY9a7TS+p20nPUAMSZW4hKf+pWQJcDp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BDVoypSt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339ee7532b9so24085456a91.3
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 13:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760389162; x=1760993962; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rsLbcQxnVzBTofG5buFKjSgLgx+LWk9MVyYKn5hZEiw=;
        b=BDVoypStYj4vZ/RT7BvmXGvUPmRDE8Rne14rBjZ0c8GFRa06gn3M5/O6iLjLmB2jZr
         5JsQ0/L3/GmrVQu+26oC7B450qEK2QdDMfWv4mIyOMVA/LpIYpm3VNKcu2b2wwen8g4s
         ylwygoNWHQ0zMz5qyJ/PM7c7VH/AZtNx5ot80cGcrXgCNKS9tYaBc4TeLAk3wc7GRNXP
         jycltPhJStfhtVb2l5D6KHZXoQKjxoj82o9QMyfS2Btv45ho95Q+fdc6Sn83mQrUBDlu
         a2yLTqc75SpG9snOb2/INL6oAT1IBkWc9PiiUQcDi5rBFfueFegxzBl1jFY/ikn5wY2M
         92vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760389162; x=1760993962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rsLbcQxnVzBTofG5buFKjSgLgx+LWk9MVyYKn5hZEiw=;
        b=HFFCWsS6szPixFznTzb80J9Psphz9xXjJfXG1bAa4UTFgf52xq7yjLZXjI1aTjjKgb
         QM4peDaWs/hOZaSjDvpBJFBf4Nj1cvaYonnH3iU6s72BlGUER7RVzcenUJao1M89oleF
         w81HbPprbe/xttd//zM/5zVwhGkv6OgmtJ9MhpbQUDd+2bitkefIqN3aWY4Oj2YIpoO+
         CF0+UZtDLnFCHuA7UJkUWtSX7JugPEr3ggCv3BQb9NzEHV0sBp66GwPMGNrezIkASRI0
         XeRJJULu2Bx7G8Gunwu4rPVBQsV6wHwhT67n+7ym1hBCFi21jySBgMjyU10591NsSfKn
         8qYA==
X-Forwarded-Encrypted: i=1; AJvYcCWR0lAO8cUAHYq7sGcWkN3OVYE5yTIXroAlAvX3NeR+/jG6JxY6qYVAGYTR5ylNhMgsPZU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yys7jC3oH2nV0wOa8rMvSZnTIVexYtMY8z2L+1+VfE4gJHE8bQd
	fVCClqgxc0wvGGpGGzo/rbycFGTtzZ2jIBy56Pp0tyLgY+WxIdVNM4bRk1K+9pcsUSuEuFgaxKj
	FfSIEVg==
X-Google-Smtp-Source: AGHT+IH3W7hslsSg1ZfruAgSMSPE57JiY/2SS4XyoAzw59MpeXjInd8g5McNYn7d63ASeoC/WcTr2wqSW2U=
X-Received: from pjyu10.prod.google.com ([2002:a17:90a:e00a:b0:330:793a:2e77])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38ce:b0:32e:23fe:fa51
 with SMTP id 98e67ed59e1d1-33b511188e7mr30269535a91.9.1760389162357; Mon, 13
 Oct 2025 13:59:22 -0700 (PDT)
Date: Mon, 13 Oct 2025 13:59:21 -0700
In-Reply-To: <ffc9e29aa6b9175bde23a522409a731d5de5f169.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251010220403.987927-1-seanjc@google.com> <20251010220403.987927-4-seanjc@google.com>
 <ffc9e29aa6b9175bde23a522409a731d5de5f169.camel@intel.com>
Message-ID: <aO1oKWbjeswQ-wZO@google.com>
Subject: Re: [RFC PATCH 3/4] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during tdx_init()
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dan J Williams <dan.j.williams@intel.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "xin@zytor.com" <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 13, 2025, Rick P Edgecombe wrote:
> On Fri, 2025-10-10 at 15:04 -0700, Sean Christopherson wrote:
> > @@ -3524,34 +3453,31 @@ static int __init __tdx_bringup(void)
> >  	if (td_conf->max_vcpus_per_td < num_present_cpus()) {
> >  		pr_err("Disable TDX: MAX_VCPU_PER_TD (%u) smaller than number of logical CPUs (%u).\n",
> >  				td_conf->max_vcpus_per_td, num_present_cpus());
> > -		goto get_sysinfo_err;
> > +		return -EINVAL;
> >  	}
> >  
> >  	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids()))
> > -		goto get_sysinfo_err;
> > +		return -EINVAL;
> >  
> >  	/*
> > -	 * Leave hardware virtualization enabled after TDX is enabled
> > -	 * successfully.  TDX CPU hotplug depends on this.
> > +	 * TDX-specific cpuhp callback to disallow offlining the last CPU in a
> > +	 * packing while KVM is running one or more TDs.  Reclaiming HKIDs
> > +	 * requires doing PAGE.WBINVD on every package, i.e. offlining all CPUs
> > +	 * of a package would prevent reclaiming the HKID.
> >  	 */
> > +	r = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvm/cpu/tdx:online",
> > +			      tdx_online_cpu, tdx_offline_cpu);
> 
> Could pass NULL instead of tdx_online_cpu() and delete this version of
> tdx_online_cpu().

Oh, nice, I didn't realize (or forgot) the startup call is optional.
 
> Also could remove the error handling too.

No.  Partly on prinicple, but also because CPUHP_AP_ONLINE_DYN can fail if the
kernel runs out of dynamic entries (currently limited to 40).  The kernel WARNs
if it runs out of entries, but KVM should still do the right thing.

> Also, can we name the two tdx_offline_cpu()'s differently? This one is all about
> keyid's being in use. tdx_hkid_offline_cpu()?

Ya.  And change the description to "kvm/cpu/tdx:hkid_packages"?  Or something
like that.

> > +	if (r < 0)
> > +		goto err_cpuhup;
> > +
> > +	tdx_cpuhp_state = r;
> >  	return 0;
> >  
> > -get_sysinfo_err:
> > -	__tdx_cleanup();
> > -tdx_bringup_err:
> > -	kvm_disable_virtualization();
> > +err_cpuhup:
> > +	misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
> >  	return r;
> >  }
> >  
> > -void tdx_cleanup(void)
> > -{
> > -	if (enable_tdx) {
> > -		misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
> > -		__tdx_cleanup();
> > -		kvm_disable_virtualization();
> > -	}
> > -}
> > -
> >  int __init tdx_bringup(void)
> >  {
> >  	int r, i;
> > @@ -3563,6 +3489,16 @@ int __init tdx_bringup(void)
> >  	if (!enable_tdx)
> >  		return 0;
> >  
> > +	if (!cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM)) {
> > +		pr_err("TDX not supported by the host platform\n");
> > +		goto success_disable_tdx;
> > +	}
> > +
> > +	if (!cpu_feature_enabled(X86_FEATURE_OSXSAVE)) {
> > +		pr_err("OSXSAVE is required for TDX\n");
> > +		return -EINVAL;
> 
> Why change this condition from goto success_disable_tdx?

Ah, a copy+paste goof.  I originally moved the code to tdx_enable(), then realized
it as checking OSXSAVE, not XSAVE, and so needed to be done later in boot.  When
I copied it back to KVM, I forgot to restore the goto.

> >  	r = __tdx_bringup();
> > -	if (r) {
> > -		/*
> > -		 * Disable TDX only but don't fail to load module if the TDX
> > -		 * module could not be loaded.  No need to print message saying
> > -		 * "module is not loaded" because it was printed when the first
> > -		 * SEAMCALL failed.  Don't bother unwinding the S-EPT hooks or
> > -		 * vm_size, as kvm_x86_ops have already been finalized (and are
> > -		 * intentionally not exported).  The S-EPT code is unreachable,
> > -		 * and allocating a few more bytes per VM in a should-be-rare
> > -		 * failure scenario is a non-issue.
> > -		 */
> > -		if (r == -ENODEV)
> > -			goto success_disable_tdx;
> > -
> > +	if (r)
> >  		enable_tdx = 0;
> > -	}
> >  
> 
> I think the previous discussion was that there should be a probe and enable
> step. We could not fail KVM init if TDX is not supported (probe), but not try to
> cleanly handle any other unexpected error (fail enabled).
> 
> The existing code mostly has the "probe" type checks in tdx_bringup(), and the
> "enable" type checks in __tdx_bringup(). But now the gutted __tdx_bringup() is
> very probe-y. Ideally we could separate these into named "install" and "probe"
> functions. I don't know if this would be good to do this as part of this series
> or later though.
> 
> >  	return r;
> >  
> > 
> > 
> 
> [snip]
> 
> >  
> >  /*
> >   * Add a memory region as a TDX memory block.  The caller must make sure
> >   * all memory regions are added in address ascending order and don't
> >   * overlap.
> >   */
> > -static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
> > -			    unsigned long end_pfn, int nid)
> > +static __init int add_tdx_memblock(struct list_head *tmb_list,
> > +				   unsigned long start_pfn,
> > +				   unsigned long end_pfn, int nid)
> 
> One easy thing to break this up would be to do this __init adjustments in a
> follow on patch.

Ya, for sure. 

