Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3550037F6DB
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 13:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbhEMLia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 07:38:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232342AbhEMLi2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 07:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620905838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uFzW4jQ7R2znAA/1j+DeYPq3FnZ8NbG7egg4F1SWsZ8=;
        b=VrDRCmWHRvNRVSk5JNPG9UXSb8KSI9oHwYi1AKwn51rWWjjRgajIaxYwDxN6bjRShE3aAq
        9WcCViLev2Im+oJNT5YTqonB2jIgIttr9vIdKReiRLpbsThy7G/A2TxgFDTyX2j3J3G2xc
        bGmKk5ucj41Kfsz7OL2c6CelWo5HviU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-ng8dP8LrN6CCgVo2NrGVJw-1; Thu, 13 May 2021 07:37:16 -0400
X-MC-Unique: ng8dP8LrN6CCgVo2NrGVJw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29DEC8015DB;
        Thu, 13 May 2021 11:37:15 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4C0E10016F8;
        Thu, 13 May 2021 11:37:11 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86: hyper-v: Conditionally allow SynIC with APICv/AVIC
Date:   Thu, 13 May 2021 13:37:08 +0200
Message-Id: <20210513113710.1740398-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
however, possible to track whether the feature was actually used by the
guest and only inhibit APICv/AVIC when needed.

The feature can be tested with QEMU's 'hv-passthrough' debug mode.

Note, 'avic' kvm-amd module parameter is '0' by default and thus needs to
be explicitly enabled.

Vitaly Kuznetsov (2):
  KVM: x86: Invert APICv/AVIC enablement check
  KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
    use

 arch/x86/include/asm/kvm_host.h |  5 ++++-
 arch/x86/kvm/hyperv.c           | 27 +++++++++++++++++++++------
 arch/x86/kvm/svm/svm.c          |  7 ++++++-
 arch/x86/kvm/vmx/vmx.c          |  7 ++++++-
 arch/x86/kvm/x86.c              |  6 +++---
 5 files changed, 40 insertions(+), 12 deletions(-)

-- 
2.31.1

