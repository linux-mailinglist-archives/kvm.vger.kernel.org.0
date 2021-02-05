Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11063310940
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 11:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhBEKhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 05:37:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59058 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231423AbhBEKed (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 05:34:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612521186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3tCYr3yMCBn+1cr68bRRYsOLCo+XUlob/DqSt8WXr5I=;
        b=S1nbpEuYHgYpadquIrn/t8xWqUexL+mg8J22W841dAA9R7Dg5QRqZPLryu+2geV8ZCAFLP
        RfQJSjjycrO9lU1ChOXjtHzixt5SWyH0xp3HQvp4FlQoDP+dT2HIyluAWR0wYKYoCge76f
        ekhWTUH0D87Y1EhYE4hj86ck3GJ7Rt8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-O305z5ggNiaNLlETfouo-Q-1; Fri, 05 Feb 2021 05:33:02 -0500
X-MC-Unique: O305z5ggNiaNLlETfouo-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE16C107ACF8;
        Fri,  5 Feb 2021 10:33:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C20919D9F;
        Fri,  5 Feb 2021 10:33:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jgg@ziepe.ca, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        dan.j.williams@intel.com
Subject: [PATCH 0/2] KVM: do not assume PTE is writable after follow_pfn
Date:   Fri,  5 Feb 2021 05:32:57 -0500
Message-Id: <20210205103259.42866-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is the first step towards fixing KVM's usage of follow_pfn.
The immediate fix here is that KVM is not checking the writability of
the PFN, which actually dates back to way before the introduction of
follow_pfn in commit add6a0cd1c5b ("KVM: MMU: try to fix up page faults
before giving up", 2016-07-05).  There are more changes needed to
invalidate gfn-to-pfn caches from MMU notifiers, but this issue will
be tackled later.

A more fundamental issue however is that the follow_pfn function is
basically impossible to use correctly.  Almost all users for example
are assuming that the page is writable; KVM was not alone in this
mistake.  follow_pte, despite not being exported for modules, is a
far saner API.  Therefore, patch 1 simplifies follow_pte a bit and
makes it available to modules.

Please review and possibly ack for inclusion in the KVM tree,
thanks!

Paolo


Paolo Bonzini (2):
  mm: provide a sane PTE walking API for modules
  KVM: do not assume PTE is writable after follow_pfn

 arch/s390/pci/pci_mmio.c |  2 +-
 fs/dax.c                 |  5 +++--
 include/linux/mm.h       |  6 ++++--
 mm/memory.c              | 35 ++++++++++++++++++++++++++++++-----
 virt/kvm/kvm_main.c      | 15 ++++++++++++---
 5 files changed, 50 insertions(+), 13 deletions(-)

-- 
2.26.2

