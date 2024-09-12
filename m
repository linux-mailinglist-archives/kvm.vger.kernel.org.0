Return-Path: <kvm+bounces-26650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7FAF976316
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CCD528254C
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57CAB19F40A;
	Thu, 12 Sep 2024 07:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qIjccIbM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1943D18FDCE
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126858; cv=none; b=MNFyGvTpZnQkl2csEdaxOpKvBYFF6VSfZ5w1+hy/ejz5dSIU2QRJe8zUZ85NTnZ2NHN9AoXcYdj/M1H/Vrg7JW/5fgfwRyUPZR79ZefTJhybinzkaKOAiZ5ld5YvjS2NmF9sryLUx5Zy6UFqLEUgobtOwtGP21aNZBX+GGmu8yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126858; c=relaxed/simple;
	bh=ixD//SETRDc8qYWsGCMhl5yO9DlMKyy5wk9p5v5F6ro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X2DlSoKJkjUKK1LyfOqLEogz+mN50qDkIopltEzLPd7107vmS7saPyAk4L+yNyaHZtyz6pyBAUwn60CblkJsm5CCEvsHr8VrDNokMbsx+c65oQt+Hkwba9ozFq6fsdTAzCR3tP9hVcKjpAos0NB+j8n4CZwCPoEdos6vfY4ExLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qIjccIbM; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3e040388737so300793b6e.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126856; x=1726731656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNLX5DGEYX2WSxoAnBw7IllFC2g6NKBNnAohuS36caw=;
        b=qIjccIbMyMO0LHSgCSGlsQ9XQtluIp6gpFTGeRW9/78r3gKjCtSUx+4qO2NemBDVnP
         Ww72XAs3ANpStwI3WbPRZZUBmh/PAbqQ2eQNzjGf8dZmzefbr0znEQ+LuUZ9RxSsSAqk
         iUVCZyb1I9OuHm0KQ8rwZwD8ggIuUuBg+XBd8h0WiqHfKZX3I5aLoGTAtlgasFIMTvul
         oWGzeDFELBqLuLOVcKtUvO0xIkreFC+vBo+nsFLIDVcokThBd0aFdJl3WhN5hCKT/jMG
         Md+oCsIJHYq7yxHgeaYrEiOAbr5pNSGSSbXo8rsgJ0Zz4s89dZ4SWK1/cf+of4tnggBc
         oFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126856; x=1726731656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BNLX5DGEYX2WSxoAnBw7IllFC2g6NKBNnAohuS36caw=;
        b=NkbILEXpEu6ORzQhbtJld0d7m1nYiIVR0Z46NXjB99S5RIwgIi32AsU9UVJ3Oxn8vi
         6ieMqQRlY496VAKZuD4H8l4giZSe1/+JmNBkgYZDAxHUFSpuJJ0MgN6jmfKdohI5Y/X3
         wWLB9uu8tljiLQSRVgnPf8K5Y8PpVyRAfB7Z6lG54UDG0RkpDHpeOXuzYHadKiNlauW8
         H0lesl3wZxjfeZEX+K4LIJvmOz1hYszi+QTfzb9w04/ZpGJmWQJrFQhELYHb2f4mLwCB
         lFQVZ9p3n01Vy22RVtYrbIyihSq1UW8XWJEzjn75l8Bqa+DOCKTTkxWOGm99PKLcg+Pj
         yGHw==
X-Forwarded-Encrypted: i=1; AJvYcCWWUOM49g2HBtY+8WeQGuq5qC3/UIkXTrWE2PtSjTCeOjhY86/XvoIQkz1rXp6vORVT8a8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWsErY1SgcvW6iXBAnbJtX8ZIeY89jGPTpp80H6C8bAbv6oxlG
	ICKmw9dhOvdHrJ34XI36sua4ZJlNyJF11uyogPR8KttbjwXzedjO4gLcaXJ+SPY=
X-Google-Smtp-Source: AGHT+IH+4KhzlZ0oxHJ+Uh2bqKlcjrz6JC7PesfrNFsLZGD4kro1D7yoRsRe4Wd9oo4If8anPJmXNQ==
X-Received: by 2002:a05:6808:d52:b0:3e0:4aa3:73a4 with SMTP id 5614622812f47-3e071ab4fd3mr991972b6e.16.1726126856074;
        Thu, 12 Sep 2024 00:40:56 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:55 -0700 (PDT)
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
Subject: [PATCH v2 34/48] target/riscv: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:07 -0700
Message-Id: <20240912073921.453203-35-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/riscv/monitor.c                  | 1 -
 target/riscv/insn_trans/trans_rvv.c.inc | 2 --
 2 files changed, 3 deletions(-)

diff --git a/target/riscv/monitor.c b/target/riscv/monitor.c
index f5b1ffe6c3e..100005ea4e9 100644
--- a/target/riscv/monitor.c
+++ b/target/riscv/monitor.c
@@ -184,7 +184,6 @@ static void mem_info_svxx(Monitor *mon, CPUArchState *env)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 
     /* calculate virtual address bits */
diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_trans/trans_rvv.c.inc
index 3a3896ba06c..f8928c44a8b 100644
--- a/target/riscv/insn_trans/trans_rvv.c.inc
+++ b/target/riscv/insn_trans/trans_rvv.c.inc
@@ -3172,7 +3172,6 @@ static void load_element(TCGv_i64 dest, TCGv_ptr base,
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 }
 
@@ -3257,7 +3256,6 @@ static void store_element(TCGv_i64 val, TCGv_ptr base,
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 }
 
-- 
2.39.2


