Return-Path: <kvm+bounces-40370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB09AA56FFD
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:04:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C467918913DB
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288321607A4;
	Fri,  7 Mar 2025 18:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DHnVm6y2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865D9217670
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370640; cv=none; b=c+JZbTAHWcgD6+c5B32/j3fb2Y4Qxu/OZZLy7i0BaQNJLIAHhFxuFo/qx+WhasQheBDftOflbtAuu5rugYY1wV7HvNfEAfOlKnQgZewhXRl13TfemQJ1/AsJyHJmu5+EmeyYfBdDsLqrzxCBkicuCFkxoqKDw9lbKL8doey0NWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370640; c=relaxed/simple;
	bh=+x0LQtWFXmuqzfMewREHvnNtInYH8RIrOAuVxKSpcPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oqSMxdSlNh6Nd/hBQzhQltDvRLgnz1lzBzxQGlzkAcK9rmQ48bUX3NdKoA7HhWL5qfZ81JlOB/eqCVhGqjSGFkBvHxXey/Ki0fXJy0uU+qfriZZbilFLYP1QGZ5a3/J3KK95AqUm0xnXdE90yBRYUK1LIB30Jh3VXkzz342vcEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DHnVm6y2; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43bc30adad5so13636615e9.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370637; x=1741975437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krlUeIQnTGSREObLa/ECb/a6wxL5+gnrd7UhE7/j7Y4=;
        b=DHnVm6y2L+Utulp1ba4juet6iej0qMUNxXWpNl2zRNlFy9jCEvThkAsATDEAiaEpyr
         lERfrDVQwamodBBr/ts2WHM6pXzf3orPHPcme4ys5N4RZVRvBzTOc2X5I5r1/WIoQ1Pz
         DzJL9hh53SujBCeW70Fzea4wcOok+LeWdZ8WYit+kxpAeqsrsEd2uw7p+w7rLvud0ZsR
         W+1gsOgOV1hk0KXKi4Gub+3/cLoQJQuZnb7vhf9ijTxg+IeWX9z9hI/2ifLew2rnymsO
         Y91lxmXNaYXT9zVjWC92ZwgExjWh3+T1A+gGAYdrJmcBUhMHbuHUFxF6+V0II/+8u2Ie
         OiQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370637; x=1741975437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=krlUeIQnTGSREObLa/ECb/a6wxL5+gnrd7UhE7/j7Y4=;
        b=Ddm8bnYuVrg7PO1v07zFEZHTvfbumyToo5W4jRknQD1m7XVyW0t3JPNGuOY2vUtQR6
         6amv1AMgpIC3O+cuMZ/KbZ6hPKNHKnFEpRE4OkD096WqLXisw/jswROWWJ8Iubp1jxXs
         /sXh1rnSKZwnDc4rB5jccNdPsrQJgF/5g1sFOJSCszQXdT1+AQjcR0xjEkOMgGH9x/wB
         RPf+NQZLZYnRmGfB6n4rkJA3T6c+KnYZRer9nPlbM9MdvGhfVSkLwKXgfzcI8z6YU3DQ
         KlWnkyWwtbzc2DZyWHpfwyQRrSKRJlt/cytAc0V67DpHEc1hmF51rhriz0f9X25qjceA
         4ZRw==
X-Forwarded-Encrypted: i=1; AJvYcCUezcWVKaODlsk7Oq0U5XK6wWJhv14cVIvVRtOVZuFQk3FmOpn9j4dLrLq57+hHQFqvZYY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhX6ZMwj7p/j8sLF0mldhgrKnfN86gR/Td0l1/WVfFtC41Fv0M
	gRQMmzUkYqgLYSpDdNYxIhSJPBHFWdZShELZc9JJhH04l1SP3b8ini2xBXq6g7s=
X-Gm-Gg: ASbGncvLuVcjoGNydxqhX/Swo4HdXdegduMcfK+B4yLMgoTRmoe6xU5gqc9HXkDvnfm
	M1hO6Mjb9dR7J8FXJgeJLi7UhROMF+dlwWr/dDnQnAH6pvx4Od9NHZSgjGxITeos2yvgXvC+mYV
	fqimRIXDv5Z4W8yvmJcvNu7OITR/vSuchflw1vJXoAcV6YoJ+YzSdmIcdKtsSMuWSozZZEdJjQ/
	/fIWZQrcGeL1nhy2MyZsepBZT2cRJyLEFNEgHXw0ddl5Md/v1d2GOe++qFA9QQgtiVT/X7V/UE1
	jpGsFqXSY9h/Ix3rRFTV+DXDqDqMOTznDalCeRAw+YVArLx6f8h5wmfDeAc39ymH2mngk3p6jw+
	DoBaGT62TBwzl8KDxoF0=
X-Google-Smtp-Source: AGHT+IGu5Q1YPuPmBb8fk1NDTqZebT4A1/g6W7nPx0JHWu+hxOl2cltZSz5gJGPwWO4yjdIb8BwaRQ==
X-Received: by 2002:a05:600c:26cc:b0:43b:c390:b77f with SMTP id 5b1f17b1804b1-43cb91c5affmr23555105e9.26.1741370636721;
        Fri, 07 Mar 2025 10:03:56 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd4352e29sm87392995e9.32.2025.03.07.10.03.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:03:56 -0800 (PST)
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
Subject: [PATCH 03/14] hw/vfio: Compile some common objects once
Date: Fri,  7 Mar 2025 19:03:26 +0100
Message-ID: <20250307180337.14811-4-philmd@linaro.org>
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

Some files don't rely on any target-specific knowledge
and can be compiled once:

 - helpers.c
 - container-base.c
 - migration.c (removing unnecessary "exec/ram_addr.h")
 - migration-multifd.c
 - cpr.c

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/migration.c |  1 -
 hw/vfio/meson.build | 13 ++++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
index 416643ddd69..fbff46cfc35 100644
--- a/hw/vfio/migration.c
+++ b/hw/vfio/migration.c
@@ -27,7 +27,6 @@
 #include "qapi/error.h"
 #include "qapi/qapi-events-vfio.h"
 #include "exec/ramlist.h"
-#include "exec/ram_addr.h"
 #include "pci.h"
 #include "trace.h"
 #include "hw/hw.h"
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 260d65febd6..8e376cfcbf8 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -1,12 +1,7 @@
 vfio_ss = ss.source_set()
 vfio_ss.add(files(
-  'helpers.c',
   'common.c',
-  'container-base.c',
   'container.c',
-  'migration.c',
-  'migration-multifd.c',
-  'cpr.c',
 ))
 vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
 vfio_ss.add(when: 'CONFIG_IOMMUFD', if_true: files(
@@ -25,3 +20,11 @@ vfio_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files('igd.c'))
 
 specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
+
+system_ss.add(when: 'CONFIG_VFIO', if_true: files(
+  'helpers.c',
+  'container-base.c',
+  'migration.c',
+  'migration-multifd.c',
+  'cpr.c',
+))
-- 
2.47.1


