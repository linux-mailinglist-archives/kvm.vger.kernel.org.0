Return-Path: <kvm+bounces-61479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A5EC2003E
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 13:29:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DCB746207E
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 12:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 979C031B111;
	Thu, 30 Oct 2025 12:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OzXvSAJU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4A730AAD7
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 12:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827290; cv=none; b=gEwHau/mywavR/ll71UBLpywun+ZCYBjWXqQbRxRtB3Jk/lIlM8AS0Eb/On/k3B7oiCBaHOk5EiGrcOUQYTkUhHoKsxpKpKdjBJamIJKvT3xqW4TnvxaKhk6+gw8e2kXFls8Q9sAzqndihepqSpGr1Fc+tE3qaJFThuF0+Nggxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827290; c=relaxed/simple;
	bh=WT+yWFoFzB4isQBpCZEi4cpIboFEmQeIxx/K8SUZ2yI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KCH2sLQqJ90yWZsg98PO0TGrPM8MoIIoIF13442khykNIaO1TjucjMSiBhCHcT80ozcSzNnnOjwo1mlCU3pT8kp9uJZ/fTO1Yjf5CSHsfiUweDGOE/tFyx7ttTGApfyi2rfVpqEO9fpFcv2I9lrHVmu6rwTmReUjbKIsFo+tYvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OzXvSAJU; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-63c4b757a76so762871a12.2
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 05:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761827287; x=1762432087; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Iz5sLW500EYIVdnuMM9jOjVidmBC+9TxhNfn+Chx9HU=;
        b=OzXvSAJU1RB1N4oXVy4AMmr9PbgiFXbBwkzJTuojrcrjZtRYk/+q8qE810HNOeVO8D
         rCcW37zAAyDgM4uJZkoVJ5mzFElj2xROZ3TtTv8meVjRFxTrK8ta9sRythQye9TxQrBI
         ZadkpfO6W++74IreQkp9+MzwL0Ms5zloBS/WyGw3SgSJpfHepeTtYboO93g+Wm1+dQmV
         wW2CylE9GlgOCzYxWRsB1zPORT6IBjLmj5EVzOu4cAfZBI94qtrGrMmI18FXKpECov5/
         1caUQZsa9+EVDsxui7WB+VGlv91v5RUer6udCmhh8FFfINs5aKFvKSiQBbEsafXGHEUj
         t/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761827287; x=1762432087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iz5sLW500EYIVdnuMM9jOjVidmBC+9TxhNfn+Chx9HU=;
        b=v2gbcpZgZSDgk8gHWxkcY73C6V/Fr0Cl2x7O6TlS5uilk28it25QEeqM0ZTyvMjVzN
         edWAaLBHmV5r+D1hh8DQEFUtOeUzYyfQ/iCJ2OeCFT0LeibnZgAKD/b6TC8kBu0NkDKB
         Vr8JwBY7+2Vs4CUCo7VX0S9yWf6b7DOaPaQQl1rVMfjLLTPFidhjv06nxeLTZaq7Swaa
         VWIR0MC6z4aqHF9qzFGwHknlSH8aFNAOv1mJousm53NH/krn2vYMJmgcQhsH/Z/hOGrv
         sx/gdKa24tDQZc6VRntmK9F1mLSY/FFfe+NJuktVog2FuY90mbm/MTiMnK/lcuUf8gLB
         BVvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoEh6qOvsMmCT7IdzbB+1FjUvLxgw2q8K3BiCfG1o1CGzcF3cg/u9YM13Bithf5dnb0IU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvn9C6K5sVFhcusE07bNPdh4vzSEBb3NP7RavVIvS5jUU3zAMn
	c5Ml2YhiXQ8kAbkrb9zmGBoGqzD08ZeX7moE54zFNvhH7RjWLd9ljZG1paZulxC0sIuhDjLOkpm
	P6QOIsnlEdm+FxQ==
X-Google-Smtp-Source: AGHT+IFf0JtH99Wnxr1MiK355F5gK34ff6ks2LaQ8nseaqfEWG8gnD0yPd0xWpTbGOhwBalj68ePrx7AR9f0bg==
X-Received: from edj18.prod.google.com ([2002:a05:6402:3252:b0:63e:1b84:55fa])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5245:b0:639:720d:72d with SMTP id 4fb4d7f45d1cf-6404425e8c2mr5290841a12.29.1761827287114;
 Thu, 30 Oct 2025 05:28:07 -0700 (PDT)
Date: Thu, 30 Oct 2025 12:28:06 +0000
In-Reply-To: <20251029-verw-vm-v1-1-babf9b961519@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com> <20251029-verw-vm-v1-1-babf9b961519@linux.intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDVNNDVOE49L.1F77ZUNBVTR1I@google.com>
Subject: Re: [PATCH 1/3] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
From: Brendan Jackman <jackmanb@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, 
	Tao Zhang <tao1.zhang@intel.com>, Jim Mattson <jmattson@google.com>, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed Oct 29, 2025 at 9:26 PM UTC, Pawan Gupta wrote:
> TSA mitigation:
>
>   d8010d4ba43e ("x86/bugs: Add a Transient Scheduler Attacks mitigation")
>
> introduced VM_CLEAR_CPU_BUFFERS for guests on AMD CPUs. Currently on Intel
> CLEAR_CPU_BUFFERS is being used for guests which has a much broader scope
> (kernel->user also).
>
> Make mitigations on Intel consistent with TSA. This would help handling the
> guest-only mitigations better in future.
>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/bugs.c | 9 +++++++--
>  arch/x86/kvm/vmx/vmenter.S | 3 ++-
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index d7fa03bf51b4517c12cc68e7c441f7589a4983d1..6d00a9ea7b4f28da291114a7a096b26cc129b57e 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -194,7 +194,7 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
>  
>  /*
>   * Controls CPU Fill buffer clear before VMenter. This is a subset of
> - * X86_FEATURE_CLEAR_CPU_BUF, and should only be enabled when KVM-only
> + * X86_FEATURE_CLEAR_CPU_BUF_VM, and should only be enabled when KVM-only
>   * mitigation is required.
>   */

So if I understand correctly with this patch the aim is:

X86_FEATURE_CLEAR_CPU_BUF means verw before exit to usermode

X86_FEATURE_CLEAR_CPU_BUF_VM means unconditional verw before VM Enter

cpu_buf_vm_clear[_mmio_only] means verw before VM Enter for
MMIO-capable guests.

Since this is being cleaned up can we also:

- Update the definition of X86_FEATURE_CLEAR_CPU_BUF in cpufeatures.h to
  say what context it applies to (now it's specifically exit to user)

- Clear up how verw_clear_cpu_buf_mitigation_selected relates to these
  two flags. Thinking aloud here... it looks like this is set:

  - If MDS mitigations are on, meaning both flags are set

  - If TAA mitigations are on, meaning both flags are set

  - If MMIO mitigations are on, and the CPU has MDS or TAA. In this case
    both flags are set, but this causality is messier.

  - If RFDS mitigations are on and supported, meaning both flags are set

  So if I'm reading this correctly whenever
  verw_clear_cpu_buf_mitigation_selected we should expect both flags
  enabled. So I think all that's needed is to add a reference to
  X86_FEATURE_CLEAR_CPU_BUF_VM to the comment?

I think we also need to update the assertion of vmx->disable_fb_clear?

Anyway thanks this seems like a very clear improvement to me.

