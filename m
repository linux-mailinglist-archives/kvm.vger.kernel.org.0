Return-Path: <kvm+bounces-27122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D32C97C36E
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E82A7283AC2
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0726D1C683;
	Thu, 19 Sep 2024 04:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ke9j1pCH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD5217740
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721211; cv=none; b=kWvJAtNL4ASfA9nvrzo0SY4VOwriL+AJxaM5vBM5DKQmtuYX7EfTM8JRZW40RWWNxV3sd2pwgV4kgOA8V27Pr5HAkAPTFH9CeXLYLDEodtSTC+OTIIPGT6O0DQnJbv0msONIEY0Z+zqVY6ocSkVFMYSols8ouj9jZilvJBsslXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721211; c=relaxed/simple;
	bh=IoqNRBXFy/wI6A8Da5gsnsZfUt5toPKUe8IBwqqaRvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IEXCktFlnY9Vgdg6WJ/sA0E1jPTQiI/pxKkbjKMCO18sgTX1fCGOZg5E7NLe27seXVtkccogKSErLt640Nz8EYBmthealG9pSQq/ZFr1xB4zRH7THI9yedmK5QHk2nl7/4Jehd/YeuxDI7yiM4c8PyqLYCcTLOhk/Vq3l5h9hDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ke9j1pCH; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-71979bf5e7aso286032b3a.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721209; x=1727326009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKE/FaSnwekzuSHN/DiZj4HlusD3QhW4e3YSU1WvaKE=;
        b=Ke9j1pCHAbOOkWfKFaULH9CT3c8K3sUuL/Fik0s1tEB7HkZdVvupwS8e6JKn2rvlxG
         hP5prvJHCg8iaONy/iGhxGcXZ6hGuNeyleABGpz5ufc058UMd7Y/m0bqDWssvzR1P3Wb
         0YuIu60fjELswIuaZMwJhjOdliZGFA/rY3ZJDQhq7bzcg9MqyoyHW1e0CczQhWO2q8Ou
         3wQjE/QVlCnTMkM51AL8CrzKZ4kPVrhaO/JOLGRPIFpjZgB1b0clyZmu8buCtpNqBzxQ
         Q3ukv1kyQiVZFbCf+0uS7hQkDUruMvW47Xc9Y+PHN3OmkgJAQOSd05GNzMoEtCaxys/+
         xyaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721209; x=1727326009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKE/FaSnwekzuSHN/DiZj4HlusD3QhW4e3YSU1WvaKE=;
        b=ah5dauXuNb/vQPJ0DOIVsTmHloJj78mHsMeNQtAfDVpD/NhACOcQrKpj5CODMOzPOE
         J9NS5g4OVv0kEz7HdHe0/UI43+lYqndG4XJwGlRGyweajcoMunO0bq+dN+rLQdcGXQ40
         3e11bfPxcjIUJxr4Mlv4+2opNy7pcqKIzLHirFK+XE4MNvDReZIwhArq1Zk33lmNsiJO
         jaav5dZRbAzRvxAudQx961nQYhZ5aAuBawXwOmfisLXL0TAZkP4/b5DMpew/7xG8CaP8
         gvqS3SJYCs7DVqFyYIqFViWGaKXYgV+0t/58xjHn5vW1teYdV562x8RxqhGDOUtQbxp9
         OfFw==
X-Forwarded-Encrypted: i=1; AJvYcCX7DopVSJfmAsP01RvNSgYMhVKKJ6TmEhRt9MrnELsbveM93OTs/ANr2SOUKF6P33ES7fs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf2q34gjs08rthfu/5sBKPMmoZhAKa6zRyp59Y1arO/YrbVkvf
	bAtfkhI1dKNs57tfcAWE+J4OQSNFduIAEomSWVHBGsqEKQPUr7tzZ/IW3mwu4o4=
X-Google-Smtp-Source: AGHT+IFSLpGq1tdAK7kcH0oPXH2ipnr8o9jAFjv4J5HFm8vaiwaqPv2XJ4VGf5F1OUzUb1F//zn0vg==
X-Received: by 2002:a05:6a00:2389:b0:70e:8e3a:10ee with SMTP id d2e1a72fcca58-719261d9b0dmr36234028b3a.21.1726721208838;
        Wed, 18 Sep 2024 21:46:48 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:46:48 -0700 (PDT)
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
Subject: [PATCH v3 01/34] hw/acpi: replace assert(0) with g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:08 -0700
Message-Id: <20240919044641.386068-2-pierrick.bouvier@linaro.org>
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
 hw/acpi/aml-build.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index 6d4517cfbe3..006c506a375 100644
--- a/hw/acpi/aml-build.c
+++ b/hw/acpi/aml-build.c
@@ -534,7 +534,7 @@ void aml_append(Aml *parent_ctx, Aml *child)
     case AML_NO_OPCODE:
         break;
     default:
-        assert(0);
+        g_assert_not_reached();
         break;
     }
     build_append_array(parent_ctx->buf, buf);
-- 
2.39.5


