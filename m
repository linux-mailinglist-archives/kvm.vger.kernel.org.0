Return-Path: <kvm+bounces-27136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 503EE97C384
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:48:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 752341C2243C
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C925E200AE;
	Thu, 19 Sep 2024 04:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aPLYOVVH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934A14206D
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721238; cv=none; b=ruORDNKjgkq8dDY1kPy70j5wOoTTPOnDy/ZnTw/Mbaei76uv0pMnRD50tMyqke8PykviO0ag9dF8ZCdDLLDIWWDu71F128BbnalDL1UvzlU7YiaesB8gakvBHSwxoxpBbxCaNrNPx1ROYKPKOZFPfEIGe7PCxnegYrMS1baqrC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721238; c=relaxed/simple;
	bh=yvpumS8T8+RP59x5A8bfw9cg1+WDbsrkKy7pql26upQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jDTv+DesVwZjm4GXHs1epzz0/bo2MNo99o70MwdN5QgbBCHZ5EFh68Kclb2UwG2auuhWxwxHrRSp0GJUw9BjD7080wB04DGhP2u6DWi6rli2+eRiXFoYYBAkruYzR4SILyuNXHz6CbqG9q2uHgP3kd4mbe00+FharGkpH5caQIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aPLYOVVH; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7191fb54147so271831b3a.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721236; x=1727326036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=volzZG+VvX1cjCtnHdp2ianv+4MCm6slEtRN/0TB/Mc=;
        b=aPLYOVVHpxWT5n7kpfPFjEEg/6/+ocSIvLpoXFmg/Lta3wRc6AiDnTXiMZF4fitoo+
         ls6FLeeT9wDGQdGBaTMKhUfpMwSMgZRzoSW4YPP3f5RIyTq3kylfZ8gWTnH6QNH+6FRn
         RLUR3uATYP524nP8aEPOExB7fgJKA+Ju6JjtKe9lOO3wq9NWiYI2wTaQdtmsMctvGotJ
         UfiT88hlaTSzdk7c7rbSFUQEGKQQBXx/ST9RgvSJaXksqN1b5q7uZ/NPnp7Ql6VV60N3
         D8BucPZ+THQumdEriZiHdpaKKfC3ag8dOuNIYXL0cr1MGEaie0lv9uS1AojEX0fDF7k2
         SaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721236; x=1727326036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=volzZG+VvX1cjCtnHdp2ianv+4MCm6slEtRN/0TB/Mc=;
        b=T+voDAEpkIZqIjPm7T2+G6LYxxMPcdMXKh/y2pNl5tlZU7DwAXavLxdkLXf6WHkHFs
         poggF86j6dGCduAOhcgtBTB32gVaTpzsw/3aRCDUenxmnK+oxcEfBCJJArhA4WsN6+jE
         kFGBtYd3MnpMOxO4anjcoiSJTtaGensEXQ/qmDOSDIpCeQZyOFdIQ9BLhTTiYW49ejea
         eP0GHS3OzIM5x6mW7f07UJ6HQq/r2sGczGLb6cBZaD/3+nKNYBJgfIehPN2lx2kMkLgv
         dAEQnOS2XX4EbGp88AqsyMdbWWSGWOuMX3Js09pF0oWVszqmbeGvkfA8loKLWgvUk7ax
         k+Zg==
X-Forwarded-Encrypted: i=1; AJvYcCXgy8dB7HHpa9esOZq3+3MpIeD9Zhq0hwd7cOe4E4XoszxC6wLjGdK6Awxq379nmf+YK9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGbAiAn1nzfEZvQskUdR7Rs7rfIdlPVygFf2e9IYogp+wPjlKR
	LFNkl13Bv6UkFxwHvaYcHrTz19fGGMgw2nbFdX5x6UtMTnF587qRj73j7LVR2tQ=
X-Google-Smtp-Source: AGHT+IFkwdx7PRwXSy60OR+EcQ83hvrfwCo2zu+BZr4pCRc3QVrXN1huxPQ5BQ1Ng2g+CQtBhwCssQ==
X-Received: by 2002:a05:6a00:2352:b0:70d:2e24:af75 with SMTP id d2e1a72fcca58-71926210c2cmr41850428b3a.24.1726721235916;
        Wed, 18 Sep 2024 21:47:15 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:15 -0700 (PDT)
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
Subject: [PATCH v3 15/34] accel/tcg: remove break after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:22 -0700
Message-Id: <20240919044641.386068-16-pierrick.bouvier@linaro.org>
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
 accel/tcg/plugin-gen.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/accel/tcg/plugin-gen.c b/accel/tcg/plugin-gen.c
index ec89a085b43..2ee4c22befd 100644
--- a/accel/tcg/plugin-gen.c
+++ b/accel/tcg/plugin-gen.c
@@ -251,7 +251,6 @@ static void inject_mem_cb(struct qemu_plugin_dyn_cb *cb,
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 }
 
-- 
2.39.5


