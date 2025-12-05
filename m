Return-Path: <kvm+bounces-65373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 247DFCA8B64
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 18:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DAC803022D02
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 17:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B968275AF5;
	Fri,  5 Dec 2025 17:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z0gsakCl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFAE2494FE
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 17:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764957488; cv=none; b=gN2PiTQB1zCFKaLJv+KLxBSoFJ59mi1aihKje7e1yy56iITGyz6B26WYDPwtLVVL+Vn0Qm/aKcwOxjIAPqHwki7MSZOjDRQdLcIvXGwHAtp3kkD4kQIPWY2oV3LvJieGT37Rc9ZY7yt5Wxt2ZdKsPs9TQLfbd8Z/1dUS1O7/yDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764957488; c=relaxed/simple;
	bh=QQUI98YqAhUSes4ECcGZ5WZF/olfwYiYRiq2OFls8Qw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tJP4ghFQnBVzuzGqX4B19xbdusIsg3tRsKltoB0+vM4rYpto4k8o3Al02XXifyw5+cyg5endXoKOuP8irCcHu/s6DNqlIBqKCmuHHih0lsbSS+FdHqK7UMS6o9oeKPNQmmvzs8AEAk76s0xeuFmrcdUuSvaoFfBJq8fSpfiixWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z0gsakCl; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-bcecfea0e8aso1997284a12.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 09:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764957486; x=1765562286; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tDQiNiNXKii8zF9sreLIimeyJDUOVZ5atq+rFjJQob0=;
        b=Z0gsakClYn64shX11i2bpjwg1ATLT9VzXGedfY4CmP2FFTMFyv/QtI4+OfIlGqZYdA
         CdZnds5KTOBEORevV361FHY0BXYOUZHLHYDU6wmvQ1oncWjU4vgEsdlEdFd9qG5U+k7y
         6z4yqOBXzpC/Wx9PDF8uBKIhIZu1KWXUtslirEoHzTNRL+hQmBSjUDBEIv291YpzP6tn
         H+tFZq+H3pLKrcc3galoXNKILVa6uLKWqdTAsyIQ/qLXjkCMb59DmpTq7pHsdKaHj1fr
         dyk6RFzXcgyUeYTfuZxiy2wKq/93UlbrFCBd7jCvB+OmNh4M/eE+giiOcYa15uUixr4f
         M5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764957486; x=1765562286;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tDQiNiNXKii8zF9sreLIimeyJDUOVZ5atq+rFjJQob0=;
        b=XLNAZ6Eq739xLW47qx9mNrTJ04+0nnPaat9dMgeSoSqVLE3a5Vk2Th9U+stMo6FVq2
         RbNtsFOxChkqNvN7x3A0RoGJfmWBRuTVJZxuPfBD1WMiUJ1WxI/8jAGNG6u7nxwTSZ5i
         OOWwTYcmv+BLKpJmKQRRIdKbDMG1IVJfnypWuH6JFZeo/tbCe1u1P+CPtHpZSj5Wr2yQ
         DDC/eLJWau6KRvPO7Xc8eIWmctC5YuKRg9QmvPa6tIo8p431GbjKPpSLcHsKXjq2G8nM
         XMAXZPuF7SqzsyPZtGgZ3/tCjm9uKMxwd7AaCfJ+9Qpn8sy1iyH30o6mxLXMXyQ36QAB
         jdlA==
X-Gm-Message-State: AOJu0YxPCh8f/+ysQygkIa45wvfdYP24fyhwodtJUoF59l6NBk5CgaEF
	hq7T/9zMWKVywhMwkUK5NGaVtKr6Nt4THUYSGQH334ClhY+ebHeAG/SWlorH13PLDubn4RWF+wC
	HHuKPUw==
X-Google-Smtp-Source: AGHT+IHzbaz1BIdk1fZM5ksjlas4j5qybmB0Dj9jOYXU6Ro6xEDlHzInuS5qOStSUPAiO2JLwXWaiXq5Vv4=
X-Received: from pjsa5.prod.google.com ([2002:a17:90a:be05:b0:343:7bc8:fb4e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d603:b0:343:a298:90ac
 with SMTP id 98e67ed59e1d1-34943730cfdmr7270744a91.0.1764957486054; Fri, 05
 Dec 2025 09:58:06 -0800 (PST)
Date: Fri, 5 Dec 2025 09:58:04 -0800
In-Reply-To: <45cbc005e14ea2a4b9ec803a91af63e364aeb71a.1757416809.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com> <45cbc005e14ea2a4b9ec803a91af63e364aeb71a.1757416809.git.houwenlong.hwl@antgroup.com>
Message-ID: <aTMdLPvT3gywUY6F@google.com>
Subject: Re: [PATCH 4/7] KVM: x86: Consolidate KVM_GUESTDBG_SINGLESTEP check
 into the kvm_inject_emulated_db()
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: kvm@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 10, 2025, Hou Wenlong wrote:
> Use kvm_inject_emulated_db() in kvm_vcpu_do_singlestep() to consolidate
> 'KVM_GUESTDBG_SINGLESTEP' check into kvm_inject_emulated_db() during
> emulation.
> 
> No functional change intended.
> 
> Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/x86.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5af652916a19..83960214d5d8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8632,7 +8632,10 @@ static int kvm_inject_emulated_db(struct kvm_vcpu *vcpu, unsigned long dr6)
>  {
>  	struct kvm_run *kvm_run = vcpu->run;
>  
> -	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> +	/* Data breakpoints are not supported in emulation for now. */
> +	WARN_ON((dr6 & DR6_BS) && (dr6 & DR_TRAP_BITS));

If we keep this, it should be a WARN_ON_ONCE().  We've had at least one case where
a sanity check in the emulator caused major problems because a WARN_ON() spammed
the kernel log to the point where it overloaded things :-)

But I think the WARN will be subject to false positives.  KVM doesn't emulate data
#DBs, but it does emulate code #DBs, and fault-like code #DBs can be coincident
with trap-like single-step #DBs.  Ah, but kvm_vcpu_check_code_breakpoint() doesn't
account for RFLAGS.TF.  That should probably be addressed in this series, especially
since it's consolidating KVM_GUESTDBG_SINGLESTEP handling.

