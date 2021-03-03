Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E03832C728
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239980AbhCDAbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:31:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1386552AbhCCS3c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:29:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ozgu7uGJ7L5oIFikBv6nOOwVLHj62DaXoZ2b5Z4gqKA=;
        b=aiSvW3zc/Vp3XxL0KyrIWq0id2Mm5MS22g2C6ZKJYTydGtpQsPRPs1C1GQNZmau2RF2sO0
        Ftv/swKIpRVfEtOsFF5XeEUyZuxhCVCyTSIAVhx1v95ixKyqv2IV0zEe7y4fesQFZIjoly
        H7PmtBZ0qDR8SKYTjB/XDb2GYQB3pGU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-r6018QozNYKF5qr1vAktVw-1; Wed, 03 Mar 2021 13:24:20 -0500
X-MC-Unique: r6018QozNYKF5qr1vAktVw-1
Received: by mail-wm1-f70.google.com with SMTP id a3so2182216wmm.0
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:24:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ozgu7uGJ7L5oIFikBv6nOOwVLHj62DaXoZ2b5Z4gqKA=;
        b=LELbKiAh83i4fie9wCAqBOMuzRBfEUyDK0cobZk2Wll7HEM99kRvwiXdyPqTgn5bvY
         lixpVrMk4o8NlPrVDB9aDzEOMqYP4dd1qTRrE5ZbmAQdZA9yECCJFHyTWNpPN6uOPaOD
         qN6MgqccGkIE+md5HnNhF0GXksIB2kGqVE9i9TTNhBbknzkHnq1gePSbWUwGRftalHYJ
         6qV3xhVggYOUX5mcB6knKHoLGKAxv5ERxrBO/np4M65rxqR8tUMyCb3/4QaG4pYhRDOb
         oWuPKOPVvbSdj9uEu1HlMvMPfocE1TA5ZAEbYZ3Dp7kRLNehQil5jBHb/9sRE/6eyuhm
         NU1g==
X-Gm-Message-State: AOAM532mxVuRSnDUFvLm46IareaGnfEXZa7h3dr1Skmt8RHk0AVBFyAR
        JMXiTPimjY5nJberhaEVv/mmLnrfNcqjFmfT1faXdzLrdO10Dz5651aR6Sstru5lYTIvw8MyMIv
        GKdAEKrbTR7zq
X-Received: by 2002:a1c:2403:: with SMTP id k3mr290756wmk.130.1614795859021;
        Wed, 03 Mar 2021 10:24:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw+bwiGrhW1JytZf41VJLAQvq5kfy08h7D0p9N1gS+u3y7+Y378geBpKVUXOU+Y1nVBjdtymg==
X-Received: by 2002:a1c:2403:: with SMTP id k3mr290721wmk.130.1614795858585;
        Wed, 03 Mar 2021 10:24:18 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id j12sm23071093wrt.27.2021.03.03.10.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:24:18 -0800 (PST)
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
Subject: [RFC PATCH 18/19] accel/hvf: Declare and allocate AccelvCPUState struct
Date:   Wed,  3 Mar 2021 19:22:18 +0100
Message-Id: <20210303182219.1631042-19-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation of moving HVF-specific fields from CPUState
to the accelerator-specific AccelvCPUState structure, first
declare it empty and allocate it. This will make the following
commits easier to review.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/hvf/hvf-i386.h | 3 +++
 target/i386/hvf/hvf.c      | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/target/i386/hvf/hvf-i386.h b/target/i386/hvf/hvf-i386.h
index 59cfca8875e..1f12eb647a0 100644
--- a/target/i386/hvf/hvf-i386.h
+++ b/target/i386/hvf/hvf-i386.h
@@ -51,6 +51,9 @@ struct HVFState {
 };
 extern HVFState *hvf_state;
 
+struct AccelvCPUState {
+};
+
 void hvf_set_phys_mem(MemoryRegionSection *, bool);
 void hvf_handle_io(CPUArchState *, uint16_t, void *, int, int, int);
 hvf_slot *hvf_find_overlap_slot(uint64_t, uint64_t);
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index effee39ee9b..342659f1e15 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -451,6 +451,7 @@ void hvf_vcpu_destroy(CPUState *cpu)
     hv_return_t ret = hv_vcpu_destroy((hv_vcpuid_t)cpu->hvf_fd);
     g_free(env->hvf_mmio_buf);
     assert_hvf_ok(ret);
+    g_free(cpu->accel_vcpu);
 }
 
 static void dummy_signal(int sig)
@@ -534,9 +535,10 @@ int hvf_init_vcpu(CPUState *cpu)
     }
 
     r = hv_vcpu_create(&hvf_fd, HV_VCPU_DEFAULT);
-    cpu->vcpu_dirty = true;
     assert_hvf_ok(r);
+    cpu->accel_vcpu = g_new(struct AccelvCPUState, 1);
     cpu->hvf_fd = (int)hvf_fd
+    cpu->vcpu_dirty = true;
 
     if (hv_vmx_read_capability(HV_VMX_CAP_PINBASED,
         &hvf_state->hvf_caps->vmx_cap_pinbased)) {
-- 
2.26.2

