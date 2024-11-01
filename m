Return-Path: <kvm+bounces-30368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C88E19B9872
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:25:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EBCA1F22B52
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE5A1D0420;
	Fri,  1 Nov 2024 19:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n0XiUp7W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26091D0140
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730489122; cv=none; b=OEXHf/y7MsxEEASSTqkhpyNDB43VAZrTkZUU7adNl+qe/zaWkb22/w9Zgd+z8P17T3w50rQ9K1cuCbwYaa8tLl0EZrpwuMTSXYQTx9uVkRdmvthN9C/B7yuDcy3SnzsmHDg6w6sguLi/LXfu3hLJ9DJaKLTEsf+ing2OBYPPpBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730489122; c=relaxed/simple;
	bh=9CFPeGa1vUV3oMQ5Y+5FYL5Vl4au98XgJ2pT8cDYqGc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u9ZVFinvkbECObeyPhL6JES8T+qb3K4IAEGFdov/iw51E+37yXa3ACV8anj/xiDUpUmyK2uTsujIbXXQlRgCU4UiMfGQa0nAWfFuC0I/BnhakQwXN1Es0TXa72+Z7qeX9v1nOQjfJjbZiZtUuTzhj847/mb/ctuOqOrF/DKT/YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n0XiUp7W; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e35bdb6a31so44724257b3.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730489119; x=1731093919; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yBs2yPm5xuCjMgG0MW8KtsBliivZ46s1J0i4m3siP5A=;
        b=n0XiUp7WxaJIO1zbWGSVO5wZB/5w0yhjq8RQZeURUzleSCk6cf5M2HezD4fIxIAFRL
         G5bo8UifJyHnOeIS9y9H7EJ4Dhyp1YYSqKVGlYzBBgfXdhwsi8HxEqcKVKxbIsQzwvsR
         UC5brzhH+Bq4EAqxDKxYo0Nb9pXsXv4SMoxbmqI1MEoNek2p7q0WrkIwBpEbPKxCr3+b
         caJbQgL/0QrfjYc+kLWvKQvYmZwklq+fxg6unoT3qApc6OEYFEyDHlRUshW3coQdD94z
         3ekeYPxug53gaJ43OKs/ZlpKtBLn4Xgnqp+qBrHt+nl4NTejdyTzoARgqTRSzzHSm8zK
         0/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730489119; x=1731093919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yBs2yPm5xuCjMgG0MW8KtsBliivZ46s1J0i4m3siP5A=;
        b=Yg2brF/7AFgAFbyWbdU8j8Z0UwZ9s4DMCN9fUjCPsZa0Tyb8vVgfRYkAW7kzCGH8D2
         Z6AevMdh21si+9KBklZyDtVS56dohLCrCLvBQYjRQ3IR2ofWulzrCom4Iuyw0fEYLlW+
         CJgJ4Swd3FXnQLOcAZ+SkaJhEb5xCq72dZdefSCGYrzssNKThuUIecZFFqTTs82iG6jA
         Sv4Ddnk5GMq41amic6c4srVti9uaHn/F19UuRP+wRwWX4urm6sbc+fr8kp23jiUgBhT8
         s5JwofdPX2L14WG1IUNMkWWa3trWDPYBHn/Yk0Zas6KY2AO8qORzAbYGZzLmzi20kjvA
         BuOA==
X-Gm-Message-State: AOJu0YzEcOXkfXQj0Wct5x2aKcrsuCcFmWh453XF5Iid8ep2P7QkBc6i
	rQ2khY0n8ppi8bUN1rh4TzKIbsRzmFrNyhK5BQwOjB4q/mDBsgrGvwZYI7hpujMuqOhfW+xpMB0
	FfysGIWamF5NbamaB5gv3oIlP1S/5xfkLjj3Z1tijgnqZ8m1DAmzNZyBwKjGE7IVycXYC1bcBrX
	da5cA3kXldGXfvYxP5WjEktmwUgTmf
X-Google-Smtp-Source: AGHT+IGV5cmGDE6cx4EDHk/BqPbUmHUlFxHVw+QXwMJWG4c7kN9q+v1lLQBJI0JElinbAbVUG3dVbLPEsfI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:83c3:0:b0:e2b:cd96:67a6 with SMTP id
 3f1490d57ef6-e30e5a904d0mr4456276.5.1730489118808; Fri, 01 Nov 2024 12:25:18
 -0700 (PDT)
Date: Fri, 1 Nov 2024 12:25:17 -0700
In-Reply-To: <173039506428.1508883.15289868954923615228.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906221824.491834-1-mlevitsk@redhat.com> <173039506428.1508883.15289868954923615228.b4-ty@google.com>
Message-ID: <ZyUrHej3jcZFPXrd@google.com>
Subject: Re: [PATCH v4 0/4] Relax canonical checks on some arch msrs
From: Sean Christopherson <seanjc@google.com>
To: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Sean Christopherson wrote:
> On Fri, 06 Sep 2024 18:18:20 -0400, Maxim Levitsky wrote:
> > Recently we came up upon a failure where likely the guest writes
> > 0xff4547ceb1600000 to MSR_KERNEL_GS_BASE and later on, qemu
> > sets this value via KVM_PUT_MSRS, and is rejected by the
> > kernel, likely due to not being canonical in 4 level paging.
> > 
> > One of the way to trigger this is to make the guest enter SMM,
> > which causes paging to be disabled, which SMM bios re-enables
> > but not the whole 5 level. MSR_KERNEL_GS_BASE on the other
> > hand continues to contain old value.
> > 
> > [...]
> 
> Applied to kvm-x86 misc, with some massaging (see responsed to individual
> patches).  Thanks!
> 
> [1/4] KVM: x86: drop x86.h include from cpuid.h
>       https://github.com/kvm-x86/linux/commit/391bd0c520c1
> [2/4] KVM: x86: implement emul_is_noncanonical_address using is_noncanonical_address
>       https://github.com/kvm-x86/linux/commit/6c45d62536d0
> [3/4] KVM: x86: model canonical checks more precisely
>       https://github.com/kvm-x86/linux/commit/1b1336d1d858
> [4/4] KVM: nVMX: fix canonical check of vmcs12 HOST_RIP
>       https://github.com/kvm-x86/linux/commit/14a95598b6e7

FYI, I rebased misc to v6.12-rc5, as patches in another series had already been
taken through the tip tree.  New hashes:

[1/5] KVM: x86: drop x86.h include from cpuid.h
      https://github.com/kvm-x86/linux/commit/e52ad1ddd0a3
[2/5] KVM: x86: Route non-canonical checks in emulator through emulate_ops
      https://github.com/kvm-x86/linux/commit/16ccadefa295
[3/5] KVM: x86: Add X86EMUL_F_MSR and X86EMUL_F_DT_LOAD to aid canonical checks
      https://github.com/kvm-x86/linux/commit/c534b37b7584
[4/5] KVM: x86: model canonical checks more precisely
      https://github.com/kvm-x86/linux/commit/9245fd6b8531
[5/5] KVM: nVMX: fix canonical check of vmcs12 HOST_RIP
      https://github.com/kvm-x86/linux/commit/90a877216e6b

