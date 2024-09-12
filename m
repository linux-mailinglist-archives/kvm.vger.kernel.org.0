Return-Path: <kvm+bounces-26637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CC41976302
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61BD61C22257
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B4319CC0E;
	Thu, 12 Sep 2024 07:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZtOogOfz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B2C19C546
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126824; cv=none; b=EzjwgkU+bMWCYSaeXTPxoY1VFfH/CWG4yQoB9jGjnkDFyjwTi9U5Au67HZRfdzEFgv9WWma5CjsNiHQ3u+qrwnxdY2b2QbXZzAcuV46yt7iAeSnh76Eo+Vo4pWxoHrG1mXFRqGS+06CKFpIFquw4c7sZD75jsp9s8tOJf9Hj/uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126824; c=relaxed/simple;
	bh=Zy+NNmqLkllb7WFjw7V2Ohgl5LvRWnkwSMJaELSfqSE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OKtO8BstEknD7I9/XyqwGQ1nc0jF1M50upR9eBUlxgPE8cvJu2famz1ddOVbIxxOH8O0U+k1s84f3Hj5GE1Ag/5QKAX7n1xoYiVSCjx7AXWVZjiMTbeIcYqSVGstWWerBxd9ViTecmnBmyKuME/5mYN3KgV9x4SgyYHa0c0APq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZtOogOfz; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7db1f13b14aso632958a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126822; x=1726731622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAqUDAXH2RLxvOYkCD7ynjvzkI7+hLAzyNaEnllXZKU=;
        b=ZtOogOfz0shZDvCxt+Hyy8luAz7xt4uCoD8hn6sgVQOTCxMTQe1pd99PHCL5Xl3nrs
         JGs0MpuHpU0DjFAWrXyollQ6fgsTJ+9pAXsohnzwNXGIioJyRlnpXmnDWiVF8IBMTzti
         Ktli1ZB8d1YTwmJeLFFegdfv2TXEBKeHEF45RTtVk5S89OIYSc31G/zBJ4kIsG0JAkXb
         0jSAniQ8fL3gf8Y+XcNe9TMnMxebgZdxtRT1MuioXxxdcjMe/F5dMK2JOG+jnHAOSfAD
         CTu786aEpmjCOL0RacSmk5HVhG+4Jmt7HxC0P+csjZkBVXl0p50uD+URh1oJ64ptoL8/
         yBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126822; x=1726731622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAqUDAXH2RLxvOYkCD7ynjvzkI7+hLAzyNaEnllXZKU=;
        b=TESvvm3euw9Q9D48PKoZrK1vkeSLREWb8w5hCDudFBRjnjnLeECio30nRxPOFDIhsC
         HKDrjKLolanYeUYIRqaldnKBho3khBy2AgjhbS3gnnpdZ0fBuBryMlntl10Nm0n81+M3
         hqHarW85JekWGeruBRFWgoGcu3l1nBaeONiBoON2BQtfDDUIDuoLnTZpm5lxvWyZeA/8
         SAZOrtcoOD3B6YiP34la3jlgJAA2ynFpRTKsWY1mpHlFy9Z6aNo4YZ5vXS/hoznRFUjE
         n+fe54ButoTGkqCGf+xgxpIRT4dHx+XUAePprhmVZsrBD4djgdthcCeTk0l7OFEgi/qy
         IHlg==
X-Forwarded-Encrypted: i=1; AJvYcCXJ/c9aNjsKdGZUe+vbxEVEsIPt6CdZx6k9n6CaaiMXg6CdMiHJ7jYQb5mFG5mIZnWPzDw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYsrZ8IkT8MbE19PI72yeu2mvDABHdTwOxPwLycE3HXhBPvlQ0
	SFKBHOu913kA2fJY4EAraXOL2JexsVDSqeBVr9DsGw5kQ3Ga3PmCbiyILkTgbso=
X-Google-Smtp-Source: AGHT+IE8CKjJgw0N7WrqC34he8rsJ6HMZ4DWnrxVglrTgBMS33CPmFB26J4BB54F9WE+apv1XwnjUQ==
X-Received: by 2002:a05:6a21:3982:b0:1cf:2931:727f with SMTP id adf61e73a8af0-1cf75f005demr2867169637.18.1726126822148;
        Thu, 12 Sep 2024 00:40:22 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:21 -0700 (PDT)
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
Subject: [PATCH v2 21/48] migration: replace assert(false) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:54 -0700
Message-Id: <20240912073921.453203-22-pierrick.bouvier@linaro.org>
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

Reviewed-by: Fabiano Rosas <farosas@suse.de>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 migration/dirtyrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index 1d9db812990..c03b13b624f 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -228,7 +228,7 @@ static int time_unit_to_power(TimeUnit time_unit)
     case TIME_UNIT_MILLISECOND:
         return -3;
     default:
-        assert(false); /* unreachable */
+        g_assert_not_reached();
         return 0;
     }
 }
-- 
2.39.2


