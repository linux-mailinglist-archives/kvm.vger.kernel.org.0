Return-Path: <kvm+bounces-26648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0157D976313
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1C93280FE7
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3D119F137;
	Thu, 12 Sep 2024 07:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nFRqFEKx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590DB19F132
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126852; cv=none; b=KEXmQPHJEQ8oRSvjT5ewxg2qxfRZZrMEzqpbGOwvT4KH0U15/on0VVvHEa1N0GcZ3t0m644Y+Xd/dEUc0I+TGCe3Uv0RRcQvLMggJeZOXpW1F4NWUcICi9cOzoFNSYJoB/uuOjdtpDlAvNBdtXMYbfiOemajLF8DS5pP13f46jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126852; c=relaxed/simple;
	bh=iPFi/mpyhuW5OJTeNuwRNlqh7FyqXyl7xKSZqYwXCio=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sWDCaNcglk8KqRg9zgEGD3wJrXN/40rVeZtUSOE+X0srFxHLOpwmOa4UtlrqAUkAYnhXZKppZD0CVsaWZLzUIh7+qhOacM1mcyr5NXSX6sZEhkmWXMiJ/ISOFS7HFETvHjUkqh5r3vUyAds7ICucg0mEu53Ja7CxFFaDi74rOP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nFRqFEKx; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7cd8803fe0aso508010a12.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126850; x=1726731650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rh7of/t1MbINnko2jvt6jPS7AWm2aGYUlEka7psebCY=;
        b=nFRqFEKx6WvzZXAeBAMX/ga85p+jEzP8EJiTpazu6rPYXKB635XP9KELrg8Wm+C/gI
         fIAJ/8amRqXeHQ1UW1QM/T5tnceCzauY1I9dmoKQ5NdnuMcx8ryodttbrnJUQVc8FmBg
         +h6PTde3eI43cZgh/1jSJSiXduxn4unk+LvpfyM6BXc7Hj0Vd5rd5AMCDZXvoIVxFFLB
         IMt9+5BH9kJuEH7MZwc2sx+D/eAT5z36GRFh3K1KwySV122/+cUSaj8roAMXt1rQEilT
         t9kIs8eCcKGUWwusY4qoAVOskZpyxHJ9LtW+UvmzJUOqVvL3GAUnKGM/eHPKjzbT47ps
         omGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126850; x=1726731650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rh7of/t1MbINnko2jvt6jPS7AWm2aGYUlEka7psebCY=;
        b=VNGOtRdYF/sOMShPu+moObi+tCOMzL/0InTJpi7L+42BrX4Xyx5ykn7/tXjeW1rVEY
         trlMxpkewZXElgamOvDjQ3IDKBzlQB5iCnJ9OMAy0RM9u2/UhB1H0+XyJSr/qxmFoQ5L
         KPybwrQohbzKrGOLkLdVrR71liYlKJwg85R/a4u/y4z885FJW47BHX8yPt9s9cJKUXDe
         HkvFO0FyrqG7fm32SKdDgngSBrBdY9DkNxu0S+qWnVyPongFC/PUXK/FVtdDT8XRXP2w
         He0O5NU3ziIPFXbHZhoAa90t5ogyzbvNMlnS45yy+u1b6kqCeS3hirKJycZGHqtm2EWa
         uAMA==
X-Forwarded-Encrypted: i=1; AJvYcCX6EFc5+ta/toew6yJQdRq78gGbEZZupyzqqVKrhG0CvN7r3IFYEOfyG7KFMeCrIbl2VcA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx71R9BNylaqL7ltvoioUMu3T0VURwmnELdvThXTZBYy0UT2By1
	+2MCKls5JuJht26A1WTjF2VbnTAuaJpwK1O2TzJTUpjn6/OA6qhig1aVKoJBAds=
X-Google-Smtp-Source: AGHT+IE/Mzhsmhy28ucIa8utEKYRtipx+MoivQXHJ4uIjGCaMxhEkc7uFeHW+uTK+aUE2aAYgUkm3Q==
X-Received: by 2002:a05:6a20:2d0a:b0:1cf:2513:8a01 with SMTP id adf61e73a8af0-1cf75f0f0cfmr2364705637.26.1726126850599;
        Thu, 12 Sep 2024 00:40:50 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:50 -0700 (PDT)
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
Subject: [PATCH v2 32/48] hw/tpm: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:05 -0700
Message-Id: <20240912073921.453203-33-pierrick.bouvier@linaro.org>
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


