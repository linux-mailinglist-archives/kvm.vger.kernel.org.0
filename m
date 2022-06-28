Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A77A55F1BF
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 01:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbiF1XCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 19:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiF1XCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 19:02:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F05563A71B
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 16:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656457357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BILLrOx0KBGDparaBoWGr82nDo23bdigh/cJQEB6on8=;
        b=Qz37mzWj40qCqjlnQ0yjevPZNubWrZEZc+U0xKZW3dGMLCB1mwKk2CcH2ytof2+UNsVyCM
        4d1XbnlIjWCzKqlTF1HUHQL7Cw5Y3+bl1aHGN2OJzdmBkiRoIIUi9opVR2Y6D/P5lyZIqM
        G4MCIFuBBxVtTFXDOIfsfwun6JPIVE0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-LsOqHyljNS-lL0E4UOaxhQ-1; Tue, 28 Jun 2022 19:02:35 -0400
X-MC-Unique: LsOqHyljNS-lL0E4UOaxhQ-1
Received: by mail-il1-f198.google.com with SMTP id q17-20020a056e02079100b002da727ae897so6300623ils.21
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 16:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BILLrOx0KBGDparaBoWGr82nDo23bdigh/cJQEB6on8=;
        b=hJBmCiVh8s7PiA1KxKcVlTXlp/DIEH4Obv1WkSf0TF9C8EOfVRWrKtnrNLlnqIzb8w
         kkyz2jrhReKu3Zay66pzXJ3lUwW/rsmFChsN6Etn/70SDXXzw0Ud9sqik7DZe1uoEw6X
         Bc4L3uVx/X0Z1nuGJ3C/7SL/LKyKgkPQyIoFsJ1+WPpVK8f9nQX5qH4MDt+w7AEtnIXT
         QYwIfSGPqoMpmbpTrEnS98GjN0qRuz13dJkWg9SRUoPOfaCS8iOI889x8BRBMujc4aAa
         TkKzNt6TX7rI95MnYPntgBY+n7yJczmiGpJqh9knuC6tY4i/DZcz/08Me9yXg9jTFT0N
         JrmA==
X-Gm-Message-State: AJIora83YcesAAyro4+bEQemvWyMXjQWU5gWZhpbaq8pKZsgGzmiCYFh
        gv/LmUKeHS80AQtEuKWpH0DEymkvd1SYCIp4uhoUIYbZgwlpp5bo049btvtj0coQz/yfV//yYMK
        xWNR3Xs0tPIi4
X-Received: by 2002:a05:6638:1446:b0:331:e0cc:bd15 with SMTP id l6-20020a056638144600b00331e0ccbd15mr289906jad.89.1656457354977;
        Tue, 28 Jun 2022 16:02:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sktsRJzoU53vy6uKrBPRFlirO/gd0xp0mF0YJcR9N5sGdjb8aEiG+AA9O8limDyR6fBWNUhA==
X-Received: by 2002:a05:6638:1446:b0:331:e0cc:bd15 with SMTP id l6-20020a056638144600b00331e0ccbd15mr289894jad.89.1656457354776;
        Tue, 28 Jun 2022 16:02:34 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id x8-20020a6bd008000000b006755ae0679bsm1816220ioa.50.2022.06.28.16.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 16:02:34 -0700 (PDT)
Date:   Tue, 28 Jun 2022 19:02:32 -0400
From:   Peter Xu <peterx@redhat.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/4] kvm: Merge "atomic" and "write" in
 __gfn_to_pfn_memslot()
Message-ID: <YruIiNIII0pXcrYY@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-3-peterx@redhat.com>
 <c047c213-252b-4a0b-9720-070307962d23@nvidia.com>
 <Yrtar+i2X0YjmD/F@xz-m1.local>
 <02831f10-3077-8836-34d0-bb853516099f@nvidia.com>
 <YruFm8vJMPxVUJTO@xz-m1.local>
 <c4f7d5cb-5b23-3384-722f-cc8c517cb123@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c4f7d5cb-5b23-3384-722f-cc8c517cb123@nvidia.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 03:55:22PM -0700, John Hubbard wrote:
> On 6/28/22 15:50, Peter Xu wrote:
> > And if you see the patch I actually did something similar (in kvm_host.h):
> > 
> >   /* gfn_to_pfn (gtp) flags */
> >   ...
> > 
> > I'd still go for GTP, but let me know if you think any of the above is
> > better, I can switch.
> > 
> 
> Yeah, I'll leave that call up to you. I don't have anything better. :)

Thanks. I'll also give it a shot with Sean's suggestion on struct when
repost (I doubt whether I can bare with 4 bools after all..).  If that goes
well we don't worry this too since there'll be no flag introduced.

-- 
Peter Xu

