Return-Path: <kvm+bounces-71646-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KCL8GGTunWncSgQAu9opvQ
	(envelope-from <kvm+bounces-71646-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:31:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 05F5618B691
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:30:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3255A31006E3
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E341C3AA1A5;
	Tue, 24 Feb 2026 18:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sM/VPDFS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8582B3A7F54
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 18:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957541; cv=none; b=Qw+/rDhVuKXE5neh8k64IFj9IpDGvRRCWnVP4ALyno1axcqE9kOBySgr4kyNno1/2C7yCmCXqw1z5b6ybsBYUuBmOiBwVarIqFxZZw7Qu3UnSyXd7BXWsJg2P9xelPjMf7tqPJlyeJDVOYYz1WkLG9FQDJowt+mX0sZ2N+WwVVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957541; c=relaxed/simple;
	bh=c3RxJ5NfBDnbTVGAVuqYFGnYsYR7E9Z82BqrkHaXlc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kPLPBB/lpvsTTTQdS1N2FhxvCiGSsTbaOaKB4jGYCfai+DyG7oism2m7ypSISiO3BT+jDagxyjOOmviaphqjQ9fXuuyoSqG7rYGL+lZsP4zWF8gupAmq+1L+t6ZMfKdrnBMtGGusQja61QzjBC/mXwj6ZYL18kCOto12DoQXnFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sM/VPDFS; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-679c5fde4c7so51656998eaf.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771957538; x=1772562338; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W43LUhh0LTU1//BOJUSbLb590wyjt02CHFj96YxulfY=;
        b=sM/VPDFS1LI5zqRMh2LUmqqBHKCnOaFjdC3i7m6GTWjXFLwKwYosYGxepJ/iJcaHF2
         LPvfIOi1IktEkaDfp8E0SOPoVmimPa3TDG5g0Ucz0SLTEXs2d7bSSD+yVrw6fUgfICFm
         wXoy0bDKaGkrTYcdopYZP4jM8kFbqk6OkVg8KxXaY2lbX35YNhrhtCR2svKkRFgBX0vZ
         d1mX+jm/W+4Jj5kr9tX1OegzBV9zkiFwqF/5YY5GKW2e098qc/ZFN+VBD5945ItjIX1B
         fzfJxJ87RKCMpiP4o7zlFxoIbm/2loZhGCrs/rFHKNzIGIRe0BGhCyk000W2z+3Hywk9
         mhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957538; x=1772562338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W43LUhh0LTU1//BOJUSbLb590wyjt02CHFj96YxulfY=;
        b=iQYWurrcC98SJpI76uhzqs5y1F1d0O4u5MSlqTgo9eVx05WRCTD8lDJPe4ob4xKVDQ
         QWTjPsZMqMsJMNXTVgOaeGfKCbIBydITpNXt+6iEoA0GlCFfg4Lwh4GmlfAiq/yOamM2
         4cPcm7LYIFNQ6I4LibjXFJJDDe77F6hmGRS2nb8xwsuuDOsIeFE2IQla7uBiVcKSSTMD
         c80DMHlfSQ9zDvASnYSiZf0FwPoS1+brgdiSVgOGrmzef3VyjKX7ElcBQzo681PuPmuU
         AZvl0otXSU+2yxCoEi5cci3oc5IDcycorIVPx3QTTUjfNp0RLYRI7W8uZasG7VU0jtFk
         dzSg==
X-Forwarded-Encrypted: i=1; AJvYcCWENCPusJAYx2DCajvRHM40hbCX0Nl0eezLHKCHj83wW7szhNTQx64ZZbrc8LRVfpp/4Po=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvOwvs6jjsk9KzjT3FXYT4e3jm9Tl4UoPBrijPr1x8I+hS4ol9
	2y1vLY91TGh4bVncPQSdwN/hVQ5jvdCArMUlQ4Xn/UswnoijO5xTEd6XFWBxsdSrIVW03l/IO2g
	fBJfDMpJgmA==
X-Received: from jabl3.prod.google.com ([2002:a05:6638:c383:b0:5cb:752:3749])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:4dc6:b0:662:f2ea:8f9b
 with SMTP id 006d021491bc7-679c428264bmr7129729eaf.20.1771957538427; Tue, 24
 Feb 2026 10:25:38 -0800 (PST)
Date: Tue, 24 Feb 2026 18:25:26 +0000
In-Reply-To: <20260224182532.3914470-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224182532.3914470-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224182532.3914470-3-rananta@google.com>
Subject: [PATCH v4 2/8] vfio: selftests: Introduce snprintf_assert()
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71646-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 05F5618B691
X-Rspamd-Action: no action

Introduce snprintf_assert() to protect the users of snprintf() to fail
if the requested operation was truncated due to buffer limits. VFIO
tests and libraries, including a new sysfs library that will be introduced
by an upcoming patch, rely quite heavily on snprintf()s to build PCI
sysfs paths. Having a protection against this will be helpful to prevent
false test failures.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../vfio/lib/include/libvfio/assert.h         |  5 +++++
 .../selftests/vfio/lib/vfio_pci_device.c      |  8 +++----
 .../selftests/vfio/vfio_dma_mapping_test.c    |  6 +++---
 .../selftests/vfio/vfio_pci_device_test.c     | 21 ++++++++++---------
 4 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
index f4ebd122d9b6f..77b68c7129a64 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
@@ -51,4 +51,9 @@
 	VFIO_ASSERT_EQ(__ret, 0, "ioctl(%s, %s, %s) returned %d\n", #_fd, #_op, #_arg, __ret); \
 } while (0)
 
+#define snprintf_assert(_s, _size, _fmt, ...) do {                      \
+	int __ret = snprintf(_s, _size, _fmt, ##__VA_ARGS__);           \
+	VFIO_ASSERT_LT(__ret, _size);                                   \
+} while (0)
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_ASSERT_H */
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 13fdb4b0b10f3..64a19481b734f 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -188,7 +188,7 @@ static unsigned int vfio_pci_get_group_from_dev(const char *bdf)
 	unsigned int group;
 	int ret;
 
-	snprintf(sysfs_path, PATH_MAX, "%s/%s/iommu_group", PCI_SYSFS_PATH, bdf);
+	snprintf_assert(sysfs_path, PATH_MAX, "%s/%s/iommu_group", PCI_SYSFS_PATH, bdf);
 
 	ret = readlink(sysfs_path, dev_iommu_group_path, sizeof(dev_iommu_group_path));
 	VFIO_ASSERT_NE(ret, -1, "Failed to get the IOMMU group for device: %s\n", bdf);
@@ -208,7 +208,7 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	int group;
 
 	group = vfio_pci_get_group_from_dev(bdf);
-	snprintf(group_path, sizeof(group_path), "/dev/vfio/%d", group);
+	snprintf_assert(group_path, sizeof(group_path), "/dev/vfio/%d", group);
 
 	device->group_fd = open(group_path, O_RDWR);
 	VFIO_ASSERT_GE(device->group_fd, 0, "open(%s) failed\n", group_path);
@@ -279,7 +279,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 	cdev_path = calloc(PATH_MAX, 1);
 	VFIO_ASSERT_NOT_NULL(cdev_path);
 
-	snprintf(dir_path, sizeof(dir_path), "/sys/bus/pci/devices/%s/vfio-dev/", bdf);
+	snprintf_assert(dir_path, sizeof(dir_path), "/sys/bus/pci/devices/%s/vfio-dev/", bdf);
 
 	dir = opendir(dir_path);
 	VFIO_ASSERT_NOT_NULL(dir, "Failed to open directory %s\n", dir_path);
@@ -289,7 +289,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 		if (strncmp("vfio", entry->d_name, 4))
 			continue;
 
-		snprintf(cdev_path, PATH_MAX, "/dev/vfio/devices/%s", entry->d_name);
+		snprintf_assert(cdev_path, PATH_MAX, "/dev/vfio/devices/%s", entry->d_name);
 		break;
 	}
 
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index 5397822c3dd4b..3a0bea5e26480 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -45,9 +45,9 @@ static int intel_iommu_mapping_get(const char *bdf, u64 iova,
 	FILE *file;
 	char *rest;
 
-	snprintf(iommu_mapping_path, sizeof(iommu_mapping_path),
-		 "/sys/kernel/debug/iommu/intel/%s/domain_translation_struct",
-		 bdf);
+	snprintf_assert(iommu_mapping_path, sizeof(iommu_mapping_path),
+			"/sys/kernel/debug/iommu/intel/%s/domain_translation_struct",
+			bdf);
 
 	printf("Searching for IOVA 0x%lx in %s\n", iova, iommu_mapping_path);
 
diff --git a/tools/testing/selftests/vfio/vfio_pci_device_test.c b/tools/testing/selftests/vfio/vfio_pci_device_test.c
index ecbb669b37651..723b56b485f67 100644
--- a/tools/testing/selftests/vfio/vfio_pci_device_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_device_test.c
@@ -39,16 +39,17 @@ FIXTURE_TEARDOWN(vfio_pci_device_test)
 	iommu_cleanup(self->iommu);
 }
 
