Return-Path: <kvm+bounces-26376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC9FE9745AC
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:19:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 684BD28689B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976811AC8BD;
	Tue, 10 Sep 2024 22:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e+GrV52q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2CE1B3737
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006633; cv=none; b=R6dyHlv2YCid5PJVUEbdFPlQ+L+QVWPsXqnbZk7Zdip0lrK7it185nilVhztBdv09egJLO0nz509hz7KnTz0n9FpacgQ68esXXBpV4E29KlCRQXBzQ0q5nCYfDfbcOSsRHm7zdf0AACintadUYz9K+jNWoVP0CEuTt7WuR4Y6tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006633; c=relaxed/simple;
	bh=I7IoEsCFiMadfRMXGxSUVnq1SR1ewhQKIDmt/usV41g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cqCDG7JbNJsNLah+8LweTm4QqWbXorU22y9ey/66he0wdubaByOayXt8hsHXQBKigQjvy4IMCljXr6rJk3PUFVrSeSvRJ1e48jAGsXrHqHkt327HvDDPe2yoXz7DM6Ces2gYzxBZpxJHN7i8CM8A07n55Nmh8Xp0MIYG8YLRZPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e+GrV52q; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7179802b8fcso4380918b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006632; x=1726611432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FxBBj8XHDZxd3pwPDQhaFTyzR1JvVS6yl60rcPuU8DE=;
        b=e+GrV52qm66BtPtdmDFe1NGb9eC//hqiSSWmBslYQRvqzYz5sKudPwJE3Xjx56hukx
         GAFlg4ipDZ0Onz6EVs2+eY4PvZLrAkXXD9xe3uNi0t3HxeZw7gjiFtzXbiLCSr3VbOKN
         GfZSpReRXpKDX8kH/mfkz23+6UMBNNW2v3+5rQJVJvVe3ZjxUb9a0lPUoyF2/NBqiQW2
         GzodbX2Ad4OIKEIhRhu8/JMsCEqqSEBGhSKPB5HFTOHtHdJMrR4DjdxAxgSHMo06Cr05
         NMwXlheCuoZz62UGw6FuzYPqoKHut2h1B+OVTk2JvGt1M2nPShLdLz5oLvRFX46mRvoq
         G9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006632; x=1726611432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FxBBj8XHDZxd3pwPDQhaFTyzR1JvVS6yl60rcPuU8DE=;
        b=qYrx9OKT0CevzD+Tb1SWf+jXEnfDdaEmVodkxrKoApU88bHKzRkPSgEPNhJ0LV7v03
         oTlcx6qP9Y8jiGYIiPbflj29D8x+n6hZYiw75jKfbBKFqTtb/OyhZCsS4siZRTm/Xo/P
         sHYEsTaTctHy1cMYztTKq1+EMfU/WqROV4RzUzB/IU1zz3C9gYcVVB081ix9J0OlwWny
         Ij9JQWZk3fYs5p0BEeSeYHTOgpk/PbN8XQZrfXCbvQ3hYRRB+10nGDASzUkZ3tL0Ttto
         VPnL9MdzOfes7DNIw+c2PTieIvNwBYDLG6+B5wPgeWfq6+3K9aK9yyYWi3pR7HQKGk9Z
         k6Jw==
X-Forwarded-Encrypted: i=1; AJvYcCUxtdytNxsL1umHjZHdKqFuhukZ4s+/xh0fe2fsdyojudDa92dGrzD2hWYRqWbKFpD27Y0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVcf6W8urBa3+ecb16idRNgrmKrmaCB3qq1qzSQwGy4zHABJfk
	FTvsaYNfYvkae6wgruEwEXFyVl60+ssNnW2UOyfsbZPrTG1GKzkM5KtEiNCzgjg=
X-Google-Smtp-Source: AGHT+IEXiP34uTnzQwoBvPtoZRfRUyfMSCqJ2GA6SrTzN26OOJqSvbL/tMxUKioN4UZqgJtB4WHk9Q==
X-Received: by 2002:aa7:88c8:0:b0:714:2fd0:357a with SMTP id d2e1a72fcca58-718d5e20a52mr15181026b3a.11.1726006631633;
        Tue, 10 Sep 2024 15:17:11 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:11 -0700 (PDT)
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
Subject: [PATCH 26/39] hw/acpi: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:53 -0700
Message-Id: <20240910221606.1817478-27-pierrick.bouvier@linaro.org>
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


