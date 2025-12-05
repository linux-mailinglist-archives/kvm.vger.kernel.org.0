Return-Path: <kvm+bounces-65345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0734DCA7E8F
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 15:16:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A352C3039762
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 14:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486622E9749;
	Fri,  5 Dec 2025 14:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EWQt/xBy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5A82DAFA1
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764944201; cv=none; b=YpGZRKEOzkyV2XgmuUoR5vBwlBFMSn+JJ66tKP1/Nv2kdoGqLSMsUCbS+7yR1KG/G5AmJnjCpm6pMDD/E2ejd8Mf3VQC9TIRdx71bo9qlM5HJJv9Vk9mIVjaxL7AEF0g2Of0UnzHWi/mtbTBznPg+pZ6s4hiOY/f97CxTTUQb2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764944201; c=relaxed/simple;
	bh=PCMB+EhGQSB8Pqw3nvG4H2MT/nfPBQOMy02+eGLTOcc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XZNcpRUNjC90B+v2WD5c70N+4Q9y6AflQLdWxUaUWx8+rUyfwzXQAcJKOMqtSel9ljXnai21yVQrjKgNc5ieISNATex7K3PQG/kAy3YSonK4XzC9vcnwhh+GoKJ4RSOM4607oB9XCMUvH9pDQmgI/leJGkTXzRgS3jL9Zt0kW8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EWQt/xBy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34176460924so2115089a91.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 06:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764944197; x=1765548997; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mC1Hm50scHMH4ScGODeyyYoa2AK7zti5T9VBpoRnu2M=;
        b=EWQt/xBy1+fLwgeyXkpQMthHVHAs5R2499bnvkhlYUnhcQ3I+sJYQs34losaAMtcQk
         zkAWAgwMKVocBcniVAb306XjdW3UOGnVsn/Mr1/NAZ9JIa/dPROgzFTeFCHqDn3HD+Wf
         92qhguEgOPqfMX6rjcs4WuQxTpyyjfshB7PV3vzf86m2fBf8VrB1V7axYmXUL97C3vbB
         GlAJIW+jmj90g8vYNb1A5hd1KfRPE5P1YpVr0TCMWLPk1dBC7tFYKFPUfRGpQMKIiQWJ
         1D0NhRoakAHgBwSDz3CLaAI9eAf1ytQhbVHlV3sD46EjFzfutpR5xepDYPT5dfX1BpGJ
         RnKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764944197; x=1765548997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mC1Hm50scHMH4ScGODeyyYoa2AK7zti5T9VBpoRnu2M=;
        b=oi5JxeNUVr/BJeFBbpOnWOFXTcyjfWcJ/WAGKErCeZCE+WZlmY2kvMXrtSY/9mag2T
         IYqeYPzJCCLzShrKEPAGbRmjeHhdw3VkzihjdUYV919faeyY7KLeAJzbNjMkv9w+sWAV
         xq+38q+l2aBb5f0AxlMZ6Cg3KhwFSyW6NNPWTWf3RIgFUu31ZZrZTbLODNUJ7dIMSfpP
         3EWv5LkJRo1doD01/gbUJvCs5hHPQl0YS+mzhov3N3jAa0dqf7DUJDJX5/TeA2fvNq9l
         1irHRYcoUTQ/6uesbBTkVJBABJabPoWvMBhtHq0udoiDF0sgXEPZqsMDcG2MhXUQ7S6S
         Ov8A==
X-Forwarded-Encrypted: i=1; AJvYcCX712CnJ6o7yjzZBdz2N5VG5QJwPB0IrWr7w2aGoOkQBIR3Wx5rL119wnQq887A/OwpBQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzR5xeKYvtM5pNtbWwQCKDbRNvAJm06N/GU9cxW2WafkNkmmTBP
	HSfCj5zKrZIPAAc+nbhFib7IttbAQ/GX3GPtXfVZTmLxzTPVxxBz2k8ekC95PUjj8XuMKOBkPvx
	zsEaOKA==
X-Google-Smtp-Source: AGHT+IHPC1TNdjrjBaT0jJG1JbHdSMGCknpgtPEMfVyST8tA7TeHUt8tTSHbGau1hACrUhIlu50Nq9tHdxY=
X-Received: from pjbbj14.prod.google.com ([2002:a17:90b:88e:b0:340:c625:b238])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:56ce:b0:32e:64ca:e84e
 with SMTP id 98e67ed59e1d1-3491260060bmr12132414a91.15.1764944197563; Fri, 05
 Dec 2025 06:16:37 -0800 (PST)
Date: Fri, 5 Dec 2025 06:16:34 -0800
In-Reply-To: <20251205074537.17072-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205074537.17072-1-jgross@suse.com>
Message-ID: <aTLpQjsSsjQbHl3y@google.com>
Subject: Re: [PATCH 00/10] KVM: Avoid literal numbers as return values
From: Sean Christopherson <seanjc@google.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	linux-coco@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 05, 2025, Juergen Gross wrote:
> This series is the first part of replacing the use of literal numbers
> (0 and 1) as return values with either true/false or with defines.

Sorry, but NAK to using true/false.  IMO, it's far worse than 0/1.  At least 0/1
draws from the kernel's 0/-errno approach.  With booleans, the polarity is often
hard to discern without a priori knowledge of the pattern, and even then it can
be confusing.  E.g. for me, returning "true" when .set_{c,d}r() fails is unexpected,
and results in unintuitive code like this:

                if (!kvm_dr6_valid(val))
			return true;

For isolated APIs whose values aren't intented to be propagated back up to the
.handle_exit() call site, I would much rather return 0/-EINVAL.

Do you have a sketch of what the end goal/result will look like?  IIRC, last time
anyone looked at doing this (which was a few years ago, but I don't think KVM has
changed _that_ much), we backed off because a partial conversion would leave KVM
in an unwieldy and somewhat scary state.

> This work is a prelude of getting rid of the magic value "1" for
> "return to guest". I started in x86 KVM host code doing that and soon
> stumbled over lots of other use cases of the magic "1" as return value,
> especially in MSR emulation where a comment even implied this "1" was
> due to the "return to guest" semantics.
> 
> A detailed analysis of all related code paths revealed that there was
> indeed a rather clean interface between the functions using the MSR
> emulation "1" and those using the "return to guest" "1". 

Ya, we've started chipping away at the MSR stuff.  The big challenge is avoiding
subtle ABI changes related to the fixups done by kvm_do_msr_access().

