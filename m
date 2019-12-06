Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32AB1157CD
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 20:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfLFTcO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 14:32:14 -0500
Received: from mail-vk1-f201.google.com ([209.85.221.201]:52560 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfLFTcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 14:32:14 -0500
Received: by mail-vk1-f201.google.com with SMTP id m25so3444457vko.19
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 11:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qyhICE/ZtsEAMoLVwH8/EamejrwLF/pI/nmxVL5Kj9A=;
        b=cFdRGHH9Onag9onWjmy46nTOYuiVo9113UiXx8+4Qw+ipTWXzHb7jnV5XnLvwWtVFb
         9GYyeW5x81SulLSHXjg3lGA9+3fpdSJryJ4aldek8vN4ebmzEySU8rrVKyqBDpslPimq
         h11E/9IbmGZreuzfUechAlkpm2gr1a5GXQUYPhcwWP3neq+DKE2/QVKJVHw2VTyOuJvj
         rOWEhH+D52JWYIA65cUqOwY9NBS85aPgcmcgEaMeIACouzIqzehjaRWwTJBT7fFZzexB
         buKuIKwEEymNSH8jAqsfHmw8TggzuGFOVGVVTTIxs7sFe/PpKvwsfF0RYbeb2z4FUYT/
         g2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qyhICE/ZtsEAMoLVwH8/EamejrwLF/pI/nmxVL5Kj9A=;
        b=OWv8iNb4lNdcR0dXglgrsed2LJyLKI0AtSBcqrV2LGDVRnfn9fySX62Z5CXU72J0ai
         cXDN/CFnX1KoeLmoJAdfzFWU2+lOLY++Qu4ZGyVthTK5/zDrxz7hqlaszYKJczZmcETK
         VHHS1by5gLk/Jc1aky1cnyW+fM1+1PRhZo3shKaOZn7NFLkhfvjdSVfq0XTY6pyU9up4
         l9w7JgJ5i+6hW6k1zMdTBKwtVOzB/YC8pF6N2QzLVlRsLjAXKrduXzVY2n/ZwQjDTn3y
         zX3Be2+iBeSuJlztrIfsykS9jHj1/gc44W83cE9i2hBdZuleCUXavdzeXOSxdcBIerOQ
         Kd4Q==
X-Gm-Message-State: APjAAAUc2J6vk0ED5C+NHJlvdSqBxm5FbvrLGDgmliS8eDPqiWIK3rKz
        gbnVkPC9QbwKOYuoD5mgpPgTW3t7TMwrbtqrfQXdLdmuVtLi+MSw4TTojux8fxWzpDyu8ME2qPy
        giYfw7ShDBq4Xxu6rZjNnBArL0HugGaDN5JuN84/Sau1RWnmeu1vfw2BaDBVAq8I=
X-Google-Smtp-Source: APXvYqx1T3nviQI+EtuzKktVshDJcEvHM4sIvCiGBBG9IPJxDyqoEhF9PEwDUqClU4dBtOjl03qQfeg+zXUZpg==
X-Received: by 2002:a67:fb58:: with SMTP id e24mr11198991vsr.55.1575660731307;
 Fri, 06 Dec 2019 11:32:11 -0800 (PST)
Date:   Fri,  6 Dec 2019 11:31:43 -0800
In-Reply-To: <20191206193144.33209-1-jmattson@google.com>
Message-Id: <20191206193144.33209-2-jmattson@google.com>
Mime-Version: 1.0
References: <20191206193144.33209-1-jmattson@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v2 2/3] kvm: nVMX: VMWRITE checks unsupported field before
 read-only field
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jon Cargille <jcargill@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the SDM, VMWRITE checks to see if the secondary source
operand corresponds to an unsupported VMCS field before it checks to
see if the secondary source operand corresponds to a VM-exit
information field and the processor does not support writing to
VM-exit information fields.

Fixes: 49f705c5324aa ("KVM: nVMX: Implement VMREAD and VMWRITE")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jon Cargille <jcargill@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ee1bf9710e86..94ec089d6d1a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4883,6 +4883,12 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 
 
 	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+
+	offset = vmcs_field_to_offset(field);
+	if (offset < 0)
+		return nested_vmx_failValid(vcpu,
+			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+
 	/*
 	 * If the vCPU supports "VMWRITE to any supported field in the
 	 * VMCS," then the "read-only" fields are actually read/write.
@@ -4899,11 +4905,6 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field))
 		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
-	offset = vmcs_field_to_offset(field);
-	if (offset < 0)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
-
 	/*
 	 * Some Intel CPUs intentionally drop the reserved bits of the AR byte
 	 * fields on VMWRITE.  Emulate this behavior to ensure consistent KVM
-- 
2.24.0.393.g34dc348eaf-goog

