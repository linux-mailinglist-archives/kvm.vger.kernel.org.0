Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7F72B78F
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 16:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfE0Obq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 10:31:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbfE0Obq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 10:31:46 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A39CD3082211
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 14:31:46 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C6C460126;
        Mon, 27 May 2019 14:31:42 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, thuth@redhat.com,
        peterx@redhat.com
Subject: [PATCH v2 0/4] kvm: selftests: aarch64: use struct kvm_vcpu_init
Date:   Mon, 27 May 2019 16:31:37 +0200
Message-Id: <20190527143141.13883-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 27 May 2019 14:31:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

aarch64 vcpu setup requires a vcpu init step that takes a kvm_vcpu_init
struct. So far we've just hard coded that to be one that requests no
features and always uses KVM_ARM_TARGET_GENERIC_V8 for the target. We
should have used the preferred target from the beginning, so we do that
now, and we also provide an API to unit tests to select a target of their
choosing and/or cpu features.

Switching to the preferred target fixes running on platforms that don't
like KVM_ARM_TARGET_GENERIC_V8. The new API will be made use of with
some coming unit tests.

v2:
- rename vm_vcpu_add_memslots to vm_vcpu_add_with_memslots

Andrew Jones (4):
  kvm: selftests: rename vm_vcpu_add to vm_vcpu_add_with_memslots
  kvm: selftests: introduce vm_vcpu_add
  kvm: selftests: introduce aarch64_vcpu_setup
  kvm: selftests: introduce aarch64_vcpu_add_default

 .../selftests/kvm/include/aarch64/processor.h |  4 +++
 .../testing/selftests/kvm/include/kvm_util.h  |  5 +--
 .../selftests/kvm/lib/aarch64/processor.c     | 33 +++++++++++++++----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +++++++++++++---
 .../selftests/kvm/lib/x86_64/processor.c      |  2 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  2 +-
 .../kvm/x86_64/kvm_create_max_vcpus.c         |  2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |  2 +-
 .../testing/selftests/kvm/x86_64/state_test.c |  2 +-
 9 files changed, 63 insertions(+), 18 deletions(-)

-- 
2.20.1

