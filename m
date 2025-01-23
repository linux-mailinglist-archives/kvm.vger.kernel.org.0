Return-Path: <kvm+bounces-36310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F092A19BCD
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 01:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CCE83AD71F
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 00:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262EF17557;
	Thu, 23 Jan 2025 00:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vYlSbZmg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE81846B5
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 00:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737592345; cv=none; b=RLid8Y5xgC6SBNIKAJr0IpkKxNm+8bqb+VMvZ7fnno3tXirUfWvEjevb6ihMBjYDJAbsUZWn1lHP2SEzK7vmBK0daddEbC5Pw/xMbS76FwpxV8KaIxYuP1xCGHdPz5z+GC472c7GqT42qz4oRkt9F2qe7S0t+CKkpTIeE6ZQL68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737592345; c=relaxed/simple;
	bh=TM33nzDjCjQduT0mnOoGoN1c3R7TrzYewMMEpbOem2w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rIiRcMFgnk94cJS5mgCFlCDFcxRK0jDi4jIKeHRIInVq4aErSacgLYtdvFi6dOqfWST9/nFS7uWHC6YJQnHagy9eGTm4zJU/Xh2rdsiNYJc/+0wgQiGGbWcqMXXtgS3YYJToCbP/jpqBiMTIDF5z4azFtKown4QU169k/YY1+M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vYlSbZmg; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2163dc0f689so8118355ad.1
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 16:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737592343; x=1738197143; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eti7sVaUcXMEqtoMCKnxd8Ta9ihl6JM2nEYMCy2F8CE=;
        b=vYlSbZmg8q8YTfy7ssq9pQYmw4S/V1Lx27ft6cF2k6+aTQBW7nL4+zSzieT4TXLX/W
         OM3YMQHfrfOZyJrIg/zoG/iZmmLmtF7oa+4eDrfEOrIeLnrDBcN8hZmRAgrX7bJWDYWd
         KWawPeWkv0MJTOpiI8Tu2xNitalLwCPkJYc54XytnjCtcv/llNgzf+Vi98bkaoHsN932
         uK+slqzGLPbcPPDz1Z9DuIh29iFRfiL+Z9j9kTPTgCLL2L/1vx7KogiWhyX3ZcxjMKTs
         lImyNf66hFie4WxbvEaTXqM4bTTm7M7AZ7RBF2TBDipQF+OrNYiJ8eu3E0V1PJCHFts8
         1mtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737592343; x=1738197143;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eti7sVaUcXMEqtoMCKnxd8Ta9ihl6JM2nEYMCy2F8CE=;
        b=vnq+C9VyTLIKFpHnaBO9J8N9I8EsW62UY4OKb9GrxynGoh5YIn2Bemfs7qf4lTMdpq
         9skJS8mV9/S6gzuTAaLSlfSW85x1mkuul9Ev9Usy+5h5F4iG2GCTgwP2hWI0LWsRFV4l
         PhtFcJ5oIFJpNnyH0cMNFa9cCHr7y1+EEtC0P2rtodUqWHHpO70oz9TG0yjmgKqhJDMF
         5LMHlFK/jViUjL2Iq1HEBDunlb85JVctT5p2YIZ+eWJ0/7NAZgwXza7Q5BxLQ/1CHC83
         q2xtJcIMoyYDqt7ofKoFwOotuGwl4HPnFHhsMNnGKVdD6/SKjV8KoCi0DPHHMqLbvVlU
         M12g==
X-Forwarded-Encrypted: i=1; AJvYcCXPHl8WTMupSu42VSLMiLG60pHvvURrbuk7Ian7RBqhvWejQAgAjVWgktOoGStaLJO+/VM=@vger.kernel.org
X-Gm-Message-State: AOJu0YypLRKcOfaFU0hMNT6NjZk7D1i3C0xwmU+/scFb+h8eKiyXgqb2
	y/sUq8IF4/dY9Rvub/fJhQJ5jUG4njLOFZCXEhWHY7JjbBI1ILJrWTIGY10FJaRry8RGySbpMvU
	o+g==
