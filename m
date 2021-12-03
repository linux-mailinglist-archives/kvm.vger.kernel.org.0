Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E5C4680E7
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 00:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354388AbhLCXwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 18:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354443AbhLCXwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 18:52:11 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B556AC061359
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 15:48:46 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id j11so4587559pgs.2
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 15:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jZAmDHsC6a6B1+lUDqpdszqQCD3+V34qAynkOGNqzOs=;
        b=ZROJNDJMOq5eIJoHp0p2tGr6bzowIDKO97CIqwhIh2xybI8owSYD51r3cZQjUy7SMs
         /P40psd2IV5qDAXCOCYwHiSHhml5L0HIMnhaLZObQG+0Hv1TAktoB1btbfH4raGuMAMe
         ell0IVFfKq86nUJQpY0EZXb2dY9wbbgAGzMXedTAW+uehWC6uWCvbOHeg2kpnbzPykUN
         lX9e0y4K1FLLZBvfJWvyw8HhVNgXjG49W4LKgWJQwTZg4t1woSQEZRu5HpUtfTQJq5h8
         rwdbRyd+awbHRbi9DEg9SXwvQGC6Ubgqnzoyn+LSR2ttCXmaRK2RKHh6RimVCyhhdZs8
         i/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jZAmDHsC6a6B1+lUDqpdszqQCD3+V34qAynkOGNqzOs=;
        b=QCSEGZi7YjGIq0YS9ljM+qrGk26+8MegScD0PJHxKTZjPRa1+Rp9omEjxwEHraFx62
         FNmNzcYqmfvb72xzgaXlf+kpap416lgWgdH1j3+hC64s6MgmesF+X2x3TWSJHxpXbuDk
         NQeoHbbGJeWTFSn9Ztc8x6jTff9SUDQ82WepwW0W9tPhNGOndv+stTZ/1jf9eV+VOasx
         TRxPPZvdulGq6LqKVw9eBJK/+EcpigU7cjwfcBhB9BBWWPN5nV/wPKJNXxYVN8uIx0ja
         9osAWtnwSi81IEjTrPAEXJJ0V3Jo+LPL02J+6RCV4L45r4R+VbXUdKhT179hpysUHe7r
         BeXQ==
X-Gm-Message-State: AOAM530D2hKx98FYFslYcFr6mPAMwnVxt+x6slFA4MpGP0gtL9XqPGzf
        DYTjNJGVKbTgg3mROchgN8vZoA==
X-Google-Smtp-Source: ABdhPJxiSrEcmRBZRtgKjhJMnu5tJLdEcIhiCx8GQtfxumShdLMvRSAXNQRAKE0vEMsLMNwHj3EJRQ==
X-Received: by 2002:a05:6a00:2353:b0:4ab:1694:6f50 with SMTP id j19-20020a056a00235300b004ab16946f50mr6815870pfj.7.1638575326038;
        Fri, 03 Dec 2021 15:48:46 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm4164413pfu.205.2021.12.03.15.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:48:45 -0800 (PST)
Date:   Fri, 3 Dec 2021 23:48:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ajay Garg <ajaygargnsit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 7/8] KVM: x86: Reject fixeds-size Hyper-V hypercalls
 with non-zero "var_cnt"
Message-ID: <Yaqs2uIiAoyfbdbX@google.com>
References: <20211030000800.3065132-1-seanjc@google.com>
 <20211030000800.3065132-8-seanjc@google.com>
 <87y268jhm1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y268jhm1.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 01, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > @@ -2331,6 +2331,11 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >  			ret = HV_STATUS_OPERATION_DENIED;
> >  			break;
> >  		}
> > +		if (unlikely(hc.var_cnt)) {
> > +			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> > +			break;
> > +		}
> > +
> 
> Probably true for HVCALL_RESET_DEBUG_SESSION but I'm not sure about
> HVCALL_POST_DEBUG_DATA/HVCALL_RETRIEVE_DEBUG_DATA (note 'fallthrough'
> above) -- these are not described well in TLFS.

I'll drop the check for all the DEBUG hypercalls and add a note in the changelog
to call out that they're probably not supposed to use var_cnt, but that the TLFS
documentation isn't clear one way or the other.
