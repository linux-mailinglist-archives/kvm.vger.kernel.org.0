Return-Path: <kvm+bounces-70726-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IH+fNGVCi2mfRwAAu9opvQ
	(envelope-from <kvm+bounces-70726-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:36:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A4311BF34
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:36:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 747F1302E7A3
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 14:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4788737FF71;
	Tue, 10 Feb 2026 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Tj9Mawj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BB41CAA7D
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 14:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770734132; cv=none; b=NOw5n+43sGTuIye2ipL4x8cRa1eyHuGyrZ9FlvDh3nwozUbfpQMp2Zj8gIgiZGhfovvE3+Osqh/rN9NmsPdtrjUKF7i1VB1H9NDggE/+Hl4WpTGuC6DKgZd5b5bCMgYpi60KIfD4gwkKPQZGWmbvbq9Gz+ljzlVtqN5ENvf/9hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770734132; c=relaxed/simple;
	bh=VnQpWo6V3EU1WRNM2jmpmp4wK5Yp/7mccmZJp/oIeXk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H8+EIMzC0yMviPzo6sel/drKXag4dNJC9drpOmrNitg6LGojuVzrRw+XCOgLe+ltHHTuPVY5KV9dvgi3dBWrioP/Uqb6jIlzxk9YunBv++vkzwmuq1EaxB2wVfMyLHO+QjG18RQBq54Supo2NW1e555m7z9Byq+LtfFxi8Dt7GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Tj9Mawj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35301003062so11572532a91.2
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 06:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770734131; x=1771338931; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1m/dqoDPG2dxYrS/cuCZ4EFUvg1uumm8Y87K346i69Y=;
        b=3Tj9MawjvHP4nAmEF/sOu8y2VtwYBz5x949CPHBWcVkHEJ3dgJtcQRLH9CVfEc3O9u
         nQcv0g9U2fxpjQPqhCN842uGYS65xF1STBFsBpC/abpDsrVfTLvj+UzXlRm6QUoREWfh
         tghkVYkgLk8AUDrky5BZtWjxLisa92uq31mYR997zr3iuCNHh3o0iJKX0pZpeJ82FGMR
         cYx6acduHmdn7sg9AHwpMG7u4v0Irer9mLsRY93YughPPgKl6HnK7Q/EZeOximzQP/9/
         djRWdh3ZwGxF2BgCOGS2yt6NMUyUEUjAZuolt68SsFx4/78YMe7zwR0oS9yVypypzCm2
         H4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770734131; x=1771338931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1m/dqoDPG2dxYrS/cuCZ4EFUvg1uumm8Y87K346i69Y=;
        b=urEN0IuhJqXCyzcGGsfTMYPfPlSJRd05mx8q/ZP76kaUGixMmfb6LbBa2GDkHvWWvt
         3I+TWFFcLbaUqyXucBf4D573ZSeokDCHklbklZHWfYviGecEiiOY+LPziYlxMKyGBEF2
         DTNBPFyKBXcqAxjOTgpq90xvNHFNRYNBaqmzl1ZQM7B8FmT+9bsm0eQqoK4uih2JYIb0
         jqwli7J2Q0Ag3Q1US4261cywqQRiid5FvBzDvcyzcS/kEnaRE8Dltc8ux/wZTmF9yBNw
         TUayxIKO/1cb4hLA2/FZMEiJ3xeCcvJv+GIBef691ZHU2lWt+2V1r4Ao0fULT4x9PN/3
         QMHg==
X-Forwarded-Encrypted: i=1; AJvYcCWgigzJoXKBd5RgOZmXkPr+BhA2MEElT7wfEbSRt0dFqh453hnR0eb7Goge6dHA/BdwvvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtWv7WeWrXkiAGbi0423FL0Jzz924thmhJalnEiDfVOKLQAimj
	kdUuYooFvS8K2OTf5d8GE+FK2Gx+PHQN9BBKk7xH+JGYsmx9cXZHVAwbmAmB+nZ7OeYabFCZHj5
	lBZEvaw==
X-Received: from pjbee13.prod.google.com ([2002:a17:90a:fc4d:b0:350:fd27:2bc8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3505:b0:354:a09a:1012
 with SMTP id 98e67ed59e1d1-354b3e3473dmr14956940a91.17.1770734130796; Tue, 10
 Feb 2026 06:35:30 -0800 (PST)
Date: Tue, 10 Feb 2026 06:35:28 -0800
In-Reply-To: <5f3e0ca5-cf60-4f07-bbc6-663b04192c49@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <369eaaa2b3c1425c85e8477066391bc7@huawei.com> <5f3e0ca5-cf60-4f07-bbc6-663b04192c49@redhat.com>
Message-ID: <aYtCMAPK4xVnE_FS@google.com>
Subject: Re: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found by
 KASAN/Syzkaller fuzz test (v5.10.0)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Zhangjiaji <zhangjiaji1@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Wangqinxiao (Tom)" <wangqinxiao@huawei.com>, 
	zhangyashu <zhangyashu2@h-partners.com>, "wangyanan (Y)" <wangyanan55@huawei.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70726-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 36A4311BF34
X-Rspamd-Action: no action

On Tue, Feb 10, 2026, Paolo Bonzini wrote:
> 
> > I've analyzed the Syzkaller output and the complete_emulated_mmio() code path.
> > The buggy address is created in em_enter(), where it passes its local variable `ulong rbp` to emulate_push(), finally ends in emulator_read_write_onepage() putting the address into vcpu->mmio_fragments[].data .
> > The bug happens when kvm guest executes an "enter" instruction, and top of the stack crosses the mem page.
> > In that case, the em_enter() function cannot complete the instruction within itself, but leave the rest data (which is in the other page) to complete_emulated_mmio().
> > When complete_emulated_mmio() starts, em_enter() has exited, so local variable `ulong rbp` is also released.
> > Now complete_emulated_mmio() trys to access vcpu->mmio_fragments[].data , and the bug happened.
> > 
> > any idea?
> 
> Ouch, the bug is certainly legit.  The easiest way to fix it is something
> like this:
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index c8e292e9a24d..1c8698139dd5 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1905,7 +1905,7 @@ static int em_enter(struct x86_emulate_ctxt *ctxt)
>  	rbp = reg_read(ctxt, VCPU_REGS_RBP);
>  	rc = emulate_push(ctxt, &rbp, stack_size(ctxt));
>  	if (rc != X86EMUL_CONTINUE)
> -		return rc;
> +		return X86EMUL_UNHANDLEABLE;

This won't do anything, rc == X86EMUL_CONTINUE when MMIO is needed.  The check
would need to be something equivalent to this hack:

	rc = emulate_push(ctxt, &rbp, stack_size(ctxt));
	if (((struct kvm_vcpu *)ctxt->vcpu)->mmio_needed)
		return X86EMUL_UNHANDLEABLE;

but that's largely a moot point.


>  	assign_masked(reg_rmw(ctxt, VCPU_REGS_RBP), reg_read(ctxt, VCPU_REGS_RSP),
>  		      stack_mask(ctxt));
>   	assign_masked(reg_rmw(ctxt, VCPU_REGS_RSP),
> 
> The hard part is auditing all similar places that lead to passing a
> local variable to emulator_read_write_onepage().
> 
> For example I found this one:
> 
> 	write_segment_descriptor(ctxt, old_tss_sel, &curr_tss_desc);
> 
> which however is caught at kvm_task_switch() and changed to an
> emulation error.
> 
> It may be a good idea to stick a defensive "vcpu->mmio_needed = false;"
> in prepare_emulation_failure_exit(), as well as
> "vcpu->arch.complete_userspace_io = NULL" both there and in
> kvm_task_switch().

Please see my other reply[*].  There are a pile of instructions and flows that
read/write using on-stack variables.  IMO, anything that relies on updating
callers is a non-starter, and I don't love the idea of simply disallowing MMIO
for any instruction that uses an on-stack variable.

[*] https://lore.kernel.org/all/aYpBz1wDdsDfl8Al@google.com

