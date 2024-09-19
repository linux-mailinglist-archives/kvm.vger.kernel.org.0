Return-Path: <kvm+bounces-27151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5033A97C39D
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D62E01F2355D
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7581386DF;
	Thu, 19 Sep 2024 04:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="boyG8oOA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A1C839F7
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721268; cv=none; b=epbCDhiLvNjdC5+izgTOzS0+MXmJb7Ug25jRknrcMAia5Shjsctvs2hr/sxr0kMiov51tdYhis61zfXdP4jSBTayRIEWRz/UkTLHjYrq2FpYmfTZxvk9Wd+4e+HNMCRG9YNu6lRARpymdFcdtgXtXYFSQDenUoQ4iwCtzOCJ3ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721268; c=relaxed/simple;
	bh=uTz0auK1I+RUbKfAt7P2FPVRTqZni3nijk17xT3fNmM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K2lpfp7Jm4YwikAdWnfY3f2qfwpWSXzRTCfWtpTrZJVePaUFCaFLhlnhNDBWcMggtfLbA/XQswmGaP4O8I+oibccZNSqSIVera2IYPeAPLtmtDJaoNhCtNLplhBjjFRF7mEwtR3x+0qae9Of/zQ6+FUUoQ5oGV+0x0F7W9UKLtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=boyG8oOA; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7d50e865b7aso308911a12.0
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721266; x=1727326066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozWlgV20eXCZ0c9b/13N/LAwE/BLpMMoDcMJfurfVNw=;
        b=boyG8oOA/aOyIJnhxBhZ4rFvfyVXlltScc+acefImb/T0L/HVyn2LcG8Mi/F56AvOf
         atNvZtb5v27aStHzR8eMS05lC9FsyS3ymoo2/9AxeuGWipz6FqT/Jvsi+Ad2NtVp4k8a
         zuCr3nSD7QQa9sU8LU/IfmXXu1gprw5rC81G+9jims5llZeoRqKasIstu4XhtoL8QW2B
         D1Z+jt7ufhAvn3eNPWSbc2WcUwo5ksTgHJjgAoUrtjm0/pHtPm+bqBpeCN7d4Mlfxxdp
         BYcfs+wo6a95dWjUYQeMT0ir7M4jLvHVbnJlmFjbHdDHJw1ypzEFHyNDQylABPnggpiL
         282g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721266; x=1727326066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ozWlgV20eXCZ0c9b/13N/LAwE/BLpMMoDcMJfurfVNw=;
        b=J0X8HGQ+fkxKzCCxiwJEjVy/H1nkVNpIuiggMYdVSCgw+pl6f412IULRxjZ423NUQ8
         7uSBIkjiOht87MHdw/wtT7hy74cAYlGzP8h9OxG8Xrli+HGguPANrMGxi+uTzE6cZcR7
         24CU7Yq33vHYivl9wt42dstEQMRkVDRBOW2eI1bRDYX9KL3fgtTJmgEUIHixopbiJQde
         5Jo7L+Lm4K9V73MQ1n5abufsDeHhWSYFMWPnrZzdIma8tzVMmEseOwF5fNoxsIb1ixQ+
         TPMjyfjVPMD3NHrhVkjXqwrGyD4/4wjfS7BP7eK+8Uw/oHdbwQMAzOVm+43zjowd7xdw
         2SoA==
X-Forwarded-Encrypted: i=1; AJvYcCVbPk5LYd/i5j4c9hCXs/hiEU152odc/ZFqSEeTVfvA5GndNKDCGBRLdBHEYCVNy+jn5vE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJdvj+/N5KIkXmVbx0UfPUDdShaaYJ75pop86sLS5uulut/ssh
	TXr+dIr02xXeqMbkyqLO3La4vBeBdTA82EMfQ659U2Gx3q54cc/+vupEBvXuAW8=
X-Google-Smtp-Source: AGHT+IHsHP2GkF8PiOM9Z52fH8cAj4VN2oMaI0BFSJQoP5lyLdMB2INYK+7wocFS7jMYdV3UCDnxug==
X-Received: by 2002:a05:6a21:38d:b0:1d2:e945:77c4 with SMTP id adf61e73a8af0-1d2e94578b5mr9976706637.2.1726721266025;
        Wed, 18 Sep 2024 21:47:46 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:45 -0700 (PDT)
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
Subject: [PATCH v3 30/34] migration: remove return after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:37 -0700
Message-Id: <20240919044641.386068-31-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 migration/dirtyrate.c    | 1 -
 migration/postcopy-ram.c | 7 -------
 migration/ram.c          | 2 --
 3 files changed, 10 deletions(-)

diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index c03b13b624f..5478d58de36 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -229,7 +229,6 @@ static int time_unit_to_power(TimeUnit time_unit)
         return -3;
     default:
         g_assert_not_reached();
-        return 0;
     }
 }
 
diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
index f431bbc0d4f..0fe9d83d44a 100644
--- a/migration/postcopy-ram.c
+++ b/migration/postcopy-ram.c
@@ -1412,40 +1412,34 @@ int postcopy_ram_incoming_init(MigrationIncomingState *mis)
 int postcopy_ram_incoming_cleanup(MigrationIncomingState *mis)
 {
     g_assert_not_reached();
-    return -1;
 }
 
 int postcopy_ram_prepare_discard(MigrationIncomingState *mis)
 {
     g_assert_not_reached();
-    return -1;
 }
 
 int postcopy_request_shared_page(struct PostCopyFD *pcfd, RAMBlock *rb,
                                  uint64_t client_addr, uint64_t rb_offset)
 {
     g_assert_not_reached();
-    return -1;
 }
 
 int postcopy_ram_incoming_setup(MigrationIncomingState *mis)
 {
     g_assert_not_reached();
-    return -1;
 }
 
 int postcopy_place_page(MigrationIncomingState *mis, void *host, void *from,
                         RAMBlock *rb)
 {
     g_assert_not_reached();
-    return -1;
 }
 
 int postcopy_place_page_zero(MigrationIncomingState *mis, void *host,
                         RAMBlock *rb)
 {
     g_assert_not_reached();
-    return -1;
 }
 
 int postcopy_wake_shared(struct PostCopyFD *pcfd,
@@ -1453,7 +1447,6 @@ int postcopy_wake_shared(struct PostCopyFD *pcfd,
                          RAMBlock *rb)
 {
     g_assert_not_reached();
-    return -1;
 }
 #endif
 
diff --git a/migration/ram.c b/migration/ram.c
index 0aa5d347439..81eda2736a9 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -1766,13 +1766,11 @@ bool ram_write_tracking_available(void)
 bool ram_write_tracking_compatible(void)
 {
     g_assert_not_reached();
-    return false;
 }
 
 int ram_write_tracking_start(void)
 {
     g_assert_not_reached();
-    return -1;
 }
 
 void ram_write_tracking_stop(void)
-- 
2.39.5


