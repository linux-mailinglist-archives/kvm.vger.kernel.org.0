Return-Path: <kvm+bounces-26352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1769C97457D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C969328BF08
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19A61AC42D;
	Tue, 10 Sep 2024 22:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fs6RKG45"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D201917E3
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006578; cv=none; b=Sk7LBjiLT8uPJDcKizYigWVOSmo4Vsl4z2X0fOO/IB7WgdjNWZKI7w0bq6P81xb+Epy2HwoIExTS54Pi6L8GNu1V+j8V/yioRxbvGNJbKlGujRcwuo4awG++SqpYnrKxpl6ii7PRSKOhsyRyp5tY835j1ahcyi6jVyqnts3MsPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006578; c=relaxed/simple;
	bh=ZkDsuG85OWuOdALFG2Ls+wju070k61pXQlQqoNPYM+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tGpMaAlVZ0jwkg+VIb5lL5WEomBmmt/vM8Xf2CBh5jxhsOlyQ6BlNouJdVF5UlT1HxICsAzOq15eTdodZyWK0ulLWlhWlB1XX1C7Ii4xDwqAOaVSyaY4klDK9SC0ll0wx/pZ0cAA182Ut6QiGsVAGpCUen1vDK8BzrSaDl+C8E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Fs6RKG45; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-718a3b8a2dcso3687334b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006576; x=1726611376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BIrX6LSYcWKQ7NWgVt5fl+kpf/h4MdU5BhontmNSP2g=;
        b=Fs6RKG45tzHC4QTivJRTMS3wQyqc8wUaRqnej1CCAl9rCFNzC+mPR7dmD7sbgytI34
         MIFBMc3T4NeOehikDXiZpqJxNTqUxDGpuRNaQqMpWGo28Ioh6yIwHLiMsVOr1x3nFYAu
         0oMrd+GiRhbBT6R5F5blv8vJnMmgWraU0iMWbBKi9THa2Ef9NGACZs5FjCQuGowSs3XV
         Z+E+r5k2F6fqOV2hYBc2rQd2QJV9mBOmc15hI3ulHnVN+dU6eseFPRBJ/j/Gk3gGwNbB
         kASPoRFL5i/+k/qf+U+jr+XK1Pqah595IN1dMHnF6MrV3+B/1Q4lA3vuzCCcjOhb1E+i
         JI7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006576; x=1726611376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BIrX6LSYcWKQ7NWgVt5fl+kpf/h4MdU5BhontmNSP2g=;
        b=JeIsow1IZkRucGTEYnN83ivsk0roinxizZQIGs2HbtBFDNQ3qLToonwnUc4yWnjGuk
         uhtuRMy1AUIHBmyvw94etBkReFoQNSY1tC0Vzw2KivWJMs1XATAmrRXtQvDmVsixwUOj
         rwU10kiOYKp/oJXxC82jyswX70QSJ/l+R5ravhHoGrjMObxNLjZMBF8tFMPJw9XuZ0hA
         nPzGBMlWLF+n0F/viyGeTOvWAmsbUzNwSyBo8FjehuuepYvF8LFVeIi6hWJIv1+pW3ju
         BFZkS/5Fvr8mNZjrFb3dZSQHfqOBiw1L+0b3N+hR+bExGvUEKZj9nUoqj2wosO2pUKlr
         PB7w==
X-Forwarded-Encrypted: i=1; AJvYcCX7RuVLZfxbbz7H4Nol/rT+woMfi0t6SmF8CcCJ1jvVuzihPkJ7QxFVK2gTJw0fygOzAeI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV39eiD4tiriB7LHgiaGp1w0yFgGOPzs7lNNcLxHXMs51cGOtK
	NlK/SySbIJSydW6dZj5jpLE5YlCxoJCB+k7YKpmGdkPmG2olHcnYUFVS8whJDXA=
X-Google-Smtp-Source: AGHT+IEi6PPXSaCo/MzwCiwcFBkPDWeKr8hyR+jrhEtygwmYUnxCgU5X+xKQ+1rCwoEBFzE8VZ/xcQ==
X-Received: by 2002:aa7:8883:0:b0:714:2069:d917 with SMTP id d2e1a72fcca58-718d5f0fcccmr19299081b3a.25.1726006575824;
        Tue, 10 Sep 2024 15:16:15 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:15 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Corey Minyard <minyard@acm.org>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	WANG Xuerui <git@xen0n.name>,
	Hyman Huang <yong.huang@smartx.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-riscv@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jesper Devantier <foss@defmacro.it>,
	Laurent Vivier <laurent@vivier.eu>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fam Zheng <fam@euphon.net>,
	qemu-s390x@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-block@nongnu.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Helge Deller <deller@gmx.de>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jason Wang <jasowang@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 02/39] hw/acpi: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:29 -0700
Message-Id: <20240910221606.1817478-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/acpi/aml-build.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index 6d4517cfbe3..006c506a375 100644
--- a/hw/acpi/aml-build.c
+++ b/hw/acpi/aml-build.c
@@ -534,7 +534,7 @@ void aml_append(Aml *parent_ctx, Aml *child)
     case AML_NO_OPCODE:
         break;
     default:
-        assert(0);
+        g_assert_not_reached();
         break;
     }
     build_append_array(parent_ctx->buf, buf);
-- 
2.39.2


