Return-Path: <kvm+bounces-27133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E634B97C380
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 574B1B226D2
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E900E3B1BC;
	Thu, 19 Sep 2024 04:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UIWoIAyb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A581B381D5
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721232; cv=none; b=TPmgCXJ23wo+gsddlbvtJKnp1or34xknkrKrhLqtjJHbbvg6p5LYYspIE8DdKaa8tY7TGT8kKGPrI60/56Hv4pnr+8bNTH2q0uM+LWoJX/9hvgTYRoIpmI1UV9ysoVunc34GvkLrtQCSmsupScwqoCCqNOhW/l8Z0SuvCgmjy6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721232; c=relaxed/simple;
	bh=MA4psclHk2mo0EvDqljV/Hi2LnP/rFStdZUcIWQbY58=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iprr1rIl24b5ntJ6zBp0brFII+lvypDyITO1wy1QQSYIYzgGZqhULMK0Xyl4t0+A7gGF64HaFyc89maVsiyMWHP7s3x01FMFCNqgruV+odcjE32vYY94tfKyFUyyrR25IvS9QqLQJMxWfJ/Vl/HeWESHQYGJzcHYOTkcveEHG30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UIWoIAyb; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7d4f85766f0so296174a12.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721230; x=1727326030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CjdIkjZ1sAe4H4BC4R89ohVomEGFONKXxXhMv5Uru1o=;
        b=UIWoIAyb5Hk3qzocSyIOMnqW1d7xBlf9zIo85bbUMGnqInT+RGTzqmOAhg/+Cg8VfX
         2q0COhRoOxF50j3sdMiPFJ6P5JAnLsIb6Ccf/PWE8yXN3PXoycUpSLWtQ9qkvHTbeUMp
         0U12kmr9szy/tPUUFyjh4zsSRiSP+ojYtwttSfYHXB/vsNb7lRKNpzevv9FPteu80giy
         F214ZO8SeUz30aiNmA1FSNk2wP+meSNOOD/aKfsWW0m0AQouOahI7xh9r9kPWMpKU5uN
         67NdIyQZ3XP/YLqSlFgL5v+uuXrx9vOdUY9Wo7hA/bMCqAuDtq2QvQec7n4yJg4bzwER
         Zkqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721230; x=1727326030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CjdIkjZ1sAe4H4BC4R89ohVomEGFONKXxXhMv5Uru1o=;
        b=ppN+m1PDFZr3pXGl1DkUhNrDU8UeRNv+Xw6hIdLvLeIw+llukKYuJWakt+17qWfjrU
         +KRof1e2J/RPMSGapBc7zI5M9d5Qc/71rgpiagvKgsPMVlgsq76daKyHkprNpiz1Kl04
         ef/nHs6XEdz5/qAn0c9fodOhJde2NL+NLlpu5G8ZiscsdFF+0+wivPpM+xRCaFAOOa2Q
         oRx9AQnfDN3gIgw0dxI2vm7Dyp2HSIbv2Do15luJTbw2Cisie4Ji01QoKoO0V0Ves+px
         lnr6lsZ+djIQLihuGGfaJOnuSuFp0OBLRvqKR8m4yiPo25SNhVUZlotnAvLZslbF7GQf
         338A==
X-Forwarded-Encrypted: i=1; AJvYcCXCCkPfQ95SyXrs0lobglBbDdWe6elXth6gjyt6wcqQyqX46XoOp5RbHZnKRaq2JHo83Tc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0Beli3jp9/HmPWbxMp6gmFRv+mdSlTiic/KH2wfisxNPR9wVy
	FA7lrUGSQ8dRsIx0LVIdL7i1cYl+zMXV1EwyZWgtYhAiO/iNFOJBHNDNr9toEwY=
X-Google-Smtp-Source: AGHT+IERhGsxI+Cf/AQ9eoxDwuPeIw/CBq8x28oXvdQRfLJHCxXd6tJwjKv16QtJVSkDvTe4ScWRrw==
X-Received: by 2002:a05:6a20:b58b:b0:1d2:ea37:95f5 with SMTP id adf61e73a8af0-1d2ea380ceemr10245819637.11.1726721230050;
        Wed, 18 Sep 2024 21:47:10 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:09 -0700 (PDT)
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
Subject: [PATCH v3 12/34] hw/ppc: replace assert(false) with g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:19 -0700
Message-Id: <20240919044641.386068-13-pierrick.bouvier@linaro.org>
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
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/ppc/spapr_events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
index cb0eeee5874..38ac1cb7866 100644
--- a/hw/ppc/spapr_events.c
+++ b/hw/ppc/spapr_events.c
@@ -645,7 +645,7 @@ static void spapr_hotplug_req_event(uint8_t hp_id, uint8_t hp_action,
         /* we shouldn't be signaling hotplug events for resources
          * that don't support them
          */
-        g_assert(false);
+        g_assert_not_reached();
         return;
     }
 
-- 
2.39.5


