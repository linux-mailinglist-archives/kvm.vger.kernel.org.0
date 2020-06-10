Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BDC1F5654
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 15:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgFJN7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 09:59:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33098 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726316AbgFJN67 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 09:58:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591797538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+xK1FKusim+ilFQ1Wb/m7cl9km13yzEUJrwXMyQvZtM=;
        b=A0ewlUM4IgzNdN79RWh2br9hjH4eOUeFl6S8FsOMMhG5RuPIU9v1bWcumrn228YgSnDQ6J
        yHEUtnqLJkhqqyppxC0kC4L2J3UWW4r+WeVb8k/rLdJ/Hp+J954kLTo6KbS2UZejP/D7jY
        MAPopu1T7w//ZgjcbEAE+pZpFMZnxcg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-ZyrC7x46PaucaFZt8eaF4A-1; Wed, 10 Jun 2020 09:58:55 -0400
X-MC-Unique: ZyrC7x46PaucaFZt8eaF4A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01680100A614;
        Wed, 10 Jun 2020 13:58:53 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AE3D5C1BD;
        Wed, 10 Jun 2020 13:58:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: selftests: avoid test failures with 'nested=0'
Date:   Wed, 10 Jun 2020 15:58:45 +0200
Message-Id: <20200610135847.754289-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 33b22172452f ("KVM: x86: move nested-related kvm_x86_ops to a
separate struct") made nested hooks (e.g. ->get_state(), ->enable_evmcs())
always available, even when kvm module is loaded with 'nested=0'. Assuming
the change was intentional, update selftests to not fail in this situation.

Vitaly Kuznetsov (2):
  KVM: selftests: do not substitute SVM/VMX check with
    KVM_CAP_NESTED_STATE check
  KVM: selftests: Don't probe KVM_CAP_HYPERV_ENLIGHTENED_VMCS when
    nested VMX is unsupported

 .../testing/selftests/kvm/include/x86_64/svm_util.h |  1 +
 tools/testing/selftests/kvm/include/x86_64/vmx.h    |  1 +
 tools/testing/selftests/kvm/lib/x86_64/svm.c        | 10 +++++++---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c        |  9 +++++++--
 tools/testing/selftests/kvm/x86_64/evmcs_test.c     |  5 +++--
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c   |  3 ++-
 tools/testing/selftests/kvm/x86_64/smm_test.c       | 13 +++++++------
 tools/testing/selftests/kvm/x86_64/state_test.c     | 13 +++++++------
 8 files changed, 35 insertions(+), 20 deletions(-)

-- 
2.25.4

