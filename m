Return-Path: <kvm+bounces-40507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C23A57FAE
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:10:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED4DD3ABA12
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BA0E20D50D;
	Sat,  8 Mar 2025 23:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uadGRkOa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02431E834F
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475405; cv=none; b=Zpd5DyclOz2/FAwa8YVU4KE/RnFt9WZHyGXsbb6THeUozf9MswjixvhHnjIOfMu2PWvKkrL8dTKQAAZmPzovsDNOLXMqJz3iB7+r/mXGNUNvX0pABW8cORbnBUBCyuEZhtfrkFof3NUZ1SLlz5UCwVPmTxY5lujuEW49BFHsxUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475405; c=relaxed/simple;
	bh=8npzkivAWWPNhdOG/zEbE5ZkHLXi7SW/1OvnJiI6da0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fPB0DXCgVVL7iHGfB07Stv/3I2M0sUhlw4DfeoYQNbuu8OCWggOF7ioEqTRQ0K7Bt9OskGu5Nft46tadvAz/YJOlZiyNR0mm737qidTBHNSdbYHrumb4JA/zySvS77fwgk9xks2TMa4ua0fHFV/sTd3NcUzV+MNvE9Brl5DOp8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uadGRkOa; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43bdc607c3fso17911705e9.3
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475402; x=1742080202; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+FGFHz50rlwowjsXAPUzEIGbHAi/y/Zg2M+gRe6JQAc=;
        b=uadGRkOaEyKrTW2yds3MEUZn7y5/OA7xPNS5DGKw8yrdxDeMBivS4q94ulxDLHQSbc
         ktr1+F4vShqLQG/QyRWCTiOCC7htsxxffvwkLE5Oov46V/67XxikzPm5sgFQKO9ZxgNA
         h7kHHN/g/u9hKG31a9/TlqZ1LewEWCwwOiubxT2qrye0CyfvUWuQa9lb9ckdSWXp/gxe
         TXG/PSzN5YWLJoeq6x+F8BQpB+DDgxyBPwUe57JvdIYf4nB1yB0mpVg1+2NCsN6WQ73+
         TbZyiE14CEfga/dlFurH/c/VDVeuWIYwC6SHcTARmKlK/kv5OAS8TRAEmPgES+HN/pz6
         Qsiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475402; x=1742080202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+FGFHz50rlwowjsXAPUzEIGbHAi/y/Zg2M+gRe6JQAc=;
        b=SSYtcNqI1QyMrq7+kc76l8wNMZnxZwXkAe7EUFUNFXIFAFpQSimNI9oOSuSu6exeF6
         Js3g4J4ERcGUk58g+gKoO9yar/thgBKbnpyULo3xuY27QnfDk5Wb6brOL1/L5lceBDUQ
         loHj/Vqc0eSBIoI3QiwnETpyh4b+KFKY6EN1vTnpx3sO9Rh3hzxZd9rC3n4Sg97tC+V1
         Sw+cOmCEMPiT8wEC93JQomPeoYMVNEN1CVqEc0ncho/VjP4FPzQj2ztESLatmoDYWj4Q
         gk9tye/I11HbMpWOE11XpekWXaNlVKVnc25RRgR5vSGYnM9hWLy5ALX0rueuUmLCkyAK
         nYjA==
X-Forwarded-Encrypted: i=1; AJvYcCXTPPoBcAAD/GFiukUm2oGqNQSZIytMkPwYNkegDadvvGAAGn8Tv5Ekmab59X0Du3ROaP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWph3+KABwh1Z2GDVb5MPEgXWhu16MR/+sxRKzCLyaV2ceT/7V
	fonfPsMIHOe2xPUEMvBtKzaPSmoShF3fXW4z4KLA4rStbjJfyNhaZG3PLEhDCZQ=
X-Gm-Gg: ASbGncuIhVeqIzQT1VlAQuFZpu1qacoHN5tCRdgsc6Tb7hyKpgN6UmoLNrlTbbocDIB
	ASe1FH45m5TYixzQ8NxzemABkO54uaUPg4pMUB4XcDwAVYKQ/QBdOqP5RJBQ5BfZP3hxbvRmC0Z
	Sfeco6bOYwsDVluqXTFqMAu6tcdRTf+KqRhXO8Jri6xogp6L5caS5aq2h7QTN24l7vk4+LhAoHA
	7rVFV3quRVpj3uIl9FvmH4YhdOB6/OJ+/Ij09U70GYLJBwIZeSFDpphkVARB+kmISl5ie6Dw03E
	HwRPWM7dYY5iFLx6HpZ05DLVGzc7kMBtWTflZzJxwRNIHFQfZDICPrrHq9Wka7QlYi0rQMCeggp
	YH3zSy6ZRQaY1TBSy2YMOQTfUe7/Xnw==
X-Google-Smtp-Source: AGHT+IGIv7r4JVSN4fyIj3wYPXDmIoomS2e7/C3qLiVhv6Ql0EEJlV/5Due87/IgHr0O7LUJ20Gsaw==
X-Received: by 2002:a05:600c:4fce:b0:439:a1ad:6851 with SMTP id 5b1f17b1804b1-43cdc7b6dccmr41459045e9.23.1741475401963;
        Sat, 08 Mar 2025 15:10:01 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8de4ffsm97892025e9.24.2025.03.08.15.10.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:10:01 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	qemu-s390x@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 07/21] hw/vfio: Compile display.c once
Date: Sun,  9 Mar 2025 00:09:03 +0100
Message-ID: <20250308230917.18907-8-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250308230917.18907-1-philmd@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

display.c doesn't rely on target specific definitions,
move it to system_ss[] to build it once.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
---
 hw/vfio/meson.build | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 5c9ec7e8971..a8939c83865 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -5,7 +5,6 @@ vfio_ss.add(files(
 ))
 vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
-  'display.c',
   'pci-quirks.c',
   'pci.c',
 ))
@@ -28,3 +27,6 @@ system_ss.add(when: 'CONFIG_VFIO', if_true: files(
 system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
   'iommufd.c',
 ))
+system_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
+  'display.c',
+))
-- 
2.47.1


