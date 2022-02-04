Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02604AA283
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241749AbiBDVoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236194AbiBDVoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:44:13 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DADC061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:44:12 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id m21-20020a17090b069500b001b532620cd9so4290483pjz.1
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=WwNn1EweE0osCn/+0myHaYSZUIQI2fqqMjPGItzI+ww=;
        b=Y/h2vmpuVioBeBX4tdCiX9vt1JbrK6mzd5psiTU1ujpf5zxkRaG/24uYQUZT/2xYFa
         sF2+0n3EHStXciW3ZTqj94uofIUO1VWcOjylkKV//VyWaH8/7rZBuNe+I0kksE8prmHL
         0i8VZqxLRqIJBAN1/tq8FmGeckEXCer84ffJSAtgd5tX3kVV+/N19CawpOea7k5dyJDG
         KcxEmM+uAnbKC8N2IhTIxMm5lRCYGMfusTqebBauDa8BzRXJInmUWJ844ONRjIrNaS0n
         J1eIjldDnbGEC3H64c4e5I6WcfPdcUlpXv+j8RaAokjD8WeAn0co85CRMdfD9uBZhDXP
         8dOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=WwNn1EweE0osCn/+0myHaYSZUIQI2fqqMjPGItzI+ww=;
        b=Fppq1+ihOAo9Pl6mxgRl0+ZkUnceM+g0Iul3eS+uzpwgfkH7u5QnJWeMQag7/Eu2Qy
         yvzofV4MuyV8j6iyEXxMjOVOHQ4IrMEel5MCTz9nukVC9AuFEErxngH23YtI2I4xRczu
         4P3dnp8VfM0pRw02YKgy9e1UtNImx8XyR6YtLu+JZrZK32h6PQya6uOFRtI82zJfbfcK
         nn12OArP6InWZ0SqkgRFGZlMMh8GWTHIFtoMcnFSCxinFo3NzLIOWvtNCgH3b36qkbG4
         tAVxrM5I69Y/ADb8tTy9xlBs22i8KuyOTgSLCq5iSB3yaM/sIArfyEtOTkec9Ybeg/Yu
         q35Q==
X-Gm-Message-State: AOAM531QnktePldK/3HTG0k5bsPcmvYqqBRRdf4QItTnZkQ6hrE1H+x8
        twn5r4DN7nqwJuExS4sPsCwZbMK6XqU=
X-Google-Smtp-Source: ABdhPJwQKbxPH8U5v1oyYN46fgHglkpHIcrZinmOQQ0m9/0Ag/lVINYHZvBhfYgcUysSXAeY1Xef4PMRgVo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1989:: with SMTP id
 d9mr5021131pfl.14.1644011052238; Fri, 04 Feb 2022 13:44:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  4 Feb 2022 21:44:10 +0000
Message-Id: <20220204214410.3315068-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [kvm-unit-tests PATCH] x86: apic: Add test config to allow running
 apic tests against SVM's AVIC
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a curated "xapic" test configuration that hides x2APIC from the guest
and does not expose a PIT/8254 timer to the guest so that KVM won't
disable AVIC due to incompatibilities.

Caveat emptor: actually running the test with AVIC enabled will fail
miserably.  KVM botches xAPIC ID changes[*], and then fails for reasons
unknown after fixing the ID goof in the "write everything" case:

  memset((void *)APIC_DEFAULT_PHYS_BASE, 0xff, PAGE_SIZE);

But, AVIC is off by default and requires disabling nested support, i.e.
only people doing actual AVIC work will be affected because it's highly
unlikely to be enabled by accident.

[*] https://lore.kernel.org/all/d058f7464084cadc183bd9dbf02c7f525bb9f902.camel@redhat.com

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 9a70ba3b..f46fb715 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -30,18 +30,31 @@ file = apic.flat
 smp = 2
 extra_params = -cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqchip=split
 arch = x86_64
+groups = apic
 
 [ioapic-split]
 file = ioapic.flat
 extra_params = -cpu qemu64 -machine kernel_irqchip=split
 arch = x86_64
+groups = apic
 
-[apic]
+[x2apic]
 file = apic.flat
 smp = 2
 extra_params = -cpu qemu64,+x2apic,+tsc-deadline
 arch = x86_64
 timeout = 30
+groups = apic
+
+# Hide x2APIC and don't create a Programmable Interval Timer (PIT, a.k.a 8254)
+# to allow testing SVM's AVIC, which is disabled if either is exposed to the guest.
+[xapic]
+file = apic.flat
+smp = 2
+extra_params = -cpu qemu64,-x2apic,+tsc-deadline -machine pit=off
+arch = x86_64
+timeout = 30
+groups = apic
 
 [ioapic]
 file = ioapic.flat

base-commit: dbf4a3c3b469a2d92366a58f481d13c98a78eecc
-- 
2.35.0.263.gb82422642f-goog

