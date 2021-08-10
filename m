Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533B83E8360
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 21:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhHJTCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 15:02:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232179AbhHJTCg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 15:02:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628622133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nios0x/SOmEoWSIl8z+EuMVv3qi92+eLAcRIOjO/f+w=;
        b=LM7a1guaiPcsDnPyyyFEJ9ohdNBeTtzv0+l+UotGZFEKV9k/gtsqtP6Sp/PWwVIrYiScmo
        pFcuyAdie3jApKhRsuHZXzzhoO0DI0w3ku4GtzcFH6X8yyVIN7Uqg5iZy5FTClDL9xsHhV
        QmE/8+x5R91sAY1PkHKBdr9WXfMCdMQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-7zJ_RvEbPky1kKXstVrRig-1; Tue, 10 Aug 2021 15:02:12 -0400
X-MC-Unique: 7zJ_RvEbPky1kKXstVrRig-1
Received: by mail-qk1-f198.google.com with SMTP id h186-20020a37b7c30000b02903b914d9e335so17534521qkf.17
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 12:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nios0x/SOmEoWSIl8z+EuMVv3qi92+eLAcRIOjO/f+w=;
        b=i1hzZw6N7C6ZEbmU6fWctoA/UDDhUPf8fA57Ve3OYUwnwJ9SC9GWyYWnW/loecwweA
         m5W5+iJBOW5l5KWZ2Xvbz06Hd6adxg158gbYP2KEgAu9nmBS40iKffZrP/CqJqUhBviE
         zMTvMOuuAcgqdL3Zdv93p4YDILy7SUbDjbR9qjK7qI31f4pkLmpn9PdI3KRcqw4o6/4B
         JAz+YwEDHGFu3tjeW3fHQ/F4GvI0stm1JgJHviFfSmohu/8YK7zynuWkbZM8zB26EByZ
         HHdkEC1jppOLD9XO/zRVlV0jA1JUoYSdJPRCft8Dj3TBRdTFVkRr+2Qz0ZyCeGLqjKmi
         0EFQ==
X-Gm-Message-State: AOAM533Yy7GeAp8LeNvnWMNRDvlIHZkBWfP2+EfEwF/8KB+11+ZpslVM
        J/ppl4pVKGm5V1n8tvhZbPxc1eWbf0S3qfNTYOUP96BtZcBYnkY6IPpUVrpQAY+ZDOlM9/opyv9
        mLz1qHiXFcsGA
X-Received: by 2002:ad4:4ee5:: with SMTP id dv5mr19514966qvb.3.1628622131943;
        Tue, 10 Aug 2021 12:02:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqt+5uYfshgiH7+DypABuSliS1cOfcGFcYlN+d70O9IJB9ST177nPLHh0DQzpOAn2Xszyk0Q==
X-Received: by 2002:ad4:4ee5:: with SMTP id dv5mr19514951qvb.3.1628622131763;
        Tue, 10 Aug 2021 12:02:11 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-92-76-70-75-133.dsl.bell.ca. [76.70.75.133])
        by smtp.gmail.com with ESMTPSA id g1sm11333268qkd.89.2021.08.10.12.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 12:02:10 -0700 (PDT)
Date:   Tue, 10 Aug 2021 15:02:10 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <YRLNMv3UhwVa8Pd4@t490s>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818325518.1511194.1243290800645603609.stgit@omen>
 <YRI+nsVAr3grftB4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YRI+nsVAr3grftB4@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 10:53:50AM +0200, Christoph Hellwig wrote:
> On Thu, Aug 05, 2021 at 11:07:35AM -0600, Alex Williamson wrote:
> > +static void vfio_pci_zap_bars(struct vfio_pci_device *vdev)
> >  {
> > +	vfio_device_unmap_mapping_range(&vdev->vdev,
> > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
> > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
> > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX));
> 
> Maybe make this a little more readable by having local variables:

Or just pass in unmap_mapping_range(start=0, len=0)?  As unmap_mapping_range()
understands len==0 as "to the end of file".  Thanks,

-- 
Peter Xu

