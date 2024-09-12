Return-Path: <kvm+bounces-26623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 702B59762E8
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32B78282305
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C9A191F69;
	Thu, 12 Sep 2024 07:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EhUa8Z0G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBF4191F62
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126786; cv=none; b=sDhHv0D7TFCRCxViWR9uYUR33NaGDwDN1EygVQbgBwPndUSXXu032lCKPXpgTMOaHPkTlqSgnkZfDI3/7RtMMr6PHgEo2NtNtfHvsXdBaXEIftI5RMbzfBbOLONxECNtewQEI9cBMsDGG/E52LhUaUM/gT2aqmAdIutbnZGu1es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126786; c=relaxed/simple;
	bh=6qAb7sWpCn5TQZoArQNa7V4gZJlYhCAnXB3dvj26Gk8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ehugi+O5qpZFLcamVDHAKW+Chi8xUCKCy/EaFYSy+3QIn2OCRg3r7GP4dAT9s+8kfRh7bAlaf+szdByMT2HQEwnMcE3tJhK+TrFXle4G6tYdlc2ZaS2108bPkc4wMGXUGZtegrv6g9aSMhnK3TbdNyFO/rlLPE2ts/92ogZ26jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EhUa8Z0G; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7db1f13b14aso632483a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126784; x=1726731584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPBETK2XAIe21YqE62iAjxbH8O1+L7jgUq9LFf3cER8=;
        b=EhUa8Z0G7L1DKtNBeTiw51zicv5ZB/10Xu8sCq6LhHn41GPn+Vc1QS+eEhVMpqj273
         AFJnJVAiD1w2gjXpjw8ViDIFCAkXLGojC59K4vnPMh1ES4yybQUoc7LlDiX7sG6U+DOR
         fOIiNH2gDfyfrUW9iLs22vJtrilL32gqAdE0IRWrJGZ7SQ35Zba3PGJ77YBrX7Ce0iYA
         NskYwUUplGWs9/VnOkHRvJuAmF8xEaOrBZoiWVXTflCqxglNQk6DE0lNZPZZSA0WFYMi
         LG1EOZ0MeO/Ve0V8Fn6/l+ahD5KDjlKP6qOH7DoROZuXPWGQ3DCJlulSgXU5NFHRVAGm
         zlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126784; x=1726731584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JPBETK2XAIe21YqE62iAjxbH8O1+L7jgUq9LFf3cER8=;
        b=m3iO9XyNfZo4sWmp0Ji8qFTfx346Un7+cTxoMdLDWirgq6mjDrxwubVOue+hFnwiju
         A6yTZrr+3uwNP4PZk2Zt3ZcOrpgIBmoOSC/S2qOylH4nQ5my0W4mtFlhu79x3t0kDJel
         sSqhnU968QRyPivowsDKisEymMe3u8DkxZE0D5rm4Gnyhl3/2M4WepMXUWrWp30u1TVG
         x1uly/o6sj9nz8CkQLwKUWVKIqWZDl/b4yApLhgbyG4sCrX1ItOaUW6QTtWse1RlnocE
         CCs++0vjIa4LoQQ5mTK9fYlUMap/2XAQ1uw7V6ifd9KMD+gKU1Rq9o4xKIRApQUdOlgO
         v1cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPJ+18JVlG2T4eUYRrJBJc0Uz4UQhnHSKM9OSr2Y7BraqwppLPbZ3iUD9dTj/n0t2V4mc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiJP8FQBcrGu++suUJyCssTMtyF/g4ajzbHlVf/Pp2F/TCf9yU
	j+Q53S5MmUihbvOAPkigFqhaZ1dl90iTuAqa+G/Y+LPryTbFmVkIqriayW0LwM0=
X-Google-Smtp-Source: AGHT+IE8nod63m/5RXrta+YpJQqaG3YPkY5+/q44EiQGD+6nDtI41YYUwLPx+yvQ/t0TsoamRCJlww==
X-Received: by 2002:a05:6a21:648c:b0:1cf:354e:93df with SMTP id adf61e73a8af0-1cf75ec5406mr2741834637.4.1726126784600;
        Thu, 12 Sep 2024 00:39:44 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:44 -0700 (PDT)
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
Subject: [PATCH v2 07/48] hw/watchdog: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:40 -0700
Message-Id: <20240912073921.453203-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard W.M. Jones <rjones@redhat.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/watchdog/watchdog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/watchdog/watchdog.c b/hw/watchdog/watchdog.c
index 955046161bf..d0ce3c4ac55 100644
--- a/hw/watchdog/watchdog.c
+++ b/hw/watchdog/watchdog.c
@@ -85,7 +85,7 @@ void watchdog_perform_action(void)
         break;
 
     default:
-        assert(0);
+        g_assert_not_reached();
     }
 }
 
-- 
2.39.2


