Return-Path: <kvm+bounces-26642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4738C976308
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B216B23D02
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D1D18E752;
	Thu, 12 Sep 2024 07:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x93+dGY8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBB419E982
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126837; cv=none; b=mxYdT6bG1UKwnoF4CW9IC5U9bUNox97hBPWMYPwHraIbltyQvlj/WopvYPDgDxkWwUPI4w5ccqht7tHTQS3mA88Sk8keGuhEO4gecs+un5S5rOUX+o7KHtOrtnycIvNV2mYM4NWzgb+X3/vaXTtNAGhnrZOQYzS4C7Hhz3new3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126837; c=relaxed/simple;
	bh=rf0i3YxuwZDwdGspRy1Xpx8uuAemLk2xKQyv9UQv0OE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K1psn5/zLm5xX9WVK5PxndIE+kerGYlI7Zp2uXWZMH6cZd+l8bH29U8g19FPEjmF/IQpVndTwgy0odAXqRYhNsBs+i4922TogZBDB+liJirPzh2dL1KCR/d+oBF3+wxAOs+Lq54hVZXHy/AV5DHrqLOlmTs8ps3J33o5+OiVm0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x93+dGY8; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-82aa8c36eefso34512639f.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126835; x=1726731635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AEyQ2xcAnmhK9ml4jXR52VoKIjk53wwLwPkspMKdJxw=;
        b=x93+dGY8GwiC/r145cnDRr1HoQRclDtx/0o0vI+jUAK1dY6d5Ub3pVPGwn8G5gakCS
         nFqSFJQgut8Wp61fRqq7pnAtzZA5qP0E9PEU25EwUMEyudWFis7XBHDxsbZmPI7hbvwH
         kR5geT8x669xoYm/daYoedlj33Ec6zNbANMP+xeEg5Oel4yPGUz7jREWzdb2ou8iria0
         gXlsGz9c97OD8Za7cd4/+2l+9Shf6ZsqlSN+HvqzOv68by5PR7JOjDXugLreZfYwO5WM
         5Q+2569MGZsEeN8bsk1qIP6fVZ1XrEX5DA0mvR/n775OC4HZ3EGa+Mv0/lA9QW5v/Ry/
         7vcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126835; x=1726731635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AEyQ2xcAnmhK9ml4jXR52VoKIjk53wwLwPkspMKdJxw=;
        b=kih7TJeRIkayOSWr6dO5WlODBzHzZMypIQf+lV5ty7QfhTjyvp2K387ZdTwR/0VjzO
         Nc+VOp1iMlRgvEMUumUq7/UE9a7MCd1r0h0J89kIGB5I9ilxDt5TwViI+qKmc0fDKHKP
         ROdEya2GTw5Xt6l0Iyq1fJvJ6lBxVib/5lGT0ul60c/PRcVO9mMgbJRovfvGKL78fZpD
         RrrD3oL/DU4hGnwPTp7fn6nHN6b36GNCczILwQFLecMMZ+tzMAdVK0YULCCl7ZHjjc+0
         hD2IQnePZFEimrdEA1R2ghpW+P34pAHAJNApspydoi1yc1dolZXLqS1tMdNA8L7Pr9ue
         N3QQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPoTopUCsLjhpkCJIPYkZKCKJVpJU8Yth+EE9d3X0wjSs+UKdj8rMV+Bjpb2l4UsH5dI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHtimRgvhox3RUZgiJLm4AvFd5MehP/mMHyaQDuxxFICgleczb
	pzVssIwLwbGwffuAEMbykY9jxVghUI6rgkqsVnuzX8GVBmTjzP0FB4aXyIYQ6ks=
X-Google-Smtp-Source: AGHT+IE1ZM38e31F8YJ5oP22VNGbpDaEZK1YoPHZ70nspmYJNabyI5hv8MwCmiBG5cRfcCe0ROr/ig==
X-Received: by 2002:a05:6e02:1a81:b0:39d:2939:3076 with SMTP id e9e14a558f8ab-3a08495df72mr19677125ab.25.1726126834897;
        Thu, 12 Sep 2024 00:40:34 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:34 -0700 (PDT)
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
Subject: [PATCH v2 26/48] hw/acpi: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:59 -0700
Message-Id: <20240912073921.453203-27-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
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
 hw/acpi/aml-build.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index 006c506a375..34e0ddbde87 100644
--- a/hw/acpi/aml-build.c
+++ b/hw/acpi/aml-build.c
@@ -535,7 +535,6 @@ void aml_append(Aml *parent_ctx, Aml *child)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
     build_append_array(parent_ctx->buf, buf);
     build_free_array(buf);
-- 
2.39.2


