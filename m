Return-Path: <kvm+bounces-26382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4AD9745B9
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:19:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 525131C25717
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B9C1AE035;
	Tue, 10 Sep 2024 22:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZNHq0Rrt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0301AD9C2
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006678; cv=none; b=Pa9LHzTLKEPYsclOMfngkoG1kznmKGEet06gis1cMxPsaGPSboBATgDiQHuYmCIGzcBPmTZOHhzFT+RVFtLkOVTnj9o2c73bqsShKTei4hsHWWBKX5CCfQl2u/N+g01FgVvFymgpyq42CNv74DhhN4QxvElARtLb3+YLFxlqRag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006678; c=relaxed/simple;
	bh=bViVuhrF5pJxEDyATj+rI+6Btpw2tOS8X954m8ogHCs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NE7N1FmROukoOLlraU7CE7bRWWcQSt6GZS96b6BrboN2j9pfuHJ/zLUQ2F8KcjtXhFB7xHt2nJAkVV9Bpy3XwcdHLURrDJoV+liUyfe4kgWaqDWt10TgPTq6F9XsPc5XqqjqxVCb44Isp7AFwiWUZEuHUXV2USyqX+tIWd3bSnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZNHq0Rrt; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-718d606726cso3379666b3a.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006676; x=1726611476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qnKY2nRodBoXlCJxTEKFwGzTN7ry8AAwSqqRpoqXdQI=;
        b=ZNHq0RrtgE6eiLtff1yJV3rEkUdAAi+tJyOZcyjalS2NsoWppTZus3Ci4RUQv1W7HI
         qpmsl2eP0zfiK2ohO/sXwLhuKgLul3P46MYpOBh+QSsiR8KC3WkMb4lUpDANWpBmvqJZ
         eDFBguBEMY7oCjwL8pbFfSlgAyH30ADD8qGndJD/C+9bvN6LINPfWulGm8B6G4Np0Eqz
         9XmgmO+xj3g6gYlM96OBEwr7DReJDiM7irpJ2/lrvHKXtbFJSg4GRgxWsBgraBi/0UVV
         ELonqDJ+Yd21tIUhOqeMaWTb+YIepH1+ONAbsuVyKwi6tma/YcEo5tWUlFwmgk6WSf9s
         b4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006676; x=1726611476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qnKY2nRodBoXlCJxTEKFwGzTN7ry8AAwSqqRpoqXdQI=;
        b=GdIulTssc/UIcUZihCWtc9h+72qdSe7eDf8UbjYWiCeHvQ7uVwzPhcoG57EMBD7rTj
         isRMFNV19XzH0Ws35jYljMQYpvdlatpaQTyPFgOWU4TmXG4t5VBtiVtqPaUMTmS+kNiB
         vG6ClBlkp3cpZO1OxMg+18Jh/Xr9CVN4n3yJNHKSQApnQIJYAyhMaebU2tJ8kJ+OHlTF
         mpN9Yz8jiMJOydz0bInCO+V1xqSuITuBwy0VJtq2oRHDjhfnA6egNchzXj5bSG8vvsVg
         w7Gmi8UIk5jmxflrokeBfActfAm/TH+D9eMpMnueFM10L9sXJ+fgySUF733WfLTvE5q2
         y+7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWwetFIJVhuJOmvYDeQqPyC/8gvqQF23oQB5AZZQj+JBvlznThRvNyvtHmmfIh9eP0og98=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLAB+1DS8/htKVcjP7WBLnUGR81DoO42vjYAukF5e/5eWGXoG2
	OkdJyq60hq1v/2yuR5DasBvUyZgEF8wOyr+3/TBhFxVRsTO7F0mHDCpLIqBSFBs=
X-Google-Smtp-Source: AGHT+IG4cFG5WUgQCn+PBNKJBzHgRuN4SjwOR6zpKqMGbFV0/QZbeUwbVdFfJerNt+rSe5+kt4gssw==
X-Received: by 2002:a05:6a00:b8f:b0:70c:f1fa:d7bf with SMTP id d2e1a72fcca58-718d5ded8e1mr25670829b3a.4.1726006676561;
        Tue, 10 Sep 2024 15:17:56 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:56 -0700 (PDT)
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
Subject: [PATCH 32/39] hw/tpm: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:59 -0700
Message-Id: <20240910221606.1817478-33-pierrick.bouvier@linaro.org>
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
 hw/tpm/tpm_spapr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/hw/tpm/tpm_spapr.c b/hw/tpm/tpm_spapr.c
index e084e987e6e..5f7a0dfc617 100644
--- a/hw/tpm/tpm_spapr.c
+++ b/hw/tpm/tpm_spapr.c
@@ -206,7 +206,6 @@ static int tpm_spapr_do_crq(struct SpaprVioDevice *dev, uint8_t *crq_data)
                 break;
             default:
                 g_assert_not_reached();
-                break;
             }
             trace_tpm_spapr_do_crq_get_version(be32_to_cpu(local_crq.data));
             spapr_tpm_send_crq(dev, &local_crq);
-- 
2.39.2


