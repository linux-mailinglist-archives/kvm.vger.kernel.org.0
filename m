Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFE84001CA
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbhICPMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhICPMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 11:12:44 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A31C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 08:11:44 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d17so3471593plr.12
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 08:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ebfHuxIwvwqFrHzz6BrrYfEUJ6sepkxSECEtDDf1F6I=;
        b=hYVwZ/W5oNBiO3zw2SElrIEAev1w/2HK4duRmgpD0nT2OzFZ8MUxSr+q40Zq3VXccF
         feBLvv6tTfInZBbZEekB6BRt0gmzP91mH79Jt5bSWmk1kyn+b7tr+uWyRl5e+BRNzVAZ
         1UKpU10jwE9SGKyjK07pVcB4d7VTIAyse5wx4zYWBt3kali1nM52HZNTdWKhRqp26Wj/
         8w1hkaKWGYO3lh7tx/eKSiegjJuuVyP1KSnOGlJtA1ATkHG35fumE3ZhgTGtpUJpUD3+
         vAchPUKhvSGGPsEup76CjI3SgJYpfL7qnbZmExcIZJYa4WVEcUnuX1vrYrf2VQwhz5Nc
         stnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ebfHuxIwvwqFrHzz6BrrYfEUJ6sepkxSECEtDDf1F6I=;
        b=k1jRWSzAuIyt+FhyQxw+6d+ntq+lv/nYV3j1Y+eDT2+PfBRcQhRpBLKVT4HYj4HDwi
         Fc6DjSBgRlBFxHG5NRGhMfkzs5zKE4eU5/6UxpshVKG2ALE3ejJT4UauFeFNDHGQNxnA
         6REEYDwfiWJSW/z6FHlxgjEKMoizzbP3XPf7oCM2HtwAaWrPfYk+GysAfGwX76juDfE5
         fssNeDvaElCDPU+k596lcPFPGuoKhIYeWQtZlWUynOLx24EvHTs/hLhwGN7o31hNC6f+
         CdX5Cf0rNxN10JtOGVltrUXJ896JHF32lM2FYpHU1RB2fXOhXASwtTqc8k/VdwkXmA4r
         QhJg==
X-Gm-Message-State: AOAM5325rybWR2ZP+nrO7KKQ6vLdvRautC6C3aTQykUbUUx73kavF89M
        IXCbzFeLvn3MAsMW8gLCPtYSpg==
X-Google-Smtp-Source: ABdhPJwchIfU51uPNsj/zvl5lU0oiDlq3zPjoSDwwCQ1PNAZtZXZ96gvsXN/7TwfYRfB8+39az9b/g==
X-Received: by 2002:a17:902:ec06:b0:138:c3af:d085 with SMTP id l6-20020a170902ec0600b00138c3afd085mr3624841pld.56.1630681903451;
        Fri, 03 Sep 2021 08:11:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e13sm5671418pfi.210.2021.09.03.08.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 08:11:42 -0700 (PDT)
Date:   Fri, 3 Sep 2021 15:11:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <YTI7K9RozNIWXTyg@google.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
 <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
 <YRvbvqhz6sknDEWe@google.com>
 <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
 <YR2Tf9WPNEzrE7Xg@google.com>
 <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
 <YS/lxNEKXLazkhc4@google.com>
 <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021, Robert Hoo wrote:
> On Wed, 2021-09-01 at 20:42 +0000, Sean Christopherson wrote:
> > On Thu, Aug 19, 2021, Robert Hoo wrote:
> > > On Wed, 2021-08-18 at 23:10 +0000, Sean Christopherson wrote:
> > > > > My this implementation: once VMX MSR's updated, the update needs to
> > > > > be passed to bitmap, this is 1 extra step comparing to aforementioned
> > > > > above.  But, later, when query field existence, especially the those
> > > > > consulting vm{entry,exit}_ctrl, they usually would have to consult
> > > > > both MSRs if otherwise no bitmap, and we cannot guarantee if in the
> > > > > future there's no more complicated dependencies. If using bitmap,
> > > > > this consult is just 1-bit reading. If no bitmap, several MSR's read
> > > > > and compare happen.
> > > > 
> > > > Yes, but the bitmap is per-VM and likely may or may not be cache- hot
> > > > for back-to-back VMREAD/VMWRITE to different fields, whereas the shadow
> > > > controls are much more likely to reside somewhere in the caches.
> > > 
> > > Sorry I don't quite understand the "shadow controls" here. Do you mean
> > > shadow VMCS? what does field existence to do with shadow VMCS?
> > 
> > vmcs->controls_shadow.*
> 
> OK, I see now. But I still don't understand why is these shadow
> controls related to field existence. They not in
> handle_vm{read,write}() path. Would you shed more light? Thanks.

Hmm, you're confused because my comment about the controls shadows is nonsensical.
I conflated the vmcs->controls_shadow.* with vmx->nested.msrs.*.  Sorry for the
confusion :-/
