Return-Path: <kvm+bounces-56774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F6B0B43519
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:12:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A89B5A13D9
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01B9B2C1583;
	Thu,  4 Sep 2025 08:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v3LBeKJy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560EA2C0F8E
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973502; cv=none; b=UBXfAIN2103WfNCjUfBSe2ga4u5mvFkNZuVb91mXpYKJekcS88knepDBjgUfTH6EXbAtWD4lliQikC/g2J4sNTdiojh6JWXIos3X/+6fc62tHzyKLRtJUMv+vMVhPEC23Ml6cOyYksy57fS87rhNTXz0/10DWT/jgzIl99aoqew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973502; c=relaxed/simple;
	bh=B34MyvIdNoAzlkhE9CwLIM2ehaejkaBF4in9KyFUfe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8YkjBHArjHrhu9+rwag2WydK43xQSYPocVQJoC5hBIHztk86U0v0ORfuxpzObtq1nXFRy3jZ5CxxeEoj+u5pWYokFSwOQNzF94smxZPBT7pZRXmUGCOKryNjyVdbMyyhphTBm45c+QJkHCBLFNJbQRAzhSCDbW6vxnOKlEfSLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v3LBeKJy; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b04770a25f2so102691166b.2
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973499; x=1757578299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JNutAIaXOMQtmCL/HAblUioHloxc8S7R+7KvtZJ66hg=;
        b=v3LBeKJyPZIwDmwOJ8wYccGEEQGHsTFJpnKx//dsdE7mIoZJpNA38X44OHsJUSSkPS
         hXhvBkuypiur8dKV9kTi4ooIvaBCFriG0vmF1VSeT5qy3NZhrdnLAkm4p5iEY/7DmY49
         8IMKqSMlov+HNOFpecjFhFshxjaSjYg3+8YcSJotgVryWYISm8F/afmDJYGVnwpeXavY
         kBC6oCgU2GlAodxipXyWfq5TSTvMw45pFv825Y8DkRSWnArC7eWTv2sY8wKMU6965zU7
         DMLfr0t2jkpnd6bZpVAinTxQFiOdjspcQIiXFbK6x41bZXzV/+mPDcQDX9xZ36JFzDqY
         9JjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973499; x=1757578299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JNutAIaXOMQtmCL/HAblUioHloxc8S7R+7KvtZJ66hg=;
        b=mN9diM/HH6VdoMHUllHvkb7z9pw3ycwMDwi4nImHrL0oQFYaEtB8TcE37ZlboTAi0h
         IURVQJ79nHpPQ9w4COTzHpD1Rs2dygb9rLYpuDJ5w9Gw4MGYHbz0swMgCd/VhZJfRSGd
         0mo43TAtOWnRKewGBip+oAGvrmWAZKjdr8gdD/zVs7WADs/Mo1jTmmlX/cogaHHlXPnC
         slslk71SKd0Kw6gkWh4YiDYO+K6h1EyAp3JN2qnIhJTbU3W9vGkwEiqmHKnjE8fTtd+i
         JLv1bp4QJt7KjbSsQKQlOxK2N5RDI9G0UEsP7aihgSdxaoIA9koZ/meDAfuFgsrIs+i4
         /fiA==
X-Forwarded-Encrypted: i=1; AJvYcCXYEO2i33ivrKrQrRmgR7HQQi+nLZbgKq8QhwnfVDCltz/TEYFJQMb3tEZGzCyYwce4Rws=@vger.kernel.org
X-Gm-Message-State: AOJu0YzebI1R5GcdsqfNuhQlTB2AKOAlaME1CFcQPg/d4eqqRchWDMvD
	zNtfMlEDKb8g6mrzgzYS7Z5cSBUIK5t+o+rwTLbva1nlBZOJiDo04ffR2wC3VLOI9O8=
X-Gm-Gg: ASbGncvtqqdzUYZGSL8xrhByUhxIRDw2Y9bhzDAZaoW+tks4js4fQQDHCHJEvXg2NYu
	e3rDyI2p9xVU3rVYPhCq75eUwGLp1L9HqF9KSphis79ed7dzn+9YXODLrQeYLCZC5AYm7pecwqk
	UBNfOE+HWpkzVUwCBvqNmcsFVcXfRSbBHkAVHyde1Am7llO/fVqdr4Ov9N8Aog+gpAP1tQn3SJ7
	5O5837Wy+B9Q20unP6Q3VXD9DoOQfPIbJQa9NJVo1ILRe9S18sIumYsYXE/evIeA3gv8ySqQvw8
	BoC2oeojJRJ7QbVx19YnuaF3neKUgal/GXt+j6qKQo+OIq9sywr4ZQdNzlvQG7YabJVoA5UDfrH
	L+eF9ob2XBG0IWXfpiJsrsSO2JGRhoNQVWxhYSEA6ZMcS
X-Google-Smtp-Source: AGHT+IFJkCbW6+YbkwCqXH5HqGu4cDJmqLYEEKmaO7rAylz2zE8LC1W+s4a2pcKUaXmJqvD/qrocUg==
X-Received: by 2002:a17:907:948a:b0:afe:93e2:3984 with SMTP id a640c23a62f3a-b01d8a321f3mr1572672866b.8.1756973498594;
        Thu, 04 Sep 2025 01:11:38 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aff0971379esm1438937866b.102.2025.09.04.01.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:37 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id EA7D95F93B;
	Thu, 04 Sep 2025 09:11:28 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-arm@nongnu.org,
	Fam Zheng <fam@euphon.net>,
	Helge Deller <deller@gmx.de>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-rust@nongnu.org,
	Bibo Mao <maobibo@loongson.cn>,
	qemu-riscv@nongnu.org,
	Thanos Makatos <thanos.makatos@nutanix.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Cameron Esfahani <dirty@apple.com>,
	Alexander Graf <agraf@csgraf.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-ppc@nongnu.org,
	Stafford Horne <shorne@gmail.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	devel@lists.libvirt.org,
	Mads Ynddal <mads@ynddal.dk>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Peter Xu <peterx@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-block@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Kostiantyn Kostiuk <kkostiuk@redhat.com>,
	Kyle Evans <kevans@freebsd.org>,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Warner Losh <imp@bsdimp.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	John Snow <jsnow@redhat.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Alistair Francis <alistair@alistair23.me>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yonggang Luo <luoyonggang@gmail.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-s390x@nongnu.org,
	Alex Williamson <alex.williamson@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Michael Roth <michael.roth@amd.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	John Levon <john.levon@nutanix.com>,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v2 007/281] Open 10.2 development tree
Date: Thu,  4 Sep 2025 09:06:41 +0100
Message-ID: <20250904081128.1942269-8-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904081128.1942269-1-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stefan Hajnoczi <stefanha@redhat.com>

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 VERSION | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/VERSION b/VERSION
index 4149c39eec6..9856be5dd98 100644
--- a/VERSION
+++ b/VERSION
@@ -1 +1 @@
-10.1.0
+10.1.50
-- 
2.47.2


