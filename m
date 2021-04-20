Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8577F365FF9
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 21:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhDTTCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 15:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbhDTTCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 15:02:46 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97010C06138A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 12:02:14 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id e2so15877383plh.8
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 12:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+te0zyK/6o9CgwOTa7CwsrMyHqJ836TUK56r21df6iY=;
        b=teIMbwvsB6hvAnggsib1KJ2dDD798AUDpjrBzRrjCT18U/dQ4q22NwiLymRmQKG1oc
         VApiKpMpsXTArfuLB+SDPWX01q0EOpdfBqP0+3vK5cWZ09qy8PChwnePYbsPndcvCbbe
         yLE//gbxvWg1L4aL+Wanbiq0rh66pemZtDK/J4XiHmgpN1pJdMb7n640wy5w0AxLaYjv
         QeD4GScXpGVIYxlAZRI0NRmkbH9neUoHMiuYq+sORjt0jZ5AUqnIKdA1srTI5aawfXPm
         dGc4ZRxtCa89jhkDzCXLmVFkHB/G81cKKIsBrWtZqyc2d1Qo+0faDN68uu8hlThpNz11
         MuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+te0zyK/6o9CgwOTa7CwsrMyHqJ836TUK56r21df6iY=;
        b=CsOGMrRWaxeoDVNGeznFZnGezufWacNMaJJcuZIH9RFHKgth6sN/0cBmiEwxVwIv9w
         DBWrW34iuOoRX8u2VCW7JL7MI60uwIhx9kkxcRzksDNX11azJ5VrhN+2k8GCWI42c+bt
         mDke+ZHD0OfSyH3H1XTSqMBiTbK0DxSxBEOaZt1pliaQVrV3QjOn1iYvMD9RFIfWAE7Q
         4Sfom6pEt/V2GRoyzVV1tJjMBT91T8DTqE11DjL9n0CFnLaCyNJwDfS5gC7Nv8o3raCv
         MSB5qDcaCVvB24bP8j//KtIiCWzP1JSy1HhNro23KUcx3dGfwiepX+MxqRrF3gYnSmco
         GBiw==
X-Gm-Message-State: AOAM530Eu3J+TMaGqhsIKxGRlrUqOMYpV1pcsT+vTI1s27WelqGE+Qwo
        MozrHT1OYOgbZR0cDBpbIol/GA==
X-Google-Smtp-Source: ABdhPJxoKN+L/DeyMkN0aQH8rhqlpVo98jxLQV3USeNNLRG9P4L2Jq9XG6tjVoVEaNTAdHSPjpYmNw==
X-Received: by 2002:a17:90b:950:: with SMTP id dw16mr6634367pjb.68.1618945334034;
        Tue, 20 Apr 2021 12:02:14 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 33sm16389070pgq.21.2021.04.20.12.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 12:02:13 -0700 (PDT)
Date:   Tue, 20 Apr 2021 19:02:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, venu.busireddy@oracle.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org, Ashish Kalra <ashish.kalra@amd.com>
Subject: Re: [PATCH 0/3] KVM: x86: guest interface for SEV live migration
Message-ID: <YH8lMTMzfD7KugRg@google.com>
References: <20210420112006.741541-1-pbonzini@redhat.com>
 <YH8P26OibEfxvJAu@google.com>
 <05129de6-c8d9-de94-89e7-6257197433ef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05129de6-c8d9-de94-89e7-6257197433ef@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021, Paolo Bonzini wrote:
> On 20/04/21 19:31, Sean Christopherson wrote:
> > > +	case KVM_HC_PAGE_ENC_STATUS: {
> > > +		u64 gpa = a0, npages = a1, enc = a2;
> > > +
> > > +		ret = -KVM_ENOSYS;
> > > +		if (!vcpu->kvm->arch.hypercall_exit_enabled)
> > 
> > I don't follow, why does the hypercall need to be gated by a capability?  What
> > would break if this were changed to?
> > 
> > 		if (!guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
> 
> The problem is that it's valid to take KVM_GET_SUPPORTED_CPUID and send it
> unmodified to KVM_SET_CPUID2.  For this reason, features that are
> conditional on other ioctls, or that require some kind of userspace support,
> must not be in KVM_GET_SUPPORTED_CPUID.  For example:
> 
> - TSC_DEADLINE because it is only implemented after KVM_CREATE_IRQCHIP (or
> after KVM_ENABLE_CAP of KVM_CAP_IRQCHIP_SPLIT)
> 
> - MONITOR only makes sense if userspace enables KVM_CAP_X86_DISABLE_EXITS
> 
> X2APIC is reported even though it shouldn't be.  Too late to fix that, I
> think.
> 
> In this particular case, if userspace sets the bit in CPUID2 but doesn't
> handle KVM_EXIT_HYPERCALL, the guest will probably trigger some kind of
> assertion failure as soon as it invokes the HC_PAGE_ENC_STATUS hypercall.

Gah, I was thinking of the MSR behavior and forgot that the hypercall exiting
behavior intentionally doesn't require extra filtering.

It's also worth noting that guest_pv_has() is particularly useless since it
will unconditionally return true for older VMMs that dont' enable
KVM_CAP_ENFORCE_PV_FEATURE_CPUID.

Bummer.
