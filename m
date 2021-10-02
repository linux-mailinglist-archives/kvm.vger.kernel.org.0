Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153D741FBF7
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhJBM5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:57:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233256AbhJBMzZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZlL6otvRUOhsGg4LexEjqPgBur9Sbw4O6pWOtqIiK2E=;
        b=GZdx9slGGrzOtU9ZPOPmAIm7BlEZi22L3Kj/0gw2xDL3iTkk2WbAEqFk+qTX5o4zko35ta
        hmjW4b5KIUkpQlqXMdfqaPphlL7bnURMg9GH43Cdpb7oOLXEEOVtHB2vQphzPK6Zb4l6R+
        dwFw8DSMzMjSK7Wnz8J+rIsT7jAkYQM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-9oitxajvNr-th8DHvlh6jQ-1; Sat, 02 Oct 2021 08:53:38 -0400
X-MC-Unique: 9oitxajvNr-th8DHvlh6jQ-1
Received: by mail-wm1-f71.google.com with SMTP id 129-20020a1c1987000000b0030cd1616fbfso7349257wmz.3
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZlL6otvRUOhsGg4LexEjqPgBur9Sbw4O6pWOtqIiK2E=;
        b=QHX7mJP6qpNcqqy4KnTug0T88/9n7ppXj+1ujMk3qv6g+s4xwaKmezaa+ssTEdWGIK
         8E/liqV7F3FNq2T7QiVfh4Kmj0Yp9BAnvPxt7JdSKwiUxsEusGFpP7yyhkmenSEP3Gjf
         2QVl6qJ68OJphbKwKTPdOZ4ROcceKGR0JmkaMU8B876bYndRBucaCYCaMn3kRWPKs6pW
         VNSxyNxtUayLZy4fnpf/uAEU+L8mGT1n14yQDicF5PBBBLizIzkcvDpJyYr+sHNG2HoM
         leUL8H9n3haLbdec36G1BG+bcXq9fa2NYnkGRvtdWUkFfO3Pp+p69ivfc+kcQq9/CFvz
         S6YA==
X-Gm-Message-State: AOAM5301xMX8issh+HzioEnQYyQrh2O1oB0tt+rdSfro0agato4pfLNk
        FfP8AD34VumJhmSi5r0Yjl3SuGB+xk5m7fEMsppdmcQH5JwWmo99aCt+7AWDBC6Wg6CJE4JqBKS
        iL0N5dSvDAH1e
X-Received: by 2002:adf:ea45:: with SMTP id j5mr3279486wrn.291.1633179217541;
        Sat, 02 Oct 2021 05:53:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvngRg6mSfZAPhLoI1z88TfL+DRAdtPTmC0GBIdj7S99yXfNxRBj9wMpPO15fh3FpbNOAwJw==
X-Received: by 2002:adf:ea45:: with SMTP id j5mr3279481wrn.291.1633179217363;
        Sat, 02 Oct 2021 05:53:37 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id b15sm10237676wru.9.2021.10.02.05.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:53:37 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        James Bottomley <jejb@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Daniel P . Berrange" <berrange@redhat.com>
Subject: [PATCH v3 04/22] target/i386/kvm: Restrict SEV stubs to x86 architecture
Date:   Sat,  2 Oct 2021 14:52:59 +0200
Message-Id: <20211002125317.3418648-5-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV is x86-specific, no need to add its stub to other
architectures. Move the stub file to target/i386/kvm/.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 {accel => target/i386}/kvm/sev-stub.c | 0
 accel/kvm/meson.build                 | 1 -
 target/i386/kvm/meson.build           | 2 ++
 3 files changed, 2 insertions(+), 1 deletion(-)
 rename {accel => target/i386}/kvm/sev-stub.c (100%)

diff --git a/accel/kvm/sev-stub.c b/target/i386/kvm/sev-stub.c
similarity index 100%
rename from accel/kvm/sev-stub.c
rename to target/i386/kvm/sev-stub.c
diff --git a/accel/kvm/meson.build b/accel/kvm/meson.build
index 8d219bea507..397a1fe1fd1 100644
--- a/accel/kvm/meson.build
+++ b/accel/kvm/meson.build
@@ -3,6 +3,5 @@
   'kvm-all.c',
   'kvm-accel-ops.c',
 ))
-kvm_ss.add(when: 'CONFIG_SEV', if_false: files('sev-stub.c'))
 
 specific_ss.add_all(when: 'CONFIG_KVM', if_true: kvm_ss)
diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index b1c76957c76..736df8b72e3 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -7,6 +7,8 @@
   'kvm-cpu.c',
 ))
 
+i386_softmmu_kvm_ss.add(when: 'CONFIG_SEV', if_false: files('sev-stub.c'))
+
 i386_softmmu_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
 
 i386_softmmu_ss.add_all(when: 'CONFIG_KVM', if_true: i386_softmmu_kvm_ss)
-- 
2.31.1

