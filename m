Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C28E52865A
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 16:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243210AbiEPODf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 10:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiEPODd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 10:03:33 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00543915C
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 07:03:32 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c14so14136948pfn.2
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 07:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z2ZfS+9I/wy5JN0Sq7cHmJHxuA7sRrJdvs6Dlp91gDo=;
        b=gBL9REUt+JUXaQa8pxDv1sRIJQFSQTUfql9JI+c9aQj6dJqthI27vp5ESB4Ck90e4n
         sAAaCcF/IW8soholXn8GLNigLp7AoHvBksA/pIkTX6b8CxuSaU7Hvk2TPSS4hprgic5m
         2dew7nuz4aXhZ9HbqUgiT6Np2s6BfB2z5dH7aBAIh2vk3d3QYuFDcbWqpEAqmvQjC4LM
         o5xOOaOLKz4A2OwLYMcUmR9A8s+sWYNbBRDDjELF0WFnubC4o8gb4kga9LnoJZ5R9YK4
         X6mZWixuwrNdiGn6VvpkjmVhmCnctpWe+Ed+7oTq8ywN1CkqEormhLpjn1N0YL2mawZ8
         mYUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z2ZfS+9I/wy5JN0Sq7cHmJHxuA7sRrJdvs6Dlp91gDo=;
        b=XsodPKF4o+7JQRLNCslgYzdlfsqTCrvSOCXaP9oYeySgkAty32JCZL++ETMX8LwA8X
         gM91S47mUO8qRMC8UGOXhAOj5ZaFYwnimMUAnvr+fMy6L8pJMkt9TcAPmsiR8hof04H1
         L+b8GKK0F7a9esQdOMz/3WvoRArAzx4pDwIzFY2eIaYCdZuui+q35twUl4BHsiSxyjed
         UCXwpkDz5xkjR9IUW2pVFS8soIO/dahpUTqX9aZp8VPPZnL1zqycPj6X25X6GNSaPb4F
         k66Eor7QVoRZeKhOuXAApv/eMMUCmVq/8Ms9yjZEPbd26abS7uWUXaICUTfw8fPAOl7Y
         xafQ==
X-Gm-Message-State: AOAM533wu8LQrmbFx9X/CnBd3qsks98L/QemwS/2mMcxCARoT1rga+IU
        elzzW3HhqlLxCl7Obcd//AT9Bw==
X-Google-Smtp-Source: ABdhPJy2NKfocT0FlvBFbTqqn7/P9nwZ7had2nn7lhxLdZ4ljNIiqZN3BfYR70FMmWIwNiXkahbCbg==
X-Received: by 2002:a63:534b:0:b0:3db:aa8f:ff1e with SMTP id t11-20020a63534b000000b003dbaa8fff1emr12358168pgl.570.1652709811941;
        Mon, 16 May 2022 07:03:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b1-20020a056a000a8100b0050dc76281c1sm6929535pfl.155.2022.05.16.07.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 07:03:31 -0700 (PDT)
Date:   Mon, 16 May 2022 14:03:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: x86: fix a typo in __try_cmpxchg_user that caused
 cmpxchg to be not atomic
Message-ID: <YoJZsJvq3YQ4xTWN@google.com>
References: <20220202004945.2540433-5-seanjc@google.com>
 <20220512101420.306759-1-mlevitsk@redhat.com>
 <87e16c11-d57b-92cd-c10b-21d855f475ef@redhat.com>
 <Yn17urxf7vprODed@google.com>
 <f05dcf66ed2bfb7d113ce0d9a261569959265c68.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f05dcf66ed2bfb7d113ce0d9a261569959265c68.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022, Maxim Levitsky wrote:
> On Thu, 2022-05-12 at 21:27 +0000, Sean Christopherson wrote:
> > On Thu, May 12, 2022, Paolo Bonzini wrote:
> > > On 5/12/22 12:14, Maxim Levitsky wrote:
> > > > Yes, this is the root cause of the TDP mmu leak I was doing debug of in the last week.
> > > > Non working cmpxchg on which TDP mmu relies makes it install two differnt shadow pages
> > > > under same spte.
> > > 
> > > Awesome!  And queued, thanks.
> > 
> > If you haven't done so already, can you add 
> > 
> >   Cc: stable@vger.kernel.org
> 
> When I posted my patch, I checked that the patch didn't reach mainline yet,
> so I assumed that it won't be in -stable either yet, although it was CCed there.

Yeah, it should hit stable trees because of the explicit stable@.  The Fixes: on
this patch is likely enough, but no harm in being paranoid.

> > Also, given that we have concrete proof that not honoring atomic accesses can have
> > dire consequences for the guest, what about adding a capability to turn the emul_write
> > path into an emulation error?
> > 
> 
> 
> This is a good idea. It might though break some guests - I did see that
> warning few times, that is why I wasn't alert by the fact that it started
> showing up more often.

It mostly shows up in KUT, one of the tests deliberately triggers the scenario.
But yeah, there's definitely potential for breakage.  Not sure if a capability or
debug oriented module param would be best.  In theory, userspace could do a better
job of emulating the atomic access than KVM, which makes me lean toward a capability,
but practically speaking I doubt a userspace will ever do anything besides
terminate the guest.
