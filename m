Return-Path: <kvm+bounces-26636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B502976301
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 206101F242A1
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E75CC19C566;
	Thu, 12 Sep 2024 07:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sj2X+unp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96B819C54C
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126822; cv=none; b=rRp+GJG4nUnsaqfPD/auG/I/T5QhS/4q7MezfLbmIkrMWMkAsR9p6h+dzrIvbmT2YZ1NfymoAG6MlFQsxJneo7hvXlyIjsIBDPElWlb9NgphnUARFTrMsL27PlKGbtnfOlW7F8WEw3yWeiUzQRM5ixlOHt7jdfqNUFjSJjlM/zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126822; c=relaxed/simple;
	bh=6n8Iu1eagLaf2nrikwLTKltHnnsvygVi78492lc1fYo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WsI452mdoOvRTONiYauZyIFCcNoulEYXfvmJoSblC0mKK+pOapl62/tL1EX00jQVQOFCmrpOEFEtwQ7sJ8U2GaCBneZthTdiE1uxOaCekV2/aSj6dFUAnngrxENTlsBCc4ODgJz0vtwbF13STZ1iovn0OkptLY9XtTsyMHo0R8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sj2X+unp; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3e05a5f21afso356890b6e.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126820; x=1726731620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QDay2TYnrrMfur+0/EEHZALdjurI2FyW1zrkZGDuads=;
        b=sj2X+unpHQqrvhzStvjsXza9lWpErfSyZWgAI2y302JATd9vetXii1LevxCgAb9Y7C
         MWerXJsdi2qCkm0vYWcABGCWWnS06RyCbgK8ylbSE8XuY8hRsmHP8LRkoNmDWK/8Jtr8
         epaBIWAvsZxm54fNhNbYxKgn21AaVyoxLR2rJBOcr8wqWxHAjvzmNOxUqEdHrvD9fC9c
         MQVtNVVGsumDawD7V+ji+q0mRQIyjNoID6FhM8+4DM1moqUefUWR9mOT7w3eVcwBtwI2
         Kb6VyOuRrgclMW6sPjuoiaZ16rS7donjuqzY0i60W9t9ulvxElAb75EuAtX/1NI2Ya8j
         qJ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126820; x=1726731620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QDay2TYnrrMfur+0/EEHZALdjurI2FyW1zrkZGDuads=;
        b=mpzXzInNd8l7MID9B1wWqf0oo++Ejf45Gc67veairX6WAZGz4FKJWWjYRK+BNTWM9G
         r5rQLwcpPWRVOtQj1BgnRzDePL58Z1NPc/u2f2hafOBFpR2TtULs8vP8MxahAgooXGzN
         dqrQRrazyinVfYsl9uOWss8jF1i9kyr10MDYGBy7QolvReJtZYcHKRSGddzhnVzRrRFa
         xXgZHsQO/ZJ/EJeVNRJKJKZBmCMosswTWc2Sp+OECFJFcQRZmddDA8fFOlbP7bQ7ZYpt
         1iM4CTJefaKetKH44mpQcd9NVZo1j4Z43jVcoxIK7MYI1/tt9/05Bm5lOS+TYfcVe5D9
         HMfA==
X-Forwarded-Encrypted: i=1; AJvYcCXdDAVNycEHVa1YB5ZhuiwssT1ygU8f2JNpx9aFs3woka+DCtjvunQa0t8sCGADsBhyMqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjePw4eM/dB6TTYVuya5GCni42FI+mgGCV5Jy3Yy0J3c5gP+6g
	HwU+N5ihkxVa+wVxQNLr9+/TxtDS0Ot77mO9mI03YzVBViCOSDFKuz0YQUEeBJg=
X-Google-Smtp-Source: AGHT+IGYhbpRKjr9LXlf6ua3NjBjcAj8nIFkkfD9zPLBPpLzylMLlenLFQR3rSDBD4RdwwuqK2vzTw==
X-Received: by 2002:a05:6808:1290:b0:3e0:41ca:1443 with SMTP id 5614622812f47-3e071a9a491mr1814477b6e.16.1726126819675;
        Thu, 12 Sep 2024 00:40:19 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:19 -0700 (PDT)
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
Subject: [PATCH v2 20/48] hw/ppc: replace assert(false) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:53 -0700
Message-Id: <20240912073921.453203-21-pierrick.bouvier@linaro.org>
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
2.39.2


