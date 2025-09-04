Return-Path: <kvm+bounces-56776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F2BB43525
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E20101C83521
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 673A32C17A0;
	Thu,  4 Sep 2025 08:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TcYGeCHY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFEE2C158E
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973503; cv=none; b=C/bkPG73puGCnx6e6vFMp7aDKY5bgvyrAQYAPl2+ToLSy8nfYdZwBR5XT5xcZzKD8an2q1HhllRbUBl2wTxEH7O12PaCakwnWAGwwXM1abg/VgzBPcA1cX7kytNhY1Eqm9N1d1XrL6yUjyObVOCHrtpLforBce4FVSVJ8ciz4CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973503; c=relaxed/simple;
	bh=MH8lHfJJTUl+IzdkOhZKDn6JSTFps1XryAlX1AbFmeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxX92v9dIjie8vCEG91s646StKLDW5zh6XzXOBE2g44ufccWb/u2gjkCD6mkMryojF5AhOJ4UQ1OP3AlFge5LmFPg+JKRPWoGFoW97/EfFDq1Xa+KLa5h8KoIWmesoN7QlD8xE6BvLt/A7GXorqyjmsENv+jpR4C3/+Phv1v4Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TcYGeCHY; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b02c719a117so132835366b.1
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973500; x=1757578300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YHrtANvKFxNzkcAR0b6AvL2FoL97RQya7kVY684YbqM=;
        b=TcYGeCHY7kqt7zoIDZ5oXV4NCF4A6aPqMRitksHLl0XfC8hp6EEUOW9Prxd7g6wdoJ
         rt2Lt4bDUKpJwCUsJMrA6QrHTviJpwVc3ef7+qORPWXLdx4Z5RdeD1wdEmwhXd4RedlN
         eH9hQk2h5GE6jF5k1Zo2UrXxvydSRuNsxYOdN+9XkydXFEyacx7LGLI3M28fT0gvndjB
         88nL6TahmfGBPOmboXHjEAiEuK0adNARzujIrS5GZ6DxZusmNQHpIMQdZOionf07Z6mA
         IyeRkbP6O3xGXxygD8TMu98Pzvcp8lDPEsfyw2HIjYftv0yDrZSSBwMMEt6ecL81hCpf
         RlDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973500; x=1757578300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YHrtANvKFxNzkcAR0b6AvL2FoL97RQya7kVY684YbqM=;
        b=tJrmyOCpugimZhPihbo3mgnhREw8YpUbtP/iBPF0EYNZyZWF/JuAc8CdUwKFivWIjP
         4//Di5Xa4Mnt2z8KG4jI40pVPbohDXMkYKTbNnmBqP2G+yP+B1kcAgxkD6+Jx6csHjsW
         0UaBd+229zn3O3pL4JoxGxL14MG8pkTcw1TZZzbZhv9eBm1bv00Hi2Qm62Ht3U9LwaCI
         wVhqUo64fx/8Vwj/WG20xbmqaWVNUGUYlIvGsnSHq9M85c05gAI4BxoZZJQ3vBJEEI4A
         zB0TkNrAGnBqFKBDtSwqtExWTWhROoxQuyTP0O2rqaWe+N+t1aDMMghNUGqpA7qQr6Xc
         j69g==
X-Forwarded-Encrypted: i=1; AJvYcCVddK77IOdPBKiD6DxvE2mgNlhOgQtlq4b2xwc0p0KAnyo9UB/ZpeH/HQ5bIdPp5rFiwgM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJU5KAEhl64yPzDjYr8mppJKd1z3Dp0DPD48921ueerRyQgDwQ
	6+Fccm+1lgonP2yEI8jyeZjI6v1ELy7xFTMCIypcTS6w6pP8KpSaYzRIircM41mRQik=
X-Gm-Gg: ASbGnctE+07D4lBmABzKZ9XWONSEgkNOrurzh7gXjShC77kHAPFF9UGOxUC9+i++W3N
	KAaTzTMUkc09bFLovaOF7qE6wiDFCeAcs0milVDS9mQ3qt40oTlHlCBlRpscj8ayo2a75zO1/mq
	u2PY44ia5bNltc/bo0bKnFKHdExXHtdJXqxLimWy3OS0TGW1USVTJgwoIuuQRgbT2imdJGNLMbm
	BCejGks+x/1C8Pqg/Aqn7enOTESZr1DWnII30rZn8EUq2ojnTMXFBYWjOsMB+56HPcN1ObwKDLE
	XcTKPINvwxAGeM6GRgwRlORBqGgvGu37j3Z0Llk5eM8Nl7xeLfIi+sQvFWjrkvk6zacqlDvKN3p
	BMu9m7o5Fxbsgf7/CEjazzCc=
X-Google-Smtp-Source: AGHT+IHWlLajDsQ384nIBXustMLg5QOay+NZ7bnHzT4T4G8CTt2TPFaQ6+dQTw7Hxia/vwaMzjizQQ==
X-Received: by 2002:a17:906:12cf:b0:b04:11e5:9a8e with SMTP id a640c23a62f3a-b0411e59b44mr1462147366b.40.1756973499887;
        Thu, 04 Sep 2025 01:11:39 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b046d420e02sm306741066b.39.2025.09.04.01.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:37 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id D1C1B5F93A;
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
Subject: [PATCH v2 006/281] Update version for the v10.1.0 release
Date: Thu,  4 Sep 2025 09:06:40 +0100
Message-ID: <20250904081128.1942269-7-alex.bennee@linaro.org>
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
index dadcbd47d3c..4149c39eec6 100644
--- a/VERSION
+++ b/VERSION
@@ -1 +1 @@
-10.0.94
+10.1.0
-- 
2.47.2


