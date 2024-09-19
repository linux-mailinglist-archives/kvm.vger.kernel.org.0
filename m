Return-Path: <kvm+bounces-27148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5242A97C39A
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76B481C2221C
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFDC81205;
	Thu, 19 Sep 2024 04:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b32aZyIM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAAC770E9
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721261; cv=none; b=htalzZnlRU1OnekfKSh6gEf+WKiuh5J0tM4R1GGbY/LcTCGO58X42sbjXHEkm7DZZzx148WpbqzLPXiHrPwUsu0E0lEKvcoMx0fQLD98AinxxypabDHFDRxGoraZRdEEjrZSndAv/Zx72TpwMLuIWC82DA9YlAxqL3Y1lAueQqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721261; c=relaxed/simple;
	bh=tptLqlcF/Nx0RRmv6IB9N0XbV+UnMzYqcQa/pMA/Qe8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m4kta8RGS8Hx0qO0zeqH4CMqu9B6cYliR7hJPQ+fF+fPgYc9EXQCtxmgM8Z3OB/7HRmhEh29bs9/LXpFVk0obQIlhN4XNTCZlOqjHozTTM3aZWKop03hPoyxeptT2f7srTQT1RuIhK/3/efPuRhoDS98LVOBHXptekgw1QtBw1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b32aZyIM; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7191df6b5f5so286978b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721260; x=1727326060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aVLlQ1azCZTPpBP5TtwQ0P5RnlTFYhwK6Tm+S/9eUGE=;
        b=b32aZyIMcN4wdkYc7RCAOCGUKdgK+brgqmR74IYcfpsC0rvhHnZ9v0qVtg2TAQ4Gcw
         cA0R0b4VvUbCnY/IOLYhxr2RPROsm3zdvMNSM6W6f09nN/w8gUg7CMD8gohxDMwX2DJX
         Cydyb2dqDurawraKEiEhmA5I5CWOaWm3l97bNs08ekK3oHqjbbVkQE728WktYDxbq/Nu
         MChyGDN02VS2/3Ksw2BWRWq2BOs5X2M+0jvccsNDi66xLiEP2nUJXu9BZ9I56iLgRjIn
         fiVjvtxecvhaBwlABys62u1hFedSjSupxGjCK9PjAHPoWjQE6IdNhz3MQVE3XR12/1uk
         TFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721260; x=1727326060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aVLlQ1azCZTPpBP5TtwQ0P5RnlTFYhwK6Tm+S/9eUGE=;
        b=XsZlsmIj/Y2KhBQFxZ/S/z4Q++/Xru3ch1cA0VvhZiUHAp8pnEuImXOjUG+b1vjbj6
         kbVe4tOcldq+RPvlZsUNGyNqIDYcgubfBmrDm1pggGnPzCyy+9v2QsAz2OUzgYHuKfmQ
         FKgIMJI/Ms88kwLD4t+NTrqoAs6d7TQb/6boA7BB2LVMGz0mfB4Y4S9DjKxE3TeHJIEB
         yhMrEaYTzbJqHvLHM0acFE23jMRDppNDo8HPZkUXF+S1Gh/mQP3hDsvuXAkApB4nj8KE
         iDL2yaZATX+PRVrnKmhbvqrQoRspmRLofEPElQltjGwxvtYFAld5wrZZTiC3b6AAyNx/
         w5DA==
X-Forwarded-Encrypted: i=1; AJvYcCUteab1Qk7gC7FMiVCgbT4tDwb5SVM5r4UjYP7FwT8iGF1U93/03SsSg/a8q0blwcHXS60=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh8agycJAUB8C5yhCh8WBw13ghoqP7Q0eoobzOnnfjarG+R5/D
	ySCDBvcrLhIgT56N9t4p7x9lof3pDB2+1o7xhz+VzpCreKxnAZj4i6sv0tPeV/Y=
X-Google-Smtp-Source: AGHT+IGrzvQ2fWBlgZ0/fu1uxdvH2ybmzImXSv0pyHCUPeGuO+jD1r3RwXqEDbd4priHhUIUEE1u1A==
X-Received: by 2002:a05:6a20:cd0e:b0:1cf:476f:2d10 with SMTP id adf61e73a8af0-1cf76239c98mr35848879637.49.1726721259880;
        Wed, 18 Sep 2024 21:47:39 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:39 -0700 (PDT)
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
Subject: [PATCH v3 27/34] hw/net: remove return after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:34 -0700
Message-Id: <20240919044641.386068-28-pierrick.bouvier@linaro.org>
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
 hw/net/e1000e_core.c | 2 --
 hw/net/igb_core.c    | 2 --
 hw/net/vmxnet3.c     | 1 -
 3 files changed, 5 deletions(-)

diff --git a/hw/net/e1000e_core.c b/hw/net/e1000e_core.c
index 248381f9766..2e4c50ddbaf 100644
--- a/hw/net/e1000e_core.c
+++ b/hw/net/e1000e_core.c
@@ -562,7 +562,6 @@ e1000e_rss_calc_hash(E1000ECore *core,
         break;
     default:
         g_assert_not_reached();
-        return 0;
     }
 
     return net_rx_pkt_calc_rss_hash(pkt, type, (uint8_t *) &core->mac[RSSRK]);
@@ -841,7 +840,6 @@ e1000e_ring_free_descr_num(E1000ECore *core, const E1000ERingInfo *r)
     }
 
     g_assert_not_reached();
-    return 0;
 }
 
 static inline bool
diff --git a/hw/net/igb_core.c b/hw/net/igb_core.c
index 6be61407715..5dffa12c64b 100644
--- a/hw/net/igb_core.c
+++ b/hw/net/igb_core.c
@@ -398,7 +398,6 @@ igb_rss_calc_hash(IGBCore *core, struct NetRxPkt *pkt, E1000E_RSSInfo *info)
         break;
     default:
         g_assert_not_reached();
-        return 0;
     }
 
     return net_rx_pkt_calc_rss_hash(pkt, type, (uint8_t *) &core->mac[RSSRK]);
@@ -747,7 +746,6 @@ igb_ring_free_descr_num(IGBCore *core, const E1000ERingInfo *r)
     }
 
     g_assert_not_reached();
-    return 0;
 }
 
 static inline bool
diff --git a/hw/net/vmxnet3.c b/hw/net/vmxnet3.c
index bb8583c7aba..8aa8c462283 100644
--- a/hw/net/vmxnet3.c
+++ b/hw/net/vmxnet3.c
@@ -456,7 +456,6 @@ vmxnet3_setup_tx_offloads(VMXNET3State *s)
 
     default:
         g_assert_not_reached();
-        return false;
     }
 
     return true;
-- 
2.39.5


