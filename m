Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D46344230E
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhKAWL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:11:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20381 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232276AbhKAWL6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UH6qFcOvOngPka/Fe9lzsDNdrqD8p0gmRL7v9NgF7Ts=;
        b=cgDoKbHNqK9Isjr/sb6KPxjoDIP+2SLoml3SA+fs3JQzpRgFRnyMXj3jTV6zU1MPRcIied
        pqxwrM6yPcAOHM2iWj0bnukS6UiBYa0xaz0ajGJbgaK5DMeEUuDnx6uNFXg5Y+tflNByes
        C/tz+3+EQxbVhg3jwf3Kih0s2GkOosI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-LhPNnfggN-a5btp1LFR2nA-1; Mon, 01 Nov 2021 18:09:23 -0400
X-MC-Unique: LhPNnfggN-a5btp1LFR2nA-1
Received: by mail-wr1-f71.google.com with SMTP id u4-20020a5d4684000000b0017c8c1de97dso3734607wrq.16
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UH6qFcOvOngPka/Fe9lzsDNdrqD8p0gmRL7v9NgF7Ts=;
        b=guF79rS6fggaYOC/qYdpLayZKyxOebnCbQjjb+6rxYBYlwzGzO3R/+uHGrQGtkwsJx
         2IX7soO6jtoIrRdf4lT+u1g016rr3LMgFrmGuGTgVCiPQyboPvaSJEh/kplshbMItirS
         Q0rdEuQQm0qOq37o3C57+Blu3nDOw+QRC+oE8oFGr6sKuGj771FQxY47UUfpaZBwK8iZ
         YJBARW/b0OISEpejv3rIOCIggKvym1cV5cw080ld4Qib4StWMZo51fVQ93jmDkw9Bs4U
         m/yuN1wbBQPLsuFwQA9KVGer0NycTgjofZk8B4++4xcYrNKFuLeY+SNxB9j+Axs+6XoG
         Kccw==
X-Gm-Message-State: AOAM532Bn0y72xtBPrKA3jjAfL1XYMojVQ26qM1B8zoykIirvtF92W9t
        PWpTuCZJN/oGNYQz/J8SKqrRUP72jI5kgt+mAMSEXU1cltArlFSuaSRXcGvzsG98hHoDOtRHImP
        yrw2UaZH0iFLh
X-Received: by 2002:adf:d20e:: with SMTP id j14mr33297700wrh.220.1635804562475;
        Mon, 01 Nov 2021 15:09:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkffbvXrtYSeZN/zNmfpHm8cIwzDDYcEpAf91jdU0NQr69iLSppRQMuLbVQCsCLOwkm5qiNw==
X-Received: by 2002:adf:d20e:: with SMTP id j14mr33297679wrh.220.1635804562331;
        Mon, 01 Nov 2021 15:09:22 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id n15sm637153wmq.38.2021.11.01.15.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:21 -0700 (PDT)
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
Subject: [PULL 06/20] migration/dirtyrate: move init step of calculation to main thread
Date:   Mon,  1 Nov 2021 23:08:58 +0100
Message-Id: <20211101220912.10039-7-quintela@redhat.com>
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

since main thread may "query dirty rate" at any time, it's better
to move init step into main thead so that synchronization overhead
between "main" and "get_dirtyrate" can be reduced.

Signed-off-by: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>
Message-Id: <109f8077518ed2f13068e3bfb10e625e964780f1.1624040308.git.huangy81@chinatelecom.cn>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/dirtyrate.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index a9bdd60034..b8f61cc650 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -380,7 +380,6 @@ void *get_dirtyrate_thread(void *arg)
 {
     struct DirtyRateConfig config = *(struct DirtyRateConfig *)arg;
     int ret;
-    int64_t start_time;
     rcu_register_thread();
 
     ret = dirtyrate_set_state(&CalculatingState, DIRTY_RATE_STATUS_UNSTARTED,
@@ -390,9 +389,6 @@ void *get_dirtyrate_thread(void *arg)
         return NULL;
     }
 
-    start_time = qemu_clock_get_ms(QEMU_CLOCK_REALTIME) / 1000;
-    init_dirtyrate_stat(start_time, config);
-
     calculate_dirtyrate(config);
 
     ret = dirtyrate_set_state(&CalculatingState, DIRTY_RATE_STATUS_MEASURING,
@@ -411,6 +407,7 @@ void qmp_calc_dirty_rate(int64_t calc_time, bool has_sample_pages,
     static struct DirtyRateConfig config;
     QemuThread thread;
     int ret;
+    int64_t start_time;
 
     /*
      * If the dirty rate is already being measured, don't attempt to start.
@@ -451,6 +448,10 @@ void qmp_calc_dirty_rate(int64_t calc_time, bool has_sample_pages,
     config.sample_period_seconds = calc_time;
     config.sample_pages_per_gigabytes = sample_pages;
     config.mode = DIRTY_RATE_MEASURE_MODE_PAGE_SAMPLING;
+
+    start_time = qemu_clock_get_ms(QEMU_CLOCK_REALTIME) / 1000;
+    init_dirtyrate_stat(start_time, config);
+
     qemu_thread_create(&thread, "get_dirtyrate", get_dirtyrate_thread,
                        (void *)&config, QEMU_THREAD_DETACHED);
 }
-- 
2.33.1

