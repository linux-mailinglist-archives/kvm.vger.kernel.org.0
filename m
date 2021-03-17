Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C503E33F5B8
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 17:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhCQQja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 12:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbhCQQjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 12:39:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D4CC06175F
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 09:39:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so3567112pjh.1
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 09:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2aEsli4hxPkyH4/4A9siZUi+g07BNBjf62n6nODEG14=;
        b=Y7fLTa0CGnCxFzVcdXXUjb1+a0hugeyoLYv3RUuinz5LJ+nsEoztEDC7GlxDtJhaDt
         IlHiym7onxV7Jc9mhNYBZauELeRTUFOafrNFb4+hYjnmRuYYujpqFC7LTJMLKEIVEGP9
         BunIie9no6fGJGXIDjfmYlX/x0PlZDRR8Zb+D5UNnlUrpGw1I6v7ATJD37lszIx16ldh
         4T0lFFy9jsuw31XWK7qPy+CyZYF0l46n1JqFQrEnlLdSczR+Q4oThiaUjeWUzwdpE3LL
         wqJaC7u5RVCACs6Woyps6oXbGywTsvcFX/0hBgk93XC5P8OkB8vokbbox5EtfG4ihlwp
         W+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2aEsli4hxPkyH4/4A9siZUi+g07BNBjf62n6nODEG14=;
        b=sGZwTOubgw9GYMMKEw4b7KLyF6wrAPd+Sl+07Od3RCBhZMeo178veGmG0q82O5+QMV
         k9/R0ZjOfUfdLEh5/AvfJkuGOCKLd1ipNYDm0IqYqlY/KZ974nx3X5gx86NP4R3/WYOC
         uJPbRCV1DtEL4WnrrcRFjfzXT6Orm8WBPp+G8ct5yxO83vKcRvXzMX4FowhSINcFzNRD
         59zrwrozGxgW6QfgfR7eQVTOrewIn5tjI+aQbO2RFNbUG958fHRcCzFq37z6qwWknbrZ
         kXSonQPmr0tcZ8LGrh+3VjZVOjk1SSSJAqVI1qUirwHgoMBDmQT0ELHkcby6K5fs2F0Y
         0A7w==
X-Gm-Message-State: AOAM531e5B9Bq9FZgQB40VAyql6R6O1umugtDmByEJwZ573xFM8eTp6T
        ONFRvqMQniF/3wUTfSVQheNpeQ==
X-Google-Smtp-Source: ABdhPJzMSgADjGdlmQhs5QYXcCvYdxRZHx9UdEO6C/M7lY9cXs0Kb9+fgyxKnRvB1F9W1asZTnsZ/A==
X-Received: by 2002:a17:902:8d8a:b029:e6:b2ea:9074 with SMTP id v10-20020a1709028d8ab02900e6b2ea9074mr5583901plo.30.1615999159840;
        Wed, 17 Mar 2021 09:39:19 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
        by smtp.gmail.com with ESMTPSA id b17sm20059834pfp.136.2021.03.17.09.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:39:19 -0700 (PDT)
Date:   Wed, 17 Mar 2021 09:39:12 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Yuan Yao <yaoyuan0329os@gmail.com>
Subject: Re: [PATCH 3/4] KVM: VMX: Macrofy the MSR bitmap getters and setters
Message-ID: <YFIwsP9gF19MyCm7@google.com>
References: <20210316184436.2544875-1-seanjc@google.com>
 <20210316184436.2544875-4-seanjc@google.com>
 <f4934b3e-4d5f-a242-e14f-ad5841079349@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4934b3e-4d5f-a242-e14f-ad5841079349@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 17, 2021, Paolo Bonzini wrote:
> On 16/03/21 19:44, Sean Christopherson wrote:
> > +	return (ret)true;						      \
> 
> I'm not sure if (void)true is amazing or disgusting, but anyway...

Definitely both.

> > +BUILD_VMX_MSR_BITMAP_HELPER(bool, test, read)
> > +BUILD_VMX_MSR_BITMAP_HELPER(bool, test, write)
> > +BUILD_VMX_MSR_BITMAP_HELPER(void, clear, read, __)
> > +BUILD_VMX_MSR_BITMAP_HELPER(void, clear, write, __)
> > +BUILD_VMX_MSR_BITMAP_HELPER(void, set, read, __)
> > +BUILD_VMX_MSR_BITMAP_HELPER(void, set, write, __)
> 
> ... I guess we have an armed truce where you let me do my bit manipulation
> magic and I let you do your macro magic.

Ha, mutually assured destruction.

> Still, I think gluing the variadic arguments with ## is a bit too much.

Heh, I don't disagree at all.  Honestly, I was surprised it worked, and couldn't
resist throwing it in because it's so absurd.

> This would be slightly less mysterious:
> 
> +BUILD_VMX_MSR_BITMAP_HELPER(bool, vmx_test_msr_bitmap_, read, test_bit)
> +BUILD_VMX_MSR_BITMAP_HELPER(bool, vmx_test_msr_bitmap_, write, test_bit)
> +BUILD_VMX_MSR_BITMAP_HELPER(void, vmx_clear_msr_bitmap_, read, __clear_bit)
> +BUILD_VMX_MSR_BITMAP_HELPER(void, vmx_clear_msr_bitmap_, write,
> __clear_bit)
> +BUILD_VMX_MSR_BITMAP_HELPER(void, vmx_set_msr_bitmap_, read, __set_bit)
> +BUILD_VMX_MSR_BITMAP_HELPER(void, vmx_set_msr_bitmap_, write, __set_bit)
> 
> And I also wonder if we really need to expand all six functions one at a
> time.  You could remove the third argument and VMX_MSR_BITMAP_BASE_*, at the
> cost of expanding the inline functions' body twice in
> BUILD_VMX_MSR_BITMAP_HELPER.

I'll play around with the macros to see if I can make them less obnoxious.  I
found it easier to differentiate between the read/write offset and the high/low
offset by building them one at a time.  I'll see if I can find a compromise.
