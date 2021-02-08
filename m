Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB123313AE2
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 18:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhBHR1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 12:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbhBHRZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 12:25:20 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F285FC061786
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 09:24:37 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id m6so10157537pfk.1
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 09:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5JsC9ioQB1vDAxY9MYIi/5R/vmSosGr84IdnVT/rTxk=;
        b=J3uwmNAuNWSn8lOfYgRjO3Pu/lh2GnaaTMnYiePeXLW5Olv6sMFKeYLUwQtU8d3Axb
         urjqcZnFc7KYsR0FqZDNNNZmALgrY94fbC4AYfUf52cG4WLCQv4UwomS5nUL6KgS/5ZX
         n1kX4SQk6KtucVdS2UCsrOTKNbjutcE/9AuC0MdqEEbExMSzQGavXLyx9ed4YzAchkvX
         GWRK9VTf9S9q3fgfBReEVaAIKu9o95KapCWHhNcax26k3xp/P9spsfdBm97BKinxolVR
         qDIRR1UVzF317G8WVLDrNmFh2AaRjIMgGFqk+z6W+SZf0Vs00MQiEAtPYXX0ay7jpJch
         Dwaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5JsC9ioQB1vDAxY9MYIi/5R/vmSosGr84IdnVT/rTxk=;
        b=nuqj0Tzwj37hfKrbub+0yOj8LgMQFA+NPoJWcbXX/ZTDBwKMC07iWX/rWdVnAoP6u0
         Ljo3W9Bid2i+Z6so3BE6CUjNwof5sEjEdJF/Kknzj4tPIgBusH7Qz4jdgkKYGzQNFgNI
         ZOlmF0+6Z4QQgYy3Uvg6Vr69ZwNyyfEGeHUIpaHIPRQaZM8Zk9f5PRFfBk064Qm7sxGd
         pvGc7kxMvH8b/WUNZFG7zNInb6kx+MKFlKDuU7SR0RvApU3bKjUV6nnsR7eG+uoxEw11
         xPeI36SqGMX0We8f93HmUwgO3AyipWb+FP564i/VnOLptTi2RqD/Mhi54Q2q3zpvVFWa
         35tQ==
X-Gm-Message-State: AOAM530vBfv4U27RiQVM9REkM7ib/HxXMKkyVNHBCwME960RvZOCWuqi
        msaDIOdFBnctyz3HzmQXNfLgiw==
X-Google-Smtp-Source: ABdhPJzJgGQnBysIV2VE39oFEVRBFqnH1GYdLOQHX2nkHNXfERYTCsJRlyP1t97PFR83+dWuJsF2AA==
X-Received: by 2002:a63:c4a:: with SMTP id 10mr18426228pgm.397.1612805077439;
        Mon, 08 Feb 2021 09:24:37 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e4db:abc1:a5c0:9dbc])
        by smtp.gmail.com with ESMTPSA id y75sm19106156pfg.119.2021.02.08.09.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 09:24:36 -0800 (PST)
Date:   Mon, 8 Feb 2021 09:24:30 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jing Liu <jing2.liu@linux.intel.com>, pbonzini@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] kvm: x86: Revise guest_fpu xcomp_bv field
Message-ID: <YCFzztFESzcnKRqQ@google.com>
References: <20210208161659.63020-1-jing2.liu@linux.intel.com>
 <4e4b37d1-e2f8-6757-003c-d19ae8184088@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e4b37d1-e2f8-6757-003c-d19ae8184088@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 08, 2021, Dave Hansen wrote:
> On 2/8/21 8:16 AM, Jing Liu wrote:
> > -#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
> > -
> >  static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
> >  {
> >  	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
> > @@ -4494,7 +4492,8 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
> >  	/* Set XSTATE_BV and possibly XCOMP_BV.  */
> >  	xsave->header.xfeatures = xstate_bv;
> >  	if (boot_cpu_has(X86_FEATURE_XSAVES))
> > -		xsave->header.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
> > +		xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
> > +					 xfeatures_mask_all;

This is wrong, xfeatures_mask_all also tracks supervisor states.

> Are 'host_xcr0' and 'xfeatures_mask_all' really interchangeable?  If so,
> shouldn't we just remove 'host_xcr0' everywhere?

I think so?  But use xfeatures_mask_user().

In theory, host_xss can also be replaced with the _supervisor() and _dynamic()
variants.  That code needs a good hard look at the _dynamic() features, which is
currently just architectural LBRs.  E.g. I wouldn't be surprised if KVM currently
fails to save/restore arch LBRs due to the bit not being set in host_xss.
