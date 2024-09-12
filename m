Return-Path: <kvm+bounces-26634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A8B9762FD
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:41:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DD73B23C53
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A851990C4;
	Thu, 12 Sep 2024 07:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qRDUt6hr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D9118FDDB
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126816; cv=none; b=pcpy7nWQEPtdr2RucahrbiCCud/5JJWj8t++61JkIRZYASOf/DfjL735CwEMKeZPrB4c/Rw4fCxr2mNp6UdrTH0iSQuVjL2qNi7bHxlZB4Kj1jS6s3FwAvA+AGThDBO8sdN9u+iwWxgvF2xQXA7L4pxu51ijCVranf8tRPoXNhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126816; c=relaxed/simple;
	bh=eEnFhXW8TKgilQt2LSiJkpcgLzb7JOAcTjQeFy0AF6I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QPCu8CFeYbVRCsOcADZD4BbQ6GfCn9bdmhCuEfh9C+AJEVapGW4+EBY44YuWTYiK1/NUo/P0/gkACgqcUcgri6Ahi0bl7u5+V7HGa+G4nT7RAFPVf/avTnuf2tPreow9jqLznyP6n4OXboNqX1BwQ5TdDtjsz0EyUpn1CGmTE9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qRDUt6hr; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-717911ef035so416312b3a.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126815; x=1726731615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TcrlVQ2BBzTTTXSH1b4iRRRxuNhgYzpbZvccV8dHuB8=;
        b=qRDUt6hrbjmONQqQLDuBshCPjfS/SMY8B/XzDzz6Kizv8HHsR1HNrPa9oA+ugfbrLO
         UusY0Um4evhldk42wGrbClxVNpdtEOIT5YrMwIq1KYfvLEzZs4cv0Yn5jfLS+ihC2v/0
         Ei9Aiz67sZAyzxEzejHLQkWOFd+SKjwZWCNZuQYQrU/OxmRC73tKWaegxk+zblTL4M+Q
         xlHMfOFI0WXabNJLApaN/l/TAYZqRcbfTCOJgmP4fpgnUgwAvTWpihVR9uw9aM7u520U
         D2qxLOvd1W6yTLMrWOa1HzrFe5whQIjoc2eDUPNSoK17A0NFicaa8JxgSv14orj2Yt28
         KhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126815; x=1726731615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TcrlVQ2BBzTTTXSH1b4iRRRxuNhgYzpbZvccV8dHuB8=;
        b=KC288Pgrvzy6faOCiVHB2c9ZFUGlWh7qg8Rdbm8l8KNZHEERfa9dKNk18OlenAfGjt
         Q9zXEHRqNiDsMFBVvnN/9HBi1YBESBJkETjtfiQ5ouMfhwS8IIHA0Os+ytgNxTFJ3ntI
         k2WokTsAKp5KQdecyiV7ub9Ek1D04FcQk4/T6IC27TyLZzHzytVrptSi7/CyEglZWXSm
         DaMa4aWUHTg1tPgCQLZTCEJc0xZBPL0fvMDzmifzyYvxImiYV31/wvtPtSxkJACtE9Dj
         kwk5XPVYTnqNXvFc8RfIrvrsfDvq1ic5zKnCoXUqX4yeS+xgOtmj0VzgPOm+THOvhMbf
         rsVg==
X-Forwarded-Encrypted: i=1; AJvYcCWlvsiB5qK6/f3jNydYx9ZvARaW4qIefUQVZm8aFersgExHnQXlFB2YzVy4Kpdc9IButIM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh4wSv6mT/mGfREefiasMyH1zSv/Z3tRJnUKKzI2QjeuvMrkv8
	rXSDgwntFsw7xjRiSwDRg3nASCDUZ5dwT/Uhu7zY1sxyyD53CLci5QeZsBXe5mw=
X-Google-Smtp-Source: AGHT+IFAZ1Pk4eCCVsZPvVoIoG/IsRq4YVcZJLHNGvieq8Ne31Y/ZKtRMM5/ZNOtWgduAu3UbqRH6w==
X-Received: by 2002:a05:6a00:4f90:b0:714:1849:2503 with SMTP id d2e1a72fcca58-71926055cfamr3299082b3a.6.1726126814532;
        Thu, 12 Sep 2024 00:40:14 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:14 -0700 (PDT)
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
Subject: [PATCH v2 18/48] hw/nvme: replace assert(false) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:51 -0700
Message-Id: <20240912073921.453203-19-pierrick.bouvier@linaro.org>
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
 hw/nvme/ctrl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/hw/nvme/ctrl.c b/hw/nvme/ctrl.c
index 9f277b81d83..fc3b27c031e 100644
--- a/hw/nvme/ctrl.c
+++ b/hw/nvme/ctrl.c
@@ -1816,7 +1816,7 @@ static uint16_t nvme_check_zone_state_for_write(NvmeZone *zone)
         trace_pci_nvme_err_zone_is_read_only(zslba);
         return NVME_ZONE_READ_ONLY;
     default:
-        assert(false);
+        g_assert_not_reached();
     }
 
     return NVME_INTERNAL_DEV_ERROR;
@@ -1870,7 +1870,7 @@ static uint16_t nvme_check_zone_state_for_read(NvmeZone *zone)
         trace_pci_nvme_err_zone_is_offline(zone->d.zslba);
         return NVME_ZONE_OFFLINE;
     default:
-        assert(false);
+        g_assert_not_reached();
     }
 
     return NVME_INTERNAL_DEV_ERROR;
@@ -4654,7 +4654,7 @@ static uint16_t nvme_io_cmd(NvmeCtrl *n, NvmeRequest *req)
     case NVME_CMD_IO_MGMT_SEND:
         return nvme_io_mgmt_send(n, req);
     default:
-        assert(false);
+        g_assert_not_reached();
     }
 
     return NVME_INVALID_OPCODE | NVME_DNR;
@@ -7205,7 +7205,7 @@ static uint16_t nvme_admin_cmd(NvmeCtrl *n, NvmeRequest *req)
     case NVME_ADM_CMD_DIRECTIVE_RECV:
         return nvme_directive_receive(n, req);
     default:
-        assert(false);
+        g_assert_not_reached();
     }
 
     return NVME_INVALID_OPCODE | NVME_DNR;
-- 
2.39.2


