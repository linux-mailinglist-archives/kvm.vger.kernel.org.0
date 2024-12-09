Return-Path: <kvm+bounces-33304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7F59E95E8
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 14:11:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 196EC282413
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 13:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845EA22F3BA;
	Mon,  9 Dec 2024 13:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="apV6vhGJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF0422D4E8
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 13:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733749616; cv=none; b=lkLpMbLBO5UITyzppUZnYz7NqQV2WJDZf17ywmKYAL2P/tlOOq0TOqftAA1mUXiLJtPKeVmN40/kqs+1KPeM8lCnaYVYcXP0VodoDY+zhcD9pFszt83Jfzpy6gvx5buOlQFTBEhiCMujuKLifDMiCHnyYutmb95ntuvu4690Bd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733749616; c=relaxed/simple;
	bh=Pp8IL9cwVd3G7A/P5OrgHCKDWhxnnnGxe9vEBoWdRJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQhRoPfWAuRx9NPqc6KhnkVMWKHd+MkSklh6kdBnu0w8UKLGo2UOR6DPdIuZMA1w3VaGrWVEZBgr7SSW1JSmfyjtR/+BBHJCsBz+IzcQq9fNFXUMDOCRsoSNGY6Eqn/jClT95VmQm9fhiSaVDqOPC7yr+yHNLxNHeHtHUAzsdmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=apV6vhGJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733749612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LjtlDqjVbjjdLVPvux+VnzDcjHru5NMyBrbq6sIUPEE=;
	b=apV6vhGJqe3Iur/zb71LXkkDlQ1F+KhhyI0OcTYBTDI19Y76PdNPTuIJbw8W4j7wmiGRpn
	tX6NTrdjbUXx/WhX2yzikh6shpncQXnEYXdaYKSP5YiR8zZ1ByQ000vWhixeVSnk9t5spJ
	tWoP7TVSdNlaOggxmFuVdHRj2Bh9pXU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-MWBeEssQO-SLIHo-wGd8cw-1; Mon, 09 Dec 2024 08:06:49 -0500
X-MC-Unique: MWBeEssQO-SLIHo-wGd8cw-1
X-Mimecast-MFC-AGG-ID: MWBeEssQO-SLIHo-wGd8cw
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385e1339790so2818244f8f.2
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 05:06:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733749608; x=1734354408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LjtlDqjVbjjdLVPvux+VnzDcjHru5NMyBrbq6sIUPEE=;
        b=fwdtrX/NAiR7X1IwUg7uVNTA/wr4emHN1LqyHI7WSIIenmspLKCei7bvZMae7cAsng
         4tb44WB6GYr4bGmIrQ58u+XlQZf76ypCMwAykxnh5tEaVJDMCAzibts6z3EZa1eeZiBX
         xD4bO0LNllph4obvkZpzOkf2uWOFgf+16jtPzvzf9uWr+wXMeJGi2Pv66FP9yTW36ahz
         6nReJaPsUoWp3Cf7/8ygUELjEadc2Pv+sc0vWW1JDiUjqGObEEHNnxJCTBd/MP/L8Qgv
         8Acm4QhobxNr08JuSeRn/vZSd6BK8LYabBUOvvVeRoOP1qaEZrZC5s+AsKWp9P9e5hO1
         wF3g==
X-Forwarded-Encrypted: i=1; AJvYcCVa7RtiPubzln8n+vP1gmsrQiH3xowja3s5BJu0YX9iGAAlsbjoxvkBHaVwnyo2ImBSAlI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXCkFKTRQjlSN/6b9DLhpddZInHOfUCId4VFVy5108a4+vMC3Q
	CIp6gd7lcj+oRbVSQr0cEk5X413B/xbvCRvZWxmM2q3ahj/AXJut1xX3jdRPQFyX9upr/SGG445
	pMLmPLglERWczOHXHVg2/Rm4Bhr+P518AwWLZ/rsTsFYkNh5l8w==
