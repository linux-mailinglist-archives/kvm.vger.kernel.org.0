Return-Path: <kvm+bounces-26638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DDE1976303
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:42:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFAE42826A5
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907BD19CC1E;
	Thu, 12 Sep 2024 07:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bqNC9VEO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8EB19CC16
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126826; cv=none; b=d0erP949vG3kB2fzXPpwwAyPxNRI4GgtDiRBSE9/xLlW+9yyZgUKmL8j9X1w0RqkjM2yugmzQxf+d1yA3u73RAa8EoidtLnWF+moieSTj+xQ+4+FsHGum9D5ZSOE9nbaYNPyqw2/37m/o3Yqi80QrmTO4OiH/oOBMWBuTAUsmO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126826; c=relaxed/simple;
	bh=AzrkcLS00WBc4gOKuIeTo6QGCcoCTXlMeNml+68ZIGs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oV6MHFbcHYiTa3b/K5yqcwEKtj6Yc78DMsZGI7PQtBbR/0+q6DbQArI4WLhyr30oMvTROML8HWe8BzhYDIDvXdG47WcKI+hG61wrngPGc4tFiPPALcFVZeRLwF1L+P1VhpzS04ZAu4sIAnZkQeOlS7u+Oj/vvCSidaBTK8rCr3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bqNC9VEO; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-718a3b8a2dcso410183b3a.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126825; x=1726731625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RMRZaTd/BH/1FKFl6y3cyJgui1+s3Png+hpoiCgGZ2o=;
        b=bqNC9VEOp9uCAwTRT9RECd6Ypdnc5UC+bhg7uvDKHa5D/Xaa/zMyjkOm9LwRFxMCFb
         PAfZKEe2U+PU49UlWF+SJa077kBRx6ONaH/i6YYXNFE3kIP5OqC/y5EN7FqM0FMfX7vZ
         iNqam3r1t90oxzbsU4hbie8OWdpo4XekC+/ZABjjINot5lwgycpNYEZp0gmQZ0ou4VHB
         H07bOmQcCp/3/uQbpis+LmAj78djinSHwNJZ9ao+lnA/9k/V70rYJvFnMqHgCFzOiMwP
         /Dp/NokYNMwBMD7XANBymIdbighsqXipZAG3ZbmLY2T05PTBnTDm3A0Ctslz6QjW+Gxh
         JG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126825; x=1726731625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RMRZaTd/BH/1FKFl6y3cyJgui1+s3Png+hpoiCgGZ2o=;
        b=A0ps6/LY/dTfb/+wvT3YTSufDgwB/YRe9/1a6l5bYnAg7XwWpkg4DSSgHDM+k4+Wo6
         hP9bWnQcEPiA/moFedT0ETd4Q3FmXspTqiZABh8Ez1NbUWOFtHmByI1hlDHdAoCWshM5
         4ienfFXWod/e9oRpK6gyGSZo9/QGJYHYQJ6ychmKzJ1xUlip8VKN8ODreuPRjtXODeqH
         Yz3YJdLEWMrDT10yz5PYOHROcy0qbvI5UhzdUBXHxMs/WTs+oNiL0Zxvk4nvR+B1clW7
         d1dIE3EcoVGbe4S4Hh5Mmx68/irL5GFhDxWt0HCzY8UsUo1zslUUhMDgeAeHW5I0PxS6
         Oh3g==
X-Forwarded-Encrypted: i=1; AJvYcCVuhwgvpTLAVsHYnnqJBXJGSnCy0tfu20f6WarxTvXwVSF6AxZoNVas1zbtxURJLuSLzac=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgYdzcFksOpCMf2F9jXcN9QUjnoJM6f/CeWzXx6upZj8q7K+oN
	gnQ6RYRC5QC1EA3Jex7erFswyQmVpckveErS1I4UNhcbu8EMmBUrJd38YwZieOU=
X-Google-Smtp-Source: AGHT+IEh7gXd2tJ0hOhx7ECr2lFSn+He2Xm0+RoHd0qt3Za4kg2n+HCrillfNzzhgQolscqSmg6E/Q==
X-Received: by 2002:a05:6a21:1813:b0:1cf:6c87:89e5 with SMTP id adf61e73a8af0-1cf764c2b90mr2176703637.48.1726126824706;
        Thu, 12 Sep 2024 00:40:24 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:24 -0700 (PDT)
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
Subject: [PATCH v2 22/48] target/i386/kvm: replace assert(false) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:55 -0700
Message-Id: <20240912073921.453203-23-pierrick.bouvier@linaro.org>
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

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/i386/kvm/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2fa88ef1e37..308b0e1cb37 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5770,7 +5770,7 @@ static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
@@ -5789,7 +5789,7 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static bool has_sgx_provisioning;
-- 
2.39.2


