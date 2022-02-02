Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0100A4A77B7
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 19:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346594AbiBBSSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 13:18:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346423AbiBBSST (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 13:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643825899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KZ6cXjJk9Pdh7+gNJjwwBF/cTV5ERwqcH25JkZ6mTHU=;
        b=BKS2rCeWUaMANA4PPkPP/M5/eFgmpFT+K1YWMDwJ3uEvIgFVP/qkPcFeExx2bR4rArdEhz
        AarqazJSofCVq5s2aHH4icYZnsY8yw+a7bieKyY1ia28TI1Oq/IN/skur5z51wwmJ4k14h
        57v/3wUcjeHi2qj+kRdY8RK9VTF6zbg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-bSOKndtiMlG64t8tVpQHQw-1; Wed, 02 Feb 2022 13:18:15 -0500
X-MC-Unique: bSOKndtiMlG64t8tVpQHQw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3DAE343CA;
        Wed,  2 Feb 2022 18:18:14 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4736877466;
        Wed,  2 Feb 2022 18:18:14 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 0/5] kvm: x86: better handling of NULL-able kvm_x86_ops
Date:   Wed,  2 Feb 2022 13:18:08 -0500
Message-Id: <20220202181813.1103496-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is really two changes:

- patch 1 to 4 clean up NULLable kvm_x86_ops so that they are marked
  in kvm-x86-ops.h and the non-NULLable ones WARN if used incorrectly.
  As an additional outcome of the review, a few more uses of
  static_call_cond are introduced.

- patch 5 allows to NULL a few kvm_x86_ops that return a value, by
  using __static_call_ret0.

Paolo Bonzini (5):
  KVM: x86: use static_call_cond for optional callbacks
  KVM: x86: mark NULL-able kvm_x86_ops
  KVM: x86: warn on incorrectly NULL static calls
  KVM: x86: change hwapic_{irr,isr}_update to NULLable calls
  KVM: x86: allow defining return-0 static calls

 arch/x86/include/asm/kvm-x86-ops.h | 45 +++++++++++++++---------------
 arch/x86/include/asm/kvm_host.h    |  9 ++++--
 arch/x86/kvm/lapic.c               | 22 ++++++---------
 arch/x86/kvm/svm/avic.c            | 13 ---------
 arch/x86/kvm/svm/svm.c             | 28 -------------------
 arch/x86/kvm/x86.c                 | 10 ++-----
 6 files changed, 41 insertions(+), 86 deletions(-)

-- 
2.31.1

