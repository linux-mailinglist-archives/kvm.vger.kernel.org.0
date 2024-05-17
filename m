Return-Path: <kvm+bounces-17612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 248448C8851
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3B752877DA
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE576BB2F;
	Fri, 17 May 2024 14:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ES+ggZC7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458086A33B;
	Fri, 17 May 2024 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715957184; cv=none; b=txnYOVBhN/9XPs0H3QJgu3K7d268h2aJMmHTa/dptREF41+g/gomNoqN5w3F3rMl1ttxzgu22ib6doesN5wVnDNcfKu5001cUj99TmycOnlYoM3e4Zy9f2YPQRJMThXnePqOcuh5qVdcqeZPdsOB9Xg9mt/f7dCXaHF+VYuO6Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715957184; c=relaxed/simple;
	bh=j2/GYQH+YPgVz6Sz+FMKMs1AQ1hkT2Fqf7GxI/sZoUs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NfdN9GVuU4pzQHtveK9uUHxXVyhtWjrZ6NRmx9WpgmmvkrylsW9ekKkRLhcGdM4vbn7qwnZ/td5S3cT+CCZqCwNadZQcJKPsa4nIkBTKyzpGpGZ6wgEjmuh85+xxuh8XpGZlkZghO+goiMubtqSegTcEl7GMPoz4nSWNgmip0n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ES+ggZC7; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1ee38966529so4907825ad.1;
        Fri, 17 May 2024 07:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715957182; x=1716561982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0yGtcKEuophyxuK9PPE+gmzXonmfacqDZH3bhCr3sI=;
        b=ES+ggZC7qHShyfUp6U+2tRYWlvhFrLzRTNc7QMvD62gCVMHNAD8e5Smx3yYsDcPyPs
         kCGH9XpJkmocR+YXGBHhCLfJz5atbAkUnkvPjteMMW8sGXWxN3J7kj+LQmvrGPTAQwLL
         M8oe5eQESxbLZd7sBZ9U81uDGrr5yMh2Yn2pXuXIVvGycVjp0/GqTCHb2cTZvFNe24GR
         LJ+pkXrMC/eEqvQfu+ja5GKqhv3qQmm+9eFkVDUKa+WMAM7lsprZqHSHjGqKfE7E+P9A
         vYCm+W7/0SJEcJfFslkcQv5gpei0MTKJWG+KfyZLbtPKhJ+D08a3HLJGPqpTEVWnFnwJ
         nUbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715957182; x=1716561982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k0yGtcKEuophyxuK9PPE+gmzXonmfacqDZH3bhCr3sI=;
        b=c5GAbnTQ7NhRtJdNF8ViQ15RMlv6ll6BggIYcO3IPIjLFMrsORNDti9HYdM0HXur6E
         r3tEh7i2cShJ1tipL+a8aK41uitzwwbls6invHMqsXjmcNk5o8aZ2fn+bfgCDMPKm7HM
         PsNHIJYc/pPHzdZms/qZnmRk/Fe5Sp2aOeGE/0kbXpmGzsEX9jEO+bAlmLeDVD7D5YY8
         lNgQZeSglKSqVGbFCbIQ7jOJcvKS1nrSmzdPxpzmxJOhTGYQiH9E14CzvYJ71aQxIpDg
         fqOJc9HrVvzYqlrd3b06nObFPcRwM72gAA66LO4Ic0oEdyJuggR+d/HYBH/b7+rssmxn
         7V8w==
X-Forwarded-Encrypted: i=1; AJvYcCUt/RrFw30zSnBlMBNLt04j2HDUA2x86ZV9B5HFC6ZlLUQ0SNgfCL8RkeEn6Oo9HY12kJERdocd6+gUft/9pPRz/MVnrZowS7TlgQwAMdvoFgVDCVrC+j8DPoA0ADiO+lTEMpXJyK45R/Kr3ZGJ2WtkP16D/rhewCjQ
X-Gm-Message-State: AOJu0YwXW4sCmhWG5pg/N6gxyp2cvyX2PNj8nWIKDBFAFYxk9zRaJTvo
	oD8uBs6RlNVpvB62Wt6cqtfKYO4V/oV7vBa+bTQ92kF/cdSrzOzZ
X-Google-Smtp-Source: AGHT+IExbl8LrLvJPyU9pKwjp5uruGM2OzUlT/MtzqGW1/+10hqCuUEFamttCWLYKNGTxD89KXVlNA==
X-Received: by 2002:a17:902:ea03:b0:1f0:af34:6fa7 with SMTP id d9443c01a7336-1f0af3472d8mr66089495ad.10.1715957182587;
        Fri, 17 May 2024 07:46:22 -0700 (PDT)
Received: from devant.hz.ali.com ([47.89.83.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c160a1esm158504985ad.279.2024.05.17.07.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 07:46:22 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com
Cc: mst@redhat.com,
	davem@davemloft.net,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [RFC PATCH 1/5] vsock/virtio: Extend virtio-vsock spec with an "order" field
Date: Fri, 17 May 2024 22:46:03 +0800
Message-Id: <20240517144607.2595798-2-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
References: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The "order" field determines the location of the device in the linked list,
the device with CID 4, having a smallest order, is in the first place, and
so forth.

Rules:

* It doesn’t have to be continuous;
* It cannot exist conflicts;
* It is optional for the mode of a single device, but is required for the
  mode of multiple devices.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 include/uapi/linux/virtio_vsock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 64738838bee5..b62ec7d2ab1e 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -43,6 +43,7 @@
 
 struct virtio_vsock_config {
 	__le64 guest_cid;
+	__le64 order;
 } __attribute__((packed));
 
 enum virtio_vsock_event_id {
-- 
2.34.1


