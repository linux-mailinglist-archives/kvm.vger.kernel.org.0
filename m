Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AFF44230A
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhKAWLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:11:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232027AbhKAWLx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:11:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hSQaBGBpJWy0B8DIEKBqKdfykrzA4ow4TzC1HWV6kH0=;
        b=hNSNMXU2Y/ryCTwvF3V47yRHi+POxwBr4glDBEfYK0S0Ns5en9qYlDbeWezXQMwMhHb6MF
        OWKSfyUcZnxqlywL8QICTVFh9cuj2k3GFG93i+t2kCnnKwFJvGDewoZ3tDcjlv9S0F5Y0s
        PZGrDGd+EHen92OgTkJja7gRK8dXI8U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-2rrkSFN2MiuKcME313qIvQ-1; Mon, 01 Nov 2021 18:09:18 -0400
X-MC-Unique: 2rrkSFN2MiuKcME313qIvQ-1
Received: by mail-wm1-f72.google.com with SMTP id m1-20020a1ca301000000b003231d5b3c4cso173225wme.5
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hSQaBGBpJWy0B8DIEKBqKdfykrzA4ow4TzC1HWV6kH0=;
        b=KtEC0JLvJxci3t770m+J44IeLAjiwkClpWm1Hl3ldcn/AfbRa3z2ETnp9vNxG2wpH5
         mlKJY+DWfKb1OoZBrylhN/JkGUWPrF8jDHEY8u8zpcXJNpsR45uGbgBhaZqCr7dNbJE1
         B9Du7xE/NjgKqAFhwTf963h3XjgVlOA+NaUTMPtuAgBHP3Lcdv2O3mzv/ADlMhuZViTi
         hHFzdOjdi7jCsMImmGrfXhk4br4dr7cWFw8IwqBL/2gtJIwzXvLH8Cg/Le11Xd8eB4dN
         cATeOJS7xIzIRIL93W2edQxQse3Nu4e0PXrnfG4AVvUqw5USqCN6Pl6AHCnMer7KhEC1
         gcQw==
X-Gm-Message-State: AOAM533p+ZRZirOrg3GhgWTOC8YARKrYVqwctHCN1mUKgtOipoLY0IzU
        hthgnSm2X26oLBb7OpOhANBxnLZNj2cFJ4/7F8jHvmjFI6ZETU7q8Xetc5bB1CiIBCzh3djQ9Kg
        NWbLDV+LXsZ5V
X-Received: by 2002:adf:a78a:: with SMTP id j10mr42370725wrc.105.1635804557396;
        Mon, 01 Nov 2021 15:09:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHSBNKTiLO5JlEV3iFexkub7waHAM8W6BpiJr+wCxnuH8FeGBZ5Ook1cyDpaRUcX/w/4yrnA==
X-Received: by 2002:adf:a78a:: with SMTP id j10mr42370691wrc.105.1635804557180;
        Mon, 01 Nov 2021 15:09:17 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id r1sm726567wmr.36.2021.11.01.15.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:16 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Hyman=20Huang=28=C3=A9=C2=BB=E2=80=9E=C3=A5=E2=80=B9?=
         =?UTF-8?q?=E2=80=A1=29?= <huangy81@chinatelecom.cn>
Subject: [PULL 02/20] KVM: introduce dirty_pages and kvm_dirty_ring_enabled
Date:   Mon,  1 Nov 2021 23:08:54 +0100
Message-Id: <20211101220912.10039-3-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>

dirty_pages is used to calculate dirtyrate via dirty ring, when
enabled, kvm-reaper will increase the dirty pages after gfns
being dirtied.

kvm_dirty_ring_enabled shows if kvm-reaper is working. dirtyrate
thread could use it to check if measurement can base on dirty
ring feature.

Signed-off-by: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>
Message-Id: <fee5fb2ab17ec2159405fc54a3cff8e02322f816.1624040308.git.huangy81@chinatelecom.cn>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 include/hw/core/cpu.h  | 1 +
 include/sysemu/kvm.h   | 1 +
 accel/kvm/kvm-all.c    | 7 +++++++
 accel/stubs/kvm-stub.c | 5 +++++
 4 files changed, 14 insertions(+)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 1a10497af3..e948e81f1a 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -381,6 +381,7 @@ struct CPUState {
     struct kvm_run *kvm_run;
     struct kvm_dirty_gfn *kvm_dirty_gfns;
     uint32_t kvm_fetch_index;
+    uint64_t dirty_pages;
 
     /* Used for events with 'vcpu' and *without* the 'disabled' properties */
     DECLARE_BITMAP(trace_dstate_delayed, CPU_TRACE_DSTATE_MAX_EVENTS);
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index a1ab1ee12d..7b22aeb6ae 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -547,4 +547,5 @@ bool kvm_cpu_check_are_resettable(void);
 
 bool kvm_arch_cpu_check_are_resettable(void);
 
+bool kvm_dirty_ring_enabled(void);
 #endif
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index db8d83b137..eecd8031cf 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -469,6 +469,7 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
     cpu->kvm_fd = ret;
     cpu->kvm_state = s;
     cpu->vcpu_dirty = true;
+    cpu->dirty_pages = 0;
 
     mmap_size = kvm_ioctl(s, KVM_GET_VCPU_MMAP_SIZE, 0);
     if (mmap_size < 0) {
@@ -743,6 +744,7 @@ static uint32_t kvm_dirty_ring_reap_one(KVMState *s, CPUState *cpu)
         count++;
     }
     cpu->kvm_fetch_index = fetch;
+    cpu->dirty_pages += count;
 
     return count;
 }
@@ -2296,6 +2298,11 @@ bool kvm_vcpu_id_is_valid(int vcpu_id)
     return vcpu_id >= 0 && vcpu_id < kvm_max_vcpu_id(s);
 }
 
+bool kvm_dirty_ring_enabled(void)
+{
+    return kvm_state->kvm_dirty_ring_size ? true : false;
+}
+
 static int kvm_init(MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 5b1d00a222..5319573e00 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -147,4 +147,9 @@ bool kvm_arm_supports_user_irq(void)
 {
     return false;
 }
+
+bool kvm_dirty_ring_enabled(void)
+{
+    return false;
+}
 #endif
-- 
2.33.1

