Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B47E26D882
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 12:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgIQKLH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 06:11:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726549AbgIQKLC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 06:11:02 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 06:11:02 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600337457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/Hhy9FvabiDG5Ek4mu3Z7RZKm3yT/cj4T3OHkyQ6r2k=;
        b=WZmVP78gT2lIEe51OK/Xs+zlV7Tt2d3PdAZKmUhcUSc1Abceuhzlwsz4c7vYfDXC7IFZRu
        jdrV0FJmL2/U39RNHGsFsZgkZcD+KnoBykj394qOvN58l9ciCGusPa6HhEk1XYybTcEyCE
        GyOVRnn5S4pYn2TxFzORJQNcQN1/8Q0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-1yKMiu0XOV2XoIf9IxiM3g-1; Thu, 17 Sep 2020 06:10:56 -0400
X-MC-Unique: 1yKMiu0XOV2XoIf9IxiM3g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BC6664085;
        Thu, 17 Sep 2020 10:10:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 954451000239;
        Thu, 17 Sep 2020 10:10:50 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 0/2] KVM: nSVM: ondemand nested state allocation
Date:   Thu, 17 Sep 2020 13:10:46 +0300
Message-Id: <20200917101048.739691-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is new version of ondemand nested state allocation.=0D
=0D
In this version I dropped the changes to set_efer and instead=0D
added a new request KVM_REQ_OUT_OF_MEMORY which makes the kvm=0D
exit to userspace with KVM_EXIT_INTERNAL_ERROR=0D
=0D
This request is used in (unlikely) case of memory allocation=0D
failure.=0D
=0D
Maxim Levitsky (2):=0D
  KVM: add request KVM_REQ_OUT_OF_MEMORY=0D
  KVM: nSVM: implement ondemand allocation of the nested state=0D
=0D
 arch/x86/kvm/svm/nested.c | 42 ++++++++++++++++++++++++++++++=0D
 arch/x86/kvm/svm/svm.c    | 54 ++++++++++++++++++++++-----------------=0D
 arch/x86/kvm/svm/svm.h    |  7 +++++=0D
 arch/x86/kvm/x86.c        |  7 +++++=0D
 include/linux/kvm_host.h  |  1 +=0D
 5 files changed, 87 insertions(+), 24 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

