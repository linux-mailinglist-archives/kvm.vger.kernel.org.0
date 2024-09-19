Return-Path: <kvm+bounces-27128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93AA797C374
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0232FB20BFA
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B698D18E29;
	Thu, 19 Sep 2024 04:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mze9w7Ti"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723B7225A8
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721223; cv=none; b=MoJEGVCZ3gaJ1IAG66zETPtRDeEZSvAwTa6dvIR4rZQEWuSU0JUsRUXaIA6Bz8SCn+VBjKPb5yC/q+FdsyzPXQ0A36THArwfbFsCNzIZUuujqOvk/PajcSB4z6qvdpmmPEF/eLg1LrvtlOsdBSyHcGu60WLpupQZaFuqHrQRE4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721223; c=relaxed/simple;
	bh=SDd/Jo9OZze1Z8uYQ4b8OezfkU3/I1UkLZARNNEkawk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y0gXqn55XAe0qrhJx8SiCwojOSjQyaodhaGaFkEMDdloo9eM4Ipckw4USWXtBUjtwKaA4WaQZSZOFYv7BKzK6FG+iUIa4MEN/jDCMWy+8oYkYNS6x7qRxPn55yGk603rArxAaU/VgaZH3KRlN9STZcrxQdDx0H+8e2oK1k9A7Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mze9w7Ti; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-718d704704aso333939b3a.3
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721221; x=1727326021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQ5w0lQctWZKvW76VfUVnQRwnSRhyDW+QKlbN5pvMwc=;
        b=mze9w7TiQ/1sB0xzeIvrWq9jOZEIHbedmCrNEF7GNQss+aUwcgPUx2FXu1R5LWfnZ6
         vWFzZQtAHjk0eAb9i9ueP13ZnoWcgDhHY+FBJjywq9EnI4PUW2cXYdHSSLg/MPxvXNEG
         xm5Seiq6KcPsXQz5ej6rlWNTZgZQlX1etk7wJQJaUjkLWYjXOax2lVluDM6ye8pchI+V
         yNNl6hhKX7gH0LXNIp33aN3UwpAF3StNVhZjfzhLxsy/8Tif5JAmF13afP+gre90y1fq
         eaZtc9JG0/JaknnLBd+1cAtj/g2koDctoRfvO0m91SwXolTy3pp3wG4tjuS5q9Dma/IC
         6gLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721221; x=1727326021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mQ5w0lQctWZKvW76VfUVnQRwnSRhyDW+QKlbN5pvMwc=;
        b=FluEyC3Ms43k67RWzkYMZoZUVniYhG9NvBJH8oq33Yjio3RVuMaELZ7AmFCMiwvtQS
         bJOzlHpXx14tscCx8Sn1m2LGZodnZ9hT9xxmpR1iAczYzS2T0oZT1Vmb/NIyd/mQc9pw
         0bGC4bwW84wv0LMzarNlC6R37LJsm3YWv1FKOB1LEK9NIrJVZy1nzpSSRxFR+7gW6rXh
         uWi26q+zyOZhFYaL2zZThA7nXEh1XUKff13TLQqWxswcjk3gSW8qYw4KdMclD7ihC9Nc
         KFvIri/er/8j4ZsF58kVX9dZWxhlEP3NrxLCYKWn05M8UsiMBivgj/u4EO89xBXdnxos
         It2g==
X-Forwarded-Encrypted: i=1; AJvYcCW8I2/8k/I+iY446KefFd+aUxJ3tWpn26L7GjRvSUteRZqyI/vUKEwVTZjTbFj/z1WAXAU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/ludwDgrKvAyp+QitK5Bgmz5tunFUJk05k51sSuc5CH0V1g3v
	l/3zN8S33oO34BFm2X35QB/CLAF2zR35UR2D7kr2J7C9PZxD++lTuww3hFw7YMg=
X-Google-Smtp-Source: AGHT+IEAmbhCRhYWmctGVCjASbSM7CCQw3PaPgr2ecmIRqDI7EbS/ir9wSwBUY/hOvsMNKhE4LWwDw==
X-Received: by 2002:a05:6a00:2e9a:b0:719:1df4:9d02 with SMTP id d2e1a72fcca58-719262069f1mr36784043b3a.25.1726721220565;
        Wed, 18 Sep 2024 21:47:00 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:00 -0700 (PDT)
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
Subject: [PATCH v3 07/34] block: replace assert(false) with g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:14 -0700
Message-Id: <20240919044641.386068-8-pierrick.bouvier@linaro.org>
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
Reviewed-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 block/qcow2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/qcow2.c b/block/qcow2.c
index dd359d241b7..803ca73a2ff 100644
--- a/block/qcow2.c
+++ b/block/qcow2.c
@@ -5299,7 +5299,7 @@ qcow2_get_specific_info(BlockDriverState *bs, Error **errp)
     } else {
         /* if this assertion fails, this probably means a new version was
          * added without having it covered here */
-        assert(false);
+        g_assert_not_reached();
     }
 
     if (encrypt_info) {
-- 
2.39.5


