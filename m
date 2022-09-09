Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB035B356D
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiIIKpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiIIKpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:45:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBDB4BA7E
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662720313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GS6z751jOS17P5KjjAKA6XFU5o/FNq7ECC/sWEiv1wc=;
        b=e5jg4GsEbWZyjBtV1RtUCxlb+FhUYxqPo6iW2oRE5HDC5VrDgT8FtGxcUaaUTWR3dMUrIh
        B97D+KyGEeGnT8nlUmu1ZK2yiZUdsbzmraFNMlKQJ/wYmyHqYet/qnZlyNFDuHgsUlJdhC
        BJxWEmJ35r8R7zTCo432eaTZhJncmQw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-V6wIM2X6MCqAcYvkPXZmGw-1; Fri, 09 Sep 2022 06:45:09 -0400
X-MC-Unique: V6wIM2X6MCqAcYvkPXZmGw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 386D4101A56D;
        Fri,  9 Sep 2022 10:45:09 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1907840D2830;
        Fri,  9 Sep 2022 10:45:08 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Date:   Fri,  9 Sep 2022 06:44:57 -0400
Message-Id: <20220909104506.738478-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM is currently capable of receiving a single memslot update through
the KVM_SET_USER_MEMORY_REGION ioctl.
The problem arises when we want to atomically perform multiple updates,
so that readers of memslot active list avoid seeing incomplete states.

For example, in RHBZ https://bugzilla.redhat.com/show_bug.cgi?id=1979276
we see how non atomic updates cause boot failure, because vcpus
will se a partial update (old memslot delete, new one not yet created)
and will crash.

In this series we introduce KVM_SET_USER_MEMORY_REGION_LIST, a new ioctl
that takes a kvm_userspace_memory_region_list, a list of memslot updates,
and performs them atomically.
"atomically" in KVM words just means "apply all modifications to the
inactive memslot list, and then perform a single swap to replace the
active list with the inactive".
It is slightly more complicated that that, since DELETE and MOVE operations
require 2 swaps, but the main idea is the above.

Patch 1-6 are just code movements, in preparation for the following patches.
Patch 7 allows the invalid slot to be in both inactive and active memslot lists.
Patch 8 allows searching for the existing memslot (old) in the inactive list,
and not the active, allowing to perform multiple memslot updates without swapping.
Patch 9 implements IOCTL logic.

QEMU userspace logic in preparation for the IOCTL is here:
https://patchew.org/QEMU/20220909081150.709060-1-eesposit@redhat.com/
"[RFC PATCH v2 0/3] accel/kvm: extend kvm memory listener to support"

TODOs and ideas:
- limit the size of the ioctl arguments. Right now it is unbounded
- try to reduce the amount of swaps necessary? ie every DELETE/MOVE
  requires an additional swap
- add selftests
- add documentation

Emanuele Giuseppe Esposito (9):
  kvm_main.c: move slot check in kvm_set_memory_region
  kvm.h: introduce KVM_SET_USER_MEMORY_REGION_LIST ioctl
  kvm_main.c: introduce kvm_internal_memory_region_list
  kvm_main.c: split logic in kvm_set_memslots
  kvm_main.c: split __kvm_set_memory_region logic in kvm_check_mem and
    kvm_prepare_batch
  kvm_main.c: simplify change-specific callbacks
  kvm_main.c: duplicate invalid memslot also in inactive list
  kvm_main.c: find memslots from the inactive memslot list
  kvm_main.c: handle atomic memslot update

 arch/x86/kvm/x86.c       |   3 +-
 include/linux/kvm_host.h |  21 +-
 include/uapi/linux/kvm.h |  21 +-
 virt/kvm/kvm_main.c      | 420 +++++++++++++++++++++++++++++++--------
 4 files changed, 377 insertions(+), 88 deletions(-)

-- 
2.31.1

