Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333823906BB
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 18:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhEYQgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 12:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbhEYQgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 12:36:09 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392CCC061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 09:34:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso13475819pjb.5
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 09:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dXoi1LYFfpdbKWHNrkGgXE8yw6j2AtvMSaL5M8EYa9I=;
        b=ODZN+ptaC53QKg9tJEuMjkU3m5Yx14qJPW5cYXiVRcY8+hX/rwhVtCsH+c63nNBFS9
         AtZ/xK5eopky4Yx7CM092gDOdFWH7gCsKLsYCj29/GTXKzklI5saaEXu5PxdW/UrkIU/
         UfhIlam+PSaIBYZrmTQYnV55nlmHUpwMSsTmI3okckkiL+tzVbqlWsuT/08RJ7cYAFN9
         rkxm0UDy/Ie/Flsm+v76JpOA8Oh+ozNH3dhH3hiSluAbK+riAo2EQX0EICSoZTLPF9iQ
         wxsFhNsIKFmctQn7DdM9DyqUizZiMV2pYq1EIP0TcztGQlQLXBWD22F7pdybFjh10o7q
         9j6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dXoi1LYFfpdbKWHNrkGgXE8yw6j2AtvMSaL5M8EYa9I=;
        b=q0vQDO71SlpbAmkgjvHCi713bWWevuxePUU2EUKW4qWV+Z/vzZ3KEMW0NgXQXH/bpz
         BH9en9UJeY/Cvj1e/1Qcpe6i5STVgTgdRgAwmmfUi5fxAWmSzXrJmlv9JLohTjsbDNEo
         xh4+nbgeudOMOSHN5LckZJQ6R+/zt5IkhXPzBHENglmZ2I9FfzEw5V+bOQYNnXQVMbxW
         QihKgff9e4h5lkY/rdkm/d3AgGd08/Fi8LMOOM8UKYUpGg/ECurq4iBnwsiMnKiJz0B8
         OiAuhfrnuCLlpgovh5MB0cgTroI/RaYvfEQHG6yrbe74Mgg61whiS4pU8XBRMuEEv7GZ
         19MA==
X-Gm-Message-State: AOAM5334RP/KIxQPG9qvBiFhmuEV5Fdbs1TeLrKtOUFD2bkFZgXT5YhY
        G3vg0uiGSuYBFrelz6LTXJbaxlcaYit6tw==
X-Google-Smtp-Source: ABdhPJzEA1uqEwImTdL1LFcJBjNgn+HaTWAVrJOuGRaq71ZArHvalHJi9+QWbOpqw8wQJU6ukS046w==
X-Received: by 2002:a17:90a:7a89:: with SMTP id q9mr5628234pjf.0.1621960478568;
        Tue, 25 May 2021 09:34:38 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s184sm14527003pgc.29.2021.05.25.09.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 09:34:37 -0700 (PDT)
Date:   Tue, 25 May 2021 16:34:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Stamatis, Ilias" <ilstam@amazon.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH v3 09/12] KVM: VMX: Remove vmx->current_tsc_ratio and
 decache_tsc_multiplier()
Message-ID: <YK0nGozm4PRPv6D7@google.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
 <20210521102449.21505-10-ilstam@amazon.com>
 <2b3bc8aff14a09c4ea4a1b648f750b5ffb1a15a0.camel@redhat.com>
 <YKv0KA+wJNCbfc/M@google.com>
 <8a13dedc5bc118072d1e79d8af13b5026de736b3.camel@amazon.com>
 <YK0emU2NjWZWBovh@google.com>
 <0220f903-2915-f072-b1da-0b58fc07f416@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0220f903-2915-f072-b1da-0b58fc07f416@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021, Paolo Bonzini wrote:
> On 25/05/21 17:58, Sean Christopherson wrote:
> > > The right place for the hw multiplier
> > > field to be updated is inside set_tsc_khz() in common code when the ratio
> > > changes.
> 
> Sort of, the problem is that you have two VMCS's to update.  If properly
> fixed, the cache is useful to fix the issue with KVM_SET_TSC_KHZ needing to
> update both of them.  For that to work, you'd have to move the cache to
> struct loaded_vmcs.

vmcs01 and vmcs02 will get updated at enter/exit, if there's no caching then
it all Just Works.

> So you can:
> 
> 1) move the cached tsc_ratio to struct loaded_vmcs
> 
> 2) add a function in common code (update_tsc_parameters or something like
> that) to update both the offset and the ratio depending on is_guest_mode()
> 
> 3) call that function from nested vmentry/vmexit
> 
> And at that point the cache will do its job and figure out whether a vmwrite
> is needed, on both vmentry and vmexit.
> 
> I actually like the idea of storing the expected value in kvm_vcpu and the
> current value in loaded_vmcs.  We might use it for other things such as
> reload_vmcs01_apic_access_page perhaps.

I'm not necessarily opposed to aggressively shadowing the VMCS, but if we go
that route then it should be a standalone series that implements a framework
that can be easily extended to arbitrary fields.  Adding fields to loaded_vmcs
one at a time will be tedious and error prone.  E.g. what makes TSC_MULTIPLIER
more special than TSC_OFFSET, GUEST_IA32_PAT, GUEST_IA32_DEBUGCTL, GUEST_BNDCFGS,
and other number of fields that are likely to persist for a given vmcs02?

The current caching logic is just plain ugly and should not exist.
