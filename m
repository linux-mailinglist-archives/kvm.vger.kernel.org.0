Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404191A7F41
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733101AbgDNOLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728876AbgDNOLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:11:51 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC341C061A0C
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 07:11:50 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id t14so1266547wrw.12
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 07:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GvtAqeY4wcF5cHSJWbUUPZ/4lNBEU1p6u0M6rbzdBCc=;
        b=aBO2pfrBdvy7EYjt0lkrxav10RgDcxHeMPovyZwU8vw+g+8kWgsiPOk28G1QmJjYX7
         zAxHfl5TGy7nfEKlSWdxPmsv6+5bGcqj+i8sY4Jn4w79FkaVFP8HkzF7+fiDRl0359iH
         M10pW2HxIdbZcZif0EfNzEtLbwVh+c8PIB1KGVMpQ57GAoq2YTI1r9jUClWpiVZkLKwN
         sgAtqKhyxD9M+7bojsGtL7XFANgX6bcnUvIOs78H3YWdJUa4bjzd0SQA6KawoQzsAPj0
         K3xaCrLIir586+P4uNLYDQPgEndKzik6TTgi6zt+RYOURYhmKpZ8S6/+AMHJIIHUC25y
         UAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=GvtAqeY4wcF5cHSJWbUUPZ/4lNBEU1p6u0M6rbzdBCc=;
        b=fI1pG+Br89M2WFTDH5+f6XnloeL353ID6l3pVx90LNcBj7ReP9aGsrdbrLEwzPfQS0
         e2gK4udmTD5ijIRMt29ySMGMHqQfVW4TIONa9iNHijDkAk9egTRKi4vKsf5pxeS3BkCG
         bZ6teN/RWER6xPoaqKK4ZKV28YydOo8/HpsPkguwcjX0p9tSesv0Jypl3NSO/arPsl0E
         2XzBaLjG0jxSTisshgH63w6haMCiiU9gZ951p+oZGhl/LLGqHQ91mecuLq2EA3rS/G4w
         Hdf99Vi3Y7a4tjA9vii9iGO1yMozJGZHCngGWBtnKmfh5QtZYpzL0XGW4obxNiutYSB9
         4vrQ==
X-Gm-Message-State: AGi0PuZmmvgrYSnfOF+c1K81VjTJIg9lhu2GOe+zFC+72CB9qCuSi68F
        98xmlaYtyZlYXpYR+rmqmjMyPaFgEpQ=
X-Google-Smtp-Source: APiQypLIIEgjLOaUzr0MvG/JAXrOODx6S+2PjlxwiDv8AqKupHULAcgatNm3qoaXjZh/6Os317/3RA==
X-Received: by 2002:a5d:6503:: with SMTP id x3mr17510221wru.153.1586873509292;
        Tue, 14 Apr 2020 07:11:49 -0700 (PDT)
Received: from donizetti.lan ([2001:b07:6468:f312:503c:7b97:e286:9d8e])
        by smtp.gmail.com with ESMTPSA id v1sm14637217wrv.19.2020.04.14.07.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 07:11:48 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     vkuznets@redhat.com
Subject: [PATCH kvm-unit-tests] ioapic-split: fix hang, run with -smp 4
Date:   Tue, 14 Apr 2020 16:11:47 +0200
Message-Id: <20200414141147.13028-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test_ioapic_physical_destination_mode uses destination id 1, so it
cannot be run with only one processor.  Fixing that however shows that
the self-reconfiguration test is broken with split irqchip.  This should
be fixed in QEMU.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/ioapic.c      | 3 ++-
 x86/unittests.cfg | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/x86/ioapic.c b/x86/ioapic.c
index 3106531..ad0b47d 100644
--- a/x86/ioapic.c
+++ b/x86/ioapic.c
@@ -504,11 +504,12 @@ int main(void)
 	test_ioapic_level_tmr(true);
 	test_ioapic_edge_tmr(true);
 
-	test_ioapic_physical_destination_mode();
 	if (cpu_count() > 3)
 		test_ioapic_logical_destination_mode();
 
 	if (cpu_count() > 1) {
+		test_ioapic_physical_destination_mode();
+
 		test_ioapic_edge_tmr_smp(false);
 		test_ioapic_level_tmr_smp(false);
 		test_ioapic_level_tmr_smp(true);
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index d658bc8..a4df06b 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -33,7 +33,8 @@ arch = x86_64
 
 [ioapic-split]
 file = ioapic.flat
-extra_params = -cpu qemu64 -machine kernel_irqchip=split
+smp = 4
+extra_params = -cpu qemu64,+x2apic -machine kernel_irqchip=split
 arch = x86_64
 
 [apic]
-- 
2.24.1

