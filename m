Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C135650036E
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 03:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbiDNBJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 21:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiDNBJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 21:09:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2487551E51
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 18:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649898428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ipdLR9D3/YHkROrPusy96LZmG+ZMYEbsweiplBcf04I=;
        b=bdBkEA0GBfq4DcsNvClDvAuXFKNtb5b7JdaaOpPRye4lkD3m7Uda+yWBKo/sbuF1bQPdoJ
        IkVI6NWZwsNxRLVloLFMrLTsNPCbrkczQ1sVqcQnkRxoX1qYyvRxK36mc7kStT2VgR++iO
        bbkCOKsxBZzGbs2slYuNlHksIyRPThg=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-Vxal36VSPw64qb52JXnX_g-1; Wed, 13 Apr 2022 21:07:07 -0400
X-MC-Unique: Vxal36VSPw64qb52JXnX_g-1
Received: by mail-il1-f199.google.com with SMTP id i14-20020a056e020ece00b002ca198245e6so2208310ilk.4
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 18:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ipdLR9D3/YHkROrPusy96LZmG+ZMYEbsweiplBcf04I=;
        b=GBRil+6WWTScO2TUYlGOKBLRqvbMhQM94BdfoIh8GXzJJSsgD9vmVG+ZivXk5lHXqk
         w9f78dL+oEyU2wydjwyOSsYpj/108W22hHcR4KcFC+uO+bNX32BgHq++aJ5aqbfOqke5
         qSS+dxj3FpaItoKukvjR9TNjN23pKUcFuxLTnkCkUggyvmWe9nyN2l0B0mOboP/cb4hx
         93nqSs3/i/5L67JaSf3D2EZJaw/iJQqGcNp07t0QmjLUPE9u1y2Hf8FlXNVobi1EAnoh
         UuXgBzqqCeBsSnTz6iibczh17xPdDx8+niGPZLjNHDV+IzX3IJL3F+6xAzvwWuS87L+K
         E6lw==
X-Gm-Message-State: AOAM531LH1LT1mcnDjUQfgZrpks7vhWIyHkUtSTsCBj/kBfmsW4ZLjrP
        xC6ogBCi3Pc4X30o7W4pySxAzjefmy95vE06pK+tAbNQ1p0JBuxSDBJpmSJUlFw3nG8oWuTDJGy
        gIdWKdeT28DPeHMhFH+2B5JYVTD8UoQVS05sTWvrYVvw4JAzXIj7kB9giHBmm4A==
X-Received: by 2002:a05:6602:2aca:b0:646:a866:9fd4 with SMTP id m10-20020a0566022aca00b00646a8669fd4mr180453iov.92.1649898426289;
        Wed, 13 Apr 2022 18:07:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuxd/QXHcWzmra/hRATB55ofGcpqDqowN6F2H5IZ0ylulAPo2vQ083vUVZwvjMon3JIjv/eA==
X-Received: by 2002:a05:6602:2aca:b0:646:a866:9fd4 with SMTP id m10-20020a0566022aca00b00646a8669fd4mr180426iov.92.1649898425812;
        Wed, 13 Apr 2022 18:07:05 -0700 (PDT)
Received: from localhost.localdomain (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id a15-20020a92ce4f000000b002cbdcef5a76sm259749ilr.84.2022.04.13.18.07.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Apr 2022 18:07:05 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>, peterx@redhat.com,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH] kvm: selftests: Fix cut-off of addr_gva2gpa lookup
Date:   Wed, 13 Apr 2022 21:07:03 -0400
Message-Id: <20220414010703.72683-1-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our QE team reported test failure on access_tracking_perf_test:

Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory offset: 0x3fffbffff000

Populating memory             : 0.684014577s
Writing to populated memory   : 0.006230175s
Reading from populated memory : 0.004557805s
==== Test Assertion Failure ====
  lib/kvm_util.c:1411: false
  pid=125806 tid=125809 errno=4 - Interrupted system call
     1  0x0000000000402f7c: addr_gpa2hva at kvm_util.c:1411
     2   (inlined by) addr_gpa2hva at kvm_util.c:1405
     3  0x0000000000401f52: lookup_pfn at access_tracking_perf_test.c:98
     4   (inlined by) mark_vcpu_memory_idle at access_tracking_perf_test.c:152
     5   (inlined by) vcpu_thread_main at access_tracking_perf_test.c:232
     6  0x00007fefe9ff81ce: ?? ??:0
     7  0x00007fefe9c64d82: ?? ??:0
  No vm physical memory at 0xffbffff000

And I can easily reproduce it with a Intel(R) Xeon(R) CPU E5-2630 with 46
bits PA.

It turns out that the address translation for clearing idle page tracking
returned wrong result, in which addr_gva2gpa()'s last step should have
treated "pte[index[0]].pfn" to be a 32bit value.  In above case the GPA
address 0x3fffbffff000 got cut-off into 0xffbffff000, then it caused
further lookup failure in the gpa2hva mapping.

I didn't yet check any other test that may fail too on some hosts, but
logically any test using addr_gva2gpa() could suffer.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2075036
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..6c356fb4a9bf 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -587,7 +587,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	if (!pte[index[0]].present)
 		goto unmapped_gva;
 
-	return (pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
+	return ((vm_paddr_t)pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
 
 unmapped_gva:
 	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
-- 
2.32.0

