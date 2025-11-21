Return-Path: <kvm+bounces-64205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B19D5C7B467
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:18:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 274D94EFD17
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A92352F9F;
	Fri, 21 Nov 2025 18:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fCQdLYwT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9294A351FB5
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748887; cv=none; b=I4BxQ+IvSeGa3iprdWM8jG4urErG0K5EEW5JwExwyHUZw8GA5iRB3cGA9emUyrTKsCwj2p/LPvRQVM9S2+TEJRhm6Q/9sZxvF93LKnqJKatYzIVeYAJbucL3H9wCYqwYyJnGbqM0wYEjrVg7KMbT8yo7z0Yqmi2W8JpXKXdnmac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748887; c=relaxed/simple;
	bh=0mpt9DrK2EH+/nszyWzaz56fSuMqVTW+MCo2D/grwGY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ab03fy9o5QKkIC91Hr64Ivkr5UcJCHchx8c7+RxloPuSqLcVMVcGgfL9sT02sPiEwGT4K+Uo11cy4YVTffPGObH5iNYNBa74fWYbprCdfu38VFsbRTDjONC8NPq4qvuCHHAh70W7lVyYeKLQk6h7OeN+UNGj4ZU8XaeorWBoll8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fCQdLYwT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295fbc7d4abso35408795ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748885; x=1764353685; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JxeIo10ZephNiFDx/n6CiZynZejR6x/fiOnvLqPApOE=;
        b=fCQdLYwTUHNraYZFyFT7SgERnZENyfiIY5r6nUNnn53rGLt9of1C/nVbKFBg2V+v22
         zu9njHADo7KN3ROjSimIsKfFw7ra392HSTLbzhyMlKYQ/TIFENQ6AVivl2ysIkYt9Zl5
         ynLoGmHWVzEczJY5Zt09jZzC/ticrP9+Fy9eV0ST6v2yUnPxlrpIFQHMsmdtdu7Yty1k
         ssdKSLdFJW0UHCFPGP9WNubAWeLf0i+zexcEZlr3b49u+FtYtwAHROOVuUMC0j/jTs5w
         fMsrhAK22hQpTActx2t2v2i09w6RE13bH5de1GryYUtPUBe5oaGKns4Fnqww+UnqCYYc
         1wPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748885; x=1764353685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JxeIo10ZephNiFDx/n6CiZynZejR6x/fiOnvLqPApOE=;
        b=lRtifqwpAvANVg6dCSOpisb1VqsPh5Ppxxe4MVUP94L/I7ED5+nT2gO/wrcWMnNTe4
         w54aKLhuOtM9G/z3ZzqrGJhycbpBjDrCqkSm4g4Nzj2TDaiGmECytWf56vR08aOxrb7o
         rg9WXbeWAldk2ggO5b1H+EAjkCQKLn24KUussGwvrQ46BKrUtKdnbA5elbc5/FSBNM0c
         nMfb5XMLbTDaZY6xJi0aLvhsSlF+OUpyl5sGODz3jvcY+Yqb3zIXFyZ/NksunNsouvL0
         wbyZMhayXyCRjOJWglZ29onBvZfUDf5Jtdnkxv29y5D94/EOSrOKaATIllKHQstxlAYZ
         QrvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGXikSsw0K44emv6Uj77oGND463HEsrWgM6/QHMYoy81ONuKFGihY22/xs0br3P4TYbxk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrwgWukoC8+ZHcBDr+8W64tZRUsM9kzbfLzPrhWSziTVlU2H+4
	pWVORX0WII0VX1/ufhK7Ux8i82p7DXT19o4T2vPoJi9pT1EjoHBMWb4SZkIrT1+7r+9AqEJFQ4h
	SDcBIsK2Sj2isYg==
X-Google-Smtp-Source: AGHT+IFbLTbWF39tJajkynXW4HbedSaaqh39StKC8XEAGbSVy0Ikmggms+4ZG3tLpOCRvQQJzPyHg6COHAgOQA==
X-Received: from plbkt13.prod.google.com ([2002:a17:903:88d:b0:292:3da1:8ea8])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:440c:b0:297:d697:41e with SMTP id d9443c01a7336-29b6bf3b588mr42912705ad.37.1763748884880;
 Fri, 21 Nov 2025 10:14:44 -0800 (PST)
Date: Fri, 21 Nov 2025 18:14:15 +0000
In-Reply-To: <20251121181429.1421717-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121181429.1421717-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121181429.1421717-5-dmatlack@google.com>
Subject: [PATCH v3 04/18] vfio: selftests: Rename struct vfio_iommu_mode to iommu_mode
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, David Matlack <dmatlack@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename struct vfio_iommu_mode to struct iommu_mode since the mode can
include iommufd. This also prepares for splitting out all the IOMMU code
into its own structs/helpers/files which are independent from the
vfio_pci_device code.

No function change intended.

Reviewed-by: Alex Mastro <amastro@fb.com>
Tested-by: Alex Mastro <amastro@fb.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/include/vfio_util.h | 4 ++--
 tools/testing/selftests/vfio/lib/vfio_pci_device.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 0b9a5628d23e..2f5555138d7f 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -50,7 +50,7 @@
 	VFIO_LOG_AND_EXIT(_fmt, ##__VA_ARGS__);			\
 } while (0)
 
-struct vfio_iommu_mode {
+struct iommu_mode {
 	const char *name;
 	const char *container_path;
 	unsigned long iommu_type;
@@ -166,7 +166,7 @@ struct vfio_pci_driver {
 struct vfio_pci_device {
 	int fd;
 
-	const struct vfio_iommu_mode *iommu_mode;
+	const struct iommu_mode *iommu_mode;
 	int group_fd;
 	int container_fd;
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index eda8f14de797..4a021ff4fc40 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -713,7 +713,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 }
 
 /* Reminder: Keep in sync with FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(). */
-static const struct vfio_iommu_mode iommu_modes[] = {
+static const struct iommu_mode iommu_modes[] = {
 	{
 		.name = "vfio_type1_iommu",
 		.container_path = "/dev/vfio/vfio",
@@ -741,7 +741,7 @@ static const struct vfio_iommu_mode iommu_modes[] = {
 
 const char *default_iommu_mode = "iommufd";
 
-static const struct vfio_iommu_mode *lookup_iommu_mode(const char *iommu_mode)
+static const struct iommu_mode *lookup_iommu_mode(const char *iommu_mode)
 {
 	int i;
 
-- 
2.52.0.rc2.455.g230fcf2819-goog


