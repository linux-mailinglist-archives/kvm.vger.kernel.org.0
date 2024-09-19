Return-Path: <kvm+bounces-27154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 568A397C3A3
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A661AB218F7
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4EF13B286;
	Thu, 19 Sep 2024 04:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W1uHyWQX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA7913A878
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721273; cv=none; b=ePmLGGhvfqS7n6rsyB+4K40zsWwnoRJVKjnRMcukNb0QQzwyfkibvxpmGLu3kF+Pj8S+kOSBhfOQ6gmpIuVilc0jhRPGm6ftalpqUHTQEWgwQu3JN5S0a9YzHOFv3M1bPGQEITFp04sPzibniLVi8u/MJvj6826X9zfqS6XSOek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721273; c=relaxed/simple;
	bh=U5fjiVedkYeOh6w1Ljorg2MNfMmdU45BnzLBKfMi88A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LUxe+fFw2TA8yIx2KGYFew/73hwCK+pCtb431wH4dzLr+HfqPeS6cIoOkjP3GcJJ/GSRkLqYTdUZikFXb/2zcymV3ezSZPj91gkdhIPsIwdhf+VdGbVEySYZ5EfPSexZU+oOpVH/w+TFh4c+0SbV36f+i8pJJo0nJKPZZrXig3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W1uHyWQX; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-718d91eef2eso279126b3a.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721272; x=1727326072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/nGORvbHJ+qdXbStyLX4ZDxj18G9D+mDlGJ72uSFPz4=;
        b=W1uHyWQXy7HZZfyXEVz5v8y62St0PVxq1qbTjw6J/TIwMS4YMvTmq8jB3NF9zK0YKV
         6Fnyp6iUPHuHvmUF27I+yYSmQmjlv2NezeeXrOWA4cAXb7dgQSmeqGRaAxLR1W6CUEQb
         KNVea3JxgVaNP6g54qdFTo1PjqsQiXSjRywle6nitaIjK3vccpOWaYrkw5oZuhk6O5yR
         u+WF+WhZuWZ1o0B9K3po571FLHD2CFmB1jWwMfCwXeWRSFmdB1fVmnpMSNMJXzNH0JeB
         XqaAMIvd1VFKlp93u+Y5iA669Dz1sxAe7bBAcfEIAWsK5fVfJZvtEIiiXpkNTO48+TEi
         tCpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721272; x=1727326072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/nGORvbHJ+qdXbStyLX4ZDxj18G9D+mDlGJ72uSFPz4=;
        b=eB8I5mqBb7J0x/R4Tz8ggsAXIiZjM4rdmGZ7hzL7w7EYq+Takvw3CQLkioLYug13JD
         +NLp2Jxmp7J2yrKGXiIjL9uOPevX28Ubu5fRsAfwRPsJNjb135E8VBQO7RAgN6HBvYKe
         00zgtzhngewIwfc3fg7mIc6Jj125yP3ztjeMiLTmL39JzogwPwK2oEDf/w38ed1SeDOn
         x24vgB1/bSUluter03Iq+9ZPk6Igrne31eBGNbWjAc2McnNUVEbuTTi73VTD+z3ugtJ/
         I9ei7/M7Zp/1vZAS0XpELkFW0X6RcmjGZFaGPPcSMJpmH7jeSm+gHIxXLpbAafigIeB8
         gbtA==
X-Forwarded-Encrypted: i=1; AJvYcCUKCwjIPzmbiV0LcOF20O0GX7AjRnux+JVTBaxxViwWgRdA51Tn3h+68zwIGQ0emOu2E+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjbH7w6zSdzkEGRDyacS3NaMF0YvmmAMxc3E9MOHpH/JYhdbzZ
	65M6F+phOHRxI73XEeQ+qdSjlM/kocUHGRFeFZW3RspeqKD9U+bvmq0nbEC6OsI=
X-Google-Smtp-Source: AGHT+IEDg2pn0QyAuvoiOwCdHYylFwrCXGUqq3XEUUTIp+6S2LNPDo0LRqpJhUmVkaR/AJ8UyQGZ3g==
X-Received: by 2002:a05:6a00:1885:b0:708:41c4:8849 with SMTP id d2e1a72fcca58-7198e2c832dmr2743657b3a.9.1726721271832;
        Wed, 18 Sep 2024 21:47:51 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:51 -0700 (PDT)
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
Subject: [PATCH v3 33/34] tests/qtest: remove return after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:40 -0700
Message-Id: <20240919044641.386068-34-pierrick.bouvier@linaro.org>
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
2.39.5


