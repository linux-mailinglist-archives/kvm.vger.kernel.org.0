Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE6A42579C
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242155AbhJGQTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230452AbhJGQTu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:19:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nFJahcuQnHhP8I03izotVBJeAm6M7KThunSrXMbgTQ0=;
        b=VnefZ267L3bCZ+WNhCdGqy0FVgDKkOLHoJzHD3qhdI4V35NnIgct3YPMH1cdQlsWr5G2k1
        06fmSQWD9tOsXiq7uOkLEr2zdDATizlbYoLsjojI1Yr/DuBDSPJTj0StaVvMoy5eUjOy3W
        5/KEAeVOtJH0kdzpDJZlL9vrgA5jVCk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-GU8ZfKFBOlqvidX9wOgX8g-1; Thu, 07 Oct 2021 12:17:55 -0400
X-MC-Unique: GU8ZfKFBOlqvidX9wOgX8g-1
Received: by mail-wr1-f69.google.com with SMTP id r21-20020adfa155000000b001608162e16dso5102835wrr.15
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nFJahcuQnHhP8I03izotVBJeAm6M7KThunSrXMbgTQ0=;
        b=DEKIAh02UXw124ebvSxgkePWcX4ZbDqYZrqkcQpkoih2Dkc8o7qCkGz/5CZm+h7cS1
         EJiSCVdy+AYUHM2//2pUwyadt9oQX3NpEshA9KpUzglvEIXKJFTCz+PEZsPPUuGoNPTx
         PUM3zS4oewt/7J8JX2if+vZ71MuxFP+fGQLiSBbKPbC1472dHFA599Q1gzztl9XvpkqX
         BYUsOvTSMLPRrushisOED+ErE7wBh4uzaGFBJ3TAXOmOjkC8uGrQgD0cur4932cuUcxe
         hCnoJDHxQ3atXeeLBJiVH/0Lz3PT9YHSJEewQXk/LfrXKAMAJuQWajZA3Wz74u19yZOD
         Kjpg==
X-Gm-Message-State: AOAM5316iZGui8ld8+ztqOCoEaR+/J2SwPV5utrGGj+KPVhkc7eSFq3e
        pQHCDFeZv6rn7Cj7jxbjfWBr5Kne13epV2P1v+ifrsFEtBnNk7gTlVXNEJf/w6NmlcB033cTzA0
        uTaJ1jUwMBVV8
X-Received: by 2002:a05:600c:1552:: with SMTP id f18mr16953007wmg.184.1633623470769;
        Thu, 07 Oct 2021 09:17:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPwOfgjE5w95h/skhL3N9RbbkKUO9R/p4rTX9ZmdO5wFGvZ/OZfqfGMboNdzGu5nRI4AFFTA==
X-Received: by 2002:a05:600c:1552:: with SMTP id f18mr16952983wmg.184.1633623470613;
        Thu, 07 Oct 2021 09:17:50 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id g188sm3421wmg.46.2021.10.07.09.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:17:50 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>
Subject: [PATCH v4 07/23] target/i386/cpu: Add missing 'qapi/error.h' header
Date:   Thu,  7 Oct 2021 18:17:00 +0200
Message-Id: <20211007161716.453984-8-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 00b81053244 ("target-i386: Remove assert_no_error usage")
forgot to add the "qapi/error.h" for &error_abort, add it now.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index a7b1b6aa93a..b54b98551e9 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -27,6 +27,7 @@
 #include "sysemu/hvf.h"
 #include "kvm/kvm_i386.h"
 #include "sev_i386.h"
+#include "qapi/error.h"
 #include "qapi/qapi-visit-machine.h"
 #include "qapi/qmp/qerror.h"
 #include "qapi/qapi-commands-machine-target.h"
-- 
2.31.1

