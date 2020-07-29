Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28F423197E
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 08:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgG2GYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 02:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgG2GYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 02:24:52 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9CCC061794;
        Tue, 28 Jul 2020 23:24:52 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d188so6365812pfd.2;
        Tue, 28 Jul 2020 23:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sMFl8A9jPxjNMZOvebjCYmlhRA1mXGyUaqgUwzyXfq0=;
        b=J66knnMasKtQuXL0XnyYfUftY3b90hkTLSjlUXZrnfi3cAomEhuNTUJ04QBBiPbelO
         GBVwvatTo/r1aarV30knngJW3xfSocwQFFkY7jlcEEV4xoyIGxXUTRfD2AsbzPpi0rPz
         VbbaxTZ3AzOIEDKFT2DN/RGAb1A5bbKKeUPh7eDa7mvEPNG09B6aWmoJJeY/GLgTepOE
         gQ0hX44bo6mae/mhLOoGRwyvtdvOrfztmsdda5RrdFMmnw8Mh12muZNS5Noa77Z5xM8K
         rXV1vsG0s05hjPTwFkqXFfh80DCVf7r8PHgkjp+AgdYFI45u84Ppyk20Z8DamAnY02Wd
         J1JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sMFl8A9jPxjNMZOvebjCYmlhRA1mXGyUaqgUwzyXfq0=;
        b=Nq5vh69DLNvI97HPl8XmqzuowjAXFopaIGB2YdLc40O8uUui2bAvztHIkYSmTs8nXG
         rQwxx5xeQ2+knRfgy++D1FEj+eZ31EQBTrQJnzdr5pqmIFul+stAQe3osfBcHBZBSPdp
         5A/8wBaajxRGKks7JD+otYDR/A8uFYYdfONJCt5DZehsGi9OW18G0SbUr3MLV+oD5QMu
         qZC08EjzTnowI1/JeZbBsmBcHcBIu7H66juzBO1vfGuiFy/9ibpr+2fAyV9GFt+yM6hH
         sZaUKviEeGQmTL/edg5TZ0c7zqW8t+7EulVODuWxaZK/p3Qyd8hCjNE+uhEwI4rlSCds
         T4nw==
X-Gm-Message-State: AOAM532vO531AHdZ5WWnVyQ1HXCCpirfVcpDsaOi3AOEv0Fm/26Flt5T
        0lb9OepCK8gawUqdQQ4bPK0pMTjp7w==
X-Google-Smtp-Source: ABdhPJzNBOg0gxTtUNOgmKD3LPQ210Qcu0zYNNCIbxNbYwmbKC2WmetoyLCzCAAygzMobKggZhg2BQ==
X-Received: by 2002:aa7:95b6:: with SMTP id a22mr4885606pfk.152.1596003891707;
        Tue, 28 Jul 2020 23:24:51 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.6])
        by smtp.gmail.com with ESMTPSA id d22sm996502pgm.93.2020.07.28.23.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 23:24:51 -0700 (PDT)
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>
Cc:     acme@redhat.com, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "joro@8bytes.org" <joro@8bytes.org>, jmattson@google.com,
        wanpengli@tencent.com, "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH] perf/x86/svm: Convert 'perf kvm stat report' output lowercase
 to uppercase
Message-ID: <fdc7e57d-4fd6-4d49-22e6-b18003034ff5@gmail.com>
Date:   Wed, 29 Jul 2020 14:24:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

The reason output of 'perf kvm stat report --event=vmexit' is uppercase 
on VMX and lowercase on SVM.

To be consistent with VMX, convert lowercase to uppercase.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
  arch/x86/include/uapi/asm/svm.h       | 184 
+++++++++++++++++-----------------
  tools/arch/x86/include/uapi/asm/svm.h | 184 
+++++++++++++++++-----------------
  2 files changed, 184 insertions(+), 184 deletions(-)

diff --git a/arch/x86/include/uapi/asm/svm.h 
b/arch/x86/include/uapi/asm/svm.h
index 2e8a30f..647b6e2 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -83,98 +83,98 @@
  #define SVM_EXIT_ERR           -1

  #define SVM_EXIT_REASONS \
