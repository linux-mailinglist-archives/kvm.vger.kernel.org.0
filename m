Return-Path: <kvm+bounces-28184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EDD499632F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:41:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAC172825F5
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983DB1922E1;
	Wed,  9 Oct 2024 08:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cETpSXlC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F2218C91F
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 08:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728463030; cv=none; b=JtgSCI+Ley9ctfHAVgm5rmC3GfzuXxIPr9jZm5GEpIhfdqsdwZ/UdyLhaMBnVvOeYcnIh5QgSm1yBRbDnuB6UunCqwuaM00B0v1yN1nRgii1tlJXd/+hS/oAWb7j1GJUfbvaPwYYkGnIk8IEUYLSvMEOSItVbJyC50rVNYc7w14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728463030; c=relaxed/simple;
	bh=dQ9VnjlSSpPEnGjxY8o7n3IH4X0Lh9+lty8CWlTOebE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUujpSW9QfTRRsLh5ADxN5YStClKvYLY52aZOjv2Z8kaGkn/2fTjENrKFJenyiMc0HFKVuK+vHlGE1fJd3GMFmFQ6g346BEpH2M1ezDEC5LDDoAckN9vzX9himsTN/qnwVCmlhhIKsExves4DXY+fKQQdUabccFjb2cSvslmkyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cETpSXlC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728463028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WNVTMVvkzsZ7hvF5EavB0JCPwkl/fF5os/K0NJtlfsw=;
	b=cETpSXlCff4S3t69JIO9kekoSicMk1gDeXJxVnYXrBEtLYTkf9oQGgGVG2/XxPYEd652NW
	n7hXYdsiJy4d48F30i9rUklHZj3bNaNW3H5iKIAaAktU/OccEPhwSqkPmQ+yqe8gu8YWvT
	PzvIhZetvSH/yhQAx9dNQjNYb2ssruw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-ivZlZlYjOK6ZNWQwYPyfvA-1; Wed, 09 Oct 2024 04:37:07 -0400
X-MC-Unique: ivZlZlYjOK6ZNWQwYPyfvA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7aed2d01616so257457485a.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 01:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728463027; x=1729067827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WNVTMVvkzsZ7hvF5EavB0JCPwkl/fF5os/K0NJtlfsw=;
        b=XhYi3RqAC/h73CUo5peDgLbPr2H6/GrgR9Az5Nwl+HPcHfimQ1UGA1/HqRpgFv89P5
         Kb6r87BXP+sDk5KDD6F7fHLxCInl+4sAY+F6NXjQxnmppeKU8QKYdD0xRn4AE9XQNEdy
         tD4ZdILJ5KTJo+pHqqcRjHaW7DchWV6/skT7lT+26oibnVxU+OJAngI4EqQS68KwIwaS
         6Qe1PCPK+wNJvywOPT0yGGNtdVVJAAuClxgqwYHElI4FQB+SATVczrrLf6+OlcrOG8kC
         M3O4/WQoqKmKuTVVB6kUQlGDye1t9TKJTjcQjpF+szKRUw1bQcLIqpfUKPrT/Zp9sfPY
         5Q+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSC8skraxqJ+fo1pPxJVszjkZU10GmK9PpUO9Ds9coe+BHR9s6hZCwM8BZp+DTR1UUeDk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsaRlKcnQ5PtY5+tApoyDAz+0FKx6WfBhqtHBg9eWjO3RQJyHX
	Wr2miFApj49IGbVHvB84wAJUF6t9aptPenIDikfFbwCVaoFQM7Cz1P4cpr6cMOe3VfPUrW2apbA
	npyuTrDdAUsU7C+pkahSUEw8ri+RV9/GmO0QM8qnzocb1fd6q7w==
X-Received: by 2002:a05:620a:1786:b0:7a9:b9c6:ab4d with SMTP id af79cd13be357-7b0874b2e98mr203713685a.51.1728463026700;
        Wed, 09 Oct 2024 01:37:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3E0hV0KwQQvESOvv48X2ciqeB9+Uq53IkSsAgik+9QXi7ONASinXEowAITLecuVI2IQ519Q==
X-Received: by 2002:a05:620a:1786:b0:7a9:b9c6:ab4d with SMTP id af79cd13be357-7b0874b2e98mr203707485a.51.1728463026267;
        Wed, 09 Oct 2024 01:37:06 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae75615aa2sm439643585a.14.2024.10.09.01.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 01:37:05 -0700 (PDT)
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
Subject: [RFC PATCH 03/13] drivers/xen: Use never-managed version of pci_intx()
Date: Wed,  9 Oct 2024 10:35:09 +0200
Message-ID: <20241009083519.10088-4-pstanner@redhat.com>
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

xen enables its PCI-Device with pci_enable_device(). Thus, it
needs the never-managed version.

Replace pci_intx() with pci_intx_unmanaged().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 drivers/xen/xen-pciback/conf_space_header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xen-pciback/conf_space_header.c b/drivers/xen/xen-pciback/conf_space_header.c
index fc0332645966..8d26d64232e8 100644
--- a/drivers/xen/xen-pciback/conf_space_header.c
+++ b/drivers/xen/xen-pciback/conf_space_header.c
@@ -106,7 +106,7 @@ static int command_write(struct pci_dev *dev, int offset, u16 value, void *data)
 
 	if (dev_data && dev_data->allow_interrupt_control &&
 	    ((cmd->val ^ value) & PCI_COMMAND_INTX_DISABLE))
-		pci_intx(dev, !(value & PCI_COMMAND_INTX_DISABLE));
+		pci_intx_unmanaged(dev, !(value & PCI_COMMAND_INTX_DISABLE));
 
 	cmd->val = value;
 
-- 
2.46.1


