Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9FB47E697
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 18:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349373AbhLWRAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 12:00:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349358AbhLWRAQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Dec 2021 12:00:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640278815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QbDlCNO8BeLEzEuY1o/Yj/OOV9u7i5H7i/UVWO5+jqU=;
        b=E+juW0NfEhQ/HUnFY9Y9n2q+mWzWYwtTQmz/+NFkQ8rBIKM/5nzfIFr76X2lYLaWIBdU+Q
        T8HDxqoWQxLlp1efsdBklnr6Q+H2bcCk1U617gRJDK9EIUVOIHN5t5ldxfVo0hWIwd2Uhb
        Q8PLKTeI1OSpi2UXCn2c0BK4xsJQUHA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-VPPhFAj3ORmv0kfDLH-pDQ-1; Thu, 23 Dec 2021 12:00:13 -0500
X-MC-Unique: VPPhFAj3ORmv0kfDLH-pDQ-1
Received: by mail-ed1-f69.google.com with SMTP id x19-20020a05640226d300b003f8b80f5729so3763319edd.13
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 09:00:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QbDlCNO8BeLEzEuY1o/Yj/OOV9u7i5H7i/UVWO5+jqU=;
        b=RyAeYPl52yp2FY3evyIlxKkTDStQNQ26x58JootHBRoHx05utR5AN1Foc2yLDg7hQ5
         +SgPxeZRT009V/3ZyoHiaZJOC1RX44BSFsdqaGykfPknDCxYr8fTvyd0KXiH3aOvVs0U
         pPs5AcpDBhNKmi0qVkKsFmriWrCQscBfet70Is8Q1COqi07WfI5/l43F3niFMzFq9zMU
         VLg6oyhV1Mr/gqAl+lruD8jxaOKfVQ7il3JfrPzYh54vptq9v7MqcTMvE5GA/IyKrt3C
         3K9IUrUuvCqqkuzxCgL+u3nnKgfOq9cFdYIztKDsjWHnm7SMlz83t1sV5hM2hVy00oOb
         ekmg==
X-Gm-Message-State: AOAM533xUaRv9ddIXvUO8ABz3RFUUZTEpzcXVHSm4BZYUSTz9fFL2YFs
        okWVSzno1RCuDEngbC9qq+jiY0K770RoRVShP4Ywt2RCfx0R4UUiaK6qavngkOMSLJA6dr2+aJW
        QAnuZ5fonU9mP
X-Received: by 2002:a17:906:478a:: with SMTP id cw10mr2509591ejc.693.1640278812810;
        Thu, 23 Dec 2021 09:00:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOXau0JYojDMrB4uhQtijnQf3uwLfJ8/1WFDQKJxoqhmtXGvyUBxdGs2J03ArKxDWe2arRKw==
X-Received: by 2002:a17:906:478a:: with SMTP id cw10mr2509570ejc.693.1640278812612;
        Thu, 23 Dec 2021 09:00:12 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id t9sm2203094edd.94.2021.12.23.09.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 09:00:12 -0800 (PST)
Date:   Thu, 23 Dec 2021 18:00:10 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH 2/5] KVM: selftests: Initialise default mode in each test
Message-ID: <20211223170010.pekdezsyn75iuxqb@gator.home>
References: <20211216123135.754114-1-maz@kernel.org>
 <20211216123135.754114-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216123135.754114-3-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 16, 2021 at 12:31:32PM +0000, Marc Zyngier wrote:
> As we are going to add support for a variable default mode on arm64,
> let's make sure it is setup first by sprinkling a number of calls
> to get_modes_append_default() when the test starts.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/aarch64/arch_timer.c       | 3 +++
>  tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 3 +++
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c     | 3 +++
>  tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c | 3 +++
>  tools/testing/selftests/kvm/aarch64/vgic_init.c        | 3 +++
>  tools/testing/selftests/kvm/kvm_binary_stats_test.c    | 3 +++
>  tools/testing/selftests/kvm/kvm_create_max_vcpus.c     | 3 +++
>  tools/testing/selftests/kvm/memslot_perf_test.c        | 4 ++++
>  tools/testing/selftests/kvm/rseq_test.c                | 3 +++
>  tools/testing/selftests/kvm/set_memory_region_test.c   | 4 ++++
>  tools/testing/selftests/kvm/steal_time.c               | 3 +++

I wish there was a better way to set the defaults for each test
without requiring a function call to be put at the beginning of
each test. Maybe we should create a constructor function? I.e.

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f307c9f61981..603e09be12ae 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -148,7 +148,7 @@ LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
 # $(TEST_GEN_PROGS) starts with $(OUTPUT)/
 include ../lib.mk
 
-STATIC_LIBS := $(OUTPUT)/libkvm.a
+STATIC_LIBS := lib/init.o $(OUTPUT)/libkvm.a
 LIBKVM_C := $(filter %.c,$(LIBKVM))
 LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
diff --git a/tools/testing/selftests/kvm/lib/init.c b/tools/testing/selftests/kvm/lib/init.c
new file mode 100644
index 000000000000..6f92a85aa263
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/init.c
@@ -0,0 +1,6 @@
+#include "guest_modes.h"
+
+void __attribute__((constructor)) main_init(void)
+{
+#ifdef __aarch64__
+       guest_modes_set_default();
+#endif
+}


Thanks,
drew

