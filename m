Return-Path: <kvm+bounces-26746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7516976E77
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 18:12:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3148C1F2472B
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075A213DBBE;
	Thu, 12 Sep 2024 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qH2ZRfku"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A9714F12D
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 16:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726157537; cv=none; b=NWgwEHpUCyUKo+UBAZtb1934zMbE2iZO258CkRjV+FgiZk6uKVuHdoFE+BbyFR8eNNAH/scf30DQATZJrZNqCUA34E5jsVNLy4hJSoeUC9hYbCDQ9G6L9hT27PpaD3AUIIjhhHmafg6tr7mk3pLr+dm3ExTq0Bk7Hry29Q9jqkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726157537; c=relaxed/simple;
	bh=rx8KXXnabdEWKAYTTAH01K2wRN2Cx2fddQlG8cTW25Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TTxHypB/9zjLCdODcUV8scX5hf6pOx8uTBMPRHI6hpNldldCr+U3/02k5fXRwai48DVGJsqISZqoulv7wLAzfqD/77YaPE+a684Z4v8DRXTZToj/4r+VA0BZZ7mfi4lHrT8ODLAVZ3kjFbaAEl7z2CF7l6Axwsxr+kzDm5Ws97s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qH2ZRfku; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2da55ea8163so849979a91.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 09:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726157535; x=1726762335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HWN+Oy9HOzHEP1zqC69VZ8fDvc5xR6kboU5Mz4xPMnU=;
        b=qH2ZRfkunv+sbpfEekljae3ciUpZ01T0xY37z/a1jDVgKrUZTWQBJ9Erc5xUXO7flk
         c7snGSMabqtyG07N4NsXfBQ/iMV3EkyOaP8aHRX4TfX2pYzlr3TTIam8xgl6caIJQ6mC
         McTqzZcAUoNryKdzAShwBI5Wp3i0PCnjX9GI0BFSw/x4SXDom/r+bKK+USxpGY5HPn33
         PSxEuePYvRqMcizPc30TzRTJWSXzCIEkVb615GUZMuInWC84hpFo96E+e22z7QzlmFgr
         wGhms5ZowSjgNzuGn7YDd01KQcGVHvAsdmzRsBJJgghQuJXbFBYrcUGyViPpZTrJGUZT
         aaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726157535; x=1726762335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HWN+Oy9HOzHEP1zqC69VZ8fDvc5xR6kboU5Mz4xPMnU=;
        b=HY1492+9AOReQ8+97sPVBP7L97oliK+JoLNqI8C/VeEIr087j4nLMikpjeX+qZoVwp
         b97D5Sayye7lF5Tj5sab0byxHYTc5uBnwlMYE64Y7syfVgV+nMy+RyDjtKA0G/L8NH79
         aVKWvTtMPRkVwcQZTtQRBuDteiSXLhCaxX4pVjjQkMqX47mZfLsisyYbVR4+PXO6YSw+
         dU8lCDpg1V71zBtyz21N86eKKCAzrsYUPgF7NtxXd1kEBfSA1sXntRH/6wzFBw9ICkxZ
         8/zS75c87sUgA9sct4pPWT0YLYi1KjMsN5rZeB/ETXCVwjm/heWMFs8QY4/kvI8aAPSA
         TLnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWARQjtl/Q+xaNUGsh1bkw1zBQ1H9zTr2oerKa9xl+Yr34nWOVfz0dyQQig60VsLBjojaU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiAdyeEo8MxXEL+3Mh/DC/0eqelm9U79u0d3aRmXVYu9hAOsbc
	o7SmWr8IcOSAd7Pe+i2b8dy9CD7Nh/ZiNilDlBCw4fwxfOLy3fFm2JX4NTiUJqM=
X-Google-Smtp-Source: AGHT+IEudqjJEaJGfdkYpDawDooI9CPu9lOGv3V8EFCc9McG20NJHsadE1XKePiqdhT+Fnpsv3OOxg==
X-Received: by 2002:a17:90b:4c41:b0:2c9:3370:56e3 with SMTP id 98e67ed59e1d1-2dba008304amr3540812a91.34.1726157534900;
        Thu, 12 Sep 2024 09:12:14 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db0419aab4sm10868139a91.15.2024.09.12.09.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 09:12:14 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Weiwei Li <liwei1518@gmail.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-s390x@nongnu.org,
	Michael Rolnik <mrolnik@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Joel Stanley <joel@jms.id.au>,
	qemu-riscv@nongnu.org,
	Aurelien Jarno <aurelien@aurel32.net>,
	Fabiano Rosas <farosas@suse.de>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Rob Herring <robh@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Jesper Devantier <foss@defmacro.it>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Fam Zheng <fam@euphon.net>,
	Klaus Jensen <its@irrelevant.dk>,
	Keith Busch <kbusch@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-ppc@nongnu.org,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	WANG Xuerui <git@xen0n.name>,
	Laurent Vivier <lvivier@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Ani Sinha <anisinha@redhat.com>,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Corey Minyard <minyard@acm.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 48/48] scripts/checkpatch.pl: emit error when using assert(false)
Date: Thu, 12 Sep 2024 09:11:50 -0700
Message-Id: <20240912161150.483515-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912161150.483515-1-pierrick.bouvier@linaro.org>
References: <20240912161150.483515-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is part of a series that moves towards a consistent use of
g_assert_not_reached() rather than an ad hoc mix of different
assertion mechanisms.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 scripts/checkpatch.pl | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 65b6f46f905..fa9c12230eb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3102,6 +3102,9 @@ sub process {
 		if ($line =~ /\b(g_)?assert\(0\)/) {
 			ERROR("use g_assert_not_reached() instead of assert(0)\n" . $herecurr);
 		}
+		if ($line =~ /\b(g_)?assert\(false\)/) {
+			ERROR("use g_assert_not_reached() instead of assert(false)\n" . $herecurr);
+		}
 		if ($line =~ /\bstrerrorname_np\(/) {
 			ERROR("use strerror() instead of strerrorname_np()\n" . $herecurr);
 		}
-- 
2.39.2


