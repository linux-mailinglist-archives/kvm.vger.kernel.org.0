Return-Path: <kvm+bounces-26745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BAC96976E76
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 18:12:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF4B51C23960
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B6F14C5AF;
	Thu, 12 Sep 2024 16:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xE32lnYH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BD1148300
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 16:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726157534; cv=none; b=j5GmgGKdFJdGyzh8ZANqJn0asV+CpADCWHuCjLFkX0O8fG3Tk4y2hqJ5rdA+vjjBb/8fVAnu8/az7CwCp+p5y5vVS5rppHLS7Ihu0bE+AERzYKmW6kTqFbiJW+H/l/Sn333my54JYcvPRY6HmalBtpq8sGg4b8+wJUxx414FwSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726157534; c=relaxed/simple;
	bh=7ePZGISZjz4seQJioMzifLb68u9zgTlI1DyF+ig+7UY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AxiUAMkrjPkJ6SjvyfWpoZM8VajQFLv4+LIAd0ULQ0bQaxf2o5PRSrt8wLc80Ini8VG1dP1UcQdTwLn2xOjve0UtSiPH15VY8BRJxjtO4cnlBmyVXOd6DXaWKNKcd62I+1u3MgQFPEzRnUdw8YCicx/QNWstnP+SdjipQLUGFjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xE32lnYH; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7db299608e7so475336a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 09:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726157532; x=1726762332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2RDX2fjFJQRiytlapcKfuKzsswRML3AeBvlkH5UKQw=;
        b=xE32lnYH6r7HTQ9dl6EpjeaO6RT9S8QzrcbKjdvS7s+OeJAmKQiIReXsUm+P/e/Og2
         5MT027i2ubayceKnwdKiywD1FYl99dhCLJGlOIsAgXAzJXsLccOL90Sfg+gnYY7NOxg7
         BjjbsS/gZnpSqj74sFSd1DsmGgidTYcDRzACjYCMEYbtyjmCoXV4dIxzyiiatEQKNgWW
         7x1kyC2LbKJKgVR4ZaP9GX5iph+xvKTc39xm4sCfokianNMSxFXEHeC/0Q5GyO4KqgIE
         ljXn5E1z6i6Ytvmg1Aa4EksMiYcpRXQIejVRGjjphBU5lIjc+RmKjZgwBHEtKuglwffX
         g+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726157532; x=1726762332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I2RDX2fjFJQRiytlapcKfuKzsswRML3AeBvlkH5UKQw=;
        b=TdiIGgysq53Fk0ZGmH0JJafKTnGEUu60pYCTI9H4TIRHW8zwHg6x9Q9zuU98eyycgl
         82BbNohCgm9kF1QtndqZfv0cmR86C7d4FNLwYI6Z0Mql+pLGxDdmA7dymJ77OQD4/SgR
         BySNAJB6GbuM/EPL0I0Mot6K2c1HHiIroYx5JhWVK22hVLWGk+NqXnWfjlXoAbw7rhdf
         FjddkFXTjfAwalP2uQPK0tTTW29hbRmwtGMDt58PAV5WLSG9GZSIo91N4su5Woebis9Q
         UbXTaN95+cYh0l5XPKIowignSH69AnvbBq9biB4XiQosLPlkuz5bIfcUsDQUd2KYIGP+
         rZig==
X-Forwarded-Encrypted: i=1; AJvYcCVJZTUsm6MWb02qu6Ec1o+EuJJMFfs0DhR4VfC8/xBaQLsvHYrMsY6k4d1cOrkAZW8qQ4k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOJ4EyHcY/dwrzEumkEgJp+qTt5sOql+xYK2JWjCvfGKu6OkSX
	BRyhmhgLU0ubMOqyuAS6FXmbEMSfHl8ZKrcVFSPqTjYAfMge9gLs2NHEPMQNsgM=
X-Google-Smtp-Source: AGHT+IGK4aCZmCNuEDtLotPImMG0hqQX92keeNScArTDh0uI/me/xdlfLavv9yxHnNep1l1nzhsFEw==
X-Received: by 2002:a17:903:2285:b0:205:2a59:a28c with SMTP id d9443c01a7336-2076e3155demr54911595ad.1.1726157532316;
        Thu, 12 Sep 2024 09:12:12 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db0419aab4sm10868139a91.15.2024.09.12.09.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 09:12:11 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Weiwei Li <liwei1518@gmail.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-s390x@nongnu.org,
	Michael Rolnik <mrolnik@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Joel Stanley <joel@jms.id.au>,
	qemu-riscv@nongnu.org,
	Aurelien Jarno <aurelien@aurel32.net>,
	Fabiano Rosas <farosas@suse.de>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Rob Herring <robh@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Jesper Devantier <foss@defmacro.it>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Fam Zheng <fam@euphon.net>,
	Klaus Jensen <its@irrelevant.dk>,
	Keith Busch <kbusch@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-ppc@nongnu.org,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	WANG Xuerui <git@xen0n.name>,
	Laurent Vivier <lvivier@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Ani Sinha <anisinha@redhat.com>,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Corey Minyard <minyard@acm.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 47/48] tests/qtest: remove return after g_assert_not_reached()
Date: Thu, 12 Sep 2024 09:11:49 -0700
Message-Id: <20240912161150.483515-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912161150.483515-1-pierrick.bouvier@linaro.org>
References: <20240912161150.483515-1-pierrick.bouvier@linaro.org>
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
 tests/qtest/acpi-utils.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/qtest/acpi-utils.c b/tests/qtest/acpi-utils.c
index 673fc975862..9dc24fbe5a0 100644
--- a/tests/qtest/acpi-utils.c
+++ b/tests/qtest/acpi-utils.c
@@ -156,5 +156,4 @@ uint64_t acpi_find_rsdp_address_uefi(QTestState *qts, uint64_t start,
         g_usleep(TEST_DELAY);
     }
     g_assert_not_reached();
-    return 0;
 }
-- 
2.39.2


