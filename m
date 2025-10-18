Return-Path: <kvm+bounces-60420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4DDBBEC217
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E87340A6FF
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 00:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7527214A64;
	Sat, 18 Oct 2025 00:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rjYNxdbg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C15A1F4617
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 00:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746064; cv=none; b=WQ/QPfk7l7WSZ+5AN3MC1+B/sY9kN28Dr8PAMVep9cBHPFMlB/apC3vihrl+AU7PmnhAwBbFtvgg+H1pJmyLj2EQTsjWfTo/4ccEE8ngC9IO5XaYZ00nAMfe6VMITTjpP6r0YYUnLQzMmVmS8n7oaPzJpzZEwkNi7RvjTcTD6ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746064; c=relaxed/simple;
	bh=Zxz213bnVu4PytMrWtldNoB5RbSMv3rpGoHLoxMbz8o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ei/UD0bmql+NwuNsfb2lZI5sdSpVBfD1j4/S0JIaVgbAeRl6vUEy2Zk5iY8qIzq3LvV1Em4+xRByfwH7DuiwY29p0edhjYIyhi/5AYlXLafUxNt2p4CInUkicc/2jbgxgIwkYgOD3zrpJ3WHQAnGm4ve5A7pTKTCJy0QpSb5ITg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rjYNxdbg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33c6140336eso1845273a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 17:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760746062; x=1761350862; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xxD/Cw9jyxG7ivQQV697wV0O8b/3dIW50+ry6yUBLsE=;
        b=rjYNxdbgkeA9Ic725M8o7FLT88khjBrEUJuwj09S5ZV7oDtUnH5X8zg/oJ42cSULtA
         3C8rp0yyxLUem98Qm2I5yQG5wArE2cx5xiA/RkvsyMERttwiBQGynOgeuYihuomORrl9
         sw9AYXrFIg9nFpJvKkFjQhU64sfYSGPvwLBBng8HPEVUUFcSXolYOJPpyDd9lt20lr1v
         iSkpnVjWWcW1FUJ4TVXjN74wkNLW9s2RXegGjc9rxlr/jgRNfxLd/KR10W+reMqSqQUf
         oYJxPobaEglhhJ3ev6zkd293Ifb2tF6+MW8XFPHTEcc7LjYOxkkR1ocS6578YtsTUx9y
         Qhpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760746062; x=1761350862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xxD/Cw9jyxG7ivQQV697wV0O8b/3dIW50+ry6yUBLsE=;
        b=XWNOKOOQGMfahV1pk6EPEtUOGblPQzVYK3G2yztmd1H4eqmdzwggwH1d4bPn1RS/pY
         LX+gl895IZM7jNASbjJ9q8/ZzvEL8VaFf6MUOcf1+3WepuXELX8xGjac764CbbTtIKXL
         KI6LL91NIxyhFzjiKRE1yqmCy8kKLcWyw7EeAVZBic1sPwb0GLdUp2oTn9Ha3yNJ/05u
         suZvKbgZNFE8bJrICXDdVMoCAkQPEFfeyXwZ81y3LWOiU4p0OT6r2L4zCr3rQBz7/Pa9
         sRjyIyOXLSPek7wz1OUzYfdPMyFaC3MhVZnPjwA1fwq5lfJL9+tw6jtGTydXD3tB7/YI
         8Qhw==
X-Forwarded-Encrypted: i=1; AJvYcCUcpW79KELC30IYQzR3NgZdSl6uk2eOG21mYTwZGXpurlEAs5o7VsT0T0KSSyBtZ1A+7ek=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNFEb3gnhwnF5poaP4hSPxbrYpITJoxBqWa6Gt9CC15yIE/D66
	Rq8zAkqUGHK4yYhNO0m8val0UdulDfblMFH1gAXfotw1KnhHMjgOerIb2MFNybDHaSzom51gXFu
	x3iDB49q5Jw==
X-Google-Smtp-Source: AGHT+IGvT4gSxZumpaRuwK33oT1VTteqUw6nohwluWluZWlr9C8TOLWOTIAP6j/iKx3fcI6xg3+HQZq1UcLw
X-Received: from pjre17.prod.google.com ([2002:a17:90a:b391:b0:33b:51fe:1a89])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:180e:b0:32e:73fd:81a3
 with SMTP id 98e67ed59e1d1-33bcf93dfbdmr7878362a91.33.1760746062232; Fri, 17
 Oct 2025 17:07:42 -0700 (PDT)
Date: Fri, 17 Oct 2025 17:07:03 -0700
In-Reply-To: <20251018000713.677779-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251018000713.677779-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251018000713.677779-12-vipinsh@google.com>
Subject: [RFC PATCH 11/21] vfio/pci: Skip clearing bus master on live update
 device during kexec
From: Vipin Sharma <vipinsh@google.com>
To: bhelgaas@google.com, alex.williamson@redhat.com, pasha.tatashin@soleen.com, 
	dmatlack@google.com, jgg@ziepe.ca, graf@amazon.com
Cc: pratyush@kernel.org, gregkh@linuxfoundation.org, chrisl@kernel.org, 
	rppt@kernel.org, skhawaja@google.com, parav@nvidia.com, saeedm@nvidia.com, 
	kevin.tian@intel.com, jrhilke@google.com, david@redhat.com, 
	jgowans@amazon.com, dwmw2@infradead.org, epetron@amazon.de, 
	junaids@google.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Set skip_kexec_clear_master on live update prepare() so that the device
participating in live update can continue to perform DMA during kexec
phase.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 8e0ee01127b3..789b52665e35 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -54,6 +54,7 @@ static int vfio_pci_liveupdate_prepare(struct liveupdate_file_handler *handler,
 		goto err_free_folio;
 
 	*data = virt_to_phys(ser);
+	vdev->pdev->skip_kexec_clear_master = true;
 
 	return 0;
 
@@ -67,7 +68,12 @@ static void vfio_pci_liveupdate_cancel(struct liveupdate_file_handler *handler,
 {
 	struct vfio_pci_core_device_ser *ser = phys_to_virt(data);
 	struct folio *folio = virt_to_folio(ser);
+	struct vfio_pci_core_device *vdev;
+	struct vfio_device *device;
 
+	device = vfio_device_from_file(file);
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	vdev->pdev->skip_kexec_clear_master = false;
 	WARN_ON_ONCE(kho_unpreserve_folio(folio));
 	folio_put(folio);
 }
-- 
2.51.0.858.gf9c4a03a3a-goog