X-Google-Smtp-Source: AGHT+IG1/AUF68kfEzgxQyITEv9451JMsxy3BXBfoGM3Bwyvux3hREqXbeDNDJg8SSYHHj+rZ8O4MnClQjo=
X-Received: from pgbck17.prod.google.com ([2002:a05:6a02:911:b0:7fd:460b:daa3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a10c:b0:1e1:9ba5:80d8
 with SMTP id adf61e73a8af0-1eb215ec495mr33615284637.33.1737592343165; Wed, 22
 Jan 2025 16:32:23 -0800 (PST)
Date: Wed, 22 Jan 2025 16:32:21 -0800
In-Reply-To: <CANDhNCogn0KogQ6HQJ0+XDwoT4QQFGmqfvTJmtmi65bo=zK=9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CANDhNCq5_F3HfFYABqFGCA1bPd_+xgNj-iDQhH4tDk+wi8iZZg@mail.gmail.com>
 <Z5FVfe9RwVNr2PGI@google.com> <CANDhNCogn0KogQ6HQJ0+XDwoT4QQFGmqfvTJmtmi65bo=zK=9w@mail.gmail.com>
Message-ID: <Z5GOFVFO6ocd1sli@google.com>
Subject: Re: BUG: Occasional unexpected DR6 value seen with nested
 virtualization on x86
From: Sean Christopherson <seanjc@google.com>
To: John Stultz <jstultz@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Frederic Weisbecker <fweisbec@gmail.com>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Jim Mattson <jmattson@google.com>, 
	"Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025, John Stultz wrote:
> On Wed, Jan 22, 2025 at 12:55=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > On Tue, Jan 21, 2025, John Stultz wrote:
> > @@ -5043,6 +5041,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
> >         .set_idt =3D svm_set_idt,
> >         .get_gdt =3D svm_get_gdt,
> >         .set_gdt =3D svm_set_gdt,
> > +       .set_dr6 =3D svm_set_dr6,
>=20
>=20
> Just fyi, to get this to build (svm_set_dr6 takes a *svm not a *vcpu)
> I needed to create a little wrapper to get the types right:
>=20
> static void svm_set_dr6_vcpu(struct kvm_vcpu *vcpu, unsigned long value)
> {
>        struct vcpu_svm *svm =3D to_svm(vcpu);
>        svm_set_dr6(svm, value);
> }

Heh, yeah, I discovered as much when I tried to build wht my more generic k=
config.

> But otherwise, this looks like it has fixed the issue! I've not been
> able to trip a failure with the bionic ptrace test, nor with the debug
> test in kvm-unit-tests, both running in loops for several minutes.

FWIW, I ran the testcase in L2 for ~45 minutes and saw one failure ~3 minut=
es in,
but unfortunately I didn't have any tracing running so I have zero insight =
into
what went wrong.  I'm fairly certain the failure was due to running an unpa=
tched
kernel in L1, i.e. that I hit the ultra-rare scenario where an L2=3D>L1 fas=
tpath
exit between the #DB and read from DR6 clobbered hardware DR6.

For giggle and extra confidence, I hacked KVM to emulate HLT as a nop in th=
e
fastpath, and verified failure (and the fix) in a non-nested setup with the=
 below
selftest, on both AMD and Intel.

Sadly, KVM doesn't handle many exits in the fastpath on AMD, so having a re=
gression
test that isn't Intel-specific isn't really possible at the momemnt.  I'm m=
ildly
tempted to use testing as an excuse to handle some CPUID emulation in the f=
astpath,
as Linux userspace does a _lot_ of CPUID, e.g. a kernel build generates ten=
s of
thousands of CPUID exits.

Anyways, this all makes me confident in the fix.  I'll post it properly tom=
orrow.

diff --git a/tools/testing/selftests/kvm/x86/debug_regs.c b/tools/testing/s=
elftests/kvm/x86/debug_regs.c
index 2d814c1d1dc4..a34b65052f4e 100644
--- a/tools/testing/selftests/kvm/x86/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86/debug_regs.c
@@ -22,11 +22,25 @@ extern unsigned char sw_bp, hw_bp, write_data, ss_start=
, bd_start;
=20
 static void guest_code(void)
 {
+       unsigned long val =3D 0xffff0ffful;
+
        /* Create a pending interrupt on current vCPU */
        x2apic_enable();
        x2apic_write_reg(APIC_ICR, APIC_DEST_SELF | APIC_INT_ASSERT |
                         APIC_DM_FIXED | IRQ_VECTOR);
=20
+       /*
+        * Debug Register Interception tests.
+        */
+       asm volatile("mov %%rax, %%dr6\n\t"
+                    "hlt\n\t"
+                    "mov %%dr6, %%rax\n\t"
+                    : "+r" (val));
+
+       __GUEST_ASSERT(val =3D=3D 0xffff0ffful,
+                      "Wanted DR6 =3D 0xffff0ffful, got %lx\n", val);
+       GUEST_SYNC(0);
+
        /*
         * Software BP tests.
         *
@@ -103,6 +117,9 @@ int main(void)
        vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
        run =3D vcpu->run;
=20
+       vcpu_run(vcpu);
+       TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
+
        /* Test software BPs - int3 */
        memset(&debug, 0, sizeof(debug));
        debug.control =3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;

