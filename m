Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5527B32C6F5
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451170AbhCDAah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377705AbhCCS2h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3WOU0ObUPkLYlvbEIzar57F9vUZTGCF79gCYDqtyU50=;
        b=FvGOvFJsz/fLD5+RdtJFZDwgcNo9ZKfjAHRgD1lBAEWliVbGu1onYBcX/bjXyj1/qWc9L4
        ua+s5kv2rwbiTAxcI70emj4CDOMrpu6aYkBX11YA9gg2sILteEf63yDryY8xBXV5gsiTfT
        0qgpD//WHvPgFp4jvVczNoxgHka98QY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-uK0UFzfeOS2752BtQwqIAw-1; Wed, 03 Mar 2021 13:22:51 -0500
X-MC-Unique: uK0UFzfeOS2752BtQwqIAw-1
Received: by mail-wr1-f72.google.com with SMTP id l10so13159846wry.16
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:22:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3WOU0ObUPkLYlvbEIzar57F9vUZTGCF79gCYDqtyU50=;
        b=maZmNwTn+94XQcpz3zyb/xnU1oJIvzlnGirHaGrgZdEejVS0IBMuOYS2KOA3+DcTUV
         LoZMD8Xn6vZnbpezHZQEheU3FUBnd7NcFpdQYkFm1dfA3gY7Bv5PsPmjFbZYKcT/Za1/
         AMRLgELY5YfG6sS2TCH3TpntKSVrWHv5JIRBsQEZJns6WxBCFvISJUiBorgx0et2CaaT
         +ooAHq3BqTWmnwQVjK6IQaBA1ATZO95Kl9PnjXv6l3iLceS47dxDOaz5zPfpu/hTKg07
         tHUctxzFywppjGpaqMk4X61ZPwV9+AUcn3HXbEfT/wiP4sHec2/838XwlOMrsMEI2qGD
         UHEQ==
X-Gm-Message-State: AOAM532VM27CVTbLkrB5yb3eyRu5+m8nYR7AK7pHDhjW3ax3aTGbM10Q
        UEVZdifMlfP8KpJ4gFV4E07N7K1aBXcDwAs4IoXhvUqq/sPb6iAkWx9WDynebvfcEoMmwvsccNP
        2xesvOw2ti9p/
X-Received: by 2002:adf:fe01:: with SMTP id n1mr28570467wrr.341.1614795770195;
        Wed, 03 Mar 2021 10:22:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqqykw9kqMqftlN/tD2Ahqv9Vq5lqc3xUzYUUXIkr2YeSmzmNjmOGpzqJYOAdnlKq3vN7dKg==
X-Received: by 2002:adf:fe01:: with SMTP id n1mr28570454wrr.341.1614795770019;
        Wed, 03 Mar 2021 10:22:50 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id a198sm6785613wmd.11.2021.03.03.10.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:22:49 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 04/19] cpu: Croup accelerator-specific fields altogether
Date:   Wed,  3 Mar 2021 19:22:04 +0100
Message-Id: <20210303182219.1631042-5-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/core/cpu.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index c005d3dc2d8..074199ce73c 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -393,10 +393,6 @@ struct CPUState {
      */
     uintptr_t mem_io_pc;
 
-    int kvm_fd;
-    struct KVMState *kvm_state;
-    struct kvm_run *kvm_run;
-
     /* Used for events with 'vcpu' and *without* the 'disabled' properties */
     DECLARE_BITMAP(trace_dstate_delayed, CPU_TRACE_DSTATE_MAX_EVENTS);
     DECLARE_BITMAP(trace_dstate, CPU_TRACE_DSTATE_MAX_EVENTS);
@@ -416,6 +412,12 @@ struct CPUState {
     uint32_t can_do_io;
     int32_t exception_index;
 
+    /* Accelerator-specific fields. */
+    int kvm_fd;
+    struct KVMState *kvm_state;
+    struct kvm_run *kvm_run;
+    struct hax_vcpu_state *hax_vcpu;
+    int hvf_fd;
     /* shared by kvm, hax and hvf */
     bool vcpu_dirty;
 
@@ -426,10 +428,6 @@ struct CPUState {
 
     bool ignore_memory_transaction_failures;
 
-    struct hax_vcpu_state *hax_vcpu;
-
-    int hvf_fd;
-
     /* track IOMMUs whose translations we've cached in the TCG TLB */
     GArray *iommu_notifiers;
 };
-- 
2.26.2

