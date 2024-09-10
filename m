Return-Path: <kvm+bounces-26380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 100EF9745B6
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:19:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 796A5B2486B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2ACA1ACDE2;
	Tue, 10 Sep 2024 22:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rNnXpnzN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DABB1AC444
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006672; cv=none; b=n5m20mQZTAr/rHE/uSpS/56G+Qd6bYYncEMCgKreyqQcNWoWcVckZnGFnuHUKOTIOD4LUAU5mlOHW8hwgELMiD7BoTUYgkBzybPUA+3eYHgb3Riw7N1kIJrIxnihQNHWpBy7TNt6A4MZ5SnFRo+vZDixhKF7ub17ExeEmpcF6/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006672; c=relaxed/simple;
	bh=s/0rl88v25EsYcfz4dkOzgaDOIDbi6VH77dMcntdP5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X/R5qXLWVK/AsIPweTKm0t9B37FpE22H+VCJDkVYyLQP9ek0PeYkkj3X3z5XsATKD+aOMsqJlyia2j6UEGx3qpo4EpLjR48y/ZrQXWNKKnlE8B4TQau9i08YElZo76Q6rWB4ZIUEvtg5KauSO6TtboPNjpYOwkvzdujfvTJPBU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rNnXpnzN; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7d50e865b7aso4609383a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006670; x=1726611470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYUGVuBQPVEKq8uP3q9x4VvG+Oea4tuw5RjsMn3QXjQ=;
        b=rNnXpnzNv5rI3GmQ+0EFZ5rW58EWqBeCzll0Wl5hMC1z/eqZwVHFu4Jk+PcHdFNAfw
         KOv+/uvAM97Z8no6nWgf1BNnNdVVpWH+z4tnQLwlJEjhw8S6qm025eHmykGdrASf6CUw
         251cLU9bonN5HCfHGHEuR6K7WbYo1lXT1Mac8PR3b4wW98xcoya9FjtXoS7zN8IGq0XU
         tMELEk6CAXYHv03i+Iv2NcgwHAbo8RUgGmmQwCCk3lA3IBlcDR1Xc2AIGQkkGKQYOTFF
         er5rr0qSxvG1r0l7W/t6dpLcL0ozYAnWpZCp2fMmynOK2Cyzi60fg408UCiQBvaubck6
         jMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006670; x=1726611470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JYUGVuBQPVEKq8uP3q9x4VvG+Oea4tuw5RjsMn3QXjQ=;
        b=uRXVZxSLofLjMNsFAOKgEGxI4dScjyYyzwVPGlWhoOpBlqrWPci2d3JDdPkHP0xVE2
         vC5mfjrgW2OYdYMB/XAt64U3Q0MwJrwV1tcTMC1yyVwzBtWpzGselAkerjF95aHNSQqF
         h4aleNnC2xzzqwXhWK0uHiyn91HsRK57Yi8YNx/0DUNxr4t5FZFjO0yGoKo8h0sRWWHY
         F+3J+CushygjpAi1lzozB9itvBcZ0yNai5zPZa1Qawz2V0+sov8HeBe+rWUzv12BbqmA
         +vnCCKBwSVOJAtDj9m/+g6AIzavhwU6H/WI1RhlRI5eJQh78RcscCFmXJZiVE+2B3B4y
         xEiA==
X-Forwarded-Encrypted: i=1; AJvYcCUGDlAtNO8uab7IVo2dR6JjJ06IpD7QcwoyX6L7jCR5y2ZkjTU7jmRbkslWQNfwndbz/3s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3xLBCU+ADFU1zextaBc2rAXuxbrzlIM9pfnEE/CSmKgVKLGMM
	dTRhD+i4Go1Nn6UVVfZ58q96ATr0WOlCjZynQxsUsbYQkrjfn00txqiEJZwcLfQ=
X-Google-Smtp-Source: AGHT+IGvdYbUxOn3oVTMiIOAaos8t5NEoWDicsVQH4rvVkTo7ZcM156Q62Eu90CVjvFHEgcLmkFROw==
X-Received: by 2002:a05:6a21:3a44:b0:1cf:284f:778d with SMTP id adf61e73a8af0-1cf5e0ae114mr3221600637.16.1726006669948;
        Tue, 10 Sep 2024 15:17:49 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:49 -0700 (PDT)
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
Subject: [PATCH 30/39] hw/pci-host: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:57 -0700
Message-Id: <20240910221606.1817478-31-pierrick.bouvier@linaro.org>
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
 hw/pci-host/gt64120.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/hw/pci-host/gt64120.c b/hw/pci-host/gt64120.c
index 33607dfbec4..58557416629 100644
--- a/hw/pci-host/gt64120.c
+++ b/hw/pci-host/gt64120.c
@@ -689,7 +689,6 @@ static void gt64120_writel(void *opaque, hwaddr addr,
     case GT_PCI0_CFGDATA:
         /* Mapped via in gt64120_pci_mapping() */
         g_assert_not_reached();
-        break;
 
     /* Interrupts */
     case GT_INTRCAUSE:
@@ -933,7 +932,6 @@ static uint64_t gt64120_readl(void *opaque,
     case GT_PCI0_CFGDATA:
         /* Mapped via in gt64120_pci_mapping() */
         g_assert_not_reached();
-        break;
 
     case GT_PCI0_CMD:
     case GT_PCI0_TOR:
-- 
2.39.2


