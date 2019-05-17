Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C3F21977
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 16:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbfEQOCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 10:02:40 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43448 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728351AbfEQOCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 10:02:40 -0400
Received: by mail-qk1-f195.google.com with SMTP id z6so4475716qkl.10
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 07:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Tq9pjDbxEOyZ7Iwpy2uNH6b9E86aYZuY86joxZD4zbM=;
        b=pPOl99vB+ZM4fPyrXfhg2Epo7F2Qdzj2WsKmspj5wBIL81kTnikotr3tnzMGATy/WS
         aZvVmA0V5Jb3fwkcjgblpEkjdXSQpSNOpb/X/Y00+u/5ibSNshQ6m6jsXhHp4Sd0WeYM
         gPmVuYOGsg0EYvxIlNIiCT7IGTD7fHuO6708hd0mEgiPoizyGX9jKUr1ymFV3tqE1e9g
         W0hEO5CpY96yJ/ctHkRiLLHpVYlHh00qSv1+ufGaOL2j/5TasAe0uLJfZMUAD1F9vAhs
         B2F0Z25J5UITuwsRFB0oJOMXPpFUozSFdpgJVsplmpooix/zgSfCUYYrtdMS+w7uDEC9
         Yw+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Tq9pjDbxEOyZ7Iwpy2uNH6b9E86aYZuY86joxZD4zbM=;
        b=nV4W+vbg/FLSvS1i8adQ+fegnZHkd2+i0ycsoyDfXmP15iuYr7171I3Y0oW6A3Ggd2
         1Omr4miEL35y0QvRKa/ziaPDmbajgI5B6END9FRBn2w5SIybZWWWrxmUV9QPf0G2oP4x
         B3RQ5RRbamgyqBLuJdl/0B9q2t3qPqWmCl+d5yomPbM0Xd69M9xvWnAR+Be/EB5fSEQ8
         VYI/iJucx7qIt4KJ8ItRXasm4PIOzMqkHmTohv2CAkFjWw6hA2dMYYtob9qEjd99E/Q6
         ShxcK06Ul1j2WUtk2QnRzUwkqOzX+IhQRUgA1vvnKOuvOk+ZqBoOm4LpUg0eqvDyUvZo
         QbDQ==
X-Gm-Message-State: APjAAAVNuR7ROe+wdeOrfy7n7VzfZcyhoW3I749bHuc72KCrxzd0e8a0
        ghAPbfqMaeeoFQBTzfdClKtayw==
X-Google-Smtp-Source: APXvYqxpdthmw/ru6DIU4vE9FD7BD+dWymUq02I/FHUxJkYGFGacoBcLSXgUo7AW1EJXLdTZUxtwJA==
X-Received: by 2002:a05:620a:12da:: with SMTP id e26mr3168424qkl.132.1558101758996;
        Fri, 17 May 2019 07:02:38 -0700 (PDT)
Received: from qcai.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id g20sm3933764qki.52.2019.05.17.07.02.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 07:02:38 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     karahmed@amazon.de, konrad.wilk@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH -next] kvm: fix compilation errors with mem[re|un]map()
Date:   Fri, 17 May 2019 10:01:53 -0400
Message-Id: <1558101713-15325-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The linux-next commit e45adf665a53 ("KVM: Introduce a new guest mapping
API") introduced compilation errors on arm64.

arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1764:9: error: implicit
declaration of function 'memremap'
[-Werror,-Wimplicit-function-declaration]
                hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
                      ^
arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1764:9: error: this function
declaration is not a prototype [-Werror,-Wstrict-prototypes]
arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1764:46: error: use of
undeclared identifier 'MEMREMAP_WB'
                hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
                                                           ^
arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1796:3: error: implicit
declaration of function 'memunmap'
[-Werror,-Wimplicit-function-declaration]
                memunmap(map->hva);

Fixed it by including io.h in kvm_main.c.

Signed-off-by: Qian Cai <cai@lca.pw>
---
 virt/kvm/kvm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8d83a787fd6b..5c5102799c2c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -51,6 +51,7 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
+#include <linux/io.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
-- 
1.8.3.1

