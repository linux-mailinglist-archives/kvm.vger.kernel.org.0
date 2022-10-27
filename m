Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2FE60FCD7
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbiJ0QTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236564AbiJ0QTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:19:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1050B196B60
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=84sVda7U9mQaMOXPCTI3bFTR+X8lA+WwdoHypcHkG8M=;
        b=fJI6fn/n61tscrYZ6/l3K6xEyV5LRHJe9AjXFnKOeZBAZNZGf1BgFw88AWDA8UBgOPFplv
        147V2RiZ4hCs+IP3qzgM8+7iHTKNtqBTK9ppqYGthMMaCTj8VoCR8z0MuK+Vjw2RD15YwD
        JahrgfSTdnJASS36lAqQyIlUn+upoVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-lzUzvazuMQGIC7ncG9DJSw-1; Thu, 27 Oct 2022 12:18:50 -0400
X-MC-Unique: lzUzvazuMQGIC7ncG9DJSw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E95885A583;
        Thu, 27 Oct 2022 16:18:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C2971415117;
        Thu, 27 Oct 2022 16:18:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH v3 00/16] KVM: x86: Always use non-compat vcpu_runstate_info size for gfn=>pfn cache
Date:   Thu, 27 Oct 2022 12:18:33 -0400
Message-Id: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The highlights are two fixes for bugs where "destroying" and "initializing"
a gfn=>pfn cache while it is being accessed results in various forms of
badness, e.g. re-initialization of an in-use lock, consuming a NULL pointer,
potential memory corruption, etc...

Everything else is cleanup to make the gpc APIs easier to use and harder
to use incorrectly.

The main difference with v2 is in playing it safer with 32-bit guests that
place the runstate info close to the end of a page.  This is a preexisting
issue that is fixed here because it affects the gfn-to-pfn cache API.
In particular, compared to v2 the length is passed at activation time
instead of initialization time.  This affects patch 7 ("KVM: Store
gfn_to_pfn_cache length at activation time"), which now incorporates some
parts of patch 13 ("KVM: Drop @gpa from exported gfn=>pfn cache check()
and refresh() helpers") to introduce __kvm_gpc_refresh.

Initially I wanted to restrict the ordering between setting Xen VM
and vCPU attributes.  In the end I left that patch out because it may
complicate the reset sequence further.

Paolo

Michal Luczaj (8):
  KVM: Initialize gfn_to_pfn_cache locks in dedicated helper
  KVM: Shorten gfn_to_pfn_cache function names
  KVM: x86: Remove unused argument in gpc_unmap_khva()
  KVM: Store immutable gfn_to_pfn_cache properties
  KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_check()
  KVM: Clean up hva_to_pfn_retry()
  KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_refresh()
  KVM: selftests: Add tests in xen_shinfo_test to detect lock races

Paolo Bonzini (2):
  KVM: x86: set gfn-to-pfn cache length consistently with VM word size
  KVM: Store gfn_to_pfn_cache length at activation time

Sean Christopherson (6):
  KVM: Reject attempts to consume or refresh inactive gfn_to_pfn_cache
  KVM: Drop KVM's API to allow temprorarily unmapping gfn=>pfn cache
  KVM: Do not partially reinitialize gfn=>pfn cache during activation
  KVM: Drop @gpa from exported gfn=>pfn cache check() and refresh()
    helpers
  KVM: Skip unnecessary "unmap" if gpc is already valid during refresh
  KVM: selftests: Mark "guest_saw_irq" as volatile in xen_shinfo_test

 arch/x86/kvm/x86.c                            |  24 +--
 arch/x86/kvm/xen.c                            | 121 ++++++++------
 include/linux/kvm_host.h                      |  70 ++++----
 include/linux/kvm_types.h                     |   2 +
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 142 +++++++++++++++-
 virt/kvm/pfncache.c                           | 155 ++++++++++--------
 6 files changed, 345 insertions(+), 169 deletions(-)

-- 
2.31.1

