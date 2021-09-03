Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B46C400759
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 23:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbhICVRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 17:17:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232927AbhICVRG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 17:17:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630703764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SSIVNkVvm0gWqkOOU9lE9NsfPjtIigmPaRNK/vB50kw=;
        b=cxbsvNI87+u1Ot7ovcBiPq5GN29sR72njnOsOAxi/cxTCFYyItP7h48oroIzg5AtCHCWje
        JXHe8DeegbrFYb6ljIgdGGg2FA9Fqm5QtL03w9DvEZ4ZJTXmDCUSZ7uoIzvNWxC1HvK4Nt
        u7+2fS3AzF1tnLZ3K3RN6e9moTS3CCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-YMVRquaMO7izfGfEc77zmA-1; Fri, 03 Sep 2021 17:16:02 -0400
X-MC-Unique: YMVRquaMO7izfGfEc77zmA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC63784A5E0;
        Fri,  3 Sep 2021 21:16:01 +0000 (UTC)
Received: from localhost (unknown [10.22.8.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A2985C3DF;
        Fri,  3 Sep 2021 21:16:01 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Juergen Gross <jgross@suse.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2 0/3] kvm: x86: Set KVM_MAX_VCPUS=1024, KVM_SOFT_MAX_VCPUS=710
Date:   Fri,  3 Sep 2021 17:15:57 -0400
Message-Id: <20210903211600.2002377-1-ehabkost@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This:
- Increases KVM_MAX_VCPUS 288 to 1024.
- Increases KVM_MAX_VCPU_ID from 1023 to 4096.
- Increases KVM_SOFT_MAX_VCPUS from 240 to 710.

Note that this conflicts with:
  https://lore.kernel.org/lkml/20210903130808.30142-1-jgross@suse.com
  Date: Fri,  3 Sep 2021 15:08:01 +0200
  From: Juergen Gross <jgross@suse.com>
  Subject: [PATCH v2 0/6] x86/kvm: add boot parameters for max vcpu configs
  Message-Id: <20210903130808.30142-1-jgross@suse.com>

I don't intend to block Juergen's work.  I will be happy to
rebase and resubmit in case Juergen's series is merged first.
However, I do propose that we set the values above as the default
even if Juergen's series is merged.

The additional overhead (on x86_64) of the new defaults will be:
- struct kvm_ioapic will grow from 1628 to 5084 bytes.
- struct kvm will grow from 19328 to 22272 bytes.
- Bitmap stack variables that will grow:
- At kvm_hv_flush_tlb() & kvm_hv_send_ipi(),
  vp_bitmap[] and vcpu_bitmap[] will now be 128 bytes long
- vcpu_bitmap at bioapic_write_indirect() will be 128 bytes long
  once patch "KVM: x86: Fix stack-out-of-bounds memory access
  from ioapic_write_indirect()" is applied

Changes v1 -> v2:
* KVM_MAX_VCPUS is now 1024 (v1 set it to 710)
* KVM_MAX_VCPU_ID is now 4096 (v1 left it unchanged, at 1023)

v1 of this series was:

  https://lore.kernel.org/lkml/20210831204535.1594297-1-ehabkost@redhat.com
  Date: Tue, 31 Aug 2021 16:45:35 -0400
  From: Eduardo Habkost <ehabkost@redhat.com>
  Subject: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
  Message-Id: <20210831204535.1594297-1-ehabkost@redhat.com>

Eduardo Habkost (3):
  kvm: x86: Set KVM_MAX_VCPU_ID to 4*KVM_MAX_VCPUS
  kvm: x86: Increase MAX_VCPUS to 1024
  kvm: x86: Increase KVM_SOFT_MAX_VCPUS to 710

 arch/x86/include/asm/kvm_host.h | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

-- 
2.31.1

