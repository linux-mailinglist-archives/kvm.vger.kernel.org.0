Return-Path: <kvm+bounces-39744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F04DEA49FCB
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 18:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FFD03A84F9
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 17:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B437F1A8F9E;
	Fri, 28 Feb 2025 17:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qudce6UO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700352755F6
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 17:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740762404; cv=none; b=LLxr7M9X6l4icKDc/TsfYwbCeHlU3fmH07VvVmH7QWn80fG0ngn5FtlaBJp0EbLRhVMKvXyRtsgE28rCxlMaj2yUBGU033UM0wGzZwvttBbtOStdsXCY38wdZUyv0Y8rM9mTHKX8TlTainfLAt0+S1LxwTNdZgTo34ul/rofATA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740762404; c=relaxed/simple;
	bh=t4Q2wvZb48EBuwVjkxXT6NvgiigVHs3fMJqJwRPXbVU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dw2pGzpYppqK2JgLEr3QFTbWdmCC5WDAZWjiLYnlYlkPpARntnHYWen59lMNW9ih7EbBMeC9zNRcvbhftWd7ltQiFM0AK2nThjEtfiTX9zP7WggJBdphMQGdcjl2VlaGx1Fw0EIilzLSBZ+U3i0NpF3qrjUOUsh/m1VifsJ9uiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qudce6UO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2feb47c6757so3095372a91.3
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 09:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740762403; x=1741367203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FRALP9rAdADR/8v31ap/i2tCtixKe4fYkVAfof+oSZM=;
        b=qudce6UOOqgG4oqHIVUYSfr4gj2QEXc8i6w1I/KVVHjo+mAWThyr6Vp72hB0C9ZWsk
         IdbzO53Va9YD9RtVX3p0fxTvgY8xVl/SHI2ocCLupXgTPa9ZPkxQaX+9NMEsYwBVe56l
         8ORFLzkFfNE1eQX/XleiX17ogBLG0x8LilAVF2TC3B43fmO3TsKvZgzjpY95z75TRbTF
         2t0nU+afRQNiHOnKGeWqneGHhl/W1oWGXHBklIPETUSDDbzdf8hd2QN0ZVPU6WTfxXVD
         661dRPZGwe169wo/Tpo4lqf4c+Ajiohu+BHlAoNI84Z/30No+eO+hIIYqDG5UxbuCm+X
         wauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740762403; x=1741367203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRALP9rAdADR/8v31ap/i2tCtixKe4fYkVAfof+oSZM=;
        b=TbRWU8WtSyzGQbMmM9cjMwkcV0VTtnQaqTaTZVKTWBFBJovFxIgDYTnkBuEJCbOygo
         CwEGRIqBlVavQiol5TfY/n6cnwsrlHfi8/PjqziQZJ9+oy0mAz/c4m3hwi6fdeLwhrbd
         XFkFfeqhoAHgEBs0fDV+16FV/+TxFO0/YbzBOso2GSMitIkfoY2ff09l43ey6e9Hwy8S
         Ug7p351p2pnj/92G2NqtKdBWZcpjgnETR0+b6WE9m0qz8KzNmkIhcwnLedEb1J9K3fyN
         FMuqXj/vEJ2IdlF73En7ZzbkvopyAu9uGZpQBdjkFJcC2JrdDOohoQOQUN3D3tSJhm0O
         r8jQ==
X-Gm-Message-State: AOJu0Yzs3ber/pEoVW8jcN55dbEhqtGx692QhWPjwyJzuKzcUsZMD7GV
	uX9o9nKsLTfFPhCdEehVGUTcs08tDgMrymprotum+Xp5me4Hp9cSWjiJeexvzeZ6np2aJsHAcyb
	BDw==
X-Google-Smtp-Source: AGHT+IEt64nYiSUPrdOxTNPOPHTIAQus7w+NLV7yZ6Zn8ORHi5B6T6IMJdN9W7cs14DqDsIgbrLsbkMDvaI=
X-Received: from pjbdj8.prod.google.com ([2002:a17:90a:d2c8:b0:2fc:3022:36b4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b50:b0:2fe:8f9f:e5f0
 with SMTP id 98e67ed59e1d1-2febab702femr6127052a91.19.1740762402761; Fri, 28
 Feb 2025 09:06:42 -0800 (PST)
Date: Fri, 28 Feb 2025 09:06:26 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174041647496.2342481.7530493639328581793.b4-ty@google.com>
Subject: Re: [PATCH v2 00/11] KVM: x86: Fix emulation of (some) L2 instructions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 31 Jan 2025 17:55:07 -0800, Sean Christopherson wrote:
> Fix a variety of bugs related to emulating instructions on behalf of L2,
> and (finally) add support for synthesizing nested VM-Exit to L1 when L1
> wants to intercept an instruction (KVM currently injects a #UD into L2).
> 
> There's no real motivation behind this series.  I spotted the PAUSE_EXITING
> vs. BUS_LOCK_DETECTION goof when sorting out a report/question about HLT
> emulation in L2 doing weird things, and then stupidly thought "how hard can
> it be to generate a VM-Exit?".  Turns out, not that hard, but definitely
> a bit harder than I was anticipating due to the annoying RIP vs. next RIP
> flaw.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[01/11] KVM: nVMX: Check PAUSE_EXITING, not BUS_LOCK_DETECTION, on PAUSE emulation
        https://github.com/kvm-x86/linux/commit/f002a97ec8c9
[02/11] KVM: nSVM: Pass next RIP, not current RIP, for nested VM-Exit on emulation
        https://github.com/kvm-x86/linux/commit/c8e612bfedff
[03/11] KVM: nVMX: Allow emulating RDPID on behalf of L2
        https://github.com/kvm-x86/linux/commit/3244616aac8d
[04/11] KVM: nVMX: Emulate HLT in L2 if it's not intercepted
        https://github.com/kvm-x86/linux/commit/f43f7a215af0
[05/11] KVM: nVMX: Consolidate missing X86EMUL_INTERCEPTED logic in L2 emulation
        https://github.com/kvm-x86/linux/commit/08e3d89eb330
[06/11] KVM: x86: Plumb the src/dst operand types through to .check_intercept()
        https://github.com/kvm-x86/linux/commit/407d03fe924c
[07/11] KVM: x86: Plumb the emulator's starting RIP into nested intercept checks
        https://github.com/kvm-x86/linux/commit/9aeb9d8a6738
[08/11] KVM: x86: Add a #define for the architectural max instruction length
        https://github.com/kvm-x86/linux/commit/d4aea23fd0ff
[09/11] KVM: nVMX: Allow the caller to provide instruction length on nested VM-Exit
        https://github.com/kvm-x86/linux/commit/fbd1e0f19546
[10/11] KVM: nVMX: Synthesize nested VM-Exit for supported emulation intercepts
        https://github.com/kvm-x86/linux/commit/79a14afc6090
[11/11] KVM: selftests: Add a nested (forced) emulation intercept test for x86
        https://github.com/kvm-x86/linux/commit/2428865bf0af

--
https://github.com/kvm-x86/linux/tree/next

