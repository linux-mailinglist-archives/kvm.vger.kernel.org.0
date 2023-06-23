Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F8073B848
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 14:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjFWMzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 08:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbjFWMzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 08:55:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E9910F1
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 05:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687524888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMJsEqZxFDEiOpUmf5NTUaCgnapiJoAxYbiFoSk82wQ=;
        b=UZmqge38PD/Glp2nnW7D0nuwZy+cC4HwY86QtQFR1c4Og3EzMRUM+S7lGnqAIHNYoDlX2z
        wGc/PhstdCHxkuuE8GYylJvsG/xOgYCj+HnYbXMH+qIqp6kVPzbNGnCfGxRGzCzy07tMTh
        D4FJplMgg5gjhsd1yvTikHcDIP+7xCU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-UhauKGHCN2CMcbORgDFUJg-1; Fri, 23 Jun 2023 08:54:43 -0400
X-MC-Unique: UhauKGHCN2CMcbORgDFUJg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 965728CC200;
        Fri, 23 Jun 2023 12:54:42 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AD80F5AC5;
        Fri, 23 Jun 2023 12:54:24 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [kvm-unit-tests PATCH 2/2] Link with "-z noexecstack" to avoid warning from newer versions of ld
Date:   Fri, 23 Jun 2023 14:54:16 +0200
Message-Id: <20230623125416.481755-3-thuth@redhat.com>
In-Reply-To: <20230623125416.481755-1-thuth@redhat.com>
References: <20230623125416.481755-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer versions of ld (from binutils 2.40) complain on s390x and x86:

 ld: warning: s390x/cpu.o: missing .note.GNU-stack section implies
              executable stack
 ld: NOTE: This behaviour is deprecated and will be removed in a
           future version of the linker

We can silence these warnings by using "-z noexecstack" for linking
(which should not have any real influence on the kvm-unit-tests since
the information from the ELF header is not used here anyway, so it's
just cosmetics).

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0e5d85a1..20f7137c 100644
--- a/Makefile
+++ b/Makefile
@@ -96,7 +96,7 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
 autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
 
-LDFLAGS += -nostdlib
+LDFLAGS += -nostdlib -z noexecstack
 
 $(libcflat): $(cflatobjs)
 	$(AR) rcs $@ $^
-- 
2.39.3

