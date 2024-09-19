Return-Path: <kvm+bounces-27135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FEE697C382
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:48:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 075F11F22CA6
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF473CF51;
	Thu, 19 Sep 2024 04:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xg8iB9RN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A187C3B79C
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721236; cv=none; b=PRHyNtKOSCbKf0aGTsbY69sETeTz7CSfKQMf6ca4JyUskH1erRixrRM048xK1R6UGNkr6bc53ysVnvWZYkN51UXXAc4YQyOnXOAsZulPF1IPlM9ZKrTnJeGUCZmVwshq2uh2nKcSPgd6V6ilezusTihw6/RwFUYA0P60eIDpAs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721236; c=relaxed/simple;
	bh=L03cMnciaXv+Tu1dHQm4msd/v7u2MEWZ2b+KhDe0RV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aw1gBzV/b/UNq8Ae+JXWtKFbg1V+Lvjnv+m3IB14oEMJzVI2Q3Rpvgv7nlyVI9rAS4WE2GNnHAsPRk5YgwSWKDQnN6EsmuJEP1cOhbHUvAcfOjT42ptzPi2d9+JQUUDHz9P3TvdBi9ySG29cQfJbqsyHtPUBLbdBQI+El6hP8Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xg8iB9RN; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-718d8d6af8fso288055b3a.3
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721234; x=1727326034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7PZhVYqzq4kADvRMhAIMG6rvS/s/Gp2LRBj3c7uTV/4=;
        b=Xg8iB9RNTIr8NP6JjBGg1UY1cXl6WTO4zJiQzSQ+8EtJiATcHTvi8fq2LhUVHXGWXe
         pXXeVo8wHLcTDy7jvUabT+smGNS2RSJMOGID19iZGFZOKq18jzM42JfZkZLdBkbktND0
         0F/4+a2KV2MHLzTiJaKbs0TEhUFhzpm8nWOA3xN0nFNzSvp5wt7IAWXykiCC+U+gr8Zq
         sQ9vZHE15vPQiskPRXemZu69pSzn0+kLGSIeLWz5MzJwePsJlHKJGGwGUeHeCzcX7KYh
         I3JEHm8UM7fBw76zwku6t5/R5yTsPDatTmPwiATbOOePrbuB+Q4mhceLV734CLrxRzFX
         9MVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721234; x=1727326034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7PZhVYqzq4kADvRMhAIMG6rvS/s/Gp2LRBj3c7uTV/4=;
        b=tnrjzyCaygh/p3FqbY7H2xcSVpzrk31A1CaquxHrpbA2qBdRf6dtg0/ecQ3/m8V3+W
         5wkWK/oP/j8moe4cpsDxF8ctcEXB5mFd2rh8tcKwDIi01Ja1PE7Ulw5XOcZ1jD9Ex2Ca
         eiLNjnDhq/hv5JozFEIyzL9d3YAecymSswTGxweK9rEI5oKo9/lxgh2ucim6opE8WCEH
         F9YsIPoSSrX1KzDC5IpcX9BN3Izzlj7nsEU9UUwjNuby6eg7jCAMV3IOfPvCnfil2cuo
         AzxjP3Boffzn0aTuEYiKgaAcdXLrBqV04JwYyKJPWfXvKMq2j5IFi+p3eq4vojgSqr4J
         GKiA==
X-Forwarded-Encrypted: i=1; AJvYcCXdysEYjyw8/pKPY3WRbfK5r73WwGjlaIJzgBWXWdSzkUcuPEphANbn2MQ69zLbRVYCxlk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ0Tdkubc9LHBDXj6pmVMlmWDZxR4e9Al7XVfxNqE/sej7KDj0
	TFd4NOwzFdsqWKLvLzpkPhdyMpqGfD8hhVu4c8TbX1EXCQgdXAs2V1pXvDkMzyg=
X-Google-Smtp-Source: AGHT+IFRqXUQzeifeEouuocTRosW9D+grcvLtI1xOR31wi5/CcwZDxPvsAI1HZex+byGlUmwqu8pKw==
X-Received: by 2002:a05:6a00:2d91:b0:717:86ea:d010 with SMTP id d2e1a72fcca58-719261edaa2mr33169557b3a.21.1726721233871;
        Wed, 18 Sep 2024 21:47:13 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:13 -0700 (PDT)
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
Subject: [PATCH v3 14/34] target/i386/kvm: replace assert(false) with g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:21 -0700
Message-Id: <20240919044641.386068-15-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
References: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
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
index ada581c5d6e..c8056ef83d7 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5771,7 +5771,7 @@ static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
@@ -5790,7 +5790,7 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static bool has_sgx_provisioning;
-- 
2.39.5


