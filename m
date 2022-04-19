Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259B6507200
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 17:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353951AbiDSPl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 11:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353949AbiDSPly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 11:41:54 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEFA1A81F
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 08:39:11 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so2198603pjb.2
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 08:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1vxTWltnFUYt5Dk4evo+wcWUS62xdb37M8PxOFZacfU=;
        b=n38lT3LWIJFpEeBcBZJZiHfbgt1H+wZQE0RdJ/k1hL+1FljvL62oOEOS1SgzC4gsO2
         cWFPRU/kbypiQtYxe5wMXhTEeho0Vp9JZHyvfHIBPiFUCPov2nhiJMaoI1Q3sM+J7PA3
         dQdvBU/m17Ynjyex3Vd1W8cUZVzw5EL6yTmSsnYX80q0r9nMIc9v67xRrowYrrmxOPth
         KRmUAj8PGzv5Tx28MYqga47QHsnCx5ECLHqqSd7pc/Wm6CmU/wmJ9rpTHUBShst+v2ac
         fT6HGzlvJ4Nb9xoFTCXKbHUnQFEvo38cUHaDBCP5CyQ3GV/miH8kipN8ViMALJZNhRTI
         ux6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1vxTWltnFUYt5Dk4evo+wcWUS62xdb37M8PxOFZacfU=;
        b=YgUaPAyazYtkDCZvSMmwPYNWQRvziNW/a01co+DXUyX2aVgPtO3AskE6Y9uV1CR82d
         3ugVBTUrR2WWfYK/dMAcBBHqoJFkACSFa4pWx6P9hcAToy5GJvn8BkuPKly2YQVrZWZS
         xTBLMNjlzjFSVYy/INw+xj50RYhAut9NFhTzvp+wJcL6vha7jjdCDOd63VBaowV+i3sq
         sfcIgO5cwPrjUTPnY6IolSJVi/AU8zA2YJ8ujOWsHeJjXeuwjVIuyRhIIJST2JXHHZbu
         FqiPvSnmEEdMpbOcMcvViIt1aAAXnfsIfme6a4hFH6+4YhFWlOCtd52FCdXj9dMx/Zye
         jPwA==
X-Gm-Message-State: AOAM531ZK3CK2SIUlD1R+lNPWmS26I8hj3mQCdqAg0pHEk3YLagoue8R
        NQZGXV7Kzti6D0WC8QdOIrvf4g==
X-Google-Smtp-Source: ABdhPJychFbEeMiVIuVkAm+vsJc1zuaDyiThBFpxebPPl+SprxHwELqvAJtWGkG7DDinjx24JrLaGA==
X-Received: by 2002:a17:90b:383:b0:1cb:b7f1:9c69 with SMTP id ga3-20020a17090b038300b001cbb7f19c69mr24909853pjb.220.1650382750828;
        Tue, 19 Apr 2022 08:39:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p4-20020a637404000000b00375948e63d6sm16437568pgc.91.2022.04.19.08.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 08:39:10 -0700 (PDT)
Date:   Tue, 19 Apr 2022 15:39:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Anton Romanov <romanton@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
Message-ID: <Yl7XmmmuAZzNYiKq@google.com>
References: <20220414183127.4080873-1-romanton@google.com>
 <Ylh3HNlcJd8+P+em@google.com>
 <877d7l5xdc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877d7l5xdc.fsf@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > +Vitaly
> >
> > On Thu, Apr 14, 2022, Anton Romanov wrote:
> 
> ...
> 
> >> @@ -8646,9 +8659,12 @@ static void tsc_khz_changed(void *data)
> >>  	struct cpufreq_freqs *freq = data;
> >>  	unsigned long khz = 0;
> >>  
> >> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> >> +		return;
> >
> > Vitaly,
> >
> > The Hyper-V guest code also sets cpu_tsc_khz, should we WARN if that notifier is
> > invoked and Hyper-V told us there's a constant TSC?
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ab336f7c82e4..ca8e20f5ffc0 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8701,6 +8701,8 @@ static void kvm_hyperv_tsc_notifier(void)
> >         struct kvm *kvm;
> >         int cpu;
> >
> > +       WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_CONSTANT_TSC));
> > +
> >         mutex_lock(&kvm_lock);
> >         list_for_each_entry(kvm, &vm_list, vm_list)
> >                 kvm_make_mclock_inprogress_request(kvm);
> >
> 
> (apologies for the delayed reply)
> 
> No, I think Hyper-V's "Reenlightenment" feature overrides (re-defines?)
> X86_FEATURE_CONSTANT_TSC. E.g. I've checked a VM on E5-2667 v4
> (Broadwell) CPU with no TSC scaling. This VM has 'constant_tsc' and will
> certainly get reenlightenment irq on migration.

Ooh, so that a VM with a constant TSC be live migrated to another system with a
constant, but different, TSC.  Does the below look correct as fixup for this patch?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab336f7c82e4..a944e4ba5532 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8708,10 +8708,18 @@ static void kvm_hyperv_tsc_notifier(void)
        /* no guest entries from this point */
        hyperv_stop_tsc_emulation();

-       /* TSC frequency always matches when on Hyper-V */
-       for_each_present_cpu(cpu)
-               per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
-       kvm_max_guest_tsc_khz = tsc_khz;
+       /*
+        * TSC frequency always matches when on Hyper-V.  Skip the updates if
+        * the TSC is "officially" constant, in which case KVM doesn't use the
+        * per-CPU and max variables.  Note, the notifier can still fire with
+        * a constant TSC, e.g. if this VM (KVM is a Hyper-V guest) is migrated
+        * to a system with a different TSC frequency.
+        */
+       if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+               for_each_present_cpu(cpu)
+                       per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
+               kvm_max_guest_tsc_khz = tsc_khz;
+       }

        list_for_each_entry(kvm, &vm_list, vm_list) {
                __kvm_start_pvclock_update(kvm);

