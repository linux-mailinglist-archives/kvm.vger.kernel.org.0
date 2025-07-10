Return-Path: <kvm+bounces-52024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86C09AFFCEE
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 10:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23F301C86D37
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 08:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853F0293B55;
	Thu, 10 Jul 2025 08:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="LENEC6da"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DADF292B5E
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 08:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752137667; cv=none; b=gLQ9I3rfRcjxgW9cf8OLP5Gygv5jq9I9IDoTpsU9EJEuGxLi8uI+Z81NXqkJwOWdS2+Y4T7v+xozjWre42fbaYpMwImITXKc30HrDTRDTtjaP6sasmuqApkuP+Hp3SdV7/h7R0FUQ4ApfBBG8i89LuO0Xa44uZyDxX51tJqgZIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752137667; c=relaxed/simple;
	bh=kuMO4alh4taqq6qqK8Ezmq1eFdMQaf8rRvbNnP7x1ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewaXxvDcA08GdKd5CkLUFVZsK0eqRuS2DlgxFOZRg6uXOsEfKh/xgw6A3XZe1LaRihrHgGXzm2dDVRsHO4nSvhA/dJ9yaX2DmixquUYiOvim5pLVHTGYgr/FuxDrDW2zWsUFxVRmJqyNJCgzz2iGD7kyzI3fhem6QlIXbqk4BAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=LENEC6da; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-236470b2dceso7457505ad.0
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 01:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1752137666; x=1752742466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=euNz/l/CHGPv/Gat71a8nUVi70h05zHrvuBm3oNz29E=;
        b=LENEC6dajcKktGlvKMstisUT7+YxOsw6i+54mmKubHTWy8oH2js8w+1etQkArkfdPd
         Z5BO9cwZc7LFDTpSt7kwHcQzOUEnB1YTVUpYfrP5nbq7aa92r9sKiscMtsgyuPZgcr6N
         /dW78f71s/1bf9ZO+eEqyiLT+9cx+0W+uMy4m5FyzjnwUrT6OnfPyS9mscJzp5nNv2JC
         ARkEtXIEeOSWNL3kLpmLoTULpVELNluih7qd6turjp0UEbtDPYTJu3FMm1wyI1zJkeIT
         OvAItdgXmNSCXrQuAcg8Y/xg9affIgB33aLOHHlzGgHZF+opOtuXP1pui/lPMrF8AYhd
         hS5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752137666; x=1752742466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=euNz/l/CHGPv/Gat71a8nUVi70h05zHrvuBm3oNz29E=;
        b=Rr1GEldr3RqhE9XwtX9Fd7xTvS8Eza867c2YBLA9zjbxoMC5dXKk0aIuEotmo91CHE
         rijjRXvhOG8RneqVzObJ2DWUwqA1zCEsuebF61b9cWAMMt3v7YxiWeUjZPUtyrLFjRYJ
         NADWEYoAcvPPCEr+OW1SEjbLKK6rct1T99txZpzSCbuheFG0hjA4hSFDOx+zCP+mtSkH
         A+knU+joZFBqAoV6wyZjPfhWDn16LmMgt5W0EYylIPW6Zi55T5SOdfu/5V7MyTdBSC8g
         LWIG2kgyT1ftziHY3mnFW/hz0EAqp4+REmi4p1eSH4izULgVXPu1JpdDLmwMnbRguL6C
         4jwg==
X-Gm-Message-State: AOJu0Ywk7cOT5YCQdkBdKM/WHoPtJeV2l5Ofc9mGDOHyy783R95sGuS/
	ERZSX1eJlZiFWgw4Bt4uydsbF0JY8MqxKQ8RNzm6sqmxN3QeoaQH2YQl7/hRp1w5uLw=
X-Gm-Gg: ASbGncuzJwTVsTxEbROuojKVeiPH2DPvm1oAqZJ052j3r2sgiJltGkhVwYGoBtrq0gY
	xrz8iktKqo8BNWJkRrQfsLRgYRrLzMtyzd8qpo7/hcngyFKhBFlnSAmvdydCDyTXLhS6iFKUX1y
	WVRq0VSNMusNjCrIet5Vfnk2PKE+zKLrwWk0QzOA8YtJS7FlRzgRJI1KmFfttSUdVMb5SyDj88e
	OkuJMRM8tfvQdLT+3lfsl8L5nmE4G9NNvQVcYzg4zqHoqhcZf30smvAXbCA+88rC3YbFlwUiTU+
	6jj48RMvWNQdFk1NK0uRS6DsrcaJdYiaPR5YryjFM89jdCmzBdp41rTEsJDN38yzld1qtQGH9Cp
	ajwI/OmgO84UVvA==
X-Google-Smtp-Source: AGHT+IEt7OZwGubuhbBz8Z/1KB4UN6EU83aIIreg1b4VW2wSiqDfLzbhNwjVrNvPGleM5LD1QDFIHw==
X-Received: by 2002:a17:903:a8f:b0:235:1962:1bf4 with SMTP id d9443c01a7336-23de4803965mr31979305ad.14.1752137665596;
        Thu, 10 Jul 2025 01:54:25 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c3e975d41sm1650228a91.13.2025.07.10.01.54.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Jul 2025 01:54:25 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	jgg@ziepe.ca,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v4 4/5] vfio/type1: introduce a new member has_rsvd for struct vfio_dma
Date: Thu, 10 Jul 2025 16:53:54 +0800
Message-ID: <20250710085355.54208-5-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250710085355.54208-1-lizhe.67@bytedance.com>
References: <20250710085355.54208-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

Introduce a new member has_rsvd for struct vfio_dma. This member is
used to indicate whether there are any reserved or invalid pfns in
the region represented by this vfio_dma. If it is true, it indicates
that there is at least one pfn in this region that is either reserved
or invalid.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index cade7ac25eea..61455d725412 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -92,6 +92,7 @@ struct vfio_dma {
 	bool			iommu_mapped;
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	bool			vaddr_invalid;
+	bool			has_rsvd;	/* has 1 or more rsvd pfns */
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
@@ -774,6 +775,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	}
 
 out:
+	dma->has_rsvd |= rsvd;
 	ret = vfio_lock_acct(dma, lock_acct, false);
 
 unpin_out:
-- 
2.20.1


