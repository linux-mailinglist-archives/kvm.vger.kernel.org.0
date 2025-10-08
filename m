Return-Path: <kvm+bounces-59671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F270BC6DBF
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E1723AA37D
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19EE22D0C63;
	Wed,  8 Oct 2025 23:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VffJ5Ls0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26E829AB13
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965976; cv=none; b=CVr0H0gE1XWKHJzEWs6xLGHrKxyYyWsJhEEY96UQuhk3c+r7J6mlsRifsrgvSfv2q5QB1uOQ3yHgxsrX842x5Ibgk6Iw/YC6V/H+h44EkDErox1u+nQrKjVFHW+BYD5rcjtATIGXruvNVvdQOMCji7xSZjfMW/GHe1gI73QbzyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965976; c=relaxed/simple;
	bh=ESrI2OtgviyQhznrksfj4ETxjDsLIDRJrw1w4E/lyKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QXaeFc0hwPdAAYtTloaUtfKJhkKbNbpTZsNEA4xlxcoxyHcQHvnqPRtQkzdrvr9/ACGsFCzI5/D2G1mzcAxybhP5Fs7Y0m9e+tYIsJ1h5kj11XhswnL8hYE7A5ULit2Jh+8kwssN4OrVO6ymPFXRYAYIat2mtySQ09jhMDprHyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VffJ5Ls0; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-780d26fb6b4so362157b3a.0
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965973; x=1760570773; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=naGWok0JDjmXONHq1VrTvQdMkBQMhO6yI8kJ9c7T1eU=;
        b=VffJ5Ls0gnAfamjqvMEuFzHKm3HmZUMK2BPt+J+BiCYm+yZs7orM4zgBEgmsUVyHJA
         L+2/hrj511lx1Ii2HK58Zwt9an46cLMFSHzEJV8LQNEv35H82CW8R7XwsLR+0yre4dL0
         tQDo6N+8P1nRR/b7W7ouoCg9keQOs6aKmUo9zxPnLJFlUfJj2i8ItDf8qlA26mC68USx
         H2LH+q40E5KIjDN5+FIad0FvXncc0gBecdQkuQpbAtwBP8QKExSJnxBrVj8PTT4dibyv
         6FAikIOoC/TISKvdMZl/Zh8qBeJkpvqWUNZWxk3pMHdHoyfj3vlvnuFG52kW4yjgGUaf
         mg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965973; x=1760570773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=naGWok0JDjmXONHq1VrTvQdMkBQMhO6yI8kJ9c7T1eU=;
        b=tbLiJ2tVeo2RGLh3Ln5qBae3cXR474rA5P9FRRdmEH3bW1i/OBn/403MacoFqvYHkx
         UZi1x4Brj2eYmhHg0dhE2tO6W+ODgu+p/ayMIBd8SdhgfN3lKzY7iRuPbbSbgaBsZrUW
         cAPe5OXfVYda6hcvyQhib0oNuWfrxDLD7JXqTGdgufZKoZC+pfT4FzPAYI5TBGGYh1oO
         0+Mj20Fl6TvRY3bdYOxhxuTRXxoQljr4nG0y+NoSlB551g9CEQr5ZZW3UFBXawj2dZHW
         MYESWy2C68u9xLoMpieNquH0/IkbU/X1xYiMLPW2t9WJ1zClUEEMaRuf4GPHYQ3OuOEO
         xdlA==
X-Forwarded-Encrypted: i=1; AJvYcCWWDo/c6x16cBOUS6f/6LSqerlI2M5qQFA4SMI84EmlX05MXLyNt5YX5m81J3G7LDNUc2I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyut8J4eNB0OeLLpxwvJj5hRSxe3z0dXYvUFUk2I8ADbMeN9rfK
	Q6f+7HaAeXklLrokRsA9yiD+a0mWeEB3Q29d9IF/x0y34VGzdbUWcWfqj/q5gv1bgc/UXbjz1dz
	9W/NxjddilDOZLA==
X-Google-Smtp-Source: AGHT+IFih6oLaQUCxnYbvbbrf1l+5eFitWvGbLsQmhqGvYslWKW9pw82O+yjieBtu2ivDvwfZgs8D1NOG9e7Mg==
X-Received: from pflr1.prod.google.com ([2002:aa7:9881:0:b0:777:8649:793e])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1250:b0:76e:885a:c32c with SMTP id d2e1a72fcca58-79387c1ad0amr6048198b3a.26.1759965972958;
 Wed, 08 Oct 2025 16:26:12 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:30 +0000
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-12-dmatlack@google.com>
Subject: [PATCH 11/12] vfio: selftests: Split libvfio.h into separate header files
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Split out the contents of libvfio.h into separate header files, but keep
libvfio.h as the top-level include that all tests can use.

