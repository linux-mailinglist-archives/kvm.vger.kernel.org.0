Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6E240F84C
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 14:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244208AbhIQMwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 08:52:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234111AbhIQMwG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 08:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631883043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WxWLEKn1ue95t53L74j0yPmGdXY5xsCCO/BiwvJrdqA=;
        b=fvAek/DSO5gGfsHGSRfTl18JWchSTvOcvXISnoqfZ69y6O7HjiFZSdKexhCaCoVSpF9v/2
        +lcGmgREWERngrQYn4WiEeoexDh3oVxy4VLCFx+jaoeQ3Uj2RaA6/BePOKcc+zNIX/hviV
        DekyIIwtmDBnzDJCsF9ZDUYXLxGgegI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-y8DVo9IYNIOkCCnl43prUw-1; Fri, 17 Sep 2021 08:50:42 -0400
X-MC-Unique: y8DVo9IYNIOkCCnl43prUw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1177F196632F;
        Fri, 17 Sep 2021 12:50:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB8DF60C2B;
        Fri, 17 Sep 2021 12:50:38 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 0/2] KVM: nSVM: use vmcb_ctrl_area_cached instead
Date:   Fri, 17 Sep 2021 08:49:54 -0400
Message-Id: <20210917124956.2042052-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to what is being done for svm save area in the nested
state (svm->nested.save), svm->nested.ctl contains some fields
that are not used. This introduces the possibility of passing
around uninitialized values, producing unnecessary bugs.

RFC: changing svm->nested.ctl however means that all functions
called with svm->nested.ctl or a normal vmcb control area
struct will need to be modified to handle the new struct. 
This is the case of vmcb_is_intercept(), which results in an
additional function definition. And this looks a little bit ugly IMO.
Therefore, the aim of this serie is to gather feedback to see
if there is a better way to change svm->nested.ctl
or if it's even worth doing it.

Based-on: <20210917120329.2013766-1-eesposit@redhat.com>
Suggested-by: Maxim Levitsky <mlevitsk@redhat.com> 
Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

Emanuele Giuseppe Esposito (2):
  nSVM: introduce struct vmcb_ctrl_area_cached
  nSVM: use vmcb_ctrl_area_cached instead of vmcb_control_area in
    svm_nested_state

 arch/x86/kvm/svm/nested.c | 74 +++++++++++++++++++++++++++++----------
 arch/x86/kvm/svm/svm.c    |  4 +--
 arch/x86/kvm/svm/svm.h    | 39 ++++++++++++++++++---
 3 files changed, 93 insertions(+), 24 deletions(-)

-- 
2.27.0

