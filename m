Return-Path: <kvm+bounces-27145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E63597C395
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D242FB22485
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29337172F;
	Thu, 19 Sep 2024 04:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L8UdPtG8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8266BFA5
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721256; cv=none; b=q6VQzLUU3rGFVaDT1clITmll9dJcOQSc7P79CPkIQxGlp0A49On23lZQraPetFu9E+zdN7aAeXJIi2jc7cJS54i316ZipPFpQq+1a/qznZG4APZ+7mB+4+wcUkI4C2v4zD4Df58BI4bu7SnsIj0BHUf1F74OXBN3WdGeSnZEmIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721256; c=relaxed/simple;
	bh=cRpllvxBxjvz6fI8fQEUykm3BKHY1dND/57a/4JFwH0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OTtcrZHzwjvkHMUL41zlTAcjY/hMKPbnfbWkW8bsxjSb88iDAHJWD11tg7n7M4F9Q2TR4vDUrVXmGI3YNTiTobRLzUv5V8CbjRJH9ZIUkILQhzjghbelontpbqfLiPkRFqklKuOWCyu04CoU7ytqG16UNB0VVasAoTcrqtvPQZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L8UdPtG8; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7198de684a7so265263b3a.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721254; x=1727326054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aSSHMg0OaePxq3iPPMHVPRVV3RpF6c4DjTvgexruOiU=;
        b=L8UdPtG8W4QuVhwO9jF/h7ipUHUbFZJeN+srP0c9cdG7jDS0/bvZ0jdiBjZd2u6Gld
         RRQmwh2Wv3sy+S2wVDS5KYSW9VWpAzSmQ7lISTdi3YedFMW4i32GOa0b4gGxLcwEMMkv
         iYOP4xL4RnvUAhSPWlWbqpS7gathZDDSfOn8hQLsCBvNKmG9IHmK61E6aNhX76NKsDIB
         oOcV3vOKqsXfhuR1heWBMyerICaqrx3wej2PZrqjhndXXLOZe4noaibWDwqNlvBepCF3
         nUIP1TwmJC3GjF4QRlkZIfFkRH58AEIx246gD+gpa2z9DIBdYMkvYPy/3e55q5aZY153
         I9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721254; x=1727326054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aSSHMg0OaePxq3iPPMHVPRVV3RpF6c4DjTvgexruOiU=;
        b=Oarg7loMgTGxWa+uv7I3uq58I4+pK3haermz2UJK0rVDDS9SPKaugenwTMGOUkW1fX
         GcyYaW2gAprgRUHxetAqeyY9ACkO0OcgWow1oiLYuhuwD/dk6owdbjkHCeQArasiQG87
         Or5yEWdx9erToiKAR4jC2jffxVCazWYlEIdIPAhz8QPKGJuj6X/jTLId2mKvL6wmJd9K
         k4F0niweGTuOl6qEn+Y2EQensySH+1MefEu8eCaCH0AG/2Nd5dy0BG43semmu3l0UJQ8
         J2UW86DsnIm9XAPk7wE7FFxrDbryP7SsrrLYOblB4tjHAy4uAKPNnTBfjW+TJpknUes6
         lDpA==
X-Forwarded-Encrypted: i=1; AJvYcCVrAIaRhIVFMi3YoqzWxIlEVAFBztIVYxzMB1xq5/T078WxriiF8PDunTTWb2QBrACYvTY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0hZOxUQNhmWScQANW/7B26f+lTBLfHkzj3QICyeCyImrixE8p
	4XUJbqjRf5xpakPWejjC2kcBBMjzPM68PKr/m5bdGQXFM+eimbrC+E3yOYqgg08=
X-Google-Smtp-Source: AGHT+IE3j8c7TJIEEHqr1Tk9wQkhE0pmUtXEeEmFijt9ElqSlK/SONVHUSLzvsaukMbj++mLsF2x3g==
X-Received: by 2002:a05:6a00:1a86:b0:70d:265a:eec6 with SMTP id d2e1a72fcca58-7192609113emr31183331b3a.13.1726721253864;
        Wed, 18 Sep 2024 21:47:33 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:33 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Bin Meng <bmeng.cn@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Corey Minyard <minyard@acm.org>,
	Laurent Vivier <laurent@vivier.eu>,
	WANG Xuerui <git@xen0n.name>,
	Thomas Huth <thuth@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Fam Zheng <fam@euphon.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Keith Busch <kbusch@kernel.org>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	qemu-riscv@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-arm@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-block@nongnu.org,
	Joel Stanley <joel@jms.id.au>,
	Weiwei Li <liwei1518@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Yanan Wang <wangyanan55@huawei.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Jesper Devantier <foss@defmacro.it>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 24/34] tcg/loongarch64: remove break after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:31 -0700
Message-Id: <20240919044641.386068-25-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
References: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
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
 tcg/loongarch64/tcg-target.c.inc | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tcg/loongarch64/tcg-target.c.inc b/tcg/loongarch64/tcg-target.c.inc
index 5b7ed5c176b..973601aec36 100644
--- a/tcg/loongarch64/tcg-target.c.inc
+++ b/tcg/loongarch64/tcg-target.c.inc
@@ -650,7 +650,6 @@ static int tcg_out_setcond_int(TCGContext *s, TCGCond cond, TCGReg ret,
 
     default:
         g_assert_not_reached();
-        break;
     }
 
     return ret | flags;
-- 
2.39.5


