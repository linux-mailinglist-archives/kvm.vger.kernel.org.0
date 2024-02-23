Return-Path: <kvm+bounces-9452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2EA8607CB
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:44:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F729B237EC
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 00:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6BB47F;
	Fri, 23 Feb 2024 00:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B9DH6Gm+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E69EBA2B
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 00:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708648991; cv=none; b=oh2xfrotxiLlGzQ2yJtI8oP0fs90UFamsr8WeulALmxzvdJhvEf7pCYkVigut190zGwBhpvRpfX5cD1yhDSm1VV/NuO4V0dGTDalCVLPIDFSaRexWsqWmHKCG/4u5hP6IVM2lUU3n0zlzQrSaYGdzc+6TxNgDSHsAh2Fi/URKFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708648991; c=relaxed/simple;
	bh=LW9qJDJFMZKoAzuMjM4EnMGD9KOMiSIoIkVhiiIE6n0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iIWlJhSAumOZS0DKt9dThnTTR98/GGBEuMFU1s94PD70VoZfka0Xq/hAVxJ1Fr7goDRkc5oAGIZY4GAJWO/WoDoQkmxp5es0dKRlRrTWzK0cSFIApb6dRKlC1Q7WPfoR749A7aCB+ZJnlJb/JCbKMHXiHheyphxBfyCKVQR+nHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B9DH6Gm+; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e44fd078bdso170082b3a.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708648987; x=1709253787; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jhSBUfusWJ3ofLKWMGpg2YDRgo1XDnuJP2HRidQqwH4=;
        b=B9DH6Gm+C1X6H3ks87B4mfBgcd9wrOAVOYx/XLoU3zt5slGPbI/pgo0jjo+yt4Nwdw
         Wz85tdd0ojV9EgE3ccGgA5+2lkUmmnmrSYx+tpsSBbmdezCatTEAoP6pwSExWNvIUnQF
         NQUKEFL8v0FM2Oj1S12koT0uc1vdPpxgJVUK7qSZxdk2yJcrBw5oXcG+jWjRh504m5jg
         pSncjC1jPFGfNMAo2sZ6hA82ct9ONR47tX+iptXOqSoDjFZwOO2ZNUQ+eU+J6/y+IgZO
         9r6QxDfl2C1Je6cforf+10ZtutDNe8LKpAkEm5JyiqFWQ8hsPZjSR20seimLstRlrm5B
         JZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708648987; x=1709253787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jhSBUfusWJ3ofLKWMGpg2YDRgo1XDnuJP2HRidQqwH4=;
        b=mPYmer/FBnTl9r2fseRPuqJPGzfueBHXfROq8447mWdfIWogfqbwAbEntIWqmrYAza
         wGOzliVSCkHDucmafxejfBIiSMx/PxFNHbK6yWWKPon3DOTFIO0gmFMzV1RnMWsHMzQR
         tYebhI816YdU467QoZwaUFscBf3PJ7JkHeml1AgTTZQlNzaTuHD/AMRq+RD6sdoDTQNb
         xeQndtHkJOHuvbFhBaJq6zHPgI3B4zuKTPzfe4tESPD0Rm6j7GfncT73UOQ7gl1U21go
         KPgIhOPpA6bDY9zv10+23oXTQ6tMXK14CL3swWovx7Wc4bo1d6LrmJFR62VNnR/8NYGN
         WdOg==
X-Gm-Message-State: AOJu0YwjEybwj2w9BCBkLdXCVM3Qui7cHlcE6kGgS+2zaxa+5jXyUjMl
	tmoWe2ouxG2Qe+c1QwkAuC9/tnsDiz586LfN/3YUccFZKEdUCtLjNb3gCyd0w89mRSqAAi3Z4wn
	u5A==
X-Google-Smtp-Source: AGHT+IHIxuf373oGf69Al+lWSIf6Q+TRpWLvL/aYM1tJ8IvZSlPzsioXOjltEzRkvK0lvpvWJZPUowBn/iU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:22cd:b0:6e4:643e:e215 with SMTP id
 f13-20020a056a0022cd00b006e4643ee215mr24254pfj.3.1708648987517; Thu, 22 Feb
 2024 16:43:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:50 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-4-seanjc@google.com>
Subject: [PATCH v9 03/11] KVM: selftests: Add a macro to iterate over a
 sparsebit range
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Add sparsebit_for_each_set_range() to allow iterator over a range of set
bits in a range.  This will be used by x86 SEV guests to process protected
physical pages (each such page needs to be encrypted _after_ being "added"
to the VM).

Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
[sean: split to separate patch]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/sparsebit.h | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/sparsebit.h b/tools/testing/selftests/kvm/include/sparsebit.h
index fb5170d57fcb..bc760761e1a3 100644
--- a/tools/testing/selftests/kvm/include/sparsebit.h
+++ b/tools/testing/selftests/kvm/include/sparsebit.h
@@ -66,6 +66,26 @@ void sparsebit_dump(FILE *stream, const struct sparsebit *sbit,
 		    unsigned int indent);
 void sparsebit_validate_internal(const struct sparsebit *sbit);
 
+/*
+ * Iterate over an inclusive ranges within sparsebit @s. In each iteration,
+ * @range_begin and @range_end will take the beginning and end of the set
+ * range, which are of type sparsebit_idx_t.
+ *
+ * For example, if the range [3, 7] (inclusive) is set, within the
+ * iteration,@range_begin will take the value 3 and @range_end will take
+ * the value 7.
+ *
+ * Ensure that there is at least one bit set before using this macro with
+ * sparsebit_any_set(), because sparsebit_first_set() will abort if none
+ * are set.
+ */
+#define sparsebit_for_each_set_range(s, range_begin, range_end)         \
+	for (range_begin = sparsebit_first_set(s),                      \
+	     range_end = sparsebit_next_clear(s, range_begin) - 1;	\
+	     range_begin && range_end;                                  \
+	     range_begin = sparsebit_next_set(s, range_end),            \
+	     range_end = sparsebit_next_clear(s, range_begin) - 1)
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.44.0.rc0.258.g7320e95886-goog


