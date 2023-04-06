Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBD36DA58A
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 00:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjDFWIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 18:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjDFWIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 18:08:42 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1051AAD08
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 15:08:42 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-62629f08378so24971b3a.3
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 15:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680818921;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k3OET9IrxkqkVzwqsY2Ob1nvZVYeqlpTB3hXyXYcn58=;
        b=m2OrzcAUd05KQd0tnQAAiyNlvBVCOW1C8JYL5vX7z9AiC6Ucn63/Rc05CMdj/dUNs6
         N1xAc36/hbGJjlXqwJPBgNPVV+uhXGyFeKV5nchL9CnIwVKLo/pvhr8IBOYfY4B6my4L
         QXKbwSaqHCLbjXNGnT7a0jEQLsPIu58/ki4fhPTgpV8UtUUvVJflZuLY3Lsz3n43gYH7
         vGZyeuQi2sPnjahr+WcieA7A4ItdgxiXqyQAUbpDNpu5/jR/SNsAmjA/tNvgqxSIVlcn
         ZuUOmpaQe4grHrjLYET9BoFQ+5BNpVxMVezU7n4m+T0FYcazOt7x6L+UU0++E87TgV65
         w2Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680818921;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k3OET9IrxkqkVzwqsY2Ob1nvZVYeqlpTB3hXyXYcn58=;
        b=b0fj0LjlDLRbQVUbSiwcWN/VLjDmMbAsP1oD6tmdoiMO4gZ63aLldhWRyJNRSC/0Aw
         Og1tJspvMnqudM0GREj/+04fnfln6eySFGOsjoQjGgmMjSgGUirhrc9h3GVDpcDrWwR1
         xs5Smlg221wxsVbJW9tdwR7IPUq6O7M8QXH5mej6afxz8ADiCPmYawxT4NDTBDGPLOj3
         K5IolCzTJspSDkMHZo4AHDh4wNe25WXbAvGUBpUh+rGFgsh1m2xcgFYQmIs+yM2GzfE6
         FRfud0TOu+UOaixyH54Xw51WNdbRVDTkZ2H6YRVFTt8gnYSVfysK14wtKExnpOQm+2Lv
         Gg2Q==
X-Gm-Message-State: AAQBX9cez33LNC7FUVAV+3O5mWGvtDpktiiUDrPHFZboxdwgdjGYbOTn
        kUo4GPx+HnqubOpiLHrYjK3efyGLEoQ=
X-Google-Smtp-Source: AKy350Z5JgISJ8XzchKsx+KKD+k2ioA6lQhmL7b8SWYAtYbgal4fkVPLSsR0YGVdBTxMra3UsrGI037B1MQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:24cd:b0:62b:e52e:1bb with SMTP id
 d13-20020a056a0024cd00b0062be52e01bbmr297032pfv.0.1680818921544; Thu, 06 Apr
 2023 15:08:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Apr 2023 15:08:39 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230406220839.835163-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86: Link with "-z noexecstack" to suppress
 irrelevant linker warnings
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly tell the linker KUT doesn't need an executable stack to
suppress gcc-12 warnings about the default behavior of having an
executable stack being deprecated.  The entire thing is irrelevant for KUT
(and other freestanding environments) as KUT creates its own stacks, i.e.
there's no loader/libc that consumes the magic ".note.GNU-stack" section.

  ld -nostdlib -m elf_x86_64 -T /home/seanjc/go/src/kernel.org/kvm-unit-tests/x86/flat.lds
     -o x86/vmx.elf x86/vmx.o x86/cstart64.o x86/access.o x86/vmx_tests.o lib/libcflat.a
  ld: warning: setjmp64.o: missing .note.GNU-stack section implies executable stack
  ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

Link: https://lkml.kernel.org/r/ZC7%2Bc42p2IRWtHfT%40google.com
Cc: Thomas Huth <thuth@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/Makefile.common | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 365e199f..c57d418a 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -62,7 +62,7 @@ else
 # We want to keep intermediate file: %.elf and %.o
 .PRECIOUS: %.elf %.o
 
-%.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
+%.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS) -z noexecstack
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
 	$(LD) $(LDFLAGS) -T $(SRCDIR)/x86/flat.lds -o $@ \
 		$(filter %.o, $^) $(FLATLIBS)

base-commit: 4ba7058c61e8922f9c8397cfa1095fac325f809b
-- 
2.40.0.577.gac1e443424-goog

