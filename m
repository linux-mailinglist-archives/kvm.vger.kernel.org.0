Return-Path: <kvm+bounces-5040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E2E881B3DD
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:40:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 669171C21667
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27F37609D;
	Thu, 21 Dec 2023 10:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jp7Ny4HW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE9F745EB
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40c38e292c8so3440035e9.0
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155119; x=1703759919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjgnYFLBOv5uB2tWkg/kIZdJs8xT0wOiNJtUez299cQ=;
        b=jp7Ny4HWqCTibwYRk6glyOqx9xDBthqzbsxV5NBNxHVPQTfdG8A6Q2IYmGMJgZsuD2
         ZeigLF9yNViJ+lSidGawZZTDzuNjyZdVdpuDadjxy0h03JEONb6Tawqbjt4oO+gybu96
         wx9qaWaR0qjVC7PUsdyCuI7UpQot7BKmzYCl+HM0tftYxZwWhs+3d5MNoqBo342vNy/X
         MtzdOXQXZvh+TrBMki5eUY5fHyy/CFtNgBkB7ts94MdJEzdeM6xKUGYRESxUiUW9lxC2
         C5z6d8gr3tNkCX3Gs2WpMkX2l9+xyKMQ2IlcfjvhajYjQQRYfykOYvalKO9JR94ECqb6
         b0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155119; x=1703759919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TjgnYFLBOv5uB2tWkg/kIZdJs8xT0wOiNJtUez299cQ=;
        b=IGuExANn1BLkWQAXrWNYHM2TUYbGZAqbv3kEpkkPGc8FmkrBnWQFo9V+8hadFDYT5u
         u6EekYVquM8mKMYQ0dr9/7tLSprWmAtmAXO4etBkg52Ut4PQoaaSXhZSG9L2py8JgrI4
         yLUGNwG3NWV6GAvqOlZWjMKrgFfLQYiJie1nbz0jDfwJC4m/6P5jyVeNNIAZnDtea0oZ
         dmNgqGrfZRHcucsyUA6vO1Js/OtVJ7tZyN0zEQh0skML2NiBYShQn6FotF/5xwdXkFyw
         urvmyujx2U/QfJ9Ez3Ulwg00ebPJ9c2/756wKQFL/GRjR2yXO+Qnr4BKidypS/hMCSSt
         jlRw==
X-Gm-Message-State: AOJu0Yy0FWxbAo0+BdBJRdr29zRrB8ZkjrhRV2hH3TCbwQZJfvCYQmAy
	uXvTfdg7e89J5k5r2RsHYycEvQ==
X-Google-Smtp-Source: AGHT+IEzYxVwlU5vLXnRXYLYc4mdvFjddVid7e+dmI0N5Jhfnqq4QSDEATHx8NRbGDzvJadlAOUBtg==
X-Received: by 2002:a05:600c:35d4:b0:40d:3ff7:9bd7 with SMTP id r20-20020a05600c35d400b0040d3ff79bd7mr273696wmq.143.1703155118806;
        Thu, 21 Dec 2023 02:38:38 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id w19-20020a05600c475300b0040c4620b9fasm2789726wmo.11.2023.12.21.02.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:34 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id D5F765F90D;
	Thu, 21 Dec 2023 10:38:22 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Brian Cain <bcain@quicinc.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Cleber Rosa <crosa@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-s390x@nongnu.org,
	David Woodhouse <dwmw2@infradead.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Thomas Huth <thuth@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Richard Henderson <richard.henderson@linaro.org>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Bin Meng <bin.meng@windriver.com>
Subject: [PATCH 38/40] contrib/plugins: fix imatch
Date: Thu, 21 Dec 2023 10:38:16 +0000
Message-Id: <20231221103818.1633766-39-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231221103818.1633766-1-alex.bennee@linaro.org>
References: <20231221103818.1633766-1-alex.bennee@linaro.org>
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


