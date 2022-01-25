Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3D549BE4D
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 23:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiAYWRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 17:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbiAYWR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 17:17:28 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF4AC06173B
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 14:17:27 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id m200-20020a628cd1000000b004c7473d8cb5so7256914pfd.5
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 14:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=/+v2uJEC9GW92ygJxqjTBrbdhjHIHPQE/KKmpBU8lZ0=;
        b=lYn13ORlI48oTAmm5CYnegV5CmPcOEoLSRCO6F7G9up/wWyP0hKgg6VvkxRQeiE6vB
         XciD6v7qLn1zQDzNBJmOoDTEJ60u771EfrfzDghGgsMzCIgEDu/56L9n1xBOy9W73fnK
         UwhGd78JmY3CbZVOC6TrOyeD1JxhKntoY4B3yBbHt9seeKevzf54DqyjsgwWQ5kvvWvD
         kngOZWiv9M/SffHdxNsbR47MVCoAyeokZgN4l9tFTllQ5U/Ip4Eo1sdnfwdKq65QWSuB
         xJbkfAJxzl1hZo7b8w6bNRyIzh0BZaOPrkSqDVhDa2iB8RVKxp/VPvwkfDVhWBFpVXn/
         NlVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=/+v2uJEC9GW92ygJxqjTBrbdhjHIHPQE/KKmpBU8lZ0=;
        b=YZ/r6yVpesLiM5fzMI4au5w8Gjob/8TVhNiaTzVRsxLa7lwKP2MLZfM7k2YzN/kg/r
         VMNzPHcysJ1w/5njNdJ8x2vpPWBZd89dDHznTnFZZ1jpxk/wDkfWogsDyeltEz9nppx+
         XPXTy9ewMlDQDDhlpAObPoM89o9GnUcO6rijbzRMZ5Wi7o+5vPAiP28/oVaHNZl+cF8n
         nEY3yzLyLmZnNkU+KhMvDmpt5APkz8wdhBT6waI18jWPiSzLsqk8xNDgH3x74En0JJzB
         VOXP/5TfFfIh/3qartcDfHs1msVwrZ3wDFxX5YgpjGyvKn78LuaWq4kniQUPLztsAfEi
         4tNw==
X-Gm-Message-State: AOAM530jwE+TfzM5Ad7UnbuiyI6uOP7HhkwOIceT4Lp2buNcgkOR00nB
        JLw9y4lO83UZZG6BFa5RIPdlgJItI8Y=
X-Google-Smtp-Source: ABdhPJyXSBHupuR6L+QWJ2moUDGC1Jp8OBVYsb8BNa//eG7RdCOYo9cgmlA2seVPcwvWxRfLRIJsEtxeJRM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:3142:0:b0:4c3:a26a:331b with SMTP id
 x63-20020a623142000000b004c3a26a331bmr20395184pfx.21.1643149047175; Tue, 25
 Jan 2022 14:17:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 25 Jan 2022 22:17:25 +0000
Message-Id: <20220125221725.2101126-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH] KVM: selftests: Don't skip L2's VMCALL in SMM test for SVM guest
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't skip the vmcall() in l2_guest_code() prior to re-entering L2, doing
so will result in L2 running to completion, popping '0' off the stack for
RET, jumping to address '0', and ultimately dying with a triple fault
shutdown.

It's not at all obvious why the test re-enters L2 and re-executes VMCALL,
but presumably it serves a purpose.  The VMX path doesn't skip vmcall(),
and the test can't possibly have passed on SVM, so just do what VMX does.

Fixes: d951b2210c1a ("KVM: selftests: smm_test: Test SMM enter from L2")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/smm_test.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 2da8eb8e2d96..a626d40fdb48 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -105,7 +105,6 @@ static void guest_code(void *arg)
 
 		if (cpu_has_svm()) {
 			run_guest(svm->vmcb, svm->vmcb_gpa);
-			svm->vmcb->save.rip += 3;
 			run_guest(svm->vmcb, svm->vmcb_gpa);
 		} else {
 			vmlaunch();

base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4
-- 
2.35.0.rc0.227.g00780c9af4-goog

