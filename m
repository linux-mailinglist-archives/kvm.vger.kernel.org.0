Return-Path: <kvm+bounces-69621-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cBs0EzTRe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69621-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:29:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C72CB4B2C
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:29:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 749D93028247
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D79E635D5E3;
	Thu, 29 Jan 2026 21:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uolrwHUK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9311F366DC9
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721968; cv=none; b=aQQwpMraDEjABjcryLpBNnVL60cl6Wf/2ZtoMFV4mB/k2Z0tVSqjHn3zyRJCCT+0/2axK0TBaxQmndoFhDwjIYJxJjlOc1RGkTOJrlHDPPo8RW8ZNtlZ2goMtU5+vJanEdYDNkQgVS2Q+PABe/lIFLS4nXZcyc0FhyVkAIGzHEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721968; c=relaxed/simple;
	bh=PAHReE1IBOjJ0GFM21TbxazaUD0k808+5LV95g4EPBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cCCznFxEtkFbegdhRuWDyMEALtcs1bfXPOq3lcfFSbKJQeXutQ2tcTx8o42AI1f8fRiClgl5vKQhA8HD8gHL1yHYBiN6HfgjlhsUHlSnE8CISUqAME8tGIYq5SnFQad4DZD33+p+aZ1hRS4L3fSj9Ow0N7+KfAyLDCB2Miu1ofc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uolrwHUK; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6124a9fb86so2905071a12.3
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721966; x=1770326766; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lEyO5iRGiN+9INh5ffm6tFBNJ0ZoJ+9Z1mvOjrL+acQ=;
        b=uolrwHUK+ADR1fqMMEb7X3dZUBZuYgaFaErvFKNbRPZulQfQ1BRIW+G8SMHgPhtDv8
         SFpDkB9ZiaRkBqiPbzplTtnkWTuxlT/qqAMaCrkF9y5rYVTjOXbLETArjnTJIUtofL+F
         yKF9J28YHUWFklDs1q70eeAN7n4bzZcj7BtQa51xsNtHBV1wwUxQXMYglPBclTastCLc
         RW9A94PdSRu4ONAS1cGJdATVlH5M+E2N5oHpT0SRCxAasPJ4r6IYky9zgg9fdUCTWsUc
         pS0LvR/e6kvriGtEck1sgynOqFh+xpmP4vPOGYCpFrf+/K15WQTZH05yPJyJCvOES9J2
         8/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721966; x=1770326766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lEyO5iRGiN+9INh5ffm6tFBNJ0ZoJ+9Z1mvOjrL+acQ=;
        b=R2USlRB16TOYlMSe4SD/nGDQQXY2rS5uYmpfDIf7mVBRGu8FN7J6PKd6nFAJyhh4jY
         vcC29YXIziEI4XYV1BnU0vDOjzDWIrHnLYxs804TomuNwCEhGXNvr0rdvKxa5Cneu613
         b+s8F0qJmiYK9AclJfbkZtZkPCNYFNAX9QulhNVHN7cRCWpDUBkDud9yeCNpQPBc7k3n
         irM3RTdcQEE9vim1x6kde30M4PdyUH9CljZoSca2AfIHhe3ZylCaJnlV4VbokAwE6ZD6
         lYgbU9DPDaCqShbog6TZ/DZ29Z/y9iAbJD4KvTKbAUOL+W4ncGw5bJVY49GuQAr0cRez
         jsAw==
X-Forwarded-Encrypted: i=1; AJvYcCVyIFhpeUrIQwb/1hvKDsFNpydmpnAtRHiDInsLF446Nr2IQXfxT8HFpNry17Y1a8CuzzY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDCWKiL/+Ke7SPRAUp4d5HEkEEwNi2xVq5AiB0e0bOgTqJIZEu
	2Ol1MTJVq2eA+gkFpvU/cSV4VuFuzsrutR2nl6P3KhD+uqXVoviAqyrdV97Y1GHM82PgLXxKqMx
	75bc6Nd/W/eGZUQ==
X-Received: from pgbdo6.prod.google.com ([2002:a05:6a02:e86:b0:c08:9db4:d5cb])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6f89:b0:35c:e441:e6d2 with SMTP id adf61e73a8af0-392dfff5a08mr409686637.7.1769721965922;
 Thu, 29 Jan 2026 13:26:05 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:04 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-18-dmatlack@google.com>
Subject: [PATCH v2 17/22] vfio: selftests: Initialize vfio_pci_device using a
 VFIO cdev FD
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69621-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2C72CB4B2C
X-Rspamd-Action: no action

From: Vipin Sharma <vipinsh@google.com>

Use the given VFIO cdev FD to initialize vfio_pci_device in VFIO
selftests. Add the assertion to make sure that passed cdev FD is not
used with legacy VFIO APIs. If VFIO cdev FD is provided then do not open
the device instead use the FD for any interaction with the device.

This API will allow to write selftests where VFIO device FD is preserved
using liveupdate and retrieved later using liveupdate ioctl after kexec.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../lib/include/libvfio/vfio_pci_device.h     |  3 ++
 .../selftests/vfio/lib/vfio_pci_device.c      | 33 ++++++++++++++-----
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 2858885a89bb..896dfde88118 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -38,6 +38,9 @@ struct vfio_pci_device {
 #define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
 #define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
 
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
+					       struct iommu *iommu,
+					       int device_fd);
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index fac4c0ecadef..08bb582eaa8f 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -318,19 +318,27 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
 	ioctl_assert(device_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &args);
 }
 
-static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *bdf)
+static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
+				   const char *bdf, int device_fd)
 {
-	const char *cdev_path = vfio_pci_get_cdev_path(bdf);
+	const char *cdev_path;
 
-	device->fd = open(cdev_path, O_RDWR);
-	VFIO_ASSERT_GE(device->fd, 0);
-	free((void *)cdev_path);
+	if (device_fd >= 0) {
+		device->fd = device_fd;
+	} else {
+		cdev_path = vfio_pci_get_cdev_path(bdf);
+		device->fd = open(cdev_path, O_RDWR);
+		VFIO_ASSERT_GE(device->fd, 0);
+		free((void *)cdev_path);
+	}
 
 	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd);
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
+					       struct iommu *iommu,
+					       int device_fd)
 {
 	struct vfio_pci_device *device;
 
@@ -341,10 +349,12 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
 	device->iommu = iommu;
 	device->bdf = bdf;
 
-	if (iommu->mode->container_path)
+	if (iommu->mode->container_path) {
+		VFIO_ASSERT_EQ(device_fd, -1);
 		vfio_pci_container_setup(device, bdf);
-	else
-		vfio_pci_iommufd_setup(device, bdf);
+	} else {
+		vfio_pci_iommufd_setup(device, bdf, device_fd);
+	}
 
 	vfio_pci_device_setup(device);
 	vfio_pci_driver_probe(device);
@@ -352,6 +362,11 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
 	return device;
 }
 
+struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+{
+	return __vfio_pci_device_init(bdf, iommu, /*device_fd=*/-1);
+}
+
 void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 {
 	int i;
-- 
2.53.0.rc1.225.gd81095ad13-goog


