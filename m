Return-Path: <kvm+bounces-27134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8C9597C381
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:48:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA661283BF4
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C482A3BB47;
	Thu, 19 Sep 2024 04:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LIFwYD4j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F47383A1
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721234; cv=none; b=R0qX0WG/q9EjpeMte2PMI+N3WE/GZn6clZ1f6NB1yirz0TovrSLa3t1SN/7LM4yoCcQoDzS/FdMtp9BD/K7wnFRaoShnA5dcI6V1fSI9dWneGzkjBMTJ/FfrITWCDXJCKqjzTcaeoYYrCvz+MT7Kltm2A/2J33jUPlXCFH6o7uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721234; c=relaxed/simple;
	bh=opM1fuP4B6hYIxce6wrCIcsQth4x5c32Od/9tnr8SGk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=USUFyJem1jRplJlH5YMf2Z+jcmOC39sBfrc2Sr2VSCqtORsq0nWIiEaQRpPd+u9bbPYktztUboqT6uEzijz3LH26XcRASzhCzX0PnGn/fxEzeflZ1upatMg55Bm/sbv4yxYPnYOiiTIexLIp8BahTefjEr8rNFOBIizhXUjmsNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LIFwYD4j; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7d916b6a73aso213519a12.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721232; x=1727326032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BFDTm87nVz3V5/Slt3dbvL2tTaVEGEVOzfLYJ3PuoMQ=;
        b=LIFwYD4j6B+0CPzcmP6heMI4BPR/l9hW+aixF8hwL71OFO//ILuQ+7kA3S2srTI+oe
         3WDaGGbUzn1e6eIg9J24pOEDq8rMG2r8ZZT8YamlbagbRytMlRualLFf5vOXBsFNvtqO
         tPCpRVW0hDz592dWsTBmpDAH2lqMWxjKmanZucX2LOqnvkC5fCZ6UnGCdncNpaCesdjG
         h4NvNTt0KUh4vna6VXsIFh1N4CUsR0wbJk3XSssB/G5NGNLLVptunDlPWSDhICziDa66
         /Ks90gVlCGFPnsMuqk92pq1/v3oisb3To3mJAAft7BddmA1BgZ/lpZq4YhNDBPjnxTlU
         lL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721232; x=1727326032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BFDTm87nVz3V5/Slt3dbvL2tTaVEGEVOzfLYJ3PuoMQ=;
        b=VQEAkvld2bpOaRhqe2bRADjVvPVh18vMek72MbGWeyR+RfAkI+k9VDQoT0DfSyRl+G
         SqGV6apF2/XuXfkRDxE5B5MfoUVft5f1E31rquslMow4kVGxXfmS2bzrSkY23NWIEqHs
         6n5G1KXY9b6HBlxq+0DpJCQuGrl1BeFg4ZnglWumPTKDPPQ2Nn5H+Ts9tN2xo5tLVxy/
         sLy0jke4RBOf0fk14qn/vsMHPJdl3ME8ItavLRGbQI+Mrmoo6NpCfrTSG/qTYP//Fe/Y
         TMl3iUIXj9T9E+BkA3S4QMrpr/OTD1XM6W1GSNvRJbS9i5keNvZz3fjwXSb1balGdpkV
         rqbA==
X-Forwarded-Encrypted: i=1; AJvYcCWcGy/8yhqexiWVmmBZI5YeowytAjOBzCK4ZC7SFKsdCkc72SIxJArV6Pib1/XOLZkgwZg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxslJZt2q50Q6c7CIsYGDAz+Rr7AO7O/Gbna3aWTGYGt7Gct/zx
	jmlldc4EmWMcerAhseePxgae+nFpkz/+7p9zXyYkgcz42nSvUXs22UAwv5+NQR8=
X-Google-Smtp-Source: AGHT+IEyMy6V2A0OtvCxf4O48p53ASfDnJYGmnLQMeZ/04wkCNDXNGA3OfpgkgUg92nhjq5jeesYvA==
X-Received: by 2002:a05:6a20:e30b:b0:1cf:3402:6e9d with SMTP id adf61e73a8af0-1cf75d76b46mr35535691637.2.1726721231866;
        Wed, 18 Sep 2024 21:47:11 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:11 -0700 (PDT)
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
Subject: [PATCH v3 13/34] migration: replace assert(false) with g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:20 -0700
Message-Id: <20240919044641.386068-14-pierrick.bouvier@linaro.org>
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
2.39.5


