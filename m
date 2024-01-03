Return-Path: <kvm+bounces-5581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A07FC8233C8
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BA611F23268
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C731C68E;
	Wed,  3 Jan 2024 17:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JwS8TueL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAF71C296
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-33723ad790cso4126822f8f.1
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704304146; x=1704908946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6SqdFcQlAJfCo/zD79U6TVq3bxpUqFYpwmC4QorajEA=;
        b=JwS8TueL+UtKELeg5mu79+APQavdn9Z/ZdGQ5TCZ7OuSxV6B7tGxVffN2bypXp5R3Y
         tDWQLADgoy890HpWTaA/m0hq+9e/Q9Pj8RVgxhiiFLU60Lp1VaxphG1GxUO8IKFutXxB
         dqo2+QPHTi/a3oz9nL+t5YWZh4ayrXU4po2GHqQX0H/JlTAXXMQqO+qrm1LWwWFMgQga
         FPyVCT6lRLCtTzMS7OAPS5MFt7Jvw43KQcpdeBq2yhsaHXxd535PnLQ2K0AyrT5zIZRl
         Xj6MFvsSGb6h1l+rJ0Y4840naFScXWO+H/sASXH+yQ8zs15BF+DBT+BPIgK9o9QM537X
         Hdww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704304146; x=1704908946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6SqdFcQlAJfCo/zD79U6TVq3bxpUqFYpwmC4QorajEA=;
        b=AcTnfkfke5Fg0H1UE6pyVkkA0kN+CNRCBxo7JZj8jvSmmNvZmvyC/ex3wu9D0/OoOa
         oynLxgy6qPjq3mtDhcp1DppJJAP1sdwsOvI5RCkZ1Z2P05RIcDTfGc3mclq8pLXrcKAU
         EAQvgzDjZpTJgkYhEFNxygZMrhn5emnYtF6sVfbmaPz27zWXlAKgJfY7n0ZHUbw42jWu
         tLs5o9h7kTTwlbU7U9GwtSfrY0aRfooQUyANYEeunJ9f6PlisY7FVuLuIYNLrfVxUKzx
         rWaMqVVWI8HRjS/XO9l5IhVinIzm7NrGGZkqeFY4wnL7OW3vRgbSoCLLXocBdPjlDPJS
         J/KQ==
X-Gm-Message-State: AOJu0Yw/sWmyG0SiobOjHR4qy28MnnYWRkotdmden5GOFRebDi4n/gzt
	IUGIDaEgVSyGRBHFx+rrPAeOPBqIbepouw==
X-Google-Smtp-Source: AGHT+IEJ8pbxuaW2ajiIhIsjZLjKvMEndaRM5euTVk/mz6c4/+Ko8TKlGfHnO3Mdder+FMkZ6TvagA==
X-Received: by 2002:a5d:47ac:0:b0:337:4a09:b7d8 with SMTP id 12-20020a5d47ac000000b003374a09b7d8mr916886wrb.211.1704304146266;
        Wed, 03 Jan 2024 09:49:06 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id b15-20020a5d4b8f000000b00336a0c083easm26789106wrt.53.2024.01.03.09.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:49:05 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B41EC5F9D8;
	Wed,  3 Jan 2024 17:33:53 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Bin Meng <bin.meng@windriver.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Laurent Vivier <laurent@vivier.eu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Brian Cain <bcain@quicinc.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Beraldo Leal <bleal@redhat.com>,
	Paul Durrant <paul@xen.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	qemu-arm@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	John Snow <jsnow@redhat.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH v2 43/43] docs/devel: document some plugin assumptions
Date: Wed,  3 Jan 2024 17:33:49 +0000
Message-Id: <20240103173349.398526-44-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103173349.398526-1-alex.bennee@linaro.org>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

While we attempt to hide implementation details from the plugin we
shouldn't be totally obtuse. Let the user know what they can and can't
expect with the various instrumentation options.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 docs/devel/tcg-plugins.rst | 49 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/docs/devel/tcg-plugins.rst b/docs/devel/tcg-plugins.rst
index 535a74684c5..9cc09d8c3da 100644
--- a/docs/devel/tcg-plugins.rst
+++ b/docs/devel/tcg-plugins.rst
@@ -112,6 +112,55 @@ details are opaque to plugins. The plugin is able to query select
 details of instructions and system configuration only through the
 exported *qemu_plugin* functions.
 
+However the following assumptions can be made:
+
+Translation Blocks
+++++++++++++++++++
+
+All code will go through a translation phase although not all
+translations will be necessarily be executed. You need to instrument
+actual executions to track what is happening.
+
+It is quite normal to see the same address translated multiple times.
+If you want to track the code in system emulation you should examine
+the underlying physical address (``qemu_plugin_insn_haddr``) to take
+into account the effects of virtual memory although if the system does
+paging this will change too.
+
+Not all instructions in a block will always execute so if its
+important to track individual instruction execution you need to
+instrument them directly. However asynchronous interrupts will not
+change control flow mid-block.
+
+Instructions
+++++++++++++
+
+Instruction instrumentation runs before the instruction executes. You
+can be can be sure the instruction will be dispatched, but you can't
+be sure it will complete. Generally this will be because of a
+synchronous exception (e.g. SIGILL) triggered by the instruction
+attempting to execute. If you want to be sure you will need to
+instrument the next instruction as well. See the ``execlog.c`` plugin
+for examples of how to track this and finalise details after execution.
+
+Memory Accesses
++++++++++++++++
+
+Memory callbacks are called after a successful load or store.
+Unsuccessful operations (i.e. faults) will not be visible to memory
+instrumentation although the execution side effects can be observed
+(e.g. entering a exception handler).
+
+System Idle and Resume States
++++++++++++++++++++++++++++++
+
+The ``qemu_plugin_register_vcpu_idle_cb`` and
+``qemu_plugin_register_vcpu_resume_cb`` functions can be used to track
+when CPUs go into and return from sleep states when waiting for
+external I/O. Be aware though that these may occur less frequently
+than in real HW due to the inefficiencies of emulation giving less
+chance for the CPU to idle.
+
 Internals
 ---------
 
-- 
2.39.2


