Return-Path: <kvm+bounces-35159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43D0AA09F6E
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:33:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D9DE188EF60
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E0E18FDB2;
	Sat, 11 Jan 2025 00:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yPbSM8Ej"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A0B18C002
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555430; cv=none; b=Si0HxeJfMqrirMyHTKyFaMziq8OkMM65VfK1tZMbEf0R5HSRVdRZuS0dSMRN/mPhnHEgHYo8Bn8ostfAW98UdpPMR6In4FLP6v61FZyXoOHn0oElS9uHrL23JBcKVyo5Zv4ZUQFqOcpN5ddL3I0bnpZ+6PF+pGsFzogbDJU8HSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555430; c=relaxed/simple;
	bh=Ct3FuonCRgDJp/Ui+bQ/TVeX0BiSNd/ih2pMmElS7V4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gXZYzWl4AbbLHzsDaNIFWH+4C1kOenJl20f+vyCia/JRLgBNCcnkMfR3BPTHO32b1KsZ2odawBdpl6nhB40sWjLgnLgjfIv9uKB/i6vt5OYHw9pbPHY7Dg8POiPOhneZKuV+UY+toc5OYOZ/Atirskn1QW/Ozk7Ar8ZAyL6stjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yPbSM8Ej; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166e907b5eso49229075ad.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555429; x=1737160229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=y05jSkqCIR81O47S4buDh42roqUgkkPVJYIkUmCWrzY=;
        b=yPbSM8EjFFKFftkcwWXAmBItUdHbdwNF3ybnL5WhdGG2/71N/SLxYy2exNlx5B29SR
         goHvdSknV74JdavsCnAVtnxquX77kvOBqgY/cXM8NEDNh+tkorKYI/tmpI5fOKkDgbc9
         cG7HDahKJDLC1i6whYU1HZFq+VU8+yVEGjJZCmAiGyQN/AAHSlgH3IOyKlVaYiITIGT8
         uhNdRqJOHSxW/KedGxbDoDK0jZKLiuYDkIHNrVWBbFVAS+LUdb771U8q0el6ZOdeuiPC
         aAVfoKWVyyUbAgRN4Et4VIuqq4x3Qk3FNAR1w47DS9v1yCasEXUzwi5UEWipGSee/zK0
         YxVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555429; x=1737160229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y05jSkqCIR81O47S4buDh42roqUgkkPVJYIkUmCWrzY=;
        b=jiC3XBmFL1G0R1T/rGBM9r5iMXVAc7pAG8wopFs8spARKazW5hd22T9L2PqwHRw1q/
         WPNhy4e6IZnKI6PziwApBwCVIa2pRpIlo+6qNMGe/sBO2ujz2arKhDboUKi2Mw8uEirO
         bmZjzFiWAdu7EN0Ed/pclgVEww5Tkw2S9Zy1O7tZcgcH+SCDvMvSBMlknwaRinZ+hnl4
         bAsCrIYa1r6a0gWh5chu73lIFzeGmDkvSbXAme5pH31E6I45XRJrSlbaDbkS19NlQk2g
         69aNUOTqs6c2mVAqa+k7vl9etUdX293nPZx6jv+Nzf9viTuR+0nMKfD2sveHuI7pbYAW
         QPjA==
X-Gm-Message-State: AOJu0YyPuFoCOeB66G4u3Vf/sGLznjR4iABRtUCubTBhNRGqz6Lr26kW
	ovMiywYt7cQaSNln9k9SIy85LzkrqIQmFHTCPZ9FCtel1SSxYE2TYdq8iEHz31ggFlwS9TfnGbg
	dDw==
X-Google-Smtp-Source: AGHT+IFgrnZzIKEMTRy6t4DPba2tanrxDHSa0a90bgDXxnDvHGsIE64G7RceEr5QZnECylO0tNxGXGphF04=
X-Received: from pfbfm22.prod.google.com ([2002:a05:6a00:2f96:b0:725:c96b:b1db])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c887:b0:1e0:dc7b:4ee9
 with SMTP id adf61e73a8af0-1e88cf7ba69mr21582007637.8.1736555428699; Fri, 10
 Jan 2025 16:30:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:56 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-13-seanjc@google.com>
Subject: [PATCH v2 12/20] KVM: selftests: Use continue to handle all "pass"
 scenarios in dirty_log_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

When verifying pages in dirty_log_test, immediately continue on all "pass"
scenarios to make the logic consistent in how it handles pass vs. fail.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 8544e8425f9c..d7cf1840bd80 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -510,8 +510,6 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 		}
 
 		if (__test_and_clear_bit_le(page, bmap)) {
-			bool matched;
-
 			nr_dirty_pages++;
 
 			/*
@@ -519,9 +517,10 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 			 * the corresponding page should be either the
 			 * previous iteration number or the current one.
 			 */
-			matched = (val == iteration || val == iteration - 1);
+			if (val == iteration || val == iteration - 1)
+				continue;
 
-			if (host_log_mode == LOG_MODE_DIRTY_RING && !matched) {
+			if (host_log_mode == LOG_MODE_DIRTY_RING) {
 				if (val == iteration - 2 && min_iter <= iteration - 2) {
 					/*
 					 * Short answer: this case is special
@@ -567,10 +566,8 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 				}
 			}
 
-			TEST_ASSERT(matched,
-				    "Set page %"PRIu64" value %"PRIu64
-				    " incorrect (iteration=%"PRIu64")",
-				    page, val, iteration);
+			TEST_FAIL("Dirty page %lu value (%lu) != iteration (%lu)",
+				  page, val, iteration);
 		} else {
 			nr_clean_pages++;
 			/*
-- 
2.47.1.613.gc27f4b7a9f-goog


