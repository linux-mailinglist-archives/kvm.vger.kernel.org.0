Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA2C3792B1
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbhEJPaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbhEJP3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 11:29:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0311C061251
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 08:13:59 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l10-20020a17090a850ab0290155b06f6267so10242789pjn.5
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 08:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Y1KdAD1SHJv1YNjWpRn+4bVw4mSZfD7sO0/DVapSfM=;
        b=HV5vHRW6IBGVG1j476M254EywlT6j6j7J8qWfdR5X1n3+SMZZ/zXuWJ9qDKS1xaaS0
         hHRlHR+Eazz+aw5M5vAtvnWo2D38f7dVSj2F6jEJFt+QjcZAGeGY3njt2ETSyK1p4W0l
         UkgGCTnmIdZci2ZxnGU7NpHCypwG0aGE7JPucbO6ldx11T+hc9t7MMo2EUOML8Vg8/Uv
         R28HaHOy7/T7lKn6f63XmLrYydwjve8ftgbgsuztnCVpERie9HKG7ptDYcCJaWpOitpw
         vMVEbAz51nhVa0rKO44TsfB3mBeIpFXT61NU3oy9VNi8wl+/2v+njiL/AmATrNCmTb9V
         vs8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Y1KdAD1SHJv1YNjWpRn+4bVw4mSZfD7sO0/DVapSfM=;
        b=CGO8t13+b8ljGSuoRWAo0f6Bd46y7HF0XTbTpi5VWJYAIDgO8RDja7n/lZ2DML64cw
         GzIMTU5Mw20PSuk4B0q+fnh4CpXBHWhMofn0ErRpMCYiZCC8Ilgy1aYvNfgIR97dMv41
         GO8Q16XVy17ijimO0v4WzHTNyZb98WpYvz7jCthmpMRHfjjEaqaaXUpsE6DUGq9QgUdl
         CODWHwRNuyNbszb4yDwXAs+FmSG5xS4K7soz6DlNXvTvOIvYAErlzf7OKcAXykVEnkVc
         TZA8X1CvYkwhadASC+DdRVLFCUr6y8HW4UVsd7hG0gtDbaPBovP6scgGbJBVJTT2Y7Jm
         XTCQ==
X-Gm-Message-State: AOAM532jWF7Dk/R5nlN88lcrhU/2kDqYI+im1mCgPbUR4qTA7YxO6U9b
        xz1nbF0qmYPqgshS591MMzFk6Q==
X-Google-Smtp-Source: ABdhPJxwrdO4H1zGRZa2R82VK975IkIJ+LPRnF+U/P64bASwOPcwnpG0CsKzMuBRfuMyTzBLNNkpvw==
X-Received: by 2002:a17:902:7b82:b029:ee:f548:2a18 with SMTP id w2-20020a1709027b82b02900eef5482a18mr13850290pll.75.1620659639229;
        Mon, 10 May 2021 08:13:59 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id b21sm11012376pfl.82.2021.05.10.08.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 08:13:58 -0700 (PDT)
Date:   Mon, 10 May 2021 15:13:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 08/15] KVM: VMX: Configure list of user return MSRs at
 module init
Message-ID: <YJlNsvKoFIKI2V/V@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-9-seanjc@google.com>
 <db161b4dd7286870db5adb9324e4941f0dc3f098.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db161b4dd7286870db5adb9324e4941f0dc3f098.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021, Maxim Levitsky wrote:
> On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> > @@ -6929,18 +6942,10 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
> >  			goto free_vpid;
> >  	}
> >  
> > -	BUILD_BUG_ON(ARRAY_SIZE(vmx_uret_msrs_list) != MAX_NR_USER_RETURN_MSRS);
> > +	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
> > +		vmx->guest_uret_msrs[i].data = 0;
> >  
> > -	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
> > -		u32 index = vmx_uret_msrs_list[i];
> > -		int j = vmx->nr_uret_msrs;
> > -
> > -		if (kvm_probe_user_return_msr(index))
> > -			continue;
> > -
> > -		vmx->guest_uret_msrs[j].slot = i;
> I don't see anything initalizing the .slot after this patch.
> Now this code is removed later which masks this bug, 
> but for the bisect sake, I think that this patch 
> should still be fixed.

Egad, indeed it's broken.  I'll retest the whole series to verify the other
patches will bisect cleanly.

Nice catch!
