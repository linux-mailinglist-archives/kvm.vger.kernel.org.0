Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD10B2F2150
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 22:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731664AbhAKVAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 16:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbhAKVAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 16:00:21 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C78C061794
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 12:59:41 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b8so175720plx.0
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 12:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jtUdywQM4flxySRPrfE1NwzGE3CmnKKdPKinhrqCi+s=;
        b=HUGlibvo5wvekMs7VGccZDkE2vCjozw6xPPRUWnq0pc5143HYx2PvyAkqIjesN56iD
         j5ZdBDDgI+Qn2Vhqu83fHwQdroFelGhPkipUeYb4zvVzCGHE3bU7+8vZJ1HQWBWjzLSM
         Fh76lbIcWEaqHkXiiTRVmSAOhlMJvhneduSx5p64QIjXmMqtUSuyQL8Q4rRSABSk+Rig
         dNtcm6bC2btaZ8OVojXy0rTdbehqbsx/8tzZUX5iFKACEZloqcC65fkrAHiT/W00h2CV
         dK2FOBT+2doLHy49XOY7jc4m2J55mQY89Q3cHoccIg/GzsjjQbWsWk+UKijkrNxLxyJH
         PPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jtUdywQM4flxySRPrfE1NwzGE3CmnKKdPKinhrqCi+s=;
        b=JJDcepWtfS/CoDRxcUl/YC99QIducXjRZSNzrLkl2YZo9NZ1fIjY9nuDbJL+nQ7sM3
         5hD0y/yUhKJpngQx537zfK1Yg8eX4bzpzb7ffCDrVozpStp0jPJWZEys3ib3Pe+zvSFo
         IJ6v/7nYXBOImwudeoogHkMzUBcSBuGZTQnjuMIW7XbvtqsL/vUw6hZJKMk5/73SY1fa
         R+t+65jPkfYlSdzqE2auEfJBbZU8IxnPuhPkpDZlhEZ453KQ4ZXhby8VrVscOpBveZDI
         qWVoKU0IsuM5ogXSY5fTXIxQcTGBFjKOQp7zpIDWAhLFAVbelrdG1N7MEaSTToa+tbhq
         lX/g==
X-Gm-Message-State: AOAM532jb40rWZinpd3k+Nib8tie3KxOYmXqHscGDUR1TkRew93d1R1z
        Qxgflz4a+FenoMpTu9ZRiKKHyQ==
X-Google-Smtp-Source: ABdhPJzK8V7iAQwaYLtUe2fmiOZBmzQjNNjxJn/CsAUKmc3YxZaCpeC/C2vIM2jsJnYGcPzpt4voCQ==
X-Received: by 2002:a17:902:830a:b029:da:df3b:459a with SMTP id bd10-20020a170902830ab02900dadf3b459amr1130093plb.75.1610398780412;
        Mon, 11 Jan 2021 12:59:40 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a2sm647153pgi.8.2021.01.11.12.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 12:59:39 -0800 (PST)
Date:   Mon, 11 Jan 2021 12:59:33 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH 11/13] KVM: SVM: Drop redundant svm_sev_enabled() helper
Message-ID: <X/y8NU4hWWKgGrJo@google.com>
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-12-seanjc@google.com>
 <89efe8fb-6495-5634-9378-a7dbb57f9d81@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89efe8fb-6495-5634-9378-a7dbb57f9d81@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021, Tom Lendacky wrote:
> On 1/8/21 6:47 PM, Sean Christopherson wrote:
> > Replace calls to svm_sev_enabled() with direct checks on sev_enabled, or
> > in the case of svm_mem_enc_op, simply drop the call to svm_sev_enabled().
> > This effectively replaces checks against a valid max_sev_asid with checks
> > against sev_enabled.  sev_enabled is forced off by sev_hardware_setup()
> > if max_sev_asid is invalid, all call sites are guaranteed to run after
> > sev_hardware_setup(), and all of the checks care about SEV being fully
> > enabled (as opposed to intentionally handling the scenario where
> > max_sev_asid is valid but SEV enabling fails due to OOM).
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/svm/sev.c | 6 +++---
> >   arch/x86/kvm/svm/svm.h | 5 -----
> >   2 files changed, 3 insertions(+), 8 deletions(-)
> > 
> 
> With CONFIG_KVM=y, CONFIG_KVM_AMD=y and CONFIG_CRYPTO_DEV_CCP_DD=m, I get
> the following build warning:

...

> In function ‘bitmap_zero’,
>     inlined from ‘__sev_recycle_asids’ at arch/x86/kvm/svm/sev.c:92:2,
>     inlined from ‘sev_asid_new’ at arch/x86/kvm/svm/sev.c:113:16,
>     inlined from ‘sev_guest_init’ at arch/x86/kvm/svm/sev.c:195:9:
> ./include/linux/bitmap.h:238:2: warning: argument 1 null where non-null expected [-Wnonnull]
>   238 |  memset(dst, 0, len);
>       |  ^~~~~~~~~~~~~~~~~~~

Ah, because that config "silently" disables CONFIG_KVM_AMD_SEV.  The warning
pops up because svm_sev_enabled() included !IS_ENABLED(CONFIG_KVM_AMD_SEV) and
that was enough for the compiler to understand that svm_mem_enc_op() was a nop.

That being said, unless I'm missing something, this is a false positive the
compiler's part, e.g. the warning occurs even if sev_enabled is false be default,
i.e. CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=n.

Anyways, I'm leaning towards "fixing" this by defining sev_enabled and
sev_es_enabled to false if CONFIG_KVM_AMD_SEV=n.  It'd be a worthwhile change to
condition the default values on CONFIG_KVM_AMD_SEV anyways, so it'd kill two
birds with one stone.  Long term, I'm tempted to exporing conditioning all of
sev.c on CONFIG_KVM_AMD_SEV=y, but there are just enough functions exposed via
svm.h that make me think it wouldn't be worth the effort.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1b9174a49b65..7e14514dd083 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,12 +28,17 @@
 #define __ex(x) __kvm_handle_fault_on_reboot(x)

 /* enable/disable SEV support */
+#ifdef CONFIG_KVM_AMD_SEV
 static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param_named(sev, sev_enabled, bool, 0444);

 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+#else
+#define sev_enabled false
+#define sev_es_enabled false
+#endif /* CONFIG_KVM_AMD_SEV */

 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
@@ -1253,11 +1258,12 @@ void sev_vm_destroy(struct kvm *kvm)

 void __init sev_hardware_setup(void)
 {
+#ifdef CONFIG_KVM_AMD_SEV
        unsigned int eax, ebx, ecx, edx;
        bool sev_es_supported = false;
        bool sev_supported = false;

-       if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev_enabled)
+       if (!sev_enabled)
                goto out;

        /* Does the CPU support SEV? */
@@ -1310,6 +1316,7 @@ void __init sev_hardware_setup(void)
 out:
        sev_enabled = sev_supported;
        sev_es_enabled = sev_es_supported;
+#endif
 }

 void sev_hardware_teardown(void)
