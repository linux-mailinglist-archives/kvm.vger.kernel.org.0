Return-Path: <kvm+bounces-5564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CBE8823384
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BFA01F227A0
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8209B1C6B2;
	Wed,  3 Jan 2024 17:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WiyN934h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6C81C2AE
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40d894764e7so25111475e9.1
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303548; x=1704908348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjgnYFLBOv5uB2tWkg/kIZdJs8xT0wOiNJtUez299cQ=;
        b=WiyN934hFFJVgf29/LTKU1dmEE+URfFeQ7ceRCEAk7HXiaAG7ZgyqvIjFAsJ2Yaldj
         CdSGzlPhivRfWDId6COeDn5Ds48iAqwibdITUR3SuedhIsek+6czuWWRx3zK9IlWgz9C
         CoH+yaICIBlfR2ywTxmJk4mJCmk1oliUcOZm2G9IXZmMcU1ydKyzj6DHU/CNS31n4528
         K2vF+9TUz0RkzT88jhqUNrV2A34KJm4uEuhk4OoDovDxJvIcVTBVa2yEXaAAQP5CZFYR
         Gc2iz6dq+cGWZCu0nbyAnfqQ863jINYQAxzcM7gJ18R9hmXZ3hWe1GRAFU37l7lDs3BP
         FdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303548; x=1704908348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TjgnYFLBOv5uB2tWkg/kIZdJs8xT0wOiNJtUez299cQ=;
        b=eL7yceIvl2pl2aGd0BWdsHH3apTLsBETvnRn/jSkSzZnJgU6g7vJU/8rxu0ZFh8iZu
         K4jl4OTwEtpQZAO9i9cWIG5ugWHjcevQn1h+ncXH5A+dvGkg70j16iEncphgVPLfDcwI
         vWu/7yN91xFGsb8r75MsMHjI5cUopgkYBvbdYnZpfn/48JQFtjOqZImLDVwzPVxwkayu
         XaoNpOaHJdjp+U8HNhpSuIYett1DRg2XQm0txrs6zQ+DWq7669lKt0rP9TJJFNQ+PzQK
         +zkMtK1iA/+PmqcSS+TLes8PoJZXpojt4oFm1Fmdz4a7TI2h8WapcMacqJzuGmagrYoC
         WS3Q==
X-Gm-Message-State: AOJu0YyO+U8fqCwR0sB8qOLgFSFwUhR61QYWhzIWdw5aPgOzCZ5ZpsF7
	6x1Rg9trGbFlu46dKkaldGlwi/3YCzQUyQ==
X-Google-Smtp-Source: AGHT+IECwsD+EsV7hgtfvLIigahdUQBBQ70d0NAK/wXl9lkOBh690IpgKO7C8ioQ4D+awmSxFlPX5A==
X-Received: by 2002:a7b:cb92:0:b0:40d:38cd:ad5c with SMTP id m18-20020a7bcb92000000b0040d38cdad5cmr6656970wmi.263.1704303548411;
        Wed, 03 Jan 2024 09:39:08 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id i15-20020a05600c354f00b0040d604dea3bsm2972869wmq.4.2024.01.03.09.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:39:05 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 542725F9D4;
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
Subject: [PATCH v2 39/43] contrib/plugins: fix imatch
Date: Wed,  3 Jan 2024 17:33:45 +0000
Message-Id: <20240103173349.398526-40-alex.bennee@linaro.org>
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

We can't directly save the ephemeral imatch from argv as that memory
will get recycled.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 contrib/plugins/execlog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/contrib/plugins/execlog.c b/contrib/plugins/execlog.c
index 82dc2f584e2..f262e5555eb 100644
--- a/contrib/plugins/execlog.c
+++ b/contrib/plugins/execlog.c
@@ -199,7 +199,7 @@ static void parse_insn_match(char *match)
     if (!imatches) {
         imatches = g_ptr_array_new();
     }
-    g_ptr_array_add(imatches, match);
+    g_ptr_array_add(imatches, g_strdup(match));
 }
 
 static void parse_vaddr_match(char *match)
-- 
2.39.2


