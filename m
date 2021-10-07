Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E734257A2
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242132AbhJGQUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:20:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231366AbhJGQUE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yu0i8hmAoNBqKA56xVa0FWOHuPb3wa3Ay0pPJ2J6oOs=;
        b=GVt1yT+itLUmXxIN/pgJBMpMb0IN2dtm9beZrzcogT0AVKh3mcNZb6eSPkJjf3kftFx2f7
        mnqbiWB9Ka1bcTcYO/kRS+wigslP2ATitcb4NVAf0B7TYnt0AheuHCeH45TitDwDd2112Q
        JtX6bNywe9B0bZEs/lEe28hryPJFUus=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-W0whaxK4PreHXOS1UI9kAw-1; Thu, 07 Oct 2021 12:18:05 -0400
X-MC-Unique: W0whaxK4PreHXOS1UI9kAw-1
Received: by mail-wr1-f72.google.com with SMTP id l6-20020adfa386000000b00160c4c1866eso5121300wrb.4
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yu0i8hmAoNBqKA56xVa0FWOHuPb3wa3Ay0pPJ2J6oOs=;
        b=2Zoz8IIBUdpcfLM0yy3ezrDYtGtOb7fLOHDTMwSJeS9TiF13P08jCTP0TOU8bc9WGo
         P70JffNehWfmOr6oztvSXaylYNvrQ5TbCpCaLxmwoH+clSewcrTkoWk3Nu18N1mpFGJF
         6RgSbX0oJEo9vsdtYmowdvhBbfLH0b+gZYxy9t32NsUI18Kg22EXlcBMZT09yN0yr1D6
         upZ+beLe7JNtVhUP3T9H6YQKMJZdFXNmq95fmRNp7X75YJtZSd5gry49Oecd3ihqCBVw
         g+GFNg/GexGpcKTf7y5ZDelKYicGxCPF4yTy6NOjMfAq7bmAEKh8kjYiVOppMO6o1eQt
         hZbw==
X-Gm-Message-State: AOAM531itCi/Dsa5hnZ32jlyRGMeY0hrki2PwdraQAJG8/RJjWwZ+iRy
        OaQpdDBF9vG0amWCm15IiQk5Q+aqnvbC6jZ1b7bky9Mu0jzskknp7ejTv/+VEtYG2MC+5sq9rsQ
        YwhWDzgwKxs83
X-Received: by 2002:adf:bb08:: with SMTP id r8mr6741284wrg.247.1633623484640;
        Thu, 07 Oct 2021 09:18:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1j54x6mkDDT5G+p886ML0TNkhiqQSJ77tctklrBToCqo96VSPVZB4HfWC67SFWx8EPKXHSw==
X-Received: by 2002:adf:bb08:: with SMTP id r8mr6741267wrg.247.1633623484503;
        Thu, 07 Oct 2021 09:18:04 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id u1sm8426658wmc.29.2021.10.07.09.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:18:04 -0700 (PDT)
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
Subject: [PATCH v4 10/23] target/i386/sev: Mark unreachable code with g_assert_not_reached()
Date:   Thu,  7 Oct 2021 18:17:03 +0200
Message-Id: <20211007161716.453984-11-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The unique sev_encrypt_flash() invocation (in pc_system_flash_map)
is protected by the "if (sev_enabled())" check, so is not
reacheable.
Replace the abort() call in sev_es_save_reset_vector() by
g_assert_not_reached() which meaning is clearer.

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev-stub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index 20b1e18ec1b..55f1ec74196 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -54,7 +54,7 @@ int sev_inject_launch_secret(const char *hdr, const char *secret,
 
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
 {
-    return 0;
+    g_assert_not_reached();
 }
 
 bool sev_es_enabled(void)
@@ -68,7 +68,7 @@ void sev_es_set_reset_vector(CPUState *cpu)
 
 int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
 {
-    abort();
+    g_assert_not_reached();
 }
 
 SevAttestationReport *
-- 
2.31.1

