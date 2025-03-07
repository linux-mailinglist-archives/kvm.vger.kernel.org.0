Return-Path: <kvm+bounces-40369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 090B1A56FFC
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:04:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 473147A8C8F
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A63821D3D6;
	Fri,  7 Mar 2025 18:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FyJlEy85"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C109918FC92
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370634; cv=none; b=KhZyYAkrd7fHNVSIjp0WknE4untIfeD3xeKQ+8XSpkbE85hCvOWVqgAhRbWAbHOMRzFF0pUcWO5EkurtiQZ/mnEPqhKANAkEQIJfA/azF7cEMWiul/YxnDcknDNLUibmHgHz/ofkTBwy9lIfvA+jdOfoOgzaHrHgreG5hQTHGA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370634; c=relaxed/simple;
	bh=ZVL1Z35KUy1EALzqodIrTZATGYJ4pO4pn0b1NrnaSzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mvCSxteEDCumwBz6e3FlMX6jDC9XZYTSpidwm8qGRzeY6tm6y9MFPIU/xtUjzxfmtcH+WFamYPak5bQtGTM70V+wME3byjrEgd9FRlQxxUv3xtnofULmSTZDXhZSQwNuFhjI5p87zb2+JV5LL9PUtNWQRYO1046hKBdawBZO2lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FyJlEy85; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39104c1cbbdso1121508f8f.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370631; x=1741975431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k75P2fUqxCLcSZyEfoYQ2NgIkqW5yPRPNiO+LCjfzGI=;
        b=FyJlEy85k69x8uWuvASuMLgSGNo20v5g+33qlIoNetd5OeNMsMbjzz+ROoKowds0XY
         aLOn96Y46d8GWqD9r24OYPQ/0pT6v1vR6gRiQDwuqjf0qLvrCRBrlSNaDbLE4Smhq/wF
         cqT5Uoj8/eyt2z4NX5MIaXxM6AmmrkiAzAsM5h2bJtY9w02TH+4gsoxvOYggbflf1Uzp
         cUDzJX+HsK5om1q9B6C6F+wclGQ3VWPsv6E4TxI4gqlPxd4CLrXP3W9cpsHh8LDm3JXw
         A9uxeoo/b8z+cTIPE2NK5OMAa0lVU0lKcZ+YBG0K/WaziJZJz4BI9GZ60lii1QwO+HCG
         VILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370631; x=1741975431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k75P2fUqxCLcSZyEfoYQ2NgIkqW5yPRPNiO+LCjfzGI=;
        b=ZLdSDC41SeY0keXHY2IZ76HmWO8UQ8bBNVCLhOhxMW8oIZ3RUO1r6leJYCkSLkqEHo
         epMBW8tGORAL5/6ly3ulczs3dQpU7BCHvd8D6CaHLfNeXZBTC1ojZUQdAaPgdD7FXRcu
         JEmorsoTfSOTZqNp5QTV1KYI2Pu8hVmw0H9Dx4Nj6rIYgKw+ONs4uHZ+jt5tRYTPiS7C
         4ByGGNsYp5OH7BDMQ8TOY1fhEvpEfUQRBPoup4QGFVzj45lMBzr6AmbW90TbZvQHxMhv
         sT5KOLw0vLh+1SNekgI7LsNqB9YIedh0zNzBayvJoBA1XKQZDoeijfJ0isUnW4NUCxrr
         fA/g==
X-Forwarded-Encrypted: i=1; AJvYcCWoONWG6H/H4iAqmPoXnG1VJ9YGIqRxWjau33KQ8CQHEn8T1uGySET/OoOZ9VwQzjYUk1c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX6QsXKf71VrSoDmfc6tjVSzUfAres5cCLMODgBrnLE9eX6Bjk
	F4yMebXCmvs4Ew4jc75wtjEbDMGbXDUfGn9O3FznvvteiHt1Ku8RpqVPyNdIkVo=
X-Gm-Gg: ASbGncsZaYnTqU8GtwxNS8vGuc7PkFuzXy1SZR38OpkD2a59BYjFayYK9t/rxoQc6/S
	vtMfQS7FE5MiMizuUCgUfnjGs8ppSkqW0PvuktbMY/2CUnSksQ3tvwmSqJwzrTAABQNxGKYVdA9
	I4gPVlJo9DLeYnxTGs7QteCzfHsDh1bYWh2ZMnAaxnTF65ZuK+l/QiNjb8Xo3/EWs9eSEemiCSM
	PC0hoVYK7b6WWgrcfFgz2CCZlcU6JGFuo1pbXqOwhkW4OID0Majo3t1KmFCCLaybKgJxXmmmTSk
	BmbuHEYIgGFuZuOsHC7Rstjxp2YMA5ANXUnYbNSadtmFKVL2r4wc++aeMrfm/8PkI6HxJM9VDQS
	plEVgRTDHIISkNTz4U34=
X-Google-Smtp-Source: AGHT+IHYEmTztSGGumLd9aL/cX0/wZGEavdogLPn/DgZYSC1IJEj6byPpvVwnQkBQTNW86k9v9l5pQ==
X-Received: by 2002:a05:6000:178d:b0:390:df02:47f0 with SMTP id ffacd0b85a97d-39132dd6b75mr2573700f8f.42.1741370630655;
        Fri, 07 Mar 2025 10:03:50 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd435c836sm87577545e9.37.2025.03.07.10.03.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:03:50 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	qemu-ppc@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Yi Liu <yi.l.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-s390x@nongnu.org,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 02/14] hw/vfio/spapr: Do not include <linux/kvm.h>
Date: Fri,  7 Mar 2025 19:03:25 +0100
Message-ID: <20250307180337.14811-3-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250307180337.14811-1-philmd@linaro.org>
References: <20250307180337.14811-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

<linux/kvm.h> is already include by "system/kvm.h" in the next line.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/spapr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
index ad4c499eafe..9b5ad05bb1c 100644
--- a/hw/vfio/spapr.c
+++ b/hw/vfio/spapr.c
@@ -11,9 +11,6 @@
 #include "qemu/osdep.h"
 #include <sys/ioctl.h>
 #include <linux/vfio.h>
-#ifdef CONFIG_KVM
-#include <linux/kvm.h>
-#endif
 #include "system/kvm.h"
 #include "exec/address-spaces.h"
 
-- 
2.47.1


