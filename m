Return-Path: <kvm+bounces-70644-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHG1M9ZBimmwIwAAu9opvQ
	(envelope-from <kvm+bounces-70644-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 21:21:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48352114652
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 21:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A1D7A301E7DC
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 20:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8DD3370EB;
	Mon,  9 Feb 2026 20:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YZXAiMMA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E393346B6
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 20:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770668498; cv=none; b=aqabix25MXLWTcS56Jg2Z9k2GTd6oZs+aupVQt97V+exohTfJ3dVWlPiHMeaxUCuA72hBP+9uSvC3Uo11N7ThdOymCntklrbgAvKmU/T/dc8naNuTAniWwGwmcEDE+xczJammUyoNyNmOiUqcw4OTVYXeGZ1jQ3OHlO9y5rJvT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770668498; c=relaxed/simple;
	bh=kvusv523KNnJrRuG7A1ERgpex2idOJxxlvuSpxWxa+g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z8st4mdBpf5v2/CrwbXphO8Xcfe1Xb7TQYEfZMy8RhErWQnB+uaOor38+to0+c5eDGNJT8wE4/e8xSfSV8BfyH9avC+j+FhPOzu1dFp7eAnFpDjGCV1lovYx02DppDyts8rQgEbU+vcJJOYVtXtXp3vpe6wFiLLkSZ4pO2LX+y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YZXAiMMA; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aad3f8367bso24563355ad.0
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 12:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770668497; x=1771273297; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hLy0aRjPsuSjAFNgZd/YjocVX7j6+8Bt/8Yl9kTSC4g=;
        b=YZXAiMMAbR0OuVyHbDMqRrunEdyObzD0JSwXU1NfhQuIyd0oC8mn8/IYplNp38gezY
         ycGRBs+b/COJTJ3r9CzExt1IsiWMGaKYab0kHku8Db+nq9Fag977NQo92o0LUIiEwURW
         p11rt87q3K9Vn+lGeFA563dlXqTKxHjcwauUbbiRVduF9rRzvcTpKze38ihgncFsSynp
         NyihtoSqa3+BG7X6JBGmP7oTyuqPZzIBUEDKASNcy+Xk70Lk4pYS7Bb5z9RyIOztZb2E
         zzt7R5TFeWTNs58GU4wSxlzX4xzwxzrZoC9jAmiETqVXJMwtuXPSFkpuGZYUb8EAl5kI
         4npQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770668497; x=1771273297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hLy0aRjPsuSjAFNgZd/YjocVX7j6+8Bt/8Yl9kTSC4g=;
        b=XKm/HEYyhUackyRZF7oC0S+lTn3eKL9Yw8WySy+Tn8pDxlBaOydPEo9C9wrWjIWh0n
         unNsiaXtpaTmp+rzfR4UeCqFt1ycFbDU/jpZaj8AamA83bV0iloiKfrwqBPAAPIodhpZ
         W1M9ESNm8LQTC9lekoHJ+ycFhSOq6j7kskonrDOkF9IssBpfoDhB0Ng+6vltXur1UwUu
         64e0gup+eYI6q0E+Ui2OsABrgHm7w8mTYJusWSWk6XAVoGcsWNJzx0fj9VfvFLCEXQiw
         94eVnJqqpg+l3WcCvbfpWsC6qzoNUXHoXT9ROd34Icx/gwHp8yunVr2U+6IviU+7hWFG
         SfQA==
X-Forwarded-Encrypted: i=1; AJvYcCUK56V6yqHjjZ51aqmFz45vF7DwUf/c9Gt9wve5iF9j/Fn5wZto7VEHAY86zQijhGjhmmk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMB6nmRWOwKos7yRSa5JUtP1pt9uSQJE4XZM4azSRGmL8z8oYV
	dukyj7TbtLMJ6ayYpghWPWw2A5VIKLp1niCGdy92QcCV2chZyVsbDVnb6u50WP9G6UtVBGYPs8R
	DwTNW3A==
X-Received: from plrd12.prod.google.com ([2002:a17:902:aa8c:b0:2aa:f9fe:334f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e783:b0:2a9:62ce:1c16
 with SMTP id d9443c01a7336-2a962ce2039mr70269995ad.43.1770668496800; Mon, 09
 Feb 2026 12:21:36 -0800 (PST)
Date: Mon, 9 Feb 2026 12:21:35 -0800
In-Reply-To: <aYZ5m5iJ_h_2wqw_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <369eaaa2b3c1425c85e8477066391bc7@huawei.com> <aYZ5m5iJ_h_2wqw_@google.com>
Message-ID: <aYpBz1wDdsDfl8Al@google.com>
Subject: Re: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found by
 KASAN/Syzkaller fuzz test (v5.10.0)
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70644-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,qemu.org:url]
X-Rspamd-Queue-Id: 48352114652
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Sean Christopherson wrote:
> On Mon, Feb 02, 2026, Zhangjiaji wrote:
> > Syzkaller hit 'KASAN: use-after-free Read in complete_emulated_mmio' bug.
> > 
> > ==================================================================
> > BUG: KASAN: use-after-free in complete_emulated_mmio+0x305/0x420
> > Read of size 1 at addr ffff888009c378d1 by task syz-executor417/984
> > 
> > CPU: 1 PID: 984 Comm: syz-executor417 Not tainted 5.10.0-182.0.0.95.h2627.eulerosv2r13.x86_64 #3 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014 Call Trace:
> > dump_stack+0xbe/0xfd
> > print_address_description.constprop.0+0x19/0x170
> > __kasan_report.cold+0x6c/0x84
> > kasan_report+0x3a/0x50
> > check_memory_region+0xfd/0x1f0
> > memcpy+0x20/0x60
> > complete_emulated_mmio+0x305/0x420
> > kvm_arch_vcpu_ioctl_run+0x63f/0x6d0
> > kvm_vcpu_ioctl+0x413/0xb20
> > __se_sys_ioctl+0x111/0x160
> > do_syscall_64+0x30/0x40
> > entry_SYSCALL_64_after_hwframe+0x67/0xd1
> > RIP: 0033:0x42477d

...

> > I've analyzed the Syzkaller output and the complete_emulated_mmio() code
> > path.  The buggy address is created in em_enter(), where it passes its local
> > variable `ulong rbp` to emulate_push(), finally ends in
> > emulator_read_write_onepage() putting the address into
> > vcpu->mmio_fragments[].data .  The bug happens when kvm guest executes an
> > "enter" instruction, and top of the stack crosses the mem page.  In that
> > case, the em_enter() function cannot complete the instruction within itself,
> > but leave the rest data (which is in the other page) to
> > complete_emulated_mmio().  When complete_emulated_mmio() starts, em_enter()
> > has exited, so local variable `ulong rbp` is also released.  Now
> > complete_emulated_mmio() trys to access vcpu->mmio_fragments[].data , and the
> > bug happened.
> > 
> > any idea?
> 
> Egad, sorry!  I had reproduced this shortly after you sent the report and prepped
> a fix, but got distracted and lost this in my inbox.
> 
> Can you test this on your end?  I repro'd by modifying a KVM-Unit-Test and hacking
> KVM to tweak the stack, so I haven't confirmed the syzkaller version.
> 
> It's a bit gross, as it abuses an unused field as scratch space, but AFAICT that's
> "fine".  The alternative would be add a dedicated field, which seems like overkill?
> 
> I'm also going to try and add a WARN to detect if the @val parameter passed to
> emulator_read_write() is ever on the kernel stack, e.g. to help detect lurking
> bugs like this one without relying on kasahn.
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index c8e292e9a24d..dacef51c2565 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1897,13 +1897,12 @@ static int em_enter(struct x86_emulate_ctxt *ctxt)
>         int rc;
>         unsigned frame_size = ctxt->src.val;
>         unsigned nesting_level = ctxt->src2.val & 31;
> -       ulong rbp;
>  
>         if (nesting_level)
>                 return X86EMUL_UNHANDLEABLE;
>  
> -       rbp = reg_read(ctxt, VCPU_REGS_RBP);
> -       rc = emulate_push(ctxt, &rbp, stack_size(ctxt));
> +       ctxt->memop.orig_val = reg_read(ctxt, VCPU_REGS_RBP);
> +       rc = emulate_push(ctxt, &ctxt->memop.orig_val, stack_size(ctxt));
>         if (rc != X86EMUL_CONTINUE)
>                 return rc;
>         assign_masked(reg_rmw(ctxt, VCPU_REGS_RBP), reg_read(ctxt, VCPU_REGS_RSP),

*sigh*

This isn't going to work.  Or rather, it's far from a complete fix, as there are
several other instructions and flows that use stack variables to service reads
and writes.  Hacking all of them to not use stack variables isn't feasible, as
flows like emulate_iret_real() and em_popa() perform multiple acceses, i.e.
hijacking an unused operand simply won't work.

I'm tempted to go with a straightforward "fix" of rejecting userspace MMIO if
the destination is on the stack, e.g. like so:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..113287612acd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8272,6 +8272,9 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
        if (!vcpu->mmio_nr_fragments)
                return X86EMUL_CONTINUE;
 
+       if (object_is_on_stack(val))
+               return X86EMUL_UNHANDLEABLE;
+
        gpa = vcpu->mmio_fragments[0].gpa;
 
        vcpu->mmio_needed = 1;

But I hate how arbitrary that is, and I'm somewhat concerned that it could break
existing setups.

I think there's a not-completely-awful solution buried in this gigantic cesspool.
The only time KVM uses on-stack variables is for qword or smaller accesses, i.e.
8 bytes in size or less.  For larger fragments, e.g. AVX to/from MMIO, the target
value will always be an operand in the emulator context.  And so rather than
disallow stack variables, for "small" fragments, we can rework the handling to
copy the value to/from each fragment on-demand instead of stashing a pointer to
the value.

This needs a _lot_ more documentation, the SEV-ES flows aren't converted, and
there is a ton of cleanup that can and should be done on top, but this appears
to work.

Note the "clobber" in complete_emulated_mmio() to fill 4096 bytes of the stack
with 0xaa, i.e. to simulate some of the stack being "freed".

---
 arch/x86/kvm/kvm_emulate.h |   8 +++
 arch/x86/kvm/x86.c         | 125 +++++++++++++++++++++++++++----------
 include/linux/kvm_host.h   |   6 +-
 3 files changed, 103 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index fb3dab4b5a53..f735158af05e 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -284,6 +284,14 @@ struct fetch_cache {
 	u8 *end;
 };
 
+/*
+ * To complete userspace MMIO and I/O reads, KVM re-emulates (NO_DECODE) the
+ * _entire_ instruction to propagate the read data to its final destination.
+ * To avoid re-reading values from memory and/or getting "stuck" on the access
+ * that triggered an exit to userspace, KVM caches all values that have been
+ * read for a given instruction, and reads from this cache instead of reading
+ * from guest memory or from userspace.
+ */
 struct read_cache {
 	u8 data[1024];
 	unsigned long pos;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..1b99de3e3236 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8109,7 +8109,7 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 
 struct read_write_emulator_ops {
-	int (*read_write_prepare)(struct kvm_vcpu *vcpu, void *val,
+	int (*read_mmio_fragment)(struct kvm_vcpu *vcpu, void *val,
 				  int bytes);
 	int (*read_write_emulate)(struct kvm_vcpu *vcpu, gpa_t gpa,
 				  void *val, int bytes);
@@ -8120,16 +8120,37 @@ struct read_write_emulator_ops {
 	bool write;
 };
 
-static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
+static int read_mmio_fragment(struct kvm_vcpu *vcpu, void *val, int bytes)
 {
-	if (vcpu->mmio_read_completed) {
-		trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes,
-			       vcpu->mmio_fragments[0].gpa, val);
-		vcpu->mmio_read_completed = 0;
-		return 1;
+	struct kvm_mmio_fragment *frag;
+	unsigned int len = bytes;
+
+	while (len && vcpu->mmio_head_fragment < vcpu->mmio_tail_fragment) {
+		int i = vcpu->mmio_head_fragment++;
+
+		if (WARN_ON_ONCE(i >= vcpu->mmio_nr_fragments))
+			break;
+
+		frag = &vcpu->mmio_fragments[i];
+		if (!frag->data) {
+			if (WARN_ON_ONCE(len < frag->len || frag->len > 8u)) {
+				pr_warn("len = %u, bytes = %u, frag->len = %u, gpa = %llx, rip = %lx\n",
+					len, bytes, frag->len, frag->gpa, kvm_rip_read(vcpu));
+				break;
+			}
+
+			memcpy(val, &frag->val, min(8u, frag->len));
+		}
+
+		val += frag->len;
+		len -= min(len, frag->len);
 	}
 
-	return 0;
+	if ((int)len == bytes)
+		return 0;
+
+	trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes, frag->gpa, val);
+	return 1;
 }
 
 static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
@@ -8150,6 +8171,11 @@ static int write_mmio(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes, void *val)
 	return vcpu_mmio_write(vcpu, gpa, bytes, val);
 }
 
+static void *mmio_frag_data(struct kvm_mmio_fragment *frag)
+{
+	return frag->data ?: &frag->val;
+}
+
 static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  void *val, int bytes)
 {
@@ -8162,12 +8188,12 @@ static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 {
 	struct kvm_mmio_fragment *frag = &vcpu->mmio_fragments[0];
 
-	memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
+	memcpy(vcpu->run->mmio.data, mmio_frag_data(frag), min(8u, frag->len));
 	return X86EMUL_CONTINUE;
 }
 
 static const struct read_write_emulator_ops read_emultor = {
-	.read_write_prepare = read_prepare,
+	.read_mmio_fragment = read_mmio_fragment,
 	.read_write_emulate = read_emulate,
 	.read_write_mmio = vcpu_mmio_read,
 	.read_write_exit_mmio = read_exit_mmio,
@@ -8226,7 +8252,13 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	WARN_ON(vcpu->mmio_nr_fragments >= KVM_MAX_MMIO_FRAGMENTS);
 	frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
 	frag->gpa = gpa;
-	frag->data = val;
+	if (bytes > 8u) {
+		frag->data = val;
+	} else {
+		frag->data = NULL;
+		if (write)
+			memcpy(&frag->val, val, bytes);
+	}
 	frag->len = bytes;
 	return X86EMUL_CONTINUE;
 }
@@ -8241,11 +8273,16 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	gpa_t gpa;
 	int rc;
 
-	if (ops->read_write_prepare &&
-		  ops->read_write_prepare(vcpu, val, bytes))
+	if (WARN_ON_ONCE(bytes > 8u && object_is_on_stack(val)))
+		return X86EMUL_UNHANDLEABLE;
+
+	if (ops->read_mmio_fragment &&
+	    ops->read_mmio_fragment(vcpu, val, bytes))
 		return X86EMUL_CONTINUE;
 
 	vcpu->mmio_nr_fragments = 0;
+	vcpu->mmio_head_fragment = 0;
+	vcpu->mmio_tail_fragment = 0;
 
 	/* Crossing a page boundary? */
 	if (((addr + bytes - 1) ^ addr) & PAGE_MASK) {
@@ -8275,7 +8312,6 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	gpa = vcpu->mmio_fragments[0].gpa;
 
 	vcpu->mmio_needed = 1;
-	vcpu->mmio_cur_fragment = 0;
 
 	vcpu->run->mmio.len = min(8u, vcpu->mmio_fragments[0].len);
 	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
@@ -11832,42 +11868,61 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	struct kvm_mmio_fragment *frag;
-	unsigned len;
+	unsigned int len;
+	u8 clobber[4096];
 
-	BUG_ON(!vcpu->mmio_needed);
+	memset(clobber, 0xaa, sizeof(clobber));
+
+	if (WARN_ON_ONCE(!vcpu->mmio_needed))
+		return -EIO;
+
+	/* Complete MMIO for the current fragment. */
+	frag = &vcpu->mmio_fragments[vcpu->mmio_tail_fragment];
 
-	/* Complete previous fragment */
-	frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment];
 	len = min(8u, frag->len);
 	if (!vcpu->mmio_is_write)
-		memcpy(frag->data, run->mmio.data, len);
+		memcpy(mmio_frag_data(frag), run->mmio.data, len);
 
 	if (frag->len <= 8) {
 		/* Switch to the next fragment. */
 		frag++;
-		vcpu->mmio_cur_fragment++;
+		vcpu->mmio_tail_fragment++;
 	} else {
+		if (WARN_ON_ONCE(!frag->data))
+			return -EIO;
+	
 		/* Go forward to the next mmio piece. */
 		frag->data += len;
 		frag->gpa += len;
 		frag->len -= len;
 	}
 
-	if (vcpu->mmio_cur_fragment >= vcpu->mmio_nr_fragments) {
+	if (vcpu->mmio_tail_fragment >= vcpu->mmio_nr_fragments) {
 		vcpu->mmio_needed = 0;
+		WARN_ON_ONCE(vcpu->mmio_head_fragment);
 
-		/* FIXME: return into emulator if single-stepping.  */
-		if (vcpu->mmio_is_write)
+		/*
+		 * Don't re-emulate the instruction for MMIO writes, as KVM has
+		 * already committed all side effects (and the emulator simply
+		 * isn't equi)
+		 *
+		 * FIXME: Return into emulator if single-stepping.
+		 */
+		if (vcpu->mmio_is_write) {
+			vcpu->mmio_tail_fragment = 0;
 			return 1;
-		vcpu->mmio_read_completed = 1;
+		}
+
 		return complete_emulated_io(vcpu);
 	}
 
+	len = min(8u, frag->len);
+
 	run->exit_reason = KVM_EXIT_MMIO;
 	run->mmio.phys_addr = frag->gpa;
 	if (vcpu->mmio_is_write)
-		memcpy(run->mmio.data, frag->data, min(8u, frag->len));
-	run->mmio.len = min(8u, frag->len);
+		memcpy(run->mmio.data, mmio_frag_data(frag), len);
+	run->mmio.len = len;
 	run->mmio.is_write = vcpu->mmio_is_write;
 	vcpu->arch.complete_userspace_io = complete_emulated_mmio;
 	return 0;
@@ -14247,15 +14302,15 @@ static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 	BUG_ON(!vcpu->mmio_needed);
 
 	/* Complete previous fragment */
-	frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment];
+	frag = &vcpu->mmio_fragments[vcpu->mmio_tail_fragment];
 	len = min(8u, frag->len);
-	if (!vcpu->mmio_is_write)
+	if (!vcpu->mmio_is_write && frag->data)
 		memcpy(frag->data, run->mmio.data, len);
 
 	if (frag->len <= 8) {
 		/* Switch to the next fragment. */
 		frag++;
-		vcpu->mmio_cur_fragment++;
+		vcpu->mmio_tail_fragment++;
 	} else {
 		/* Go forward to the next mmio piece. */
 		frag->data += len;
@@ -14263,7 +14318,7 @@ static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 		frag->len -= len;
 	}
 
-	if (vcpu->mmio_cur_fragment >= vcpu->mmio_nr_fragments) {
+	if (vcpu->mmio_tail_fragment >= vcpu->mmio_nr_fragments) {
 		vcpu->mmio_needed = 0;
 
 		// VMG change, at this point, we're always done
@@ -14303,13 +14358,14 @@ int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 
 	/*TODO: Check if need to increment number of frags */
 	frag = vcpu->mmio_fragments;
-	vcpu->mmio_nr_fragments = 1;
 	frag->len = bytes;
 	frag->gpa = gpa;
 	frag->data = data;
 
 	vcpu->mmio_needed = 1;
-	vcpu->mmio_cur_fragment = 0;
+	vcpu->mmio_nr_fragments = 1;
+	vcpu->mmio_head_fragment = 0;
+	vcpu->mmio_tail_fragment = 0;
 
 	vcpu->run->mmio.phys_addr = gpa;
 	vcpu->run->mmio.len = min(8u, frag->len);
@@ -14342,13 +14398,14 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 
 	/*TODO: Check if need to increment number of frags */
 	frag = vcpu->mmio_fragments;
-	vcpu->mmio_nr_fragments = 1;
 	frag->len = bytes;
 	frag->gpa = gpa;
 	frag->data = data;
 
 	vcpu->mmio_needed = 1;
-	vcpu->mmio_cur_fragment = 0;
+	vcpu->mmio_nr_fragments = 1;
+	vcpu->mmio_head_fragment = 0;
+	vcpu->mmio_tail_fragment = 0;
 
 	vcpu->run->mmio.phys_addr = gpa;
 	vcpu->run->mmio.len = min(8u, frag->len);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 782f4d670793..be4b9de5b8c9 100644
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
@@ -356,7 +357,8 @@ struct kvm_vcpu {
 	int mmio_needed;
 	int mmio_read_completed;
 	int mmio_is_write;
-	int mmio_cur_fragment;
+	int mmio_head_fragment;
+	int mmio_tail_fragment;
 	int mmio_nr_fragments;
 	struct kvm_mmio_fragment mmio_fragments[KVM_MAX_MMIO_FRAGMENTS];
 #endif

base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
--

