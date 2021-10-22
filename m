Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3543437A06
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbhJVPip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:38:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233363AbhJVPio (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:38:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=N4QDGFQMHWohd/KdxIYekf+yDmyllljs4b87acPJcHQ=;
        b=f1uoCXwxt/TT/CDTJJYsBK2xhhHOtq/lDRbiCEtoJU/mGqk5lSXuwyLexBWkOEAvPKIQdh
        2/s60w6NrrnWRbLW2zj+XPDO3NqnotNd2IOcWbiNjCvQtF3tD2tx09znFutUoMZWRfSWP7
        NjW420vg+xA/wBYfMRhcnzaG0psaKQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-Z776zpvDO8OXDzNri2iRsg-1; Fri, 22 Oct 2021 11:36:23 -0400
X-MC-Unique: Z776zpvDO8OXDzNri2iRsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 083908042E1;
        Fri, 22 Oct 2021 15:36:22 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8928E60C04;
        Fri, 22 Oct 2021 15:36:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH v2 00/13] fixes and cleanups for string I/O emulation
Date:   Fri, 22 Oct 2021 11:36:03 -0400
Message-Id: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is split in two parts:

- patch 7 fixes a bug in string I/O emulation for SEV-ES, where
  the size of the GHCB buffer can exceed the size of vcpu->arch.pio_data.
  If that happens, we need to go over the GHCB buffer in multiple passes.
  There are some preliminary cleanups in patches 1/3/6 too.

- the other patches clean emulator_pio_in and emulator_pio_in_out.  The
  first changes (patches 2/3/5) are more localized; they make the final
  SEV code a little easier to follow, and they remove unnecessary
  function arguments so that it is clearer which functions consume
  vcpu->arch.pio and which don't.  Patches starting from 8 on, instead,
  remove all usage of vcpu->arch.pio unless a userspace KVM_EXIT_IO is
  required.  In the end, IN is split clearly into a function that
  (if needed) fills in vcpu->arch.pio, and one that is intended for
  completion callbacks and consumes it.

Tested by booting a SEV-ES guest and with "regular" kvm-unit-tests.

Paolo

Paolo Bonzini (13):
  KVM: SEV-ES: rename guest_ins_data to sev_pio_data
  KVM: x86: leave vcpu->arch.pio.count alone in emulator_pio_in_out
  KVM: SEV-ES: clean up kvm_sev_es_ins/outs
  KVM: x86: split the two parts of emulator_pio_in
  KVM: x86: remove unnecessary arguments from complete_emulator_pio_in
  KVM: SEV-ES: keep INS functions together
  KVM: SEV-ES: go over the sev_pio_data buffer in multiple passes if
    needed
  KVM: x86: inline kernel_pio into its sole caller
  KVM: x86: move all vcpu->arch.pio* setup in emulator_pio_in_out
  KVM: x86: wean in-kernel PIO from vcpu->arch.pio*
  KVM: x86: wean fast IN from emulator_pio_in
  KVM: x86: de-underscorify __emulator_pio_in
  KVM: SEV-ES: reuse advance_sev_es_emulated_ins for OUT too

 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/trace.h            |   2 +-
 arch/x86/kvm/x86.c              | 193 +++++++++++++++++++-------------
 3 files changed, 117 insertions(+), 81 deletions(-)

-- 
2.27.0

