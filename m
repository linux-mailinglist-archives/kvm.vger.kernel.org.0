Return-Path: <kvm+bounces-28185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B24699633A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:42:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D51471F25901
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A598192B8C;
	Wed,  9 Oct 2024 08:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZDG4gA91"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA8D192B85
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 08:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728463044; cv=none; b=VKi04YTVCEk4ZEfg8K28xQzv2RmKQ4AAlf2Un+I1ObHsN4Zi9mOkYyppcZOAO+VivUW/7mmukq0Ie0JeT108eyNE723IBhpPOW+f9qVGyg5vlAVVUki7cPme/ztYXYKyYR63+r2tJG4rDZLU0pTeQMMZGeCM1/grdkNuNqkiN+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728463044; c=relaxed/simple;
	bh=NzW9wxcIHOJnLhCClKauHXIBaaQFN0Es8rifujb3cYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgG37GCoBAolwvDafrnWPpaWznnIwlFR0XNhMuViGA6lpfLUJHNJ5f5CajX5LLQvWqXW3TxpB+Eyb+GfNy8cjytTaLyvK2K+/Sxx+jNPfrhSVG1CPN5qXvTyhKghkRxHtsKu+SxXiB9Rxq+sS9mWrlrB1Wk92RfMf1aV9VqKL9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZDG4gA91; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728463040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x2+4tkUVcLGJF5zHhr3G6hU1vXfnQU3y0JjqPGIiXBc=;
	b=ZDG4gA9100slt4l2cvfk/RvA3XFzfnXKg8wve70gOBdwLabCS6Pi3WQ5gL44oAFhpSNsQA
	AJ1XT+vZYloqos2Kj+rKS1I4o3MaN6vkwoxFctsOA230PTTus4GzcCsoYxcJ9osuAy/fBD
	mkR02l6UvlCoWwcdCd7oa7Tgtr7HeAg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-z3kAd-NnMFizVtDb7q3tgQ-1; Wed, 09 Oct 2024 04:37:19 -0400
X-MC-Unique: z3kAd-NnMFizVtDb7q3tgQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7afdf50bfcaso139035685a.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 01:37:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728463036; x=1729067836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x2+4tkUVcLGJF5zHhr3G6hU1vXfnQU3y0JjqPGIiXBc=;
        b=Jl0Wojv3G7rQre3v89yX7hKKxvKAvyx8xtMQeterU+E0MXE/V+I3ah1MMIXjKeMupW
         qVXVei0rlAxqMlS3KiN0tZ2DLu+L67nOcDFMBR6Q5NZtUvuPSX34iz9nTRsfDC41tJDS
         hrd0kYlXHfYZ4aB/2Tt80Vq1aoNkDbWPCAbKImFNrWHifSdrl+p5kBuQ6whVCsbX16Wf
         7G6qq8puHmvFOr3bPsBTFC7WDqFD/fvs7uWpU/xswnyjMR7bAvFCHe/RQBhIKRqwgm7k
         zLN08g4RL5w7jrwO4i2yyELIddU9CDw2u1QrqDKy+N9e5EDlg29bnY4m8meJXuisE0a4
         agIA==
X-Forwarded-Encrypted: i=1; AJvYcCWfKyFpRdb4MsOjUwxeZP/LkaQ/OI4HFLtIgV6ItEWxgdnC13jRI8+lFXAhBX9vWftu2rg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRtg0Gr3nyvr5LssxHVOvbZwzcoiDZMwJ127qsARPj5v0wZHoH
	bxllJyA8A6wPFn8tVE94uyYW1t8FHhhGJ6E+YUGxFGSnO2SuYQPNqpwHzyMk6jlwEEJGjWJ4CLh
	yIw7qeduZpj6lSQQtYjn1+cuDmd8mxdBz8ADhjugG10xYaTB/0Q==
X-Received: by 2002:a05:620a:2585:b0:7a1:e341:d543 with SMTP id af79cd13be357-7ae85f85358mr1004129885a.28.1728463035627;
        Wed, 09 Oct 2024 01:37:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEO+/SwmcH6h0Vxkc+UACkKjxSzn/5VgASgM8SukkUVixA4gIuWgHYKW5iFaezTFbfMq+Vx5w==
X-Received: by 2002:a05:620a:2585:b0:7a1:e341:d543 with SMTP id af79cd13be357-7ae85f85358mr1004126485a.28.1728463035252;
        Wed, 09 Oct 2024 01:37:15 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae75615aa2sm439643585a.14.2024.10.09.01.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 01:37:15 -0700 (PDT)
From: Philipp Stanner <pstanner@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alex Dubov <oakad@yahoo.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
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
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Chen Ni <nichen@iscas.ac.cn>,
	Ricky Wu <ricky_wu@realtek.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Breno Leitao <leitao@debian.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Soumya Negi <soumya.negi97@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yi Liu <yi.l.liu@intel.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ye Bin <yebin10@huawei.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Rui Salvaterra <rsalvaterra@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Cc: linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ntb@lists.linux.dev,
	linux-pci@vger.kernel.org,
	linux-staging@lists.linux.dev,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-sound@vger.kernel.org
Subject: [RFC PATCH 04/13] net/ethernet: Use never-managed version of pci_intx()
Date: Wed,  9 Oct 2024 10:35:10 +0200
Message-ID: <20241009083519.10088-5-pstanner@redhat.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241009083519.10088-1-pstanner@redhat.com>
References: <20241009083519.10088-1-pstanner@redhat.com>
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

broadcom/bnx2x and brocade/bna enable their PCI-Device with
pci_enable_device(). Thus, they need the never-managed version.

Replace pci_intx() with pci_intx_unmanaged().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 2 +-
 drivers/net/ethernet/brocade/bna/bnad.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 678829646cec..2ae63d6e6792 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -1669,7 +1669,7 @@ static void bnx2x_igu_int_enable(struct bnx2x *bp)
 	REG_WR(bp, IGU_REG_PF_CONFIGURATION, val);
 
 	if (val & IGU_PF_CONF_INT_LINE_EN)
-		pci_intx(bp->pdev, true);
+		pci_intx_unmanaged(bp->pdev, true);
 
 	barrier();
 
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index ece6f3b48327..2b37462d406e 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -2669,7 +2669,7 @@ bnad_enable_msix(struct bnad *bnad)
 		}
 	}
 
-	pci_intx(bnad->pcidev, 0);
+	pci_intx_unmanaged(bnad->pcidev, 0);
 
 	return;
 
-- 
2.46.1


