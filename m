Return-Path: <kvm+bounces-42213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73E0CA7521A
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 22:26:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B34F3A939A
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 21:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28C471F0989;
	Fri, 28 Mar 2025 21:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="29auB3hB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com [209.85.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7211E0E1A
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 21:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743197193; cv=none; b=nNr0wWtrS/22FN6iuY/mUQ4RUhYLVQzqdPkMRhpsZNjSSuyeDeewOc7a9Vfh7bOrrEjHDwJsk1KKjrXOLTF+kiZjaZMResomcE+GZZ2d0eEZEiyfrnhbQWsSOT3TViwsGBaCcwWNzRn2Ty/K5WQQwkfz8GIlRvfml1umA87nvsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743197193; c=relaxed/simple;
	bh=yecGsCrsQo1B4hn5+/Mj4gFgydWrhHzcrGDbHTeB4/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dy3pd2N8FJY0ck5fhvJB0teMnDJeWQNn7Zp9btXKAQNBuxruH9JjN//4KgXt7ivAUjiCLcldcvoC9gm5BuSe6yMXvA+/yyiRmnrh6UqFdTlOlM9Fxftuu+7kuvKlYctaLEllNkjVx0GNNeN5/IyDOvtMVcnC1ZpKQXddZMJRXWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=29auB3hB; arc=none smtp.client-ip=209.85.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f202.google.com with SMTP id 71dfb90a1353d-523eaf9631eso749893e0c.2
        for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 14:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743197189; x=1743801989; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w8m4zXBwsuwd+TpPXsReUYFUJslyYnLsiTdphFGmuAI=;
        b=29auB3hBnNZwvt2CpP7mpIlJ3yiLPYxnhdknHktsQQP01L9LADwDkTXZLpQdp+4bdC
         xnKBfiHZj87QEqz244UHmflYnh9TClFQFCjnMONdUWw/3e63JMrgjA0zw3pM0iPZAwNt
         qMYStrKlodgr+YM5yFEGkAXk0R5pHHZAy39kmxPZlVcaHSN6Hf/tN9jPyf7Xl0Yu58kM
         yzVn5ZTL1SGs9UVZcQnKHS9Cl+yND0acER7nTgIg549Zm5uz2AyIq/jr/uBvbk/NfNfX
         dHTklJa2l3mvX2TNt831NOTQSWnwzL1jqMM3BXi32sQFnJ6bcJfAAnNeEf52DXEnDQDI
         MoaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743197189; x=1743801989;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w8m4zXBwsuwd+TpPXsReUYFUJslyYnLsiTdphFGmuAI=;
        b=GUUIcc0PgjJT68aXz39YNZSRpW0Ka4mM759FEOQjOBhxSZjHVisO+ySEPpuVjzJLlx
         f7CBZFvsv9O848pzumCtnU6rHi8O6nku6obIKVULYIdDe1NULlP43M1+Ia8uo1jJhHPW
         8m909L0INuTYRv8fxIopj5VKtTPZ4G4+TyP8KPjHZRbi+Rb4PbpD5RAGwi+z8BYAuZXo
         MXaB/1DwWSGL049E6D0WzSBZsucFULlMrWCE4CFfCAYwnIjBH89l+LPdcR8o5A6LLZaT
         Hr7UX8dxnIY3gK+zsE1Ok6CtyMSPieHPlyOniAzNQdUCZfmvi8tFp79Mvv++JlMFhAMS
         CU/w==
X-Forwarded-Encrypted: i=1; AJvYcCXTxDj3hKGzm285aPWFlVnLEbdtGRo1UpzJEpis11QFEF5z/34WUpnd5eFQZ8f6pDlG/Uw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHII/p+/l8ZZdIRCSkeOyVoylbB84ROuxCtkKNlrHuyeRoz3Aw
	LNDTnQqCrp/aGAONSRQwXdPEQw2m1oSLY1Sx77vV0Q4T5GUD4UyzvGw27+qZZahxYn3gn9MSVRe
	AmAOu1KMZMdGrHUhz4A==
