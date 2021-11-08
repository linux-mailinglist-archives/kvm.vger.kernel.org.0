Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83BE449846
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 16:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbhKHPbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 10:31:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239124AbhKHPbP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 10:31:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636385310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sh0jeoaaV6hR+Zk6dI8yO0WLid/uTuPNM9688vfZlag=;
        b=XiOSOftROmXqqUii+64E6pdovYL9Y/4e0pd1A0XaENANJ9QMOFUppiBmfgdWPLHS5BMODG
        Es/0071ogoNs8Q0kcQoHsgcmkoVFWwPSbFSehIYznA2z52q4fF3PsID9Tqe+RAfbxo2o8A
        3ZBeWSR8nNdzsKK+QZRuS66EDm36SR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-5Z0ArhbNPzCZjDsBRGzHjg-1; Mon, 08 Nov 2021 10:28:24 -0500
X-MC-Unique: 5Z0ArhbNPzCZjDsBRGzHjg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 218CC1DDF0;
        Mon,  8 Nov 2021 15:28:23 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E28E3794A4;
        Mon,  8 Nov 2021 15:28:20 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Li RongQing <lirongqing@baidu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86: Sanitize writes to MSR_KVM_PV_EOI_EN
Date:   Mon,  8 Nov 2021 16:28:17 +0100
Message-Id: <20211108152819.12485-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a continuation of work started by Li RongQing with
"[PATCH] KVM: x86: disable pv eoi if guest gives a wrong address":
https://lore.kernel.org/kvm/1636078404-48617-1-git-send-email-lirongqing@baidu.com/

Instead of resetting 'KVM_MSR_ENABLED' when a bogus address was written to
MSR_KVM_PV_EOI_EN I suggest we refuse to update MSR at all, this aligns
with #GP which is being injected on such writes.

Vitaly Kuznetsov (2):
  KVM: x86: Rename kvm_lapic_enable_pv_eoi()
  KVM: x86: Don't update vcpu->arch.pv_eoi.msr_val when a bogus value
    was written to MSR_KVM_PV_EOI_EN

 arch/x86/kvm/hyperv.c |  4 ++--
 arch/x86/kvm/lapic.c  | 23 ++++++++++++++---------
 arch/x86/kvm/lapic.h  |  2 +-
 arch/x86/kvm/x86.c    |  2 +-
 4 files changed, 18 insertions(+), 13 deletions(-)

-- 
2.31.1

