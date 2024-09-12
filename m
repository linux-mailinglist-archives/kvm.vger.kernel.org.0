Return-Path: <kvm+bounces-26630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30E2C9762F5
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:41:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A57611F24274
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8571190462;
	Thu, 12 Sep 2024 07:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PCBencC1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B571925BC
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126805; cv=none; b=Oy9S5omBBsV/8EvHT6Z4IW49GyfcfsQMmGTS6exTlw8b760I+qqtz/2DBtEGqU2kG5tPIYyle7IAl0dq02H94AszjH7AxeU5ni0bAsuiXVwfYRm3TPrcBG3QAXXSoxzE0uLaQMk8x1MBbqonj/MvZ1kikzvYRqdeXuPPnSwKMNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126805; c=relaxed/simple;
	bh=Tsn24Q2zqOITbsqWB26jmhxj+NilzFUR/Z5Y25b5X5o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZfE+lcqwb9UACyo6M5bEjK4yb4bu2UNwZG7RT9+CFzOgIg84tozjnFdSfgV3/vJPWWxBrO2eEk0Bp3Gn6BiXIs7VYELKDGBu6Ay96RAbTz7C+Xtc342wqe1UrzAaf0EVAz5s8IL0ucTu3blZE/P+sP9BMu/G/Vr272p6BClsCh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PCBencC1; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-718f4fd89e5so549283b3a.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126803; x=1726731603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfrMTIgk5Q+XEJO7A3FTmtoXD8cfHvhd3vsooDA9mV4=;
        b=PCBencC1I+Iys/e01Vp3XG9yQk3dn+QxHFRXgtcWfM9aR3jqyKd6kP6G4DDikQpSJl
         q7tbJsRx/3on5M8DRZz5Ivq/wvasclRzhVVtrAHnGYhLsxkTebYR2YK5qH4dT9VPNjYa
         Dk6yQ6z4PjpiWy61EsTkNlfR5L4WUnCTHEe6vIoVUeNxMXPeF05T0j7O7rSwGexH6JVj
         9yqpsZouxmbXDPoSXvFjBoew40mwBjnsbX7q+aLjW4qS5wJ429yNluaueDcuOxjeN/1H
         rBJKL+XLmFU32LAzUe+gI2iEBt3BQXqyEODsUlXakYfJ/gZNZLBnLmDwhvI2MVpx+z4T
         VxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126803; x=1726731603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cfrMTIgk5Q+XEJO7A3FTmtoXD8cfHvhd3vsooDA9mV4=;
        b=wjcv6Hw47CwgygnWQD9+8vTyiLFscKGaQPNzeacuLy+eHavfoI+3WOCN0boIHb7lbj
         7IUtA/9nuazM2UHyXB8ekDsKD4t9+cdj//qiyFgiH31Z/7+MHCRcrhjhLrpocHjPH77i
         hnZ1UV+L5qT6V4A/1Dm0kv+/a6CmncMZz7mU+Vyb0F1oRH3RFQJ7dG6U9rhe7l2XNcYe
         HRneh/U6Tvm3I6zN5FHiNxb0QXpZV3YesX/69w/gY6g6CHA38pEHAjjIXQCe6hd73reT
         ip/8QMhFhEQeVrjXKTSj+4xyMIvrwP9lfSOXfFfWXHOC9gNblkTYTdFon0AVcGRbMM0V
         MAZg==
X-Forwarded-Encrypted: i=1; AJvYcCXUKecJK4biT96zDFiGJkE3kajj5cN8MpzKEGzMB+jdwsnT15zGS/u5DouTIFnhwc/I+Hw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfmRIhJMisrLqDSmCZvufsryeSG22LR88s+Gy52+E7ESa/3kPa
	qNSp+xbG2GrVyPH2zOk+zQe8VJ4nOAdNQ8QYfoSnaqlOgljN8nrAqDSnedGaSoM=
X-Google-Smtp-Source: AGHT+IHWOaE7dY6tBiE9Ghckw7hSP0fZD+0ZwcWT4soLCd5pY4NREymaum+9biUNdbtqFJkCdDcI4A==
X-Received: by 2002:a05:6a20:8420:b0:1cf:d745:d641 with SMTP id adf61e73a8af0-1cfd745d677mr1281589637.18.1726126802834;
        Thu, 12 Sep 2024 00:40:02 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:02 -0700 (PDT)
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
Subject: [PATCH v2 14/48] include/hw/s390x: replace assert(false) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:47 -0700
Message-Id: <20240912073921.453203-15-pierrick.bouvier@linaro.org>
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/hw/s390x/cpu-topology.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index a11b1baa77b..9283c948e3a 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -57,7 +57,7 @@ static inline void s390_topology_setup_cpu(MachineState *ms,
 static inline void s390_topology_reset(void)
 {
     /* Unreachable, CPU topology not implemented for TCG */
-    assert(false);
+    g_assert_not_reached();
 }
 #endif
 
-- 
2.39.2