X-Google-Smtp-Source: AGHT+IHivVsC++z1BFup0tqwkOd7GYrq8moTlRg/GpRhWDoE3Ghyz4O+IMFvuK9BuVDldT8TyVBFOBtgde1ZgIOF
X-Received: from vkbfs2.prod.google.com ([2002:a05:6122:3b82:b0:523:87b6:c79a])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:328c:b0:523:dd87:fe86 with SMTP id 71dfb90a1353d-5261d46ad97mr1034796e0c.6.1743197189310;
 Fri, 28 Mar 2025 14:26:29 -0700 (PDT)
Date: Fri, 28 Mar 2025 21:26:27 +0000
In-Reply-To: <c04233d3c35e2bad5a864ab72d0f55b3919100f3.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c04233d3c35e2bad5a864ab72d0f55b3919100f3.camel@redhat.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250328212628.2235898-1-jthoughton@google.com>
Subject: Re: [PATCH 2/5] KVM: selftests: access_tracking_perf_test: Add option
 to skip the sanity check
From: James Houghton <jthoughton@google.com>
To: mlevitsk@redhat.com
Cc: axelrasmussen@google.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	jthoughton@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mkoutny@suse.com, seanjc@google.com, tj@kernel.org, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2025 at 12:32=E2=80=AFPM Maxim Levitsky <mlevitsk@redhat.co=
m> wrote:
>
> On Thu, 2025-03-27 at 01:23 +0000, James Houghton wrote:
> > From: Maxim Levitsky <mlevitsk@redhat.com>
> >
> > Add an option to skip sanity check of number of still idle pages,
> > and set it by default to skip, in case hypervisor or NUMA balancing
> > is detected.
> >
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > Co-developed-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > =C2=A0.../selftests/kvm/access_tracking_perf_test.c | 61 ++++++++++++++=
++---
> > =C2=A0.../testing/selftests/kvm/include/test_util.h | =C2=A01 +
> > =C2=A0tools/testing/selftests/kvm/lib/test_util.c =C2=A0 | =C2=A07 +++
> > =C2=A03 files changed, 60 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/=
tools/testing/selftests/kvm/access_tracking_perf_test.c
> > index 447e619cf856e..0e594883ec13e 100644
> > --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> > +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> > @@ -65,6 +65,16 @@ static int vcpu_last_completed_iteration[KVM_MAX_VCP=
US];
> > =C2=A0/* Whether to overlap the regions of memory vCPUs access. */
> > =C2=A0static bool overlap_memory_access;
> >=20
> > +/*
> > + * If the test should only warn if there are too many idle pages (i.e.=
, it is
> > + * expected).
> > + * -1: Not yet set.
> > + * =C2=A00: We do not expect too many idle pages, so FAIL if too many =
idle pages.
> > + * =C2=A01: Having too many idle pages is expected, so merely print a =
warning if
> > + * =C2=A0 =C2=A0 too many idle pages are found.
> > + */
> > +static int idle_pages_warn_only =3D -1;
> > +
> > =C2=A0struct test_params {
> > =C2=A0 =C2=A0 =C2=A0 /* The backing source for the region of memory. */
> > =C2=A0 =C2=A0 =C2=A0 enum vm_mem_backing_src_type backing_src;
> > @@ -177,18 +187,12 @@ static void mark_vcpu_memory_idle(struct kvm_vm *=
vm,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0* arbitrary; high enough that we ensure most=
 memory access went through
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0* access tracking but low enough as to not m=
ake the test too brittle
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0* over time and across architectures.
> > - =C2=A0 =C2=A0 =C2=A0*
> > - =C2=A0 =C2=A0 =C2=A0* When running the guest as a nested VM, "warn" i=
nstead of asserting
> > - =C2=A0 =C2=A0 =C2=A0* as the TLB size is effectively unlimited and th=
e KVM doesn't
> > - =C2=A0 =C2=A0 =C2=A0* explicitly flush the TLB when aging SPTEs. =C2=
=A0As a result, more pages
> > - =C2=A0 =C2=A0 =C2=A0* are cached and the guest won't see the "idle" b=
it cleared.
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > =C2=A0 =C2=A0 =C2=A0 if (still_idle >=3D pages / 10) {
> > -#ifdef __x86_64__
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TEST_ASSERT(this_cpu_has(X8=
6_FEATURE_HYPERVISOR),
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TEST_ASSERT(idle_pages_warn=
_only,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 "vCPU%d: Too many pages still idle (%lu out of %lu)",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 vcpu_idx, still_idle, pages);
> > -#endif
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf("WARNING: vCPU%=
d: Too many pages still idle (%lu out of %lu), "
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0"this will affect performance results.\n",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0vcpu_idx, still_idle, pages);
> > @@ -328,6 +332,31 @@ static void run_test(enum vm_guest_mode mode, void=
 *arg)
> > =C2=A0 =C2=A0 =C2=A0 memstress_destroy_vm(vm);
> > =C2=A0}
> >=20
> > +static int access_tracking_unreliable(void)
> > +{
> > +#ifdef __x86_64__
> > + =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0* When running nested, the TLB size is effectivel=
y unlimited and the
> > + =C2=A0 =C2=A0 =C2=A0* KVM doesn't explicitly flush the TLB when aging=
 SPTEs. =C2=A0As a result,
> > + =C2=A0 =C2=A0 =C2=A0* more pages are cached and the guest won't see t=
he "idle" bit cleared.
> > + =C2=A0 =C2=A0 =C2=A0*/
> Tiny nitpick: nested on KVM, because on other hypervisors it might work d=
ifferently,
> but overall most of them probably suffer from the same problem,
> so its probably better to say something like that:
>
> 'When running nested, the TLB size might be effectively unlimited,
> for example this is the case when running on top of KVM L0'

Added this clarification (see below), thanks!

This wording was left as-is from before, but I agree that it could be bette=
r.

>
>
> > + =C2=A0 =C2=A0 if (this_cpu_has(X86_FEATURE_HYPERVISOR)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 puts("Skipping idle page co=
unt sanity check, because the test is run nested");
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> > + =C2=A0 =C2=A0 }
> > +#endif
> > + =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0* When NUMA balancing is enabled, guest memory ca=
n be mapped
> > + =C2=A0 =C2=A0 =C2=A0* PROT_NONE, and the Accessed bits won't be queri=
able.
>
> Tiny nitpick: the accessed bit in this case are lost, because KVM no long=
er propagates
> it from secondary to primary paging, and the secondary mapping might be l=
ost due to zapping,
> and the biggest offender of this is NUMA balancing.

Reworded this bit. The current wording is indeed misleading.

> > + =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 if (is_numa_balancing_enabled()) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 puts("Skipping idle page co=
unt sanity check, because NUMA balancing is enabled");
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> > + =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 return 0;
> > +}
>
> Very good idea of extracting this logic into a function and documenting i=
t.

:)

> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Thanks, though I've already included your Signed-off-by. I'll just keep you=
r
Signed-off-by and From:.

I'm applying the following diff for the next version:

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tool=
s/testing/selftests/kvm/access_tracking_perf_test.c
index 0e594883ec13e..1770998c7675b 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -336,9 +336,10 @@ static int access_tracking_unreliable(void)
 {
 #ifdef __x86_64__
 	/*
-	 * When running nested, the TLB size is effectively unlimited and the
-	 * KVM doesn't explicitly flush the TLB when aging SPTEs.  As a result,
-	 * more pages are cached and the guest won't see the "idle" bit cleared.
+	 * When running nested, the TLB size may be effectively unlimited (for
+	 * example, this is the case when running on KVM L0), and KVM doesn't
+	 * explicitly flush the TLB when aging SPTEs.  As a result, more pages
+	 * are cached and the guest won't see the "idle" bit cleared.
 	 */
 	if (this_cpu_has(X86_FEATURE_HYPERVISOR)) {
 		puts("Skipping idle page count sanity check, because the test is run nes=
ted");
@@ -346,8 +347,8 @@ static int access_tracking_unreliable(void)
 	}
 #endif
 	/*
-	 * When NUMA balancing is enabled, guest memory can be mapped
-	 * PROT_NONE, and the Accessed bits won't be queriable.
+	 * When NUMA balancing is enabled, guest memory will be unmapped to get
+	 * NUMA faults, dropping the Accessed bits.
 	 */
 	if (is_numa_balancing_enabled()) {
 		puts("Skipping idle page count sanity check, because NUMA balancing is e=
nabled");

