Return-Path: <kvm+bounces-26374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D0699745AA
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:19:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AA111C253FF
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 097A41AC8AC;
	Tue, 10 Sep 2024 22:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xr0fFnQF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80C01B29C1
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006629; cv=none; b=NrfGhDNCiE6bgV7kbMLaa9De/4WSICjIFWdNMmlybN1YKO5TvkKKSxHWz9pVl0APXNDGkRnt0vg0h4ZbCu2uFRSXEHvTqlrijkCa+5Sy5j5lS7xAiMiJ5UpXf7ZrA3MPTTSwZEL2mFAqYxlaM1ooXW9jshMCUR6IlNsNFLbRTc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006629; c=relaxed/simple;
	bh=bs1VVWRt6rLtUfVmZM0ZnFO4EMeIfBMDWxxonlsKOA4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ftq1P1VPDMZKtL+7ustqpWi5aukg/lE6ZzpQyBjt4NO9rfVzEjgUEcW6+0T6wdaHsb640tqLG5oVbuiUlXbHj/zMuBftLLgEPeFPOYfHpKSMPxZ/zHMcQXiVUq1Z33jRZF8VWJRpUdZvbDIhSPoIYKgyJvv1vxReAD5X113l8jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xr0fFnQF; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7d916b6a73aso1775455a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006627; x=1726611427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PMAzhundz5cnlhXkr4isErmBbfbpq/QVHnsSNQckDH4=;
        b=Xr0fFnQFJ8+hYREz9tSEr9Fq5OGkT7frzzPCn/sRPis1FEr0MMAMbq3tjR+VnvtPrY
         tYILZBLTETwbavIfEccKrHqJL72KlVvrGmoJToJLuUp1X/Wo/RkXFtG9sJS5T/dmaRAs
         PdLHc3ynfQ9+bwV3np5SWhg2KGHDvzVRVSCVXPimfNmysWy2DQJL4BVKUM2oq04uki+t
         UmWjNHFeL5OjxGRpQhyDZ916dqZnpCIOtGVq6x8Vm9AySZuV0F3C7OZkYznikShLxndM
         purNRRpip49x/+BW51A/fDgs5K8ThkS5IzNbdXqY2OqRLAm6zoClDRCziX41PvcafKMC
         I8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006627; x=1726611427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PMAzhundz5cnlhXkr4isErmBbfbpq/QVHnsSNQckDH4=;
        b=OsyRnNH0RrcRwbuP0tQ0kGbTGwLjtsBVx4ZFRE6nd8sjfFPP7Q6KgDCHB6Uo9/+XLI
         LvjI1PGy/WCGNFTo6R3/GVWsM+xJO2GZVv2bLmonVH/E3O7zX3lXM9EDfOunLo6he8PT
         nZXCtga3zvljlrMpCIR6wHzlwyRYy52p9pMx0pnOdF583qrVDS0a5nSU2prn3HTNOXQJ
         yI5FkboQBySUgbngmymbgS/Z1aepYUg5+weXyrUXKVrGbsuovZMdK2ofRtwTbFJeZofV
         5gJFghKCDUhOFpHsrOFqji9RduYumHVuhj5GgglIJpI6tEZYtHvpzeBDww/knndCnMLf
         yycA==
X-Forwarded-Encrypted: i=1; AJvYcCV7neRYR61m3c88QMq4+ro+aByaIW1sOIU17h7j9bx10bVDxURP21V1NsBZIBqsoUQPRA4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9ok7TV/FWSu5aPaUEdj4+kJ3glBXneEn7qjWqoYjRo/k1+RMo
	df05I58+MBwWvCygO7mkaOFtUk+5nTdvWFM/3vZUNiglkeozlb64ALWBst8GZqI=
X-Google-Smtp-Source: AGHT+IEi5JaA4MkES+9U+PpXOPIvBZ+R7wRmXVH+oG4VWiCcruy8sEZ0nEXAobw17ZrGyKMKj2WwFA==
X-Received: by 2002:a05:6a21:3a48:b0:1cf:20a7:ec65 with SMTP id adf61e73a8af0-1cf5e19cebbmr2662324637.49.1726006627163;
        Tue, 10 Sep 2024 15:17:07 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:06 -0700 (PDT)
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
Subject: [PATCH 24/39] accel/tcg: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:51 -0700
Message-Id: <20240910221606.1817478-25-pierrick.bouvier@linaro.org>
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
 accel/tcg/plugin-gen.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/accel/tcg/plugin-gen.c b/accel/tcg/plugin-gen.c
index ec89a085b43..2ee4c22befd 100644
--- a/accel/tcg/plugin-gen.c
+++ b/accel/tcg/plugin-gen.c
@@ -251,7 +251,6 @@ static void inject_mem_cb(struct qemu_plugin_dyn_cb *cb,
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 }
 
-- 
2.39.2


