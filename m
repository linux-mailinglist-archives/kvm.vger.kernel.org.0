Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B555B094A
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 17:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiIGP4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 11:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiIGPz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 11:55:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9C17C753
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 08:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662566156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U000y4AlzxnDukLNUBVaMd74Em033gIiv2WJaxIzryc=;
        b=EC9fQ3iWUouCpAIS/nvmIrROb5ct85SHEeWMR+DLD43OHHCUQ/aWrr3JCVl2kPn0vC3SAh
        JvQ7gmIcMlN5P66FDt6oZ0jRFUeuxsmDa5MF0QdlwBTU6oduQ4tDhfEZqwpanbyx0r/f3Y
        nM7dz+kHJd797BB9/OTnHTIiML0mIFI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-_QyNwgLgMGa7NWDQLxysew-1; Wed, 07 Sep 2022 11:55:55 -0400
X-MC-Unique: _QyNwgLgMGa7NWDQLxysew-1
Received: by mail-io1-f69.google.com with SMTP id l205-20020a6b3ed6000000b0068b49dd0a61so9449049ioa.14
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 08:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=U000y4AlzxnDukLNUBVaMd74Em033gIiv2WJaxIzryc=;
        b=ykbN4F08puCF8TxmdxtsmSCUlUXG7o04y+EUaJSBC+gx668Rde4f272GcFo+C6MjEO
         7SHVt+GTA/mUJk/fXr65oP1wvdyJUV/1AMsFK0v/5am7q/sEsxoxxJSziHEgaLRKo5Wg
         RXgVTU0BcivMBqA26k4fi9swFP3W1QJv2JtW73Lfg9fnUccaUo/TdKwnm1DODB1zff/M
         4/Xfm2vn9B8FJ4Be73QWNlzREPvnWUe1qnNLHPtPI7mybT7F/BM7LbfYNNcWGYIobOkd
         A3xNtSpCHPyIYD74olSQttz5ESUf/OdaBaHnDUIwiICokfT/QE6512GlPrbJ0nXuF+le
         1xyw==
X-Gm-Message-State: ACgBeo1KPupp0z9jnXsgdbjQFrCJEDTEftUCkogXTGopf0DBxNsqChnB
        j3EqaxVMsK9hMd/FQx2kgQWs13qzPUr4EgnFexUAk6D0QRUjY47vQvkGPggyMFzLXWMgcNT1MBB
        4kv96bgQopRsB
X-Received: by 2002:a05:6638:22d1:b0:34f:5d31:5fe with SMTP id j17-20020a05663822d100b0034f5d3105femr2606499jat.185.1662566154720;
        Wed, 07 Sep 2022 08:55:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6D7qKm1upNIe82yM19qyluZ0T+1qSlkLSi1fOw3wRUvT4Mi/b72egvqphU/nT0DgOhWBcbfQ==
X-Received: by 2002:a05:6638:22d1:b0:34f:5d31:5fe with SMTP id j17-20020a05663822d100b0034f5d3105femr2606485jat.185.1662566154471;
        Wed, 07 Sep 2022 08:55:54 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c44-20020a02962f000000b00349cee4ef4asm7424975jai.62.2022.09.07.08.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 08:55:54 -0700 (PDT)
Date:   Wed, 7 Sep 2022 09:55:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     David Hildenbrand <david@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lpivarc@redhat.com" <lpivarc@redhat.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: [PATCH] vfio/type1: Unpin zero pages
Message-ID: <20220907095552.336c8f34.alex.williamson@redhat.com>
In-Reply-To: <YxiTOyGqXHFkR/DY@ziepe.ca>
References: <166182871735.3518559.8884121293045337358.stgit@omen>
        <BN9PR11MB527655973E2603E73F280DF48C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <d71160d1-5a41-eae0-6405-898fe0a28696@redhat.com>
        <YxfX+kpajVY4vWTL@ziepe.ca>
        <b365f30b-da58-39c0-08e9-c622cc506afa@redhat.com>
        <YxiTOyGqXHFkR/DY@ziepe.ca>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Sep 2022 09:48:59 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Wed, Sep 07, 2022 at 11:00:21AM +0200, David Hildenbrand wrote:
> > > > I do wonder if that's a real issue, though. One approach would be to
> > > > warn the VFIO users and allow for slightly exceeding the MEMLOCK limit
> > > > for a while. Of course, that only works if we assume that such pinned
> > > > zeropages are only extremely rarely longterm-pinned for a single VM
> > > > instance by VFIO.  
> > > 
> > > I'm confused, doesn't vfio increment the memlock for every page of VA
> > > it pins? Why would it matter if the page was COW'd or not? It is
> > > already accounted for today as though it was a unique page.
> > > 
> > > IOW if we add FOLL_FORCE it won't change the value of the memlock.  
> > 
> > I only briefly skimmed over the code Alex might be able to provide more
> > details and correct me if I'm wrong:
> > 
> > vfio_pin_pages_remote() contains a comment:
> > 
> > "Reserved pages aren't counted against the user, externally pinned pages are
> > already counted against the user."
> > 
> > is_invalid_reserved_pfn() should return "true" for the shared zeropage and
> > prevent us from accounting it via vfio_lock_acct(). Otherwise,
> > vfio_find_vpfn() seems to be in place to avoid double-accounting pages.  
> 
> is_invalid_reserved_pfn() is supposed to return 'true' for PFNs that
> cannot be returned from pin_user_pages():
> 
> /*
>  * Some mappings aren't backed by a struct page, for example an mmap'd
>  * MMIO range for our own or another device.  These use a different
>  * pfn conversion and shouldn't be tracked as locked pages.
>  * For compound pages, any driver that sets the reserved bit in head
>  * page needs to set the reserved bit in all subpages to be safe.
>  */
> static bool is_invalid_reserved_pfn(unsigned long pfn)
> 
> What it is talking about by 'different pfn conversion' is the
> follow_fault_pfn() path, not the PUP path.
> 
> So, it is some way for VFIO to keep track of when a pfn was returned
> by PUP vs follow_fault_pfn(), because it treats those two paths quite
> differently.
> 
> I lost track of what the original cause of this bug is - however AFAIK
> pin_user_pages() used to succeed when the zero page is mapped.

It does currently, modulo getting broken occasionally.

> No other PUP user call this follow_fault_pfn() hacky path, and we
> expect things like O_DIRECT to work properly even when reading from VA
> that has the zero page mapped.

zero page shouldn't take that path, we get the pages via PUP.

> So, if we go back far enough in the git history we will find a case
> where PUP is returning something for the zero page, and that something
> caused is_invalid_reserved_pfn() == false since VFIO did work at some
> point.

Can we assume that?  It takes a while for a refcount leak on the zero
page to cause an overflow.  My assumption is that it's never worked, we
pin zero pages, don't account them against the locked memory limits
because our is_invalid_reserved_pfn() test returns true, and therefore
we don't unpin them.

> IHMO we should simply go back to the historical behavior - make
> is_invalid_reserved_pfn() check for the zero_pfn and return
> false. Meaning that PUP returned it.

We've never explicitly tested for zero_pfn and as David notes,
accounting the zero page against the user's locked memory limits has
user visible consequences.  VMs that worked with a specific locked
memory limit may no longer work.  Logically, this seems to be the one
case of duplicate accounting that we get right relative to the user's
locked memory limit and the current implementation of pinning the zero
page.  We're not locking any resources that aren't effectively already
locked.  Thanks,

Alex

