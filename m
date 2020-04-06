Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7028D19FEDA
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 22:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDFUMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 16:12:43 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:50818 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFUMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 16:12:42 -0400
Received: by mail-qk1-f202.google.com with SMTP id r64so986243qkc.17
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 13:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=TyKWOeNND5wJuATkpa2E9J5zvrRDBHGDg+cfVXGKtTk=;
        b=oZOUUAfhEzkvoWmBJXx9XtTUiRVggmDaS8YdfJ3Fzyvu9S4HYABA4HIK9cabv51cbA
         XNKVS1BOBFRJuj5Rl86fVC6vOr4Y0HD5N56nf6g+EEeNRoZzeJ8mxpQ3NBme0Tqb7VJA
         pVVZ0A9/giiNvjY5J523YNGeSiRfoInR7OtkwCYjpmnx+XGd11NPw/VoR/ONNjPY0rkM
         ZJdezHexkC3rW87ne6s+74EIp8ni+y+/kpdnhw6hAiNIhXUowY8AL7805cMP7FhT0cgT
         8j4zVYrhu0HyVjJbNmB8JFdcro3o9PIRs0GvWCjXMKbnQCqYJqcIE8vmmhlkqlnHuOCS
         KB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=TyKWOeNND5wJuATkpa2E9J5zvrRDBHGDg+cfVXGKtTk=;
        b=p6BMGe20Vv79RPg7xrvuBU19EjxgP/gy1D5JN2LFq3w8Vf2f+r5Tdi+jR0qkC87YWg
         eSLVUkx+6wQMATbJ6yLjuHbjRWZNGc2ouKvXWj6O/BbUMcZAwG7IdYho6ItrNuMKgk+1
         utWNePm1zOFje7Qt9Xwa39XR9qTai90wZ539BAdm9yUeS7WPA/7q6LXpEufFvFtlt3Ib
         HWRW9i3sy8ThEh1EFNZPbVVuTkZ+2CRM2sK1xhKvZK8ZEHWWPKyZN6uWR9gv5GBtWJdD
         L/UWSTRjgjtJjepUOUuOZFDuQWj8LdxVLP8/PNcx58BTAJOq4p9tOfgG9wfktQ+W7Ydz
         tKBg==
X-Gm-Message-State: AGi0PuZshQRswABK4idxb7bn6bxSSyYQV0zk52WfobKm2d7abuYaHXT/
        tm7AnjGrGxbzOytEn87MbPGCo8TkjdmoquBtIoY+dZa3c74RUGGMOhxEvwcZe+VSrb3joU+zEbp
        xOhBLM2ezpqPgsrofg0SBdVX1WGcNpZfUrASxCCbOQq/r3CawrbytCLtMCA==
X-Google-Smtp-Source: APiQypLuYG/7i4JzWaOMGVvDpXG7J6qfwzi5kgORw7BeRgBqxiTsxpoALYFRGZ8tpfriHMPR2ICu3qDj0pE=
X-Received: by 2002:ad4:5586:: with SMTP id e6mr1576604qvx.65.1586203961474;
 Mon, 06 Apr 2020 13:12:41 -0700 (PDT)
Date:   Mon,  6 Apr 2020 20:12:37 +0000
Message-Id: <20200406201237.178725-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH] KVM: nVMX: don't clear mtf_pending when nested events are blocked
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If nested events are blocked, don't clear the mtf_pending flag to avoid
missing later delivery of the MTF VM-exit.

Fixes: 5ef8acbdd687c ("KVM: nVMX: Emulate MTF when performing instruction emulation")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index de232306561a0..cbc9ea2de28f9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3645,7 +3645,8 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * Clear the MTF state. If a higher priority VM-exit is delivered first,
 	 * this state is discarded.
 	 */
-	vmx->nested.mtf_pending = false;
+	if (!block_nested_events)
+		vmx->nested.mtf_pending = false;
 
 	if (lapic_in_kernel(vcpu) &&
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
-- 
2.26.0.292.g33ef6b2f38-goog

