Return-Path: <kvm+bounces-56770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 36ABFB4351F
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 670101C25E6E
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468FA2C028C;
	Thu,  4 Sep 2025 08:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="edEz+Zu8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CD52C08AF
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973497; cv=none; b=DW49RJPeHAIEbSJaH/V5cR5/b0XloWqZL9dpHmM5uPeum98Jy0WQdOIkh2MvBo4Tt/0eGuBqfKA4+M4scawgoXy1cAweu39TgKN4hK/uRHibGOJxDG41GAVaddZq+hTE9QxrFqDaEIY7wZShzYlw6Wtno7SSeldkyELfN37ZrTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973497; c=relaxed/simple;
	bh=qvS8sAyc8SkWCq3FYME7uB8L+MbWDghaWVjUjWkJvtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfD3qhxWUluLjzX/0bqWtvaVOM1LL0brjOUeUgDjJ8APSI+vQizzXPsJWhsrURitTnhUwnjST+SOXNFp/yJNICU1T7gZPyEEBg/VNn5F6UoEZn933gJCl1WOOEnA9n2HBxhUMZUZtcOwlA49TrKKc4hQf4v182p3fzC+nBMo4lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=edEz+Zu8; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-620724883e6so159820a12.2
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973493; x=1757578293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pfipyU6Vd8H7OBNmQiaCitsZISqNnzAeEnNiRJw+yKE=;
        b=edEz+Zu8Aa6GR9ob17R0PKbb97Z/zAhINqwHsCgu+QOs2e78qnmAaX6HbRH13ZlPDO
         4Cc48SKS2KJ10LsuF1TwXeAz15JWTXq03ql+kg/ZkcKocV/7xSZjXKPeqgM6tMgB2Ybc
         c7MBpQwQfS+qpeApnDz8GjdyYrnSGdPAj6twPUlRaKnuZh9cMN6HXruPu5OgA1TojP05
         oXZpYJ89kklPfXGTdZ63zQ3dHL6d4fAIC8VqjOwEK6WZVvXq5kp0hoJ054+eaysrXLea
         H5fuOCChrRwj/7Jjx9pD2XKFIwOYmJL9PNCaMoOkqxfK7DS+7/gpxixUtiBzUpjiPEXq
         COww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973493; x=1757578293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfipyU6Vd8H7OBNmQiaCitsZISqNnzAeEnNiRJw+yKE=;
        b=n6uhIpggViElveLLWqt/ikn6/JGaFENF6A76XAPsmOcEPxCRXV/UpU+s4u4jPrhzhb
         384xcTNVCG+Zc5FZe3OH04maaDSq6HfiVHZsSsrNl7jR0IMkmpz3TYlFkfjsaLq5/aeW
         qMihs17FFbB4exm6qvyiS7P9Qr4ZBaZftziPqtT91uNNq3M7B4mNXzPac3J9CM1rNIDU
         Qta1IprWaUCChROcjBsTFyd75UceDW8rDQGD5HQZS0sBQ62lsklMGCSH9gFW2nHEoO3h
         oKNvbGcb3FRs7zKg5QytR+sDup0KAZiSAN+h/0griZj/blnFJHkN95lYwIU5AFGebeaj
         HRmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvEuF1mT5srJeRVyxAyn6BUlh2Q8TrJzj6fIGYXxz2qyHe6akPSqK/jFNr1jKUDGRQn+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOtO4u59YOBHdJdfQ5XR9ogEa3MSDsRbAXBiuJJeomfm9w2HgI
	/eSMJpbunma1l+4oLGVBfu/ukfOFF4Dt4QnIlaswhx7XhRRUY/gEBeC8G13ZFHUQsPA=
X-Gm-Gg: ASbGncuUMK084pcCm4YlRcZfJEw8mv48+TjY44Zk3vOwU4g1zTn5PNXuzLi4jVNf6SI
	x7qEnw5FKsMtcFQ0PWOoljWaFzX5d8YAWT2egRDJFLWpsRv5CpXe37dczMu3COH065BnYimQFC4
	DpsJuGH+bS6ZCQ/6H8RDrOE+Al7TPWbgxlIOsvvIYJ59hCgGgdA4qyUSVVVS4EWVuA7NZgxcBWl
	zZ/ReVDaOmVIYrCe+iJGb4e3KjkyG6URTNxp//ASHm9POkV9/KQNK7Yxuagg0hUoudxQSBaqAs7
	FeejxOuHp2AedWeDtfdj/nMNBk7gTPAlFon8KqKx0bgXHj80AjVPO5ijQnYg0wzOg8bimzuRdgU
	NZzBiUGitETo+DNWr0yz8o/4=
X-Google-Smtp-Source: AGHT+IEoaLYHbkuQ5w0GIOHrSrp6jiGSZD/L88aCCuGmKVKhMNAGz92wDlGLKlrjfHoRe3Zrhm5FPg==
X-Received: by 2002:a05:6402:40c8:b0:620:1c6d:e6c4 with SMTP id 4fb4d7f45d1cf-6201c6de967mr689986a12.38.1756973493583;
        Thu, 04 Sep 2025 01:11:33 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc52ade4sm13646124a12.45.2025.09.04.01.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:32 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 674E15F913;
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
	John Levon <john.levon@nutanix.com>
Subject: [PATCH v2 002/281] scripts/minikconf.py: fix invalid attribute access
Date: Thu,  4 Sep 2025 09:06:36 +0100
Message-ID: <20250904081128.1942269-3-alex.bennee@linaro.org>
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

From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>

Fix parse method to use `defconfig` global variable instead of the
non-existent KconfigParser class attribute

Fixes: f349474920d80838ecea3d421531fdb0660b8740 ("minikconfig: implement allnoconfig and defconfig modes")
Signed-off-by: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Link: https://lore.kernel.org/r/20250820-scripts-minikconf-fixes-v1-1-252041a9125e@linaro.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 scripts/minikconf.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/minikconf.py b/scripts/minikconf.py
index 6f7f43b2918..2a4694fb6a3 100644
--- a/scripts/minikconf.py
+++ b/scripts/minikconf.py
@@ -340,7 +340,7 @@ class KconfigParser:
 
     @classmethod
     def parse(self, fp, mode=None):
-        data = KconfigData(mode or KconfigParser.defconfig)
+        data = KconfigData(mode or defconfig)
         parser = KconfigParser(data)
         parser.parse_file(fp)
         return data
-- 
2.47.2


