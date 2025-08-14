Return-Path: <kvm+bounces-54673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1F0B26855
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 16:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93E6E1CE3023
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 13:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B3EB3002AC;
	Thu, 14 Aug 2025 13:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="daEOp3lt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC0A2FD7C4
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 13:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755179660; cv=none; b=MmcAR4o/mXhG5/nnhIxH2l5JTMa2m6OqXsoTPwRat9zwv4MJryL+db0nLPuPr/2hb3t5tZ6cOtGUSE2gaulLxe0ZRZ0bpOep1BsoMcpSTc1ecL1lN7/0Q8yu60E+DCbykRRWFwe5tI26vIuwnD20ZDKAYs5XkF/1YvaLWjrhZFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755179660; c=relaxed/simple;
	bh=KWKFgqrMEJy2qGnil2Tx3WqFtti1rmJ94E5W+NOYgfQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m2+2Ec0Lk9vDonnbwSjjRxhH83tePG2Zsc5RazZK3lwnaWX8tqbrR9P/J9n7lp1z2xhJNMeZEAD4hzeGT1hV1UJuOQ3gQ0zRR8kOXlPvKXjttlAUssW4+nes7GSqRAWz2XAuhywXJsP+wq0Pcucm8cnfBpkMY0rS9QmkmiKXbko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=daEOp3lt; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2445806dc88so21630185ad.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 06:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755179657; x=1755784457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fyJbJM7IcaPznn76owPMykg8NkcmrFg15/R109Uu1ck=;
        b=daEOp3ltqygQImLZYCZquqGbiwlptr3iwtVy3qeFQ4At3ZBnNZ14HVgdDyEG0MmmDS
         q0DJRRkeJ03xjRA4HwXq5CBLdF4EqR9gW1GFm++70fPNwfXIsh38Z4dKdxlQLHk46Gfx
         BpKEN7PaZgMxlYvoL1y73wdXLBNe/UkjuT1NEmsas6yeFDnX2YHeFtfvWwaylRp9AcWN
         QqXMvHKemnRL5E1MsFhq8/XHV0NIIS36+koHlI75fbf0USbItXn0sHQGgtXXadpdSsxZ
         JjrEX5YKf4/+LKU8W1F278Jz9l/iRp5glDvg/65p1ZxTUGKK5INspbnHDS18quqqptJ+
         fJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755179657; x=1755784457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fyJbJM7IcaPznn76owPMykg8NkcmrFg15/R109Uu1ck=;
        b=BBwyBsS1Va7+SrMu6X1moaIOIoDS0KNPaPLMYhlpBWWymyoQG9IhvMCWciaRVUH4mt
         60rKnaEEgWH2dCLCleuqP4Bs8Z9Rja9GLhzjIKi6Ge0yutIHEqoTG3j2v2YX6uL9jubR
         26E2luuiCqwaAApbEcTD4zBfLhocqJUYx6vJCBdagvVIZC6JRxrmuh3BtG53G6BwVT25
         7W2Y6lom8hfJTC3w7xqrfu1b4KoGsSuAAVdCrAMYit0QrjA5Xvkmvr6Yb6wmsFFW3dxl
         IeCKvxYP8/V34pdvBD8lE7vJtRCkmScJYjD072SmyePbra5D5SGOt+CA2oUfvcwluGKp
         1ysw==
X-Forwarded-Encrypted: i=1; AJvYcCWYw/fOzPLv7HuDp6/sJrdAtAndvpUCSJ8R82ILkDjiahF4F/IYmKJ5m31Mn3XTGGrejH8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZvOV7e/I3cScwrU02IqveAbUNTaeOhyfkes6Cyn00+QnG7RVp
	ts052DqT7fCzEejKvsxVsawwL3wRoG3MapgZ7Qg0noSR2BU4Qt1vM52AE+KfkTnXonec23ntpOv
	K0gFHJQ==
