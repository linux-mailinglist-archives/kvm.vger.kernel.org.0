Return-Path: <kvm+bounces-72127-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0M1bFVk4oWkbrQQAu9opvQ
	(envelope-from <kvm+bounces-72127-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 07:23:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EB4F11B334C
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 07:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5246030C8283
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 06:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92693E958E;
	Fri, 27 Feb 2026 06:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fVjxCfjr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4F53E9F78
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 06:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772173018; cv=none; b=gyKigqRApe8bQBYUe8uB3yYr6eBIMABBVlf4pt6iZMG/cSm2hicsC60xJz9W5VoeY5rThQA2qeT/tCqyA9IHyGMYUF7gUa02p0subRyUM9Fe2llV01HLAUevXwL5uMQ7/B4Q9vBvXDQF7RtPjKXaKE7+pDAfExSyXoLcFMnh3AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772173018; c=relaxed/simple;
	bh=MdLOpx/IWf/OKaXN2DbeVdGINITywi9y78eO/a2PMrY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=quB7fxudvKpGXrRkCHjFp9sDb9cUeBUncBg+DAU8d3t7hfwTETfNa05iTgvlhtNtVl2DA668r795/e3nH1QDuzo2MCqPWovCq/X5fut5KkXyj8WJR6dkLvbsafy25ljfiHgD5/cc6n2HRIjyQdUn0MQaoxIw//MgVdoEe62RI+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fVjxCfjr; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2aad1bb5058so16151745ad.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 22:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772173016; x=1772777816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TBQTSZoZ8QpZw8gStM3hrWmhO0sM5dIUkdb0CVPsHZ4=;
        b=fVjxCfjrLRY+/zllukQdLwdAkHtcNX+5n9ZM0T8hU+WIAV23MkUHB0EouTwXXhblag
         JRwhHUzW7I8k76ZVk6V8+foyR2KGnP/41nD3wa9P9Q3f5yNvwvn7+mdLgyy94BiSqVtP
         lqgPPd+aS9q2whpeIhWbX7N59arx5WAu2Ae+5L5Po8TY/aqt+tUAS/S8IFiLgAolNm4t
         xjeuG2oW8U1DTgFmC50CHe00X0H5ael822fu74fU4Z2sgho6D2fx9WH5GZHvfH2ghNHG
         KC3F212HYHEHZmv4Dii5N12TSB91pZUNgLw+8bKBQWvRLUrTu7Bq7lbh2EtQFUoyJwsF
         fWjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772173016; x=1772777816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBQTSZoZ8QpZw8gStM3hrWmhO0sM5dIUkdb0CVPsHZ4=;
        b=oEtzjxIlrN3C9vym00uvXgyRN4VgUTm9I7gCrc+lh7FCL7lSS2IUMjTq8VNK2knBD4
         Xssc3hXRLTD9vguwFrY36gymg++366L/1ZcW7szNORRFr5KcSjSTM0z4Bi3O7oSfromd
         YfDFwHxl9z8Pl+NzFhmIoy6gKRPJiMw5dZQit338vGJIbb8xu8hQIXoclpCUsQ4Zj/R4
         XLCxjUp/XFLr37AxLZ6O9q3oDd+JEC/B7UNxvctf5/T2gNDorEvv4DtPNg8dYhpkaCkW
         yIWoTNeXyXyX5lswU9A9UCcOMvff/LcXpvc13+dAzJ4KF2RLFzTjo9NkLa3LkJL+mgAm
         No+w==
X-Forwarded-Encrypted: i=1; AJvYcCUZDcaFXpDK/VhX043eSUvyNMKYR3dIskYlc0Kxx/E8JYC1dIWLPaguFMQFVKa8uRXHGHI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxS6c/qZPbtMKuCQwx6HAt799Q9/R6KRU9MUvMgwy7i8jqGBy1b
	k7ajlt0fkRndJRvol7d6zAUxM5o39ArPfQygPKN95QbrUaixy7BCHXeI
X-Gm-Gg: ATEYQzxGPBZ3VGV6ljmSo9z3BUeDZwQwTL1Pv1oQHtzvL84tHVpG5s7YthuA337Fnu3
	Z/n2ffIdzXC26RoMIDnFqc72jU9KnM6oFQMPX9t9cOPokP8FKlbv3d8r9ZGfcPxn4m3klE1xJjD
	H3whdJuJBi+lnF2MYVaaUUZByvEvhOcJbNFORE0tUZgeS4YeCG3FFrMva6hEzZMitgBWEKzPSAr
	Qxe3xWYSZjtIkoI4TiCDCnjHjdhqSBkUcNLS5/ETw9TV/MOWI9TQ2LRajqlkY23FGVVDvlq3VXM
	KWJC8jp8qMvrFN8LIjx8cT15uIEL4Qh7fnb2eSKXsRk1sNQwqKNgh3/91B+qwaUb1YXwiSm/9V7
	thkGby02vYYZJmLeWtJZse85FBnz0a9f42FJ7aP/JJSDdDGU2CIMGkg05QTEGWWATyC2LB8LoXJ
	VzA4R3gnbazTmDAsMDvw==
X-Received: by 2002:a17:902:d2c1:b0:2ad:9edf:7fe5 with SMTP id d9443c01a7336-2ae2e4bce9dmr19427245ad.42.1772173016250;
        Thu, 26 Feb 2026 22:16:56 -0800 (PST)
Received: from dw-tp ([203.81.243.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6d1913sm57837485ad.77.2026.02.26.22.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 22:16:55 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	Peter Xu <peterx@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from switch case to if/else block
Date: Fri, 27 Feb 2026 11:46:36 +0530
Message-ID: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72127-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kvack.org,vger.kernel.org,shazbot.org,redhat.com,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[riteshlist@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EB4F11B334C
X-Rspamd-Action: no action

Architectures like PowerPC uses runtime defined values for
PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
at runtime using kernel cmdline. So the pXd_index_size is not known at
compile time. Without this fix, when we add huge pfn support on powerpc
in the next patch, vfio_pci_core driver compilation can fail with the
following errors.

  CC [M]  drivers/vfio/vfio_main.o
  CC [M]  drivers/vfio/group.o
  CC [M]  drivers/vfio/container.o
  CC [M]  drivers/vfio/virqfd.o
  CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
  CC [M]  drivers/vfio/pci/vfio_pci_core.o
  CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
  CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
  CC [M]  drivers/vfio/pci/vfio_pci_config.o
  CC [M]  drivers/vfio/pci/vfio_pci.o
  AR      kernel/built-in.a
../drivers/vfio/pci/vfio_pci_core.c: In function ‘vfio_pci_vmf_insert_pfn’:
../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not reduce to an integer constant
 1678 |         case PMD_ORDER:
      |         ^~~~
../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not reduce to an integer constant
 1682 |         case PUD_ORDER:
      |         ^~~~
make[6]: *** [../scripts/Makefile.build:289: drivers/vfio/pci/vfio_pci_core.o] Error 1
make[6]: *** Waiting for unfinished jobs....
make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2

Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d43745fe4c84..5395a6f30904 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1670,21 +1670,20 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		return VM_FAULT_SIGBUS;

-	switch (order) {
-	case 0:
+	if (order == 0) {
 		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+	}
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
-	case PMD_ORDER:
+	 else if (order == PMD_ORDER) {
 		return vmf_insert_pfn_pmd(vmf, pfn, false);
+	 }
 #endif
 #ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
-	case PUD_ORDER:
+	 else if (order == PUD_ORDER) {
 		return vmf_insert_pfn_pud(vmf, pfn, false);
-		break;
+	 }
 #endif
-	default:
-		return VM_FAULT_FALLBACK;
-	}
+	return VM_FAULT_FALLBACK;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);

--
2.53.0


