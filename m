Return-Path: <kvm+bounces-26640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B09976306
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:42:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B359D282733
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDBDC19E960;
	Thu, 12 Sep 2024 07:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PnC14nyQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D8718E04A
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126834; cv=none; b=Rur56YroohiELAHvhxUfGDsD7rqFfLp/LuHwpxtKBnuev1+vcTwiKiJ8tmKNxsa5w8qz1Giz7HCKFeXqjy+OgvFyhAp03v8XyNPhluyJN1o9kihIyBNrCS7/O7/gUmbwaEHciwVsb1/sF+s9KxzY4g/Jd3vFVnVoNEr0uH8HmdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126834; c=relaxed/simple;
	bh=+9r8rajTU9SwPdjh7W+mWMz+ubk2p7B7CO6CHoco8vo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hOX2P9Y44BwGzQAx0Y/+8HwViLYmLRKRTwP9pfKZqLuU3lLhAAaFJp+3y/dRw5sjpPa+GHGOpRxOT381yye0Z/6MUZrJBGnpYZnpntPLeqihdZaIXh4yabaWNgfXONDHeSc8xM2UgvFJW6WDWYX5Mz6M5Wbnm91/WOc2zkbzUCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PnC14nyQ; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a056727fdfso2448685ab.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126830; x=1726731630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sAFROPRNfnjqKGInm+avpv2FlUZT8Lrw7bfqM3cunwQ=;
        b=PnC14nyQnGQmsL7e19B4QpSJ42w6OdgWr9UwHVP0MrDgxN2Fa+BRXDUYosm+ETJ0gK
         4YGo5+sCagpgw6gBuTTgeaavIN5hOd4K4XvYn3MZGMVAzWbFUQ+wt9RSnZaQ4RM1o407
         vFhO5E/C/LrA+wtSZ9bRocj6QS+UpN0B9RGS17M1FEzcnteWlBvDDu6QSdA8Ac0Zb+0J
         OmQWaIKt6Mk5LSaFHimEYcTic69IcuSc+LUA2HtNHSnNHD89Z1P3hGDDUwvyDWfIqFT5
         wjb4ee63Z44voITDojIW9H4Db6ny+MKMj7NJvJLKJwJnTd+FWV5o/bKrgjJ1FxgB62B9
         ZSvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126830; x=1726731630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sAFROPRNfnjqKGInm+avpv2FlUZT8Lrw7bfqM3cunwQ=;
        b=TXh884CgHdj1/Svgario9wXlC0hlcsnZjVjzb/db/AzODrRm6wF/tfW6N/CxJxNfzo
         jBy2uOjtOKnWhKKEr3+8dfAI4zgJifg2aqSoJL1mopM4npIGlcoIvqgNdbHj8VMQlkEk
         twgpf63bmOnBLs+rYl2PrCAICjW8INpyDl/DAUrj489ICtqjgSZiUDVPcJ80+7rv6UpT
         WWx0qr36tMVvBDwXz0y8+nTPAU3ufTfEV3kRkPoI9PjTUAUolFKlQzYG5oJbBEmfS5Uh
         nJntmRw5yxJdqGP8iH+2O4h7gqKKjj3HobHy8Z48vZadowDy+wcHgabeMI9PT+E8f3Xx
         eKBw==
X-Forwarded-Encrypted: i=1; AJvYcCWkgCSmyzT/IM6MbKaONY4vdQKnBcxob5ZIVjhLT2dJnbCivMPrJAoV5LnBkp/IHHgT/0g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA68NwomIOmze9Fr3tp/UeuYhi6lj8mzYQ/uB3ye6fh5PAspUv
	uFN2ndyYEXDXRv/fnWypxGHRWY3I6QWNptR1PPQi+lhyMlRwiODHFqmnprG3DHo=
X-Google-Smtp-Source: AGHT+IEH81pDNJI3FqeUIYeBUH1XaZ7gixSvfp0/bKQHU2ae/DBaz8G+MQhE29wWc5KRqiqKpbOJOw==
X-Received: by 2002:a05:6e02:152e:b0:3a0:7687:8c2d with SMTP id e9e14a558f8ab-3a08495a790mr13830495ab.26.1726126829641;
        Thu, 12 Sep 2024 00:40:29 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:29 -0700 (PDT)
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
Subject: [PATCH v2 24/48] accel/tcg: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:57 -0700
Message-Id: <20240912073921.453203-25-pierrick.bouvier@linaro.org>
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
 accel/tcg/plugin-gen.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/accel/tcg/plugin-gen.c b/accel/tcg/plugin-gen.c
index ec89a085b43..2ee4c22befd 100644
--- a/accel/tcg/plugin-gen.c
+++ b/accel/tcg/plugin-gen.c
@@ -251,7 +251,6 @@ static void inject_mem_cb(struct qemu_plugin_dyn_cb *cb,
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 }
 
-- 
2.39.2


