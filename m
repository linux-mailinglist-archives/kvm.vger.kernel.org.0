Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA9C5352EF
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348422AbiEZRym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348399AbiEZRy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:54:26 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF5BA76EC
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:23 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t14-20020a65608e000000b003fa321e8ea3so1122000pgu.18
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Gl1ger3sfcviuQtEjEFpxedsk42UqwPOcwBSPpwDgrU=;
        b=fucrALtULyCr73H7V/AH9SnvOwGVx9HHpm5iyNovmetTQtgREZgxD+4w8eqnV4gfn+
         xftI2cBDekG3YFoRIfxuQyENTWfQMxB498jJ8f4i2yN8pHLiobFxCVR7sHPfb+UuyZOO
         OYJfLUZl+G+EAGlECaHo58kwZGC43X0jlIf03PF9V9gDe2OEUOdwd9I784uTojTJbmIT
         BZNMIIUqlhXjrB2QvB8AocVSl+lnC7LDI/PB0Zp1z3nk6dAR+RyISpDIFdXb+psDbxkN
         MSkCaJjWz4EumHXma4xy7MGPbXR9xII2n7y3KxNBZ0AANV1bJ2OUQBKsjW9JF+q7eRL8
         d/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Gl1ger3sfcviuQtEjEFpxedsk42UqwPOcwBSPpwDgrU=;
        b=KTU4daIL7Ej1icvURvqDlXDgVMFyepsFWQXf38whnsBXgFbAdp3+/7/WXIJmCMxBxQ
         WWn2L/x8ixGjAcY+SZ8ufspev8fzo5fI4YYj8iK+342u5ASpVmTegoYxmuxyfrG3vA8T
         dQmX0iKdrhp9P8XP47E8BR5BgmPsDoI6eQSr0401iW9Q2UO7TH2XtppN6ef+eTx840qH
         GIKqrUY2W00NgAZCwrdlopgldFNxEb/KwUTn0FCs+oZFDXEXxmcsbaeG+tHGldJ0TJnB
         WGdXC2zT0oCPUqIl3wDD15f9v5nJICwLNbBQK6mieZDgStZq9OYpnilubmkiPoRMiGgY
         Qbrg==
X-Gm-Message-State: AOAM530soMtyHZH7wLxTW2GfoGQidHUZgPebX50QKfTMpNqTJW1s8RQC
        aOOJ8ZZhNqOuTwwVsJHrZYs490OP/rjmI7weBR3uEkzsByN8b7piOuy1033CMQv7/8AGHE8//09
        dYqXGrI8awKYvTKXWlJFIeo3Ak6yAw7YK0zX+kjiRgIjsb2s1YDEk7nJzPMtL
X-Google-Smtp-Source: ABdhPJwfS8zuFF5ADj/NW82LmsBUkN5yDaJ+k3+6saKpjrVZOvgqnncdg9RnQRuQWYjSi4EU2ni3mLGwusvY
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90b:1bcc:b0:1e0:1c94:ebcf with SMTP id
 oa12-20020a17090b1bcc00b001e01c94ebcfmr3830455pjb.140.1653587663082; Thu, 26
 May 2022 10:54:23 -0700 (PDT)
Date:   Thu, 26 May 2022 17:54:04 +0000
In-Reply-To: <20220526175408.399718-1-bgardon@google.com>
Message-Id: <20220526175408.399718-8-bgardon@google.com>
Mime-Version: 1.0
References: <20220526175408.399718-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v8 07/11] KVM: x86: Fix errant brace in KVM capability handling
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The braces around the KVM_CAP_XSAVE2 block also surround the
KVM_CAP_PMU_CAPABILITY block, likely the result of a merge issue. Simply
move the curly brace back to where it belongs.

Fixes: ba7bb663f5547 ("KVM: x86: Provide per VM capability for disabling PMU virtualization")

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7460b9a77d9a..33653a008b28 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4414,10 +4414,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
+	}
 	case KVM_CAP_PMU_CAPABILITY:
 		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
 		break;
-	}
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = KVM_X86_VALID_QUIRKS;
 		break;
-- 
2.36.1.124.g0e6072fb45-goog

