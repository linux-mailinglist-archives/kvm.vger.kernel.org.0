Return-Path: <kvm+bounces-27143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB6997C393
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D1611C225F0
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BAD260EC4;
	Thu, 19 Sep 2024 04:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kPd+64qC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A32219EB
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721253; cv=none; b=SHyHQK9lc19UfWW8326FNVs5f6sA/OyvIWA9Z0GPmoYGTXq+H0Isztd9W+FpqVm7SX8+nxcrbejUtV8Su++upLX7IgBAWyDx9DAFJFb+n8S7kruiE4EBvd1t1/V4bYPkfvycyArsX3zu+vaB7Tg5nh3yZp04pFovzQGzhlpaeog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721253; c=relaxed/simple;
	bh=kZzqIDT1mymDXK40PTnYGQq6EWN8LMqSeQL8CVADzkE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CdhVQy0uvKZUn1gMfjcSnXsnhSGiVoCwhj9Ab0n5w8O8wKVzGq9h1bj4zkAHx3E4ilKFSgnoAIosJTDW6tZ+6F75yk8ultxKU+asRMkHpgba51knnnHsNzgzSvhCg4zkI4xmIuEzwa0I1Hl7Yr9V8xa4SbhRCYzHR3Kdg/NxPZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kPd+64qC; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7d916b6a73aso213693a12.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721250; x=1727326050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5Ewnrr/qjz52ggXP5z2OAFJ85TodMlAQJmzdk5fJ2U=;
        b=kPd+64qCIYwg78mpCXQhEdAadOBwATnS7k11ZNbXOEFlNEE7wy3TkQId+ffjL1bKfl
         GHSJ6L/YCSOAMtrzswavJOTFvedBSDOXCRdTpYe1hClqo03m5xZWtY87rlKG0QsMKgjB
         ZslThJWfzfWtQ54H4qTWTQdWvUKcJ+tOdhbYjyRRrzBS73wpGsXThidQ5CZJQw3LXZYF
         /hf9Fp47UHhge/0eViIwzpjwR5u7k+wkLxPpGi2rgq+7PHyvlWMRm8ul2JBuwyFnGKUP
         OToTjLCXlZbPwymTwdZixrHCWwelvGS4G/iUWiiTz39x1RGrl7bCMJy+HKuB6R1W1J1W
         oTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721250; x=1727326050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5Ewnrr/qjz52ggXP5z2OAFJ85TodMlAQJmzdk5fJ2U=;
        b=h8ZrjiXy1uRLySxRRmJFCWwmq1j14+4ShJLlLXwl3isLdmwO3CHKgfIP430990bly1
         pJ92+MwUDW6a1XOEw0rKZ6wtG1qD1MmS27JmiXkrzmEe5TUp2n07X3+tRfatD06rzfcK
         Tq73G20anr35z4x8wOebFDT3XbSN10tVSt6Le4uF6sYwNubWFxEMKzrb8w0+5vsLowK6
         7J8eiS+d/gmLMY8oLyYp6szjHmoPnV4f17r/at0WIrlGYB4cO6JJ5wU3r8pnvZ5q/4Xi
         lbr7oJdoGyIG6FBHpdHDIhr7P6689ItjoF2yZ0kZwL73NuPjnoaoa2UiYzH/SdXHtLDy
         NHYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe8g3B/lOyz02S+21oIW+6iue0skbidhaSW/SkI+Ry+zpPbU9JlgvHvalM5LqhhNNGzh4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhVJK+Qu/sqTM050tzjIfqTsdANkiLuwGfu/UjrhG22acs/oR8
	AjsIfBFGmyaCuY7CsPnIm8xyyC/BYAqpN5AiLbG9ersf+ohj0AFNrKkcZpo9MDA=
X-Google-Smtp-Source: AGHT+IHOtMj/Kr5ExQ1Dywx7ERrNLhz2hVxVxQFKG+INI6zzOgF8wrQsA7qvcA3V9hiv+CFRCBs7cw==
X-Received: by 2002:a05:6a20:b58b:b0:1cf:3838:1ed9 with SMTP id adf61e73a8af0-1cf76239c73mr33120242637.50.1726721249781;
        Wed, 18 Sep 2024 21:47:29 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:29 -0700 (PDT)
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
Subject: [PATCH v3 22/34] target/riscv: remove break after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:29 -0700
Message-Id: <20240919044641.386068-23-pierrick.bouvier@linaro.org>
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
2.39.5


