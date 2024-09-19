Return-Path: <kvm+bounces-27149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 269C597C39B
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A08C51F23108
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE176131BDF;
	Thu, 19 Sep 2024 04:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PIAPAE9Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99A7839F7
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721264; cv=none; b=GZW/zqZhMyVUbIE/CfA/Ce85GGfyyKMgXvm/VG+o3eV8JNDCCJdlgXBBeTDdgiNUshiMRjyGoR1eIAN+AG03XOtUxT+CNY5aHlOSBt61ldU/jxV/WXbgkIpg9sz9qPEIIQTVAQYl4iHGZIRSRbRT18i29aiIpko+R36PlDjgc0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721264; c=relaxed/simple;
	bh=25lbqox4bT09Xf5Plsemd4lkKHcoBxvtHR5q7wmN2pA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aGCObqwCZAGGeIXBtzbHKMjAQ2YITRXN37C8yxI5kmV/5xC4qypm9EPAkbn50WpNGs07TcebvL5PmSmmfmkR6dwlAaEzIrlSME/quZmj7mjUZdt7BscjYa78LKV7LzsZSArhNRr12gm33jGh7bsRb5DmJElhmqYoumIb4HS0YJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PIAPAE9Q; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71788bfe60eso311243b3a.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721262; x=1727326062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mp3yl1TjwHpJ2DET+AsHEAo67XBOppY+FOew/7+eLo4=;
        b=PIAPAE9Q5uVQlQHJuK23EckxjHQAIY38zjAQBo14w6WlcKqt1UtLD2e6uWKsISEhHL
         ouZLf4Ulyi1oU7vWZEKTfjsRKpcR/nC0xEuO+CZMW0ysY53uO7DT2Z1NSGX074b9a0kp
         J/p8LefztARo4M5OxyLjv8zvIdjq5B/cYuVfhekvpJCoZ+jR0c/KBQBnxReFCTX68fNs
         1idEeppYn9pxfUchDjTdQX0o7J5uIF0kvLzuX5oftsiv2L3iC6pf5ceiF4D4E6biFUUe
         WmpiUig0dLcK5fCcxxGRM6jxYi9Met+BB2414Q2RT2WmF1yOJJpIcKwqU7FJm8FipX4Q
         Sx2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721262; x=1727326062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mp3yl1TjwHpJ2DET+AsHEAo67XBOppY+FOew/7+eLo4=;
        b=lam5EI+lbz2QtNjytz5sS2XGxU7LgdFfS6gsso/03u1bBDc9f2N/Z4itguL23YUQPm
         F0n+XMJwhIyjzLxqZAeVjeGjAR1FX6NoWZssQjPFB8r6TcEon+QDZliwe728NjkV2skA
         wLEkB09hKDi8/48XAtMPMGyz+cWwCSV0BnozsGzareqTylR+pSYiDi6bqcLw8sXqaoIV
         D33+wMYAx1EplHyiYsVV2Q0ROpltKXcBtCEorg55NMBYldRTC/+FSUQ4F98XxxmUl0KD
         Vk3Jj29pXPiuhs9XwcXfqwogLx0D43LRpNcjtflLTlJrkSYFzH0gpP1DjABJjq4TKCEz
         2ovQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuceo0P+QLsDarvD7I2gWOPC0Kseh/PyJ9UwceFmE3k2WI7YdLplS02seoJK48ndLPEVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9is0NdIAfID3FvtgCMSQ4wejdSOKSZknw+705bfQPZ1WgXME6
	JKyuiRDH2zrOVHMER3zLHQ+aT+OOejuwtL5mfoGH1LjHczl2zODZ19YInOAe//0=
X-Google-Smtp-Source: AGHT+IGTH8Je8M6ejpwdBpT0Z6Qq2OjP8dnJm8Cntg/tnIi4gVE22oFZXABE3c3Lz1gX4VojsLrJsA==
X-Received: by 2002:a05:6a00:2daa:b0:717:9154:b5b6 with SMTP id d2e1a72fcca58-7192606ce9emr38950232b3a.7.1726721261958;
        Wed, 18 Sep 2024 21:47:41 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:41 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Bin Meng <bmeng.cn@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Corey Minyard <minyard@acm.org>,
	Laurent Vivier <laurent@vivier.eu>,
	WANG Xuerui <git@xen0n.name>,
	Thomas Huth <thuth@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Fam Zheng <fam@euphon.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Keith Busch <kbusch@kernel.org>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	qemu-riscv@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-arm@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-block@nongnu.org,
	Joel Stanley <joel@jms.id.au>,
	Weiwei Li <liwei1518@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Yanan Wang <wangyanan55@huawei.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Jesper Devantier <foss@defmacro.it>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 28/34] hw/pci: remove return after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:35 -0700
Message-Id: <20240919044641.386068-29-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
References: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
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
2.39.5


