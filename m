Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9C5459940
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhKWAqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 19:46:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229619AbhKWAqX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 19:46:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637628196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AVxr2xCL/l1MkBneMfhrO2vUcrrfpsi5NQH6MFNTUzo=;
        b=iRnxxP7oRa2FqbMt7JWZTKpjcJ66tXa3uMXroRwLYgAc3sXOCKfCPtgUVVJiOMJ5jZzfej
        aRNN+0+uLT2ZPbWqjhVmKZbZIgfPqZk9d9bBc1NHP5S+Y3jJw+vuow7dD6mCxLE8OT++ys
        n9Owx9Ohldgqjy3p2COJ5AuX1OZDWys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-VV5k1cRKNVKKzTJ_SserJQ-1; Mon, 22 Nov 2021 19:43:12 -0500
X-MC-Unique: VV5k1cRKNVKKzTJ_SserJQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B568A0CAB;
        Tue, 23 Nov 2021 00:43:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AE3B56A93;
        Tue, 23 Nov 2021 00:43:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 0/4] KVM: VMX: process posted interrupts on APICv-disable vCPUs
Date:   Mon, 22 Nov 2021 19:43:07 -0500
Message-Id: <20211123004311.2954158-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The fixed version of the patches from last week.  To sum up, the issue
is the following.

Now that APICv can be disabled per-CPU (depending on whether it has some
setup that is incompatible) we need to deal with guests having a mix of
vCPUs with enabled/disabled posted interrupts.  For assigned devices,
their posted interrupt configuration must be the same across the whole
VM, so handle posted interrupts by hand on vCPUs with disabled posted
interrupts.

Patches 1-3 handle the regular posted interrupt vector, while patch 4
handles the wakeup vector.

Paolo Bonzini (4):
  KVM: x86: ignore APICv if LAPIC is not enabled
  KVM: VMX: prepare sync_pir_to_irr for running with APICv disabled
  KVM: x86: check PIR even for vCPUs with disabled APICv
  KVM: x86: Use a stable condition around all VT-d PI paths

 arch/x86/kvm/lapic.c           |  2 +-
 arch/x86/kvm/svm/svm.c         |  1 -
 arch/x86/kvm/vmx/posted_intr.c | 20 ++++++++++---------
 arch/x86/kvm/vmx/vmx.c         | 35 ++++++++++++++++++++++------------
 arch/x86/kvm/x86.c             | 18 ++++++++---------
 5 files changed, 44 insertions(+), 32 deletions(-)

-- 
2.27.0

