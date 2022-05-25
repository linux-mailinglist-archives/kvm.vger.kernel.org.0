Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB446533F4F
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 16:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbiEYOfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 10:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbiEYOff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 10:35:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86DFDA76F4
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 07:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653489332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=blExWzXbh/zvOBhUZ8Z2FT5bxTyHpnQEmh5Dkx3hZ4w=;
        b=I1X96LqIjAv8iLsSFX3gAy0YElqgQweSKG4VxzHHx4ve71IoFhfIRGYhmNouq+k30C3ADf
        YdZeDTb9iM3zUj8lAQ2hgf6870RYsVX2tPhfXOmRsKhOwFHqxqd5ItDHR59pM0VKWVFyXc
        i2WyLtSKmMtKclxReIBW7wBI7ZyBKRw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-sEPaT_uUMhuI4JCjWPKHpw-1; Wed, 25 May 2022 10:35:31 -0400
X-MC-Unique: sEPaT_uUMhuI4JCjWPKHpw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8BCD1C0782A
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 14:35:30 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC18E1410DD5;
        Wed, 25 May 2022 14:35:29 +0000 (UTC)
Message-ID: <201c43722d7f0faffc9a2377fd25fd31f4565898.camel@redhat.com>
Subject: FYI: hyperv_clock  selftest has random failures
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 25 May 2022 17:35:28 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just something I noticed today. Happens on both AMD and Intel, kvm/queue. 

Likely the test needs lower tolerancies.

I'll investigate this later

This is on my AMD machine (3970X):

[mlevitsk@starship ~/Kernel/master/src/tools/testing/selftests/kvm]$while true ; do ./x86_64/hyperv_clock  ; done
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=66218 tid=66218 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f0f2822d55f: ?? ??:0
     4	0x00007f0f2822d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=471600, TSC=461024)
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=66269 tid=66269 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f296522d55f: ?? ??:0
     4	0x00007f296522d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=460700, TSC=475361)
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:234: false
  pid=66652 tid=66652 errno=4 - Interrupted system call
     1	0x00000000004026e7: main at hyperv_clock.c:234
     2	0x00007fdab782d55f: ?? ??:0
     3	0x00007fdab782d60b: ?? ??:0
     4	0x0000000000402744: _start at ??:?
  Failed guest assert: delta_ns * 100 < (t2 - t1) * 100 at x86_64/hyperv_clock.c:74
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=67112 tid=67112 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f3095c2d55f: ?? ??:0
     4	0x00007f3095c2d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=469600, TSC=484418)
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:234: false
  pid=67146 tid=67146 errno=4 - Interrupted system call
     1	0x00000000004026e7: main at hyperv_clock.c:234
     2	0x00007f81b802d55f: ?? ??:0
     3	0x00007f81b802d60b: ?? ??:0
     4	0x0000000000402744: _start at ??:?
  Failed guest assert: delta_ns * 100 < (t2 - t1) * 100 at x86_64/hyperv_clock.c:74
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=67179 tid=67179 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f1fb522d55f: ?? ??:0
     4	0x00007f1fb522d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=470300, TSC=461134)
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:234: false
  pid=67459 tid=67459 errno=4 - Interrupted system call
     1	0x00000000004026e7: main at hyperv_clock.c:234
     2	0x00007f330dc2d55f: ?? ??:0
     3	0x00007f330dc2d60b: ?? ??:0
     4	0x0000000000402744: _start at ??:?
  Failed guest assert: delta_ns * 100 < (t2 - t1) * 100 at x86_64/hyperv_clock.c:74
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:234: false
  pid=67622 tid=67622 errno=4 - Interrupted system call
     1	0x00000000004026e7: main at hyperv_clock.c:234
     2	0x00007f9da422d55f: ?? ??:0
     3	0x00007f9da422d60b: ?? ??:0
     4	0x0000000000402744: _start at ??:?
  Failed guest assert: delta_ns * 100 < (t2 - t1) * 100 at x86_64/hyperv_clock.c:74
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=68043 tid=68043 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f3ba2c2d55f: ?? ??:0
     4	0x00007f3ba2c2d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=482900, TSC=468989)
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=68118 tid=68118 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f25ef62d55f: ?? ??:0
     4	0x00007f25ef62d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=362300, TSC=379772)
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:234: false
  pid=68233 tid=68233 errno=4 - Interrupted system call
     1	0x00000000004026e7: main at hyperv_clock.c:234
     2	0x00007f7e94c2d55f: ?? ??:0
     3	0x00007f7e94c2d60b: ?? ??:0
     4	0x0000000000402744: _start at ??:?
  Failed guest assert: delta_ns * 100 < (t2 - t1) * 100 at x86_64/hyperv_clock.c:74
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=68609 tid=68609 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f69a3a2d55f: ?? ??:0
     4	0x00007f69a3a2d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=475800, TSC=466334)



