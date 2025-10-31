Return-Path: <kvm+bounces-61709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3A7EC26490
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 18:08:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 103141A64A85
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 17:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A574307AD0;
	Fri, 31 Oct 2025 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G9nHaUnf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F0F301707
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 17:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761930370; cv=none; b=qtazfFMLhlnTtRNeW6eiu1XF9FBWhjAM9sX20hCymBeZLS6iNh2o6s71YsnG1Nw4yr1mPw6GasStlLTxE+ktBYuzIcjc328VsTxdSkX5MVtPAsBns3y87rYZlCjKJuIPSDQa9EDgc1kEDNwxmSX8qG8z4xpyqf6wD6Zsqu4fXIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761930370; c=relaxed/simple;
	bh=QwYo/Yoz+I4T+rZY/7ih9WEmyZPRtgRok11KJciMVYc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=glzCOXrAHYt54hwKrD83jOv3GpdyVMNS8ggnOdIINzGgR+Cikg53NifJnWbqZFDg5eq6Pnmnh7DxwglMt1mMId2p2nKj2WvYAROe/r4LI5XdCfKJEkMBQh5BqYhXw68UjNLX/xmxNmf2tDU6gTpqAsU6g9hGinlWMF4KD9oFIhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G9nHaUnf; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7c531e5d0d3so6540427a34.2
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 10:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761930368; x=1762535168; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OY4ljaKFzmW3A8oE1zEU8ROXOLit9Ajx9xtSY2H7jXY=;
        b=G9nHaUnfUjt68aiP/CybRo7KmwBmq0K7B4ZpIEJlRCYW7Fps+ADEwraw2+Mk83Wopr
         //Ba16ZKuIb8LmVrMHN4VGcyZpQ+QKVis+CJxXuAksXD5PhnxTnysN79AZ5k5y6pUxC5
         VjNZr9+ciPUxYapnFnKi9VfN0MEgf8xsEstL5fN3GON0O0tt2GnLI8wMSU1bDw41Faz3
         QFw4iaUCIHgCgda/+/+nCwfe8erV8dOxdleg+ruabOBCH+vS5axxtU3uWnsOGbYAFogp
         m2wdvSjAeiy9MUFpg3PXT1UGyhrY74YuHkPEPPOATN2MH+GutjR4HM2HKDuC3wltCpNA
         +MqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761930368; x=1762535168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OY4ljaKFzmW3A8oE1zEU8ROXOLit9Ajx9xtSY2H7jXY=;
        b=CmYXfC1frrLA2xlShBPFx8iRlkh/afJyXOHcsKmPJl44rLpIqG+rgiiZt/uWOHWCI6
         K1doSagG4FRKzBoeTI2qX82lGp44eeFeZtjtxREf+LtMZgykXn5FLFi8uNr5Jm3vp4vS
         n28bcK0hw1Y3a9wPoyW7IWO3FFjoMvwCJZyHSdXYg1gSIh96Va68TFLGef1Sna8Fybg4
         Mm0TqI8yj38WBHLtdqVmhgvlEvMAS4xer0OKrpE7HUq+bIafFxOGgxG6oNgUJljoJRd3
         Aq8SAkqWzOZ+4ciYGN3i+ARqO7MPVKLM1lgx5+UtHpQLqXHXbJQOTfLVL1nt2M5SQHLC
         RwNA==
X-Forwarded-Encrypted: i=1; AJvYcCV/NDtJ/F6mU/VcQO3zO6XnhzlA3fewcDn89j9UyJ0HHpUmkRzWHowHxkVtzcNB/fk0raI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEBHHebh69q8/sfoTPMwVOUvy3MrFmwvLpvOQqZ+0twBSOa4MW
	8a8JAz/DPmUe2kMn+yraZDEQ/ZM+5ByO5hC+OzYfBO9DfuDJwilM1aCKH+8dPnvXB4I63bBbWIQ
	WP2h31dJn5A==
X-Google-Smtp-Source: AGHT+IEnJVtmijC8TzZF5pGhOrZATGI47Fj98vUFRBqaKlvcaJ3uI54EHz3UXi30/Su9B2TFuWmC2JYVX9kc
X-Received: from otar9.prod.google.com ([2002:a05:6830:1c9:b0:7c3:e32e:483d])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6830:6110:b0:7b2:8ab:69bd
 with SMTP id 46e09a7af769-7c696847015mr2109668a34.33.1761930368062; Fri, 31
 Oct 2025 10:06:08 -0700 (PDT)
Date: Fri, 31 Oct 2025 17:06:03 +0000
In-Reply-To: <20251031170603.2260022-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031170603.2260022-1-rananta@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031170603.2260022-3-rananta@google.com>
Subject: [PATCH v2 2/2] hisi_acc_vfio_pci: Add .match_token_uuid callback in hisi_acc_vfio_pci_migrn_ops
From: Raghavendra Rao Ananta <rananta@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Longfang Liu <liulongfang@huawei.com>, 
	David Matlack <dmatlack@google.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The commit, <86624ba3b522> ("vfio/pci: Do vf_token checks for
VFIO_DEVICE_BIND_IOMMUFD") accidentally ignored including the
.match_token_uuid callback in the hisi_acc_vfio_pci_migrn_ops struct.
Introduce the missed callback here.

Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD")
Cc: stable@vger.kernel.org
Suggested-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index fde33f54e99ec..d07093d7cc3f5 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1564,6 +1564,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 	.mmap = hisi_acc_vfio_pci_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
-- 
2.51.1.930.gacf6e81ea2-goog


