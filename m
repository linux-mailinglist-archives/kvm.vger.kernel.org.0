Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D3B12423
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 23:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfEBVbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 17:31:17 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35108 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBVbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 17:31:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id h1so1653480pgs.2
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 14:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kRgByrXycqdM1M15nLlf2KBo+chiXOfH1fCUeiWFamk=;
        b=IB6vB3FcEKMO2tz50VgGyzrBtZMalWIMGECGJABNUiGIiF4HAo+NTjeGWgpmYtPOa1
         4+Ma+mOOB/7cFCg7aXwzUGlRnVuNwKh6AX4AwWnzGvTqXl7dHmsDJkRJ29Fmn517/9k/
         sMw75Kfe9QaZMqT71HiV6+rEW1DBhPNRoC0t/GBKH5JWhNqfJtxDpRSJe9yd2dcj3Dsc
         fcyL1+Ksyh5vaM0xWTa9VMI3kson5N4WxFOOxIhcmW1ZL4Td3lr2iwb43OnpRL4oqHCK
         aTgoeiXsL3vWVXWOtQNfDnnGs/83xnjlRyPxfcN6p13pNhbekPysPf2Vkw5v2ooFMnkk
         pJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kRgByrXycqdM1M15nLlf2KBo+chiXOfH1fCUeiWFamk=;
        b=LZx++RT5HMIiL3yPL9Zhjo3aSDVOPIzntVwFGu8AkyK2on8b30PveUS70Vdpa1IVEh
         6TfKNRpgM/pihp66B4yZ5Z7nFbjKsGiQeF6kiMiRCKyJONGm72UuDqY5jSVV5bILiRtq
         dCxHMgEx3+dx6C/1xRmaQmfNkvmDtSE29ZDgqdpyzZWbaHDx/YikG9yWOq2DFmf/D9Nh
         xNhrg60UGyKfCEju3L0hU/L2jg7Il/nOCIjolGlOh2Uvo0h8WJfquYfdO4TNnlfFp03N
         8ICJ+TutSStV+iyTnHuf8FkrLF5MsoHVzTDPmIQ41yI4ZLnM/rpI1Hy2rgDCZEjLxV2m
         Oe/A==
X-Gm-Message-State: APjAAAVR4N6QmFyOy4yYcam/kuW1Fi521Z0/9QZe8UQJdrpSrSe37lPd
        sSvjOItjRH1jk2f3lyQUj6mPsv5Oq7Q=
X-Google-Smtp-Source: APXvYqzPrvlCDN3tPKoZWMIeu94VTX43ShlfIv2/42nM0TCUhoak2wMc8ycorb1O8jZ8vhCD+BOBrQ==
X-Received: by 2002:aa7:9089:: with SMTP id i9mr6559654pfa.115.1556832675561;
        Thu, 02 May 2019 14:31:15 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id c17sm116546pfn.173.2019.05.02.14.31.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 14:31:14 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] x86: Set "APIC Software Enable" after APIC reset
Date:   Thu,  2 May 2019 07:08:56 -0700
Message-Id: <20190502140856.4136-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

After the APIC is reset, some of its registers might be reset. As the
SDM says: "When IA32_APIC_BASE[11] is set to 0, prior initialization to
the APIC may be lost and the APIC may return to the state described in
Section 10.4.7.1". The SDM also says that after APIC reset "the
spurious-interrupt vector register is initialized to 000000FFH". This
means that after the APIC is reset it needs to be software-enabled
through the SPIV.

This is done one occasion, but there are (at least) two occasions that
do not software-enable the APIC after reset (__test_apic_id() and main()
in vmx.c).

Move APIC SPIV reinitialization into reset_apic(). Remove SPIV settings
which are unnecessary after reset_apic() is modified.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/apic.c | 1 +
 x86/apic.c     | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 2aeffbd..4e7d43c 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -161,6 +161,7 @@ void reset_apic(void)
 {
     disable_apic();
     wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) | APIC_EN);
+    apic_write(APIC_SPIV, 0x1ff);
 }
 
 u32 ioapic_read_reg(unsigned reg)
diff --git a/x86/apic.c b/x86/apic.c
index 3eff588..7ef4a27 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -148,7 +148,6 @@ static void test_apic_disable(void)
     verify_disabled_apic_mmio();
 
     reset_apic();
-    apic_write(APIC_SPIV, 0x1ff);
     report("Local apic enabled in xAPIC mode",
 	   (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN);
     report("CPUID.1H:EDX.APIC[bit 9] is set", cpuid(1).d & (1 << 9));
-- 
2.17.1

