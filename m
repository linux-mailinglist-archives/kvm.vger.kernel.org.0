Return-Path: <kvm+bounces-26621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A95C9762E5
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CDE31C226E1
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E031917C0;
	Thu, 12 Sep 2024 07:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e9qH+d9Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9490C191494
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126781; cv=none; b=jRKssODO2+LFuD/B5bXClxVrPDOj4fr4g0+E6OEC0et5iu2neggFLr7VKNmdL3etvTDU1NlYQkgO7D/Qsi43kEqPlvB+dnos439NGEv/5xf9XtwKBd95X7/fy/S9+loAiDoWX1H/PacADoZJqaTUh4rWBKzIWiijHEcNkeJ+meo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126781; c=relaxed/simple;
	bh=zzR5V7UsJxbXcCEbgxsNTaIMw4zZwjNRz5mG2S5uCN8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MUnSmjVYetM6rwONOGTaK7rKenEmNdqxT4vzH/k3Aw9yMMF/AVpRH4lFS6y0Jt05yrWCnE9eQi10OSvxwmrdIFZ81l8a3ApVBOqI4vHI1W7XqrxIUYv4/mbWdiG9lZN7SdF5qO7jqoLuPb4AIbnbi6lLR5rEn+8fTede012x9H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e9qH+d9Z; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7191ee537cbso486247b3a.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126779; x=1726731579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fLMdbuNc1S53EAbOcoLtqlHcp4TS6A8Qk4ILSrig2co=;
        b=e9qH+d9ZpLyF+RitrQK//ujOX9juiQGSgIa07Vvk5QXh+4KRxgZ3wzAwsleHr1fnpm
         TnhbNBxpLlkS0Upcucq9tK+QyR/22aHJPfnjGwmEQjWu1CDEyGhsZ9I+0kGXHxgBxRHP
         seIVLCcFJsAyCigK3gchf9GP5IfQzLDNTaEYB+sU+v/HeE3B0F0tfi+JB+ZoHce/POxV
         dpIVGUvife2rdmPE3r0IWg3huhcNkCtrPjQ8hkbDtUjJQsC7kskj7Y7w5Mcil8UgZPVu
         28L/Vm5sDRwPcSS2HnX8xgt/Y3jsATDw3pwomCggP4x1LVWaAr/RnI+1PR/v4UFU5DPh
         PWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126779; x=1726731579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fLMdbuNc1S53EAbOcoLtqlHcp4TS6A8Qk4ILSrig2co=;
        b=wraRlrENyA46uAYJ2BUC/VaAKLjeg8sViG+e2cV17CA3tMKrSPSVAyyhmjw8B/i1vr
         K3qF2cabwd3P2gJk6RyD8LQZ31k/Q+qSWoB/lxehCnZjN9reewkNiPOtt5XIBuiEyAtg
         c2tPq3AidR1rqBYbV8B59SFkxVIkfolUn7eeo7Ldwbnm1C/qu/os4aAunRomVDhZ5Ye4
         Rl8t65pwJ/qfRJdli5c89NYBHCaiS9UA7m2IcOOCd2UZwQEZTt7q2/PAx9r3ijU0lHiG
         fB1AKFw1vJQcn2VvewHIrIbJ8jAVfkX4jzpJcFshIyYUBSZ+bYFxPtfT2AAB2sf+MZc+
         d52g==
X-Forwarded-Encrypted: i=1; AJvYcCVaf3ROrQQjOUUJ1GwbQLg/X1LSo0i/9PlG2uidE6PPBeMOBysBQRsPL1pucjX0o4TGDlk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdmUlTW8nioUB9Mkb6ijuorpyq1Htau/iK3fD9WJqxzS7Cj96D
	rAd4aTe+5XWFKrVt5K6pSKVlh043/xxNeD5wGah7GhU/vesjTMJP/B9l4VxIBRA=
X-Google-Smtp-Source: AGHT+IGsYfpgGMtUkJQV3ZoeaZnVF1kzOMAI4k+7EcIVricIQ5VNOKh5dVOAemjBCE1kuSKrF+5BOQ==
X-Received: by 2002:a05:6a00:1883:b0:706:58ef:613 with SMTP id d2e1a72fcca58-719262066efmr3042407b3a.27.1726126778888;
        Thu, 12 Sep 2024 00:39:38 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:38 -0700 (PDT)
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
Subject: [PATCH v2 05/48] hw/core: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:38 -0700
Message-Id: <20240912073921.453203-6-pierrick.bouvier@linaro.org>
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
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/core/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/core/numa.c b/hw/core/numa.c
index fb81c1ed51b..1b5f44baeac 100644
--- a/hw/core/numa.c
+++ b/hw/core/numa.c
@@ -380,7 +380,7 @@ void parse_numa_hmat_lb(NumaState *numa_state, NumaHmatLBOptions *node,
         }
         lb_data.data = node->bandwidth;
     } else {
-        assert(0);
+        g_assert_not_reached();
     }
 
     g_array_append_val(hmat_lb->list, lb_data);
-- 
2.39.2


