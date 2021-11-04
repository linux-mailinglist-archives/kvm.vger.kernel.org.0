Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DE2445C88
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 00:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhKDXHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 19:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhKDXHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 19:07:39 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B65C061203
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 16:05:00 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id l3so5297596pfu.13
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 16:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c4Bb1dfEPDdzci1tZFjbFRtp5Abr6nE775hg2DDtBYY=;
        b=srg0TNbzfRepxeomjd2u4SpB0ERVKTNwffeZ4TKcgZEWphFa8O1NImBjZmz6uGBfov
         Cw1gTU9vGZ5pSJM+BtD0CXhMqtRDz16r+E3aPp0h6LzK7b9gvkVROZPxi6AmB3KE2Hxl
         OrTL0B2s3rXsg8oBJySzsnbFYP/aPRB2vPop8dFZuWgyjyzKpxHpOoEVq6rEQkl6adQC
         DpVyWHeWxqOA+aui7On7JdaN3F9XfAnTdoMluJgxARHAqa/iv5E3R5WKy0pm08CN9ZLE
         dmRAnoi/Cht/1XyRPD8ekvC812hplwFSTL7IqSnzBNFt1NOHUKmxfCURqnwllDjrb1n5
         blQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c4Bb1dfEPDdzci1tZFjbFRtp5Abr6nE775hg2DDtBYY=;
        b=pYILpul7hnjWz2c3aH3RA9cSpswAzJJ1z19zeGKb5CPTtFIqRsZioARejiXPjUwmcp
         idWPYx9mjOTipaIzpebfe2RapTnbW7CGwzycqOJAp+OJXPx4berVW36s5v1N/ztrf110
         j4BrmLT7AdrU0J8Vsp6jDPAdEEyhUmMVOH9hK76Ys+FD4OAI1sfRwp0xMrHdN5gcoPQs
         6vGicMUyXPno3Rxbsqt/ZLCnc7AmCjwUr7ayKZdWBUoQNV7rC+zudDo8DZkfao33yZCr
         mdd5XOQ5oc8MYGu8r3poLtVyLKYnvcrxIwE1GgYPbcUXTjX6iVwsL43tMFfgq4gSOAXe
         GKDw==
X-Gm-Message-State: AOAM531iBVxwbesuZGzdEZTO6HpvxoZN2tmT2sUq0CZ1jGYxvn/a7HLV
        uQPKpFSZ+wTHPjd+hrlclUCm3Q==
X-Google-Smtp-Source: ABdhPJwuIOHRA2np1L1DpNIMnFkSKuPi9K1siKfpH0XRidcW0LJjODw8d94v6jXGw3f2UOEh2xZEDw==
X-Received: by 2002:a62:30c7:0:b0:44c:1ec3:bc31 with SMTP id w190-20020a6230c7000000b0044c1ec3bc31mr56192384pfw.21.1636067099700;
        Thu, 04 Nov 2021 16:04:59 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f11sm4618135pga.11.2021.11.04.16.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 16:04:59 -0700 (PDT)
Date:   Thu, 4 Nov 2021 23:04:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V11 2/5] KVM: SEV: Add support for SEV intra host
 migration
Message-ID: <YYRnF00iE15hd5UV@google.com>
References: <20211021174303.385706-1-pgonda@google.com>
 <20211021174303.385706-3-pgonda@google.com>
 <YYRZq+Zt52FSyjVW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYRZq+Zt52FSyjVW@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 04, 2021, Sean Christopherson wrote:
> On Thu, Oct 21, 2021, Peter Gonda wrote:
> > +	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
> > +		ret = -EINVAL;
> > +		goto out_source;
> > +	}
> > +	ret = sev_lock_vcpus_for_migration(kvm);
> > +	if (ret)
> > +		goto out_dst_vcpu;
> > +	ret = sev_lock_vcpus_for_migration(source_kvm);
> > +	if (ret)
> > +		goto out_source_vcpu;
> > +
> > +	sev_migrate_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
> > +	kvm_for_each_vcpu(i, vcpu, source_kvm) {
> 
> Braces not needed.
> 
> > +		kvm_vcpu_reset(vcpu, /* init_event= */ false);

...

> That way the source vCPUs don't need to be locked

Scratch that particular idea, I keep forgetting the SEV-ES support needs to lock
the source vCPUs to transfer state.
