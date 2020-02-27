Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09531724FD
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 18:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbgB0RXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 12:23:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35084 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728413AbgB0RXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 12:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582824216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Gjp4z4++70DlRdyoFwoW1wXA2SmQC4OgN2YnpC8FfY0=;
        b=MHBomGOoRD/7LgV8bXtFl/R7xjrs+mHM41goUid9xnXO5BJ7zAmRSpIQMG5ExCJsdAzF51
        2+lNohmhtf1NttgMNkCJQtZym/65ZuxgSG6/zKNHyjXrut4yuWUZOaXOz5QWteo5V4dCaM
        JQkPvyRYrGfOhWSEfPN2V87uEOrolxM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-MIUn5VExOQGbEy_dwFFG-A-1; Thu, 27 Feb 2020 12:23:32 -0500
X-MC-Unique: MIUn5VExOQGbEy_dwFFG-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73BA5800D54;
        Thu, 27 Feb 2020 17:23:30 +0000 (UTC)
Received: from millenium-falcon.redhat.com (unknown [10.36.118.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A13A1001B2C;
        Thu, 27 Feb 2020 17:23:23 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH 0/5] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
Date:   Thu, 27 Feb 2020 19:23:01 +0200
Message-Id: <20200227172306.21426-1-mgamal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When EPT/NPT is enabled, KVM does not really look at guest physical=20
address size. Address bits above maximum physical memory size are reserve=
d.=20
Because KVM does not look at these guest physical addresses, it currently=
=20
effectively supports guest physical address sizes equal to the host.

This can be problem when having a mixed setup of machines with 5-level pa=
ge=20
tables and machines with 4-level page tables, as live migration can chang=
e=20
MAXPHYADDR while the guest runs, which can theoretically introduce bugs.

In this patch series we add checks on guest physical addresses in EPT=20
violation/misconfig and NPF vmexits and if needed inject the proper=20
page faults in the guest.

A more subtle issue is when the host MAXPHYADDR is larger than that of th=
e
guest. Page faults caused by reserved bits on the guest won't cause an EP=
T
violation/NPF and hence we also check guest MAXPHYADDR and add PFERR_RSVD=
_MASK
error code to the page fault if needed.


Mohammed Gamal (5):
  KVM: x86: Add function to inject guest page fault with reserved bits
    set
  KVM: VMX: Add guest physical address check in EPT violation and
    misconfig
  KVM: SVM: Add guest physical address check in NPF interception
  KVM: x86: mmu: Move translate_gpa() to mmu.c
  KVM: x86: mmu: Add guest physical address check in translate_gpa()

 arch/x86/include/asm/kvm_host.h |  6 ------
 arch/x86/kvm/mmu/mmu.c          | 10 ++++++++++
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/svm.c              |  7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 13 +++++++++++++
 arch/x86/kvm/x86.c              | 14 ++++++++++++++
 arch/x86/kvm/x86.h              |  1 +
 7 files changed, 46 insertions(+), 7 deletions(-)

--=20
2.21.1

