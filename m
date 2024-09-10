Return-Path: <kvm+bounces-26386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA349745BF
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EED5E1F22941
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50DF51AED2E;
	Tue, 10 Sep 2024 22:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C/Y5fvfb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2C21AE87F
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006688; cv=none; b=iqwy0roRQNHstYAPnydf9fE6aeHRVx58dC29PaFvd90DoQtD0qeOU1vl03sbM0SzjERZEWehzr3c+/RDvLv2jMXqYw8dUyeg6IvAd6n8qKqnKV0E1oHVPpLSxnX/Iz/09IQj88FDedzHX6KbNbKaL7+WUObVNALCAuWKCT5lv2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006688; c=relaxed/simple;
	bh=dWcHsEJ932nJIkEj4rPPfF5X1KqoBzpxy5C49e9JITc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l/rfIVkc+yUOG8Nfft9K2DP5pm02GUwmRobcPMX1qkKC+3MlkIOrGBbRh5BpWKFCpUSwm+MUmePhwpas0x3FOI+ZAAOYq4YKCN0jks8eMJnZHoTLZNTFdELsFeI/ARpH6tU40jJW+2OnlUioiRaoFb3Qyh6Fd64n125tfJL973Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C/Y5fvfb; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7178df70f28so1002842b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006686; x=1726611486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ilTWC8SUeBuQoT7BUDbD2Q85sEksALIaITVdH6ynhyQ=;
        b=C/Y5fvfbmdCHlermTdGFwwpvI6jGxbDbE1s8PXn6P8usnWGQddLV7Gi8A3BIwv0nWO
         gJrTO7LTEEpf90gApxTOhjroN06TMJ84pDrqRbuPwOLjD3/9rG3C3dPvyij+eE2OOuqH
         4gkJoOSQ0OfoT98u1Wp96yS70Ph5gTXC0ppKKA46fAXtiLjk5y5d9gK5szM7GofBQEyk
         9KwJ7IoDSG5HqAN1vFuwsQ8VBCdFeC15te7CXBemWsxPUvAa4+VcjV4MFlKO0Nlj6TvO
         SMSiaKtWk1IZ+E8eofuW6FIvfiWlCnlY2cva+F6I+xYHulh5StJv3Vx8ex80HLM4zUWu
         laGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006686; x=1726611486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ilTWC8SUeBuQoT7BUDbD2Q85sEksALIaITVdH6ynhyQ=;
        b=BIj60tsdL7q79eqBjcuZMnyFoy3nHGvsHCFv7jXqfRCzEteGPd0/pkWST2T+m5rWr5
         9l1zZKXBubVnhDXfD6gnUKKttajsoH6swgoC/JH1Ffat1SI5JRsMPZSmqzumY88SXMTT
         M34nRhLB8Mc9aCSRMxyuX9y2fUUh60Exmh0OysUu0HZCFVG4gfsxmPjo7gQ4pZyuj9o2
         vr4NOyrVkknuF9FGav4f6b9k8FsADmC8o5uvM2GB2NZd0lzXkdZARiLY2wXnHN5nuDvS
         5mdV7Gz7+UlkOpdxMAvYjhi8RqERnQdKziCjwtYNlRhgrD33pTnTJiqPQyyUDJUuxzr0
         LqKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXr09WQklDKzK9Orar9PM15eW84SDWApN6RWqqjBCdF+IfpUC8stKaSXp4fvW98NyZsJGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLa72O6nwbciGD0yNSXFlCMVgLrI1dCWqCFgiSLq9HDielzakO
	0d+prC1y4Cys31z1dygjH7wjDWhozJnqgXKXVMNNlvCy5XCFh2CHOsnB2TntjsQ=
X-Google-Smtp-Source: AGHT+IFCrp/2O2fWq/sOFJdW2m0YIC6PP34v266qfmkWHzxnSrAINIAZCxBzCzEo5+wVOk3yz3M+wg==
X-Received: by 2002:a05:6a00:1799:b0:706:5dab:83c4 with SMTP id d2e1a72fcca58-71916e7d1bdmr1330581b3a.14.1726006686207;
        Tue, 10 Sep 2024 15:18:06 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:18:05 -0700 (PDT)
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
Subject: [PATCH 36/39] ui: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:16:03 -0700
Message-Id: <20240910221606.1817478-37-pierrick.bouvier@linaro.org>
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
 ui/qemu-pixman.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/ui/qemu-pixman.c b/ui/qemu-pixman.c
index 5ca55dd1998..6cada8b45e1 100644
--- a/ui/qemu-pixman.c
+++ b/ui/qemu-pixman.c
@@ -49,7 +49,6 @@ PixelFormat qemu_pixelformat_from_pixman(pixman_format_code_t format)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 
     pf.amax = (1 << pf.abits) - 1;
-- 
2.39.2


