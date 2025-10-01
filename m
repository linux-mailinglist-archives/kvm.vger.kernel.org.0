Return-Path: <kvm+bounces-59332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C7BBBB148C
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53EEE7A7166
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1620F2D238D;
	Wed,  1 Oct 2025 16:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o+nRrENQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797292D2390
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759337122; cv=none; b=X/UjyYGjTR3iSBOFi3KsHyMRm9Pj2CgHXCrCIX1/XP574dhbmIeOupmJF4hQ3cuAkBKOSubha+9RsTV8Ccgq/LF03VWlawlaY57urZU4gZRBNOTZVGSXqj+eeC1TLAzgINa6MauHr02TjlGrTCmK7mgfx4Q3BbZdunzLxRJqM9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759337122; c=relaxed/simple;
	bh=OBrWyJRSwCBu+wAfpCWoC4IvOf30Ut6XQun/mQ5/bP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2fAPshSE13bx9nVCVHFw6hmEpCSxjA6MPUKw+bIFqRAWG5PR8lE/Ns0AC5+r56Ao8qqGX93ecIasaIzx9KLcJE69wdOPpXHlKwixuHE7LXfVkEq1wFA68OuIndtFsoqiiEzyo0vEt8ONV28Gop02RadH4R+5KSb8horlJomTyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o+nRrENQ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e42fa08e4so53515e9.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759337119; x=1759941919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EDum+dhl1CD52KcXkjkndmne+c8mAKnL24q1elV6zA=;
        b=o+nRrENQpiHLnWAkVuUyO/odW0U4OVXE4ZE99er6R37ukImX8YYrLp8339wMIPpCmT
         s/EF+skIbJz2gDiq+UunS/2omdRJwbE3d3OSv2TWnstYZaGmgYDDsGJGc2oQyJDv+Xnp
         hXx2VwvF7TulUy94QfuAsbX0ErXILRiHHItaYAo5dGNPGgDn07gF1g+yyPbcb4R18W11
         Mukoag5MIj3HGpoLiiGqV5KRWuqLDoEPtETEFfZeRvmBrRcbFrxncyStxVemRlLw0uZO
         +hiB1L7zx/tWKelP+WrkVLfWZDaUztoGg04J4BB9M+khYVM2QUDyRhCD3CoM0HW7kGOV
         JH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759337119; x=1759941919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6EDum+dhl1CD52KcXkjkndmne+c8mAKnL24q1elV6zA=;
        b=Nx25OBtidng3sU3BLdrruglllP6ffOKDFt6bUDg/z8JiAqosLA8A0IIeSVZSm107I3
         psztjYjct+KSrxl27bKfe3DytLHD9WEjuweHZ0UcuWa98r+78H5aHz00mQqUnrdW9+5C
         MKMEEI1xX0R0ycrNvLB39PhKYoC2lSXUn517EK/7BzXACRnUSbrdF8ejQZDZjXaMYKvu
         fTNC97FmIpWjxGZXEkO01HwmUh18hYS9eJe6UlqDtHykTzWVuYZS7wIBF8rcf2v7zu0C
         9Mumx7lMEXIMWnmNo7KZM7a2hk08fynXvf2vs+CtaxL6skdReOZl9ACTRfWPK+NByGwA
         0pow==
X-Forwarded-Encrypted: i=1; AJvYcCVFoCAum576MjeASmzoilX8q0mQhtYDufLhTKlFkCCdP/hQFL/z0uki99Cpzstsej+D6iI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUntRY0GNefx7mdekCV2hRkmvbbdkde3TvLoXieOK3mT9s1DxK
	A2cGfdMB74/rTUShmLtq+qNLr/J5CsFtj0K6jCmEC7MAsOKOxuy12hLxCxDbfm9Yg58=
X-Gm-Gg: ASbGnctURdQ1Kj5VMdRq/+IOPw17lRl5QaJcIJqHRcg/CTB7YypHMH8UxFVR7EUjHTT
	h8bOY+KCCN0qwh7Hv+8W6NPh8l9cHdl5slXG2K00Crvx6hVfhUpyfH3gqSE41LBesxjVfGaZUey
	tO82e+BHVBCI5BFwe3+PTt289Lrs7jtfNUESoTdfenrXprYaQ2AvnbSgkPKEEKnlrUEcZPKLZ83
	tXpMrmi9mVTMk59ut1BsctjPihiiIeCzTOu1Ao+9/D9rJFFk5tW+lTK5suSQsvLduMt00lIa9sN
	lyzcrz/5TwBE7a3nAon/lUqYVDo8GLa48bpNz0QlFfIdgbVyUwVsXuugGbAR0i8HEZ56w1fGw6d
	r++wLskUbdS80bwB5gto2FXXMW34m/JqBn7QoGNhWnB9PApkw1lFqhKiyTJ4QWP9StSitTnlK15
	arUlb07e9//Ns6s+VWDVF4
X-Google-Smtp-Source: AGHT+IFuoJIVwwuSQuz/IALkeQo4mbooTvN92OPoQ5bAMU1DhLeX3idgzhWXiJutaq+0+/Xb8si8zQ==
X-Received: by 2002:a05:600c:4f91:b0:46e:4a30:2b0f with SMTP id 5b1f17b1804b1-46e612dd093mr36263585e9.29.1759337118163;
        Wed, 01 Oct 2025 09:45:18 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc6921bcfsm30183370f8f.43.2025.10.01.09.45.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 09:45:17 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 4/6] system/ramblock: Use ram_addr_t in ram_block_discard_guest_memfd_range
Date: Wed,  1 Oct 2025 18:44:54 +0200
Message-ID: <20251001164456.3230-5-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001164456.3230-1-philmd@linaro.org>
References: <20251001164456.3230-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rename @start as @offset, since it express an offset within a RAMBlock.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ramblock.h | 3 ++-
 system/physmem.c          | 8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 530c5a2e4c2..839d8a070c1 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -104,7 +104,8 @@ struct RamBlockAttributes {
 };
 
 int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
-int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
+/* @offset: the offset within the RAMBlock */
+int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t offset,
                                         size_t length);
 
 RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
diff --git a/system/physmem.c b/system/physmem.c
index 3766fae0aba..2bfddb3db52 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3920,7 +3920,7 @@ err:
     return ret;
 }
 
-int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
+int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t offset,
                                         size_t length)
 {
     int ret = -1;
@@ -3928,17 +3928,17 @@ int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
 #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
     /* ignore fd_offset with guest_memfd */
     ret = fallocate(rb->guest_memfd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-                    start, length);
+                    offset, length);
 
     if (ret) {
         ret = -errno;
         error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
-                     __func__, rb->idstr, start, length, ret);
+                     __func__, rb->idstr, offset, length, ret);
     }
 #else
     ret = -ENOSYS;
     error_report("%s: fallocate not available %s:%" PRIx64 " +%zx (%d)",
-                 __func__, rb->idstr, start, length, ret);
+                 __func__, rb->idstr, offset, length, ret);
 #endif
 
     return ret;
-- 
2.51.0