X-Google-Smtp-Source: AGHT+IFc8rQwzFNm90sVJBEONFTj6biaSgb+iwPmQbSfN/V2e/NQZ+17pol+42jKlhGZTUb4jbGQNph1iaE=
X-Received: from plry14.prod.google.com ([2002:a17:902:b48e:b0:240:72c0:cc89])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ced0:b0:23f:e869:9a25
 with SMTP id d9443c01a7336-244586dc38bmr53125045ad.44.1755179657224; Thu, 14
 Aug 2025 06:54:17 -0700 (PDT)
Date: Thu, 14 Aug 2025 06:54:14 -0700
In-Reply-To: <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755126788.git.kai.huang@intel.com> <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
Message-ID: <aJ3qhtzwHIRPrLK7@google.com>
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: dave.hansen@intel.com, bp@alien8.de, tglx@linutronix.de, 
	peterz@infradead.org, mingo@redhat.com, hpa@zytor.com, 
	thomas.lendacky@amd.com, x86@kernel.org, kas@kernel.org, 
	rick.p.edgecombe@intel.com, dwmw@amazon.co.uk, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, kvm@vger.kernel.org, reinette.chatre@intel.com, 
	isaku.yamahata@intel.com, dan.j.williams@intel.com, ashish.kalra@amd.com, 
	nik.borisov@suse.com, chao.gao@intel.com, sagis@google.com, 
	farrah.chen@intel.com, Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 14, 2025, Kai Huang wrote:
>  arch/x86/include/asm/tdx.h  |  2 ++
>  arch/x86/kvm/vmx/tdx.c      | 12 ++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.c | 12 ++++++++++++
>  3 files changed, 26 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 0922265c6bdc..e9a213582f03 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -217,6 +217,7 @@ u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u6
>  u64 tdh_phymem_cache_wb(bool resume);
>  u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
>  u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
> +void tdx_cpu_flush_cache(void);
>  #else
>  static inline void tdx_init(void) { }
>  static inline int tdx_cpu_enable(void) { return -ENODEV; }
> @@ -224,6 +225,7 @@ static inline int tdx_enable(void)  { return -ENODEV; }
>  static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
>  static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
>  static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
> +static inline void tdx_cpu_flush_cache(void) { }

Stub is unnecessary.  tdx.c is built iff KVM_INTEL_TDX=y, and that depends on
INTEL_TDX_HOST.

At a glance, some of the existing stubs are useless as well.

>  #endif	/* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLER__ */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 66744f5768c8..1bc6f52e0cd7 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -442,6 +442,18 @@ void tdx_disable_virtualization_cpu(void)
>  		tdx_flush_vp(&arg);
>  	}
>  	local_irq_restore(flags);
> +
> +	/*
> +	 * No more TDX activity on this CPU from here.  Flush cache to
> +	 * avoid having to do WBINVD in stop_this_cpu() during kexec.
> +	 *
> +	 * Kexec calls native_stop_other_cpus() to stop remote CPUs
> +	 * before booting to new kernel, but that code has a "race"
> +	 * when the normal REBOOT IPI times out and NMIs are sent to
> +	 * remote CPUs to stop them.  Doing WBINVD in stop_this_cpu()
> +	 * could potentially increase the possibility of the "race".
> +	 */
> +	tdx_cpu_flush_cache();

IIUC, this can be:

	if (IS_ENABLED(CONFIG_KEXEC))
		tdx_cpu_flush_cache();

>  }
>  
>  #define TDX_SEAMCALL_RETRIES 10000
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 3ea6f587c81a..c26e2e07ff6b 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1870,3 +1870,15 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
>  	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
>  }
>  EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
> +
> +void tdx_cpu_flush_cache(void)
> +{
> +	lockdep_assert_preemption_disabled();
> +
> +	if (!this_cpu_read(cache_state_incoherent))
> +		return;
> +
> +	wbinvd();
> +	this_cpu_write(cache_state_incoherent, false);
> +}
> +EXPORT_SYMBOL_GPL(tdx_cpu_flush_cache);
> -- 
> 2.50.1
> 

