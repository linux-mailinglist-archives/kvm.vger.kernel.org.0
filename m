Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F30EA1A1054
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbgDGPht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 11:37:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35545 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729381AbgDGPht (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 11:37:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586273869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=x4CHFC9TOF2vCml2TedFLaM/BhVt2666Y7Zsy2uCISM=;
        b=LLSJBwwOMuMLNBnJGLDw3AZHp1QO2b7k/Um0+97jWjbw1sKFyR8tZI0vgOCueXIoW/yJBH
        Mj9nk/7bMfBHXd4EOy8cG05NbHS604fooMRpBEgROlWZ/I1Su9MaUQMsPa11Pe0zfXyo2N
        GYihDnuTSH6pMCNNAHT9YQCPZOacs24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-oDhq-eh8PCCpgKiXXtRKIQ-1; Tue, 07 Apr 2020 11:37:40 -0400
X-MC-Unique: oDhq-eh8PCCpgKiXXtRKIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 489448017CE;
        Tue,  7 Apr 2020 15:37:39 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-15.gru2.redhat.com [10.97.116.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA6A5272A6;
        Tue,  7 Apr 2020 15:37:32 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     drjones@redhat.com, david@redhat.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v3 0/2] selftests: kvm: Introduce the mem_slot_test test
Date:   Tue,  7 Apr 2020 12:37:29 -0300
Message-Id: <20200407153731.3236-1-wainersm@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series introduces a new KVM selftest (mem_slot_test) that goal
is to verify memory slots can be added up to the maximum allowed. An
extra slot is attempted which should occur on error.

The patch 01 is needed so that the VM fd can be accessed from the
test code (for the ioctl call attempting to add an extra slot).

I ran the test successfully on x86_64, aarch64, and s390x.  This
is why it is enabled to build on those arches.

- Changelog -

v2 -> v3:
 - Keep alphabetical order of .gitignore and Makefile [drjones]
 - Use memory region flags equals to zero [drjones]
 - Changed mmap() assert from 'mem != NULL' to 'mem != MAP_FAILED' [drjones]
 - kvm_region is declared along side other variables and malloc()'ed
   later [drjones]
 - Combined two asserts into a single 'ret == -1 && errno == EINVAL'
   [drjones]

v1 -> v2:
 - Rebased to queue
 - vm_get_fd() returns int instead of unsigned int (patch 01) [drjones]
 - Removed MEM_REG_FLAGS and GUEST_VM_MODE defines [drjones]
 - Replaced DEBUG() with pr_info() [drjones]
 - Calculate number of guest pages with vm_calc_num_guest_pages()
   [drjones]
 - Using memory region of 1 MB sized (matches mininum needed
   for s390x)
 - Removed the increment of guest_addr after the loop [drjones]
 - Added assert for the errno when adding a slot beyond-the-limit [drjones]
 - Prefer KVM_MEM_READONLY flag but on s390x it switch to KVM_MEM_LOG_DIRTY_PAGES,
   so ensure the coverage of both flags. Also somewhat tests the KVM_CAP_READONLY_MEM capability check [drjones]
 - Moved the test logic to test_add_max_slots(), this allows to more easily add new cases in the "suite".

v1: https://lore.kernel.org/kvm/20200330204310.21736-1-wainersm@redhat.com

Wainer dos Santos Moschetta (2):
  selftests: kvm: Add vm_get_fd() in kvm_util
  selftests: kvm: Add mem_slot_test test

 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  3 +
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  5 ++
 tools/testing/selftests/kvm/mem_slot_test.c   | 85 +++++++++++++++++++
 5 files changed, 95 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/mem_slot_test.c

-- 
2.17.2

