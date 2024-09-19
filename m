Return-Path: <kvm+bounces-27139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9900D97C389
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:49:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15885B21980
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18CFC4D8B7;
	Thu, 19 Sep 2024 04:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fsKrkDFE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87354D8A1
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721244; cv=none; b=EmYUToyyHZhzoxNUSphGNA3yp4ydGeSjFPpRM1kjAoV9/D77hny3VnJwKFPBbGPsHw+eSAyqnwjfS/fNvOn9OjuNa7FhtvVtd+X4cExdVrcwmh19+C/dQYs/rSHllDgW/Qz6SocxSaFs3DHYqDs/qKGjvkM0gZEO1tLI32cvZ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721244; c=relaxed/simple;
	bh=Avahiy2LXP0vtKirKz8lxo6CVy91LQWXSnvIbQLzopc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=omanr6SLOTO33NgnEZaozr3xEToIciMB/s0//WXAnkvVdwybeH/quWy+G3bBPOaSmLTrhSTHE4CNerTQfdnMWZJZiAtWkAWXfoiaOMV5uAkT+YRI6DnkkFm2sesp+T1wH42KUHYzNch3ji8aZcyLJnUTtyMof/J5F0T+6P45+7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fsKrkDFE; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7179069d029so297642b3a.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721242; x=1727326042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTfod+luVyICpEfgZ8Uh3DA36M6kM7v+mrR6MBDF7uk=;
        b=fsKrkDFEUP+bTlgFIAdt8eOUr0LvHg6YbuHfQh+TR1b1olb3DrocrWW9Ba/aEXNDzc
         aVExWQvrXZ8Wb6IzeRBI/2JUbMVH4F7nn3z9ZKLVbb+LiJwX60xY5pxw74tIbybVMGlX
         2DGEH6KaBGmUzEjbJ+A2TDCPFYr6sc3Vr0rncXXmkbwwn3HQ3JWxEAD6vYo5KbhfLuzB
         sAK0nbenAriLF9mtI2+4BiNg/x/UcC2Am9fCg29Qa5SL4fP4TUz+NnZo3O9ywapkOpA2
         gVVexHFmNjCdF9aC//dlNUhBSXTmQow4RrZupE+JkjTbQIGsRrJoubNjkWGZSfL8SKg0
         WIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721242; x=1727326042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XTfod+luVyICpEfgZ8Uh3DA36M6kM7v+mrR6MBDF7uk=;
        b=BXATiPQ71+NAhrhzb1uf1OqEAe4FXqD2OVmxbNjPVBErH98Wb3Vu9RBrVGRbKvsmw6
         FXWrYHyeQmTfU1RN1dqSH2kmEpy0oKTTwPuRNMN0SvjpCnroveHi3KSdUN1zA6C93P97
         7EXfHxuam2ET5ufrILmkUa204h856riBXZDUBb3aPqdWfrXm10M02JvCkvhGQnaawm52
         VNOB4LIdg4rOVhY603O7rwSnHdlRzr/CxLX/Q5lN+NOJ7kLsOokf+95uQemr6FTAjku1
         cjwxduAuu4VnyC35wNaKDV+vwep68sn8Yt3CsGVxpB+vQ44btksYVKiYGC6yAgYusC/M
         igRA==
X-Forwarded-Encrypted: i=1; AJvYcCXNOklVHeO+XCO/UaLHHI6QRafzgzpqeAwME5d2t94hT05HD976MU3Uatz8f6yQKSfHKwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxD88rfu8ZnUTvY+x3U6T5lAZS2HsMFwzQH/lWWYAL6+yePv9WZ
	Gfek6FqK4xt5MKFyGjaebfjdNeoTOZr7wXASjzukA2mED3ieao8mudx/XCPrW70=
X-Google-Smtp-Source: AGHT+IENpGOMxkAxVpBEbVxwqYg+XoCNj0Y+tup5K+eTLr6T9UQRMpy2wwxVgVE7FTWLiR+Ma6cVKg==
X-Received: by 2002:a05:6a00:2d10:b0:717:9462:8bda with SMTP id d2e1a72fcca58-71936a5fb10mr30684467b3a.12.1726721242032;
        Wed, 18 Sep 2024 21:47:22 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:21 -0700 (PDT)
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
Subject: [PATCH v3 18/34] hw/net: remove break after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:25 -0700
Message-Id: <20240919044641.386068-19-pierrick.bouvier@linaro.org>
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
 hw/net/net_rx_pkt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/hw/net/net_rx_pkt.c b/hw/net/net_rx_pkt.c
index 6b9c4c9559d..0ea87344745 100644
--- a/hw/net/net_rx_pkt.c
+++ b/hw/net/net_rx_pkt.c
@@ -376,7 +376,6 @@ net_rx_pkt_calc_rss_hash(struct NetRxPkt *pkt,
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 
     net_toeplitz_key_init(&key_data, key);
-- 
2.39.5


