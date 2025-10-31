Return-Path: <kvm+bounces-61677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A07F6C24C52
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 12:26:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64BF41896186
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 11:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8C633451C9;
	Fri, 31 Oct 2025 11:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fbxJ2KY5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6E542050
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 11:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761909952; cv=none; b=jruVlBAlHbFADthHfYYv67YoMl4/dSrdm7kBiMV6mbyNnTee2lujD/USOlQhabxOLrxozOAGpdLxS8jB6hJGicjfUkZ+ONGEjkKsxju8T5xWK1v/cT0bbxNzgpO3142w3pvqzHkfTpCpPrRqQBfBY+LuiR8hFefCkqC3YCkAoL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761909952; c=relaxed/simple;
	bh=X4VaRNNgNgnlXlGOlZI2p4bomujrfvSguly9xNpr6YQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kCZukCYWOx1rpiwAWntugKwJADXEwsPRmgKKMReYzuvwCq7gm7iiikFs/wLJ5PR/zcYRC810HWbOlFvUKUkWrpAbYPjsBtEZ+bexi6pp2xRqFLkdeJ1XjdkuBPflx/H+eG8HY6t1tKEM1jP8NFXKDahH/7zemYWioiWsMJSLtLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fbxJ2KY5; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso21178955e9.2
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 04:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761909949; x=1762514749; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gC+O1H55oLfCNcv4yz7bhSqw3iH3dOLNxNvOfa9XL8w=;
        b=fbxJ2KY5dnwrJO7Nn9FbxPHCcbeHbgADX2BGRfcr3Ko0PJRRQr2jNl8NAnN/cJs/oz
         GObFasb3g++9tmkyvVme2CdCT/QjTQ7kUSjQzblt/ohhhVfpBCZp2rNdwiKg0kwh6tRH
         r2D8pGdJrtxdEkzjjJDKBRDf2vuxXorzTu6WUiZnld/xpouHFNEHmL/V0mptTftGdVnO
         ltMk+e2wNAZrinq7RP2eTVEM85or6LctYlhKwZzq/X4Ad4EZLnLtqQGGXUE/GE9vJqeE
         8Q/9/UytwpcSirxksi7QwwYcOKkAn67MX+krxi4GYCWWk/CR60xo8RLptX5JLNrJ53u+
         emJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761909949; x=1762514749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gC+O1H55oLfCNcv4yz7bhSqw3iH3dOLNxNvOfa9XL8w=;
        b=mbA2LU0bWRG0QuIE8RONmXqmTJOwdNZanAdRsY13FQj81+PT+gNZG2j84CnJBT1mXp
         DzwS8ytMXfjjivQmKsBxBpcb+rXfisMNMM5TxgkYcLis0gCV5EMtwKv4eRNx2SdAtxjY
         9DDVTCvELFc0VwERlU/n9/0Cwj90azSyQ/2m3Y51J0Ng27SwBpBT9+u827snLIcjI8Dg
         IrluQBXyrOVZb4+DRbxWC3rZ04w7u2ELvYEmQ8O8MWIJw83t+ddMgCtjqAY4UqtZGuxB
         WXRQsZ1d1HxiBJxdgHJ/PBrfEbRlTqio1G4y2cEs2Ns4FFJlAt2IRpuyVY1lYFXsBKyh
         XalA==
X-Forwarded-Encrypted: i=1; AJvYcCXmVAIMY9Lv5p7iQa6hJd9NpYelg+sEUr/FjtB+jsBaGponKPxjdtgDorgEEXUES353N08=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd7yO/pIKajkZpJleSh1Vz0LuJLn2a6TNIV42Yn4N5IBenFOzZ
	l+xSBWoP5qk4QsQ67gF2/s6HpOjup7qpiabeLmahtxxS2C2M7AGQ9rqgPhiXlGI3W69uPY7DwuT
	HWn5Z6y7TikJMng==
X-Google-Smtp-Source: AGHT+IEOTuytwp3PmKm6W+0WiiAoI4oh/JX4kv9XKyvEyXzu66nx1kXLfw2RNbRxaOXTa0uRUHzCIPMiIlG46Q==
X-Received: from wmbh20.prod.google.com ([2002:a05:600c:a114:b0:46e:684e:1977])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e87:b0:46e:74cc:42b8 with SMTP id 5b1f17b1804b1-4773080fbfbmr28060755e9.17.1761909949647;
 Fri, 31 Oct 2025 04:25:49 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:25:49 +0000