X-Gm-Gg: ASbGnctJWIdKlJX02rqYMPXZBM2DyeAQMEReOMwEGTJH3aHPp5hfOYfNhXL9Op8pFpC
	fTBM7zb/5U5ZtNRnve0qhHAIhZUzBaJb9s/fkFtBVvak6Et8LlMme04uPDOEJJ+AzXdjgd8jEGJ
	B8bRt64cHURh1fJG75zuOyXzWO+/c6O7qd0/buD3pWJcwBxbpcbu7z2jwmeK5jbhvyjGVAiUpQE
	pI+ANxOij5AFr+xs+HuuAt4HIXcdtHCYKXk2lijLherL1JRVT1pwPbO/25+iUuxjLC2w4fhkd8+
	ublxNqSQ
X-Received: by 2002:a5d:6c65:0:b0:385:ebaf:3824 with SMTP id ffacd0b85a97d-386453e1638mr347907f8f.27.1733749608227;
        Mon, 09 Dec 2024 05:06:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFe4lx/EENwtCaRxhJCz0NOg0TrCmZKbhSzjlYB6+7PsBpCd1abctGiIUuR4mdyx/fkgNv7cA==
X-Received: by 2002:a5d:6c65:0:b0:385:ebaf:3824 with SMTP id ffacd0b85a97d-386453e1638mr347789f8f.27.1733749607612;
        Mon, 09 Dec 2024 05:06:47 -0800 (PST)
Received: from eisenberg.redhat.com (nat-pool-muc-u.redhat.com. [149.14.88.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3862190965asm13200127f8f.82.2024.12.09.05.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 05:06:47 -0800 (PST)
From: Philipp Stanner <pstanner@redhat.com>
To: amien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alex Dubov <oakad@yahoo.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rasesh Mody <rmody@marvell.com>,
	GR-Linux-NIC-Dev@marvell.com,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sanjay R Mehta <sanju.mehta@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Jon Mason <jdmason@kudzu.us>,
	Dave Jiang <dave.jiang@intel.com>,
	Allen Hubbe <allenbh@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Chen Ni <nichen@iscas.ac.cn>,
	Philipp Stanner <pstanner@redhat.com>,
	Ricky Wu <ricky_wu@realtek.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Breno Leitao <leitao@debian.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Kevin Tian <kevin.tian@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yi Liu <yi.l.liu@intel.com>,
	Kunwu Chan <chentao@kylinos.cn>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ye Bin <yebin10@huawei.com>
Cc: linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ntb@lists.linux.dev,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH v3 01/11] PCI: Prepare removing devres from pci_intx()
Date: Mon,  9 Dec 2024 14:06:23 +0100
Message-ID: <20241209130632.132074-3-pstanner@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241209130632.132074-2-pstanner@redhat.com>
References: <20241209130632.132074-2-pstanner@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pci_intx() is a hybrid function which sometimes performs devres
operations, depending on whether pcim_enable_device() has been used to
enable the pci_dev. This sometimes-managed nature of the function is
problematic. Notably, it causes the function to allocate under some
circumstances which makes it unusable from interrupt context.

To, ultimately, remove the hybrid nature from pci_intx(), it is first
necessary to provide an always-managed and a never-managed version
of that function. Then, all callers of pci_intx() can be ported to the
version they need, depending whether they use pci_enable_device() or
pcim_enable_device().

An always-managed function exists, namely pcim_intx(), for which
__pcim_intx(), a never-managed version of pci_intx() has been
implemented.

Make __pcim_intx() a public function under the name
pci_intx_unmanaged(). Make pcim_intx() a public function.

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/pci/devres.c | 24 +++---------------------
 drivers/pci/pci.c    | 29 +++++++++++++++++++++++++++++
 include/linux/pci.h  |  2 ++
 3 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/devres.c b/drivers/pci/devres.c
index 3b59a86a764b..3594eea37993 100644
--- a/drivers/pci/devres.c
+++ b/drivers/pci/devres.c
@@ -411,31 +411,12 @@ static inline bool mask_contains_bar(int mask, int bar)
 	return mask & BIT(bar);
 }
 
