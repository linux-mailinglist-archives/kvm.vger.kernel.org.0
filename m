Return-Path: <kvm+bounces-69467-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CFzxHRy2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69467-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:21:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DF20AAAA1C
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 38B8630583A9
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50EAB3446B0;
	Thu, 29 Jan 2026 01:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r+gj6EBc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0911234105D
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649364; cv=none; b=l3z98JPVOMBn1t18X31rb0jkoqg8vvSBeTiIxCIJohMMHagRF7LOO/fQO4b/jo4tHcsEDxOaXu9oWbgfGEYOs7/0Qw1wLtk0znxvfVbD0ZzLU8EiW5VJ9MIlxeUfpigBKwDsz2r0vFQ3MAhtMbWcN5tq89h4K+6YcN4DtOQlIDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649364; c=relaxed/simple;
	bh=9SrYLBLoBg+Brv1S2Cy63Tr95H28nw4CNLfY9ahurBw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o+r42ZyaDIZEUWRHIZLlepHmjrpoudpmA1suqe+Orfy1MFASIlahO//Lp+KeEYyhl/MvBH65Jvqon9y/cP5hkIcVD+WPjlsyliohQibym2VNqOGS3hAUgLajzNNgjHVq8rM/wOUgU9Sn/9AANOkMLZfu1c6PrvsEUXvGlGMwpd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r+gj6EBc; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34cc8bf226cso375005a91.3
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649361; x=1770254161; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SvybPfEFtNPjwlwiGqMKsAxDfWeIkvf3Jbxr1ERSoXA=;
        b=r+gj6EBcaWCWPlTtfZPUhk9lI4xMzOaaLh0rtZl0FCyoFtnbLjEst50/YU+gtWsP8u
         KNSzAcPyOumXIXOS8x2AtKV7TaD61nhL+o46s6YW2nkt62G9ZXcFqLxOBNeKmqL23rpD
         OXXLKUNOAp64tT7phVstRIU4JN6UWEIyRAwA5LlgwSfn2WpDjdwBUhYo3JPJ3cL0eX/a
         /FjLHN0saVeYB3BlyhBwZ67wim9giFwvCf/oqMHmhlc3P3C3RxavOpNUtuIBFT8WC5/l
         xwUSa8rC6+4p+KyGN0I32A9N8JHzSpJzF9MaA3cubIYIcppBwIAPh/LsdrIVvPB3Hw+v
         9xdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649361; x=1770254161;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SvybPfEFtNPjwlwiGqMKsAxDfWeIkvf3Jbxr1ERSoXA=;
        b=NQixHtJM7gMGp2lmCMwWFMXLpQMKbgoVx24Sc/ATrDeknKuM3cVRBr/gRdtKO3TzxQ
         dbcoDXOfeu7Jh/MiIue3fS+GEaJl68/7rgMv91T8uOTqBlP9r4EicaHwFy3C5Uw7TvQO
         3haTsLgMowlY75P8BVf02GvW1R5R3InUCBdpRJ/n486sN2FD5r26oiiy1gDQ9WDdqz56
         +C0D6BJXyIrQusZRJXc0dmLehyOXNs5jLlvC8xdHbA4fuefASKhS0ZEUBT7Ss77quEHg
         vaCGA73IHRouEmhyzcHAOqgwIzPlSjp7WvieyaHJRijVkjZUTbvfCuJ6B8ReJ5BILoTt
         yvYw==
X-Forwarded-Encrypted: i=1; AJvYcCULVwy5mhcMoEgetRMyMqYtqlLVX5chfX1gBsbdSNvr43KBZtuhUK0IC6GqLgXZSOP8dxk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaMJcn/V+WDNoQ+trPq8OjtXG+h1S30C88e9dafxxJzs5Cf9tJ
	S5D4eK+tCg7qcHLlhcvCgyPklogmI5IYGYoQHtJtnmYMhdZrdZ3hTA6TDU1vZYfHSGvQSmZvkKR
	bHE4onQ==
