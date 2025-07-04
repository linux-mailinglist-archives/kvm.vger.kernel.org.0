Return-Path: <kvm+bounces-51548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9B28AF8801
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:28:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15152587F7B
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F452512DE;
	Fri,  4 Jul 2025 06:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="aShmA0qo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2BD254B1F
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 06:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751610427; cv=none; b=N09ZAy5iYrydHgn6pc/+X9IvNyX+hE6y3ggNJc+H/tbnZ2j+9estiqtnS6Ahst4zCP8XwNHgUpjUt4E+wzjoUTUoGA6zxjXln/W60A7zDwKMydUDtvpR9LMOXLqkJBCW2cXFW6lqd69vix60IIctpR6upv9DYA0tfUlGNRPbBK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751610427; c=relaxed/simple;
	bh=eqnxbsj14Y9W2BV2T0VsO5bpIYVtD7sCrCgDaNmvUzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3WW+PJVTwVZJXbuyvIcXi9bsMvw4Jy9CnsDUcdPq46gn2aOk1kLtKnlTIQ/niX3mmtyo0ePxvZi3XU6M03jQzUFFWsn7F5wAQPzU7IByEcNREJpqssxo9jz0aNIL5b4G6Xox50zahZINWQmyrAn5n9FVFZjeFZFKyhRJAYN9yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=aShmA0qo; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-742c3d06de3so863685b3a.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 23:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751610425; x=1752215225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/oMFootAUhR4O6zt87edsWksnJ6wDOqtWn4lJQpVn0=;
        b=aShmA0qoMQEmPCIoWDrBKAxKBFI8EzaOP8HY/6JTQ9LjLWLJzCRWHnHC+hDpVpItV1
         AADMK6hbmeFQNmkgx0SBJ7XblU+TcZlZsYRiKIM5XLpxmOFSt4g4rkVThkUyh4XrMNca
         owfQY+pJ+Sgvb7zoKf0TSKZschT/U7pD8uIUNRbQqqrV+SuCkLlfSzkDc6zfSCoAa8s0
         LhTnHg+2jkvQbkEAe6FZP1qxNlG4WzfdPHD8CyMmhTpSKmAUL4aZE9yVUsaTp/gp7xtA
         40jWUe+RFBnyqaGk0hi5rCAmPtVRZ3T6WQenaTHzzycFsB6P33guaM5hGLgNHcoLPvrJ
         holw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751610425; x=1752215225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2/oMFootAUhR4O6zt87edsWksnJ6wDOqtWn4lJQpVn0=;
        b=Vs/x5/fzLOOsJiFj5+WIeE8zH4aco8sRvJm6daIH7pYggLB37vfmydz3Al4Ud/th1V
         EA+rl18NJsrOdTFn9lioGPtG2L6mcXsuCngy/yB8hKdT7kx1i9CDD9kKf2LZI/E8xJhR
         RaMM6bGTPrfCcKehvV+IbAODKnOTJfXt9xRXSllZUGORu+7W7z1z6D/MDzpJGa2YaY7L
         Z9ZIK+8luf3t8y+Fzw4N8pycHdJaH/2foPGKtMfCkqoLPTUfMtxfp6uuLi3bfdfup7kG
         Hf8LvNIkMtbTtzDDdLLgGnnmvFmmmgwt6nfBtXgxMgMp03ZqdkiZQNRz5GotnLJNn7ln
         NRZw==
X-Gm-Message-State: AOJu0YzxnBTJiDRcizPuufxSLHTjM9LGBP0k/ydxvHUnWGYO7gmLpvTi
	afZt3AtVMSF2pxfjQ32/Q2mZTWGXW0Dnq43j0Bi2q7u/10SQZQ6atKgfPvP8qeG3ktEU9Itwqt4
	XqJv9
X-Gm-Gg: ASbGncvLtuzruUizFFMdsGGq3rWRL8fgMOnC/Favnambe6TJ2gn5HbNRUXifXj6ojgX
	CnmQzkyeJ7MM0irg24Yf3j+ITSPabAYk2K9j5a08p+VIjJSyXohFKnSjZbR5DCeiXoa/2BFj6qs
	k9sGx28Iu3Wfp8uVfWylDc1xAGpMLbjsG6sezefrpioY5NslAjKBhdr2Q13VaoFQ41sPHunWucR
	w6GOLZgNEuK4BtjQXlWuo4yYYModco2YMW2d4+mI/fcA/28J6HHh4f6b9u7x+74NIvQpgDuoun0
	+vxMPa0S2vJ+jnGeh+K1TMC3cB5uwo0CnmKQ1EtH2G0GnAifAGE/55eSVoFStCSXhwNNA87ptFo
	zJRj2d/P6skRc
X-Google-Smtp-Source: AGHT+IG7T3GkhpHyXokGGwnbLUIOIE+bDXBFA0sb55px9wI3AAa5v6JbBWaMLj5Gi0BMN4In5dKGIw==
X-Received: by 2002:a05:6a21:6b02:b0:215:d611:5d9b with SMTP id adf61e73a8af0-225b85f3f18mr2349868637.12.1751610425169;
        Thu, 03 Jul 2025 23:27:05 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee5f643dsm1183240a12.37.2025.07.03.23.27.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 23:27:04 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	peterx@redhat.com,
	jgg@ziepe.ca
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v2 4/5] vfio/type1: introduce a new member has_rsvd for struct vfio_dma
Date: Fri,  4 Jul 2025 14:26:01 +0800
Message-ID: <20250704062602.33500-5-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250704062602.33500-1-lizhe.67@bytedance.com>
References: <20250704062602.33500-1-lizhe.67@bytedance.com>
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
---
 drivers/vfio/vfio_iommu_type1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b770eb1c4e07..13c5667d431c 100644
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