-/*
- * This is a copy of pci_intx() used to bypass the problem of recursive
- * function calls due to the hybrid nature of pci_intx().
- */
-static void __pcim_intx(struct pci_dev *pdev, int enable)
-{
-	u16 pci_command, new;
-
-	pci_read_config_word(pdev, PCI_COMMAND, &pci_command);
-
-	if (enable)
-		new = pci_command & ~PCI_COMMAND_INTX_DISABLE;
-	else
-		new = pci_command | PCI_COMMAND_INTX_DISABLE;
-
-	if (new != pci_command)
-		pci_write_config_word(pdev, PCI_COMMAND, new);
-}
-
 static void pcim_intx_restore(struct device *dev, void *data)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct pcim_intx_devres *res = data;
 
-	__pcim_intx(pdev, res->orig_intx);
+	pci_intx_unmanaged(pdev, res->orig_intx);
 }
 
 static struct pcim_intx_devres *get_or_create_intx_devres(struct device *dev)
@@ -472,10 +453,11 @@ int pcim_intx(struct pci_dev *pdev, int enable)
 		return -ENOMEM;
 
 	res->orig_intx = !enable;
-	__pcim_intx(pdev, enable);
+	pci_intx_unmanaged(pdev, enable);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(pcim_intx);
 
 static void pcim_disable_device(void *pdev_raw)
 {
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 0b29ec6e8e5e..30d17ec771fc 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4482,6 +4482,35 @@ void pci_disable_parity(struct pci_dev *dev)
 	}
 }
 
+/**
+ * pci_intx_unmanaged - enables/disables PCI INTx for device dev,
+ * unmanaged version
+ * @pdev: the PCI device to operate on
+ * @enable: boolean: whether to enable or disable PCI INTx
+ *
+ * Enables/disables PCI INTx for device @pdev
+ *
+ * This function behavios identically to pci_intx(), but is never managed with
+ * devres.
+ */
+void pci_intx_unmanaged(struct pci_dev *pdev, int enable)
+{
+	u16 pci_command, new;
+
+	pci_read_config_word(pdev, PCI_COMMAND, &pci_command);
+
+	if (enable)
+		new = pci_command & ~PCI_COMMAND_INTX_DISABLE;
+	else
+		new = pci_command | PCI_COMMAND_INTX_DISABLE;
+
+	if (new == pci_command)
+		return;
+
+	pci_write_config_word(pdev, PCI_COMMAND, new);
+}
+EXPORT_SYMBOL_GPL(pci_intx_unmanaged);
+
 /**
  * pci_intx - enables/disables PCI INTx for device dev
  * @pdev: the PCI device to operate on
diff --git a/include/linux/pci.h b/include/linux/pci.h
index db9b47ce3eef..b5eb8bda655d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1350,6 +1350,7 @@ int __must_check pcim_set_mwi(struct pci_dev *dev);
 int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_disable_parity(struct pci_dev *dev);
+void pci_intx_unmanaged(struct pci_dev *pdev, int enable);
 void pci_intx(struct pci_dev *dev, int enable);
 bool pci_check_and_mask_intx(struct pci_dev *dev);
 bool pci_check_and_unmask_intx(struct pci_dev *dev);
@@ -2297,6 +2298,7 @@ static inline void pci_fixup_device(enum pci_fixup_pass pass,
 				    struct pci_dev *dev) { }
 #endif
 
+int pcim_intx(struct pci_dev *pdev, int enabled);
 int pcim_request_all_regions(struct pci_dev *pdev, const char *name);
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
 void __iomem *pcim_iomap_region(struct pci_dev *pdev, int bar,
-- 
2.47.1


