Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546C237672E
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 16:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237692AbhEGOpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 10:45:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234601AbhEGOpd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 10:45:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620398673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C+MYJWIsLohbCHlMSEIGcZQyDaEDuU9Kl0ow5213YNc=;
        b=T9bqPQ1iOCtOKzHERhU/iTCRz0QU+fJrVF7VtsJtQ1CCf+nD5fiCd3UL4Tf5Pug+hnXn0A
        iS6taGJK/KAqmDWOLanVYHlyKIuW8EShZq3IPNpUd9MsmnZ1qhfip1w63fLcuGeZLzqRD3
        urf2/VDDc9L3+6oZq7q/Vf4Cs3vKot0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-r851SfVcOGyO7fkQu3389g-1; Fri, 07 May 2021 10:44:31 -0400
X-MC-Unique: r851SfVcOGyO7fkQu3389g-1
Received: by mail-wr1-f69.google.com with SMTP id 65-20020adf82c70000b0290107593a42c3so3701426wrc.5
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 07:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C+MYJWIsLohbCHlMSEIGcZQyDaEDuU9Kl0ow5213YNc=;
        b=R4U2iQ07ssxn8xm2HOpcowGBxbc3YE+hzR3/7iIgPAGbMWKBXSzyY8fQWqfl0qLro7
         JRgBKbCssBvJl//giwX8CcvSekj2MSBxxtRZ2UN5pmPT5XpcZSoZML4C76jOjo+j1T3s
         tR81lIKvA77fwo3/rP+risfZbFMefuztjIoRNMZgkiUEnPQCzz0D3+pQUQEBG4uJ4Vz4
         ClSEd4xz+nRkKdNhPj2BublaR9WvPRXjLXWAbn4ahZBLO54q5d+s8FBYpfdu0lT3dbMt
         2IGNHs7vnfPPeRrol/gmSMKcfCmcdOnmnC9qEIfnNW329JVWuD5TVA68t5Z6ErhrtFnC
         qejA==
X-Gm-Message-State: AOAM5334ELiildZYAUKIPjKGROmsPD3zE8D5gF5lmfhYqkPkDSuTAwpQ
        ttFq+cQBPwnkvZF++y+ZjzIwkuLlUQyqJCxLCjc/ohR6odNKbw3HOEbZhvyobyZChVMV3D1hOXa
        66xFlpJUct8hg
X-Received: by 2002:adf:f80f:: with SMTP id s15mr12876030wrp.341.1620398670260;
        Fri, 07 May 2021 07:44:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyV3LXdgDeT9W3nPy2PYFEyT0xnL/c2fIbnfgtcygElbhUWgwrD2nI+U4GtCxZ9QE5ZsaU17g==
X-Received: by 2002:adf:f80f:: with SMTP id s15mr12876009wrp.341.1620398670157;
        Fri, 07 May 2021 07:44:30 -0700 (PDT)
Received: from localhost.localdomain (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id r13sm8833726wrn.2.2021.05.07.07.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 07:44:29 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH v3 15/17] target/ppc/kvm: Replace alloca() by g_malloc()
Date:   Fri,  7 May 2021 16:43:13 +0200
Message-Id: <20210507144315.1994337-16-philmd@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210507144315.1994337-1-philmd@redhat.com>
References: <20210507144315.1994337-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ALLOCA(3) man-page mentions its "use is discouraged".

Use autofree heap allocation instead, replacing it by a g_malloc call.

Reviewed-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/ppc/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 104a308abb5..23c4ea377e8 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2698,11 +2698,11 @@ int kvmppc_save_htab(QEMUFile *f, int fd, size_t bufsize, int64_t max_ns)
 int kvmppc_load_htab_chunk(QEMUFile *f, int fd, uint32_t index,
                            uint16_t n_valid, uint16_t n_invalid, Error **errp)
 {
-    struct kvm_get_htab_header *buf;
+    g_autofree struct kvm_get_htab_header *buf = NULL;
     size_t chunksize = sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
     ssize_t rc;
 
-    buf = alloca(chunksize);
+    buf = g_malloc(chunksize);
     buf->index = index;
     buf->n_valid = n_valid;
     buf->n_invalid = n_invalid;
-- 
2.26.3

