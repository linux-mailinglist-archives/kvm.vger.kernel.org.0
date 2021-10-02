Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D3441FBF6
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhJBM5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:57:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233238AbhJBMzV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g4CQJdzlwnG2lhh6cD8LFOTW/FEZbmRSxqmO9AK0wf0=;
        b=I/8Xp4e2E+WL79W0XSEGvCPifPK2bhUerJaAixHYDFZv4YtEtGwgifBZfuqgqJArFiN9uv
        5gGYpeRpnDETEKJ+MTpICjYpUmp96vczUjcQTJjIldTeuBS8fsqQRyvn/I138ozLwAa/qg
        GZ0H3LpZNUz3uE+bPo0Ayf3AbKAJxNM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-S81j0aWgNoWf8SfTwSr2nQ-1; Sat, 02 Oct 2021 08:53:34 -0400
X-MC-Unique: S81j0aWgNoWf8SfTwSr2nQ-1
Received: by mail-wm1-f72.google.com with SMTP id m9-20020a05600c4f4900b003057c761567so7366943wmq.1
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g4CQJdzlwnG2lhh6cD8LFOTW/FEZbmRSxqmO9AK0wf0=;
        b=YrP53aId7d7wrzF3CIawQ/JT1flPmm0mBLQvyJrDiYMmY8+nWYfIN0e2nxzTGuaplo
         bGqRo6iqSI+KPDHJX4GUxn/tgvxhOE7vreD6qixTzZjp/eiURSoFtNHQsMF3QsYTGT7S
         QPa2VHCMIVUiLZwOyJKqwgZn6koCIHrvd3NsHMhgy6Q3TryLR/1sBIeYrWdOtUb/CwdH
         uM9xkQpI2UFLepQkMFRsCskk4WiGarMiqu6zSl7UBJxV8CkfkeZSusBGZjctVCKoaak0
         cUZpjoH/UoC7MQUaH4xmp2xNkV/8G/a0MqgwFL547bWQi3lMdNpqnM0meEUWBeVf/v7P
         ECaQ==
X-Gm-Message-State: AOAM533P47MJKLrnVSLAJtX0u6AhZEsR6oxeaU8iVGvGlAWV18NyLuna
        YI+TorL/hLXa/UQhu3Sa7Om6Irh3JjjWuajAez39qIBRO4TGens5q9+j2ZgzzZpAemOb9aIOxFD
        KeUhT6soen4d2
X-Received: by 2002:a05:600c:240a:: with SMTP id 10mr9368878wmp.170.1633179213048;
        Sat, 02 Oct 2021 05:53:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVukirZxFLCnS0tPkLQb551+kxcHjcGyPtCd0pzUdBEUoIeuKLgKAGClPI+IvXqQdALVy20Q==
X-Received: by 2002:a05:600c:240a:: with SMTP id 10mr9368862wmp.170.1633179212853;
        Sat, 02 Oct 2021 05:53:32 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id n17sm8399735wrp.17.2021.10.02.05.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:53:32 -0700 (PDT)
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
Subject: [PATCH v3 03/22] target/i386/kvm: Introduce i386_softmmu_kvm Meson source set
Date:   Sat,  2 Oct 2021 14:52:58 +0200
Message-Id: <20211002125317.3418648-4-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the i386_softmmu_kvm Meson source set to be able to
add features dependent on CONFIG_KVM.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/kvm/meson.build | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index 0a533411cab..b1c76957c76 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -1,8 +1,12 @@
 i386_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
 
-i386_softmmu_ss.add(when: 'CONFIG_KVM', if_true: files(
+i386_softmmu_kvm_ss = ss.source_set()
+
+i386_softmmu_kvm_ss.add(files(
   'kvm.c',
   'kvm-cpu.c',
 ))
 
 i386_softmmu_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
+
+i386_softmmu_ss.add_all(when: 'CONFIG_KVM', if_true: i386_softmmu_kvm_ss)
-- 
2.31.1