-#define read_pci_id_from_sysfs(_file) ({							\
-	char __sysfs_path[PATH_MAX];								\
-	char __buf[32];										\
-	int __fd;										\
-												\
-	snprintf(__sysfs_path, PATH_MAX, "/sys/bus/pci/devices/%s/%s", device_bdf, _file);	\
-	ASSERT_GT((__fd = open(__sysfs_path, O_RDONLY)), 0);					\
-	ASSERT_GT(read(__fd, __buf, ARRAY_SIZE(__buf)), 0);					\
-	ASSERT_EQ(0, close(__fd));								\
-	(u16)strtoul(__buf, NULL, 0);								\
+#define read_pci_id_from_sysfs(_file) ({					\
+	char __sysfs_path[PATH_MAX];						\
+	char __buf[32];								\
+	int __fd;								\
+										\
+	snprintf_assert(__sysfs_path, PATH_MAX, "/sys/bus/pci/devices/%s/%s",	\
+			device_bdf, _file);					\
+	ASSERT_GT((__fd = open(__sysfs_path, O_RDONLY)), 0);			\
+	ASSERT_GT(read(__fd, __buf, ARRAY_SIZE(__buf)), 0);			\
+	ASSERT_EQ(0, close(__fd));						\
+	(u16)strtoul(__buf, NULL, 0);						\
 })
 
 TEST_F(vfio_pci_device_test, config_space_read_write)
-- 
2.53.0.414.gf7e9f6c205-goog


