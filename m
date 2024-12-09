Return-Path: <kvm+bounces-33311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D469E964D
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 14:17:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F7441690D4
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 13:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525E3222D5C;
	Mon,  9 Dec 2024 13:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HvF9pQ7y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAE1238754
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 13:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733749633; cv=none; b=Q33+AplDBXU8K73xNitvqvLcFCLhFWqA5c/8Di9t3kud0wKer47e5fCNAaJXEEddR4er+Qw/ugk7kTJzR4sKrSStZwL1NsoWqAXnbpHel6XCfyWM2VxHBmrReQpX2uHNlBu4HF7Dy6Vdr1qeH/EpcQ7HmTkxCnA7Bzqr/K0XsPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733749633; c=relaxed/simple;
	bh=jwv6lYop8TdP9htf7xZwf/ELhC2D1ascIg4aYDeJpYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0NMx7osVzs0scpDxnEpnL+JFOytQ5vLYgJ1INjklobY5dj3LsmW6snVXp1ZM/apj57agCxe4TYTezU9kUcNSfyR0Y7DDL/pqEWr5Dk0kXqAMWagWahbZdha3DV83RIDhBgaBDXuCGvv3qrdUp0y4toA14f9pjfFLA3RsqDJHQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HvF9pQ7y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733749628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QrzFiyozzKwphrmER/QLBGC9UXhx6Rbz0xOMvDA9uiM=;
	b=HvF9pQ7yxte6Zj086vXS91oaZk0/BiR9FRxajzADYmI3wYBZ6K9ueL46ONKCU9smD/prKM
	6z5yNRewwV/FiyKFJNM6HoFts798lmpGUDfDGn+FSYeJf3yZ1Bv0PypyVRD+zmP5liLxdP
	q05Qgi6XbllBr/6TxojIkTCBkgQXCKg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-gXRuXfXGNw6v-BR5se-Dig-1; Mon, 09 Dec 2024 08:07:07 -0500
X-MC-Unique: gXRuXfXGNw6v-BR5se-Dig-1
X-Mimecast-MFC-AGG-ID: gXRuXfXGNw6v-BR5se-Dig
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-434ed70b74eso15200225e9.1
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 05:07:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733749626; x=1734354426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QrzFiyozzKwphrmER/QLBGC9UXhx6Rbz0xOMvDA9uiM=;
        b=C57hBEsdMieTKtuO/V3JcLIf/2v0jxV1E+cVHQS5jZ3hjhGGy14JsKaGsozhFebUk5
         9q+BxwjPPuBqZ9EB0rE904UbZqyteDId12tdy27bwCsJj8nxy28V6uMHYZUz9+NtmbyM
         ePTTs9cmfI3HBOReRErr4d253N+6GRvdIw79jRzcpG0fiS9szthyX5HJ7WjSK13a5GOM
         ZWHwUDXeOzQ0yhgiyT2q0cg+KkwWqwSmPTuvBxTlDS2dnyORdPCT1rkpUDj/9cxIF3wN
         5VtW55CFeViGkDzSAHv7Xxbz7lL5NanZ7h0mUC4K9+gVY5RqJ2pN16TvxVaTgtHjnSKB
         pApw==
X-Forwarded-Encrypted: i=1; AJvYcCUNfA0dURFbptmT7uRS51CEFXUnVwRuaohEhG1hLx1PBy9F3+qu0IIJjbKujG3jDfrossY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyyp3ziz9JRGmM3yI1notfKRR7I7Z6tpRJn5gKNVx8AfsiGOjfQ
	GmHy+uxwuhwlLO95czIyodZE6x93isDKvfTSALhfAh1Uy5ZVXhvqaqtwhv+Swc6h9Tkjmi7iPSh
	qlpV+XEeN31yvImL7jcArKxJzpfEaTU+mvmyvc+IdGyJKBL42YQ==
X-Gm-Gg: ASbGncu8bh4fTDPwu/4NL3hgIefeRcI7WLGiZauzgmccP0ecU57Y8GxMiMZUq3IWcWR
	R0XPaDDulN4sxgkjb0u7gsaCRUCSKjAZUT2ejmBLwTzeQwVrUK4McecNe7utL9Hy28hpXepg7kM
	Ob425csegxDoJyjBC+yQCBup5J03AUGOM/q/3Xa17ZwUHlkKv4KAguI1ehLMxE3xnjpObmggIZa
	lK0cVv2ibfBxv2zvmeT+cH3WqIIgRqlqvoVpb82MPHSN0to2qq+Ky7hoDIhZO4dJCCSpBa0m9oN
	GqPI1Lpd
X-Received: by 2002:a05:6000:79e:b0:385:e9c0:c069 with SMTP id ffacd0b85a97d-3862b3d0941mr9603902f8f.57.1733749626177;
        Mon, 09 Dec 2024 05:07:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IERHmOpW9Cz/hix9sJGhQKCFL65VOvqT0smHQwQu2JVZ9uttb5F5Byv3ep6mSTcPHbKk0ee2g==
X-Received: by 2002:a05:6000:79e:b0:385:e9c0:c069 with SMTP id ffacd0b85a97d-3862b3d0941mr9603809f8f.57.1733749625729;
        Mon, 09 Dec 2024 05:07:05 -0800 (PST)
Received: from eisenberg.redhat.com (nat-pool-muc-u.redhat.com. [149.14.88.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3862190965asm13200127f8f.82.2024.12.09.05.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 05:07:05 -0800 (PST)
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
Subject: [PATCH v3 09/11] wifi: qtnfmac: use always-managed version of pcim_intx()
Date: Mon,  9 Dec 2024 14:06:31 +0100
Message-ID: <20241209130632.132074-11-pstanner@redhat.com>
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

pci_intx() is a hybrid function which can sometimes be managed through
devres. To remove this hybrid nature from pci_intx(), it is necessary to
port users to either an always-managed or a never-managed version.

qtnfmac enables its PCI-Device with pcim_enable_device(). Thus, it needs
the always-managed version.

Replace pci_intx() with pcim_intx().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Acked-by: Kalle Valo <kvalo@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
index f66eb43094d4..3adcfac2886f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -204,7 +204,7 @@ static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv, bool use_msi)
 
 	if (!priv->msi_enabled) {
 		pr_warn("legacy PCIE interrupts enabled\n");
-		pci_intx(pdev, 1);
+		pcim_intx(pdev, 1);
 	}
 }
 
-- 
2.47.1


