Return-Path: <kvm+bounces-5549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CEC5823352
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F8CFB23CFD
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E3D1CFB6;
	Wed,  3 Jan 2024 17:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NB8PUlZ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB411CAB7
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3373a30af67so3024799f8f.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303239; x=1704908039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1rMPXmtlBiD25TB/VWS9sZqi6o6l7wGlXBsxO0xhRU=;
        b=NB8PUlZ6bVxhuhiVLj8qO1jbM+vhPVvaow3KloYWFEm06x3GC+bf77/sNoACUBxGZt
         ptipRvu6RXcNNBoKGCe515Xn6dBd6HW33ceS+dKwlzhUtsxnxPlG8BbVgI9mqh/d1TD6
         lL3QM43QC1jm18rfOzbBeRf3gs1CoFbY4Tub/M0FWONToflvXsBi/euscxaxeNp/mKpy
         mVQfZhB1mhi0WY0p/2MBSHDCoexqVLL4w+wP0PlHI9m+fOaJqRoRMYoeUIfTO9347TIL
         8D+PKxeyyDIZn7b4OU2rvpVbHn2u7A7O12hguabgSByd6W1jK/XztQsLtA1yV0J/wa8l
         P+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303239; x=1704908039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1rMPXmtlBiD25TB/VWS9sZqi6o6l7wGlXBsxO0xhRU=;
        b=FXsyM559ugyeFpgQykyikmYLpD8s0liUd1kOvq+KzggQFPGqEFLY4Dimix2OQVLhCn
         oHq7cEytKzw+0fy0QqLtwowrQR6LQ4jrJ1yBuTm1rUbJsnuY+QdroZUXxqAsrT5SAq/0
         KaJpLPVkI7QF0wLgWCxryWT/8zzivwaEdm+q+B2vs+WRnKc0LpEtCx51O/xsKYSJx6tm
         Vj0jt7Va4P0GvH+O5QToapUt4ywqRK5WUo+o5Bm/Ke875TGlWusWolPkkMEysPWMcasB
         axaPtTOammRG7ztPW7nwVt89IMMA0n1wnZSWLTHljS0GQ5akdCGmKyt8/I+udrtu6UZ8
         csAw==
X-Gm-Message-State: AOJu0Yy1gHghrVvRhycqu0QryhmgN8xRPi76jfeOz2ueolWxNFhlBvzF
	f64QdW7MXJQr8GH/3igeraYECDk/+bNRmQ==
X-Google-Smtp-Source: AGHT+IGoegAEw8eIc6J+w1ZnlPQQhLp8Eo/JAhJe/joDQxXfuS1B+vbw8iKXZSou7llER/sVL52p+Q==
X-Received: by 2002:a05:600c:4f15:b0:40d:8557:9266 with SMTP id l21-20020a05600c4f1500b0040d85579266mr2005442wmq.23.1704303239306;
        Wed, 03 Jan 2024 09:33:59 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id w13-20020a05600c474d00b0040c46719966sm2952760wmo.25.2024.01.03.09.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:33:56 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 56A705F940;
	Wed,  3 Jan 2024 17:33:50 +0000 (GMT)
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
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH v2 11/43] qtest: bump prom-env-test timeout to 6 minutes
Date: Wed,  3 Jan 2024 17:33:17 +0000
Message-Id: <20240103173349.398526-12-alex.bennee@linaro.org>
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

From: Daniel P. Berrangé <berrange@redhat.com>

The prom-env-test can take more than 5 minutes in a --enable-debug
build on a loaded system. Bumping to 6 minutes will give more headroom.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
[thuth: Bump timeout to 6 minutes instead of 3]
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-8-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index ec93d5a384f..c7944e8dbe9 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -5,6 +5,7 @@ slow_qtests = {
   'qom-test' : 900,
   'test-hmp' : 240,
   'pxe-test': 600,
+  'prom-env-test': 360,
 }
 
 qtests_generic = [
-- 
2.39.2


