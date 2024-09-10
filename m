Return-Path: <kvm+bounces-26356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29FFC974584
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0F6728BE8B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5641ABEDB;
	Tue, 10 Sep 2024 22:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U4L4bK+R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957D21ABECE
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006587; cv=none; b=b7Vx3lZywO432AoYSHVFzmsPdg8mifPOy6DPi0SmnF9ekjx6oUNjWk13yZzZJ+F1KsZXRA8zV3XsZQofz8XjY3N0YwxwcZcaPao3FOszL/0nmoatWBSdNYxPQC5/QlxNKtpwrIM2Q1X/NjAtutLfOZdlIbWAcqVtbahCVNFHQFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006587; c=relaxed/simple;
	bh=dG5ignWIfxWAaS30drG6W4hSlvXV0DyVuyVMpWP5HbE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FftwOTEGOQvazH28Qv3fbZpRkwVuuy6eru+whcteOsFpYtiJcmwZ9hdf6ArjEHuRpbV7DUWLjVYbWcwS1VQFwNuymq1BVHNf4ec29O7bcgp7jh9A5v2Mfn91FopugGBNysS/LHDH76Py/twhOS93m96bhVw7UZtzj7Fl6+F6618=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U4L4bK+R; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-718e11e4186so1244153b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006585; x=1726611385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=puqvVpFKVlVCK3CqflCQnP9TK7q5f0hM5PCb/iix3yg=;
        b=U4L4bK+RTpnj/o2R4sV/dk7mTqSLUNjSn8hqWm0fy7wtnTsJPutukjsD7X8QyOmmit
         XchnElwgKQDPKd/zdpk8s89NSmaE96XXv/f1rjzRIa/j9rbRlj7fKK5Zt/H5SGUjz4sD
         aAERYQRtEDLz9MoVm5ThVlyOlkw7zeaSwnFSDV+dMgRy8/D8tFWR23d/XL/pbN8rLLCq
         q+dLQlQt5x0zQfomihPnJ+k+JON59LCGdVRzXIZp4LpEFXIPRQKUYo6lZ8imVtDWkmSJ
         hgGgN4oji0bnScD1vK4g4xRnqeB6Apzpt0xKUwBfsBXGGHzjdB+cBpEUtnpQqoF0DgUF
         xzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006585; x=1726611385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=puqvVpFKVlVCK3CqflCQnP9TK7q5f0hM5PCb/iix3yg=;
        b=pdKqdHwNXs3X709SwG/DDGn94KPEpHslyA1GJ6CNaD8opE/pDS1wCw9TVX3xnKMWND
         izXHBlsf73gTmVF/SQql1IB3k20h1T4opeLvVb3E0I1Emswg7NK37kkZAAjjFX4CJpo9
         SElnIgpEakipWUDIblgAL5XB0I1JToNK+8RVOEQ/CDTxOu4aNo5t/AM9bL9/k45dQ4yN
         jKu92ySnnpB7dmzV2U5qCuzMIgTCS5O4oAV4+omDF/tmmNGtigrmemRAxcmfn1MKGhff
         L4Ed0sGD/3Pww970Pd18/af01DYfvYGLl2juiH6vgnrUVCfY/VED2Gp4gDdtVeLiDg37
         mzew==
X-Forwarded-Encrypted: i=1; AJvYcCWovvnjGOX0U32CoG2fPyPPNg/82S1D9fIk+5g98jbr3a9vV1kvVsW3Sjc/44/KBm0SQLc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7sn07sd3vup6UEDKizA6ZXE9smVDCTTqI0IjsfxkFLfIhcIfO
	yS+UPDnz3ZwXATwbCLiuH92Acby3eqUPh0CWTmYy2XCEw3jbLKwypv/KAvdzHC8=
X-Google-Smtp-Source: AGHT+IHIvrzvH/+9jVryyqHImeYb4fOhg81YBUc0CfmQo7SIWh/8KSDCX9LvH03UUnVz/fF8OPBLeg==
X-Received: by 2002:a05:6a00:8586:b0:717:8aaf:43be with SMTP id d2e1a72fcca58-71916baea16mr1226278b3a.0.1726006584757;
        Tue, 10 Sep 2024 15:16:24 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:24 -0700 (PDT)
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
Subject: [PATCH 06/39] hw/net: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:33 -0700
Message-Id: <20240910221606.1817478-7-pierrick.bouvier@linaro.org>
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
 hw/net/i82596.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/net/i82596.c b/hw/net/i82596.c
index 6cc8292a65a..cd416a00ffa 100644
--- a/hw/net/i82596.c
+++ b/hw/net/i82596.c
@@ -282,7 +282,7 @@ static void command_loop(I82596State *s)
         case CmdDump:
         case CmdDiagnose:
             printf("FIXME Command %d !!\n", cmd & 7);
-            assert(0);
+            g_assert_not_reached();
         }
 
         /* update status */
-- 
2.39.2


