Return-Path: <kvm+bounces-26384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 799639745BC
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED46BB245A7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511DD1AE865;
	Tue, 10 Sep 2024 22:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S+JKjgyF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4BB1AE053
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006683; cv=none; b=l5zy+qVJZYyGEj2QUfnVA+eO0RKRuczhAh36zrXM5Z68jsZpdK9yo6mnczLT1xmFqXrUgUOxMOr1TvyxCyWABImtEKlAaBljukguJg6VP7iyhs9zZq8erm3H0J/0G8CB8EzIuGtCMHFM6qAXDgizSuNehQ7LbDfWW+JLe3Xm2pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006683; c=relaxed/simple;
	bh=byWCUVZY0CZgmeG8Uk3XPiSRQHpXFzzgihmVJ6iWyM8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SzIK3SUsmqlpMjRKbGJ6M7HOc/BhDhtrCttj49Qq5gCVm7nkSr9m9NhCn1M6+nnibWfMOBIqnQcjOVVRzcMpZh6JheVG5D6olqsJFV7RC0eRqQ+H0fdGVcArGoiJLB17TH73KAu4RjHhFtQKLPL9ISD13CDD/4sODdr5P2ArRfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S+JKjgyF; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7178cab62e6so5308955b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006681; x=1726611481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nc9MGfuSCocWwKVEpmreZE3UNjtG/w4I6s0g9X8lNJQ=;
        b=S+JKjgyFcy38UIyPhukUtdAGDU1M+fVU+WvmXzYlnNv4cGA0aYwrMMBGQCewkYz2Gk
         m6enQOPUgTPTX07LmZx8lIAocavS6RKwfc8YBdjiNvFtN1S0J1djr+1I230sAd6Okg/d
         kOCCsArmaudDQwghfO+JRq4EomP9p+i0FglrfLT0NoKV5+Gc4HSMRHIN9ihZHvgzwijF
         K9DUZTG0qIfSSosMWIbiCKsUTS2uDQRxSuzKZ0TweeGmvnoyDy0kg27YqgX1IwMMH/Qa
         KfJwvLJRWCRl1BRN0f8vxG6c7OhpABCdA1YpkB2XRCOn35cxRwfHk240GbjFbzz7UTGb
         ez7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006681; x=1726611481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nc9MGfuSCocWwKVEpmreZE3UNjtG/w4I6s0g9X8lNJQ=;
        b=VA1ybPe3ryIw8ZFpZdguFU38q9Kjdm2E4yb93WPRNeGzkAIDYec+ZkJVhERQzH49e+
         5wkDpp4EfL6bzgtEcudisjg8TQStzezU7OPv35e5A/HFu8Heaw1nko6PP78cFmdyQ39a
         rNLRda3Kz7efGMm+3Ixl+nsyJNm71zPbO4Mqo0HVIdIaqCQQbaVC2ny1E4T0/j6aRP0n
         HO31XI9XxyfDfddsMh782JzEOv6kVuyttBL6luv75GZaYRBmHTqEc1MBdRV0XMOqSf6R
         VpV209/9SRFVPYtM+sY69wENxGpaaHimlcd+D3IXJjaLo63ob83P826Q3fUrd8SNNmW5
         mjhg==
X-Forwarded-Encrypted: i=1; AJvYcCVQYLRjylVNHeuXIOFtzPogaimLungEeOlNcu9KFtAtkP84ndeX7uaN4lCpcph2Rm4dx4I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5QZxNw84mvwMAwS/yCF7z+3I7WS2UDBQ9rNp8CSlWA99cueFE
	E/oBpYsRYRFc7FcMcAAcpIQKgVtLp4y1kL2blt+yHeyJsVV8jSaSU/cYSrj7a8o=
X-Google-Smtp-Source: AGHT+IEWKrlPdcL0ciOz6xX9tzB4Y5/ftvFt/m826lvbOpwq+zPCmtbQUUnnI0rtApLLAhne6XqzYw==
X-Received: by 2002:a05:6a00:919e:b0:70e:9907:ef75 with SMTP id d2e1a72fcca58-718d5ded0a1mr20600690b3a.4.1726006681287;
        Tue, 10 Sep 2024 15:18:01 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:18:00 -0700 (PDT)
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
Subject: [PATCH 34/39] target/riscv: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:16:01 -0700
Message-Id: <20240910221606.1817478-35-pierrick.bouvier@linaro.org>
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


