Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BDE18FD81
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 20:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgCWTUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 15:20:06 -0400
Received: from mail-qv1-f74.google.com ([209.85.219.74]:56873 "EHLO
        mail-qv1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbgCWTUG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 15:20:06 -0400
Received: by mail-qv1-f74.google.com with SMTP id ee5so13664597qvb.23
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 12:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EuEgHEvOOlLZGILEOt39luhrShhjhA+dXySCvlN5S/w=;
        b=frWZZr05u+jNrEcB3GH0499Ea350wyE93JmIJPfup0N2Iea+YPd3q6/qiz0WC7FuIP
         WBoyPuMVzyQ4O0/YDSAKhAYkgwpj2nq/kGj7IXWW8nzOpSAWmDkEmkHZBHhOdIb7x4pd
         qlvurUUNUqAF0ALylfTDWTBWNPTw17zbfsbVbCkiBao+3wRoTcRnmjsmmCReJ48hIwth
         B68OT7qccAkZcNrdsb1H/LUCmoznz/xEpUxBHTQXSMH4jktAFRqwWvBTNfrNypJtUtaF
         YcA+zNaafJAhGeMyIFSuEJaN92/9bAes2ovUyOw85AoB7NNsikFkTqC7SY5py2h97KEV
         vWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EuEgHEvOOlLZGILEOt39luhrShhjhA+dXySCvlN5S/w=;
        b=atIe8vZNk1mTXfLkx2xgX4sKQTNFeuyHHTsJ2QOx2xJs3w57czyHeV1fHM0nbOnzj1
         JrDgkmYyTZ+o+SYCFwkWy1+nw3jXHKMBPXOod152Dk4IMWFlrRooTGPgd1MWhvJ7EXxT
         Ox+mGLjqJzPNeIfl/XPH08jAS94lWFU7nBi/xg/jMlIQjfEcwz4V1lp4rpfZjMIr3izA
         VcAjiIQ1wYZIGsR+sdt/GfbhNUjA6sz+2WWShVwztSlhR6B5WOiMYVlPtHrmeTIFOXAM
         LG8rz7Gba8KKWyfDPBeIR6ksvA0op5h+XrCAIDS0kkYjQn52b1Xb+Q8uSUf4/RKtEwDJ
         uARw==
X-Gm-Message-State: ANhLgQ1Cb6t66na2xMAsPwig0lxKrIn8qTsV+wG64cEmhlOQknQNFcNc
        pLW+0QxYbs4YOrelBuWa3/WIlpuiVO08dN1nTqM=
X-Google-Smtp-Source: ADFU+vvHiSEJBBT42wVNqrw/x1QVUgfHCyw0l5oYHfNcWj0WqOy/M8fE1DC3Ojv4iFuGiQeAk5S8n+b6TA1pOtTBh1A=
X-Received: by 2002:a0c:fd85:: with SMTP id p5mr6095302qvr.205.1584991205290;
 Mon, 23 Mar 2020 12:20:05 -0700 (PDT)
Date:   Mon, 23 Mar 2020 12:12:43 -0700
In-Reply-To: <CAKwvOdn10Ts_AU6i+7toj7NkMwK-+0yr5wTrN0XEDudBWS0sPQ@mail.gmail.com>
Message-Id: <20200323191243.30002-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAKwvOdn10Ts_AU6i+7toj7NkMwK-+0yr5wTrN0XEDudBWS0sPQ@mail.gmail.com>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
Subject: [PATCH] KVM: VMX: don't allow memory operands for inline asm that
 modifies SP
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     ndesaulniers@google.com, bp@alien8.de,
        clang-built-linux@googlegroups.com, dvyukov@google.com,
        glider@google.com, hpa@zytor.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com,
        syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

THUNK_TARGET defines [thunk_target] as having "rm" input constraints
when CONFIG_RETPOLINE is not set, which isn't constrained enough for
this specific case.

For inline assembly that modifies the stack pointer before using this
input, the underspecification of constraints is dangerous, and results
in an indirect call to a previously pushed flags register.

In this case `entry`'s stack slot is good enough to satisfy the "m"
constraint in "rm", but the inline assembly in
handle_external_interrupt_irqoff() modifies the stack pointer via
push+pushf before using this input, which in this case results in
calling what was the previous state of the flags register, rather than
`entry`.

Be more specific in the constraints by requiring `entry` be in a
register, and not a memory operand.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com
Debugged-by: Alexander Potapenko <glider@google.com>
Debugged-by: Paolo Bonzini <pbonzini@redhat.com>
Debugged-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4d22b1b5e822..310e8c1169b8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6277,7 +6277,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 #endif
 		ASM_CALL_CONSTRAINT
 		:
-		THUNK_TARGET(entry),
+		[thunk_target]"r"(entry),
 		[ss]"i"(__KERNEL_DS),
 		[cs]"i"(__KERNEL_CS)
 	);
-- 
2.25.1.696.g5e7596f4ac-goog