-	{ SVM_EXIT_READ_CR0,    "read_cr0" }, \
-	{ SVM_EXIT_READ_CR2,    "read_cr2" }, \
-	{ SVM_EXIT_READ_CR3,    "read_cr3" }, \
-	{ SVM_EXIT_READ_CR4,    "read_cr4" }, \
-	{ SVM_EXIT_READ_CR8,    "read_cr8" }, \
-	{ SVM_EXIT_WRITE_CR0,   "write_cr0" }, \
-	{ SVM_EXIT_WRITE_CR2,   "write_cr2" }, \
-	{ SVM_EXIT_WRITE_CR3,   "write_cr3" }, \
-	{ SVM_EXIT_WRITE_CR4,   "write_cr4" }, \
-	{ SVM_EXIT_WRITE_CR8,   "write_cr8" }, \
-	{ SVM_EXIT_READ_DR0,    "read_dr0" }, \
-	{ SVM_EXIT_READ_DR1,    "read_dr1" }, \
-	{ SVM_EXIT_READ_DR2,    "read_dr2" }, \
-	{ SVM_EXIT_READ_DR3,    "read_dr3" }, \
-	{ SVM_EXIT_READ_DR4,    "read_dr4" }, \
-	{ SVM_EXIT_READ_DR5,    "read_dr5" }, \
-	{ SVM_EXIT_READ_DR6,    "read_dr6" }, \
-	{ SVM_EXIT_READ_DR7,    "read_dr7" }, \
-	{ SVM_EXIT_WRITE_DR0,   "write_dr0" }, \
-	{ SVM_EXIT_WRITE_DR1,   "write_dr1" }, \
-	{ SVM_EXIT_WRITE_DR2,   "write_dr2" }, \
-	{ SVM_EXIT_WRITE_DR3,   "write_dr3" }, \
-	{ SVM_EXIT_WRITE_DR4,   "write_dr4" }, \
-	{ SVM_EXIT_WRITE_DR5,   "write_dr5" }, \
-	{ SVM_EXIT_WRITE_DR6,   "write_dr6" }, \
-	{ SVM_EXIT_WRITE_DR7,   "write_dr7" }, \
-	{ SVM_EXIT_EXCP_BASE + DE_VECTOR,       "DE excp" }, \
-	{ SVM_EXIT_EXCP_BASE + DB_VECTOR,       "DB excp" }, \
-	{ SVM_EXIT_EXCP_BASE + BP_VECTOR,       "BP excp" }, \
-	{ SVM_EXIT_EXCP_BASE + OF_VECTOR,       "OF excp" }, \
-	{ SVM_EXIT_EXCP_BASE + BR_VECTOR,       "BR excp" }, \
-	{ SVM_EXIT_EXCP_BASE + UD_VECTOR,       "UD excp" }, \
-	{ SVM_EXIT_EXCP_BASE + NM_VECTOR,       "NM excp" }, \
-	{ SVM_EXIT_EXCP_BASE + DF_VECTOR,       "DF excp" }, \
-	{ SVM_EXIT_EXCP_BASE + TS_VECTOR,       "TS excp" }, \
-	{ SVM_EXIT_EXCP_BASE + NP_VECTOR,       "NP excp" }, \
-	{ SVM_EXIT_EXCP_BASE + SS_VECTOR,       "SS excp" }, \
-	{ SVM_EXIT_EXCP_BASE + GP_VECTOR,       "GP excp" }, \
-	{ SVM_EXIT_EXCP_BASE + PF_VECTOR,       "PF excp" }, \
-	{ SVM_EXIT_EXCP_BASE + MF_VECTOR,       "MF excp" }, \
-	{ SVM_EXIT_EXCP_BASE + AC_VECTOR,       "AC excp" }, \
-	{ SVM_EXIT_EXCP_BASE + MC_VECTOR,       "MC excp" }, \
-	{ SVM_EXIT_EXCP_BASE + XM_VECTOR,       "XF excp" }, \
-	{ SVM_EXIT_INTR,        "interrupt" }, \
-	{ SVM_EXIT_NMI,         "nmi" }, \
-	{ SVM_EXIT_SMI,         "smi" }, \
-	{ SVM_EXIT_INIT,        "init" }, \
-	{ SVM_EXIT_VINTR,       "vintr" }, \
-	{ SVM_EXIT_CR0_SEL_WRITE, "cr0_sel_write" }, \
-	{ SVM_EXIT_IDTR_READ,   "read_idtr" }, \
-	{ SVM_EXIT_GDTR_READ,   "read_gdtr" }, \
-	{ SVM_EXIT_LDTR_READ,   "read_ldtr" }, \
-	{ SVM_EXIT_TR_READ,     "read_rt" }, \
-	{ SVM_EXIT_IDTR_WRITE,  "write_idtr" }, \
-	{ SVM_EXIT_GDTR_WRITE,  "write_gdtr" }, \
-	{ SVM_EXIT_LDTR_WRITE,  "write_ldtr" }, \
-	{ SVM_EXIT_TR_WRITE,    "write_rt" }, \
-	{ SVM_EXIT_RDTSC,       "rdtsc" }, \
-	{ SVM_EXIT_RDPMC,       "rdpmc" }, \
-	{ SVM_EXIT_PUSHF,       "pushf" }, \
-	{ SVM_EXIT_POPF,        "popf" }, \
-	{ SVM_EXIT_CPUID,       "cpuid" }, \
-	{ SVM_EXIT_RSM,         "rsm" }, \
-	{ SVM_EXIT_IRET,        "iret" }, \
-	{ SVM_EXIT_SWINT,       "swint" }, \
-	{ SVM_EXIT_INVD,        "invd" }, \
-	{ SVM_EXIT_PAUSE,       "pause" }, \
-	{ SVM_EXIT_HLT,         "hlt" }, \
-	{ SVM_EXIT_INVLPG,      "invlpg" }, \
-	{ SVM_EXIT_INVLPGA,     "invlpga" }, \
-	{ SVM_EXIT_IOIO,        "io" }, \
-	{ SVM_EXIT_MSR,         "msr" }, \
-	{ SVM_EXIT_TASK_SWITCH, "task_switch" }, \
-	{ SVM_EXIT_FERR_FREEZE, "ferr_freeze" }, \
-	{ SVM_EXIT_SHUTDOWN,    "shutdown" }, \
-	{ SVM_EXIT_VMRUN,       "vmrun" }, \
-	{ SVM_EXIT_VMMCALL,     "hypercall" }, \
-	{ SVM_EXIT_VMLOAD,      "vmload" }, \
-	{ SVM_EXIT_VMSAVE,      "vmsave" }, \
-	{ SVM_EXIT_STGI,        "stgi" }, \
-	{ SVM_EXIT_CLGI,        "clgi" }, \
-	{ SVM_EXIT_SKINIT,      "skinit" }, \
-	{ SVM_EXIT_RDTSCP,      "rdtscp" }, \
-	{ SVM_EXIT_ICEBP,       "icebp" }, \
-	{ SVM_EXIT_WBINVD,      "wbinvd" }, \
-	{ SVM_EXIT_MONITOR,     "monitor" }, \
-	{ SVM_EXIT_MWAIT,       "mwait" }, \
-	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
-	{ SVM_EXIT_NPF,         "npf" }, \
-	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
-	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
-	{ SVM_EXIT_ERR,         "invalid_guest_state" }
+	{ SVM_EXIT_READ_CR0,    "READ_CR0" }, \
+	{ SVM_EXIT_READ_CR2,    "READ_CR2" }, \
+	{ SVM_EXIT_READ_CR3,    "READ_CR3" }, \
+	{ SVM_EXIT_READ_CR4,    "READ_CR4" }, \
+	{ SVM_EXIT_READ_CR8,    "READ_CR8" }, \
+	{ SVM_EXIT_WRITE_CR0,   "WRITE_CR0" }, \
+	{ SVM_EXIT_WRITE_CR2,   "WRITE_CR2" }, \
+	{ SVM_EXIT_WRITE_CR3,   "WRITE_CR3" }, \
+	{ SVM_EXIT_WRITE_CR4,   "WRITE_CR4" }, \
+	{ SVM_EXIT_WRITE_CR8,   "WRITE_CR8" }, \
+	{ SVM_EXIT_READ_DR0,    "READ_DR0" }, \
+	{ SVM_EXIT_READ_DR1,    "READ_DR1" }, \
+	{ SVM_EXIT_READ_DR2,    "READ_DR2" }, \
+	{ SVM_EXIT_READ_DR3,    "READ_DR3" }, \
+	{ SVM_EXIT_READ_DR4,    "READ_DR4" }, \
+	{ SVM_EXIT_READ_DR5,    "READ_DR5" }, \
+	{ SVM_EXIT_READ_DR6,    "READ_DR6" }, \
+	{ SVM_EXIT_READ_DR7,    "READ_DR7" }, \
+	{ SVM_EXIT_WRITE_DR0,   "WRITE_DR0" }, \
+	{ SVM_EXIT_WRITE_DR1,   "WRITE_DR1" }, \
+	{ SVM_EXIT_WRITE_DR2,   "WRITE_DR2" }, \
+	{ SVM_EXIT_WRITE_DR3,   "WRITE_DR3" }, \
+	{ SVM_EXIT_WRITE_DR4,   "WRITE_DR4" }, \
+	{ SVM_EXIT_WRITE_DR5,   "WRITE_DR5" }, \
+	{ SVM_EXIT_WRITE_DR6,   "WRITE_DR6" }, \
+	{ SVM_EXIT_WRITE_DR7,   "WRITE_DR7" }, \
+	{ SVM_EXIT_EXCP_BASE + DE_VECTOR,       "DE EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + DB_VECTOR,       "DB EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + BP_VECTOR,       "BP EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + OF_VECTOR,       "OF EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + BR_VECTOR,       "BR EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + UD_VECTOR,       "UD EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + NM_VECTOR,       "NM EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + DF_VECTOR,       "DF EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + TS_VECTOR,       "TS EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + NP_VECTOR,       "NP EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + SS_VECTOR,       "SS EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + GP_VECTOR,       "GP EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + PF_VECTOR,       "PF EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + MF_VECTOR,       "MF EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + AC_VECTOR,       "AC EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + MC_VECTOR,       "MC EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + XM_VECTOR,       "XF EXCP" }, \
+	{ SVM_EXIT_INTR,        "INTERRUPT" }, \
+	{ SVM_EXIT_NMI,         "NMI" }, \
+	{ SVM_EXIT_SMI,         "SMI" }, \
+	{ SVM_EXIT_INIT,        "INIT" }, \
+	{ SVM_EXIT_VINTR,       "VINTR" }, \
+	{ SVM_EXIT_CR0_SEL_WRITE, "CR0_SEL_WRITE" }, \
+	{ SVM_EXIT_IDTR_READ,   "READ_IDTR" }, \
+	{ SVM_EXIT_GDTR_READ,   "READ_GDTR" }, \
+	{ SVM_EXIT_LDTR_READ,   "READ_LDTR" }, \
+	{ SVM_EXIT_TR_READ,     "READ_RT" }, \
+	{ SVM_EXIT_IDTR_WRITE,  "WRITE_IDTR" }, \
+	{ SVM_EXIT_GDTR_WRITE,  "WRITE_GDTR" }, \
+	{ SVM_EXIT_LDTR_WRITE,  "WRITE_LDTR" }, \
+	{ SVM_EXIT_TR_WRITE,    "WRITE_RT" }, \
+	{ SVM_EXIT_RDTSC,       "RDTSC" }, \
+	{ SVM_EXIT_RDPMC,       "RDPMC" }, \
+	{ SVM_EXIT_PUSHF,       "PUSHF" }, \
+	{ SVM_EXIT_POPF,        "POPF" }, \
+	{ SVM_EXIT_CPUID,       "CPUID" }, \
+	{ SVM_EXIT_RSM,         "RSM" }, \
+	{ SVM_EXIT_IRET,        "IRET" }, \
+	{ SVM_EXIT_SWINT,       "SWINT" }, \
+	{ SVM_EXIT_INVD,        "INVD" }, \
+	{ SVM_EXIT_PAUSE,       "PAUSE" }, \
+	{ SVM_EXIT_HLT,         "HLT" }, \
+	{ SVM_EXIT_INVLPG,      "INVLPG" }, \
+	{ SVM_EXIT_INVLPGA,     "INVLPGA" }, \
+	{ SVM_EXIT_IOIO,        "IO" }, \
+	{ SVM_EXIT_MSR,         "MSR" }, \
+	{ SVM_EXIT_TASK_SWITCH, "TASK_SWITCH" }, \
+	{ SVM_EXIT_FERR_FREEZE, "FERR_FREEZE" }, \
+	{ SVM_EXIT_SHUTDOWN,    "SHUTDOWN" }, \
+	{ SVM_EXIT_VMRUN,       "VMRUN" }, \
+	{ SVM_EXIT_VMMCALL,     "HYPERCALL" }, \
+	{ SVM_EXIT_VMLOAD,      "VMLOAD" }, \
+	{ SVM_EXIT_VMSAVE,      "VMSAVE" }, \
+	{ SVM_EXIT_STGI,        "STGI" }, \
+	{ SVM_EXIT_CLGI,        "CLGI" }, \
+	{ SVM_EXIT_SKINIT,      "SKINIT" }, \
+	{ SVM_EXIT_RDTSCP,      "RDTSCP" }, \
+	{ SVM_EXIT_ICEBP,       "ICEBP" }, \
+	{ SVM_EXIT_WBINVD,      "WBINVD" }, \
+	{ SVM_EXIT_MONITOR,     "MONITOR" }, \
+	{ SVM_EXIT_MWAIT,       "MWAIT" }, \
+	{ SVM_EXIT_XSETBV,      "XSETBV" }, \
+	{ SVM_EXIT_NPF,         "NPF" }, \
+	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"AVIC_INCOMPLETE_IPI" }, \
+	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "AVIC_UNACCELERATED_ACCESS" }, \
+	{ SVM_EXIT_ERR,         "INVALID_GUEST_STATE" }


  #endif /* _UAPI__SVM_H */
