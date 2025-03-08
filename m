Return-Path: <kvm+bounces-40519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D66DBA57FBB
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B1A11888678
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A183120C468;
	Sat,  8 Mar 2025 23:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ON1EZGP7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C4217C77
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475473; cv=none; b=XNN6AKrsqoxGqpKiergmuVhxcRVEOedrujofI4CJYnJzPYaqPBlaiVBcL6RjmV0oTgJfCElzDXKB7InBmJYlsOUK7PzIaFchdG8gfEFWVhjIUJcEoJOHSOUvZFmKtsbHs2e2+/XhordRi529uqS8JnsgpYP3mGyDgVQMXYdAxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475473; c=relaxed/simple;
	bh=wAy5ej7XHY90ux45qXW7oKSQt3NI/TDRCxR+k/DH8j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ITo7jSCagloXlPuoPydBu/+AHzQxNGMC08qQC+FzkcLIAGYt1uh1ziBDtuwV8Y0Nv3wGjrB2iqq7tfwIW/TvYp/uhWnrivwDoG8a6uXMzPSWiGtzwTf5kYCW9RCEW15hwar2kM8uw5HDzlCQ5MHNo1K5dwR8X+KXN08gT/R9C2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ON1EZGP7; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43bccfa7b89so25637275e9.2
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475470; x=1742080270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SchAlroLdDNdcNXpi1x0hC/CnniZL26bHHU3ofZkp5E=;
        b=ON1EZGP7VY8C1uASrTSl5ZCjHCpWM54oqImBljM4Pslc8W1mDmGtWGIPFQcbfs6dy3
         8/1vcY0EujSiuUbwR3oRM/hpHPhOMXYKtw33ZgIHGQGXeZu9/qGxJhI992kW4Li9B4/D
         BUnowQ1LKh8TZ50o+vUskEwKm55lQQmSuxnUAGPIiJAA0o2uk/A3yISyodzl1R1aMQuo
         KzhegnACQ+cZBaOBQzYyik210fXQS524X+ZJR7QZX6pH7X8VecYugl80PQGevr1xskfn
         tXUzgBrrcSHIsmnW8Dntzml6wTV5rY/8sXyBTYiWydItAFKHR/2Fl8ihl1vOYs6EX6mS
         YQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475470; x=1742080270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SchAlroLdDNdcNXpi1x0hC/CnniZL26bHHU3ofZkp5E=;
        b=w+/eBo/wWsAaioG2S44rhot8C3uoeniQ/5Qa70vWNMtQoNGVAmIodIWZ6h03xxyGrK
         txIei31ZuEbvoFRyA/+zCTFHwOHBSX/b5n9RX+GZGOsVI1u9erAy3tl/bkqEUqoMgfP7
         wjD/RQH4AeLaYBPm/udbkQn+UCyLrnAv8hySexcvAkZA8n53ufBmC6ZbZfN/9Ky2T9w3
         x6jfG2bETDWdgwfIkM3dn1rSG1ybT6Vv1JUHH66Er0Qc88t7ZpWFoEqtsBHLfksgFM+5
         WkN5qdnJkHoh/HTI2VdL3cjgzYJ30QJpCpQiOaNlTB8MXkI/4cQAQpS8HWMPNRjS+p9S
         EiAA==
X-Forwarded-Encrypted: i=1; AJvYcCX6Wwr2aDvTGkbwebV/89r7m9w3BIyovio7lNqvmSaL3G3z02TJjIPxDPJjYd7DobZYFXs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqpQOSFsKqaJGjVNQpY/U8tdOWYQ+gyxoAWOd9mORyQuRbd02B
	48p+Zb0fbQ5jCWkabCNC9rguIEgrLDPqW3GuuY7ATKRGbsoQNXVRZjmpeUjd20M=
X-Gm-Gg: ASbGnctJHVYar3FnPfaWYPa80lOZZneP+bZB2/dC5Z0F3+RTEQIWKMKr8WsqJ3RA1zd
	Id0BNlPbgnWbPBS72GwiRgKqStSWZQV8wtd4MhTMUA+QaL5YI9g3oIOtkj+KvmrobiaRY/b1FFA
	7ZhhtQ0mmiHLnMefL7BrIbHHmzHP2uRyfbUuBysSG8W1Seq6pFW98IAF6slbV4L3zmOJB96okeD
	6moJd8PQMhK6F4KBD+fu44wD04aw7WUeqI4WElxPhKJeJuEwnNjr+Zc3eA2+QOFZAdKxc09Norz
	0nVawigdXEpdQRyQNaLBkoO9ULL8Kob0oRfBaIgF1RHRZFvaDHGHoAoRFx5IbAygy56t7JdRDqE
	P2FOX4aeKcHRFIxVrff0=
X-Google-Smtp-Source: AGHT+IEb/b4LOE2Bgus21ZYrnM3VVzkRV4FDIHRDZ5Yi+DfrCk1Fa3EmoxdciYSS3mQYlPYdKzgUqA==
X-Received: by 2002:a05:600c:4e89:b0:43b:c448:bc34 with SMTP id 5b1f17b1804b1-43c601d0758mr55299595e9.18.1741475470398;
        Sat, 08 Mar 2025 15:11:10 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0e4065sm10261640f8f.62.2025.03.08.15.11.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:11:09 -0800 (PST)
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
Subject: [PATCH v2 19/21] hw/vfio/s390x: Compile AP and CCW once
Date: Sun,  9 Mar 2025 00:09:15 +0100
Message-ID: <20250308230917.18907-20-philmd@linaro.org>
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

Since the files don't use any target-specific knowledge anymore,
move them to system_ss[] to build them once, even if they are
only used for one unique binary (qemu-system-s390x).

Because files in system_ss[] don't get the target/foo/ path in
their CPPFLAGS, use header paths relative to the root directory.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/s390x/kvm/kvm_s390x.h | 2 +-
 hw/vfio/ap.c                 | 2 +-
 hw/vfio/meson.build          | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/s390x/kvm/kvm_s390x.h b/target/s390x/kvm/kvm_s390x.h
index 649dae5948a..7b1cce3e60d 100644
--- a/target/s390x/kvm/kvm_s390x.h
+++ b/target/s390x/kvm/kvm_s390x.h
@@ -10,7 +10,7 @@
 #ifndef KVM_S390X_H
 #define KVM_S390X_H
 
-#include "cpu-qom.h"
+#include "target/s390x/cpu-qom.h"
 
 struct kvm_s390_irq;
 
diff --git a/hw/vfio/ap.c b/hw/vfio/ap.c
index a4ec2b5f9ac..832b98532ea 100644
--- a/hw/vfio/ap.c
+++ b/hw/vfio/ap.c
@@ -23,7 +23,7 @@
 #include "qemu/module.h"
 #include "qemu/option.h"
 #include "qemu/config-file.h"
-#include "kvm/kvm_s390x.h"
+#include "target/s390x/kvm/kvm_s390x.h"
 #include "migration/vmstate.h"
 #include "hw/qdev-properties.h"
 #include "hw/s390x/ap-bridge.h"
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index ff9bd4f2e35..3119c841ed9 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -4,9 +4,7 @@ vfio_ss.add(files(
   'container.c',
 ))
 vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
-vfio_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
-vfio_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
 
 specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
 
@@ -27,6 +25,8 @@ system_ss.add(when: 'CONFIG_VFIO', if_true: files(
 system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
   'iommufd.c',
 ))
+system_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
+system_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
 system_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'display.c',
   'pci.c',
-- 
2.47.1


