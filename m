Return-Path: <kvm+bounces-26362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 786A4974592
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3652228BEB2
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 918BB1AE872;
	Tue, 10 Sep 2024 22:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ANNQLJOy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639041AE862
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006600; cv=none; b=dy0l0tv3YW+THIYQPAwL/Wi5r3q5DuYVRH0QkQj2/HwMKkWt+1CCyVLY9FysEUHDNLRop1TTqRt7Qqmwenoj4TNtUW6CpOe7UIDbxs/z+xRhd3Jvw6p8B9browSGLtiwjvqGEj67x1XmyphXtuJLX3inuIp6DlJ2i9yDDTB1m5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006600; c=relaxed/simple;
	bh=vgIVOOQZwlXrDwhev8td9BK4bnD3X5cqSFsOwLrK8iM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WcO4h6/ZxKns/d6dauYPRo7AN57Wa8jEv8W5wPclO8kdLss9JWkzK4IFKJ/vHxQLM3rndu4ni0aFF20Gq8gPTZVaZfpWTdmTTVklB2Ath9eDlFeUCsA/6boB/nfCUl80JjMI+f7hZVabH2nqFaKGJKD647M4y4b/08l+/LdWVBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ANNQLJOy; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-718e285544fso2749266b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006599; x=1726611399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5e7jM2SGiugZIDj7hvcHvckpF7J0ao6gx5zsDNU5OmE=;
        b=ANNQLJOyCiEbS8Uy3RRQUvLG8J1gbvU7eddI13UYzVhDsXxogoRDv7ckkkoaehdcV3
         ABJgtKsUL46rSjfox5K7ChlM4djiFmoenKQA+Et6q4Y2AsIE6ot1g65UI9EWowdqV86l
         LQ9CImQKyi5VJX69hMRZx9LGxY2deKw0KGeL5fXD6zQ5uCoFXB4Go9woxlsLvYykvPCB
         09p/YGuENbDaT1srrMpSsEyTKTsNyQVSNM8CAZB/zk+PmlkRHZjD6GcKg3apIjWz1R4k
         ASPibHPoyrseh/crvQ3AADdBTDG92o2ADiKamAe9LGTEf5/KRyj+NFSBQjr9CETqhVMd
         AXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006599; x=1726611399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5e7jM2SGiugZIDj7hvcHvckpF7J0ao6gx5zsDNU5OmE=;
        b=t6OefMaY1i8/FpC/hfrEZrgbWWlXowtr7LYeikUICUdydGEhvmNlmU7VhmkJUiwR+q
         JbQU6+Qo0z8F+qaKz4xzLAxpKU1lbDNBISnxFXB6N3w04KIr1um8gv7zgAEwEtIMAzQR
         Fuqr+YPXVDmd0joGt/uBGGnebvqPWDUkbqjc/473D4Eibn2A6Lf6mROyAAq8CiHIXn5I
         SordLhy+3FO6rDk7sipZ2+Dgb3gGxXfxYxP3C4LJGf5stEBqx1nKpKHNyZIoFyevYD67
         VN8XDsBN+a658yY0o9y0ivaWLPyeZQ/f9+lFd/opzcJUKyEE9I7vDHojTC4lHZST7T/L
         AwRw==
X-Forwarded-Encrypted: i=1; AJvYcCUARDrP+Ebd8azMO6Mazlkf5LWFlRrnOFZ+2IybwMPzyiK9fZ1SOQUEsVx40NmqQdaf5V8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv80nZ8ur+NDYcnlnPAq6rzvncioL9oGHujhh1WxHlVcjBsliG
	IeH5tMeFynA5pp4cz3en5soWyl1liUYx1FbRi7Pr4xttpJfEmf2+FC9Wa9JZkao=
X-Google-Smtp-Source: AGHT+IGmTWAlHqohfvDcmF4lhCn4e0s9xwSiGMy/9LUB1RgrtDOx1fMalziLV42CXKlDan+123/d1Q==
X-Received: by 2002:a05:6a20:289e:b0:1cf:4348:d5c8 with SMTP id adf61e73a8af0-1cf5e157922mr2270616637.39.1726006598631;
        Tue, 10 Sep 2024 15:16:38 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:38 -0700 (PDT)
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
Subject: [PATCH 12/39] tests/qtest: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:39 -0700
Message-Id: <20240910221606.1817478-13-pierrick.bouvier@linaro.org>
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
 tests/qtest/ipmi-bt-test.c  | 2 +-
 tests/qtest/ipmi-kcs-test.c | 4 ++--
 tests/qtest/rtl8139-test.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/qtest/ipmi-bt-test.c b/tests/qtest/ipmi-bt-test.c
index 383239bcd48..13f7c841f59 100644
--- a/tests/qtest/ipmi-bt-test.c
+++ b/tests/qtest/ipmi-bt-test.c
@@ -251,7 +251,7 @@ static void emu_msg_handler(void)
         msg[msg_len++] = 0xa0;
         write_emu_msg(msg, msg_len);
     } else {
-        g_assert(0);
+        g_assert_not_reached();
     }
 }
 
diff --git a/tests/qtest/ipmi-kcs-test.c b/tests/qtest/ipmi-kcs-test.c
index afc24dd3e46..3186c6ad64b 100644
--- a/tests/qtest/ipmi-kcs-test.c
+++ b/tests/qtest/ipmi-kcs-test.c
@@ -145,7 +145,7 @@ static void kcs_cmd(uint8_t *cmd, unsigned int cmd_len,
         break;
 
     default:
-        g_assert(0);
+        g_assert_not_reached();
     }
     *rsp_len = j;
 }
@@ -184,7 +184,7 @@ static void kcs_abort(uint8_t *cmd, unsigned int cmd_len,
         break;
 
     default:
-        g_assert(0);
+        g_assert_not_reached();
     }
 
     /* Start the abort here */
diff --git a/tests/qtest/rtl8139-test.c b/tests/qtest/rtl8139-test.c
index eedf90f65af..55f671f2f59 100644
--- a/tests/qtest/rtl8139-test.c
+++ b/tests/qtest/rtl8139-test.c
@@ -65,7 +65,7 @@ PORT(IntrMask, w, 0x3c)
 PORT(IntrStatus, w, 0x3E)
 PORT(TimerInt, l, 0x54)
 
-#define fatal(...) do { g_test_message(__VA_ARGS__); g_assert(0); } while (0)
+#define fatal(...) do { g_test_message(__VA_ARGS__); g_assert_not_reached(); } while (0)
 
 static void test_timer(void)
 {
-- 
2.39.2


