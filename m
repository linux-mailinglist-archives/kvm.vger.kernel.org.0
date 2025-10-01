Return-Path: <kvm+bounces-59249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19540BAF943
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6B8E189D76E
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F8D28002B;
	Wed,  1 Oct 2025 08:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jidRShac"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2A127A465
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306931; cv=none; b=l+oO6oQZ99Fyc6o0qEYioTutW+ok1k8w8AIkpGI0t09getT2RKcyIWZGcNQ8B3qOVyx0XXHHtiQQaLHyGSVtr8SYuFX09dJTcCq9nVqid+2yb/Jnmi19xMjFKbUlgsE6z9GSd9zggPB56a/h3Bbk/dCKI3ZHN3TMM9xl918MdOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306931; c=relaxed/simple;
	bh=EjCu1VweCSnApKCVaWWWRS+JFqokTMZA9JvYDKvB5Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gqoTBkUOvxA4ISO3NYABpkB84k8/S4xdRf3sDLQo9msBmte8J8hxkMMfA8QuJJxtPeFUYOU+WjRfbcx6LikMMJmipt9qP4JhPwomOrbavrBWRa9oXVFubV6xkzjQw77mg7AoG90mpbNw1mEgqxecuYZth0XzOII04nR45hC8Xo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jidRShac; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e34052bb7so68947945e9.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306928; x=1759911728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhhq2tskzQ+RgPEYDmhVYVdDixzKo6a0xF5vcW2Lqu4=;
        b=jidRShactQVOWeNRgBpkjv/f5PJXA0BzcfdX5UH6J3k6nYDjdr1Nc7Th17NudRYnB3
         iXGlOr+tMq7cep0yViXgY6vJhCRIXQ/9Na2/FkdCEQFjKv3QLNuSnT85Xno/VqGOPM/1
         5Pjzmij8wkT2CnmHWqRzg5XabcSzugzWfV3h9UTdAew4uU9RSsKQM9UCWFWgGX8g56HH
         zjXR8NFgQDyTh15nj/AQmGScf+raNLKER5/nkngWGZOK62c/TJNUW1XJjVyyQE6zQ5IG
         N5EEDBFSnneEhm9hOLtjufbGwyPRLh4AbgshP4SYFjeJqUBX06z07OSuUCeEXUlpthJA
         4IVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306928; x=1759911728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hhhq2tskzQ+RgPEYDmhVYVdDixzKo6a0xF5vcW2Lqu4=;
        b=UnnXW0B6vf2qeYPrZSCWPFnHGEfvWQwrXVd9w0tqDSaVGEYyGsSaoNdNffG6BA1/kV
         o9bnE7XorAtlNMFKFVw3tdgon9FyXLNSi2Rg36y7C6dfZHzYeBAJN1e7S7igoKfXRCtw
         C2w1ybpHy2rTlX/TwyRh2rTiEUsCjo/Yu/NktJEtqwTAMO4/romdQBwPTAEBJ9aYQ3iK
         h9usz0kTkWK7rzbeAAXDkXwDNLM1uq3qU031RGuBN3q2Lgx3+u7kX460rML31sjmEMim
         t7NY/9D4CXCYq8pDsk6ie8FnXllrak0x8BsP7wM/FDhOOF96LZCIvSHpuxUf2wPkf/Uq
         3zVw==
X-Forwarded-Encrypted: i=1; AJvYcCWoU5HHIeXiPTmNHRHtP2+PhtCVPzrr0RW3qmb/xUi6sIXnp1YD4RKUG2+fWn5FYjHzIjc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRClXRcMuT45jsxSbbPgsxwzkmvkSTpzB3TmP2qYy2chb3oC10
	yEGB3vkjo21bQOdi33AebE5afokXM6pNyV1J3Rpg+Z+ZAaRCxKsaIEaMxT8N0UFwJKA=
X-Gm-Gg: ASbGncug4VrF2txL1M/gFXeFX8WcEh+rxu99Mt2eseHzGSTkBsRbUz8CbQQVNF4hDV3
	CDu5PWLKLQS01HAmMmUGcTs1Nv7DWP9o4/+zGmnTEORMA9ombu5dQOIB+5WeQPFrcBljVYrsjjK
	2NeQVVGgDHdyK5jxBqltq4n1r6glcrqapucExSBI+q21aJSrIbsi0Pv9qLOTtQsdPuMnwWOvwdn
	uhKV0tZvGavBT05rQq5SWi0if0MIY4lUh2YRYoCOQR32JI28t5B1U7Vp5EYe/Gi49Rr8j/LmLsC
	My7wLIaWx+FkmWzQ91BLo4e20M+30zUccYqOetTWqShqGug6vWdIblsC0goaUjzUuxtvI4+wtCB
	Xi2RA74PznmQ56YmyTlvM/q/CPDOmRkmrNzzfS3dUqcVo9AriaSkNcaYaASHqNW/Al/UjNa4iRi
	Emycb1aRVmWE+JOfQVA3pb
X-Google-Smtp-Source: AGHT+IH4vV/tAX0nQk6v1/YbP3GsfsEh9ZvIi/+Ptsdr+eTl5VsK33qrJ//K+YNtHqEFYGbK2CCT3A==
X-Received: by 2002:a05:600c:4511:b0:46e:394b:49b7 with SMTP id 5b1f17b1804b1-46e612e5d92mr21414055e9.37.1759306927524;
        Wed, 01 Oct 2025 01:22:07 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a020a3sm27838355e9.10.2025.10.01.01.22.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:22:07 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	qemu-arm@nongnu.org,
	Jagannathan Raman <jag.raman@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-s390x@nongnu.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 07/25] accel/tcg: Document rcu_read_lock is held when calling tlb_reset_dirty()
Date: Wed,  1 Oct 2025 10:21:07 +0200
Message-ID: <20251001082127.65741-8-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001082127.65741-1-philmd@linaro.org>
References: <20251001082127.65741-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/exec/cputlb.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/exec/cputlb.h b/include/exec/cputlb.h
index 9bec0e78909..db7cbf97826 100644
--- a/include/exec/cputlb.h
+++ b/include/exec/cputlb.h
@@ -31,6 +31,7 @@ void tlb_unprotect_code(ram_addr_t ram_addr);
 #endif
 
 #ifndef CONFIG_USER_ONLY
+/* Called with rcu_read_lock held. */
 void tlb_reset_dirty(CPUState *cpu, uintptr_t start, uintptr_t length);
 void tlb_reset_dirty_range_all(ram_addr_t start, ram_addr_t length);
 #endif
-- 
2.51.0


