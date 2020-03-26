Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA1F193BF2
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 10:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgCZJfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 05:35:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:57338 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbgCZJfV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 05:35:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585215320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=mHAcO/esGjuXCW34/CgY8eM7k2k6/5G4mIqIMAwoOLc=;
        b=gE1vAYe7wK+kZ457Ib0lsYm57apQEoNqzD1Ix0rkfa3EHopQrzIA3Tl+VaSuqJvRF3X5x/
        v2I3DeC7SCTSvUDXayW/cna8p8Ss4poDaMM+HUgZL3emMpxKqXNPSN9/BTn9Avq73VF3jP
        en7fnrKJNAKchyiSzw1EsI7h1Qk2flY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-U5kOa6KsMQy72PQznZ-5Kg-1; Thu, 26 Mar 2020 05:35:18 -0400
X-MC-Unique: U5kOa6KsMQy72PQznZ-5Kg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9ABB801E53;
        Thu, 26 Mar 2020 09:35:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA7A49CA3;
        Thu, 26 Mar 2020 09:35:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 0/3] KVM: x86: sync SPTEs on page/EPT fault injection
Date:   Thu, 26 Mar 2020 05:35:13 -0400
Message-Id: <20200326093516.24215-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is my take on Junaid and Sean's patch, from the TLB cleanup series.
It passes initial tests, including my usual guest installation and
kvm-unit-tests battery (with both ept=0 and ept=1), but I'm not sure if
there's anything that isn't covered by kvm-unit-tests, especially for
nested.  I have not yet run guest installation tests under nested
virt but I will before merging the whole TLB cleanup series.

Please review!

Junaid Shahid (1):
  KVM: x86: Sync SPTEs when injecting page/EPT fault into L1

Paolo Bonzini (2):
  KVM: x86: introduce kvm_mmu_invalidate_gva
  KVM: x86: cleanup kvm_inject_emulated_page_fault

 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/mmu/mmu.c          | 77 +++++++++++++++++++--------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/vmx/nested.c       | 12 ++---
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              | 16 +++++--
 6 files changed, 67 insertions(+), 44 deletions(-)

-- 
2.18.2

