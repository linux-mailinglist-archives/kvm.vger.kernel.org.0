Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9853432C6F7
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344388AbhCDAal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377260AbhCCS2h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PLSHq+T6Ji51VQxldUQn+fMOB/V6gychel2awYEX8OQ=;
        b=E7PcqCyYOBd9ukCCdc+/8AHwW8lqYO0WDzFUSUaXumAED/qzPkESh0egDjr0WPky+zpjPt
        JanLpL/756PmrFe9kQA+l3ZkRfgyMc/r9iwjTAozbukAKCYKBjNITc4cyB7cdzCe8mpWY4
        M866HmA32LmGXsJSGMwPM0ybWGq+TgA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-2UnEy_V2PYSB1aeq4QHNZw-1; Wed, 03 Mar 2021 13:22:58 -0500
X-MC-Unique: 2UnEy_V2PYSB1aeq4QHNZw-1
Received: by mail-wr1-f69.google.com with SMTP id l10so13160032wry.16
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:22:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PLSHq+T6Ji51VQxldUQn+fMOB/V6gychel2awYEX8OQ=;
        b=hvOdiUmbIflHF2BQzod6K/ISMJJBxntm5PTB75dM0yt3LM3TmKRhapddbtVT7XhmC1
         IstHyKqroQeYlFn+JambDepA46CDENrXit0aRcgMqwUW8OpYoMqBuR/xU9pp83/K9dxc
         zFrI+gXDXGofp9F7YuRFznoUe6io+HOMM63DNSefhMC8z3Fo+wtlu4REFrkpIFkREcNa
         aS6myyBzuV+j5be3rbeg+jyEtk8oT+xO0KqCPz3UhMrI6dStPxhYQZSaS2lc47COioPT
         QBJOgqQPT/v5O6qyClsmjk+QYCuP9Zz2y4stWliFkkIX07IBERdimtEjA2cemhjl7qVF
         f1VQ==
X-Gm-Message-State: AOAM531N10jiraGXog+h6p2ShILZ8GGXDPiS37F8YM922th+80ZvT9+D
        4CpFzlZwI2aKPdG0a/t0qFZiDz7iMGAGcOd8HQbPLiBI0X/B8GDj57LQfV30rjWc+/7evSOpdxH
        eeLpP9UFStjpm
X-Received: by 2002:a5d:4445:: with SMTP id x5mr36864wrr.30.1614795777196;
        Wed, 03 Mar 2021 10:22:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyL7XqgigoYX+jhMS8HmdFrzDcCNORueIOZ/5Ml4d8Vt2v7I+aoNp8Jrifd3yZk0HsaustCqA==
X-Received: by 2002:a5d:4445:: with SMTP id x5mr36729wrr.30.1614795775449;
        Wed, 03 Mar 2021 10:22:55 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id g9sm34117131wrp.14.2021.03.03.10.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:22:55 -0800 (PST)
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
Subject: [RFC PATCH 05/19] cpu: Introduce AccelvCPUState opaque structure
Date:   Wed,  3 Mar 2021 19:22:05 +0100
Message-Id: <20210303182219.1631042-6-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the opaque 'AccelvCPUState' structure which will
be declared by each accelerator. Forward-declare it in "cpu.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/core/cpu.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 074199ce73c..d807645af2b 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -274,6 +274,9 @@ struct qemu_work_item;
 #define CPU_UNSET_NUMA_NODE_ID -1
 #define CPU_TRACE_DSTATE_MAX_EVENTS 32
 
+/* This structure is defined by each accelerator. */
+struct AccelvCPUState;
+
 /**
  * CPUState:
  * @cpu_index: CPU index (informative).
@@ -312,6 +315,7 @@ struct qemu_work_item;
  * @next_cpu: Next CPU sharing TB cache.
  * @opaque: User data.
  * @mem_io_pc: Host Program Counter at which the memory was accessed.
+ * @accel_vcpu: Pointer to accelerator-specific AccelvCPUState field.
  * @kvm_fd: vCPU file descriptor for KVM.
  * @work_mutex: Lock to prevent multiple access to @work_list.
  * @work_list: List of pending asynchronous work.
@@ -413,6 +417,7 @@ struct CPUState {
     int32_t exception_index;
 
     /* Accelerator-specific fields. */
+    struct AccelvCPUState *accel_vcpu;
     int kvm_fd;
     struct KVMState *kvm_state;
     struct kvm_run *kvm_run;
-- 
2.26.2

