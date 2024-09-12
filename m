Return-Path: <kvm+bounces-26635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C56D59762FF
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:41:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5154A1F24272
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3842D18FDDB;
	Thu, 12 Sep 2024 07:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="joA2yG6N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BB9191477
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126819; cv=none; b=koptAfxDw/ViWUc5s5uyWaCymfY1a9b1hV0VJ2+iAAGTlgKWu9K8rVLApbBvQmg/mwGekmo1qinSDTQ46TwGTNqwJhOh0/5Ov2/5dGzB9/wtb8offU+l8benJTccMTLYxgxwHWH5a9XcMt8uD6VzzHlgvQlQHYc7BbzU9hEtsDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126819; c=relaxed/simple;
	bh=QwIT7hjUUVpIm7wW7pa8dcd4MWifd9MGeiuQY06Qv8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q9GweynryZFKiZG3O+/JvOILTBzKrNekbMwiXbYotT95Q5GCg34SaEI6fN1/zyGGVYX69IPArqs1NNEsqWFCQsOssQYB+UeFoceZhacXaHhMAot8XYUV9uqDeOM7LZiDChjbLodKLOyuIp66TBvXmaWge7Nrye3JTgjd7V7ppoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=joA2yG6N; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3e04801bb65so366235b6e.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126817; x=1726731617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=THAU92UrM0dCOcON0qgAWJPM/1rIMc3WLepZV6d4U4w=;
        b=joA2yG6N6WdXNzCsJxHu8p54ZlO9YIdfLoYh7z27mHHHPhMO2xdX67VEInz4bqmYB2
         41UJatSme1F/bs9WZl5u3L0/j8T7b0J9WT5osdPoYjVCQsOepxbrmLnZSKhLSrfXoZA9
         B6IaHDXUqnYqh6J7NsJpyEPjUEJtY6+ANk2hRg1XzRXIpUcDU16V2p7LZD6ogvdlE3DP
         ePGtlE2r3WYpkBpM8S3aEAp/YxQREw5wSpH9goP5RPCM6MsO3UPIvGzeZZmCNloH51dG
         M+CuVmqsLAoJy1wfTHVvZY7TLrDzfk/GxkPttfRZwBAmQwpdAu2kHuWmlszBCDNcKKsV
         LsZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126817; x=1726731617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=THAU92UrM0dCOcON0qgAWJPM/1rIMc3WLepZV6d4U4w=;
        b=dTuKLIx8Qdqc5avjttwWp73SsccS5cDOnl9v5WlXEfnJUWcyornj7nH1A+Ptp1ajX6
         nWbc17I8CaPWKqSkz/lO9Afv4OhkW9FjNuXnwX228VjyU72tHVSqLlQkwRVMuLiC9jh1
         XbDEHkwmvepnD0Rcd4jIQWREaEHsU1vwWvoSrDVnUdIEnBTASzpYXkkUzsB0fcGge2au
         JC0qEdLvE9PpacxPqFqwzIUJ7XwBhW1VBGpNBn6WIl83nfTvrX/ubrxRisSqvyeDSRIe
         gFydzY4QBcMlpsWb9Gedhdm2soFCykxvVy41mkuxqxGpfeZGUmmYoh5aEks/G2vAZCVe
         b1zg==
X-Forwarded-Encrypted: i=1; AJvYcCUFKdW/HDD7zM86jW73a6VBcFfBLKUx02Y++F7VZsEMbF0gSc9Rjn56eoXF31FUs72ag1w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc/D/7xDOpkj2GmkqbbxFYiBcDBXntbJHsB/NkDOQwnmVa4Yed
	atayleBkgY9yz6D2fLm6/HqM290o9qMAGNNd3+NVFV0aiSiw0kx/aeBauyEZKt8=
X-Google-Smtp-Source: AGHT+IE18OQNSYCTciWDcZ2tARjoD9KTkXd4QIX1a/2fI71lIh2I9Gute7KgIxVtwws+/7Dh8z96lg==
X-Received: by 2002:a05:6808:23d5:b0:3e0:45ea:7fbe with SMTP id 5614622812f47-3e071a97f6emr1220176b6e.13.1726126817031;
        Thu, 12 Sep 2024 00:40:17 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:16 -0700 (PDT)
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
Subject: [PATCH v2 19/48] hw/pci: replace assert(false) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:52 -0700
Message-Id: <20240912073921.453203-20-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/pci/pci-stub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/pci/pci-stub.c b/hw/pci/pci-stub.c
index f0508682d2b..c6950e21bd4 100644
--- a/hw/pci/pci-stub.c
+++ b/hw/pci/pci-stub.c
@@ -46,13 +46,13 @@ void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict)
 /* kvm-all wants this */
 MSIMessage pci_get_msi_message(PCIDevice *dev, int vector)
 {
-    g_assert(false);
+    g_assert_not_reached();
     return (MSIMessage){};
 }
 
 uint16_t pci_requester_id(PCIDevice *dev)
 {
-    g_assert(false);
+    g_assert_not_reached();
     return 0;
 }
 
-- 
2.39.2


