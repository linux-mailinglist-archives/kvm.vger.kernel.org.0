Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB7B487020
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 03:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344527AbiAGCCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 21:02:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23551 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344420AbiAGCCw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 21:02:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641520971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7e+sPs/b1j/CYZnqTqmIsGCLd5nxBuh/KrP4+Bx4Mso=;
        b=SPH02zvttm6E2RgHRXuPHitS3enxKgNQ0coXWfqv9DyHC4OxNiX33j2PKGISHR6/cwpcLN
        nxICJT0cusZweJMSKlHsqSfFsgduPmJkqOsZU6IFjir2fa+eH9fx0oL2qG57zn/thtsIZk
        NjEnZttPP+LLhJ4mZKoiPdV2eF3jzg8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-vsF0qHcFMumW8giNainmQw-1; Thu, 06 Jan 2022 21:02:50 -0500
X-MC-Unique: vsF0qHcFMumW8giNainmQw-1
Received: by mail-pj1-f71.google.com with SMTP id k13-20020a17090a3ccd00b001b356efebd6so1242702pjd.3
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 18:02:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7e+sPs/b1j/CYZnqTqmIsGCLd5nxBuh/KrP4+Bx4Mso=;
        b=e1S507+FQTB++YeSCFUlQRJ3CLhoSvNbbtU9qPbNdblohNc6Uh43znpo2NJcwSxVV+
         k4H8ufrNOE7gSSl6K5PYekZ9+Dfhp1XMMdNK9zfPeBFSPmTldHZP0uSl1xIZce+AWs53
         0zpodwpftceOYxythqUpq5NbStkuSS69rO/O5UiFtufbHmESzubdSN0kVHOi+d5KiBqB
         CZQbQoh8x3mTsJHJ4t7053Qf4NceeJDxbdV+9TL0qA+YO/ChI4jStVQE0Ez5YFOagvYi
         qOif4hvoCk6g+H+OiYJHXv29pOQQwNY+fU2MuTUeTSV8XC7D/Le789dnuJdxps9Ecqav
         Y6gA==
X-Gm-Message-State: AOAM532k1Q06HyJlCM0ZrfDXFIXmrCpt6JmqifgzrK138Ch2CUyHh/T2
        qMsqsRPR7DRi4pQHjPl0Yp03GmitQouJpqZmIX6E4a/6LlYGGWK115mGMPYoKvA/V3ZcqddUuHc
        cZOEnU+HNh6KN
X-Received: by 2002:a65:5b4b:: with SMTP id y11mr54799448pgr.59.1641520969174;
        Thu, 06 Jan 2022 18:02:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEWlAJnM2yMkz6/loDVwLYqUcjJCb18TZRuCXSJbW38s16yOJ2BL6uKuMMj1aio6Lg+qujDA==
X-Received: by 2002:a65:5b4b:: with SMTP id y11mr54799424pgr.59.1641520968806;
        Thu, 06 Jan 2022 18:02:48 -0800 (PST)
Received: from xz-m1.local ([191.101.132.79])
        by smtp.gmail.com with ESMTPSA id s25sm3378210pfg.208.2022.01.06.18.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 18:02:48 -0800 (PST)
Date:   Fri, 7 Jan 2022 10:02:40 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 09/13] KVM: x86/mmu: Split huge pages when dirty
 logging is enabled
Message-ID: <YdefQNIxNmKF5RB3@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-10-dmatlack@google.com>
 <Ydde9VE9vD/qo/wN@google.com>
 <CALzav=eOzX68FMjRDKAfu6N8Zp_WVkAF_OtJ99Dmb3V_kH2rWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=eOzX68FMjRDKAfu6N8Zp_WVkAF_OtJ99Dmb3V_kH2rWw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022 at 02:20:25PM -0800, David Matlack wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 85127b3e3690..fb5592bf2eee 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -187,6 +187,9 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
> > >  int __read_mostly pi_inject_timer = -1;
> > >  module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
> > >
> > > +static bool __read_mostly eagerly_split_huge_pages_for_dirty_logging = true;
> > > +module_param(eagerly_split_huge_pages_for_dirty_logging, bool, 0644);
> >
> > Heh, can we use a shorter name for the module param?  There's 0% chance I'll ever
> > type that correctly.  Maybe eager_hugepage_splitting?  Though even that is a bit
> > too long for my tastes.
> 
> Yeah I'll pick a shorter name :). I was going back and forth on a few.
> The other contender was "eager_page_splitting", since that's what I've
> been calling this feature throughout the discussion of this series.
> Although I can see the argument for adding "huge" in there.

I didn't raise this question when reviewing but I agree. :) I'll even go with
the shorter "eager_page_split" since the suffix "-ting" doesn't help anything
on understanding, imho; meanwhile "huge" is implied by "split" (as small page
won't need any split anyway).

-- 
Peter Xu

