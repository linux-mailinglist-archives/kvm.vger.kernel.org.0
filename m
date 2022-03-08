Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8427A4D1556
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346072AbiCHLA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 06:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346032AbiCHLAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 06:00:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9E5B41F8A
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 02:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646737166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3yqdS8zAEjaJjs00ZY9U4Ql4/aCVM8MsMEwUnD+zf4Q=;
        b=gmxuOCBH0GYQ9xycyAssx2/7ahDXce5OBPi2NrUCH2L/q5PcL7TlBLuwx+T+ikRhSMeAne
        VMSZs2Wy0OuzAageMDARFxzoW56iV0odV9Q/nhKyj0REwEHk8SMzoBoA0wo+lX1FOhvhVe
        u9bZZYFgfc6Kqh65Cicuseh3y+uqQxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-345-D7y9jPIWOpia1cea1Qxr2w-1; Tue, 08 Mar 2022 05:59:23 -0500
X-MC-Unique: D7y9jPIWOpia1cea1Qxr2w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D828801AEB;
        Tue,  8 Mar 2022 10:59:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9CB46FB03;
        Tue,  8 Mar 2022 10:59:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: [PATCH 0/3] mm: vmalloc: introduce array allocation functions
Date:   Tue,  8 Mar 2022 05:59:15 -0500
Message-Id: <20220308105918.615575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch in this series introduces four array allocation
functions to replace vmalloc(array_size()) and vzalloc(array_size()),
of which Linux has dozens of occurrences.  The Functions take care of
the multiplication and overflow check, result in simpler code and make
it easier for developers to avoid overflow bugs.

The other two patches start to apply the functions in the mm/ and KVM
areas.  In the case of KVM, it is also important to switch from kvcalloc
to __vcalloc; the allocation size is driven by userspace and can be larger
than 4GiB, which has been forbidden by the kv*alloc functions since 5.15.

Paolo

Paolo Bonzini (3):
  mm: vmalloc: introduce array allocation functions
  mm: use vmalloc_array and vcalloc for array allocations
  KVM: use __vcalloc for very large allocations

 arch/powerpc/kvm/book3s_hv_uvmem.c |  2 +-
 arch/x86/kvm/mmu/page_track.c      |  7 +++--
 arch/x86/kvm/x86.c                 |  4 +--
 include/linux/vmalloc.h            |  5 +++
 mm/percpu-stats.c                  |  2 +-
 mm/swap_cgroup.c                   |  4 +--
 mm/util.c                          | 50 ++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                |  4 +--
 9 files changed, 66 insertions(+), 12 deletions(-)

-- 
2.31.1

