Return-Path: <kvm+bounces-65343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A4DCA7700
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 12:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D05B312FD33
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 11:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9816C32D7EC;
	Fri,  5 Dec 2025 11:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ICG9sMR8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D2431D366
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 11:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764934761; cv=none; b=rGTIn/YBKpg76F7o3YoaaU0NwgMiwvljO/2uLzGlR4DwaSiAIMw8rgh0ixYbpYcai65k3iA4VBrIGPBVGrm8MRLAmjNEVKXlwRkcx2+NFiCmF8bXs3xWyT8Ueg01EbDBZLII9J2yp0JSHGNsNTbo3lJ7xo9XXJe0Y9R10xx5g20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764934761; c=relaxed/simple;
	bh=QqH8/pjRCcGh0Jyr6tcZ3HotdYoJ1HgZDkQeP8IceDk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hfLO8fqu+UBtkUCKblyY/vjIWs8MTWgckr2p9kHqv6/ZvAkwl9tee+8HOftZ6/VNR3jVjXqCnm/3i4DhdUWfC1S4+Rh2moCEUY1+5CreSRFosxDVs/UKhkmFlx6IfG0ZAwHI45XY4D3SDd3gUIWqlAR2+g6xhKLylNPKkIhVWg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ICG9sMR8; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-477632d9326so14162305e9.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 03:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764934756; x=1765539556; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ydvHPuR/TEWjlqHSyc+IuhV3845FKKl2OTvoX5xFzHs=;
        b=ICG9sMR8JnkA+elVgSM2l6ApOru1cWYXHe00gVb3FdUMkDOiC0ZikjRSWfQForHPDv
         boYF7OzPI6ZJS8uIPDGDfN2h/ZyawiuL3v5QRtbxvS02PGWnLMkwT+C/52tRIwZjqJCD
         ip5cm3tYVvWVRlG/tEvBsMi6+MUKcpjMHxIegnwtPsTGHjxAlE2TIqB6GuXk9d1gFCZV
         RBlox2NPs8X5bMrt/17ELOdeo62PLNul8bfoO33+rn1BPe+IyBdKz0LGxtZQe9u/W6q0
         XqUjDCn0df5TvsnRq2RBGN5UR2/Ou8l7z3R39irV/tyvmhLnExjWhoyNnubBSxjxZvFr
         PhQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764934756; x=1765539556;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ydvHPuR/TEWjlqHSyc+IuhV3845FKKl2OTvoX5xFzHs=;
        b=GXyx3NURk5ShLXAjBB5K7bctv92Q/IGcIEVqaTEMDmexQd0LCOOfPMtYpGZKNWFGhT
         NaXvKtS/M7Y9g4yuJA1EaNuG5gogBt3fMbS18qxxJNtvkYDM3QWAvPk5wJZdwidryA1D
         XLx9gzYqNMSdMeQssNVbPSw8FugkX1bH6y8WIL4pc3uTZVAS3hh5erlJPpeY1BqdHLkm
         ehspX+xijxSodQgspPV4huAdeh1lX3qWOWALl1LohXBRu1qMPA0JQao5nDJkqHyOejmN
         i80BaEHInAMJ+WPDoOdQNQPOposasFsMXCUClkEURN6zNwcFajMKoiea+j44muEaKY5x
         lcBQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3Ods3zRkmioNGFG7kzra/uHL/Ee31Cv6TzypcnFX3KJWakP4taqRSqaepdzTaIfEKUns=@vger.kernel.org
X-Gm-Message-State: AOJu0Yws9/EXoPcMLrAdikXhk9outh4HC1WzXsiRZRBxuo1IouBI+qBz
	IaAk0Tzknk1lZIOe/NyupfQ18q5REvaLngfAayR4hZ0LR1yID3YUaTN3xF655UeZzTU=
X-Gm-Gg: ASbGncvV9rRd1e6MquX/y2xvVySTXivawZQaSI98NGdfeOmBSdpPQwohv9kMLRwjr5F
	g8/eLVrIMt/eRTJO6+y3SMWy6eVwuedDjjs0f/gctkLa0unp5Fk5FtpmzrhMMCF4MlGk52x3Fzk
	ewdHrRUAav/Tm/FlvX3y9WYEJmdciY2nAG9f1si5e3p98xrueNQOpVUR72f4Mu5cZkVwNMHiiZ8
	txH6ADozlTqw74CQ6yS7NInDucUDkzl25XpOvLeAwhf0x4rfk6ELf7pl8EG6NUbXd7DqI9m76tZ
	FGEnnIEC2Ag2jO/J1g0mShFsnuw44KDP51cmOYjV5DWs5rkU6O0Yrlw829oomnHSxrYRRTXtgHQ
	IT5fMvbdWmzq8hpTWLNhkt7Z78FmnT4fzFZJ1omjN3+MCSpqs5qwtAkCMyTanRpno/a29Uk7wyN
	lFVQFS2HYmuquL6JlOFR0SpyxOekc=
X-Google-Smtp-Source: AGHT+IF/vwM9KOmX570wAov4Xy6x0tD+87+iHCXLimHTetQ/1oLM41jUaLHyTjztyr8/nNeI54dvbg==
X-Received: by 2002:a05:600c:c8c:b0:477:7bca:8b2b with SMTP id 5b1f17b1804b1-4792aef7050mr121690165e9.15.1764934755224;
        Fri, 05 Dec 2025 03:39:15 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-42f7d353f8bsm8501158f8f.43.2025.12.05.03.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 03:39:14 -0800 (PST)
Date: Fri, 5 Dec 2025 14:39:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>, kvm@vger.kernel.org,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next] vfio/xe: Fix use after free in xe_vfio_pci_alloc_file()
Message-ID: <aTLEXt_h5bWRWC0Z@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

This code frees "migf" and then dereferences it on the next line to get
the error code.  Preserve the error code before freeing the pointer.

Fixes: 2e38c50ae492 ("vfio/xe: Add device specific vfio_pci driver variant for Intel graphics")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/vfio/pci/xe/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/xe/main.c b/drivers/vfio/pci/xe/main.c
index 0156b53c678b..8e1595e00e18 100644
--- a/drivers/vfio/pci/xe/main.c
+++ b/drivers/vfio/pci/xe/main.c
@@ -250,6 +250,7 @@ xe_vfio_pci_alloc_file(struct xe_vfio_pci_core_device *xe_vdev,
 	struct xe_vfio_pci_migration_file *migf;
 	const struct file_operations *fops;
 	int flags;
+	int ret;
 
 	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
 	if (!migf)
@@ -259,8 +260,9 @@ xe_vfio_pci_alloc_file(struct xe_vfio_pci_core_device *xe_vdev,
 	flags = type == XE_VFIO_FILE_SAVE ? O_RDONLY : O_WRONLY;
 	migf->filp = anon_inode_getfile("xe_vfio_mig", fops, migf, flags);
 	if (IS_ERR(migf->filp)) {
+		ret = PTR_ERR(migf->filp);
 		kfree(migf);
-		return ERR_CAST(migf->filp);
+		return ERR_PTR(ret);
 	}
 
 	mutex_init(&migf->lock);
-- 
2.51.0