Put all new header files into a libvfio/ subdirectory to avoid future
name conflicts in include paths when libvfio is used by other selftests
like KVM.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/lib/include/libvfio.h      | 318 +-----------------
 .../vfio/lib/include/libvfio/assert.h         |  53 +++
 .../vfio/lib/include/libvfio/iommu.h          |  53 +++
 .../lib/include/libvfio/vfio_pci_device.h     | 143 ++++++++
 .../lib/include/libvfio/vfio_pci_driver.h     |  98 ++++++
 tools/testing/selftests/vfio/lib/libvfio.c    |  77 +++++
 tools/testing/selftests/vfio/lib/libvfio.mk   |   3 +-
 .../selftests/vfio/lib/vfio_pci_device.c      |  70 ----
 8 files changed, 430 insertions(+), 385 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/assert.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
 create mode 100644 tools/testing/selftests/vfio/lib/libvfio.c

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio.h b/tools/testing/selftests/vfio/lib/include/libvfio.h
index 8b72d9c62404..ddb0b3bf60e7 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio.h
@@ -2,201 +2,10 @@
 #ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_H
 #define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_H
 
-#include <fcntl.h>
-#include <string.h>
-#include <linux/vfio.h>
-#include <linux/list.h>
-#include <linux/pci_regs.h>
-#include <sys/ioctl.h>
-
-#include "../../../kselftest.h"
-
-#define VFIO_LOG_AND_EXIT(...) do {		\
-	fprintf(stderr, "  " __VA_ARGS__);	\
-	fprintf(stderr, "\n");			\
-	exit(KSFT_FAIL);			\
-} while (0)
-
-#define VFIO_ASSERT_OP(_lhs, _rhs, _op, ...) do {				\
-	typeof(_lhs) __lhs = (_lhs);						\
-	typeof(_rhs) __rhs = (_rhs);						\
-										\
-	if (__lhs _op __rhs)							\
-		break;								\
-										\
-	fprintf(stderr, "%s:%u: Assertion Failure\n\n", __FILE__, __LINE__);	\
-	fprintf(stderr, "  Expression: " #_lhs " " #_op " " #_rhs "\n");	\
-	fprintf(stderr, "  Observed: %#lx %s %#lx\n",				\
-			(u64)__lhs, #_op, (u64)__rhs);				\
-	fprintf(stderr, "  [errno: %d - %s]\n", errno, strerror(errno));	\
-	VFIO_LOG_AND_EXIT(__VA_ARGS__);						\
-} while (0)
-
-#define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, ==, ##__VA_ARGS__)
-#define VFIO_ASSERT_NE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, !=, ##__VA_ARGS__)
-#define VFIO_ASSERT_LT(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, <, ##__VA_ARGS__)
-#define VFIO_ASSERT_LE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, <=, ##__VA_ARGS__)
-#define VFIO_ASSERT_GT(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, >, ##__VA_ARGS__)
-#define VFIO_ASSERT_GE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, >=, ##__VA_ARGS__)
-#define VFIO_ASSERT_TRUE(_a, ...) VFIO_ASSERT_NE(false, (_a), ##__VA_ARGS__)
-#define VFIO_ASSERT_FALSE(_a, ...) VFIO_ASSERT_EQ(false, (_a), ##__VA_ARGS__)
-#define VFIO_ASSERT_NULL(_a, ...) VFIO_ASSERT_EQ(NULL, _a, ##__VA_ARGS__)
-#define VFIO_ASSERT_NOT_NULL(_a, ...) VFIO_ASSERT_NE(NULL, _a, ##__VA_ARGS__)
-
-#define VFIO_FAIL(_fmt, ...) do {				\
-	fprintf(stderr, "%s:%u: FAIL\n\n", __FILE__, __LINE__);	\
-	VFIO_LOG_AND_EXIT(_fmt, ##__VA_ARGS__);			\
-} while (0)
-
-#define ioctl_assert(_fd, _op, _arg) do {						       \
-	void *__arg = (_arg);								       \
-	int __ret = ioctl((_fd), (_op), (__arg));					       \
-	VFIO_ASSERT_EQ(__ret, 0, "ioctl(%s, %s, %s) returned %d\n", #_fd, #_op, #_arg, __ret); \
-} while (0)
-
-#define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
-#define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
-
-struct iommu_mode {
-	const char *name;
-	const char *container_path;
-	unsigned long iommu_type;
-};
-
-/*
- * Generator for VFIO selftests fixture variants that replicate across all
- * possible IOMMU modes. Tests must define FIXTURE_VARIANT_ADD_IOMMU_MODE()
- * which should then use FIXTURE_VARIANT_ADD() to create the variant.
- */
-#define FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(...) \
-FIXTURE_VARIANT_ADD_IOMMU_MODE(vfio_type1_iommu, ##__VA_ARGS__); \
-FIXTURE_VARIANT_ADD_IOMMU_MODE(vfio_type1v2_iommu, ##__VA_ARGS__); \
-FIXTURE_VARIANT_ADD_IOMMU_MODE(iommufd_compat_type1, ##__VA_ARGS__); \
-FIXTURE_VARIANT_ADD_IOMMU_MODE(iommufd_compat_type1v2, ##__VA_ARGS__); \
-FIXTURE_VARIANT_ADD_IOMMU_MODE(iommufd, ##__VA_ARGS__)
-
-struct vfio_pci_bar {
-	struct vfio_region_info info;
-	void *vaddr;
-};
-
-typedef u64 iova_t;
-
-#define INVALID_IOVA UINT64_MAX
-
-struct dma_region {
-	struct list_head link;
-	void *vaddr;
-	iova_t iova;
-	u64 size;
-};
-
-struct vfio_pci_device;
-
-struct vfio_pci_driver_ops {
-	const char *name;
-
-	/**
-	 * @probe() - Check if the driver supports the given device.
-	 *
-	 * Return: 0 on success, non-0 on failure.
-	 */
-	int (*probe)(struct vfio_pci_device *device);
-
-	/**
-	 * @init() - Initialize the driver for @device.
-	 *
-	 * Must be called after device->driver.region has been initialized.
-	 */
-	void (*init)(struct vfio_pci_device *device);
-
-	/**
-	 * remove() - Deinitialize the driver for @device.
-	 */
-	void (*remove)(struct vfio_pci_device *device);
-
-	/**
-	 * memcpy_start() - Kick off @count repeated memcpy operations from
-	 * [@src, @src + @size) to [@dst, @dst + @size).
-	 *
-	 * Guarantees:
-	 *  - The device will attempt DMA reads on [src, src + size).
-	 *  - The device will attempt DMA writes on [dst, dst + size).
-	 *  - The device will not generate any interrupts.
-	 *
-	 * memcpy_start() returns immediately, it does not wait for the
-	 * copies to complete.
-	 */
-	void (*memcpy_start)(struct vfio_pci_device *device,
-			     iova_t src, iova_t dst, u64 size, u64 count);
-
-	/**
-	 * memcpy_wait() - Wait until the memcpy operations started by
-	 * memcpy_start() have finished.
-	 *
-	 * Guarantees:
-	 *  - All in-flight DMAs initiated by memcpy_start() are fully complete
-	 *    before memcpy_wait() returns.
-	 *
-	 * Returns non-0 if the driver detects that an error occurred during the
-	 * memcpy, 0 otherwise.
-	 */
-	int (*memcpy_wait)(struct vfio_pci_device *device);
-
-	/**
-	 * send_msi() - Make the device send the MSI device->driver.msi.
-	 *
-	 * Guarantees:
-	 *  - The device will send the MSI once.
-	 */
-	void (*send_msi)(struct vfio_pci_device *device);
-};
-
-struct vfio_pci_driver {
-	const struct vfio_pci_driver_ops *ops;
-	bool initialized;
-	bool memcpy_in_progress;
-
-	/* Region to be used by the driver (e.g. for in-memory descriptors) */
-	struct dma_region region;
-
-	/* The maximum size that can be passed to memcpy_start(). */
-	u64 max_memcpy_size;
-
-	/* The maximum count that can be passed to memcpy_start(). */
-	u64 max_memcpy_count;
-
-	/* The MSI vector the device will signal in ops->send_msi(). */
-	int msi;
-};
-
-struct iommu {
-	const struct iommu_mode *mode;
-	int container_fd;
-	int iommufd;
-	u32 ioas_id;
-	struct list_head dma_regions;
-};
-
-struct vfio_pci_device {
-	const char *bdf;
-	int fd;
-	int group_fd;
-
-	struct iommu *iommu;
-
-	struct vfio_device_info info;
-	struct vfio_region_info config_space;
-	struct vfio_pci_bar bars[PCI_STD_NUM_BARS];
-
-	struct vfio_irq_info msi_info;
-	struct vfio_irq_info msix_info;
-
-	/* eventfds for MSI and MSI-x interrupts */
-	int msi_eventfds[PCI_MSIX_FLAGS_QSIZE + 1];
-
-	struct vfio_pci_driver driver;
-};
+#include <libvfio/assert.h>
+#include <libvfio/iommu.h>
+#include <libvfio/vfio_pci_driver.h>
+#include <libvfio/vfio_pci_device.h>
 
 /*
  * Return the BDF string of the device that the test should use.
@@ -213,123 +22,4 @@ struct vfio_pci_device {
 const char *vfio_selftests_get_bdf(int *argc, char *argv[]);
 char **vfio_selftests_get_bdfs(int *argc, char *argv[], int *nr_bdfs);
 
-const char *vfio_pci_get_cdev_path(const char *bdf);
-
-extern const char *default_iommu_mode;
-
-struct iommu *iommu_init(const char *iommu_mode);
-void iommu_cleanup(struct iommu *iommu);
-iova_t iommu_hva2iova(struct iommu *iommu, void *vaddr);
-iova_t __iommu_hva2iova(struct iommu *iommu, void *vaddr);
-void iommu_map(struct iommu *iommu, struct dma_region *region);
-void iommu_unmap(struct iommu *iommu, struct dma_region *region);
-
-struct vfio_pci_device *__vfio_pci_device_init(const char *bdf, struct iommu *iommu);
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode);
-
-void __vfio_pci_device_cleanup(struct vfio_pci_device *device);
-void vfio_pci_device_cleanup(struct vfio_pci_device *device);
-
-void vfio_pci_device_reset(struct vfio_pci_device *device);
-
-static inline void vfio_pci_dma_map(struct vfio_pci_device *device,
-				    struct dma_region *region)
-{
-	return iommu_map(device->iommu, region);
-}
-
-static inline void vfio_pci_dma_unmap(struct vfio_pci_device *device,
-				      struct dma_region *region)
-{
-	return iommu_unmap(device->iommu, region);
-}
-
-void vfio_pci_config_access(struct vfio_pci_device *device, bool write,
-			    size_t config, size_t size, void *data);
-
-#define vfio_pci_config_read(_device, _offset, _type) ({			    \
-	_type __data;								    \
-	vfio_pci_config_access((_device), false, _offset, sizeof(__data), &__data); \
-	__data;									    \
-})
-
-#define vfio_pci_config_readb(_d, _o) vfio_pci_config_read(_d, _o, u8)
-#define vfio_pci_config_readw(_d, _o) vfio_pci_config_read(_d, _o, u16)
-#define vfio_pci_config_readl(_d, _o) vfio_pci_config_read(_d, _o, u32)
-
-#define vfio_pci_config_write(_device, _offset, _value, _type) do {		  \
-	_type __data = (_value);						  \
-	vfio_pci_config_access((_device), true, _offset, sizeof(_type), &__data); \
-} while (0)
-
-#define vfio_pci_config_writeb(_d, _o, _v) vfio_pci_config_write(_d, _o, _v, u8)
-#define vfio_pci_config_writew(_d, _o, _v) vfio_pci_config_write(_d, _o, _v, u16)
-#define vfio_pci_config_writel(_d, _o, _v) vfio_pci_config_write(_d, _o, _v, u32)
-
-void vfio_pci_irq_enable(struct vfio_pci_device *device, u32 index,
-			 u32 vector, int count);
-void vfio_pci_irq_disable(struct vfio_pci_device *device, u32 index);
-void vfio_pci_irq_trigger(struct vfio_pci_device *device, u32 index, u32 vector);
-
-static inline void fcntl_set_nonblock(int fd)
-{
-	int r;
-
-	r = fcntl(fd, F_GETFL, 0);
-	VFIO_ASSERT_NE(r, -1, "F_GETFL failed for fd %d\n", fd);
-
-	r = fcntl(fd, F_SETFL, r | O_NONBLOCK);
-	VFIO_ASSERT_NE(r, -1, "F_SETFL O_NONBLOCK failed for fd %d\n", fd);
-}
-
-static inline void vfio_pci_msi_enable(struct vfio_pci_device *device,
-				       u32 vector, int count)
-{
-	vfio_pci_irq_enable(device, VFIO_PCI_MSI_IRQ_INDEX, vector, count);
-}
-
-static inline void vfio_pci_msi_disable(struct vfio_pci_device *device)
-{
-	vfio_pci_irq_disable(device, VFIO_PCI_MSI_IRQ_INDEX);
-}
-
-static inline void vfio_pci_msix_enable(struct vfio_pci_device *device,
-					u32 vector, int count)
-{
-	vfio_pci_irq_enable(device, VFIO_PCI_MSIX_IRQ_INDEX, vector, count);
-}
-
-static inline void vfio_pci_msix_disable(struct vfio_pci_device *device)
-{
-	vfio_pci_irq_disable(device, VFIO_PCI_MSIX_IRQ_INDEX);
-}
-
-static inline iova_t __to_iova(struct vfio_pci_device *device, void *vaddr)
-{
-	return __iommu_hva2iova(device->iommu, vaddr);
-}
-
-static inline iova_t to_iova(struct vfio_pci_device *device, void *vaddr)
-{
-	return iommu_hva2iova(device->iommu, vaddr);
-}
-
-static inline bool vfio_pci_device_match(struct vfio_pci_device *device,
-					 u16 vendor_id, u16 device_id)
-{
-	return (vendor_id == vfio_pci_config_readw(device, PCI_VENDOR_ID)) &&
-		(device_id == vfio_pci_config_readw(device, PCI_DEVICE_ID));
-}
-
-void vfio_pci_driver_probe(struct vfio_pci_device *device);
-void vfio_pci_driver_init(struct vfio_pci_device *device);
-void vfio_pci_driver_remove(struct vfio_pci_device *device);
-int vfio_pci_driver_memcpy(struct vfio_pci_device *device,
-			   iova_t src, iova_t dst, u64 size);
-void vfio_pci_driver_memcpy_start(struct vfio_pci_device *device,
-				  iova_t src, iova_t dst, u64 size,
-				  u64 count);
-int vfio_pci_driver_memcpy_wait(struct vfio_pci_device *device);
-void vfio_pci_driver_send_msi(struct vfio_pci_device *device);
-
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_H */
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
new file mode 100644
index 000000000000..0f68af94a2ca
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_ASSERT_H
+#define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_ASSERT_H
+
+#include <stdio.h>
+#include <sys/ioctl.h>
+
+#include "../../../kselftest.h"
+
+#define VFIO_LOG_AND_EXIT(...) do {		\
+	fprintf(stderr, "  " __VA_ARGS__);	\
+	fprintf(stderr, "\n");			\
+	exit(KSFT_FAIL);			\
+} while (0)
+
+#define VFIO_ASSERT_OP(_lhs, _rhs, _op, ...) do {				\
+	typeof(_lhs) __lhs = (_lhs);						\
+	typeof(_rhs) __rhs = (_rhs);						\
+										\
+	if (__lhs _op __rhs)							\
+		break;								\
+										\
+	fprintf(stderr, "%s:%u: Assertion Failure\n\n", __FILE__, __LINE__);	\
+	fprintf(stderr, "  Expression: " #_lhs " " #_op " " #_rhs "\n");	\
+	fprintf(stderr, "  Observed: %#lx %s %#lx\n",				\
+			(u64)__lhs, #_op, (u64)__rhs);				\
+	fprintf(stderr, "  [errno: %d - %s]\n", errno, strerror(errno));	\
+	VFIO_LOG_AND_EXIT(__VA_ARGS__);						\
+} while (0)
+
+#define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, ==, ##__VA_ARGS__)
+#define VFIO_ASSERT_NE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, !=, ##__VA_ARGS__)
+#define VFIO_ASSERT_LT(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, <, ##__VA_ARGS__)
+#define VFIO_ASSERT_LE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, <=, ##__VA_ARGS__)
+#define VFIO_ASSERT_GT(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, >, ##__VA_ARGS__)
+#define VFIO_ASSERT_GE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, >=, ##__VA_ARGS__)
+#define VFIO_ASSERT_TRUE(_a, ...) VFIO_ASSERT_NE(false, (_a), ##__VA_ARGS__)
+#define VFIO_ASSERT_FALSE(_a, ...) VFIO_ASSERT_EQ(false, (_a), ##__VA_ARGS__)
+#define VFIO_ASSERT_NULL(_a, ...) VFIO_ASSERT_EQ(NULL, _a, ##__VA_ARGS__)
+#define VFIO_ASSERT_NOT_NULL(_a, ...) VFIO_ASSERT_NE(NULL, _a, ##__VA_ARGS__)
+
+#define VFIO_FAIL(_fmt, ...) do {				\
+	fprintf(stderr, "%s:%u: FAIL\n\n", __FILE__, __LINE__);	\
+	VFIO_LOG_AND_EXIT(_fmt, ##__VA_ARGS__);			\
+} while (0)
+
+#define ioctl_assert(_fd, _op, _arg) do {						       \
+	void *__arg = (_arg);								       \
+	int __ret = ioctl((_fd), (_op), (__arg));					       \
+	VFIO_ASSERT_EQ(__ret, 0, "ioctl(%s, %s, %s) returned %d\n", #_fd, #_op, #_arg, __ret); \
+} while (0)
+
+#endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_ASSERT_H */
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
new file mode 100644
index 000000000000..fdb88dc0a5c7
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_IOMMU_H
+#define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_IOMMU_H
+
+#include <linux/types.h>
+
+struct iommu_mode {
+	const char *name;
+	const char *container_path;
+	unsigned long iommu_type;
+};
+
+/*
+ * Generator for VFIO selftests fixture variants that replicate across all
+ * possible IOMMU modes. Tests must define FIXTURE_VARIANT_ADD_IOMMU_MODE()
+ * which should then use FIXTURE_VARIANT_ADD() to create the variant.
+ */
+#define FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(...) \
+FIXTURE_VARIANT_ADD_IOMMU_MODE(vfio_type1_iommu, ##__VA_ARGS__); \
+FIXTURE_VARIANT_ADD_IOMMU_MODE(vfio_type1v2_iommu, ##__VA_ARGS__); \
+FIXTURE_VARIANT_ADD_IOMMU_MODE(iommufd_compat_type1, ##__VA_ARGS__); \
+FIXTURE_VARIANT_ADD_IOMMU_MODE(iommufd_compat_type1v2, ##__VA_ARGS__); \
+FIXTURE_VARIANT_ADD_IOMMU_MODE(iommufd, ##__VA_ARGS__)
+
+typedef u64 iova_t;
+
+#define INVALID_IOVA UINT64_MAX
+
+struct dma_region {
+	struct list_head link;
+	void *vaddr;
+	iova_t iova;
+	u64 size;
+};
+
+struct iommu {
+	const struct iommu_mode *mode;
+	int container_fd;
+	int iommufd;
+	u32 ioas_id;
+	struct list_head dma_regions;
+};
+
+extern const char *default_iommu_mode;
+
+struct iommu *iommu_init(const char *iommu_mode);
+void iommu_cleanup(struct iommu *iommu);
+iova_t iommu_hva2iova(struct iommu *iommu, void *vaddr);
+iova_t __iommu_hva2iova(struct iommu *iommu, void *vaddr);
+void iommu_map(struct iommu *iommu, struct dma_region *region);
+void iommu_unmap(struct iommu *iommu, struct dma_region *region);
+
+#endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_IOMMU_H */
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
new file mode 100644
index 000000000000..0ef27f95d5f8
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -0,0 +1,143 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H
+#define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H
+
+#include <fcntl.h>
+#include <string.h>
+#include <linux/vfio.h>
+#include <linux/list.h>
+#include <linux/pci_regs.h>
+#include <sys/ioctl.h>
+
+#include <libvfio/assert.h>
+#include <libvfio/iommu.h>
+#include <libvfio/vfio_pci_driver.h>
+
+#define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
+#define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
+
+struct vfio_pci_bar {
+	struct vfio_region_info info;
+	void *vaddr;
+};
+
+struct vfio_pci_device {
+	const char *bdf;
+	int fd;
+	int group_fd;
+
+	struct iommu *iommu;
+
+	struct vfio_device_info info;
+	struct vfio_region_info config_space;
+	struct vfio_pci_bar bars[PCI_STD_NUM_BARS];
+
+	struct vfio_irq_info msi_info;
+	struct vfio_irq_info msix_info;
+
+	/* eventfds for MSI and MSI-x interrupts */
+	int msi_eventfds[PCI_MSIX_FLAGS_QSIZE + 1];
+
+	struct vfio_pci_driver driver;
+};
+
+const char *vfio_pci_get_cdev_path(const char *bdf);
+
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf, struct iommu *iommu);
+struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode);
+
+void __vfio_pci_device_cleanup(struct vfio_pci_device *device);
+void vfio_pci_device_cleanup(struct vfio_pci_device *device);
+
+void vfio_pci_device_reset(struct vfio_pci_device *device);
+
+static inline void vfio_pci_dma_map(struct vfio_pci_device *device,
+				    struct dma_region *region)
+{
+	return iommu_map(device->iommu, region);
+}
+
+static inline void vfio_pci_dma_unmap(struct vfio_pci_device *device,
+				      struct dma_region *region)
+{
+	return iommu_unmap(device->iommu, region);
+}
+
+void vfio_pci_config_access(struct vfio_pci_device *device, bool write,
+			    size_t config, size_t size, void *data);
+
+#define vfio_pci_config_read(_device, _offset, _type) ({			    \
+	_type __data;								    \
+	vfio_pci_config_access((_device), false, _offset, sizeof(__data), &__data); \
+	__data;									    \
+})
+
+#define vfio_pci_config_readb(_d, _o) vfio_pci_config_read(_d, _o, u8)
+#define vfio_pci_config_readw(_d, _o) vfio_pci_config_read(_d, _o, u16)
+#define vfio_pci_config_readl(_d, _o) vfio_pci_config_read(_d, _o, u32)
+
+#define vfio_pci_config_write(_device, _offset, _value, _type) do {		  \
+	_type __data = (_value);						  \
+	vfio_pci_config_access((_device), true, _offset, sizeof(_type), &__data); \
+} while (0)
+
+#define vfio_pci_config_writeb(_d, _o, _v) vfio_pci_config_write(_d, _o, _v, u8)
+#define vfio_pci_config_writew(_d, _o, _v) vfio_pci_config_write(_d, _o, _v, u16)
+#define vfio_pci_config_writel(_d, _o, _v) vfio_pci_config_write(_d, _o, _v, u32)
+
+void vfio_pci_irq_enable(struct vfio_pci_device *device, u32 index,
+			 u32 vector, int count);
+void vfio_pci_irq_disable(struct vfio_pci_device *device, u32 index);
+void vfio_pci_irq_trigger(struct vfio_pci_device *device, u32 index, u32 vector);
+
+static inline void fcntl_set_nonblock(int fd)
+{
+	int r;
+
+	r = fcntl(fd, F_GETFL, 0);
+	VFIO_ASSERT_NE(r, -1, "F_GETFL failed for fd %d\n", fd);
+
+	r = fcntl(fd, F_SETFL, r | O_NONBLOCK);
+	VFIO_ASSERT_NE(r, -1, "F_SETFL O_NONBLOCK failed for fd %d\n", fd);
+}
+
+static inline void vfio_pci_msi_enable(struct vfio_pci_device *device,
+				       u32 vector, int count)
+{
+	vfio_pci_irq_enable(device, VFIO_PCI_MSI_IRQ_INDEX, vector, count);
+}
+
+static inline void vfio_pci_msi_disable(struct vfio_pci_device *device)
+{
+	vfio_pci_irq_disable(device, VFIO_PCI_MSI_IRQ_INDEX);
+}
+
+static inline void vfio_pci_msix_enable(struct vfio_pci_device *device,
+					u32 vector, int count)
+{
+	vfio_pci_irq_enable(device, VFIO_PCI_MSIX_IRQ_INDEX, vector, count);
+}
+
+static inline void vfio_pci_msix_disable(struct vfio_pci_device *device)
+{
+	vfio_pci_irq_disable(device, VFIO_PCI_MSIX_IRQ_INDEX);
+}
+
+static inline iova_t __to_iova(struct vfio_pci_device *device, void *vaddr)
+{
+	return __iommu_hva2iova(device->iommu, vaddr);
+}
+
+static inline iova_t to_iova(struct vfio_pci_device *device, void *vaddr)
+{
+	return iommu_hva2iova(device->iommu, vaddr);
+}
+
+static inline bool vfio_pci_device_match(struct vfio_pci_device *device,
+					 u16 vendor_id, u16 device_id)
+{
+	return (vendor_id == vfio_pci_config_readw(device, PCI_VENDOR_ID)) &&
+		(device_id == vfio_pci_config_readw(device, PCI_DEVICE_ID));
+}
+
+#endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H */
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
new file mode 100644
index 000000000000..6653e786e98a
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DRIVER_H
+#define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DRIVER_H
+
+#include <linux/types.h>
+#include <libvfio/iommu.h>
+
+struct vfio_pci_device;
+
+struct vfio_pci_driver_ops {
+	const char *name;
+
+	/**
+	 * @probe() - Check if the driver supports the given device.
+	 *
+	 * Return: 0 on success, non-0 on failure.
+	 */
+	int (*probe)(struct vfio_pci_device *device);
+
+	/**
+	 * @init() - Initialize the driver for @device.
+	 *
+	 * Must be called after device->driver.region has been initialized.
+	 */
+	void (*init)(struct vfio_pci_device *device);
+
+	/**
+	 * remove() - Deinitialize the driver for @device.
+	 */
+	void (*remove)(struct vfio_pci_device *device);
+
+	/**
+	 * memcpy_start() - Kick off @count repeated memcpy operations from
+	 * [@src, @src + @size) to [@dst, @dst + @size).
+	 *
+	 * Guarantees:
+	 *  - The device will attempt DMA reads on [src, src + size).
+	 *  - The device will attempt DMA writes on [dst, dst + size).
+	 *  - The device will not generate any interrupts.
+	 *
+	 * memcpy_start() returns immediately, it does not wait for the
+	 * copies to complete.
+	 */
+	void (*memcpy_start)(struct vfio_pci_device *device,
+			     iova_t src, iova_t dst, u64 size, u64 count);
+
+	/**
+	 * memcpy_wait() - Wait until the memcpy operations started by
+	 * memcpy_start() have finished.
+	 *
+	 * Guarantees:
+	 *  - All in-flight DMAs initiated by memcpy_start() are fully complete
+	 *    before memcpy_wait() returns.
+	 *
+	 * Returns non-0 if the driver detects that an error occurred during the
+	 * memcpy, 0 otherwise.
+	 */
+	int (*memcpy_wait)(struct vfio_pci_device *device);
+
+	/**
+	 * send_msi() - Make the device send the MSI device->driver.msi.
+	 *
+	 * Guarantees:
+	 *  - The device will send the MSI once.
+	 */
+	void (*send_msi)(struct vfio_pci_device *device);
+};
+
+struct vfio_pci_driver {
+	const struct vfio_pci_driver_ops *ops;
+	bool initialized;
+	bool memcpy_in_progress;
+
+	/* Region to be used by the driver (e.g. for in-memory descriptors) */
+	struct dma_region region;
+
+	/* The maximum size that can be passed to memcpy_start(). */
+	u64 max_memcpy_size;
+
+	/* The maximum count that can be passed to memcpy_start(). */
+	u64 max_memcpy_count;
+
+	/* The MSI vector the device will signal in ops->send_msi(). */
+	int msi;
+};
+
+void vfio_pci_driver_probe(struct vfio_pci_device *device);
+void vfio_pci_driver_init(struct vfio_pci_device *device);
+void vfio_pci_driver_remove(struct vfio_pci_device *device);
+int vfio_pci_driver_memcpy(struct vfio_pci_device *device,
+			   iova_t src, iova_t dst, u64 size);
+void vfio_pci_driver_memcpy_start(struct vfio_pci_device *device,
+				  iova_t src, iova_t dst, u64 size,
+				  u64 count);
+int vfio_pci_driver_memcpy_wait(struct vfio_pci_device *device);
+void vfio_pci_driver_send_msi(struct vfio_pci_device *device);
+
+#endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DRIVER_H */
diff --git a/tools/testing/selftests/vfio/lib/libvfio.c b/tools/testing/selftests/vfio/lib/libvfio.c
new file mode 100644
index 000000000000..fa5ef796842e
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/libvfio.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "../../../kselftest.h"
+#include <libvfio.h>
+
+static bool is_bdf(const char *str)
+{
+	unsigned int s, b, d, f;
+	int length, count;
+
+	count = sscanf(str, "%4x:%2x:%2x.%2x%n", &s, &b, &d, &f, &length);
+	return count == 4 && length == strlen(str);
+}
+
+static char **vfio_selftests_get_bdfs_cmdline(int *argc, char *argv[], int *nr_bdfs)
+{
+	int i;
+
+	for (i = *argc - 1; i > 0 && is_bdf(argv[i]); i--)
+		continue;
+
+	i++;
+	*nr_bdfs = *argc - i;
+	*argc -= *nr_bdfs;
+
+	return *nr_bdfs ? &argv[i] : NULL;
+}
+
+static char **vfio_selftests_get_bdfs_env(int *argc, char *argv[], int *nr_bdfs)
+{
+	static char *bdf;
+
+	bdf = getenv("VFIO_SELFTESTS_BDF");
+	if (!bdf)
+		return NULL;
+
+	*nr_bdfs = 1;
+	VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
+
+	return &bdf;
+}
+
+char **vfio_selftests_get_bdfs(int *argc, char *argv[], int *nr_bdfs)
+{
+	char **bdfs;
+
+	bdfs = vfio_selftests_get_bdfs_cmdline(argc, argv, nr_bdfs);
+	if (bdfs)
+		return bdfs;
+
+	bdfs = vfio_selftests_get_bdfs_env(argc, argv, nr_bdfs);
+	if (bdfs)
+		return bdfs;
+
+	fprintf(stderr, "Unable to determine which device(s) to use, skipping test.\n");
+	fprintf(stderr, "\n");
+	fprintf(stderr, "To pass the device address via environment variable:\n");
+	fprintf(stderr, "\n");
+	fprintf(stderr, "    export VFIO_SELFTESTS_BDF=\"segment:bus:device.function\"\n");
+	fprintf(stderr, "    %s [options]\n", argv[0]);
+	fprintf(stderr, "\n");
+	fprintf(stderr, "To pass the device address(es) via argv:\n");
+	fprintf(stderr, "\n");
+	fprintf(stderr, "    %s [options] segment:bus:device.function ...\n", argv[0]);
+	fprintf(stderr, "\n");
+	exit(KSFT_SKIP);
+}
+
+const char *vfio_selftests_get_bdf(int *argc, char *argv[])
+{
+	int nr_bdfs;
+
+	return vfio_selftests_get_bdfs(argc, argv, &nr_bdfs)[0];
+}
diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
index 1d53311e2610..6bcd89f7f8ee 100644
--- a/tools/testing/selftests/vfio/lib/libvfio.mk
+++ b/tools/testing/selftests/vfio/lib/libvfio.mk
@@ -3,7 +3,8 @@ ARCH ?= $(SUBARCH)
 
 VFIO_DIR := $(selfdir)/vfio
 
-LIBVFIO_C := lib/iommu.c
+LIBVFIO_C := lib/libvfio.c
+LIBVFIO_C += lib/iommu.c
 LIBVFIO_C += lib/vfio_pci_device.c
 LIBVFIO_C += lib/vfio_pci_driver.c
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 909c951eb52f..e5e08b28744d 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -388,73 +388,3 @@ void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 	__vfio_pci_device_cleanup(device);
 	iommu_cleanup(iommu);
 }
-
-static bool is_bdf(const char *str)
-{
-	unsigned int s, b, d, f;
-	int length, count;
-
-	count = sscanf(str, "%4x:%2x:%2x.%2x%n", &s, &b, &d, &f, &length);
-	return count == 4 && length == strlen(str);
-}
-
-static char **vfio_selftests_get_bdfs_cmdline(int *argc, char *argv[], int *nr_bdfs)
-{
-	int i;
-
-	for (i = *argc - 1; i > 0 && is_bdf(argv[i]); i--)
-		continue;
-
-	i++;
-	*nr_bdfs = *argc - i;
-	*argc -= *nr_bdfs;
-
-	return *nr_bdfs ? &argv[i] : NULL;
-}
-
-static char **vfio_selftests_get_bdfs_env(int *argc, char *argv[], int *nr_bdfs)
-{
-	static char *bdf;
-
-	bdf = getenv("VFIO_SELFTESTS_BDF");
-	if (!bdf)
-		return NULL;
-
-	*nr_bdfs = 1;
-	VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
-
-	return &bdf;
-}
-
-char **vfio_selftests_get_bdfs(int *argc, char *argv[], int *nr_bdfs)
-{
-	char **bdfs;
-
-	bdfs = vfio_selftests_get_bdfs_cmdline(argc, argv, nr_bdfs);
-	if (bdfs)
-		return bdfs;
-
-	bdfs = vfio_selftests_get_bdfs_env(argc, argv, nr_bdfs);
-	if (bdfs)
-		return bdfs;
-
-	fprintf(stderr, "Unable to determine which device(s) to use, skipping test.\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "To pass the device address via environment variable:\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "    export VFIO_SELFTESTS_BDF=\"segment:bus:device.function\"\n");
-	fprintf(stderr, "    %s [options]\n", argv[0]);
-	fprintf(stderr, "\n");
-	fprintf(stderr, "To pass the device address(es) via argv:\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "    %s [options] segment:bus:device.function ...\n", argv[0]);
-	fprintf(stderr, "\n");
-	exit(KSFT_SKIP);
-}
-
-const char *vfio_selftests_get_bdf(int *argc, char *argv[])
-{
-	int nr_bdfs;
-
-	return vfio_selftests_get_bdfs(argc, argv, &nr_bdfs)[0];
-}
-- 
2.51.0.710.ga91ca5db03-goog


