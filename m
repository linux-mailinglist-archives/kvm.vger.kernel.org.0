Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D1C355A20
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 19:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346842AbhDFRSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 13:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244425AbhDFRSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 13:18:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E329C06174A
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 10:18:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l132so8049519ybl.23
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 10:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oivDkQlUDQSvSEYmPed6OfkcBD+Dvdh/iwh7GoMJjX4=;
        b=ggRtauV+tbl//nJw9paxByj4LnhMRWjJS7yrReiQAs3GvtMi2oMAS3yC1IFT/CoHGe
         RbHKiJ1H2D6MEi7QYMNkil9+Aerk0FiECYeaBlD1QcAbi4iwn9qABTyT+fbass/ZEKZK
         3O42kT5OWCcSyNhlMLf8w3yu9VoxhzkZCASbdbh7Oux8hBaJRF3a1sV/BRnoro+fNLqL
         i4VaQRGWV/vRQ9Upp4+ARASsJyVGOZ+KYidRi4jgR08qmw6WiN5ol62J7MEE08WTqx5i
         tlJuZeYrMa/TcwXLNfLfk3XjGLKtoWUnYWpdeNyjNrxXxGTs90da8KmBkWR/SRjHyngM
         YnGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oivDkQlUDQSvSEYmPed6OfkcBD+Dvdh/iwh7GoMJjX4=;
        b=jskhY+gu7xns92h6jMmZYcuCojmEUkbed+XOGh+Vw+z7OvNtntMdGyt4EJdsoMiJJc
         hHFuOeojbTuxNDM6AmztaqgcW5b56Bi2VEHGnL8SpAN9TiBfODKfX2UdWuesB6yLKzAp
         7Y1pIksUWHgv3+K7PuTniyHYTl/G5zl11sFOpTTAdcE/LaMHFPJaVX8JNPO/I4Ol1gEc
         Tux353NurD5F4yYSHZPt9gYXm+miH2aBo32VayK32ph6Qd9jng2DCNNGmotRkwHtPdzh
         PU02BjNIxK2z22OLGhMCYdrZ4dZ/xvn3TNhCOlnc5kvorFCQyQ8GvJHCekgF0rjdSuHU
         jjVQ==
X-Gm-Message-State: AOAM530uaIy3DLPymnTsJtr/GqmVYYJk8iPjeHyURI+cGh9Q9ruB5eVN
        cTiAJGbLnWH+CQ+FDkeBgpuH539rbaE=
X-Google-Smtp-Source: ABdhPJy4XKdA8GBJ3EDloaxSOG3D2OJARqprhnA3IlBhScNJSqLb4bKe9aTcFxXnCIMiMduIFXARkNbXC8Q=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100d:: with SMTP id
 w13mr21865678ybt.489.1617729496367; Tue, 06 Apr 2021 10:18:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 10:18:08 -0700
In-Reply-To: <20210406171811.4043363-1-seanjc@google.com>
Message-Id: <20210406171811.4043363-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210406171811.4043363-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 1/4] KVM: SVM: Don't set current_vmcb->cpu when switching vmcb
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not update the new vmcb's last-run cpu when switching to a different
vmcb.  If the vCPU is migrated between its last run and a vmcb switch,
e.g. for nested VM-Exit, then setting the cpu without marking the vmcb
dirty will lead to KVM running the vCPU on a different physical cpu with
stale clean bit settings.

                          vcpu->cpu    current_vmcb->cpu    hardware
  pre_svm_run()           cpu0         cpu0                 cpu0,clean
  kvm_arch_vcpu_load()    cpu1         cpu0                 cpu0,clean
  svm_switch_vmcb()       cpu1         cpu1                 cpu0,clean
  pre_svm_run()           cpu1         cpu1                 kaboom

Simply delete the offending code; unlike VMX, which needs to update the
cpu at switch time due to the need to do VMPTRLD, SVM only cares about
which cpu last ran the vCPU.

Fixes: af18fa775d07 ("KVM: nSVM: Track the physical cpu of the vmcb vmrun through the vmcb")
Cc: Cathy Avery <cavery@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 48b396f33bee..89619cc52cf4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1311,14 +1311,6 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
 	svm->current_vmcb = target_vmcb;
 	svm->vmcb = target_vmcb->ptr;
 	svm->vmcb_pa = target_vmcb->pa;
-
-	/*
-	* Track the physical CPU the target_vmcb is running on
-	* in order to mark the VMCB dirty if the cpu changes at
-	* its next vmrun.
-	*/
-
-	svm->current_vmcb->cpu = svm->vcpu.cpu;
 }
 
 static int svm_create_vcpu(struct kvm_vcpu *vcpu)
-- 
2.31.0.208.g409f899ff0-goog

