Return-Path: <kvm+bounces-14055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4421B89E6C5
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 02:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6B56B22591
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C044A1B;
	Wed, 10 Apr 2024 00:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GnGoxJFm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BE14A11
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708589; cv=none; b=Uzp3+WEV+kuE4a1Ix35WXP+yv34y+iSJCOHGdfEPfA2g9LoILCkk5Gv4LajJ+Okqa2n7HtkTvLr4vbt8kOWL0t8DsGvAZ1c6tNXwCCG1C2CBcByOS2TFBZSf68HCW0KGTisxWcQ1RWTDn0ErZqVkGLJxUIsO0U8Kn6saXVlxC/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708589; c=relaxed/simple;
	bh=pHlM0XVx9NTNUAXMuclPrj40otYkCLtMYRlJXvi7cpo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tCPV6VMLAaSR6BPTUTGbgKYHvVIn7XBp0El+eWAhC+6UhqD3Tl6rUpaUnSml0HGcSYY3Pt6jSDPEKKyGadwcA+gxL8PGPzA9ENHYqdaPgjWOqKhiFRp2/oC9B6XrSdYSPW2Enu99geu3rX/PTQsVLVPdvm8BtPJeHWSDjfh7D78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GnGoxJFm; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc05887ee9so8323231276.1
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 17:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708587; x=1713313387; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=htUF4GcjxNHIR81oJrQq7Z2RdLusi7qpjkhr5S8yjTs=;
        b=GnGoxJFm51a7/q2qOZCl7rA7tDgBCZeUt9IgIfwAaOJLvNz95q5/0kf7D88sUbhKI2
         W8RGMLh1Q6r9dv/VUUnzetN81qX0ytodDZBgUVy2iXHSAguOgcghzCGPzSmI/yCs2Xae
         PsdL58EebcaBWuSCMNXP/w02FlNNennVaQXSWLvbzLRMe0zSVQmjOcQfC8VUeZvEZvvU
         O2kLGpDMybR5LM6mL/KgRAsRZTNXDsPAMPPvLY3vo69riN+gTbJwYEApmyaHjkq0LQaB
         snJrzn4rLlq1Q/+MIZrtn335+aFkUzlLq6jtWJ1jih9IpxS5mf5za9FSlw0PdWWnCfPo
         aVBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708587; x=1713313387;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=htUF4GcjxNHIR81oJrQq7Z2RdLusi7qpjkhr5S8yjTs=;
        b=OecYh1S6uMza4hBqxEDyAcWbhC15GG7IKLtyJsh5gsKuJ00aIKK6mff0O0L8jjyYs0
         YECK9/S8GZBaoDqRqCoEXqyUFggT4ok1yoi+JxzwOwyGsF6b1bu5XMMNHIg6e5lq9Bhv
         c2p6pW4zuVou6gk0pdx0zIkbywd852CyUu8fi10eH00Yqay9jrbyOzNxhfEIu32L2hca
         20xVdbji7Jpas9ToV0Mmi3fMQx3V3RCpx3eXYsmkp/Sh8fZvsQdfWVsxve/BlJtj52h0
         8cOjsk9JP7NYcMtr0SvMJ8rzgDm53jaRwFSdQioakSnItsOjjg8FdYrvaJPnjGX8M/J2
         z25g==
X-Gm-Message-State: AOJu0Yxfc6abCLXRsV9r/k15/sfbb5/uPntcYUJ1uMw+xPRRUARvJ0+P
	xH+Wa2OVSF8w14javMpUwNhLz3BPHOcjbhz1jiXYW2ZRFxFbyHjjMtozjKnxZ2mkjRZ921Hw6Q9
	LDg==
X-Google-Smtp-Source: AGHT+IGoOCypTJl5Vv1goHbhu/hnODpllocU84G0pfEc6lSAIHxJwl5TpyckAQ3Xnsk/Db1AlsGMhZHaIL4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1505:b0:dbe:387d:a8ef with SMTP id
 q5-20020a056902150500b00dbe387da8efmr132273ybu.1.1712708587172; Tue, 09 Apr
 2024 17:23:07 -0700 (PDT)
Date: Tue,  9 Apr 2024 17:19:59 -0700
In-Reply-To: <20240223204233.3337324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223204233.3337324-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171270505394.1590014.8020716629474398619.b4-ty@google.com>
Subject: Re: [PATCH 0/8] KVM: SVM: Clean up VMRUN=>#VMEXIT assembly
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 23 Feb 2024 12:42:25 -0800, Sean Christopherson wrote:
> Clean up SVM's enter/exit assembly code so that it can be compiled
> without OBJECT_FILES_NON_STANDARD.  The "standard" __svm_vcpu_run() can't
> be made 100% bulletproof, as RBP isn't restored on #VMEXIT, but that's
> also the case for __vmx_vcpu_run(), and getting "close enough" is better
> than not even trying.
> 
> As for SEV-ES, after yet another refresher on swap types, I realized KVM
> can simply let the hardware restore registers after #VMEXIT, all that's
> missing is storing the current values to the host save area (I learned the
> hard way that they are swap Type B, *sigh*).  Unless I'm missing something,
> this provides 100% accuracy when using stack frames for unwinding, and
> requires less assembly (though probably not fewer code bytes; I didn't check).
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/8] KVM: SVM: Create a stack frame in __svm_vcpu_run() for unwinding
      https://github.com/kvm-x86/linux/commit/19597a71a0c8
[2/8] KVM: SVM: Wrap __svm_sev_es_vcpu_run() with #ifdef CONFIG_KVM_AMD_SEV
      https://github.com/kvm-x86/linux/commit/7774c8f32e99
[3/8] KVM: SVM: Drop 32-bit "support" from __svm_sev_es_vcpu_run()
      https://github.com/kvm-x86/linux/commit/331282fdb15e
[4/8] KVM: SVM: Clobber RAX instead of RBX when discarding spec_ctrl_intercepted
      https://github.com/kvm-x86/linux/commit/87e8e360a05f
[5/8] KVM: SVM: Save/restore non-volatile GPRs in SEV-ES VMRUN via host save area
      https://github.com/kvm-x86/linux/commit/c92be2fd8edf
[6/8] KVM: SVM: Save/restore args across SEV-ES VMRUN via host save area
      https://github.com/kvm-x86/linux/commit/adac42bf42c1
[7/8] KVM: SVM: Create a stack frame in __svm_sev_es_vcpu_run()
      https://github.com/kvm-x86/linux/commit/4367a75887ec
[8/8] KVM: x86: Stop compiling vmenter.S with OBJECT_FILES_NON_STANDARD
      https://github.com/kvm-x86/linux/commit/27ca867042af

--
https://github.com/kvm-x86/linux/tree/next