In-Reply-To: <20251030184354.qwulxmbxkt6thu6b@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-1-babf9b961519@linux.intel.com> <DDVNNDVOE49L.1F77ZUNBVTR1I@google.com>
 <20251030184354.qwulxmbxkt6thu6b@desk>
X-Mailer: aerc 0.21.0
Message-ID: <DDWGY8JOYRIO.2XYJMYGEEVLIX@google.com>
Subject: Re: [PATCH 1/3] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
From: Brendan Jackman <jackmanb@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Brendan Jackman <jackmanb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, 
	Tao Zhang <tao1.zhang@intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu Oct 30, 2025 at 6:43 PM UTC, Pawan Gupta wrote:
> On Thu, Oct 30, 2025 at 12:28:06PM +0000, Brendan Jackman wrote:
>> On Wed Oct 29, 2025 at 9:26 PM UTC, Pawan Gupta wrote:
>> > TSA mitigation:
>> >
>> >   d8010d4ba43e ("x86/bugs: Add a Transient Scheduler Attacks mitigation")
>> >
>> > introduced VM_CLEAR_CPU_BUFFERS for guests on AMD CPUs. Currently on Intel
>> > CLEAR_CPU_BUFFERS is being used for guests which has a much broader scope
>> > (kernel->user also).
>> >
>> > Make mitigations on Intel consistent with TSA. This would help handling the
>> > guest-only mitigations better in future.
>> >
>> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>> > ---
>> >  arch/x86/kernel/cpu/bugs.c | 9 +++++++--
>> >  arch/x86/kvm/vmx/vmenter.S | 3 ++-
>> >  2 files changed, 9 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
>> > index d7fa03bf51b4517c12cc68e7c441f7589a4983d1..6d00a9ea7b4f28da291114a7a096b26cc129b57e 100644
>> > --- a/arch/x86/kernel/cpu/bugs.c
>> > +++ b/arch/x86/kernel/cpu/bugs.c
>> > @@ -194,7 +194,7 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
>> >  
>> >  /*
>> >   * Controls CPU Fill buffer clear before VMenter. This is a subset of
>> > - * X86_FEATURE_CLEAR_CPU_BUF, and should only be enabled when KVM-only
>> > + * X86_FEATURE_CLEAR_CPU_BUF_VM, and should only be enabled when KVM-only
>> >   * mitigation is required.
>> >   */
>> 
>> So if I understand correctly with this patch the aim is:
>> 
>> X86_FEATURE_CLEAR_CPU_BUF means verw before exit to usermode
>> 
>> X86_FEATURE_CLEAR_CPU_BUF_VM means unconditional verw before VM Enter
>> 
>> cpu_buf_vm_clear[_mmio_only] means verw before VM Enter for
>> MMIO-capable guests.
>
> Yup, thats the goal.
>
>> Since this is being cleaned up can we also:
>> 
>> - Update the definition of X86_FEATURE_CLEAR_CPU_BUF in cpufeatures.h to
>>   say what context it applies to (now it's specifically exit to user)
>> 
>> - Clear up how verw_clear_cpu_buf_mitigation_selected relates to these
>>   two flags. Thinking aloud here... it looks like this is set:
>> 
>>   - If MDS mitigations are on, meaning both flags are set
>> 
>>   - If TAA mitigations are on, meaning both flags are set
>> 
>>   - If MMIO mitigations are on, and the CPU has MDS or TAA. In this case
>>     both flags are set, but this causality is messier.
>> 
>>   - If RFDS mitigations are on and supported, meaning both flags are set
>> 
>>   So if I'm reading this correctly whenever
>>   verw_clear_cpu_buf_mitigation_selected we should expect both flags
>>   enabled. So I think all that's needed is to add a reference to
>>   X86_FEATURE_CLEAR_CPU_BUF_VM to the comment?
>
> Yes. I will update the comment accordingly.
>
>> I think we also need to update the assertion of vmx->disable_fb_clear?
>
> I am not quite sure about the update needed. Could you please clarify?
>
>> Anyway thanks this seems like a very clear improvement to me.
>
> Thanks for the review and suggestions!

I will drop this thread and continue here:
https://lore.kernel.org/all/20251031003040.3491385-2-seanjc@google.com/

