Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCAA867F26C
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 00:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjA0XxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 18:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjA0XxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 18:53:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE8459E50
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 15:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674863551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BQMEZRsgVM2HSFe9NijBSKPEa568wzbl1o/5iMJMWGk=;
        b=h0yBBSEIjjGAcgHawIP7zwtvxe8MFc/u6BYvZSCrl0WPyiOsLIu18J4jGZCg3iM7I9GFAS
        aNvJmQDTIVT8FAhyG8twLQd1/wZOuXs+vas2UbH609nqggBtu4GxBmmt3n5HBweEKnj9EC
        PfB3Js8HzUSz30KG0qU5lBaiLojDJ/Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-JnfRbcj7PrW6L-U2dOC3tA-1; Fri, 27 Jan 2023 18:52:28 -0500
X-MC-Unique: JnfRbcj7PrW6L-U2dOC3tA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BF8F29AA3B9;
        Fri, 27 Jan 2023 23:52:27 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-64.bne.redhat.com [10.64.54.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F259240C141B;
        Fri, 27 Jan 2023 23:52:18 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, corbet@lwn.net, maz@kernel.org,
        james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, yuzhe@nfschina.com,
        gshan@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        ricarkol@google.com, eric.auger@redhat.com, renzhengeek@gmail.com,
        reijiw@google.com, shan.gavin@gmail.com
Subject: [PATCH v4 0/4] Improve dirty ring warning report
Date:   Sat, 28 Jan 2023 07:51:46 +0800
Message-Id: <20230127235150.17025-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It has been known case where no running VCPU context exists when the
vgic/its tables are saved. There are other two unknown cases where we
don't have the running VCPU context: (a) restore VGICv3 LPI pending
status. (b) restoring VGICv3 pending tables.

PATCH[1]     includes 'kvm_mmu.h' to 'vgic.h'
PATCH[2]     adds unified helper vgic_write_guest_lock()
PATCH[3 - 4] allows no-running-vcpu context for (a) and (b)

v3: https://lore.kernel.org/kvmarm/20230126235451.469087-1-gshan@redhat.com/T/#t
v2: https://lore.kernel.org/kvmarm/Y9Lg1ESUVJov0WpH@google.com/T/#t
v1: https://lore.kernel.org/kvmarm/20230116040405.260935-1-gshan@redhat.com/T/#t

Changelog
=========
v4:
  * s/vgic3/VGICv3                                             (Zenghui)
  * s/save_tables_in_progress/write_tables_in_progress         (Zenghui)
v3:
  * Pick Oliver's r-bs
  * Include 'kvm_mmu.h' to 'vgic.h'                            (Oliver)
v2:
  * Add unified helper vgic_write_guest_lock()                 (Oliver)
  * Dropped two patches to refactor mark_page_dirty_in_slot()  (Sean)

Gavin Shan (4):
  KVM: arm64: Include kvm_mmu.h from vgic.h
  KVM: arm64: Add helper vgic_write_guest_lock()
  KVM: arm64: Allow no running vcpu on restoring VGICv3 LPI pending
    status
  KVM: arm64: Allow no running vcpu on saving VGICv3 pending table

 Documentation/virt/kvm/api.rst        | 10 +++++++---
 arch/arm64/kvm/vgic/vgic-debug.c      |  1 -
 arch/arm64/kvm/vgic/vgic-init.c       |  1 -
 arch/arm64/kvm/vgic/vgic-its.c        | 14 +++++---------
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  1 -
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  1 -
 arch/arm64/kvm/vgic/vgic-v2.c         |  1 -
 arch/arm64/kvm/vgic/vgic-v3.c         |  5 ++---
 arch/arm64/kvm/vgic/vgic.h            | 14 ++++++++++++++
 include/kvm/arm_vgic.h                |  2 +-
 10 files changed, 29 insertions(+), 21 deletions(-)

-- 
2.23.0

