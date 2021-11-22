Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55082459466
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 18:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239614AbhKVSBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:01:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239456AbhKVSBd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 13:01:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637603906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oho2gQcrtnBzKN/N7Mw7niaAvzwkqs20P8dz8NbT/KA=;
        b=bB8KI4pLxKHBVMURumSkvoRKqaQJzOlmGaSmGEooDydgu/pOIkjYd0/o/vt1DMHRjSKXUg
        PwnB+ltlmnjFD1uEW76sSaAP+aYWvQvxy12O499MU0c7xl0HsnQSXF/ZYGAGJnBquhzYLZ
        gZg+DMiy7px5BudbrnWcJFguq3jrwh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-181-Ba9gOhaROT-WNYpa-QMgvw-1; Mon, 22 Nov 2021 12:58:23 -0500
X-MC-Unique: Ba9gOhaROT-WNYpa-QMgvw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07BC7872FF3;
        Mon, 22 Nov 2021 17:58:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 119721037F5D;
        Mon, 22 Nov 2021 17:58:19 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Date:   Mon, 22 Nov 2021 18:58:16 +0100
Message-Id: <20211122175818.608220-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 63f5a1909f9e ("KVM: x86: Alert userspace that KVM_SET_CPUID{,2}
after KVM_RUN is broken") officially deprecated KVM_SET_CPUID{,2} ioctls
after first successful KVM_RUN and promissed to make this sequence forbiden
in 5.16. TO fulfil the promise 'hyperv_features' selftest needs to be fixed
first.

Vitaly Kuznetsov (2):
  KVM: selftests: Avoid KVM_SET_CPUID2 after KVM_RUN in hyperv_features
    test
  KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN

 arch/x86/kvm/mmu/mmu.c                        |  20 +--
 arch/x86/kvm/x86.c                            |  27 ++++
 .../selftests/kvm/x86_64/hyperv_features.c    | 140 +++++++++---------
 3 files changed, 101 insertions(+), 86 deletions(-)

-- 
2.33.1

