Return-Path: <kvm+bounces-26387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE6C19745C0
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:20:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0CA01C25929
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD98A1AED41;
	Tue, 10 Sep 2024 22:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zIIn/gEM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9855A1B150D
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006691; cv=none; b=sxWTiwDzyA9pclVV/ti8itcMiTzaLAYBTotBm4O0rzBOX0dkjlJuNjRq9gqgCLRKE6v4rFE7lcma4baYEa7i3pMD4JeLrRCi8SUmYSlccHESf56C5dvOquNj0GcQCOI/nbl2WsmDOYO3nwEZUQM9TGytiDw34MkrngGVzuntRdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006691; c=relaxed/simple;
	bh=U/hJ8AHDBxN4vbSkcUYneem7sLGkz/PxyrW5VkLEjPY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NzofjCRJuTAUOE+YzFDCuCElYVtXpwYMy1NWuzrCiEaQ3BcnrvxRW0LbJYsyzTy7zm5U8qp+gxcJvpKtrU8BC1Gkna8bkypzvNE12G32S4uy8Cg8g75RsLheh60jV+6/lp2V8BnLhmfNR/1Gr8/9Y2BfJWwwl+ILazHIuHcpeSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zIIn/gEM; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-718e6299191so2047548b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006689; x=1726611489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w3yhi+ZDTWCfsZmUwBuf/pfnGgC91a9e/gCoVrv3y5U=;
        b=zIIn/gEMSPl+NTeadxYcwIKFvNKGgbrFiBrs8TVpHIk3bpz65nHUiaOBEllR+md/9A
         NPUO9Uhe838GIIEMdE/aeA85nFW87z77r62w+2oKRT/FKXY4RKOeBTKHcTaKue1rRlEc
         VRGS9ufTpVjOTo9J4btzd4iMMe/PI7waUNVH3wMAys4N7vxTVMImJ4fKC4L0LQsN3ONW
         UKt6qHDuTfsmARyonZVOyvVks8fL+7k13ASYw535p49n90zO8ieI35qWtpfgDWZxl4XA
         yoIXyCfsOSRCGyKs4HXaRgcmZ18+lqCFNBHpNaOlSmmYE5EyT7/shNxJlDt7kuFTWe5N
         +WSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006689; x=1726611489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w3yhi+ZDTWCfsZmUwBuf/pfnGgC91a9e/gCoVrv3y5U=;
        b=LCf7gkxoy3EljOmvsfY6NOUj2DfKhlj3D1dw7IFMjlKi9T4k800UcNB/CMNMVv32F0
         dUGnxXULLu3XR9omf1tSOjoaS0o9CcZz6h8tkrSSn31qQUT39YdgjAVCm7BNZSCwdBgN
         1kCOxCzexBoQ3lLtcCgvBruICyK38oXDL+JjEreJ9jJOTaKMRb4L7x+Dh9Gx4WlahmyM
         bL4CMniyUDtgeAj2AK8oJJmtKQGG5R1G11PKmTkaDIHuFsiWx89oIaVGSGQHvrF4YsOC
         q9/lEDrp+yMt15XxMb5ErPuYXmk4nIQucbLrvHZvQZCFSaSNVK161ol8TDcBoz2QViWk
         fdqg==
X-Forwarded-Encrypted: i=1; AJvYcCV8pnPeHLPFGqtnfxJzEq7PW52zN95NaIYJSlF9mMpGGJFKstQTVlWum+ID6QRDpvJGmi8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2g6GyM5X9NWtPodnB6OGYt7G54j0tS3OV83nlHFY9vWYnb/BC
	SWHMHNYR81BJSHVnMcUQYg2lvwYgozeNSBei7KKRql27xkT4DzmY9LCfCVlPbu8=
X-Google-Smtp-Source: AGHT+IFWVQXCFJBuiwg4sJ6d5t1Y5jRczP6OzJP2N7AUafUaS1UpRZkOWeoH/e+NIJwWwR2fc3KdxA==
X-Received: by 2002:a05:6a00:218e:b0:717:9768:a4e7 with SMTP id d2e1a72fcca58-718d5ded0acmr15828847b3a.2.1726006688573;
        Tue, 10 Sep 2024 15:18:08 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:18:08 -0700 (PDT)
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
Subject: [PATCH 37/39] fpu: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:16:04 -0700
Message-Id: <20240910221606.1817478-38-pierrick.bouvier@linaro.org>
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
 fpu/softfloat-parts.c.inc | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fpu/softfloat-parts.c.inc b/fpu/softfloat-parts.c.inc
index a44649f4f4a..cc6e06b9761 100644
--- a/fpu/softfloat-parts.c.inc
+++ b/fpu/softfloat-parts.c.inc
@@ -1373,7 +1373,6 @@ static FloatPartsN *partsN(minmax)(FloatPartsN *a, FloatPartsN *b,
             break;
         default:
             g_assert_not_reached();
-            break;
         }
         switch (b->cls) {
         case float_class_normal:
@@ -1386,7 +1385,6 @@ static FloatPartsN *partsN(minmax)(FloatPartsN *a, FloatPartsN *b,
             break;
         default:
             g_assert_not_reached();
-            break;
         }
     }
 
-- 
2.39.2


