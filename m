Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4725204F95
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732374AbgFWKvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:51:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46038 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732361AbgFWKvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:51:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592909498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LVjwKVhnoJ/NkeP5BdSwAibBor9Meggq390h5glu26Q=;
        b=DwmVE5ad68785tPUJ+lb+3agrbLi61OIpxdFYj5Y368vovtmBG5ZA5TkFxkv+z/q/2Ao7l
        zFMiyiNRfyTXaS+OMbbGIxWaSpEczosCNNBMXvPYqBMSheI9j6HWO1wsaR35gZDsPybT5I
        kMph1Nm7/GjuP/fNT4X+XGqDNNc6Nr0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-51uIWFUVOSaSD6eLgAWmSQ-1; Tue, 23 Jun 2020 06:51:36 -0400
X-MC-Unique: 51uIWFUVOSaSD6eLgAWmSQ-1
Received: by mail-wr1-f71.google.com with SMTP id y13so1665415wrp.13
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 03:51:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LVjwKVhnoJ/NkeP5BdSwAibBor9Meggq390h5glu26Q=;
        b=U7cwsN86ZtTz+b89fYYAK0cdl8pBwoKD36HNxVwzLHYvm/nPfFsjaJgUq0uxhjio4z
         1vbBTfX9EhwLXRsB7IYZH2lsHO9EE437b72rO8Dp9Fp6HrmUh3f0bHD1YfkoBqsJ3v6r
         hJ95E/cXVhSmY4vU7Ir1t9yZ86D2R1R8GSV+Ux1Z9iP1qQAlUOnY4nZ4OnttPfLF3Ofj
         O44SruZRYt/O3QttOb7J1pyry8TnGjee7PSi56eAWHue1B+R6fOVufSVX9s/vguuxqgb
         fzjAyj5yaGnipaJ20rkrpO9hFhNSsWozmSKh87+ifLsJIQ941B5PE0iWfvHlTTS+DJus
         Ksyg==
X-Gm-Message-State: AOAM5315gO8Ys4FahtUlLzNtxJxknZR4N9F9qcm4WqyCCPb3ycvRln+7
        k4/xr+PItOYOKrJZ67ZzLvbuydgEYx0yOx/S22pylcV4Lawme/wSIqQblXn+QpculmBCki52gdE
        5v2zKq2ouM2sQ
X-Received: by 2002:a7b:c08e:: with SMTP id r14mr24504245wmh.78.1592909495610;
        Tue, 23 Jun 2020 03:51:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+lUmsOxGGyNhicD4Qre6EUQ9uDD12JC437h5LIw7lhq7cKVmWoabmNrYpUWBP1jZa8ZjEtQ==
X-Received: by 2002:a7b:c08e:: with SMTP id r14mr24504225wmh.78.1592909495383;
        Tue, 23 Jun 2020 03:51:35 -0700 (PDT)
Received: from localhost.localdomain (1.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.1])
        by smtp.gmail.com with ESMTPSA id b201sm3199953wmb.36.2020.06.23.03.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 03:51:34 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [RFC PATCH 7/7] target/i386/kvm: Simplify kvm_get_supported_[feature]_msrs()
Date:   Tue, 23 Jun 2020 12:50:52 +0200
Message-Id: <20200623105052.1700-8-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200623105052.1700-1-philmd@redhat.com>
References: <20200623105052.1700-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the MSR supported features should be the same for all
VMs, it is safe to directly use the global kvm_state.
Remove the unnecessary KVMState* argument.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/kvm.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 626cb04d88..988ed3c238 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1887,7 +1887,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
     }
 }
 
-static int kvm_get_supported_feature_msrs(KVMState *s)
+static int kvm_get_supported_feature_msrs(void)
 {
     int ret = 0;
 
@@ -1902,7 +1902,7 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
     struct kvm_msr_list msr_list;
 
     msr_list.nmsrs = 0;
-    ret = kvm_ioctl(s, KVM_GET_MSR_FEATURE_INDEX_LIST, &msr_list);
+    ret = kvm_ioctl(kvm_state, KVM_GET_MSR_FEATURE_INDEX_LIST, &msr_list);
     if (ret < 0 && ret != -E2BIG) {
         error_report("Fetch KVM feature MSR list failed: %s",
             strerror(-ret));
@@ -1915,7 +1915,8 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
                  msr_list.nmsrs * sizeof(msr_list.indices[0]));
 
     kvm_feature_msrs->nmsrs = msr_list.nmsrs;
-    ret = kvm_ioctl(s, KVM_GET_MSR_FEATURE_INDEX_LIST, kvm_feature_msrs);
+    ret = kvm_ioctl(kvm_state, KVM_GET_MSR_FEATURE_INDEX_LIST,
+                    kvm_feature_msrs);
 
     if (ret < 0) {
         error_report("Fetch KVM feature MSR list failed: %s",
@@ -1928,7 +1929,7 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
     return 0;
 }
 
-static int kvm_get_supported_msrs(KVMState *s)
+static int kvm_get_supported_msrs(void)
 {
     int ret = 0;
     struct kvm_msr_list msr_list, *kvm_msr_list;
@@ -1938,7 +1939,7 @@ static int kvm_get_supported_msrs(KVMState *s)
      *  save/restore.
      */
     msr_list.nmsrs = 0;
-    ret = kvm_ioctl(s, KVM_GET_MSR_INDEX_LIST, &msr_list);
+    ret = kvm_ioctl(kvm_state, KVM_GET_MSR_INDEX_LIST, &msr_list);
     if (ret < 0 && ret != -E2BIG) {
         return ret;
     }
@@ -1951,7 +1952,7 @@ static int kvm_get_supported_msrs(KVMState *s)
                                           sizeof(msr_list.indices[0])));
 
     kvm_msr_list->nmsrs = msr_list.nmsrs;
-    ret = kvm_ioctl(s, KVM_GET_MSR_INDEX_LIST, kvm_msr_list);
+    ret = kvm_ioctl(kvm_state, KVM_GET_MSR_INDEX_LIST, kvm_msr_list);
     if (ret >= 0) {
         int i;
 
@@ -2107,12 +2108,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
-    ret = kvm_get_supported_msrs(s);
+    ret = kvm_get_supported_msrs();
     if (ret < 0) {
         return ret;
     }
 
-    kvm_get_supported_feature_msrs(s);
+    kvm_get_supported_feature_msrs();
 
     uname(&utsname);
     lm_capable_kernel = strcmp(utsname.machine, "x86_64") == 0;
-- 
2.21.3

