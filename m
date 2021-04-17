Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12583630A9
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 16:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbhDQOgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 10:36:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236519AbhDQOgg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 10:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618670170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aKAKI7v52vyNqiS4SW9aCQUStioGeZ6CYyWT7sgQ8pM=;
        b=Zn5r590qzJPXLTCPqN6WwHhDb4LhZpZLrZenh8vOeD3/bP9sGkeYcoUQ8JFosAGt7UHszw
        F6RWOq98wsAYiDgDuDY1ty947cZUmQpgnd4V3FQQIuXI+rAiL+vVzHcD58B5xQV1hAIsqM
        VTbLl5r4H14Aoww4PfWyPUJTE4fvz3M=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-7yVmwQx9PDWQSS2zHZ5CVw-1; Sat, 17 Apr 2021 10:36:08 -0400
X-MC-Unique: 7yVmwQx9PDWQSS2zHZ5CVw-1
Received: by mail-qv1-f69.google.com with SMTP id j8-20020ad453a80000b029017e3d6eb516so5687863qvv.10
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 07:36:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aKAKI7v52vyNqiS4SW9aCQUStioGeZ6CYyWT7sgQ8pM=;
        b=KniXOLgprHBCc5xwOjScGm6JIfq1uBdG+MReddLFcfOEhdpHR8LVCGU53O24dWSJKz
         0GE8RCfIKkM/eIUbuTtfZLCchMyFfxN40ZRqIlwCH1TWb7bhU81ONj9v2/bYjkO6xBMm
         xlAZ3SS9IpcLLcWGzIQFORNioO9j8q8pTcZiZ3hzcztRHG6BhiZ92PvM8o2hftziZhWW
         LpLPCVfmk9fmQzFba9JbEzE/tkOBktAMv5sFFBwo4MIl1OGp7PmKPJse3eF3EJ8ABAvT
         tKxE6kwW50+SGpxatZT+25uRYyRKuxKC/SfciCYGE6yS02VXbxU1MhaUsD6eQ9afXEEt
         LUtw==
X-Gm-Message-State: AOAM532F68g5RPreMU9GD3a04cOIPr/ZpGcWFP5g4DpwFQUWii9bXFFr
        mORERnBXGliv1g2Szq2ULtY3Olx+VdvIo+jf3VN0bo1FYadEakNCwNg827Av8PVOzEbLHN8mjYL
        1WZxAChXmcO+N
X-Received: by 2002:a37:9f41:: with SMTP id i62mr4104146qke.36.1618670167734;
        Sat, 17 Apr 2021 07:36:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxa6QLJMIv/tTZgxg6Y43LxC33xHosYTeNLBo4R0maleXRNXWOm9czMRqWhLKT+w4SotmTiBA==
X-Received: by 2002:a37:9f41:: with SMTP id i62mr4104132qke.36.1618670167495;
        Sat, 17 Apr 2021 07:36:07 -0700 (PDT)
Received: from xz-x1.redhat.com (bras-base-toroon474qw-grc-88-174-93-75-154.dsl.bell.ca. [174.93.75.154])
        by smtp.gmail.com with ESMTPSA id l12sm378159qtq.34.2021.04.17.07.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 07:36:06 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v3 2/2] KVM: selftests: Wait for vcpu thread before signal setup
Date:   Sat, 17 Apr 2021 10:36:02 -0400
Message-Id: <20210417143602.215059-3-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210417143602.215059-1-peterx@redhat.com>
References: <20210417143602.215059-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main thread could start to send SIG_IPI at any time, even before signal
blocked on vcpu thread.  Reuse the sem_vcpu_stop to sync on that, so when
SIG_IPI is sent the signal will always land correctly as an -EINTR.

Without this patch, on very busy cores the dirty_log_test could fail directly
on receiving a SIG_USR1 without a handler (when vcpu runs far slower than main).

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 510884f0eab8..25230e799bc4 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -534,6 +534,12 @@ static void *vcpu_worker(void *data)
 	sigemptyset(sigset);
 	sigaddset(sigset, SIG_IPI);
 
+	/*
+	 * Tell the main thread that signals are setup already; let's borrow
+	 * sem_vcpu_stop even if it's not for it.
+	 */
+	sem_post(&sem_vcpu_stop);
+
 	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
 
 	while (!READ_ONCE(host_quit)) {
@@ -785,6 +791,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vm);
 
+	sem_wait_until(&sem_vcpu_stop);
+
 	while (iteration < p->iterations) {
 		/* Give the vcpu thread some time to dirty some pages */
 		usleep(p->interval * 1000);
-- 
2.26.2