diff --git a/tools/arch/x86/include/uapi/asm/svm.h 
b/tools/arch/x86/include/uapi/asm/svm.h
index 2e8a30f..647b6e2 100644
--- a/tools/arch/x86/include/uapi/asm/svm.h
+++ b/tools/arch/x86/include/uapi/asm/svm.h
@@ -83,98 +83,98 @@
  #define SVM_EXIT_ERR           -1

  #define SVM_EXIT_REASONS \
-	{ SVM_EXIT_READ_CR0,    "read_cr0" }, \
-	{ SVM_EXIT_READ_CR2,    "read_cr2" }, \
-	{ SVM_EXIT_READ_CR3,    "read_cr3" }, \
-	{ SVM_EXIT_READ_CR4,    "read_cr4" }, \
-	{ SVM_EXIT_READ_CR8,    "read_cr8" }, \
-	{ SVM_EXIT_WRITE_CR0,   "write_cr0" }, \
-	{ SVM_EXIT_WRITE_CR2,   "write_cr2" }, \
-	{ SVM_EXIT_WRITE_CR3,   "write_cr3" }, \
-	{ SVM_EXIT_WRITE_CR4,   "write_cr4" }, \
-	{ SVM_EXIT_WRITE_CR8,   "write_cr8" }, \
-	{ SVM_EXIT_READ_DR0,    "read_dr0" }, \
-	{ SVM_EXIT_READ_DR1,    "read_dr1" }, \
-	{ SVM_EXIT_READ_DR2,    "read_dr2" }, \
-	{ SVM_EXIT_READ_DR3,    "read_dr3" }, \
-	{ SVM_EXIT_READ_DR4,    "read_dr4" }, \
-	{ SVM_EXIT_READ_DR5,    "read_dr5" }, \
-	{ SVM_EXIT_READ_DR6,    "read_dr6" }, \
-	{ SVM_EXIT_READ_DR7,    "read_dr7" }, \
-	{ SVM_EXIT_WRITE_DR0,   "write_dr0" }, \
-	{ SVM_EXIT_WRITE_DR1,   "write_dr1" }, \
-	{ SVM_EXIT_WRITE_DR2,   "write_dr2" }, \
-	{ SVM_EXIT_WRITE_DR3,   "write_dr3" }, \
-	{ SVM_EXIT_WRITE_DR4,   "write_dr4" }, \
-	{ SVM_EXIT_WRITE_DR5,   "write_dr5" }, \
-	{ SVM_EXIT_WRITE_DR6,   "write_dr6" }, \
-	{ SVM_EXIT_WRITE_DR7,   "write_dr7" }, \
-	{ SVM_EXIT_EXCP_BASE + DE_VECTOR,       "DE excp" }, \
-	{ SVM_EXIT_EXCP_BASE + DB_VECTOR,       "DB excp" }, \
-	{ SVM_EXIT_EXCP_BASE + BP_VECTOR,       "BP excp" }, \
-	{ SVM_EXIT_EXCP_BASE + OF_VECTOR,       "OF excp" }, \
-	{ SVM_EXIT_EXCP_BASE + BR_VECTOR,       "BR excp" }, \
-	{ SVM_EXIT_EXCP_BASE + UD_VECTOR,       "UD excp" }, \
-	{ SVM_EXIT_EXCP_BASE + NM_VECTOR,       "NM excp" }, \
-	{ SVM_EXIT_EXCP_BASE + DF_VECTOR,       "DF excp" }, \
-	{ SVM_EXIT_EXCP_BASE + TS_VECTOR,       "TS excp" }, \
-	{ SVM_EXIT_EXCP_BASE + NP_VECTOR,       "NP excp" }, \
-	{ SVM_EXIT_EXCP_BASE + SS_VECTOR,       "SS excp" }, \
-	{ SVM_EXIT_EXCP_BASE + GP_VECTOR,       "GP excp" }, \
-	{ SVM_EXIT_EXCP_BASE + PF_VECTOR,       "PF excp" }, \
-	{ SVM_EXIT_EXCP_BASE + MF_VECTOR,       "MF excp" }, \
-	{ SVM_EXIT_EXCP_BASE + AC_VECTOR,       "AC excp" }, \
-	{ SVM_EXIT_EXCP_BASE + MC_VECTOR,       "MC excp" }, \
-	{ SVM_EXIT_EXCP_BASE + XM_VECTOR,       "XF excp" }, \
-	{ SVM_EXIT_INTR,        "interrupt" }, \
-	{ SVM_EXIT_NMI,         "nmi" }, \
-	{ SVM_EXIT_SMI,         "smi" }, \
-	{ SVM_EXIT_INIT,        "init" }, \
-	{ SVM_EXIT_VINTR,       "vintr" }, \
-	{ SVM_EXIT_CR0_SEL_WRITE, "cr0_sel_write" }, \
-	{ SVM_EXIT_IDTR_READ,   "read_idtr" }, \
-	{ SVM_EXIT_GDTR_READ,   "read_gdtr" }, \
-	{ SVM_EXIT_LDTR_READ,   "read_ldtr" }, \
-	{ SVM_EXIT_TR_READ,     "read_rt" }, \
-	{ SVM_EXIT_IDTR_WRITE,  "write_idtr" }, \
-	{ SVM_EXIT_GDTR_WRITE,  "write_gdtr" }, \
-	{ SVM_EXIT_LDTR_WRITE,  "write_ldtr" }, \
-	{ SVM_EXIT_TR_WRITE,    "write_rt" }, \
-	{ SVM_EXIT_RDTSC,       "rdtsc" }, \
-	{ SVM_EXIT_RDPMC,       "rdpmc" }, \
-	{ SVM_EXIT_PUSHF,       "pushf" }, \
-	{ SVM_EXIT_POPF,        "popf" }, \
-	{ SVM_EXIT_CPUID,       "cpuid" }, \
-	{ SVM_EXIT_RSM,         "rsm" }, \
-	{ SVM_EXIT_IRET,        "iret" }, \
-	{ SVM_EXIT_SWINT,       "swint" }, \
-	{ SVM_EXIT_INVD,        "invd" }, \
-	{ SVM_EXIT_PAUSE,       "pause" }, \
-	{ SVM_EXIT_HLT,         "hlt" }, \
-	{ SVM_EXIT_INVLPG,      "invlpg" }, \
-	{ SVM_EXIT_INVLPGA,     "invlpga" }, \
-	{ SVM_EXIT_IOIO,        "io" }, \
-	{ SVM_EXIT_MSR,         "msr" }, \
-	{ SVM_EXIT_TASK_SWITCH, "task_switch" }, \
-	{ SVM_EXIT_FERR_FREEZE, "ferr_freeze" }, \
-	{ SVM_EXIT_SHUTDOWN,    "shutdown" }, \
-	{ SVM_EXIT_VMRUN,       "vmrun" }, \
-	{ SVM_EXIT_VMMCALL,     "hypercall" }, \
-	{ SVM_EXIT_VMLOAD,      "vmload" }, \
-	{ SVM_EXIT_VMSAVE,      "vmsave" }, \
-	{ SVM_EXIT_STGI,        "stgi" }, \
-	{ SVM_EXIT_CLGI,        "clgi" }, \
-	{ SVM_EXIT_SKINIT,      "skinit" }, \
-	{ SVM_EXIT_RDTSCP,      "rdtscp" }, \
-	{ SVM_EXIT_ICEBP,       "icebp" }, \
-	{ SVM_EXIT_WBINVD,      "wbinvd" }, \
-	{ SVM_EXIT_MONITOR,     "monitor" }, \
-	{ SVM_EXIT_MWAIT,       "mwait" }, \
-	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
-	{ SVM_EXIT_NPF,         "npf" }, \
-	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
-	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
-	{ SVM_EXIT_ERR,         "invalid_guest_state" }
+	{ SVM_EXIT_READ_CR0,    "READ_CR0" }, \
+	{ SVM_EXIT_READ_CR2,    "READ_CR2" }, \
+	{ SVM_EXIT_READ_CR3,    "READ_CR3" }, \
+	{ SVM_EXIT_READ_CR4,    "READ_CR4" }, \
+	{ SVM_EXIT_READ_CR8,    "READ_CR8" }, \
+	{ SVM_EXIT_WRITE_CR0,   "WRITE_CR0" }, \
+	{ SVM_EXIT_WRITE_CR2,   "WRITE_CR2" }, \
+	{ SVM_EXIT_WRITE_CR3,   "WRITE_CR3" }, \
+	{ SVM_EXIT_WRITE_CR4,   "WRITE_CR4" }, \
+	{ SVM_EXIT_WRITE_CR8,   "WRITE_CR8" }, \
+	{ SVM_EXIT_READ_DR0,    "READ_DR0" }, \
+	{ SVM_EXIT_READ_DR1,    "READ_DR1" }, \
+	{ SVM_EXIT_READ_DR2,    "READ_DR2" }, \
+	{ SVM_EXIT_READ_DR3,    "READ_DR3" }, \
+	{ SVM_EXIT_READ_DR4,    "READ_DR4" }, \
+	{ SVM_EXIT_READ_DR5,    "READ_DR5" }, \
+	{ SVM_EXIT_READ_DR6,    "READ_DR6" }, \
+	{ SVM_EXIT_READ_DR7,    "READ_DR7" }, \
+	{ SVM_EXIT_WRITE_DR0,   "WRITE_DR0" }, \
+	{ SVM_EXIT_WRITE_DR1,   "WRITE_DR1" }, \
+	{ SVM_EXIT_WRITE_DR2,   "WRITE_DR2" }, \
+	{ SVM_EXIT_WRITE_DR3,   "WRITE_DR3" }, \
+	{ SVM_EXIT_WRITE_DR4,   "WRITE_DR4" }, \
+	{ SVM_EXIT_WRITE_DR5,   "WRITE_DR5" }, \
+	{ SVM_EXIT_WRITE_DR6,   "WRITE_DR6" }, \
+	{ SVM_EXIT_WRITE_DR7,   "WRITE_DR7" }, \
+	{ SVM_EXIT_EXCP_BASE + DE_VECTOR,       "DE EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + DB_VECTOR,       "DB EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + BP_VECTOR,       "BP EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + OF_VECTOR,       "OF EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + BR_VECTOR,       "BR EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + UD_VECTOR,       "UD EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + NM_VECTOR,       "NM EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + DF_VECTOR,       "DF EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + TS_VECTOR,       "TS EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + NP_VECTOR,       "NP EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + SS_VECTOR,       "SS EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + GP_VECTOR,       "GP EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + PF_VECTOR,       "PF EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + MF_VECTOR,       "MF EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + AC_VECTOR,       "AC EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + MC_VECTOR,       "MC EXCP" }, \
+	{ SVM_EXIT_EXCP_BASE + XM_VECTOR,       "XF EXCP" }, \
+	{ SVM_EXIT_INTR,        "INTERRUPT" }, \
+	{ SVM_EXIT_NMI,         "NMI" }, \
+	{ SVM_EXIT_SMI,         "SMI" }, \
+	{ SVM_EXIT_INIT,        "INIT" }, \
+	{ SVM_EXIT_VINTR,       "VINTR" }, \
+	{ SVM_EXIT_CR0_SEL_WRITE, "CR0_SEL_WRITE" }, \
+	{ SVM_EXIT_IDTR_READ,   "READ_IDTR" }, \
+	{ SVM_EXIT_GDTR_READ,   "READ_GDTR" }, \
+	{ SVM_EXIT_LDTR_READ,   "READ_LDTR" }, \
+	{ SVM_EXIT_TR_READ,     "READ_RT" }, \
+	{ SVM_EXIT_IDTR_WRITE,  "WRITE_IDTR" }, \
+	{ SVM_EXIT_GDTR_WRITE,  "WRITE_GDTR" }, \
+	{ SVM_EXIT_LDTR_WRITE,  "WRITE_LDTR" }, \
+	{ SVM_EXIT_TR_WRITE,    "WRITE_RT" }, \
+	{ SVM_EXIT_RDTSC,       "RDTSC" }, \
+	{ SVM_EXIT_RDPMC,       "RDPMC" }, \
+	{ SVM_EXIT_PUSHF,       "PUSHF" }, \
+	{ SVM_EXIT_POPF,        "POPF" }, \
+	{ SVM_EXIT_CPUID,       "CPUID" }, \
+	{ SVM_EXIT_RSM,         "RSM" }, \
+	{ SVM_EXIT_IRET,        "IRET" }, \
+	{ SVM_EXIT_SWINT,       "SWINT" }, \
+	{ SVM_EXIT_INVD,        "INVD" }, \
+	{ SVM_EXIT_PAUSE,       "PAUSE" }, \
+	{ SVM_EXIT_HLT,         "HLT" }, \
+	{ SVM_EXIT_INVLPG,      "INVLPG" }, \
+	{ SVM_EXIT_INVLPGA,     "INVLPGA" }, \
+	{ SVM_EXIT_IOIO,        "IO" }, \
+	{ SVM_EXIT_MSR,         "MSR" }, \
+	{ SVM_EXIT_TASK_SWITCH, "TASK_SWITCH" }, \
+	{ SVM_EXIT_FERR_FREEZE, "FERR_FREEZE" }, \
+	{ SVM_EXIT_SHUTDOWN,    "SHUTDOWN" }, \
+	{ SVM_EXIT_VMRUN,       "VMRUN" }, \
+	{ SVM_EXIT_VMMCALL,     "HYPERCALL" }, \
+	{ SVM_EXIT_VMLOAD,      "VMLOAD" }, \
+	{ SVM_EXIT_VMSAVE,      "VMSAVE" }, \
+	{ SVM_EXIT_STGI,        "STGI" }, \
+	{ SVM_EXIT_CLGI,        "CLGI" }, \
+	{ SVM_EXIT_SKINIT,      "SKINIT" }, \
+	{ SVM_EXIT_RDTSCP,      "RDTSCP" }, \
+	{ SVM_EXIT_ICEBP,       "ICEBP" }, \
+	{ SVM_EXIT_WBINVD,      "WBINVD" }, \
+	{ SVM_EXIT_MONITOR,     "MONITOR" }, \
+	{ SVM_EXIT_MWAIT,       "MWAIT" }, \
+	{ SVM_EXIT_XSETBV,      "XSETBV" }, \
+	{ SVM_EXIT_NPF,         "NPF" }, \
+	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"AVIC_INCOMPLETE_IPI" }, \
+	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "AVIC_UNACCELERATED_ACCESS" }, \
+	{ SVM_EXIT_ERR,         "INVALID_GUEST_STATE" }


  #endif /* _UAPI__SVM_H */
-- 
1.8.3.1


