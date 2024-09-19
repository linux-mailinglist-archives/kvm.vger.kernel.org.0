Return-Path: <kvm+bounces-27150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A81E397C39C
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:50:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 397671F23250
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0104A1369B6;
	Thu, 19 Sep 2024 04:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MLerGjK7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4BB130495
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721266; cv=none; b=W7/rljJEPJiBzzm3ANcCWtfujMGLOqzanbDS2vX98AGQpnsdonRj7PbTKAsW0ZxhTY3sJJ+8DwxpcZRreFrBAD6InAF0i/47Kjy1OROtsoXvBArnCnHU8tOR54rNB6XQBcKR6tDnr5reRju36zp31dIY7rz/CuWHd+fNEYf7OwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721266; c=relaxed/simple;
	bh=HWwY24WZZLHk/J+SJCHhl6mzgvIAogrzwEH+WFoXwuc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VRVqW2eDjvyCt3naewgyLhGwcRPjbh20uZN+THV6TS9qjZrDMPdQqPq+DPrTcwIfDtnFor+a/4D34bKHGv9n43vzpxBk0ASI6s38YR0Ji2L6VZEDsJ+dT6TatwEESYOeGrw7tnijmajRdCxE/HkdfSwG9ws7DmjvpK3SkVIwxNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MLerGjK7; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-71798661a52so342044b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721264; x=1727326064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHfEx5g5BzL1PX1RgAlJ8l3kVoVW/oh/s4YLt1Je16g=;
        b=MLerGjK7mKXFKl6ftyGcaOces0UpsulGfMPcebfES2VOVSbVe4iFtHO1zCaKdpbphV
         H3+wGy8GRWWuHr503OLGGZAF8LMA/6Azap6JVCLAfvY6J8IvwKaefgiSpawWVL3atlmU
         4fzojVH+qYSz4y1w3ysmV7eNTcpZ3SNcS3Fzw273otUn4cXM5nPuPsxSXUY3qtR5sXUV
         Rp24ZdQGqcN8wGWfQflfYWKenRPdXIN2odk53YR37BYk+Uwxe4UiTOqIGOPFddEczL2P
         PDH3LpL8CgUZB9X+rwcgBvpkvetSTfmW/UgDaO00MAujvmkvfhLh4BQewJ+gNmsVHNE8
         KFzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721264; x=1727326064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZHfEx5g5BzL1PX1RgAlJ8l3kVoVW/oh/s4YLt1Je16g=;
        b=LJrQWAQay0wORLzJmr7kOwJ3DloDeke/3eImVzaJ3M/Fly+u+yLdKu77DJZJOGGHVG
         +8SfWxe/A1g27GO5KlxklMVP522kuMtHerdAWBVS8799b/K+JM1IjlTjmL4dohb7JN+7
         ZMz3g9AxDLNIO0O92mzv8eG8R9vB2sm7ErrgVVQ5r73Ehva0rKWMK3QjCN/MFDfKcC+w
         BkzO+wuZ8/wdjz7tonK9H2471vbZfz8EaSIaLMP6w8Ik0jQhWAqGMFzvsKocDwG4QXGZ
         oPn6DGxaGNGVHtplYFx43DkEWKpmCnPPNQThHJlvYJOUe2UGHkoumQf9FQglGV6tAmtU
         DE8g==
X-Forwarded-Encrypted: i=1; AJvYcCUOkjR4vA5Wswywe0zNAwECi4NfSb9G9oSf9Z3hIuiFrcUpQo8ztcotazz482pxQvVvNR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJyVcahCqyUR06RGwu/yQ5GUhNRMhNzoC+LsLYaFZmzNom+5Ck
	RO80O2e2fGIie3luJQPaZjWyZvmeOxbeavJnpqs5Du5w0RmmWiHQc+SjZT0laqo=
X-Google-Smtp-Source: AGHT+IGn0zKE4NWTBii40hBHgJl3lvYHO2m3pyUcQ8D1+09Ub75s0ooGndgxJcjdbl40KxBP6dN9PQ==
X-Received: by 2002:a05:6a00:1746:b0:70d:2a1b:422c with SMTP id d2e1a72fcca58-7198e2a8f1dmr3107578b3a.7.1726721264030;
        Wed, 18 Sep 2024 21:47:44 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:43 -0700 (PDT)
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
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>
Subject: [PATCH v3 29/34] hw/ppc: remove return after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:36 -0700
Message-Id: <20240919044641.386068-30-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
References: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch is part of a series that moves towards a consistent use of
g_assert_not_reached() rather than an ad hoc mix of different
assertion mechanisms.

Reviewed-by: Cédric Le Goater <clg@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/ppc/ppc.c          | 1 -
 hw/ppc/spapr_events.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/hw/ppc/ppc.c b/hw/ppc/ppc.c
index e6fa5580c01..fde46194122 100644
--- a/hw/ppc/ppc.c
+++ b/hw/ppc/ppc.c
@@ -267,7 +267,6 @@ static void power9_set_irq(void *opaque, int pin, int level)
         break;
     default:
         g_assert_not_reached();
-        return;
     }
 }
 
diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
index 38ac1cb7866..4dbf8e2e2ef 100644
--- a/hw/ppc/spapr_events.c
+++ b/hw/ppc/spapr_events.c
@@ -646,7 +646,6 @@ static void spapr_hotplug_req_event(uint8_t hp_id, uint8_t hp_action,
          * that don't support them
          */
         g_assert_not_reached();
-        return;
     }
 
     if (hp_id == RTAS_LOG_V6_HP_ID_DRC_COUNT) {
-- 
2.39.5


