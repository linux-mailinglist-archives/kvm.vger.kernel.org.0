Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DF75247D6
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 10:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351402AbiELIX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 04:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237176AbiELIXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 04:23:54 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DD769B4F;
        Thu, 12 May 2022 01:23:52 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id 126so4089205qkm.4;
        Thu, 12 May 2022 01:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=brHoAYESbYaw3qeDx896/zwLySs+sKATjJeEldnRzw0=;
        b=KgfUkaQARcExIlpU4rOm6uwSVpDtKV+CYKxa0xV36nWPu6HcqwegrlwMmwFAmZCk6s
         JQDg3yjgtLGYy+rcSgvEVNFUgZHXFXUVbvv5q2Opa9B7XCKnmWety+W8z5Tj8U2QT0bk
         jaOVNY5CQyv6rg2n7ZcbKTP1R1V+I+cakkG+vgl7hrN8yo3/wP9m8vuti0jZawo67nUM
         AOXHoTOt6BzMq31dQCgIf5+E+VYaJTp7fM7BLTpfY5Bm+2QtbnGAFA/N4R0Bgo3hLRBz
         IuawAuEQryOHeLJdgBSFKkWdRV31YdI8b4NmiIO7NbBVnCtHXV0ocffJkMFjjECtf4Km
         yrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=brHoAYESbYaw3qeDx896/zwLySs+sKATjJeEldnRzw0=;
        b=EneTyFqni5ce8/avtpC1N/e/YaF257wfLCaO8v34J/f0tFk93wwEitc/nott7MHDat
         Ymildo1METv69iG2kYmWv7PPpM6UGlb6YqeWcm9KSb/+ao9HiQTgvnUubPeDv2QaWUx+
         LLXAo5ruzmSD4yHlr985mXli0066AfOwNR0LYxnog6b00AyHGrULieeB3gQxlTKdV+lg
         kQmHx5ZrvfgcrzJLHsggavazs7mdSMFIz65mREhJWuXEpwOeb3l0xS1mOCHRMe09FOAY
         ApiEAA2jiE1TM1jtB//8fd+1zs/h9BuzZC6LVgwxS0Ye22yhRt7k/GQRzyXYrsQRP1PZ
         Xzng==
X-Gm-Message-State: AOAM532GF/+pO5TxsQLYb34oBc3LP9LOCmNwSzN124PhmEClhXtK6PDf
        5OXFo9bwf+FVMNpzRa8izQKtEywsE4QVWrWcBv8=
X-Google-Smtp-Source: ABdhPJyGAjNEKtEIIrYUOnLep7A7vZSIaAaaX6ec2tSxbiP9yvOwZ5Re/xNCRVSWIFgNux6XC7YflNO/XiTrD7nAv6M=
X-Received: by 2002:a37:9ace:0:b0:69f:b424:25b4 with SMTP id
 c197-20020a379ace000000b0069fb42425b4mr21826665qke.250.1652343831504; Thu, 12
 May 2022 01:23:51 -0700 (PDT)
MIME-Version: 1.0
References: <1652236710-36524-1-git-send-email-wanpengli@tencent.com> <7d9d5f72-21ed-070e-c063-1cd7ae6671ec@redhat.com>
In-Reply-To: <7d9d5f72-21ed-070e-c063-1cd7ae6671ec@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 12 May 2022 16:23:40 +0800
Message-ID: <CANRm+CzFdJvuq=V+5eSGmqvrTFPyHTHGp-rQD4gGujADeNtf+w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: LAPIC: Disarm LAPIC timer includes pending
 timer around TSC deadline switch
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 May 2022 at 21:54, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 5/11/22 04:38, Wanpeng Li wrote:
> >
> > Fixes: 4427593258 (KVM: x86: thoroughly disarm LAPIC timer around TSC deadline switch)
> > Signed-off-by: Wanpeng Li<wanpengli@tencent.com>
> > ---
>
> Please write a testcase for this.

Something like this, however, it is not easy to catch the pending
timer in this scenario.

diff --git a/x86/apic.c b/x86/apic.c
index 23508ad..108c1c8 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -22,7 +22,7 @@ static void test_lapic_existence(void)
 #define TSC_DEADLINE_TIMER_VECTOR 0xef
 #define BROADCAST_VECTOR 0xcf

-static int tdt_count;
+static int volatile tdt_count;

 static void tsc_deadline_timer_isr(isr_regs_t *regs)
 {
@@ -672,6 +672,18 @@ static void test_apic_change_mode(void)
        /* now tmcct == 0 and tmict != 0 */
        apic_change_mode(APIC_LVT_TIMER_PERIODIC);
        report(!apic_read(APIC_TMCCT), "TMCCT should stay at zero");
+
+       handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
+       irq_enable();
+
+       apic_write(APIC_LVTT, APIC_LVT_TIMER_ONESHOT |
+               APIC_LVT_TIMER_VECTOR);
+        /* Divider == 1 */
+       apic_write(APIC_TDCR, 0x0000000b);
+
+       apic_write(APIC_TMICT, 0x999999);
+       enable_tsc_deadline_timer();
+       while(tdt_count == 1);
 }

 #define KVM_HC_SEND_IPI 10
