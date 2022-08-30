Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478935A66FE
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 17:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiH3PL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 11:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiH3PLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 11:11:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5624C7A52F
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 08:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661872283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Uj1KSGVvpg1e2uy6Lmq+BilnZLZf+fvAkkGZhgZ/JI=;
        b=ElgX8nNU72xIzuf5OFPDsBSi8CnY55rfIjnKDJyvHJ8fr3H7mm/vXOPQgbj+m+SqdYLU5k
        yw0gphay4pEH5gJYKXlWhAB4fhPWmizeEfS684bLIn/VRS71B1yC65kVcPEKYvT9FitlKC
        GndEMLtl7L3Ze9ucXCgiuF0Jxv4ihB4=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-495-s-z1bSfrMsyd2Zf53vE3Sw-1; Tue, 30 Aug 2022 11:11:19 -0400
X-MC-Unique: s-z1bSfrMsyd2Zf53vE3Sw-1
Received: by mail-oo1-f69.google.com with SMTP id z22-20020a4a9c96000000b0044b699279ddso5172301ooj.22
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 08:11:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=9Uj1KSGVvpg1e2uy6Lmq+BilnZLZf+fvAkkGZhgZ/JI=;
        b=fnCoNS9CwFyH7Q81oSfEckf0HfwmAmaVkUWI7MX6//MGP5MX1hA0ngT0jS8N5Z1dXP
         +fAWk1wF3kW7etetR2HrNOcnqroKpmg3zdJ70e2dOf4BXulUPe9c4ys3PEXBJ5Sdulm7
         YfWlOp0as2A5Dtidfr8YAtWszZcC9nvzRc6VXzSrbtVdIqONFIU+4JkbAsAVQYbbpXEp
         qDFeSIYVtuthH2ohpIbYEyBGxJw6zDBEeQqniLd4lOkC965kKC+3Fv22Hmohx4YqewIV
         xMKNNQpIEfFYmktP50qJr8sZrPtHyqTXvWTU87FQMpuQrR4St478Wp6P8n62F9vu5Ufu
         FuSQ==
X-Gm-Message-State: ACgBeo1gm50ZFbXkwFRX08gJXHAifNGpJ1fjzNn/56wQneiur5JtMP0y
        /biTP4HHpPXFvjKTPzx6nDCw6k/k0MuIAfyWruhW5+rN0PCcpLH/xVVUxgI0R+dKiYZDD39doer
        xX7ihtETuCBWt
X-Received: by 2002:a05:6830:1e64:b0:63b:25dd:ed07 with SMTP id m4-20020a0568301e6400b0063b25dded07mr5689835otr.159.1661872278756;
        Tue, 30 Aug 2022 08:11:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7imdzhCAin1zc5CWFAJrLO27P5NJLOlKojo5DBQINDuHfcvZzdAo7eVrmJH+TF0TXpUXCpRg==
X-Received: by 2002:a05:6830:1e64:b0:63b:25dd:ed07 with SMTP id m4-20020a0568301e6400b0063b25dded07mr5689827otr.159.1661872278524;
        Tue, 30 Aug 2022 08:11:18 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e5-20020aca1305000000b00344e3751fc4sm6192535oii.36.2022.08.30.08.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 08:11:18 -0700 (PDT)
Date:   Tue, 30 Aug 2022 09:11:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lpivarc@redhat.com
Subject: Re: [PATCH] vfio/type1: Unpin zero pages
Message-ID: <20220830091110.3f6d1737.alex.williamson@redhat.com>
In-Reply-To: <39145649-c378-d027-8856-81b4f09050fc@redhat.com>
References: <166182871735.3518559.8884121293045337358.stgit@omen>
        <39145649-c378-d027-8856-81b4f09050fc@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Aug 2022 09:59:33 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 30.08.22 05:05, Alex Williamson wrote:
> > There's currently a reference count leak on the zero page.  We increment
> > the reference via pin_user_pages_remote(), but the page is later handled
> > as an invalid/reserved page, therefore it's not accounted against the
> > user and not unpinned by our put_pfn().
> > 
> > Introducing special zero page handling in put_pfn() would resolve the
> > leak, but without accounting of the zero page, a single user could
> > still create enough mappings to generate a reference count overflow.
> > 
> > The zero page is always resident, so for our purposes there's no reason
> > to keep it pinned.  Therefore, add a loop to walk pages returned from
> > pin_user_pages_remote() and unpin any zero pages.
> > 
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: stable@vger.kernel.org
> > Reported-by: Luboslav Pivarc <lpivarc@redhat.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index db516c90a977..8706482665d1 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -558,6 +558,18 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
> >  	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
> >  				    pages, NULL, NULL);
> >  	if (ret > 0) {
> > +		int i;
> > +
> > +		/*
> > +		 * The zero page is always resident, we don't need to pin it
> > +		 * and it falls into our invalid/reserved test so we don't
> > +		 * unpin in put_pfn().  Unpin all zero pages in the batch here.
> > +		 */
> > +		for (i = 0 ; i < ret; i++) {
> > +			if (unlikely(is_zero_pfn(page_to_pfn(pages[i]))))
> > +				unpin_user_page(pages[i]);
> > +		}
> > +
> >  		*pfn = page_to_pfn(pages[0]);
> >  		goto done;
> >  	}
> > 
> >   
> 
> As discussed offline, for the shared zeropage (that's not even
> refcounted when mapped into a process), this makes perfect sense to me.
> 
> Good question raised by Sean if ZONE_DEVICE pages might similarly be
> problematic. But for them, we cannot simply always unpin here.

What sort of VM mapping would give me ZONE_DEVICE pages?  Thanks,

Alex

