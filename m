Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B216D31EE42
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhBRS2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:28:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233597AbhBRQaE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 11:30:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613665718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7n6Dv7TL968Ih5U8eggCJpLl9IZAG+GVZ7m57WR0dUw=;
        b=bQ7RmRx+usdoqvOCdNeSof+U2ghbPa9y+E2FJG9WRHBU/HTpOlq+ZPAWgavst/D5vkr/lH
        BH+Uu3/rfbqfUHADrrDGQG6gtIcEMopuygy7sG9D+QIBMfeuHMEhTgYKDyZwrNtIOAqMlE
        XRNjP4adfwikJarjzCqWxGkoo+eCnBE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-NcuK9xVoObOOMUB8lotdwA-1; Thu, 18 Feb 2021 11:28:34 -0500
X-MC-Unique: NcuK9xVoObOOMUB8lotdwA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71EC980196C;
        Thu, 18 Feb 2021 16:28:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC39C5C1C4;
        Thu, 18 Feb 2021 16:28:31 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jroedel@suse.de, seanjc@google.com, mlevitsk@redhat.com
Subject: [PATCH] KVM: nSVM: prepare guest save area while is_guest_mode is true
Date:   Thu, 18 Feb 2021 11:28:31 -0500
Message-Id: <20210218162831.1407616-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, enter_svm_guest_mode is calling nested_prepare_vmcb_save and
nested_prepare_vmcb_control.  This results in is_guest_mode being false
until the end of nested_prepare_vmcb_control.

This is a problem because nested_prepare_vmcb_save can in turn cause
changes to the intercepts and these have to be applied to the "host VMCB"
(stored in svm->nested.hsave) and then merged with the VMCB12 intercepts
into svm->vmcb.

In particular, without this change we forget to set the CR0 read and CR0
write intercepts when running a real mode L2 guest with NPT disabled.
The guest is therefore able to see the CR0.PG bit that KVM sets to
enable "paged real mode".  This patch fixes the svm.flat mode_switch
test case with npt=0.  There are no other problematic calls in
nested_prepare_vmcb_save.

The bug is present since commit 06fc7772690d ("KVM: SVM: Activate nested
state only when guest state is complete", 2010-04-25).  Unfortunately,
it is not clear from the commit message what issue exactly led to the
change back then.  It was probably related to svm_set_cr0 however because
the patch series cover letter[1] mentioned lazy FPU switching.

[1] https://lore.kernel.org/kvm/1266493115-28386-1-git-send-email-joerg.roedel@amd.com/

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 92d3aaaac612..35891d9a1099 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -469,8 +469,8 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
 
 	svm->nested.vmcb12_gpa = vmcb12_gpa;
 	load_nested_vmcb_control(svm, &vmcb12->control);
-	nested_prepare_vmcb_save(svm, vmcb12);
 	nested_prepare_vmcb_control(svm);
+	nested_prepare_vmcb_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
 				  nested_npt_enabled(svm));
-- 
2.26.2

