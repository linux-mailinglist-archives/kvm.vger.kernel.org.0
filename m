Return-Path: <kvm+bounces-28581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B793999A17
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E96221F24233
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E901F4FD3;
	Fri, 11 Oct 2024 02:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p5mJoFqi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC79E1F4FA0
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612663; cv=none; b=n/QekuBU7zHH5iqGyUkUk4Go10qhVtZeCFvVN9cUGPah91ZlNI6csD1zwNo74uL5E0GxHKT0LfOCQ9+rvibsIEAxXXWBBgyIcLCPYAzHdMrP4VQbGnIuS2+WNCsDHELHrq7ALRKbh9pw/LLP07lyxNDSwNNXhEcfAogvRs9aquw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612663; c=relaxed/simple;
	bh=E3IXDKgcyUCE+TmbZTTwZzg1L4bUxpva3WFh9qzTdFk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hoV6b3AyW44hqnRFYp9KAvjLo5IIXOBcY8IVA18GI9gkaRmldaMlvHtYAwTgmNrnTiGZqF38cReNN8ZK+UFvrpkkzUps/STiNkVAnejYAWSEGLtFTRfqBKBbcjqZyq8hQL79HB/IMiakI29fcMy+ZwNTdJGOwjl9TJBLaKCOLN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p5mJoFqi; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e347b1e29dso3714947b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612661; x=1729217461; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vfRd4YGDidyx6Q8cdQBlESrYYtQMzsNuRjsxO0/o42k=;
        b=p5mJoFqiWrKPNXn3tzposfZ/LwMyFOC4Qi/F6zOxZZ+WzeSw961jBZGR0nNjeoUeAd
         wIutWcEuNHESvCc90p17R8Jmlizw37Vhb+OCnYJ7eDweqT0DMbvZ938z5xWzgTYHaXx4
         UNlwodEOof06CzkhBv2lWbN+KJ/SwjvTP6B9/NOElMthBbV8TgA4G5Z8SLEQP93/BJLs
         AFkkICKF+uGb7ILyteK9uzucetMrRF6M+G0B6ka9RJAJLLvSazSq3cWuWAqw0iWnj7bk
         9SgeLLPICHGUtXrSSfy109fBTNPZtVrXwjKSwxlbLXY7PiPhg//1ONlaP4uuXP7n/iiL
         SqEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612661; x=1729217461;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vfRd4YGDidyx6Q8cdQBlESrYYtQMzsNuRjsxO0/o42k=;
        b=rLTiGTlYdREJssRNrwJQ9jS8FDVsBOW+cevrt2tevSjFaDgOvO3QKRBj1IEV3b8YcH
         kpbGaLziAYchX500N/lHF6tKOryr2iyh/fYGWhtDK3LgYr4yflHc9Cf51FfIrc8CW+Uy
         Ny6KCxMEBT4X3zvIrHJY4nYqWVKzel2Mb7WlpSXuhVqEA8DIbIyXuJEec7o4aA8I6dln
         qfau+8e9pK1thmNSJl6KMXcbMpFfmxAxeyYn9gimu2UfMoc/i1VFNqTClpTLlxKnwqq7
         XWrgf3d+eEisq0+Z1mbxDcyU8ioCQRSyKf9hnH8iMSW21o/5nID6Ns0F/rSAGgEm9/77
         OOWw==
X-Gm-Message-State: AOJu0YxsL34IsGDECHrAXnggJzvrajVLwmlVDBTBHrBUUjATWZMHIO78
	IidNZ40a73IC0yzewmocpCi8Uwxzclu3765MLyuzZ9vdL1rYaGBbFX6IXuDUmrikSBpp102gbrM
	ptA==
X-Google-Smtp-Source: AGHT+IGmrtxjHtrBMHGZEUy3JQ2tvJIUU8sN8vV3zTrSpyXnDiKaHwy98K8xzQupsJi3j4s85TEUOMvXyAM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4384:b0:6e3:15a8:b26b with SMTP id
 00721157ae682-6e347c70e18mr57427b3.8.1728612660902; Thu, 10 Oct 2024 19:11:00
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:36 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-5-seanjc@google.com>
Subject: [PATCH 04/18] KVM: x86/mmu: Don't force flush if SPTE update clears
 Accessed bit
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Don't force a TLB flush if mmu_spte_update() clears the Accessed bit, as
access tracking tolerates false negatives, as evidenced by the
mmu_notifier hooks that explicitly test and age SPTEs without doing a TLB
flush.

In practice, this is very nearly a nop.  spte_write_protect() and
spte_clear_dirty() never clear the Accessed bit.  make_spte() always
sets the Accessed bit for !prefetch scenarios.  FNAME(sync_spte) only sets
SPTE if the protection bits are changing, i.e. if a flush will be needed
regardless of the Accessed bits.  And FNAME(pte_prefetch) sets SPTE if and
only if the old SPTE is !PRESENT.

That leaves kvm_arch_async_page_ready() as the one path that will generate
a !ACCESSED SPTE *and* overwrite a PRESENT SPTE.  And that's very arguably
a bug, as clobbering a valid SPTE in that case is nonsensical.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 176fc37540df..9ccfe7eba9b4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -521,36 +521,24 @@ static u64 mmu_spte_update_no_track(u64 *sptep, u64 n=
ew_spte)
  * not whether or not SPTEs were modified, i.e. only the write-tracking ca=
se
  * needs to flush at the time the SPTEs is modified, before dropping mmu_l=
ock.
  *
+ * Remote TLBs also need to be flushed if the Dirty bit is cleared, as fal=
se
+ * negatives are not acceptable, e.g. if KVM is using D-bit based PML on V=
MX.
+ *
+ * Don't flush if the Accessed bit is cleared, as access tracking tolerate=
s
+ * false negatives, and the one path that does care about TLB flushes,
+ * kvm_mmu_notifier_clear_flush_young(), uses mmu_spte_update_no_track().
+ *
  * Returns true if the TLB needs to be flushed
  */
 static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 {
-	bool flush =3D false;
 	u64 old_spte =3D mmu_spte_update_no_track(sptep, new_spte);
=20
 	if (!is_shadow_present_pte(old_spte))
 		return false;
=20
-	/*
-	 * For the spte updated out of mmu-lock is safe, since
-	 * we always atomically update it, see the comments in
-	 * spte_has_volatile_bits().
-	 */
-	if (is_mmu_writable_spte(old_spte) && !is_mmu_writable_spte(new_spte))
-		flush =3D true;
-
-	/*
-	 * Flush TLB when accessed/dirty states are changed in the page tables,
-	 * to guarantee consistency between TLB and page tables.
-	 */
-
-	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte))
-		flush =3D true;
-
-	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte))
-		flush =3D true;
-
-	return flush;
+	return (is_mmu_writable_spte(old_spte) && !is_mmu_writable_spte(new_spte)=
) ||
+	       (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte));
 }
=20
 /*
--=20
2.47.0.rc1.288.g06298d1525-goog


