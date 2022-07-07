Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5302256A69F
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 17:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbiGGPHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 11:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbiGGPG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 11:06:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB82F31DD3
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 08:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657206415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UinEqYT5P2BUTkxNTDp3jNgzt4lAPnjhnDB8MAsyPX4=;
        b=WL+zZQZV7fa46WHlfb48AbC0b3mWn6DON953PFGQtsG3On4CjHZuy7waENNFrs6+EXJopv
        gDWxGR0zIg3paFy9i/lErqgeyhmlCP2ucQGH4lsOMdD3HbxQyoFNiRWSBpwSERf9nwd2G3
        naixRzOHViUV327SROfXGJbWuX896wc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-PjLSW_oNNiGgbAzeC1nvTA-1; Thu, 07 Jul 2022 11:06:54 -0400
X-MC-Unique: PjLSW_oNNiGgbAzeC1nvTA-1
Received: by mail-qt1-f199.google.com with SMTP id d4-20020ac86144000000b00319586f86fcso15678572qtm.16
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 08:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UinEqYT5P2BUTkxNTDp3jNgzt4lAPnjhnDB8MAsyPX4=;
        b=8DSSYiJZDpIC5NDJiaj7gSqnDaJ3IB1yFKwcm6grhd+S5wpXDVnUhqClyxJsXEkl9Y
         PQbQHdxlWXWnTwjvAqrLdYgrE3Wgka6Q3XvPEh0PSUlRHC600ktSU6evC/Mcb6JsSV4M
         QJ3/dKHefFWNebDfODLBRpluvm0DVk6PFkA0hUFgtci/LNm40XSPyKZydU2YrNYLgp7M
         K0nvQJHkAOfxWyvQKHq1XgJdKneRLPqbqBhREtdD0smCLNo+dq2Y5H3dFIsz0Wo9T3b8
         JClDpJIWbcA4ksC2AihGRMUojyeMBWgJPsMrSJOTtFJqsxIRRNepHhKtvbWmnTwHJjt2
         SO8A==
X-Gm-Message-State: AJIora+uXfQ0Xq7EnOT/K+Hv5om2qbNzmiVnEyFyDmasyfZwPVMi1HQY
        ZgHZUmb12NLQ3IqNTVioHNcujH4qf93Maq9tGMZ/J715HPWdj6kyRvnrxj+g1YCq5asiZFnaTDm
        j3Lit11OSQx9z
X-Received: by 2002:a05:620a:1ed:b0:6b5:51ef:a01b with SMTP id x13-20020a05620a01ed00b006b551efa01bmr2234440qkn.672.1657206413983;
        Thu, 07 Jul 2022 08:06:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1veVQQ17tD7Ufgu37nRA9WzoyJWV+Q9os145bMm7/zYt0YRDhjZ/MSZMr+nKljNFfFJ65mMdA==
X-Received: by 2002:a05:620a:1ed:b0:6b5:51ef:a01b with SMTP id x13-20020a05620a01ed00b006b551efa01bmr2234378qkn.672.1657206413610;
        Thu, 07 Jul 2022 08:06:53 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-37-74-12-30-85.dsl.bell.ca. [74.12.30.85])
        by smtp.gmail.com with ESMTPSA id j17-20020ac84c91000000b002f39b99f6a4sm20992646qtv.62.2022.07.07.08.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 08:06:52 -0700 (PDT)
Date:   Thu, 7 Jul 2022 11:06:49 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Message-ID: <Ysb2iW/MniHX6BXL@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
 <YsNuMSuneND6KW3o@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YsNuMSuneND6KW3o@casper.infradead.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 04, 2022 at 11:48:17PM +0100, Matthew Wilcox wrote:
> On Wed, Jun 22, 2022 at 05:36:53PM -0400, Peter Xu wrote:
> > +/*
> > + * GUP always responds to fatal signals.  When FOLL_INTERRUPTIBLE is
> > + * specified, it'll also respond to generic signals.  The caller of GUP
> > + * that has FOLL_INTERRUPTIBLE should take care of the GUP interruption.
> > + */
> > +static bool gup_signal_pending(unsigned int flags)
> > +{
> > +	if (fatal_signal_pending(current))
> > +		return true;
> > +
> > +	if (!(flags & FOLL_INTERRUPTIBLE))
> > +		return false;
> > +
> > +	return signal_pending(current);
> > +}
> 
> This should resemble signal_pending_state() more closely, if indeed not
> be a wrapper of signal_pending_state().

Could you be more specific?  Note that the only thing that should affect
the signal handling here is FOLL_INTERRUPTIBLE, we don't allow anything
else being passed in, e.g. we don't take TASK_INTERRUPTIBLE or TASK_*.

Thanks,

-- 
Peter Xu

