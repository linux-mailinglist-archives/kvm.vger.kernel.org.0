Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2E545E3B1
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 01:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349802AbhKZAgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 19:36:40 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:55264 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238708AbhKZAej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 19:34:39 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mqP91-0007Gv-5T; Fri, 26 Nov 2021 01:31:15 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: Scalable memslots implementation additional patches
Date:   Fri, 26 Nov 2021 01:31:06 +0100
Message-Id: <cover.1637884349.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

While the last "5.5" version of KVM scalable memslots implementation was
merged to kvm/queue some changes from its review round are still pending.

This series contains these changes which still apply to the final form of
the code.

The changes include switching kvm_for_each_memslot_in_gfn_range() to use
iterators.
However, I've dropped kvm_for_each_memslot_in_hva_range() rework to
use dedicated iterators since the existing implementation was already
returning only strictly overlapping memslots and it was already using
interval tree iterators.
The code there is also self-contained and very simple.

The code was tested on x86 with KASAN on and booted various guests
successfully (including nested ones; with TDP MMU both enabled and disabled).

There were some VMX APICv warnings during these tests but these look
related to the latest VMX PI changes rather than memslots handling code.

 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/mmu/mmu.c          |  11 ++--
 arch/x86/kvm/x86.c              |   3 +-
 include/linux/kvm_host.h        | 104 ++++++++++++++++++++------------
 virt/kvm/kvm_main.c             |  25 +++-----
 5 files changed, 83 insertions(+), 62 deletions(-)

