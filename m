Return-Path: <kvm+bounces-59261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4207ABAF96D
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:23:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C5C63C6E56
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A40281531;
	Wed,  1 Oct 2025 08:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p7tyQB+V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CAE27A456
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306995; cv=none; b=jNa3JTopzgUGd9HpA6yxtbflv2wDpy5CrYcPeIKyC+EYMNA2Ji0yUybh+b67wSEFmF/xNbM4zLvj7Uw/k4oczbZLMg5wiKiNkZA3oeLSAXX6rcTwzz/d2ChlbQ+ae2IgEkE94L3JuLm3xyN8IPPVcE4DkIvoTsZD89Vl8pXil/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306995; c=relaxed/simple;
	bh=As3IRzEO2n2xK6IbAmrVgsckbyGUkiRiIYG08NBKJ0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W1sdDQx2mB2dfGK0PoS0Bv16vQWg4ZrSEZAkTBePixOqrRApRTLwFIxfApB+vFnYqox2ULf93CMVviep103pV+ogbZxvOcFNw8iYnr/acwuwyY1OUeI0DxVnp4wu+paZRnU+ZIw1m70YxRDl2iuKcUmJEzi84CERnfcNao/G7Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p7tyQB+V; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e2c3b6d4cso52358025e9.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306992; x=1759911792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afB/RZFwe4kGQ4M+qs4tNxazcsoE4PwZzYwGLFafQyg=;
        b=p7tyQB+VF/76aBefQ+4Mw/t+JHexuYdFOfRfqLCnKfQpaMAXRs7o5GnXsO8kMSLi1v
         y9jkPkW7DnS3pDCsn6iqbJRm311BVomlGdEPdTLQVJaGQohcHbtaNXQ2Y+hLZHgFiQxR
         D2arPwq0v2rF7Py0QFUYtjbeQ+5V1YKQgkZ9ol2r1VwgAtaPh/QL2Tw79WqxixAZAqPH
         TiTU7HPlv7kEFOW8zSKfZ2v+jyxEZ7ITx+zUKdzU6j/xrPYn9b2tNFutG78xq6Cyc3VC
         I6H1273mW9nXbuRv0HaIwiAm332YD5alQD0tQus5knVeohKD5Xkekr6ivfYYgvJMWUWj
         s7wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306992; x=1759911792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=afB/RZFwe4kGQ4M+qs4tNxazcsoE4PwZzYwGLFafQyg=;
        b=c2IFLDO3UddnmIvznwFAI93qSbzd16Y5EPw3AQER9a1RM4XxtIb/ew8KQ/CHhyrm1F
         NBPWigPTViajcqWxyFARP9DCtwgQEXwgN2tPIBz8ufA1uOu+TmmA4fuLHl+m0PhDDCYe
         GNKHXadWstnVT8rRXYglK71tdA8iTfciS3njZW+UM/NHhlNgeeCKA6n1mqb8qW5rnZAK
         ZVdave0WLH64gQp/bw/EcbCBr9R0WmYApj9LgUyTo4uD945w+s4pTVo5eP0iu2biBLyq
         VOpFkFbOoupQJcr9Ytd9BeOeddxEmPxD9fzNkReNAD6+bxGK5QJu6HT5hnzAr9xb9+dR
         NypQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYnSuoYBwAp3fkNaO1KMsvmSGDIZ2lyXUp48cDnSAzUCtw5raEYUSo1NSitXuaDJFl4LY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP8PVoInnR8vUN4oi1ysleBqyJqWHbAJrUu1kH+PJKFp9xEIKN
	iojCkDPvKDKVBx30fmHaBfwNvdyTWk6X3HmOeHC0nBfOnJM3E1EPwAnBQ6mkW6l8PvE=
X-Gm-Gg: ASbGncvbPA8yUM+bLiHql0WMwwreeCchX0S/QuXY9LwCD6xFLX/HqQvJCI7gaaaVHYT
	PqIIHyvj61v62qHCKZFc9XXZndoLFFkwj7TvBRSkg6g0xg8RPCj2vSpslZy6Hsm5VYLUT5bOBhN
	P4uWQ88em1J4rSxFMCdm9wqXH6yKDYPXpug2iOPU3TgUEt43Gz+E+uPrHVTDRzxvtjcr0OVxrCw
	VPlOQ/ILAyZ7dUf/YiBSy0CLZjd7UVQuxX7D9XNw8eit3SbxTtlH/6tOs/gDXtTJRLNbdpWFvIx
	EYhCPIXzZu05DQ1wpKaBFSO37CIRFu92o41+azTUU4QNr41fA/oQHGIaTGSbWfiaW+3v1MMGTS0
	Vj05J6OeKNXDwfMR4fKTQ62kuQT3mXi8FThUI65bI6Hv9a+zsl9qyNMH7KKAa7Ob1IGIdJBwQa5
	NT8IG3/es2vM0ZCEmR1XzEGbVI2zvNXTM=
X-Google-Smtp-Source: AGHT+IES+dNLrdEB70zhgtK1c4BlsMZT242yR2FvRNkFzHhBxS3IH+lOXPsvtn3VywwmBpBB1wjvcw==
X-Received: by 2002:a05:600c:8114:b0:46d:ba6d:65bb with SMTP id 5b1f17b1804b1-46e612dadeamr20526405e9.31.1759306992259;
        Wed, 01 Oct 2025 01:23:12 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6199fc34sm31625915e9.8.2025.10.01.01.23.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:23:11 -0700 (PDT)
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
Subject: [PATCH 19/25] system/physmem: Rename @start argument of physmem_dirty_bits_cleared()
Date: Wed,  1 Oct 2025 10:21:19 +0200
Message-ID: <20251001082127.65741-20-philmd@linaro.org>
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

Generally we want to clarify terminology and avoid confusions,
prefering @start with (exclusive) @end, and base @addr with
@length (for inclusive range).

Here as cpu_physical_memory_dirty_bits_cleared() operates on
a range, rename @start as @addr.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 4c227fee412..e65f479e266 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -166,13 +166,12 @@ uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
                                                 ram_addr_t pages);
 #endif /* not _WIN32 */
 
-static inline void cpu_physical_memory_dirty_bits_cleared(ram_addr_t start,
+static inline void cpu_physical_memory_dirty_bits_cleared(ram_addr_t addr,
                                                           ram_addr_t length)
 {
     if (tcg_enabled()) {
-        tlb_reset_dirty_range_all(start, length);
+        tlb_reset_dirty_range_all(addr, length);
     }
-
 }
 bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
                                               ram_addr_t length,
-- 
2.51.0


