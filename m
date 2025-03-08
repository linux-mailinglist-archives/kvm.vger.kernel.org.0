Return-Path: <kvm+bounces-40503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2885A57FAA
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:09:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBBF716AC99
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D564C20D50D;
	Sat,  8 Mar 2025 23:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FEUhmu3u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F141F584B
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475382; cv=none; b=b+Pz+dp/ey0ig4oOKnjznWT5A4I2jpt+jLy/CKX9anVSfZ7Jad26aST/9OOvBK73gQNIfPF60tv7FfDAm1hlpIOM8BRc6lF0Jc7EIWulyAKGrO+TKAgSzRrjgWo0jphDiBDSYLBH96FXXEjr128dY61HY8L8ASDccj87stpjMck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475382; c=relaxed/simple;
	bh=kC6TRwPJU8pcisC+kwrbFny6G8hHIGGNWh5b3/4nNF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JrHRCo/PsnGr9SadUiZ7D303a/ku5dH91Ve7xC8jxPZ/fjYR/8D+rhgYOX/6XGBES1rmYV9hE1qU/8RN9GsNiMKEQqeG2m8g6iR32KTl//my7DignG5hAyl3Szg0B0U0IeoIITOyoEEI4XM5Awb52f1beX7Q7U66QOY7IMk4iag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FEUhmu3u; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3913d129c1aso402833f8f.0
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475378; x=1742080178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C4sOyyLdHZ94t1nFvB4a0FIi/FlAkRfDFcAkUZmK1lY=;
        b=FEUhmu3uIG845ve6zRBEnvihlfZL4VC1CUBb3zZBBAt5E8dr4ctgnB8oqlLCkEDxqO
         l+/6aI7ediLCsNRBz3GRQ+cGqsl0CatYeTHMfB9Zv/AyH9gjLNT6QfsJq6Wq6iIiKZVg
         zAqPAjfXHGyz2gog8V1IOvIdf2yoLxE4mwTOzjaZ5WEJmGvfjpoL+BU+VfiIJA2+aCFw
         Q2+3TOL5EyGzp7FQPyoPUVNxj+8Dy+G6WwspQK7Wi/MQEX5MDwc1VYFxAfz0K2uPiVB0
         ny2j0xIWaCC2WbYdYNkvE8RJqu+0RQXaXucUsr9jIDneTq11Clk+1PzvyuhN0U7g1vfe
         4xjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475378; x=1742080178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C4sOyyLdHZ94t1nFvB4a0FIi/FlAkRfDFcAkUZmK1lY=;
        b=YRSCiBjikLNQfichONyb7tYXuiRFBHmMZKZCuSExiL6YvoCFqifv4tLUVa/y01XT/q
         N0Hi56S20dEdYg3GRwg5aah5Qz4ZfhcE9VM+gnjN9+JbIleCtSHE/melMo6ChOcvkx2+
         72e90QJwkg46tb9eTjq+fUKUKaHHN2Pm0PLzPY3aLubpkb3SV4zIP2H5fs5U6nN0m1K2
         /SjdVBFJnGQzT6B+i6uaHIi91VZLAcQZpfrqsPocgLwlTG/lYQXi4m9xRQkLbgPf5Pj1
         iaTrwf9cTzJdpjV/WqyLZFE7/TDA0R8pjjQFykBVhskslDAXVhTaq9tTWLyXTFF1+Dwd
         UYEw==
X-Forwarded-Encrypted: i=1; AJvYcCWEnnvjGpsKn07Gwi3MDqiKGYrX0C6KYATcWE4t31j0QOU2NDhJrYtyU7/+hpYGGF+yfYs=@vger.kernel.org
X-Gm-Message-State: AOJu0YynxJSTokD+4a18O5yuSfQn1+P09PGj4qxuYYzOXo1fbSpqX92N
	LA0drh61HrHUb93c0cmvorQVp29gQPubzvdI/mVestKtI2VBNuEQmSddQESf2kQ=
X-Gm-Gg: ASbGnctkYoQgKklk6gDgWYqwAuJAgrK43UfiIH0d27oEpFIUM/QsIjXQ8hU++nRmnLO
	DscYBf1aJcKpM8I145RVvTwUhkiYhZ2Ndj9ZoZDJncHl4f3bZJCwsgt8rOLbl12MOchfL1ZMGFR
	W+7ZaZH8D7MyUPQUM5zgDoteAPUmLlSyFvxPJsGEIwyHchL6gpxkhhtZUYmQofTzlyF4nMsurkg
	IUuK8AUlCMq2pbnjY9IqcOtpDX6TrUHzbIRXijmySJ5dOP4gkYrbc1B2jwaZYP7OI1kltkem8V2
	Th2jlm3/SYNH+4OjUlA5it3udWNj1MOU/gXkRMK3TV3m9AdicKn684kYIB60JtWVXyQEBG2ccYf
	y2rdMxB7bI3djGUojLFY=
X-Google-Smtp-Source: AGHT+IEw95hLpQ6L7aoWgp/bxwK/ZuUh6EVLZGte6tf2yrptaAeFh+yTGwJkxhI0K8AnTcsOHslqpg==
X-Received: by 2002:a05:6000:1a86:b0:391:a74:d7e2 with SMTP id ffacd0b85a97d-3913af390eemr2446915f8f.26.1741475378455;
        Sat, 08 Mar 2025 15:09:38 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43cf27f8ef3sm2422605e9.11.2025.03.08.15.09.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:09:37 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	qemu-s390x@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 03/21] hw/vfio: Compile some common objects once
Date: Sun,  9 Mar 2025 00:08:59 +0100
Message-ID: <20250308230917.18907-4-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250308230917.18907-1-philmd@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
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
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
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


