Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A4F175A4D
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 13:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgCBMTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 07:19:41 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44062 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgCBMTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 07:19:41 -0500
Received: by mail-ed1-f66.google.com with SMTP id g19so13005657eds.11;
        Mon, 02 Mar 2020 04:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=G/f6M+HBAL4DqhW0c1p6bk4sytP2vYJy/i55zifn5Jk=;
        b=KXBL9v6wyp6mGHBavSEyUHPC7wdx5NE9+19vaHLaQPb6Ln6uPjQLYM6gkPhEIy7LbZ
         zjR/je8Rualwm5StcN/6KtHwZAygVAPkHHufletcymi5MBwT/JtvVTlBQWkvNxgSNWL2
         btjgci44eHkrXqZiKqqZfO3ukli+j6gc/3T8FBnUiWRVo+WqVppV/tJQt2sxxYp5C8oO
         3jbk8nBHvrTVAcYJUqq9YuKyNbzeBUpcgEnXMkj6sZGJDxshQ7fHBufzvj2RV5QUQezE
         YHZKOkuTpDhTfQjSOToHoFC6hMFj4FSPWJr3ByOOsOVQ2EN6obPxD0dSknI1n4UP2vZ7
         dF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=G/f6M+HBAL4DqhW0c1p6bk4sytP2vYJy/i55zifn5Jk=;
        b=UbMQ4oTzgR/gYkh++TPlHcpQnMnwV17CcgKRWhsJzehuYpZNlTYmDCWF7ru3I7KIZY
         njxb54aVV5NUaQo+O/dzGOwI0co68EUDsrKlqbiig6BqlMFBnULCeEwcZySXsHZdWI53
         rJbEt1kJCzN9rq/kA+IsO/DiWNQHFs8LuCNFtD+EtcE9ZU+I5bIsDcKfYqzaSq7dsb00
         JQCzVLBZsSCEfE5u/old56Hf3alvEImB0mYnIpK3Dm0drAgT491Oh7RZTmDG6LWxZfo8
         oX22uSGWo48HdqiVdCv+6iitKYTH62iigvEmZbSnDTqXPY0gBbKhElMgpBG/pVVqbuED
         hsMw==
X-Gm-Message-State: ANhLgQ1jAVYEDBUrzGkKxJE2+BT7/iv5Lb9CwhJreZDEwOj9mUicl+Os
        xThhA8oAPLsorpwBZnirz7DzF9woevK2sJyZs18+
X-Google-Smtp-Source: ADFU+vvc/UCNpbkJV2EIc9o+6JskdV54r70wFEAdITkyCL/3CMdTefLpyOzqHlscsZu6AjkA+qVd42CsAvWgIimb5x4=
X-Received: by 2002:a50:9f68:: with SMTP id b95mr770815edf.96.1583151579669;
 Mon, 02 Mar 2020 04:19:39 -0800 (PST)
MIME-Version: 1.0
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Mon, 2 Mar 2020 20:19:28 +0800
Message-ID: <CAB5KdOZwZUvgmHX5C53SBU0WttEF4wBFpgqiGahD2OkojQJZ-Q@mail.gmail.com>
Subject: [PATCH] KVM: SVM: Fix svm the vmexit error_code of WRMSR
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     hpa@zytor.com, bp@alien8.de, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "joro@8bytes.org" <joro@8bytes.org>, jmattson@google.com,
        wanpengli@tencent.com, "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 From 1f755f75dfd73ad7cabb0e0f43e9993dd9f69120 Mon Sep 17 00:00:00 2001
From: Haiwei Li <lihaiwei@tencent.com>
Date: Mon, 2 Mar 2020 19:19:59 +0800
Subject: [PATCH] KVM: SVM: Fix svm the vmexit error_code of WRMSR

In svm, exit_code of write_msr is not EXIT_REASON_MSR_WRITE which
belongs to vmx.

According to amd manual, SVM_EXIT_MSR(7ch) is the exit_code of VMEXIT_MSR
due to RDMSR or WRMSR access to protected MSR. Additionally, the processor
indicates in the VMCB's EXITINFO1 whether a RDMSR(EXITINFO1=0) or
WRMSR(EXITINFO1=1) was intercepted.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
  arch/x86/kvm/svm.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index fd3fc9f..ef71755 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6296,7 +6296,8 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu
*vcpu,
         enum exit_fastpath_completion *exit_fastpath)
  {
         if (!is_guest_mode(vcpu) &&
-               to_svm(vcpu)->vmcb->control.exit_code ==
EXIT_REASON_MSR_WRITE)
+               (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR) &&
+               (to_svm(vcpu)->vmcb->control.exit_info_1 & 1))
                 *exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
  }

--
1.8.3.1
