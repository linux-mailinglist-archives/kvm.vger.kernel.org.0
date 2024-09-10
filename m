Return-Path: <kvm+bounces-26385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDC69745BD
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:20:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12C031C25526
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C811AE87D;
	Tue, 10 Sep 2024 22:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v+EjWw1v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0E11AE86C
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006685; cv=none; b=Gh28MPkhh6pxiq35KDUSAOZyM7O8s84yiRqNGZXYFcjEcSjSwM+jRcwzNq3VwsC5Lp4ttqB9l13M9z0+x8u9+SjjccCaijzKW4nIio5Y437cxap9g/wuY0fQH9zwMOeqB/53zc9i+RXN5OypJPPHCzKOg72H4OZW3T0PFhL0SsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006685; c=relaxed/simple;
	bh=1AGBMR1/NWeP+5I7hPVtba982O/XvPhQ9gUCXm1FDK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lXf1Zald0sLZc8NcM5q1fju53Lu1KGgiBXwZAVz0/vT3ccW6rLYjh05VY5zrcQ0VHFTlpGbvBsY13wnAdTwJLJ4QKPE5HIkpiXj1XSCO1DopNp8AJq+0/THXz2iWeDz5OQQiSQWy63qkKWzUoWhlkVzpnf86smupWnyGk2n0cA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v+EjWw1v; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7d50b3a924bso1840607a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006684; x=1726611484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HVlIH0vLGwHmaRGMFANFNOikFJyMD1Z2/NyDN944UZ0=;
        b=v+EjWw1vLgH19WwWVNrWPCAnk758zu54eYzgWm2cqQHxncjhVZxx3EnNvG5KtkhjWB
         3EfOhlXXn3RVMNDsa0v1wt6RQdtZsGmk/t50AJi2iAFMaqTMBVADJo2J/+ysY65pmgnj
         NBXhTMoLFiYz2LgAniU5WnF7Ey3ydqOUb2xfji8HnN3WXeXByQJ+ayDSFr/yGXo0Cxik
         OzeVDkX/TIu95G1p+ziIQe8D+HCKuSvnVt12PO398a1kTgEmupV790fIBJRv6glz00c8
         n3GaJ9lfqWbczwIUPnRPCYImYv24m1L+SS9l1uEmVjaXMu0VcilK+gsHaaB/GOvhs7eO
         DpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006684; x=1726611484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HVlIH0vLGwHmaRGMFANFNOikFJyMD1Z2/NyDN944UZ0=;
        b=B9q36yiLBQul3e01CczSfCvehPL5HmQ3h+oX2DjjIO8OUbs02K3F8nQwWGoshgZaia
         uZMBxiNiNTcm14DYaW5xPdf7ze2wfo3hwXqdQOaghqY7PvDFyejRZERbxUEJ/SiOY8oy
         CIvrJAfE4m2v6Jx3KZ9Ub/0/SEYCuOdQpvudDweW974WicDRyQDfYWNyJK2VO47vaLpi
         uf8ljOGzMEFlVTSrYjp8yQ/0tw7KUKG2UHj31mdGOtb66sy3rIjkEaIb+VSG4NLy3mP7
         rHR9mMlhnYfOHxHmnl157MjwSvG3zH7a1EkHx27Yb0UKLN7tCBKodg0kE/2cSLgrie5q
         3o7g==
X-Forwarded-Encrypted: i=1; AJvYcCXstpdwUC8bKGJHro/2lthBCSVNrvdkU65IfyAe5RwUAj+klr1uUEvv0s0TcF5+A3z4/y4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMLX6xjh+niVfjT4PnlXVtu6SuSUW7zujuXJ8OWtNoZjz/9EjO
	DRNj7OKqI/pNpTveeT9GV8bo2JONkVkMGWd+7mLtJ9d01nv45qLrN7F7FURTUDM=
X-Google-Smtp-Source: AGHT+IGmxzzneUTyXUzTC7HDyLbhq6XrgpPzar4wgVhFnulO1e/5MM9gmR+Gi+k9UlOi7JBGbi98dA==
X-Received: by 2002:a05:6a21:4a4b:b0:1cf:2df6:453f with SMTP id adf61e73a8af0-1cf5de0ef4cmr3537960637.0.1726006683723;
        Tue, 10 Sep 2024 15:18:03 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:18:03 -0700 (PDT)
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
Subject: [PATCH 35/39] tests/qtest: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:16:02 -0700
Message-Id: <20240910221606.1817478-36-pierrick.bouvier@linaro.org>
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
 tests/qtest/migration-helpers.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/qtest/migration-helpers.c b/tests/qtest/migration-helpers.c
index a43d180c807..00259338833 100644
--- a/tests/qtest/migration-helpers.c
+++ b/tests/qtest/migration-helpers.c
@@ -76,7 +76,6 @@ static QDict *SocketAddress_to_qdict(SocketAddress *addr)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 
     return dict;
-- 
2.39.2


