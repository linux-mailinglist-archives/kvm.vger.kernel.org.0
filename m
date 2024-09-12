Return-Path: <kvm+bounces-26620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C285E9762E4
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E791E1C229ED
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59EE819069B;
	Thu, 12 Sep 2024 07:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XC52f7Ls"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D27919049A
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126778; cv=none; b=jyJTYgG8P6x3ARbpwt8Y+F+SThjPZFoy8JMQuPrB6I9BjNmlFgzLIdHir8VL//U6QL2QhOG4JwLY1AEJ1c2W9tEzQbcmKaxTHbZEKJ0vcI9BLfUmzQq/hrNH/7SbARIt1YgTDcuy57PLrpleMUZv2LuboCkLHDE+/TDQ9xWlxcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126778; c=relaxed/simple;
	bh=wFUSxajtwSZ+PI8d24ODT73aKq3TzMRPJaCjR/1QcNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hlyAQhA2Qie5NfkJKtZfYUZMjxn+HH+MFwZ0RAzUyk0Tx0dtYEKqYQmzne5QGynSsGmgQQGQkCZK6jTvRfuYHHb9sVjzVDT+axF1Z+64BVPNWWJsYd+9VnyG7aDT3rB57d3K1fKP8FWFoeStfoNO7xNAwKkhrwQNbjhev35Uy5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XC52f7Ls; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7cf5e179b68so509000a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126776; x=1726731576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ecO/hlC3v3MEosBJkifBisWZ7NVSSxAF5ju3ujjbozc=;
        b=XC52f7LsGIqE1il+T0AZ3odG3/qRLwZSveFy/NSUH+0DcOmY+UbrL4Med5549Y0vyq
         CprwykPruTanIeeJcep+j/cAmY9coTkCBfDnTU0bx87nv2HUk1Q30bQgLikVxZUzq0hf
         sYz3Zv/cr3XZmc3GPMORJ81PZyT0lJlVtyTYG4ej4NA52OnBmDFNekvlaF06v51p7Rnf
         QObfuntsZv0UxyuIA1vcaQ4H1lWnix/azEiZsZN8jVjC+zjrsPceWvZ3r2EuW8rCaSuL
         emMhhV0NoMR0weCZbvmxhigO2pPqd1BoilvrWph0CedpDpDXEGeqjJBoR5R0BU4wHPA1
         zo9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126776; x=1726731576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ecO/hlC3v3MEosBJkifBisWZ7NVSSxAF5ju3ujjbozc=;
        b=n6dfKk8BHfsZZ4xbKW+9dUPv82U2X6FbONn6IzKGZGEl2NMgjld7fhdfRQsrAZbBIS
         EMKk1wskRLs0tmhwndUgbd2Bip+f2R+H/mv0nE0qHlTII+9OMR4FacmPMX3mKttpL2QA
         Vj5rfxJR6KC1MQjRxbi81xLKC2KrhLs2SdRibCfl1hory3OCWqss2YP1DhJUV/m+XX9R
         /BqUJMSbh8o35626jPoz+dte9Ykay4gtTOAMgwZ9yl4g3lQOi3NfCSVdINuTcpSKo6Bi
         l2aM5/XEyLSXYd9TFJ5Sv3yAfnqGwDxAZFidy1jlNaEmhJUz21PEXXy9mUqj8wirxDE1
         DGgw==
X-Forwarded-Encrypted: i=1; AJvYcCUld8VG1vQ8yXWWdMao8DbFn344ju8rKTXsE97MXmGQ0Voz88eLGW90R/Xt+w51yoEPJX8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yws4sz8IMRBY3hGWF8/9yf+h1qPsZq923Fu44XhCgGZxhvMSuMw
	XwtH+Jv2Ceu7byXTwjJKpn48BFADij4ald18Sj63922MIryJ38K2eskB3BgTnQQma2Dd1a5z8CQ
	v1QGpWW36
X-Google-Smtp-Source: AGHT+IGWOkQDiFo4ViC5Y6sElaFJqOWW1j8ZfDmO3I52qr0gLqmLrSh4yCtDTRzacjd0//JBuuxsHA==
X-Received: by 2002:a05:6a21:4d8c:b0:1cc:e101:ee64 with SMTP id adf61e73a8af0-1cf75599a20mr3182576637.1.1726126776379;
        Thu, 12 Sep 2024 00:39:36 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:35 -0700 (PDT)
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
Subject: [PATCH v2 04/48] hw/char: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:37 -0700
Message-Id: <20240912073921.453203-5-pierrick.bouvier@linaro.org>
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
 hw/char/avr_usart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/char/avr_usart.c b/hw/char/avr_usart.c
index 5bcf9db0b78..e738a2ca97e 100644
--- a/hw/char/avr_usart.c
+++ b/hw/char/avr_usart.c
@@ -86,7 +86,7 @@ static void update_char_mask(AVRUsartState *usart)
         usart->char_mask = 0b11111111;
         break;
     default:
-        assert(0);
+        g_assert_not_reached();
     }
 }
 
-- 
2.39.2


