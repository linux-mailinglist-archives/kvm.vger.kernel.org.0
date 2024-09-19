Return-Path: <kvm+bounces-27142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C01C97C391
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:49:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F3DB1C22699
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F5657CA6;
	Thu, 19 Sep 2024 04:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cL8NI6AZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8356055885
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721249; cv=none; b=US7t6piiL3rM8usNjWioq49p1u9Yv420bAZBrDSRe5lUtuS4ibc8Q96hg+WjapCzEhIPvSKKCT2fVfycEvnR1uhfSn0Y6g/hNgzRQI6hl21SsCDSYG/vz1bMP+jRs2ZD2tkMl99nea0aXLWo9NXuNEuTxtW2L5OuqU8rWO/InUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721249; c=relaxed/simple;
	bh=UxMxgMmU6rXl5QkO71lpCL3jaK/IWI74zWJB0msEGQ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mHYHOObyPYHp4KxBUoBONvGQ1F6UNVI46gspNiqFPSN34miyL4GW6BfY5mvqZAbeM6qL/qAIFSWE0rc03aW3u2dMqr8HxSzIkmijbmtFeDKvGKjwqK5ZPg9oAdjusVHDqdYpAgZ9z8hZG2HBoTeuD+Bgc85iqHamhDXbJB/UL6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cL8NI6AZ; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-718e3c98b5aso280390b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721248; x=1727326048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOTDlymCoYoChOB3X8FuVGmcdRWIYVQOru1+/fCCr8A=;
        b=cL8NI6AZ2BDA0PPt1yrrjcYCSGmSg9K2EshlsDMMduo8HNGh3IHrvGSFn5ULRXXnOT
         kyk97dfKR7y9hYSRYYuNoVnqxJW6R3U1vqwQ2Lr7lLNkB8rN/hOeB//cmAmjqi8kiHXd
         vqv00HHxGAZBHKZwrZ0jGjODYTeLTJYqfN5rW0prEJlTQE9C9trvnuSPIC94PyEa6zMc
         fH2+eExSNOW6mt+vo03DU47T5DOJPX6Va2Gz4YlZyyvyzUV72Pg0kaTBHSZs6umy4AeO
         q6PL5Yzfkl1KSh2Sfz+PeEsndgTWim/NfWRUfpI3/IE6+f1ZAerw4k7ya+0vd8aLVAsp
         vq+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721248; x=1727326048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOTDlymCoYoChOB3X8FuVGmcdRWIYVQOru1+/fCCr8A=;
        b=X4VFfRaMmiM6on7Zo7sMi6txJar5I7j/wrFXszVgs1WgzZTSC93y51+JH03yi6Gh8M
         3ln9/gLoMHmiMaTdDlLUb+Qx8WmHXPrwXXLCeN9Qd6nonTux9Irca8cVO93lOGXk/+7w
         0Apv67cuyOnwAVgXAjqwCfz6ZPIk7QYpe5dyM/Sd8o78sufkyQM8STppq8YFYUZ5okN9
         dw+mr7//9dVlg7/y2L+i/25vhaZoWfaBZmBXtn269ocIKvoRJP4JoffqMHVckOs9wbPt
         a88GdH5RyPZYwJvw/vbKJem2RuXycPWiaKLGOjLqrbHjUmg1WHAUT4IaR5HGvm3NwaiD
         tOSw==
X-Forwarded-Encrypted: i=1; AJvYcCUJlZzSka700KYyF8u9HfD3Gwb7nE6BgvkgbSs61R1jug8Su+40y7d8dSMA3jB1rhkW+wE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4bO48U3CUwPZcopRN4yQeEb4RUeO3J8VSp91XLXxsjGkvGWDL
	78l8YdJJbnd/iNH1I2wnEe0c/YbJKr1Nb3UiKgGPBMXRownlHtShhd+FnJu457w=
X-Google-Smtp-Source: AGHT+IF4VdR408ElGh9vDAVjdbcMP3qqXEsAp/0wcOEvsQ0+y71/UwITZuPKa7pIAYx77zAYCo1WvA==
X-Received: by 2002:a05:6a21:2d86:b0:1cf:5437:e768 with SMTP id adf61e73a8af0-1cf75d7fe57mr34834771637.7.1726721247872;
        Wed, 18 Sep 2024 21:47:27 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:27 -0700 (PDT)
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
Subject: [PATCH v3 21/34] target/arm: remove break after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:28 -0700
Message-Id: <20240919044641.386068-22-pierrick.bouvier@linaro.org>
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
 target/arm/hyp_gdbstub.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/target/arm/hyp_gdbstub.c b/target/arm/hyp_gdbstub.c
index f120d55caab..1e861263b3d 100644
--- a/target/arm/hyp_gdbstub.c
+++ b/target/arm/hyp_gdbstub.c
@@ -158,7 +158,6 @@ int insert_hw_watchpoint(target_ulong addr, target_ulong len, int type)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
     if (len <= 8) {
         /* we align the address and set the bits in BAS */
-- 
2.39.5


