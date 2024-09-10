Return-Path: <kvm+bounces-26368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 248749745A2
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:18:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD1E828BF95
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C38DC1B1507;
	Tue, 10 Sep 2024 22:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C+ajDqPD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9631B013F
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006616; cv=none; b=tyX+pGBzqWDEZV8RpZ0jmsxv1mvF6wabuQonc7ED79jg54F+WWbrfCIyP0Q/hM90f4e0IAaR+T02NnBBcaY0UOikG+KP9YVihWNVSP6T1GGwb6AVsZqof2l19TL40g0HW1mFby4L8zd52fXZ18nzhiPgDL5j1STi7oABUOVUS+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006616; c=relaxed/simple;
	bh=zZHblByLQumGTFty+KN7J0PDXXlIzFYijZu7SzODD4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s67l80zqGsFTTiMUSXaz4RfrOipJZI7os1TGrqdS9odMXUVxlf+1n81B42CjD33TiHiCOKvQu1iEsMArzutj/hkGIasX+rjxPkTClfi/ZD2ptBCKnhmne7oHK1U52pYIvdwcpsopiupDuP1VGFo84AeXpyo56ngC7KWDvG8DcDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C+ajDqPD; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71788bfe60eso980520b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006614; x=1726611414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g94oM2AdOrkhIM0zmQXs6BZslT0T+3A9bvoVuc5szJw=;
        b=C+ajDqPDV1qqoKnKlhwKDPetpVF92pJxRwAT6FXAdvqt2+BZ2DiMtbh3cQ9s7ZxPJK
         /1gNyj+hPhhEn/p2ewGnodD8Ks1ByP1XHD2Soy4gF1TmOleOCWKSY2WwrLFxgpCyDLIa
         SQWrzvadZwllFUR9Sm2aEYEvuxIymK5M7kckQA5S7qdp8iOb+diqTjRHL589XbOULGLM
         EeNGg5W+v32pOFeT3WasCyTrb/oR6K7azvcKsYiD5dpsJ3MpvuOuYUIk+9oGT/5JfWcB
         /pYkrg6WVP7LiSNymHvZbn8W6GK/g0SmRFnaTaXzbFbYeUqPQQBHGdrIJh2wjBmJi1/I
         dtXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006614; x=1726611414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g94oM2AdOrkhIM0zmQXs6BZslT0T+3A9bvoVuc5szJw=;
        b=lALp74snQO8tcl27nAn1A+ZJ/q5iW0l8+cRowbiGzWiaEfTOTr1NbJyxfTW4Zbst6k
         +gSiTWEWuAVsm4UzcsypfKu+0WpV5DVGCi74by+3ul8HTjEmmw3u/MfUDtF3o07neqXt
         /oOgAcTgtsUX0s6Qi/rH2PYw7hTYIWjqc+SbeAaVvScUvTijWFNJ2fSupdmTirNP6c60
         SFja7Dwh1YtGu7sTm9wB3o1gf5Tl9Uom80iTxQ+lpElihciwB6j89XuuIarzBOODeq0/
         l4XVjwTjslVKtbHav/tCzAUlEF/uFk1H/RGnWuSX09OBoXZXhrw7+gaxni8pG/jULIG4
         W0QA==
X-Forwarded-Encrypted: i=1; AJvYcCWa0ipwbtHo9W+bAuHpq7IK7Bh9hvnTV2wVwOePUCpxp88jXf0pIN7Qw95BPPk/6IrhKrI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6mNbaYEqwjA2gyIZ4zLI4XtdDdE2x75bbKNECPMWh+3giB6MS
	YUJZg2L0roSIDyOztOllKAeMkFGw6CvH5wwJdW7qHhW02h3Lp7UbK53g9lq7+js=
X-Google-Smtp-Source: AGHT+IHL2ZH6nUBIcX/D81YvSHijd2PVp9cRI7IyORN5V83dLkzGAu93AwGsK5Tkm+BoWZtfm/pR4A==
X-Received: by 2002:a05:6a00:1803:b0:714:2cea:1473 with SMTP id d2e1a72fcca58-7191723a295mr1055728b3a.23.1726006613650;
        Tue, 10 Sep 2024 15:16:53 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:53 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Corey Minyard <minyard@acm.org>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	WANG Xuerui <git@xen0n.name>,
	Hyman Huang <yong.huang@smartx.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-riscv@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jesper Devantier <foss@defmacro.it>,
	Laurent Vivier <laurent@vivier.eu>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fam Zheng <fam@euphon.net>,
	qemu-s390x@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-block@nongnu.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Helge Deller <deller@gmx.de>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jason Wang <jasowang@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 18/39] hw/nvme: replace assert(false) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:45 -0700
Message-Id: <20240910221606.1817478-19-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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