X-Received: from pjzh6.prod.google.com ([2002:a17:90a:ea86:b0:352:fa90:e943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:268a:b0:353:6373:590b
 with SMTP id 98e67ed59e1d1-353fecc6720mr7267165a91.7.1769649361299; Wed, 28
 Jan 2026 17:16:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:49 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-18-seanjc@google.com>
Subject: [RFC PATCH v5 17/45] x86/virt/tdx: Optimize tdx_alloc/free_control_page()
 helpers
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69467-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: DF20AAAA1C
X-Rspamd-Action: no action

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Optimize the PAMT alloc/free helpers to avoid taking the global lock when
possible.

The recently introduced PAMT alloc/free helpers maintain a refcount to
keep track of when it is ok to reclaim and free a 4KB PAMT page. This
refcount is protected by a global lock in order to guarantee that races
don=E2=80=99t result in the PAMT getting freed while another caller request=
s it
be mapped. But a global lock is a bit heavyweight, especially since the
refcounts can be (already are) updated atomically.

A simple approach would be to increment/decrement the refcount outside of
the lock before actually adjusting the PAMT, and only adjust the PAMT if
the refcount transitions from/to 0. This would correctly allocate and free
the PAMT page without getting out of sync. But there it leaves a race
where a simultaneous caller could see the refcount already incremented and
return before it is actually mapped.

So treat the refcount 0->1 case as a special case. On add, if the refcount
is zero *don=E2=80=99t* increment the refcount outside the lock (to 1). Alw=
ays
take the lock in that case and only set the refcount to 1 after the PAMT
is actually added. This way simultaneous adders, when PAMT is not
installed yet, will take the slow lock path.

On the 1->0 case, it is ok to return from tdx_pamt_put() when the DPAMT is
not actually freed yet, so the basic approach works. Just decrement the
refcount before  taking the lock. Only do the lock and removal of the PAMT
when the refcount goes to zero.

There is an asymmetry between tdx_pamt_get() and tdx_pamt_put() in that
tdx_pamt_put() goes 1->0 outside the lock, but tdx_pamt_get() does 0-1
inside the lock. Because of this, there is a special race where
tdx_pamt_put() could decrement the refcount to zero before the PAMT is
actually removed, and tdx_pamt_get() could try to do a PAMT.ADD when the
page is already mapped. Luckily the TDX module will tell return a special
error that tells us we hit this case. So handle it specially by looking
for the error code.

The optimization is a little special, so make the code extra commented
and verbose.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Clean up code, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Tested-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/shared/tdx_errno.h |  2 +
 arch/x86/virt/vmx/tdx/tdx.c             | 69 +++++++++++++++++++------
 2 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/shared/tdx_errno.h b/arch/x86/include/asm=
/shared/tdx_errno.h
index e302aed31b50..acf7197527da 100644
--- a/arch/x86/include/asm/shared/tdx_errno.h
+++ b/arch/x86/include/asm/shared/tdx_errno.h
@@ -21,6 +21,7 @@
 #define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
 #define TDX_RND_NO_ENTROPY			0x8000020300000000ULL
 #define TDX_PAGE_METADATA_INCORRECT		0xC000030000000000ULL
+#define TDX_HPA_RANGE_NOT_FREE			0xC000030400000000ULL
 #define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
 #define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
 #define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
@@ -94,6 +95,7 @@ DEFINE_TDX_ERRNO_HELPER(TDX_SUCCESS);
 DEFINE_TDX_ERRNO_HELPER(TDX_RND_NO_ENTROPY);
 DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_INVALID);
 DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_BUSY);
+DEFINE_TDX_ERRNO_HELPER(TDX_HPA_RANGE_NOT_FREE);
 DEFINE_TDX_ERRNO_HELPER(TDX_VCPU_NOT_ASSOCIATED);
 DEFINE_TDX_ERRNO_HELPER(TDX_FLUSHVP_NOT_DONE);
 DEFINE_TDX_ERRNO_HELPER(TDX_SW_ERROR);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 682c8a228b53..d333d2790913 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2161,16 +2161,23 @@ static int tdx_pamt_get(struct page *page)
 	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
 		return 0;
=20
+	pamt_refcount =3D tdx_find_pamt_refcount(page_to_pfn(page));
+
+	/*
+	 * If the pamt page is already added (i.e. refcount >=3D 1),
+	 * then just increment the refcount.
+	 */
+	if (atomic_inc_not_zero(pamt_refcount))
+		return 0;
+
 	ret =3D alloc_pamt_array(pamt_pa_array);
 	if (ret)
 		goto out_free;