This is on my Intel machine:

[mlevitsk@worklaptop ~/Kernel/master/src/tools/testing/selftests/kvm]$while true ; do ./x86_64/hyperv_clock  ; done
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:234: false
  pid=52204 tid=52204 errno=4 - Interrupted system call
     1	0x00000000004026e7: main at hyperv_clock.c:234
     2	0x00007fd2baa2d55f: ?? ??:0
     3	0x00007fd2baa2d60b: ?? ??:0
     4	0x0000000000402744: _start at ??:?
  Failed guest assert: delta_ns * 100 < (t2 - t1) * 100 at x86_64/hyperv_clock.c:74
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:234: false
  pid=52517 tid=52517 errno=4 - Interrupted system call
     1	0x00000000004026e7: main at hyperv_clock.c:234
     2	0x00007f832a02d55f: ?? ??:0
     3	0x00007f832a02d60b: ?? ??:0
     4	0x0000000000402744: _start at ??:?
  Failed guest assert: delta_ns * 100 < (t2 - t1) * 100 at x86_64/hyperv_clock.c:74
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=52598 tid=52598 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f52bd02d55f: ?? ??:0
     4	0x00007f52bd02d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=263000, TSC=269964)
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=52645 tid=52645 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f398d22d55f: ?? ??:0
     4	0x00007f398d22d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=530300, TSC=521275)
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=52762 tid=52762 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007fdaac62d55f: ?? ??:0
     4	0x00007fdaac62d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=263800, TSC=267716)
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=52787 tid=52787 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f029322d55f: ?? ??:0
     4	0x00007f029322d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=342200, TSC=332493)
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:234: false
  pid=52968 tid=52968 errno=4 - Interrupted system call
     1	0x00000000004026e7: main at hyperv_clock.c:234
     2	0x00007f133202d55f: ?? ??:0
     3	0x00007f133202d60b: ?? ??:0
     4	0x0000000000402744: _start at ??:?
  Failed guest assert: delta_ns * 100 < (t2 - t1) * 100 at x86_64/hyperv_clock.c:74
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=53349 tid=53349 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f28fbc2d55f: ?? ??:0
     4	0x00007f28fbc2d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=265300, TSC=257886)
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:234: false
  pid=53460 tid=53460 errno=4 - Interrupted system call
     1	0x00000000004026e7: main at hyperv_clock.c:234
     2	0x00007f7a0542d55f: ?? ??:0
     3	0x00007f7a0542d60b: ?? ??:0
     4	0x0000000000402744: _start at ??:?
  Failed guest assert: delta_ns * 100 < (t2 - t1) * 100 at x86_64/hyperv_clock.c:74
==== Test Assertion Failure ====
  x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
  pid=53847 tid=53847 errno=0 - Success
     1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
     2	 (inlined by) main at hyperv_clock.c:223
     3	0x00007f7d53c2d55f: ?? ??:0
     4	0x00007f7d53c2d60b: ?? ??:0
     5	0x0000000000402744: _start at ??:?
  Elapsed time does not match (MSR=578800, TSC=527827)



Best regards,
	Maxim Levitsky

