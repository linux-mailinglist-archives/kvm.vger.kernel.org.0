Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C821365C58
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 17:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhDTPkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 11:40:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232940AbhDTPkK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 11:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618933178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v0hTcWbX3BCC9ZUFjKu3oL9Qk+b2NyA6y6oL3gT9PjE=;
        b=Q43JsS5bbhjrFLbtH6eF7AUmxlx4GackLjYhuen5hhdBPGjoEteqg5PKJVVkWyRWbwBriP
        jMMsMoe35Kzy1xEeEs+wRzLkiVJN6EJjzzt9o6tqXbul91mGpf/+tP3uFmYoSdWSD8iWSG
        YuShInf5Ei2p27LtKegEOgSFNzPtW8U=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-EKXF2ZStMbyq9hCeO0l0IQ-1; Tue, 20 Apr 2021 11:39:37 -0400
X-MC-Unique: EKXF2ZStMbyq9hCeO0l0IQ-1
Received: by mail-qk1-f200.google.com with SMTP id h22-20020a05620a13f6b02902e3e9aad4bdso3265427qkl.14
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 08:39:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v0hTcWbX3BCC9ZUFjKu3oL9Qk+b2NyA6y6oL3gT9PjE=;
        b=egeinBuGVjmPxXy5mZOTP16Hi+10LLGtve4r36M76s+pAYhLFCpnkQQdqjtdFreApe
         zkOOuw17VNwUdougN3ni8Yzc9OnnIZX2a4yVsXawzH/j2MPruUAb7oR6VWKTcrxT340J
         CZfqwYAb3AqwM+tX7dna7jL1n1KZYRbHPOGnAizthNONv9L/MxvPWggPssgMwm6Vp6ih
         IQPT71NlBnV8ppdHXgUiYEk/fudV7O2RIQPw+/ldsiLlJcdqif6EoGqnNwfV6lcKgHMX
         kp75/lx/kL0wkhONUGuSg0uH9EqQ2ui8Slv8s5w+FbUFL50vRw1g0eWbPqzm90ruawpr
         k9aQ==
X-Gm-Message-State: AOAM533x4RzWaOXYHnWKbYo3poc1M+keEE4+auZ7YFos0BCjg0MO0R+I
        XBUyEmAR203OlsOqLtdcmrRmDXGh7PtpvycS9fTQqMhNoG3jejJNMppKM75qvGuKjbNADfYYi83
        JeFrCiQVfKojvMI1+u58iUetVfVEQS/xnq6kz1iDqfyQim1j0dv0kvCBRtzyzQA==
X-Received: by 2002:ac8:6703:: with SMTP id e3mr2290924qtp.247.1618933174939;
        Tue, 20 Apr 2021 08:39:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyn0RU8rrRtvS0aT44DO1pxylQ0/+NBEAMy1jGC/Bhuc46/VKsZuFkoMeQ5x5S9cCioVtWTXw==
X-Received: by 2002:ac8:6703:: with SMTP id e3mr2290900qtp.247.1618933174663;
        Tue, 20 Apr 2021 08:39:34 -0700 (PDT)
Received: from xz-x1.redhat.com (bras-base-toroon474qw-grc-88-174-93-75-154.dsl.bell.ca. [174.93.75.154])
        by smtp.gmail.com with ESMTPSA id f12sm11633325qtq.84.2021.04.20.08.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 08:39:34 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v4 2/2] KVM: selftests: Wait for vcpu thread before signal setup
Date:   Tue, 20 Apr 2021 11:39:29 -0400
Message-Id: <20210420153929.482810-3-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210420153929.482810-1-peterx@redhat.com>
References: <20210420153929.482810-1-peterx@redhat.com>
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
index fc87e2f11d3d..d3050d1c2cd0 100644
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

