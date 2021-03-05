Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C0132F215
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhCESCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhCESCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:02:43 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE56DC061756
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:02:43 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id s23so2551367pji.1
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pa/ihPLMWiDPuAKfoSPXdVYkgFb1n3QQX5Inso9m03Q=;
        b=NhPdKrEGB310P7xnWhrvWnhZL8j8ZsPVVoxJqIu0Kwk+X4KeqvhGeXRdUAQ0dn2odO
         CeHF9a+JwLuM4s1/MbuFx7Tae+plUQ83sg+R3EpUzDonW2t+PevibvROEbKtzt2X1iQA
         r7F4xyvbE7penXK4rJ9hytfECTm8uIiWCDPAcH48YH0UN/ypweBOGuB+B27mm8TMXS8s
         WJASstNzd15dJl6KN7sfos/sJPKYtQan2b71yLvEZ934Cmmr7nqgN/6hE3jd/6zgrnpk
         llklek1yZfOpjPpxneElQmvliI1W2pt4HzxyHNEUe97K1plapo8i1nhiU9GC4ycMYmxy
         Uv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pa/ihPLMWiDPuAKfoSPXdVYkgFb1n3QQX5Inso9m03Q=;
        b=Tpg5DzSdEFO0SBZLbCRCqF4kfX9amLYlX1Y7tnx9vzWuwbGr4bxc21jbDhPOP2UuqK
         fZfoZyssOC4ZPyW+9LlcYdaWWiHKHpWcElNzmPmimNigLzpAbq6S7zJBG/WztALt8ZZn
         KihhMLqDDVx/QHIdJaYIBHg3xpKElpnBjOcoyjiQ0lM0DxRGXkGgYRU4Y5rA+Y339XDq
         CdKb4Abg7y0XUwsA7q312pg6Eu3yijzBfVGVmt9PlCCYGx49yz0nRFegYWI12/VBwRWi
         pARx1Uq7J17XY96YKlLdfcTUnnztCP/90AIwP9AGerpXeWIP/tBaek+afJlGF/wSwos9
         fElw==
X-Gm-Message-State: AOAM530GWxTGUgE8QHC9PIgcNNByi/xGUrKQj/rLGREiXn73Yavp4bPp
        tFiV9o8r08qtVifCqHuTwpS2hVs6byc2Jw==
X-Google-Smtp-Source: ABdhPJxeFm85FbgreUuwyw+nLyliAogr5aJbtlWWbpo8vrmV20B5WAt77gOU81uFWevk/IBloVHgyw==
X-Received: by 2002:a17:90b:804:: with SMTP id bk4mr11383248pjb.25.1614967363207;
        Fri, 05 Mar 2021 10:02:43 -0800 (PST)
Received: from google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
        by smtp.gmail.com with ESMTPSA id s1sm3089587pju.7.2021.03.05.10.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 10:02:42 -0800 (PST)
Date:   Fri, 5 Mar 2021 10:02:36 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 11/17] KVM: x86/mmu: Mark the PAE roots as decrypted
 for shadow paging
Message-ID: <YEJyPMpV1G1We7OM@google.com>
References: <20210305011101.3597423-1-seanjc@google.com>
 <20210305011101.3597423-12-seanjc@google.com>
 <d18e53f9-f8ce-9793-a3e7-ad945fd1f5f0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d18e53f9-f8ce-9793-a3e7-ad945fd1f5f0@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 05, 2021, Paolo Bonzini wrote:
> On 05/03/21 02:10, Sean Christopherson wrote:
> > @@ -5301,6 +5307,22 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> >   	for (i = 0; i < 4; ++i)
> >   		mmu->pae_root[i] = 0;
> 
> I think this should be deleted, since you have another identical for loop
> below?

Yes, rebase gone awry.  And the zeroing needs to be done after decryption.
Good eyes!

> Paolo
> 
> > +	/*
> > +	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
> > +	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
> > +	 * that KVM's writes and the CPU's reads get along.  Note, this is
> > +	 * only necessary when using shadow paging, as 64-bit NPT can get at
> > +	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
> > +	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
> > +	 */
> > +	if (!tdp_enabled)
> > +		set_memory_decrypted((unsigned long)mmu->pae_root, 1);
> > +	else
> > +		WARN_ON_ONCE(shadow_me_mask);
> > +
> > +	for (i = 0; i < 4; ++i)
> > +		mmu->pae_root[i] = 0;
> > +
> 
