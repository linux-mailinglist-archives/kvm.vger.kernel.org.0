Return-Path: <kvm+bounces-56779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8856B4352A
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6AC76884C8
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7762C326F;
	Thu,  4 Sep 2025 08:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kbG5acIi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4882C21D5
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973507; cv=none; b=j5+rzpbO1qqnRjSo6w+TjlRFrHdlYmrAOE6PC0LTMLoFJIIwrrpYrOmdmwDrztDLLH0aw6CjloCLFq1tXisz35SYIPmuVSuQ1c+9rR8SkuAvFGhx/RnpUxciOtX+m3PTmFGjdXdCpkunLCFwldpaQnrAXUG0qIC1WGshs775jy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973507; c=relaxed/simple;
	bh=BQMNJSFYDOADxPmjE7KhCHj8ong/Jy5m8lGgFICBako=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeyCaUKhytRbcX/ZYI5RHWdkjNBAKDJUxWkUebRvzObrZX7auoYwG3hr8U0fBqL2LzTvTo8DfUTrMV2h/sL4RFNrczhvNM8nqklQS6+BlIenNzPqt6MAVR7zM15gmv3YO1SDmCMeP7IGORoDU1o+Woxs68+2qybvcmtd4q8gOto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kbG5acIi; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6188b5ae1e8so921236a12.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973504; x=1757578304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=myCatgpniSey/NjO+dQuRIOhbIuhsJO0uetvy2+5HH0=;
        b=kbG5acIiF5n9tZeuc2OnhkLxiHYZHxEh6WkSAkFYS5uKb3HlFGVBJCYF0ZLkEiU8Zz
         cIRvvdgQwqoB6YIM0b8afv9lpoUVFcBxRezcFVYZY6gMQXtV9GVYIngG6aMLOv0E1CF8
         zND8Ur9VmUxdYs2BnJSvU6+VzcF4tcvRGuuu+ets56E3V/neMK3KlhYDiTw5UV5Seho4
         BFAcdLQnCiMoY00noG9hhHyvItwzGr2zIkvUMBiakd6gfVRcQDaftHjBLb1REyKANYfy
         Z0/e4wh8qcFGtDoY3VSJa6HDpbeGQ+Uo4TpGw8PnMno0+Io1xYFZnVTmyVekZzHQKfsL
         /0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973504; x=1757578304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=myCatgpniSey/NjO+dQuRIOhbIuhsJO0uetvy2+5HH0=;
        b=FdI49uIfwc0h7mO3zV1/+8HRpU4H7eViIdw4azk8XkpmB7i7exY6hpHdcDQOMolA4+
         kLtEV0GfeKzCPl/Gocrm9PuNJFWUvidx+0HgXJQATVlNzVQh75A7Jai19BjVsRB09WHO
         wcAjTLv2a8rINMi5ZNohW7LwV0QbAGj0F8idN8nFQ1nuDnRyfmicvB9uLGDLLRyqEse+
         3x7GyMRt17IzxDlvxf3wE3xeynM0g+4amJgjjILjKwRoDpRtJv+f85RHkeHPNpOFV3Ry
         tT4iAKDKz6tP91+UmCd2tv/MMwDSzU75UR1FGkRvkuvfDLCkpI6mCgZfhF9D9f+BBuye
         cIHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrQSeIVUhyE6wrRgM3XMdTrSG1RIb9J8c8q0H1gTwkHPnvMMa2ilqxVA+HpQ552T+sTA0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi92Ak1dT5nZXIyEpyVwNMGw6WiY22PiUM4TT1dbceyKhJEoM3
	M77xQIvdpRC6MJ5ROKzlY3WtpADloToHHJWFQDy4NSjh5NUleJZN3wO7FGCNID7PTwY=
X-Gm-Gg: ASbGncvDjk4wfsCDBntexK++x5I40/QxCvgIiye8IwFlZ9e4YCKkT/G4EIYwXN2xqx2
	CqjN8UuFCwRUsQxgOS0gNLnjNJfFPXe+IaVFdKMbZm1HexGLBGPWLuTq6MbpazxmwPfedJO9IBD
	2khsWM9OvVKoh/BOJtHmnSHuQmOHpA6dbBzvIEE9TIqAf9nprkpXCC3pcIlQYlf45wxZcC33Rdl
	s5xFQ0PaOVHbYN7jTs1K/W3dIBFzdZRVIWitCyx1E0JiUXWLH/CdKbdCns4c63fdSgb4TsdfhMI
	Ii1pICRuixqurnaD5UR1zhH9Ix+dW9ay2mCSfKN6xJkP7WH1gzjF057nCkmsS4FK5DqjD4wadf6
	rxvAp3cJkrlocAON4a8q1vDM=
X-Google-Smtp-Source: AGHT+IEkvYRALNYOlXlCh0M9P7tOTgw2dIkqwHytdvjqGaEFKKMvexexT1+4HGfULBPkmc4HuBN2QQ==
X-Received: by 2002:a05:6402:40ce:b0:61d:cd5:8b6e with SMTP id 4fb4d7f45d1cf-61d260cc220mr16736785a12.0.1756973504083;
        Thu, 04 Sep 2025 01:11:44 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61ede659366sm2877110a12.24.2025.09.04.01.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:43 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 16B025FA31;
	Thu, 04 Sep 2025 09:11:30 +0100 (BST)
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
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 016/281] tests/functional/meson.build: Allow tests to reside in subfolders
Date: Thu,  4 Sep 2025 09:06:50 +0100
Message-ID: <20250904081128.1942269-17-alex.bennee@linaro.org>
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

From: Thomas Huth <thuth@redhat.com>

We are going to move target-specific tests to subfolders that are
named after the target (and generic tests will be put into a "generic"
folder), so prepare the meson.build file to allow such locations, too.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20250819112403.432587-5-thuth@redhat.com>
---
 tests/functional/meson.build | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tests/functional/meson.build b/tests/functional/meson.build
index 356aad12dee..8c24ac1cc2d 100644
--- a/tests/functional/meson.build
+++ b/tests/functional/meson.build
@@ -423,7 +423,13 @@ foreach speed : ['quick', 'thorough']
 
     foreach test : target_tests
       testname = '@0@-@1@'.format(target_base, test)
-      testfile = 'test_' + test + '.py'
+      if fs.exists('test_' + test + '.py')
+        testfile = 'test_' + test + '.py'
+      elif fs.exists('generic' / 'test_' + test + '.py')
+        testfile = 'generic' / 'test_' + test + '.py'
+      else
+        testfile = target_base / 'test_' + test + '.py'
+      endif
       testpath = meson.current_source_dir() / testfile
       teststamp = testname + '.tstamp'
       test_precache_env = environment()
-- 
2.47.2


