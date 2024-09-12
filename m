Return-Path: <kvm+bounces-26658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F7B97631F
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:44:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 894081C22236
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA0F188CDA;
	Thu, 12 Sep 2024 07:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xs1UShTW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBD6192B73
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126879; cv=none; b=U7LvRjNIhIfLn7tGzgoF5RTTj1jUZJRWU6nEhu4ygbbK4qRm7SkgfdrLJkTvzyw2XBT2tVjK/J9SgxdiDaiLst9f5CKB4umY+WJJTtQ/Df/OYeSInsNUU7TrBU8UXk9i44HEsPVVMZQAD0t5CpnnyEnZ7uwkQQt0Kjct7nPn2to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126879; c=relaxed/simple;
	bh=spC06ZvIThumQY77OYpdAPyZuSolKTInQltg38j+/3s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JqDEHnOsKFSQRN8huAU+Y2o77TlH6pYWjT5GoUtr5ToF37kAuVU6Tu/23KhvgbkkFS11m6dNplz8/iOgsSV0jL6vD8DhTKF1x3XOvOB3sGFWJ/Vxj/OnsoODxGKXZO6a0qZNSlAmMCjJ02aeYevXHsC+xwE1F8lFZoGGaIjbQBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xs1UShTW; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-82a626d73efso23665339f.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126877; x=1726731677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMUYyvkrsw4WRnt3KKvMbrVUL0nLRii9ZhUC+JLdWEA=;
        b=xs1UShTWN8WZktriLr6BskfMTL248mcDWfcgjdI++v55j52jB8KgqoW8pS/iUYGh2w
         p7bkShayqbrDaE9pDY8NIBRpYXPl61nfLuSE6d6SnWc0Zsmdrovx9kRKKNrjT0TTw/eb
         b/kZYvMgCI+jTQr0V5KcmXkpaESiQafODOBeltr1Rh6bcqWpOCLzB7ktpBNZCTybG/wj
         +2vRAKzZe2b+sZbo0C6Tgh2bKQprcY2j/seVwZI5tXaVKCx3Bn3pduI/zl/ZMS2kT5M/
         7tvLpEpH5ZohTnbX2ZJHuytdnJYaS2YXJZOlKOt9peZZ0OKCPV8agtthioIgE3S3DIYb
         rj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126877; x=1726731677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pMUYyvkrsw4WRnt3KKvMbrVUL0nLRii9ZhUC+JLdWEA=;
        b=wsXygVQRPUyG3UMN3D9besWDLgaanyJeUy/sunUroAJDWrFLcIQW0G6Ksiv5pkAv6v
         TKkSbdVa5rO9F6kcwzIlsOtlZZJZ99SDwxhAdddOZfapQYNMVr2hJPNrfixkXMx0kfb9
         B95kNqVCfKeVZK6y/NlHzurJThKt/mdZ6tqvzXuroxS5jN7LQifMyA0jiVUU0H/hPM+Q
         6iz2EsoFOb348deNXLL9NZ2I1nj11k7sUpImQss3EQJxf48IO0UcodZGahDuOkfd/XFW
         3Gc3An3osPUWsfOWDOpzd1Vugw8k9kH3YnsKCFjwPA1fVPskfvU/BiP1W3Y+CaZVKOmn
         C78A==
X-Forwarded-Encrypted: i=1; AJvYcCXHpLRBZplHTFh0fAPU964zqUoM1tmno1yDED2LCB5bEsqFO/hbpXYSQEVzPcxItX8LA+g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3nNeHyXd9i+rCiryOVqnz7kJ/q79UW3oQ6DOTCtIQIpmwpoPn
	/TZDkWjBkvCvW6Bj8ObUOZ2LtkL0rt6Dp2E+jTB+IaUASdIXoQqmnDzHIDOo/6M=
X-Google-Smtp-Source: AGHT+IHzePrHc9NvGdqaAhT6SIBTHUep9YZZsqe6VCOInwH/5gPcwLaBPPH2x/wVY/X1vhjYzcDUGg==
X-Received: by 2002:a05:6e02:12e2:b0:39b:20d8:601e with SMTP id e9e14a558f8ab-3a0848afb8dmr18701325ab.3.1726126877432;
        Thu, 12 Sep 2024 00:41:17 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:41:17 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	WANG Xuerui <git@xen0n.name>,
	Halil Pasic <pasic@linux.ibm.com>,
	Rob Herring <robh@kernel.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Corey Minyard <minyard@acm.org>,
	Keith Busch <kbusch@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jesper Devantier <foss@defmacro.it>,
	Hyman Huang <yong.huang@smartx.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	Laurent Vivier <laurent@vivier.eu>,
	qemu-riscv@nongnu.org,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Peter Xu <peterx@redhat.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Eric Farman <farman@linux.ibm.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	qemu-block@nongnu.org,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Eduardo Habkost <eduardo@habkost.net>,
	David Gibson <david@gibson.dropbear.id.au>,
	Fam Zheng <fam@euphon.net>,
	Weiwei Li <liwei1518@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 42/48] hw/pci: remove return after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:15 -0700
Message-Id: <20240912073921.453203-43-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is part of a series that moves towards a consistent use of
g_assert_not_reached() rather than an ad hoc mix of different
assertion mechanisms.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/pci/pci-stub.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/hw/pci/pci-stub.c b/hw/pci/pci-stub.c
index c6950e21bd4..3397d0c82ea 100644
--- a/hw/pci/pci-stub.c
+++ b/hw/pci/pci-stub.c
@@ -47,13 +47,11 @@ void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict)
 MSIMessage pci_get_msi_message(PCIDevice *dev, int vector)
 {
     g_assert_not_reached();
-    return (MSIMessage){};
 }
 
 uint16_t pci_requester_id(PCIDevice *dev)
 {
     g_assert_not_reached();
-    return 0;
 }
 
 /* Required by ahci.c */
-- 
2.39.2


