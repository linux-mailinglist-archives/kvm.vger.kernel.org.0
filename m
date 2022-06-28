Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F1F55F197
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 00:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiF1WuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 18:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiF1WuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 18:50:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51B573A709
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 15:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656456608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W3kLhAZGK2ncHck2YD7sSY1Nrpc3ON/goS7rYhosu+8=;
        b=UL1SNrMwUdd20s0cmAaG3JJ2iRMZW4q3oCJwymQxqFI0j5fBBS9VBlwy78BQ0Sl0fXBv5n
        cA/n+wWOjakgC2kc/8BYvqqbR+y/laS/f1SiVFMj3EEDybVJ/4Yy1OuUPGusRjxT471g8R
        iG/pqxJAawUAz7fOzaIw3qzBVz9LqmY=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-4g6-QYQhMxGBfbZOeHotEw-1; Tue, 28 Jun 2022 18:50:06 -0400
X-MC-Unique: 4g6-QYQhMxGBfbZOeHotEw-1
Received: by mail-io1-f69.google.com with SMTP id p16-20020a5d8b90000000b006750eb6b95dso7078495iol.11
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 15:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W3kLhAZGK2ncHck2YD7sSY1Nrpc3ON/goS7rYhosu+8=;
        b=AYUQhaDKkQLukmYIBGdqbCVbflfjoT3RqogvSSgmyU9k0Dfet2i/Z2uPBw/ry10RfR
         MMsn9a2BpGfKshN0xGrZppmReaICKfnS5UkzcohfDljtfm4F3irFjDwm+g+DQJi0zaSf
         4rLpHOG3/8H5qpnU/JMSFnEwpl4pittPgDSM1W+6GrwuLRa6U6uD0EZc0D8XHspZaULh
         mhQtYTkABp3Q8FFMQtTQhn9Z2rf3NAfmnOj85uoi0JIrX3pC/pSgpDqDZRbb+f6v6rB4
         KXWl9TkN8E5mqFEg7GLjfEc4sceEYc9seVgNZ5tDCINodYYiilgclFriduphfsrCmY6H
         ZdRw==
X-Gm-Message-State: AJIora/D7Xqd7BcInm9awU4IFUoCwAPEUzu1hIqBxE8Cl/GdyKDm5JOK
        qp1LlsaP3zrxKwSvjPOlsu8lFpXiCPOqnrgAxn9InMxjfvI+t8mfr54UqgybfGyOXIqpPRBm3sT
        Yy6HZzVAAmV3o
X-Received: by 2002:a05:6e02:15c9:b0:2da:c33e:49c7 with SMTP id q9-20020a056e0215c900b002dac33e49c7mr18968ilu.26.1656456606272;
        Tue, 28 Jun 2022 15:50:06 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uvOepd4UW7ERHSNp4aEwCJ76y/hhPsMiiTQrUS6nrxdaYCpU21kA6tkiY9yBbjfWLSCFQliA==
X-Received: by 2002:a05:6e02:15c9:b0:2da:c33e:49c7 with SMTP id q9-20020a056e0215c900b002dac33e49c7mr18948ilu.26.1656456606042;
        Tue, 28 Jun 2022 15:50:06 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id j25-20020a02a699000000b00339c33df66bsm6537922jam.118.2022.06.28.15.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 15:50:05 -0700 (PDT)
Date:   Tue, 28 Jun 2022 18:50:03 -0400
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
Message-ID: <YruFm8vJMPxVUJTO@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-3-peterx@redhat.com>
 <c047c213-252b-4a0b-9720-070307962d23@nvidia.com>
 <Yrtar+i2X0YjmD/F@xz-m1.local>
 <02831f10-3077-8836-34d0-bb853516099f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <02831f10-3077-8836-34d0-bb853516099f@nvidia.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 02:52:04PM -0700, John Hubbard wrote:
> On 6/28/22 12:46, Peter Xu wrote:
> > I'd try to argu with "I prefixed it with kvm_", but oh well.. yes they're a
> > bit close :)
> > 
> > > 
> > > Yes, "read the code", but if you can come up with a better TLA than GTP
> > > here, let's consider using it.
> > 
> > Could I ask what's TLA?  Any suggestions on the abbrev, btw?
> 
> "Three-Letter Acronym". I love "TLA" because the very fact that one has
> to ask what it means, shows why using them makes it harder to communicate. :)

Ha!

> 
> As for alternatives, here I'll demonstrate that "GTP" actually is probably
> better than anything else I can come up with, heh. Brainstorming:
> 
>     * GPN ("Guest pfn to pfn")
>     * GTPN (similar, but with a "T" for "to")
>     * GFNC ("guest frame number conversion")

Always a challenge on the naming kongfu. :-D

One good thing on using TLA in macros, flags and codes (rather than simply
mention some three letters): we can easily jump to the label of any of the
flags when we want to figure out what it means, and logically there'll (and
should) be explanations of the abbrev in the headers if it's a good header.

Example: it's even not easy to figure out what GFP is in GFP_KERNEL flag
for someone not familiar with mm (when I wrote this line, I got lost!), but
when that happens we do jump label and at the entry of gfp.h we'll see:

 * ...  The GFP acronym stands for get_free_pages(),

And if you see the patch I actually did something similar (in kvm_host.h):

 /* gfn_to_pfn (gtp) flags */
 ...

I'd still go for GTP, but let me know if you think any of the above is
better, I can switch.

Thanks,

-- 
Peter Xu

