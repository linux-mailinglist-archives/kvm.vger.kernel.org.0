Return-Path: <kvm+bounces-56793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52250B43533
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:14:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12F9F16A6A9
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8C52D3EC2;
	Thu,  4 Sep 2025 08:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Oe/dA3g/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9142D29D8
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973533; cv=none; b=Y2ssj3aY8J2wkY5knwgU1MowMD1hq6e+CZv7hx1w0sDxhJo9WF3sXp6fkQBGegKTvsKWuM8YfjOog4hC2arym9rgfr3I9TS+Zrr7XWb7HoUiCmsas4dclhlUDvHfDsuaEnJdk9KndNH+djxLW6ORvimExsjMzL/ons6dgyOd5LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973533; c=relaxed/simple;
	bh=H1u0xIrHRBsI5iBWiPGxvfuroguBcudIhZAGEhEwpfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1+6rGg3JHpF7dCvTSCEBw0tmGzjg0guRSYOOKSrx1endphp8ItF3dbbgj+SDNoBlC3li2yvCODEuejR5jHPgfFo8HWrB5/7+8DVAINjaRRSGsTvn5vdUmiNwNtobzfntmjJqKvsq8ZE915OTjlU42EEZuuQq1G8YmnU61t575s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Oe/dA3g/; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b042cc39551so125979666b.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973530; x=1757578330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=arwdiSLHZSf6gZ/oJp/0pmlfrIs2tD4nzezQj8ONLa8=;
        b=Oe/dA3g/+pkPZ3L5OX5iCSblBCHitswzIteEAu+7aLroQgjxonU/ElNs4wB951hWHI
         pmZ0SzrCMND0/oMZextTFVgsHwVX0r/aHq8HefKVkGRgTTHfRvf/I/NtFJGQsr2eMuor
         r2n/Lse7yqoM10ccaQLcq6k7WPFAONAl8GH/IaJBTNlsmOGRmuCdT8dw+OH3MlMN129R
         HwVMSTEBLaCveIHvvjI+JVcrNMscR/ROUjABJh5uLXM6u1NOzZuwVWTvwhUumuKiTXJp
         xfCszGCXSxQ+9mrcXDYxbW3iYYS1FB4Ie57oggLj0PF6SGCa6+0H3oFfHVcHfUmDCU3r
         X/rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973530; x=1757578330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=arwdiSLHZSf6gZ/oJp/0pmlfrIs2tD4nzezQj8ONLa8=;
        b=X0e9QRCqLi5DdoTkvoD6gKIlhNWvlDeSMBBjZJke0b7YZGsl1XjBJ1JWiNf3qXZVtI
         Iz6ocAHPnEzNeNhDyTkfTT9fLgUrAEW6GF07Q3DLsNySeFJvQzkt1npvKiRyDLvZYFwL
         9SUPuB2+RDNwC56SsRxyrUCzzwq2asuBFtQVfN9N4mdN7IJrrDLKvi/I0p2OC4+tySLA
         Ga6xCk/hkoZc8OqbtWseB/I7HjsdM1iXUf8ATIBT4G00YRtBBG/kiPQQLjKWnsfx6Li1
         K9Ru16iFuDsJ1TMK10iKXdxfwvQ3gFZ/WFHOROoKW+W676pMG6SJhd8ooLqCrN71m2yW
         gKVg==
X-Forwarded-Encrypted: i=1; AJvYcCXHw+mjB/cHsKKaHZ1XcbYYDhkYfS9dQFxVha9vO258MwyUtCEa/IUKW5VWo9ZcheiWgRo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+BDy9do6XPovaiUfA8WCQp2hQRptA53AhILWWN21ApGQerH/5
	OfMavQckyC9IEey5K6NJdQ5Gu9LExTIXa43FgaojHDfQWgPQDMJZtjb9287bjndtD3I=
X-Gm-Gg: ASbGnctF1Rdgk/mCU5nCmg4nWWcnU+yjjxnLlNhRQos3olFVv6jgeaWbnFnfrl/5IRH
	5NPsozFQ58jjwCmHcABqFuy8EikK521WWZWfS2QiLQLIcqOvTAG1ZF8RXqwlx04OY56ADn+JQcM
	5lUccN6QV1myYOvb1xoVICqXmV6P9Pxpt/D8aP2tA7FXa9mKhzRTj/5pfJJ6Ee50x4sRvuHc/Th
	4MiTO/fV3nyTYTMIjK7Uu88E8BlT6+SsM6d5Nz7ZqIL62Qc9ICEIVk2vAsEkpVZTkllWV7HutIu
	QbK3LKTdXwYCxroG4aCbI38u0jj+HwiBv43jQwnfR+4B9+CylkRfjWE3Am6vjComu9PjR/6Lmxz
	68IdUYaftWci4Wecxm10IMT6qYkvFP5oNiw==
X-Google-Smtp-Source: AGHT+IFQfEnVE3jwf+K8A9mRCuKbsvAdVucPiFVZ9gLtG5kMjB7TuNZVupCy9McVaCvmyY+uZupkMA==
X-Received: by 2002:a17:907:7f20:b0:afe:d62a:f04b with SMTP id a640c23a62f3a-b01d8a25c7bmr1778270066b.3.1756973529775;
        Thu, 04 Sep 2025 01:12:09 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b04110b94cbsm1152568366b.93.2025.09.04.01.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:12:04 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 694A560AAF;
	Thu, 04 Sep 2025 09:11:37 +0100 (BST)
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
	John Levon <john.levon@nutanix.com>
Subject: [PATCH v2 071/281] linux-user: Move target_cpu_copy_regs decl to qemu.h
Date: Thu,  4 Sep 2025 09:07:45 +0100
Message-ID: <20250904081128.1942269-72-alex.bennee@linaro.org>
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

From: Richard Henderson <richard.henderson@linaro.org>

The function is not used by bsd-user, so placement
within include/user/cpu_loop.h is not ideal.

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/user/cpu_loop.h | 4 ----
 linux-user/qemu.h       | 3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/user/cpu_loop.h b/include/user/cpu_loop.h
index ad8a1d711f0..346e37ede8b 100644
--- a/include/user/cpu_loop.h
+++ b/include/user/cpu_loop.h
@@ -81,8 +81,4 @@ void target_exception_dump(CPUArchState *env, const char *fmt, int code);
 #define EXCP_DUMP(env, fmt, code) \
     target_exception_dump(env, fmt, code)
 
-typedef struct target_pt_regs target_pt_regs;
-
-void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs);
-
 #endif
diff --git a/linux-user/qemu.h b/linux-user/qemu.h
index 4d6fad28c63..0c3cfe93a14 100644
--- a/linux-user/qemu.h
+++ b/linux-user/qemu.h
@@ -359,4 +359,7 @@ void *lock_user_string(abi_ulong guest_addr);
 /* Clone cpu state */
 CPUArchState *cpu_copy(CPUArchState *env);
 
+typedef struct target_pt_regs target_pt_regs;
+void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs);
+
 #endif /* QEMU_H */
-- 
2.47.2


