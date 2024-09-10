Return-Path: <kvm+bounces-26355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60104974581
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E42A1C20A3F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 646751AC895;
	Tue, 10 Sep 2024 22:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nkDpA4oL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B351ABEB3
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006584; cv=none; b=gJkoO8uiKJEs4AA7S8BIw7Q53f2pX56F+qQsCw6QBVNLopM1DDBDYVszjpZ/sScEawbAXE2xmQC/danwXQKJQe7bXp5qXU1k8u+skiHtP2+Jz6IkGO6UP/fUVEMedNHBmWxDP++4w9UqsMB2Qcjc0LZthInTKsy8u13g6wuzJDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006584; c=relaxed/simple;
	bh=MRe9PQTAv9qPdjpNLZJUkYhfIrlDNC+Nd4rxUtgNywo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DMeayDXBuoc0kR39WKhY49pXKYy9qEmD/0nisEGbJ6mdwPNTkZ4XGOCqd1IV5xrP+mrGd3dc/ciHu8QtlXYoCJbw/2zKqQrm9c5q7uQrTVgLU2PaxuDyVIQmvr3+FIHNcxGbSkICYZBetPd9blHhUFXyECbOsyLBK5DI/QuvGsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nkDpA4oL; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-718e1ce7e84so3015519b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006582; x=1726611382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8E41vvCuzFfFnWNVteAbOukx+NZntvmSmJeEnMZhnio=;
        b=nkDpA4oL1g4Dd5iRyEk7fNTXg94d5WGfSXNxjhm5aIPjVgdY9W/AjeVkTkWUCpzWLh
         SM1jj4aRLq+gYH0kQF/CD1wYopEZ5F2174i9o1NuY6Db+yMCX6gXBNjlm/VnzIucLUr4
         zlY/i0tCdWzJOMnJfgySmOxPwsyMcFUrV4iwQ6k30Y7l7hCZ4L6QEILK2Y8h1BzfRP05
         q9N9yjjLzIgKVajuWbfkfsIF+D8pyc/jok3saqmkC67v4bT1cV7+cshRxY0w2Tbn/p1T
         UJcp/IEvxS83mzuK0XtsQ++iufcKxWfCMjwVHmFEJ4spLYdAHLJ1Z5bvwGdwCEOiXfXc
         gBeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006582; x=1726611382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8E41vvCuzFfFnWNVteAbOukx+NZntvmSmJeEnMZhnio=;
        b=IHW9bzUi5yN62XtauttF8ep3sWn57J8q1Fc5PgQn71jEnvB+OYNZKpOGTOwwsCPJuU
         2+iRa5lMJ2g2+uxGqBDlJtOvmY6H0GGPwLYBV6OD/OPgmUCVU1AAVyuzSt/OELgDllJX
         Bbf7EImj2+Yi0pb83363PqsAHTs2kbqgLHYTOlO+MwSlOQtiQ6D4ulEcmOX1TlAJgOct
         HtHIL1ub4pSUn8SrQlg1brjhOpApeDrBOm6HcADqifI/b4aq+YEIUiJcfk9DNiwzRTLn
         KidLzorILxfvOp+OKkeKHYmycm8sc4PNPrOceN1H/k7FCLSdTZVLofgDc1UkqUeBy1FB
         Wb7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWXtPC3dEiHh9IZ3ia14OS/LIjXyyyuElvDxhvPNKKhMFM6SLaQ5EYrs4ZxUvXJnWk1Qws=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi6WX5O9tsmmtT0+pQRdQC2qwDWdCPxOYsDhM2mRDi+J5wDlfP
	nIpPC+Iam2aB5l9l2UM6zkt+Tdy0Bz5C3qVOtpk7FU7J5X6mo3cdre+dJ2aHZfE=
X-Google-Smtp-Source: AGHT+IEpm92TEZ7l/i72e03p8S1n7AWDI6NeOOFfrUtGzNn7Eo7pwNzB53KVkJOarI+xWw/0AjoAnw==
X-Received: by 2002:a05:6a00:218e:b0:717:9768:a4e7 with SMTP id d2e1a72fcca58-718d5ded0acmr15822990b3a.2.1726006582456;
        Tue, 10 Sep 2024 15:16:22 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:22 -0700 (PDT)
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
Subject: [PATCH 05/39] hw/core: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:32 -0700
Message-Id: <20240910221606.1817478-6-pierrick.bouvier@linaro.org>
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
 hw/core/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/core/numa.c b/hw/core/numa.c
index f8ce332cfe9..14283293b42 100644
--- a/hw/core/numa.c
+++ b/hw/core/numa.c
@@ -380,7 +380,7 @@ void parse_numa_hmat_lb(NumaState *numa_state, NumaHmatLBOptions *node,
         }
         lb_data.data = node->bandwidth;
     } else {
-        assert(0);
+        g_assert_not_reached();
     }
 
     g_array_append_val(hmat_lb->list, lb_data);
-- 
2.39.2


