Return-Path: <kvm+bounces-26364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A7EE974594
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F83628BECA
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F048B1AED29;
	Tue, 10 Sep 2024 22:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FazGGGC8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5591AE87A
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006605; cv=none; b=QrGR2DbIN3B4TgFnDXHut1vDZAJwAj88FInXaWsA8Mge2un7udVmxsBWwjMloJXVgO/xcTDLHnuWxVYPRWuCMDAebJI5x/vP3WOAIBnuks5RdKVqsVhxz7rSLXIertAt+jDOMAA5UI0WsOveKVskHlvohBKV8nb3LvFz4gNY+qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006605; c=relaxed/simple;
	bh=zQsvt4n4V9EW0EOzDeA+30dv9n5pC1zHFw/Nv6RfpbA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pL2pnt8jKZ9fdUuhN/vw4q9bfI7/KHCbWEcKgguJPjbyGzA3ubZBOOI85WFxuwtFai8XhkgcVfdIm2VUu5pHxutP8m17dJ7l2yMLgK20rVmIf5GD37h19ZrlUTv48VrO8wc/G+mGjafy6UPwY5EL7Xii1RGv4S8Xqdh1tNBuOic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FazGGGC8; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-6bce380eb96so3759282a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006603; x=1726611403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iYkzieYJP14CnD0ztJrOrrQh8wNVhd37zVufqRq95Wk=;
        b=FazGGGC8hyY55fi16EtKYSX0x65vyctlrjR7zx/jnZdcA7kcXgEe8ZIDw1RXFfWv6e
         8AlolfLKGVHm2G/ny8R9dR6/oKVyBU82rANJlRMKYpAGbi3llaT+cUwH25wFG46E0IfA
         CXqhfIvDP6ZOBC3NvXG8LY54Krbp21F0T/UHGVbp2bgxdkiq1os2RZGnIdydeHj5kEWu
         ZgvD1N4fpCb6+Z285520NlgYloLsr77uoGjzP+qoZ9fMx1nudKVKAfUP7MTCRiWltz4r
         x2n4hgc89FUJFL0ZifkCDdbbl5L6HQmAuD1JuNBi6/Ugl09CBPsIqsKs/3R6kWlu7xV4
         YtNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006603; x=1726611403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iYkzieYJP14CnD0ztJrOrrQh8wNVhd37zVufqRq95Wk=;
        b=euCKrjYXut33w5u0ZGiyAYaz2InrTMsXReppjxyaCs2Z7aQUYQjq1/bga641wkZfwt
         uULY0QWE9urp6pZYIRPNyhKzs90JKKqPQJaecreNvdOPxOL8MltCQsu3hKEvItNn2cxw
         yJXkdd6i37SumbMH1tNQ1HVfvNRWuXjrKbcmo804UCO0z9+qyDZBumqZrkLpwfcDOPdB
         3mE0WW7FezEGrj14qXpug6WLi2OYEQJagwQXOM6+xyDcas/MeA7RWAOQwnYSzqjFpAnT
         QQPpU735zERFyn29stuajkpU4ZEpvQROg/zON6x8GaYabspPhV8Wm/yOr1+Ix2LvFbHw
         s85w==
X-Forwarded-Encrypted: i=1; AJvYcCXyNfarLIBwJG61xKpKAIGVpqlNaMtluz2t64Y2GeuUc/UW6hAtxdRsUltOKop7oBG7f5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWqKqlte5+5ZoOxz/kV5Q41gfeE/NSH0n4ij5xA7ImBBzPPAn9
	5qVFWNBD0cYe/v2zMs/Ue2Kj1vGk8JYLVtMqVFOulo0eGr6KAs9oNyVx/bdw3vw=
X-Google-Smtp-Source: AGHT+IHKXs1YiNP1OusG1gOCeK6/p++op+cHmYKzQLej9YXDjOXxCcnGSzx+XKVm5NrT1vtmlbfLhg==
X-Received: by 2002:a05:6a20:d525:b0:1cf:58e3:2d1 with SMTP id adf61e73a8af0-1cf5e197fecmr2959596637.47.1726006603120;
        Tue, 10 Sep 2024 15:16:43 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:42 -0700 (PDT)
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
Subject: [PATCH 14/39] include/hw/s390x: replace assert(false) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:41 -0700
Message-Id: <20240910221606.1817478-15-pierrick.bouvier@linaro.org>
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
 include/hw/s390x/cpu-topology.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index c064f427e94..dcb25956a64 100644
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


