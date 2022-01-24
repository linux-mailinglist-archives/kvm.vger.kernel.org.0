Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6F9499CC1
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 23:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380120AbiAXWIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 17:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458053AbiAXVmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 16:42:44 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF40C0419D5;
        Mon, 24 Jan 2022 12:30:12 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id a25so9722808lji.9;
        Mon, 24 Jan 2022 12:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kzTVh1Uj9CB0rrMx8+UTj8sMwZ1dWsFJyOIw9wz4SCY=;
        b=AgwNbDN/9SGFAevlHvPQ/SgZ48DjERb0nTmPJwXdtXAAuLCIokl7/JseIUBAd4W84X
         HEYUhFreZsY2UvjiyMjQHjMCyvuRv8xjvjggx+dbc3tusfLA6a/Zl6T/1bq8nhoFqdmY
         GUJkUlZdrkwDCedSbIli8+kDyBFU+AKdZbmTWRLD/CcXlTGRiLtUziI9GsQ1/X/KISIQ
         HOsnzJTWNeY6vNIJR2GlDx8pw63DpeoEf5Axc7RGnJE9GprevHjNWEiglc5Ok77ENtk/
         OSpR2WA/KlrYc5wZSMXEAwM5+tX35i8k6pD0Hb+vSoona8hlcKA/BPkur4D0aKI+48Ji
         whnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kzTVh1Uj9CB0rrMx8+UTj8sMwZ1dWsFJyOIw9wz4SCY=;
        b=25CFAHGZ1+o6Jzf3YfFM822m0fatMf1qA/LSzaqDKEDDgEk8FiKPb2OcSFrB5Me7S/
         FrlFyJiG3eJSCUsdRxv95uLq0vHdg43j2jIXSpLDGp61hZSvIHW2tmj25JU/4dcfQhT3
         9qem6VdBrZUCkUySxdNJnm8Bx8Q0hC/6rBciii1KAYllpppedbbXsxROLd8BK5uKd4EJ
         hW308/PRhBY2qXdGMe0JDNqqkmFRLD1+6UD5zm7QLk7e9hKRUlpwWwUugtvWuxoV2eKS
         vbhflR7s4VH7saBKSgy7lEq4poOgOB4KRUDoMHUI1mAQQ+SdKqB3N4yPuE4Hxj8A0HhX
         nk6A==
X-Gm-Message-State: AOAM530lyRrO0V3dXRi/Pj+aokg/flk/64ETPqMJOVvB7yEWUiRcsgi0
        jD/qnqLyepYBHfc0K9Hea8fnRrRGnfZaZQ==
X-Google-Smtp-Source: ABdhPJxAOu2G9kaRBdEwBp4Ira/soT1cXeusM2MEtCjGf39yHQRJpqBkb7ozy9McyqWZ21MTNVJkHw==
X-Received: by 2002:a2e:9dce:: with SMTP id x14mr11534147ljj.33.1643056210946;
        Mon, 24 Jan 2022 12:30:10 -0800 (PST)
Received: from localhost.localdomain (h-155-4-221-129.NA.cust.bahnhof.se. [155.4.221.129])
        by smtp.gmail.com with ESMTPSA id h6sm199125ljg.58.2022.01.24.12.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:30:10 -0800 (PST)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH] KVM: vfio: Constify static kvm_device_ops
Date:   Mon, 24 Jan 2022 21:30:06 +0100
Message-Id: <20220124203006.11704-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vfio_ops is never modified, so make it const to allow the compiler
to put it in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 virt/kvm/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 8fcbc50221c2..0b305f13489e 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -384,7 +384,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 
 static int kvm_vfio_create(struct kvm_device *dev, u32 type);
 
-static struct kvm_device_ops kvm_vfio_ops = {
+static const struct kvm_device_ops kvm_vfio_ops = {
 	.name = "kvm-vfio",
 	.create = kvm_vfio_create,
 	.destroy = kvm_vfio_destroy,
-- 
2.34.1

