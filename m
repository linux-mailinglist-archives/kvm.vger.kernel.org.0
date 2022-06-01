Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0C153AF4F
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 00:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiFAUvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 16:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiFAUvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 16:51:12 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C63B1451F4;
        Wed,  1 Jun 2022 13:49:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id d12-20020a17090abf8c00b001e2eb431ce4so3134322pjs.1;
        Wed, 01 Jun 2022 13:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u0H1kLA3X1D/SLwx0igAK0OoRemdRuXz90z2O1rY8PM=;
        b=LbzXBKG/3AC7CStS9n9FMm43vi8rWlovWBnsj47xHclZl5/pan1dNzcD79FRTdBQy4
         LLjGJJSHG7MpelcW6NJj2Ug9i96pcjZMeiosnm9RqrEn4ZGO4yYV/DIZ2l+8I5V//XQi
         I689jl+ZksPGn9JCQYmlVzvRrSZDFMDGAyHL3RR/oZiYNHZMla6RiEuQ3Yagjj6UT4Us
         0+HRe9aJ9seU1DvPWBamQ1y3hKGmIORVJqGZoxvgDmnkglt9DADvCMOBx0hZab9xSLI4
         gAkHmU6VJOKdVVv41J18zkCOskA++3gOzOyDdYW/iXIVo/IIknjYXIEyAHdvgYDC6X0S
         sMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u0H1kLA3X1D/SLwx0igAK0OoRemdRuXz90z2O1rY8PM=;
        b=ERSWvxLUi9tiNWpBtVCYCXNa2KDQIY1HrHcCaL+pVsDYZl4uIG5QwSOAwH3wsELdVy
         zmzCFljhUbtdw7kZVyKifteHIe5nkJkQuqXqpJcsLz+T5kb/cuXTPi9U42Ow0cB81aym
         Xpj492SXOK4lDokLyi37/4f1OUM56niPgTRyr50AvJWhKpJMI7QVr3hvNlyDqr3zA13F
         GDa31za8rfWO2tNhlM+UeTiqxtabnCvEKE7tBJEucsbv49JcDnJGTvyRVrdrpJrdtGpM
         fYntPXYgfJz6ib2GDgR7f4E1FdbI26r/UB2mRS2vv+A0xJB8rBX9Cn/fY25MqUh24uJz
         6GCA==
X-Gm-Message-State: AOAM533HTxRsbcvjX0WfiZU9Vw+3ooBrnCUosG9Zwa7TAS9VJ/6j3IFs
        rW5APcB/HJLkjfsAOgTP6yI=
X-Google-Smtp-Source: ABdhPJx0qbahqePV0XhWwyGoAmhKsdikmawwN30TCtH8lrhNXSQQ3NMpLjDHl2mHl1WKo7nTzug7Kw==
X-Received: by 2002:a17:903:11d0:b0:155:c240:a2c0 with SMTP id q16-20020a17090311d000b00155c240a2c0mr1255102plh.143.1654116560147;
        Wed, 01 Jun 2022 13:49:20 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id jg15-20020a17090326cf00b001640594376dsm1934150plb.183.2022.06.01.13.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 13:49:19 -0700 (PDT)
Date:   Wed, 1 Jun 2022 13:49:17 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [RFC PATCH v6 047/104] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <20220601204917.GA3778155@ls.amr.corp.intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <653230043fdb2d20e871e79e73f757134ca92eeb.1651774250.git.isaku.yamahata@intel.com>
 <2d2a9789-083c-7e58-4628-8ebd024bee1f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2d2a9789-083c-7e58-4628-8ebd024bee1f@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 27, 2022 at 07:38:57PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 5/5/22 20:14, isaku.yamahata@intel.com wrote:
> > +/*
> > + * Private page can't be release on mmu_notifier without losing page contents.
> > + * The help, callback, from backing store is needed to allow page migration.
> > + * For now, pin the page.
> > + */
> > +static bool kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> > +				    struct kvm_page_fault *fault, int *r)
> > +{
> > +	hva_t hva = gfn_to_hva_memslot(fault->slot, fault->gfn);
> > +	struct page *page[1];
> > +	unsigned int flags;
> > +	int npages;
> > +
> > +	fault->map_writable = false;
> > +	fault->pfn = KVM_PFN_ERR_FAULT;
> > +	*r = -1;
> > +	if (hva == KVM_HVA_ERR_RO_BAD || hva == KVM_HVA_ERR_BAD)
> > +		return true;
> > +
> > +	/* TDX allows only RWX.  Read-only isn't supported. */
> > +	WARN_ON_ONCE(!fault->write);
> > +	flags = FOLL_WRITE | FOLL_LONGTERM;
> > +
> > +	npages = pin_user_pages_fast(hva, 1, flags, page);
> > +	if (npages != 1)
> > +		return true;
> > +
> > +	fault->map_writable = true;
> > +	fault->pfn = page_to_pfn(page[0]);
> > +	return false;
> > +}
> > +
> 
> This function is present also in the memfd notifier series.  For the next
> postings, can you remove all the KVM bits from the series and include it
> yourself?

Sure.
For next post, do you want to KVM patch series based on memfd notifier series?
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
