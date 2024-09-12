Return-Path: <kvm+bounces-26626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE1889762EB
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADEDB28209F
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADE6D191F8E;
	Thu, 12 Sep 2024 07:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oeQVgxNX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779151922E0
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126794; cv=none; b=pH+/CbCRMjg5CwCYsbf1SYUjw7uIh3bmggJXhcAa0gJxBeJAJPIMGnLA0TaZyX/2wZwB3MgLyE0E4AMK15iXtPwLZ0GUa0B7TESqIeMkSG2Wkr8fADWlWTjRs1bL3115YokJheuEYb9oGD5fue2OWJV2vk0NfOckLoRplyynemU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126794; c=relaxed/simple;
	bh=yhNry/CHODzz/FBsWk1vpsMIAXL6cGf+oMKxPRAAEVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jYWdnp1JaaxU8AnGjOMfcPSdQqzEB9iHqBQJ+BR5uASbCwiA88a//eW42h2AqbcwWKwVEBNP+UPWo/+1AJf6vb0DiMwsqr+yCsqfpg2wG+Dbcn9tzRZqYhgv2qNhYkSm0rD/bbpdpXWYmLWJTfG98zzmI7yBjm+02uwq0DIw7rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oeQVgxNX; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7193010d386so92493b3a.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126793; x=1726731593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1LH7RZDNr8Bem+cpDiAWWDNCRvN8aqG8ZgQstwfOCIs=;
        b=oeQVgxNXPQJ/hgSjrz2hX280ttk5lQDtTwajX00eUJheT/o5/v2Za2aN067QREXg8E
         nI0mhYXfcH5bg51A5swJhmAVUlg8vVCdo67AoKfwLY5F7xh31ww/MafwEXO6tOcNChFj
         7UzLfLblqd8Gbs0BfrTMqVsMZCTjCTLsNEqwVkiV8j1B8sAGAy61o/q46Fl8ZUhJlmyY
         Se+RN+q5lBW/CY6pMB5toWGXzZE3AhREa3OulFGdCw2Sxx//Aqp+7qNmk3+mxt6iiV2K
         sgJKuOpGGPls03iae6i4gCpK9mrbQHmYDVUxioWh9siscg3yCyTlqCgCPEA50qLx2yMx
         GuNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126793; x=1726731593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1LH7RZDNr8Bem+cpDiAWWDNCRvN8aqG8ZgQstwfOCIs=;
        b=ozWDS8Nk0Nfx1GAZGL5koXfaPo0+KMsJYDKuFAuPLFG0oLsSuL54m2xhWfsFEYVg/a
         8BFMJOKXWGmX34pQ8PfB2TMwIwGdu0ipqzsYNraQTAG911gJdiTKgWze1EnfmOjxawm5
         pgTNN2MUxD4umNaaOmtKxBAO7gxuHLBE8saRJn9pwRYOK1e4aXQxZILv8LhjUUFzCG9r
         /BKVJeKu7JFCTDtrAaQPPK2yy6LNe3h2JRt3CPuZxW8YEcBP6zq5h8pO2yoxGKRvwsUI
         CKRIJPKaDvBG/ARvYz0E85czWmPdBmFY4BrJhh+liZzuGBv76RBl8mWotyEmAj/4hsma
         bjPQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+Z8cyERFOanNAiIJ/YGkhU02Q5xvtGkq8TmXtLd4YzEW0Vouu1E1FpR9l7yez28mxL9A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMPvwB2g7xSLsNdAzpSCwuXXAHCxZ0n2fTLwyQ1irBlqsVU0CV
	aZWiSrYhAEGk2OcIdpxP8CUkVmsqQQrpWEA4LlTo9mxbQ07ML7MeVfKOZ9ApCH4=
X-Google-Smtp-Source: AGHT+IHO/OYYyb0vxtmPEDD5VDcNxDdhzKA5t0NP0cSnDTfGGp5wourxXyyoQSgKxB6gKjLR2x0CeA==
X-Received: by 2002:a05:6a00:ac2:b0:717:8cef:4053 with SMTP id d2e1a72fcca58-7192608fd96mr3206049b3a.14.1726126792521;
        Thu, 12 Sep 2024 00:39:52 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:51 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	WANG Xuerui <git@xen0n.name>,
	Halil Pasic <pasic@linux.ibm.com>,
	Rob Herring <robh@kernel.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Corey Minyard <minyard@acm.org>,
	Keith Busch <kbusch@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jesper Devantier <foss@defmacro.it>,
	Hyman Huang <yong.huang@smartx.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	Laurent Vivier <laurent@vivier.eu>,
	qemu-riscv@nongnu.org,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Peter Xu <peterx@redhat.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Eric Farman <farman@linux.ibm.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	qemu-block@nongnu.org,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Eduardo Habkost <eduardo@habkost.net>,
	David Gibson <david@gibson.dropbear.id.au>,
	Fam Zheng <fam@euphon.net>,
	Weiwei Li <liwei1518@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 10/48] system: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:43 -0700
Message-Id: <20240912073921.453203-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch is part of a series that moves towards a consistent use of
g_assert_not_reached() rather than an ad hoc mix of different
assertion mechanisms.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 system/rtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/system/rtc.c b/system/rtc.c
index dc44576686e..216d2aee3ae 100644
--- a/system/rtc.c
+++ b/system/rtc.c
@@ -62,7 +62,7 @@ static time_t qemu_ref_timedate(QEMUClockType clock)
         }
         break;
     default:
-        assert(0);
+        g_assert_not_reached();
     }
     return value;
 }
-- 
2.39.2


