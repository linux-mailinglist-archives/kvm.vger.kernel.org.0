Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F1C2F7C67
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732886AbhAONVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:21:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732822AbhAONVL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:21:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610716730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bCrvudd8WM+aVyudRWSq4Vs5HPTCK/SkatpqJMHjO6c=;
        b=C/DiDYrHvDNnvAI3XyNHjchpDBUgH4CvfiXuvVfqQdngaHcf4dIWoNQv94N2tZst+m241p
        SAd4mhFlvIN/mF8r8FiXE2Ljkh0MUiwhMFXEh6/85EwNXrA32Ao0EwBBkTPH41LHNLCndW
        mFbgLQBAxXFI47qTwxxRHB2ydf87RvE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-yiRhxk8DNjyVVqxQRxW9-w-1; Fri, 15 Jan 2021 08:18:49 -0500
X-MC-Unique: yiRhxk8DNjyVVqxQRxW9-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72B5F100F340;
        Fri, 15 Jan 2021 13:18:47 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6C73608BA;
        Fri, 15 Jan 2021 13:18:45 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 0/4] KVM: x86: Drastically raise KVM_USER_MEM_SLOTS limit
Date:   Fri, 15 Jan 2021 14:18:40 +0100
Message-Id: <20210115131844.468982-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TL;DR: any particular reason why KVM_USER_MEM_SLOTS is so low?

Longer version:

Current KVM_USER_MEM_SLOTS limit (509) can be a limiting factor for some
configurations. In particular, when QEMU tries to start a Windows guest
with Hyper-V SynIC enabled and e.g. 256 vCPUs the limit is hit as SynIC
requires two pages per vCPU and the guest is free to pick any GFN for
each of them, this fragments memslots as QEMU wants to have a separate
memslot for each of these pages (which are supposed to act as 'overlay'
pages).

Memory slots are allocated dynamically in KVM when added so the only real
limitation is 'id_to_index' array which is 'short'. We don't have any
KVM_MEM_SLOTS_NUM/KVM_USER_MEM_SLOTS-sized statically defined arrays.

We could've just raised the limit to e.g. '1021' (we have 3 private
memslots on x86) and this should be enough for now as KVM_MAX_VCPUS is
'288' but AFAIK there are plans to raise this limit as well.

Vitaly Kuznetsov (4):
  KVM: x86: Drop redundant KVM_MEM_SLOTS_NUM definition
  KVM: mips: Drop KVM_PRIVATE_MEM_SLOTS definition
  KVM: Define KVM_USER_MEM_SLOTS in arch-neutral
    include/linux/kvm_host.h
  KVM: x86: Stop limiting KVM_USER_MEM_SLOTS

 arch/mips/include/asm/kvm_host.h | 2 --
 arch/x86/include/asm/kvm_host.h  | 3 +--
 include/linux/kvm_host.h         | 4 ++++
 3 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.29.2

