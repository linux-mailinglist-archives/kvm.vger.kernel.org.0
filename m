Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611CF367172
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 19:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244768AbhDURh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 13:37:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234882AbhDURhz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 13:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619026642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mZ151TioPJVlWCYFd+WMRoWzUWYENr1Mw5ggyRpzHCc=;
        b=LwRJXXownLQMT0O+jrgTGZNc067WoEvvV9qU3Xm0/WfsmUSLbIgy0ldZF0BxjA0Fz6iLYE
        38dg/gi28qSLNWrG/n58RG5l+KU4cP0/v8/occIyURbY33RrfaN34aCrSv3UTvsZ5PlkBn
        qdqWI6rAGrx5XxZgqqFASeV4AQXgfzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-Ty8iWhTANKK8fF6jVl_Z_A-1; Wed, 21 Apr 2021 13:37:20 -0400
X-MC-Unique: Ty8iWhTANKK8fF6jVl_Z_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 127F818B9ECA;
        Wed, 21 Apr 2021 17:37:18 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61E7A1001B2C;
        Wed, 21 Apr 2021 17:37:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, srutherford@google.com, joro@8bytes.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        venu.busireddy@oracle.com
Subject: [PATCH v2 0/2] KVM: x86: guest interface for SEV live migration
Date:   Wed, 21 Apr 2021 13:37:14 -0400
Message-Id: <20210421173716.1577745-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a reviewed version of the guest interface (hypercall+MSR)
for SEV live migration.  The differences lie mostly in the API
for userspace.  In particular:

- the CPUID feature is not exposed in KVM_GET_SUPPORTED_CPUID

- the hypercall must be enabled manually with KVM_ENABLE_CAP

- the MSR has sensible behavior if not filtered (reads as zero,
  writes must leave undefined bits as zero or they #GP)

v1->v2: reviewed KVM_CAP_EXIT_HYPERCALL semantics,
	split CPUID bits so that the migration control MSR
	can be used for TDX

Ashish Kalra (1):
  KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall

Paolo Bonzini (1):
  KVM: x86: add MSR_KVM_MIGRATION_CONTROL

 Documentation/virt/kvm/api.rst        | 19 ++++++++++
 Documentation/virt/kvm/cpuid.rst      |  9 +++++
 Documentation/virt/kvm/hypercalls.rst | 15 ++++++++
 Documentation/virt/kvm/msr.rst        | 10 ++++++
 arch/x86/include/asm/kvm_host.h       |  2 ++
 arch/x86/include/uapi/asm/kvm_para.h  |  5 +++
 arch/x86/kvm/cpuid.c                  |  3 +-
 arch/x86/kvm/x86.c                    | 50 +++++++++++++++++++++++++++
 include/uapi/linux/kvm.h              |  1 +
 include/uapi/linux/kvm_para.h         |  1 +
 10 files changed, 114 insertions(+), 1 deletion(-)

-- 
2.26.2

