Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7420A6057FE
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 09:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiJTHMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 03:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiJTHMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 03:12:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082CD159A15
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 00:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666249968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iSbqsg4g0J+uDTur4nOLOrDlqWhjBL7zIdyxmPl56wI=;
        b=JBb5P3wSgMJfLi30+oCzV1VB7373nMV1LjGrmE5PySTrSnLcUDznAXSMJLqhevPvEPh+04
        y9A3rU8jSCrwd9X1/MrTdg+TqatO0kLy92WBGYgB92zwUCbJgd23V29Mxkv7XwDMvelXwS
        IOiTvgrqdg7L/pfQiPWFlt8kj0dfamk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-Va38NGliOg6Us14EzfvzXA-1; Thu, 20 Oct 2022 03:12:44 -0400
X-MC-Unique: Va38NGliOg6Us14EzfvzXA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C45BE101A52A;
        Thu, 20 Oct 2022 07:12:43 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7703C40C6EC2;
        Thu, 20 Oct 2022 07:12:38 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mail@maciej.szmigiero.name,
        maz@kernel.org, pbonzini@redhat.com, ajones@ventanamicro.com,
        shuah@kernel.org, peterx@redhat.com, oliver.upton@linux.dev,
        seanjc@google.com, ricarkol@google.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH v3 0/6] KVM: selftests: memslot_perf_test: aarch64 cleanup/fixes
Date:   Thu, 20 Oct 2022 15:12:03 +0800
Message-Id: <20221020071209.559062-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm/selftests/memslots_perf_test doesn't work with 64KB-page-size-host
and 4KB-page-size-guest on aarch64. In the implementation, the host and
guest page size have been hardcoded to 4KB. It's ovbiously not working
on aarch64 which supports 4KB, 16KB, 64KB individually on host and guest.

This series tries to fix it. After the series is applied, the test runs
successfully with 64KB-page-size-host and 4KB-page-size-guest.

   # ./memslots_perf_tests -v -s 512

Since we're here, the code is cleaned up a bit as PATCH[1-3] do. The
other patches are fixes to handle the mismatched host/guest page
sized.

v1: https://lore.kernel.org/kvmarm/20221014071914.227134-1-gshan@redhat.com/T/#t
v2: https://lore.kernel.org/kvmarm/20221018040454.405719-1-gshan@redhat.com/T/#t

Changelog
=========
v3:
  * Improved comments about MEM_TEST_MOVE_SIZE, which is set
    to 64KB in PATCH[v3 4/6] and finally fixed to 192KB in
    PATCH[v3 5/6].                                              (Maciej)
  * Use size instead of pages to do the comparison in
    test_memslot_move_prepare()                                 (Maciej)
  * Use tools/include/linux/sizes.h instead of inventing
    our own macros.                                             (Oliver)
v2:
  * Pick the smaller value between the ones specified by
    user or probed from KVM_CAP_NR_MEMSLOTS in PATCH[v2 3/6]    (Maciej)
  * Improved comments about MEM_TEST_MOVE_SIZE in
    PATCH[v2 4/6]                                               (Maciej)
  * Avoid mismatched guest page size after VM is started in
    prepare_vm() in PATCH[v2 4/6]                               (Maciej)
  * Fix condition to check MEM_TEST_{UNMAP, UNMAP_CHUNK}_SIZE
    in check_memory_size() in PATCH[v2 4/6]                     (Maciej)
  * Define base and huge page size in kvm_util_base.h in
    PATCH[v2 5/6]                                               (Sean)
  * Add checks on host/guest page size in check_memory_size()
    and fail early if any of them exceeds 64KB in PATCH[v2 5/6] (Maciej)


Gavin Shan (6):
  KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
  KVM: selftests: memslot_perf_test: Consolidate loop conditions in
    prepare_vm()
  KVM: selftests: memslot_perf_test: Probe memory slots for once
  KVM: selftests: memslot_perf_test: Support variable guest page size
  KVM: selftests: memslot_perf_test: Consolidate memory
  KVM: selftests: memslot_perf_test: Report optimal memory slots

 .../testing/selftests/kvm/memslot_perf_test.c | 317 ++++++++++++------
 1 file changed, 208 insertions(+), 109 deletions(-)

-- 
2.23.0

