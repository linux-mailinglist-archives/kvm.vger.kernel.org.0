Return-Path: <kvm+bounces-56771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E43DB43521
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C8EA7C45C9
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29EDE2C11DB;
	Thu,  4 Sep 2025 08:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RwQSEXuT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B49A2C0F89
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973499; cv=none; b=HXEjSop2IJMHOCI7Thf4rBTiqPVdjJwlT/w5JmFW4d6PTOnU4AwqQozRLjH2g+DlCE1/iSk7JA0SIEzWWTIJzWw7BL8J0OwZOBlKWO9yfdRdhZEcM+xNoSZ6R2xY/UWoifvnLfbdxcL8cSdMkQCc81GTiVZVXKuh+9UTJIuCiLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973499; c=relaxed/simple;
	bh=4w3qe2ixMqPGcvZjsIbbYIT1F7PXQ70EjuRIksHMo60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CKhRhhuQbkugzX8HxrOl7dQhIUGjCTt0bq72LAwicASUeuudEdEe4gpoH5iPwBuGVJf6OU03lfv6+5iHlt6nXW5X1Qe5BygW19SG7KdVcdaLTl+sk8j5Etk8/TaviUXHQFHtEFu6RmoVwFFtZGlMMtNKMCLx5WtDiA1wieR0c2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RwQSEXuT; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b042cc3954fso129230566b.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973496; x=1757578296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wv6wFcI7G6DdUK88SJsbLfMk3oLK1TTP1R3ujLyoIqI=;
        b=RwQSEXuTsWTP8T8MS4TimeQNycWlsPFI4nKS7RRzTCkwWX+DaVm1e9Ld58N0KKkF/7
         /XwI9LIPwxia8iETAY5lCC2WIA3rLnrwEOhXE0EKCaRcDBocWOV1fk9Y0gOjX7jIiCyM
         yyAyTy6UnHI282uzmRAQP86QfqOXnoihKGtcBcz0znlUbJEe3yScSXM3DzuwhRqLgFsx
         4cAOBPGzAoUkct4Ynn1kC2XHeS7uvAzQa+c0NYermc2DFegHC8TI/cPUh0bhFmM6VVRJ
         mfF5pItFXLyjomVQhCc+pf8gBdpfiD4NxoDzlLcdzBt+XKW3PbMCyhK2ppLrmS86mPYX
         /SjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973496; x=1757578296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wv6wFcI7G6DdUK88SJsbLfMk3oLK1TTP1R3ujLyoIqI=;
        b=GzpJp4nu+iQDdqFYjo2R6vwXEKGN+h/03gcHZhXdsmRRADx0RM2vZxcZK14au0YVub
         0ftuBKIbW8M53clET3T8Kmy6ZAOuvSLaqGJapLuXbnl/Qhhw8MSSTkKH/eoCv0ubAgcf
         8QGbRclL2XCPONBJ+Lmtr9rcHcTHiXGg9eOfmbAitlQyu2lcHMav2+zdgg9q8en1Xf+b
         1SNqbgjTmptmgkmoA6jmIzYRUSyooEmdH/nefdppc6e+VMM88mn+ZP/wU8Fxu4Qktk2k
         CyWZvFNOwWSz/oSvWV98lDxZRjk7qI+A3UjqCaeYK7GehKy1aEpokjiQXIWueCyK8TH5
         V4PQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyP8IjA2oAmKuPN/ezBCcimO3o7hXY1eJbExEqbU3V58QbhkVqZQ1UXzVXYIAh70pgiUo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFClLz7CBO8m/ZS5vhpTreTJsi3F0YwsKX8SYWplnhWka7+DuB
	HACq5kz7XZh7F7OuZsIFrC9OOFoZff35vwcnJgvo45r53PaPF8tDvKk8c/W2YOUmWHk=
X-Gm-Gg: ASbGncvhEwfaHp1DSmxIZajosqvf7Hz0rnT6C3PP+6bV+FtjIVxsn+w5ILLrvTZXtM6
	hxHInbgBktBMxH3YKrQL1BzpRm97DbMqS+GgtdhcprrqitA1NODxJMXL0uonJ60fLzQMolmNTPc
	m8+wYJzC/Xe0RuYZ85r5N7QkHynARy9movdBM3UEkJy1YZfAVKiqJiioxrXYiZgcRyH4wqW7pcP
	cVKyIaXyfoQqNKKCXuE3WBTUiyCcdYTjhW+c9qr7Cpkkr2XXGYc/ZCgJAqo9oPMM1cENN8jjdHU
	WhtYX8jYjrzsE+jdgWFed0nSt0r9PpG8rzBeD0CcBMC4hhk3aTWZnKKJaSkXAJU5wJKXBtvPHfX
	nb4LeCvTgzGicrSOQ8Btc444DMAMz8lsRnQ==
X-Google-Smtp-Source: AGHT+IElPpn0KvMqOR0Q75Gfkj0ncOLp1bLOMMk7oeP9JIeBPVNdyXvx2TH7ciqYVtSvBIeB+x6WBg==
X-Received: by 2002:a17:906:7953:b0:b04:813e:491 with SMTP id a640c23a62f3a-b04813e1a1amr139359366b.12.1756973495570;
        Thu, 04 Sep 2025 01:11:35 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0484e8a4a1sm55305766b.83.2025.09.04.01.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:32 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 9A3B85F92F;
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
	qemu-stable@nongnu.org
Subject: [PATCH v2 004/281] python: mkvenv: fix messages printed by mkvenv
Date: Thu,  4 Sep 2025 09:06:38 +0100
Message-ID: <20250904081128.1942269-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904081128.1942269-1-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

The new Matcher class does not have a __str__ implementation, and therefore
it prints the debugging representation of the internal object:

  $ ../configure --enable-rust && make qemu-system-arm --enable-download
  python determined to be '/usr/bin/python3'
  python version: Python 3.13.6
  mkvenv: Creating non-isolated virtual environment at 'pyvenv'
  mkvenv: checking for LegacyMatcher('meson>=1.5.0')
  mkvenv: checking for LegacyMatcher('pycotap>=1.1.0')

Add the method to print the nicer

  mkvenv: checking for meson>=1.5.0
  mkvenv: checking for pycotap>=1.1.0

Cc: qemu-stable@nongnu.org
Cc: John Snow <jsnow@redhat.com>
Reviewed-by: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 python/scripts/mkvenv.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/python/scripts/mkvenv.py b/python/scripts/mkvenv.py
index f102527c4de..9aed266df1b 100644
--- a/python/scripts/mkvenv.py
+++ b/python/scripts/mkvenv.py
@@ -184,6 +184,10 @@ def match(self, version_str: str) -> bool:
             )
         )
 
+    def __str__(self) -> str:
+        """String representation delegated to the backend."""
+        return str(self._m)
+
     def __repr__(self) -> str:
         """Stable debug representation delegated to the backend."""
         return repr(self._m)
-- 
2.47.2


