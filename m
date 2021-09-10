Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571E6406ED3
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 18:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhIJQIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 12:08:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28024 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231717AbhIJQHv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 12:07:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631289999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7FIHzSBbNjLJLP/TbCUVl6AXA2FHU6lfKWV0UxZklGM=;
        b=X0lfDnCD4W+4syNY77bF9RZJzDdv1+byq3L0+IgpmKluOjkU2MMzyROJQESQlAHbFlQJDK
        KCkV4EqeO4cpQq0WnSU937b6thuhQf2E1CwX2dy/fFNewr75Ft4NL/VJftpOfIj8E3puak
        w+AO0/NJiLiDW2IUcThmkpodRcw6pW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-YM_DiuZvPb2ae_oT8K4kgA-1; Fri, 10 Sep 2021 12:06:38 -0400
X-MC-Unique: YM_DiuZvPb2ae_oT8K4kgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65C14101F000;
        Fri, 10 Sep 2021 16:06:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CB205C1A1;
        Fri, 10 Sep 2021 16:06:35 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: nVMX: Enlightened MSR Bitmap feature for Hyper-V on KVM
Date:   Fri, 10 Sep 2021 18:06:29 +0200
Message-Id: <20210910160633.451250-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Updating MSR bitmap for L2 is not cheap and rearly needed. TLFS for Hyper-V
offers 'Enlightened MSR Bitmap' feature which allows L1 hypervisor to
inform L0 when it changes MSR bitmap, this eliminates the need to examine
L1's MSR bitmap for L2 every time when 'real' MSR bitmap for L2 gets
constructed.

When the feature is enabled for Win10+WSL2, it shaves off around 700 CPU
cycles from a nested vmexit cost (tight cpuid loop test).

First patch of the series is unrelated to the newly implemented feature,
it fixes a bug in Enlightened MSR Bitmap usage when KVM runs as a nested
hypervisor on top of Hyper-V.

Vitaly Kuznetsov (4):
  KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
  KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
  KVM: nVMX: Track whether changes in L0 require MSR bitmap for L2 to be
    rebuilt
  KVM: nVMX: Implement Enlightened MSR Bitmap feature

 arch/x86/kvm/hyperv.c     |  2 ++
 arch/x86/kvm/vmx/nested.c | 28 +++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.c    | 41 ++++++++++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h    |  6 ++++++
 4 files changed, 61 insertions(+), 16 deletions(-)

-- 
2.31.1

