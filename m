Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DD145A251
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 13:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbhKWMTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 07:19:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229939AbhKWMTa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 07:19:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637669782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0lTu4UDtxs9G6akE9Ez/8GeGccVaaleJp/KA7PEeCZI=;
        b=RjaVebfbaJBsetzJUGoxL5r2qtfOWKt1mONywQpz6T2146e0VNuf2SpX0HPDU/DNRUoD71
        zZJ88x/tn3GJfoLo0z9D1gpeTuO1aMz/N/OEB4GI1wyA8K18+9HjVEdV4DPZil4Adx+bvu
        D9LH2JrLRfOZ/OEbHF4L9Uj8vKzYnME=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-Bs2hW7wxOpO7rKc5JVGstw-1; Tue, 23 Nov 2021 07:16:21 -0500
X-MC-Unique: Bs2hW7wxOpO7rKc5JVGstw-1
Received: by mail-pj1-f72.google.com with SMTP id u11-20020a17090a4bcb00b001a6e77f7312so1268743pjl.5
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 04:16:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0lTu4UDtxs9G6akE9Ez/8GeGccVaaleJp/KA7PEeCZI=;
        b=onGHM+jZ28LBVQ9qoFVTE1Yc0Ar4IOtx2Npx1cAcZ5DTiHmumuOD6rpBJ1kd5vUFrn
         6rIQWBdcsgg0wOanwAfaDQtpOYqvRBxr1q1lZyHF3GxwO9YltXl5tFFD8Y25hqvh54Y0
         Ec0QznAno0geh+0ihganCAySYhmWszs68wu+Ly8bPIfCR3Padk4xRkX7LQY3MO54S19P
         xGQOozG3n02aKlFkxc1c87XDEJ+vYIvJNgUzLaats3IbE9U7M56W/iIRG900snFmLCLH
         aG2lUQz7fSbJs0Fq7zFkKH6iS6Bp/zIzo0pxGd9oNwxB0zAGxdsScBeZeU3Hr7LefqXK
         1Ghw==
X-Gm-Message-State: AOAM531D+xoECJlnvc72tr3oD4KSRnYW8qH7xcvuDWpRCQSYHOGUrZ5N
        JRNflVpc4JHvfeI2MeeUPcAAQgOLRTbU5XbDz28Rws1TtIInssTIz3Am45XpaqCMhw3hFJBO3Jf
        ubysR6hz9hIJv
X-Received: by 2002:a62:7c8b:0:b0:49f:a8ae:de33 with SMTP id x133-20020a627c8b000000b0049fa8aede33mr4665106pfc.29.1637669779922;
        Tue, 23 Nov 2021 04:16:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzXoQ6l69oslSPduxOpj5oSb0/wv8X2UapMrfGsTgsa2jNnmdantJusdefawcE93caP/ffL5g==
X-Received: by 2002:a62:7c8b:0:b0:49f:a8ae:de33 with SMTP id x133-20020a627c8b000000b0049fa8aede33mr4665066pfc.29.1637669779657;
        Tue, 23 Nov 2021 04:16:19 -0800 (PST)
Received: from xz-m1.local ([191.101.132.71])
        by smtp.gmail.com with ESMTPSA id b4sm13267412pfl.60.2021.11.23.04.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 04:16:19 -0800 (PST)
Date:   Tue, 23 Nov 2021 20:15:57 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: RFC: KVM: x86/mmu: Eager Page Splitting
Message-ID: <YZzbfYeVSJ/rPTuI@xz-m1.local>
References: <CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com>
 <bc06dd82-06e1-b455-b2c1-59125b530dda@linux.vnet.ibm.com>
 <YYmRpz4dQgli3GKM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YYmRpz4dQgli3GKM@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 08, 2021 at 09:07:51PM +0000, David Matlack wrote:
> On Fri, Nov 05, 2021 at 06:17:11PM +0100, Janis Schoetterl-Glausch wrote:
> > On 11/4/21 23:45, David Matlack wrote:
> > 
> > [...]
> > > 
> > > The last alternative is to perform dirty tracking at a 2M granularity.
> > > This would reduce the amount of splitting work required by 512x,
> > > making the current approach of splitting on fault less impactful to
> > > customer performance. We are in the early stages of investigating 2M
> > > dirty tracking internally but it will be a while before it is proven
> > > and ready for production. Furthermore there may be scenarios where
> > > dirty tracking at 4K would be preferable to reduce the amount of
> > > memory that needs to be demand-faulted during precopy.
> 
> Oops I meant to say "demand-faulted during post-copy" here.

Sorry to join late, but this does sound like an interesting topic, too.

Hopefully assuming postcopy will be enabled in just a few iterations of
precopy, write amplification could hopefully be a much smaller problem, so the
mostly-static pages can still be successfully migrated during precopy.

Please share more information when there is, and I'll be very interested to
learn.

Thanks!

-- 
Peter Xu

