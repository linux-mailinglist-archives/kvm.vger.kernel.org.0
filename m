Return-Path: <kvm+bounces-71271-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6PSSHLwnlmnxbQIAu9opvQ
	(envelope-from <kvm+bounces-71271-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:57:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3166159A9B
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:57:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 600A53014A28
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 20:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A748349B1F;
	Wed, 18 Feb 2026 20:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m2hSGXQJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732DB349B0B
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771448188; cv=none; b=qjXOA7VgcP5T2KjpLXd+j2J5j7zd66M3n+Ylxo45JqLylcav6sSLcmCvOZrfLbn766BTAeoSKwjeDzKDifeudpMqErai73mLlvnqDKDHM7C60TZRe0Bna1ulePjsUTX4/hP7TbOZomhqojVE4EPAFkw+JUQfkavKXOF1anMd+Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771448188; c=relaxed/simple;
	bh=az8pKqGTqLPKEg70OjYkXanOeX00kgot4vjebxI5Rd0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uz3V4xwRsdBASaPiEeZxAkkcYym/w5jpsAaxADV95i9pvYydtelhzmUkmTOgUuryKly7nGRtI11PEmvOCcXEh64eidZrJajbAeUXcw5GUw1vDbKdDXC691iwTC51+r52JPNchObP6QH+494nwBGLk6vYqa8/HO++3gJDMvhZWoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m2hSGXQJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c7febaefso733513a91.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 12:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771448187; x=1772052987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gre4sWSuNgzzkfFkiG0uuZShlGPNxvNAn5AYWvywWnE=;
        b=m2hSGXQJAlWbaUHKBljsoI8geiuHAv/HbSleOzF1KSGwv8+2HDC5213DKovJXr0bjI
         PM2XXLGc36moABtRJS04JGuV8mObZ4am2fhZ1wq+mFzRIwW9VfzC50BrEBb810OVOQ+r
         0PgbMxsciyHJVXEIUL7DboLv7upKETDj3NHqop6WDwLCUyxrBefnuLLkSbpUSsfa2JqV
         9NgBFJ054kFVcAhH2/pB2T2SjJEGi+R8U+uDVRq50kqY+dLjUjyjNYgTmLABPJwx0bCm
         brA7WgABuBjTxe2j0XUJq0JSYJawoA16bXzT6RFjWkq0hh5NtasYuohtH1OdX7gTgci5
         +HGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771448187; x=1772052987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gre4sWSuNgzzkfFkiG0uuZShlGPNxvNAn5AYWvywWnE=;
        b=po0RkdNYsemi/v+GArI/WFFHICK9A5MyJKO/u5Jn0U3fUlaDsWLt5lmzBtBdBg8CSm
         vWOMl7p2DWuZ1rpstH/JCmUxM+UK5fpbV/3jpnBQF1fjxhXehYvPP59ZxItUX2m+GE34
         dlgnMwqZsGAinHhsB3etV5vRGaBOh5jwWf9fwnrBzf7D0x9nt9F8mWx+AJZhGX5gHK1K
         oU9OGRPD4j8XZCwpWeXszXFGAcB+8Ln61co4u4xRBnFQmhIukD2pTO97MhiPrrtJc2fq
         RCtCXrfMx5Y5mq/mOwNgxzvkC6L08IkSwdedzc4Z7U2N+gawHJwdYO7nQeJuM5zexgiK
         oBhA==
X-Forwarded-Encrypted: i=1; AJvYcCX32WrIHc5davz5tPDixVq0+6iCesye+pvzPteRvxWt0vCnMcX1UcPemeGo/x+fw3XaJMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwButUghCjAFESLQp6sqG6KmVex1IDp7V/NAZDqgTvAlk7MzuSV
	xMYtzePws6aicUWSERuE9AguAE76URz5MuoB56iZWHggb4djNpA6zK4P9BrGLFBjF+8mZlSts1K
	1KowgrA==
X-Received: from pjzb12.prod.google.com ([2002:a17:90a:e38c:b0:353:454:939c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5704:b0:356:4c1f:98d4
 with SMTP id 98e67ed59e1d1-358890dda32mr2710883a91.13.1771448186543; Wed, 18
 Feb 2026 12:56:26 -0800 (PST)
Date: Wed, 18 Feb 2026 12:56:25 -0800
In-Reply-To: <aYuC87rMLlBYIZRc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <67a2f20537354628bcb835586a7c6255@huawei.com> <aYuC87rMLlBYIZRc@google.com>
Message-ID: <aZYneb7Dvuu-HQsP@google.com>
Subject: Re: Re: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found
 by KASAN/Syzkaller fuzz test (v5.10.0)
From: Sean Christopherson <seanjc@google.com>
To: Zhangjiaji <zhangjiaji1@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Wangqinxiao (Tom)" <wangqinxiao@huawei.com>, 
	zhangyashu <zhangyashu2@h-partners.com>, "wangyanan (Y)" <wangyanan55@huawei.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71271-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,huawei.com:email]
X-Rspamd-Queue-Id: A3166159A9B
X-Rspamd-Action: no action

On Tue, Feb 10, 2026, Sean Christopherson wrote:
> On Tue, Feb 10, 2026, Zhangjiaji wrote:
> > > I think there's a not-completely-awful solution buried in this gigantic cesspool.
> > > The only time KVM uses on-stack variables is for qword or smaller accesses, i.e.
> > > 8 bytes in size or less.  For larger fragments, e.g. AVX to/from MMIO, the target
> > > value will always be an operand in the emulator context.  And so rather than
> > > disallow stack variables, for "small" fragments, we can rework the handling to
> > > copy the value to/from each fragment on-demand instead of stashing a pointer to
> > > the value.
> > 
> > Since we can store the frag->val in struct kvm_mmio_fragment,
> > why not just point frag->data to it? This Way we can save a lot code about
> > (frag->data == NULL).
> 
> It's not quite that simple, because we need to handle reads as well.
> 
> > Though this patch will block any read-into-stack calls, we can add a special path
> > in function emulator_read_write handling feasible read-into-stack calls -- the
> > target is released just after emulator_read_write returns.
> > 
> > ---
> >  arch/x86/kvm/x86.c       | 9 ++++++++-
> >  include/linux/kvm_host.h | 3 ++-
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 72d37c8930ad..12d53d441a39 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8197,7 +8197,14 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
> >  	WARN_ON(vcpu->mmio_nr_fragments >= KVM_MAX_MMIO_FRAGMENTS);
> >  	frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
> >  	frag->gpa = gpa;
> > -	frag->data = val;
> > +	if (bytes > 8u || ! write) {
> > +		if (WARN_ON_ONCE(object_is_on_stack(val)))
> 
> This is user-triggerable, e.g. em_popa(), em_pop_sreg(), emulate_iret_real(),
> em_ret_near_imm(), em_ret_far(), and em_ret().

*sigh*

And I was wrong.  I finally sat down to write some comments for all of this, and
realized that reads _never_ pass an on-stack @val to emulator_read_write_onepage(),
because read_emulated() always buffers reads through ctxt->mem_read.

So not only is my fancy, complex code unnecessary, it's actively broken.  If a
read splits a page boundary, and the first page is NOT emulated MMIO, trying to
fulfill the read on-demand falls apart because the @val points at the start of
the operand (technically its cache "entry").  I'm sure that's a solvable problem,
but I don't see any point in manufacturing a problem in the first place.

I need to write a changelog, but as Yashu suggested, the fix can more simply be:

--
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Feb 2026 09:45:37 -0800
Subject: [PATCH 01/14] KVM: x86: Use scratch field in MMIO fragment to hold
 small write values

Fixes: f78146b0f923 ("KVM: Fix page-crossing MMIO")
Suggested-by: Yashu Zhang <zhangjiaji1@huawei.com>
Reported-by: Yashu Zhang <zhangjiaji1@huawei.com>
Closes: https://lore.kernel.org/all/369eaaa2b3c1425c85e8477066391bc7@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       | 14 +++++++++++++-
 include/linux/kvm_host.h |  3 ++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..ff3a6f86973f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8226,7 +8226,13 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	WARN_ON(vcpu->mmio_nr_fragments >= KVM_MAX_MMIO_FRAGMENTS);
 	frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
 	frag->gpa = gpa;
-	frag->data = val;
+	if (write && bytes <= 8u) {
+		frag->val = 0;
+		frag->data = &frag->val;
+		memcpy(&frag->val, val, bytes);
+	} else {
+		frag->data = val;
+	}
 	frag->len = bytes;
 	return X86EMUL_CONTINUE;
 }
@@ -8241,6 +8247,9 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	gpa_t gpa;
 	int rc;
 
+	if (WARN_ON_ONCE((bytes > 8u || !ops->write) && object_is_on_stack(val)))
+		return X86EMUL_UNHANDLEABLE;
+
 	if (ops->read_write_prepare &&
 		  ops->read_write_prepare(vcpu, val, bytes))
 		return X86EMUL_CONTINUE;
@@ -11847,6 +11856,9 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 		frag++;
 		vcpu->mmio_cur_fragment++;
 	} else {
+		if (WARN_ON_ONCE(frag->data == &frag->val))
+			return -EIO;
+
 		/* Go forward to the next mmio piece. */
 		frag->data += len;
 		frag->gpa += len;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c7d76262898..0bb2a34fb93d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -320,7 +320,8 @@ static inline bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
 struct kvm_mmio_fragment {
 	gpa_t gpa;
 	void *data;
-	unsigned len;
+	u64 val;
+	unsigned int len;
 };
 
 struct kvm_vcpu {

base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
--

