Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52754467147
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 05:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhLCFBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 00:01:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhLCFBG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 00:01:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638507462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XaG12ubYE6ngbdheeEwWE4DGS+ZWBFAUkKRVGo3LS/w=;
        b=TeBoJPP3kRxi+2FHY+w/ef6V6MaB6uosggt2ASwYm6CZJE3nXvySWcZe9ri6a6Y5++8AtQ
        bGsvHKa2HkS3l5h1oUt6Y64qvNoTQIwwlWnva9Ha2VBxnhhzZxaVR1k5A6YMTuz6tbkP/F
        k84dFle8z2cKsproVc84UWxwhFJ9sKo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-7U0ELZXzMTmeWkXgRGg6OQ-1; Thu, 02 Dec 2021 23:57:41 -0500
X-MC-Unique: 7U0ELZXzMTmeWkXgRGg6OQ-1
Received: by mail-wm1-f72.google.com with SMTP id r129-20020a1c4487000000b00333629ed22dso2814456wma.6
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 20:57:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XaG12ubYE6ngbdheeEwWE4DGS+ZWBFAUkKRVGo3LS/w=;
        b=hBgHRhbvifeoSmH0evD2Xs4oPOd9msW77appl+q57zA1Jno5TF3me8iYKLnUjCDevz
         18AeO81uxNdj7EXafBMJPNCWSqyECMQD5/v+x2rTq0rLxg5gqlPKoCOpj4C/+uBp4AOc
         nTahCGXiEWJJGaKSiAvQLKsofWYn8vGU6AFHbyFk61b45V9xsQMIE5NsjMSBBjCxVHB3
         v3lFR0qad/CMl9BoPjRzT6xmQIUOtMN62YC728scz5PwWLP8v74jBLAfW5GDEonPtBDy
         7fREg1unm/0fAMxoM1ku3ApXUZt7fpMFJFFUnlBF/zirkM2iKgK1hggGxioLDxuoqdxH
         WPwg==
X-Gm-Message-State: AOAM532GNJAPm6Ek/HgiH8RfA8Kt/fuKUfM0IOq23Deb4Y4hP/zkvy+T
        Weg54JBSfrGekK5X+gW67t+RaKWTtInkKq1ZHT3tW+pq8WCz17Jb0IQdsjvN/rqpPOBSxaCFlcF
        mecNY1HE9lRVI
X-Received: by 2002:a5d:4563:: with SMTP id a3mr19103887wrc.130.1638507460551;
        Thu, 02 Dec 2021 20:57:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwiRtsiGLJhbwI3cEymcTSZvr9YNwLpNElvMUCWxxWEeRj7X0y8qvM8PJ7bxqtbhLayBQZhlg==
X-Received: by 2002:a5d:4563:: with SMTP id a3mr19103874wrc.130.1638507460392;
        Thu, 02 Dec 2021 20:57:40 -0800 (PST)
Received: from xz-m1.local ([64.64.123.26])
        by smtp.gmail.com with ESMTPSA id 21sm1422838wmj.18.2021.12.02.20.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 20:57:39 -0800 (PST)
Date:   Fri, 3 Dec 2021 12:57:32 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during
 CLEAR_DIRTY_LOG
Message-ID: <YamjvO+vCO2PAWyr@xz-m1.local>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-14-dmatlack@google.com>
 <YaDQSKnZ3bN501Ml@xz-m1.local>
 <CALzav=fVd4mLMyf6RBS=yDuN+hMM0hoa7+YHdYucRcJDjD4EfA@mail.gmail.com>
 <CALzav=ex+5y7-5a-8Vum2-eOKuKYe=RU9NvrS82H=sTwj2mqaw@mail.gmail.com>
 <Yab0JRVmwyr1GL3Y@xz-m1.local>
 <CALzav=etCjq=9BukQ4vF49wOsE+pdGRGLHqy5jfzFaeHaZBoUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=etCjq=9BukQ4vF49wOsE+pdGRGLHqy5jfzFaeHaZBoUg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021 at 02:14:27PM -0800, David Matlack wrote:
> > > > Thanks for calling this out. Could the same be said about the existing
> > > > code that unconditionally tries to write-protect 2M+ pages?
> >
> > They're different because wr-protect can be restored (to be not-wr-protected)
> > when vcpu threads write to the pages, so they need to be always done.
> 
> That's true for 4K pages, but not for write-protecting 2M+ pages
> (which is what we're discussing here). Once KVM write-protects a 2M+
> page, it should never need to write-protect it again, but we always
> try to here. Same goes with splitting.

Ah I see, that's fair point. :)

Yeah let's see how it goes with the numbers, I'd hope it's trivial to do both
wr-protect 2m and the split unconditionally, because for CLEAR_LOG the major
overhead should be walking the small pages instead, afaiu.

-- 
Peter Xu