=20
-	pamt_refcount =3D tdx_find_pamt_refcount(page_to_pfn(page));
-
 	scoped_guard(spinlock, &pamt_lock) {
 		/*
-		 * If the pamt page is already added (i.e. refcount >=3D 1),
-		 * then just increment the refcount.
+		 * Lost race to other tdx_pamt_add(). Other task has already allocated
+		 * PAMT memory for the HPA.
 		 */
 		if (atomic_read(pamt_refcount)) {
 			atomic_inc(pamt_refcount);
@@ -2179,12 +2186,30 @@ static int tdx_pamt_get(struct page *page)
=20
 		/* Try to add the pamt page and take the refcount 0->1. */
 		tdx_status =3D tdh_phymem_pamt_add(page, pamt_pa_array);
-		if (WARN_ON_ONCE(!IS_TDX_SUCCESS(tdx_status))) {
+		if (IS_TDX_SUCCESS(tdx_status)) {
+			/*
+			 * The refcount is zero, and this locked path is the only way to
+			 * increase it from 0-1. If the PAMT.ADD was successful, set it
+			 * to 1 (obviously).
+			 */
+			atomic_set(pamt_refcount, 1);
+		} else if (IS_TDX_HPA_RANGE_NOT_FREE(tdx_status)) {
+			/*
+			 * Less obviously, another CPU's call to tdx_pamt_put() could have
+			 * decremented the refcount before entering its lock section.
+			 * In this case, the PAMT is not actually removed yet. Luckily
+			 * TDX module tells about this case, so increment the refcount
+			 * 0-1, so tdx_pamt_put() skips its pending PAMT.REMOVE.
+			 *
+			 * The call didn't need the pages though, so free them.
+			 */
+			atomic_set(pamt_refcount, 1);
+			goto out_free;
+		} else {
+			WARN_ON_ONCE(1);
 			ret =3D -EIO;
 			goto out_free;
 		}
-
-		atomic_inc(pamt_refcount);
 	}
=20
 	return 0;
@@ -2213,15 +2238,21 @@ static void tdx_pamt_put(struct page *page)
=20
 	pamt_refcount =3D tdx_find_pamt_refcount(page_to_pfn(page));
=20
+	/*
+	 * If the there are more than 1 references on the pamt page,
+	 * don't remove it yet. Just decrement the refcount.
+	 *
+	 * Unlike the paired call in tdx_pamt_get(), decrement the refcount
+	 * outside the lock even if it's the special 0<->1 transition. See
+	 * special logic around HPA_RANGE_NOT_FREE in tdx_pamt_get().
+	 */
+	if (!atomic_dec_and_test(pamt_refcount))
+		return;
+
 	scoped_guard(spinlock, &pamt_lock) {
-		/*
-		 * If the there are more than 1 references on the pamt page,
-		 * don't remove it yet. Just decrement the refcount.
-		 */
-		if (atomic_read(pamt_refcount) > 1) {
-			atomic_dec(pamt_refcount);
+		/* Lost race with tdx_pamt_get(). */
+		if (atomic_read(pamt_refcount))
 			return;
-		}
=20
 		/* Try to remove the pamt page and take the refcount 1->0. */
 		tdx_status =3D tdh_phymem_pamt_remove(page, pamt_pa_array);
@@ -2233,10 +2264,14 @@ static void tdx_pamt_put(struct page *page)
 		 * failure indicates a kernel bug, memory is being leaked, and
 		 * the dangling PAMT entry may cause future operations to fail.
 		 */
-		if (WARN_ON_ONCE(!IS_TDX_SUCCESS(tdx_status)))
+		if (WARN_ON_ONCE(!IS_TDX_SUCCESS(tdx_status))) {
+			/*
+			 * Since the refcount was optimistically decremented above
+			 * outside the lock, revert it if there is a failure.
+			 */
+			atomic_inc(pamt_refcount);
 			return;
-
-		atomic_dec(pamt_refcount);
+		}
 	}
=20
 	/*
--=20
2.53.0.rc1.217.geba53bf80e-goog


