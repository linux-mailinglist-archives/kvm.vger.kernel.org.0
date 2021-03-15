Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FDD33BDC4
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 15:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhCOOif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 10:38:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56464 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238626AbhCOOhO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 10:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0LYR6JBqjo2XVOwjxQTLuJ6o2JNXhKkR1znK2FpvTjM=;
        b=IPg23awUmxSTotU4TK6VumeE2IvTt8Y5XtuGO1WwTLXOUhsUARdiICdjSe4fw4uCOQdwnx
        yy/B5RK4ijoqJtEH3m89DWmeQUVIgisTGu6LoqMaeN/N9XSYUaOFYwUCYMKg7VythVIxFl
        ayy5G4pm6odEaCuMiJCJ0GpVmImSGgs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-TdQEF0uUPR2PJhuQmxBClg-1; Mon, 15 Mar 2021 10:37:11 -0400
X-MC-Unique: TdQEF0uUPR2PJhuQmxBClg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D63D9107ACCA;
        Mon, 15 Mar 2021 14:37:09 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04A9C5C3E6;
        Mon, 15 Mar 2021 14:37:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 0/4] KVM: x86: hyper-v: TSC page fixes
Date:   Mon, 15 Mar 2021 15:37:02 +0100
Message-Id: <20210315143706.859293-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm investigating an issue when Linux guest on nested Hyper-V on KVM 
(WSL2 on Win10 on KVM to be precise) hangs after L1 KVM is migrated. Trace
shows us that L2 is trying to set L1's Synthetic Timer and reacting to
this Hyper-V sets Synthetic Timer in KVM but the target value it sets is
always slightly in the past, this causes the timer to expire immediately
and an interrupt storm is thus observed. L2 is not making much forward
progress.

The issue is only observed when re-enlightenment is exposed to L1. KVM
doesn't really support re-enlightenment notifications upon migration,
userspace is supposed to expose it only when TSC scaling is supported
on the destination host. Without re-enlightenment exposed, Hyper-V will
not expose stable TSC page clocksource to its L2s. The issue is observed
on when migration happens between hosts supporting TSC scaling. Rumor has
it that it is possible to reproduce the problem even when migrating locally
to the same host, though, I wasn't really able to.

The current speculation is that when Hyper-V is migrated, it uses stale
(cached) TSC page values to compute the difference between its own
clocksource (provided by KVM) and its guests' TSC pages to program
synthetic timers and in some cases, when TSC page is updated, this puts all
stimer expirations in the past. This, in its turn, causes an interrupt
storms (both L0-L1 and L1->L2 as Hyper-V mirrors stimer expirations into
L2).

The proposed fix is to skip updating TSC page clocksource when guest opted
for re-enlightenment notifications (PATCH4). Patches 1-3 are slightly
related fixes to the (mostly theoretical) issues I've stumbled upon while
working on the problem.

Vitaly Kuznetsov (4):
  KVM: x86: hyper-v: Limit guest to writing zero to
    HV_X64_MSR_TSC_EMULATION_STATUS
  KVM: x86: hyper-v: Prevent using not-yet-updated TSC page by secondary
    CPUs
  KVM: x86: hyper-v: Track Hyper-V TSC page status
  KVM: x86: hyper-v: Don't touch TSC page values when guest opted for
    re-enlightenment

 arch/x86/include/asm/kvm_host.h |  9 +++++++
 arch/x86/kvm/hyperv.c           | 42 +++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.c              |  5 ++--
 3 files changed, 49 insertions(+), 7 deletions(-)

-- 
2.30.2

