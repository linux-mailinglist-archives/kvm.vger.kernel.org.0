Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79CD35F3E3
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 14:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350958AbhDNMgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 08:36:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25602 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350951AbhDNMgO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 08:36:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618403753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1d76h5lbcfofHJsa9ymlWqG/TzME9YBSEisvqRIJKpc=;
        b=FwB3XDzT3Lpb0HnyARviir2Eq6zTtVRlaffuKksOrNitd5jdGixEyJPcUonkHNqCG+p3p/
        LpfQso9HzvDpfxigds4t4Ods6fILGZLZ717KFxgI5kj3yGEfCVu1MO9VMsvK5VYVET1y0Z
        LYWWpvwNg3hMfjBqZxNiL0FdPq/9d5Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-OxkhufTGPl-2DOZRw_2htQ-1; Wed, 14 Apr 2021 08:35:49 -0400
X-MC-Unique: OxkhufTGPl-2DOZRw_2htQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37EF6801FCE;
        Wed, 14 Apr 2021 12:35:48 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.196.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C2C45D9DE;
        Wed, 14 Apr 2021 12:35:45 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Lenny Szubowicz <lszubowi@redhat.com>,
        Mohamed Aboubakr <mabouba@amazon.com>,
        Xiaoyi Chen <cxiaoyi@amazon.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] x86/kvm: Refactor KVM PV features teardown and fix restore from hibernation
Date:   Wed, 14 Apr 2021 14:35:39 +0200
Message-Id: <20210414123544.1060604-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is a successor of Lenny's "[PATCH] x86/kvmclock: Stop kvmclocks
for hibernate restore". While reviewing his patch I realized that PV
features teardown we have is a bit messy: it is scattered across kvm.c
and kvmclock.c and not all features are being shutdown an all paths.
This series unifies all teardown paths in kvm.c and makes sure all
features are disabled when needed.

Vitaly Kuznetsov (5):
  x86/kvm: Fix pr_info() for async PF setup/teardown
  x86/kvm: Teardown PV features on boot CPU as well
  x86/kvm: Disable kvmclock on all CPUs on shutdown
  x86/kvm: Disable all PV features on crash
  x86/kvm: Unify kvm_pv_guest_cpu_reboot() with kvm_guest_cpu_offline()

 arch/x86/include/asm/kvm_para.h |  10 +--
 arch/x86/kernel/kvm.c           | 113 +++++++++++++++++++++-----------
 arch/x86/kernel/kvmclock.c      |  26 +-------
 3 files changed, 78 insertions(+), 71 deletions(-)

-- 
2.30.2

