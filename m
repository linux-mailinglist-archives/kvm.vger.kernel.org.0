Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCB1405CB9
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243659AbhIISOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244761AbhIISOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:14:19 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCA5C061756
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:13:09 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso2060840pjq.4
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oYzdplyM18KY0Rs8AvP7jRRMtS3fev77XkdskNX9cmc=;
        b=ZR+lGDI9LQg3dBtisyxTNm+HrbpIznzitrU0/yGTRHNMwChDKiR/owHUXKZTFgn/DW
         lDK+N+zsp3x/AcjIhqSh64wZcb/Fg4Um1uwRLHAf5ISFDW2KRa9ttt8Z1Rn4hqT9YX5c
         6J6gFEa93O2XZ3gmgfvfHywZwVUHzwRmdCdHW2malFgfBuBU3FAhksfJZESzKGjpX11g
         pJmYmOetRt5HuKgC+7I49jLfrUHg5jhqnRw0kiCmjldscemLhWTopFYo1Lbb3M9L7UUC
         zwa+C/MspbQlDyNCK78koAsA4WHdGMom9cWg+O0zfZKB6oiwtXKK8rSJ/b73ojpVzwah
         oTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oYzdplyM18KY0Rs8AvP7jRRMtS3fev77XkdskNX9cmc=;
        b=5aMr6Sornse/x6atwMu8DIfasKjPOTr1OJTf0yTuMlTEekeIfLTyed7E7J/g6W2Uix
         SbblHnTUjeywZVo5iMab+G/ZEkb30rXPbAcyyDlMpnIHqWDEX70yxwVIeieYUSKeBU/u
         GLEype3532AUrJ5RhPkLIK9la7fQvUaz2dMEir8nfotQipgTA+Go03N3I0Q7xPbScG9t
         RcuYQgRYxQc6/ggVnO2ORlt9oUDcJBqotapcy6R5QH1N+sQiPrSUiQ6qMtUi4WwuZSCU
         jHdqT+eI0aLY5yljs5fkJ06Kh4JPAWeecio2Hm4qW1JDq6PSMlRBp5Jd8XkXf8fcHIrl
         u3Pg==
X-Gm-Message-State: AOAM533mNJbIZ0YPz49xSjJMvNzWGcsG8wgW7fkkHXc87dEgYgth7cC7
        fBJ2CPtMJPyioLfgtvuMwjx3VA==
X-Google-Smtp-Source: ABdhPJwjxNZvs52Wb3cW5/9xyK/4w0Xli94hIemVpgz29jXOSyfDxRN91mAeYXb0+lxKj6DstTdWHg==
X-Received: by 2002:a17:902:7c93:b0:13a:a1e:dd2d with SMTP id y19-20020a1709027c9300b0013a0a1edd2dmr3821810pll.12.1631211189217;
        Thu, 09 Sep 2021 11:13:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h20sm2876865pfn.173.2021.09.09.11.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 11:13:08 -0700 (PDT)
Date:   Thu, 9 Sep 2021 18:13:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: move sev_bind_asid to psp
Message-ID: <YTpOsUAqHjQ9DDLd@google.com>
References: <20210818053908.1907051-1-mizhang@google.com>
 <20210818053908.1907051-4-mizhang@google.com>
 <YTJ5wjNShaHlDVAp@google.com>
 <fcb83a85-8150-9617-01e6-c6bcc249c485@amd.com>
 <YTf3udAv1TZzW+xA@google.com>
 <8421f104-34e8-cc68-1066-be95254af625@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8421f104-34e8-cc68-1066-be95254af625@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021, Brijesh Singh wrote:
> 
> On 9/7/21 6:37 PM, Sean Christopherson wrote:
> > On Tue, Sep 07, 2021, Brijesh Singh wrote:
> > > I have no strong preference for either of the abstraction approaches. The
> > > sheer number of argument can also make some folks wonder whether such
> > > abstraction makes it easy to read. e.g send-start may need up to 11.
> > 
> > Yeah, that's brutal, but IMO having a few ugly functions is an acceptable cost if
> > it means the rest of the API is cleaner.  E.g. KVM is not the right place to
> > implement sev_deactivate_lock, as any coincident DEACTIVATE will be problematic.
> > The current code "works" because KVM is the only in-tree user, but even that's a
> > bit of a grey area because sev_guest_deactivate() is exported.
> > 
> > If large param lists are problematic, one idea would be to reuse the sev_data_*
> > structs for the API.  I still don't like the idea of exposing those structs
> > outside of the PSP driver, and the potential user vs. kernel pointer confusion
> > is more than a bit ugly.  On the other hand it's not exactly secret info,
> > e.g. KVM's UAPI structs are already excrutiatingly close to sev_data_* structs.
> > 
> > For future ioctls(), KVM could even define UAPI structs that are bit-for-bit
> > compatible with the hardware structs.  That would allow KVM to copy userspace's
> > data directly into a "struct sev_data_*" and simply require the handle and any
> > other KVM-defined params to be zero.  KVM could then hand the whole struct over
> > to the PSP driver for processing.
> 
> Most of the address field in the "struct sev_data_*" are physical
> addressess. The userspace will not be able to populate those fields.

Yeah, that's my biggest hesitation to using struct sev_data_* in the API, it's
both confusing and gross.  But it's also why I think these helpers belong in the
PSP driver, KVM should not need to know the "on-the-wire" format for communicating
with the PSP.

> PSP or KVM may still need to assist filling the final hardware structure.
> Some of fields in hardware structure must be zero, so we need to add checks
> for it.

> I can try posting RFC post SNP series and we can see how it all looks.

I'm a bit torn.  I completely understand the desire to get SNP support merged, but
at the same time KVM has accrued a fair bit of technical debt for SEV and SEV-ES,
and the lack of tests is also a concern.  I don't exactly love the idea of kicking
those cans further down the road.

Paolo, any thoughts?
