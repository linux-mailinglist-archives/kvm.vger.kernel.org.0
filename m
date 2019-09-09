Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A22ADD54
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 18:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfIIQeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 12:34:01 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46313 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfIIQeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 12:34:00 -0400
Received: by mail-ed1-f66.google.com with SMTP id i8so13496224edn.13
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 09:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QxM9mJktlH2b9W/UrzlsSXilA2r8zVDwLuT+VMLdcm4=;
        b=qXurPKBeQ/50vkdVpdFd3RSFI5atfLR6gPp0JjnuECbcNWDtU74AipRoFJSjkAcOy3
         FfBcaM9GRBg8SD2T1Q6QoVjNV5wloxgkJnhSSmsRUEKZNf8DGRghZRRByKpks6ejiozo
         IBd+bYzG5nzJgRXFlAjDxtSmKg1yemVBjKrqzFuH6AOe4YDZR0qX81XGVRy28dB7ixl1
         n3WhCeqgxzfaUFtdBqVH7E1BzdRpmPnLzzsoVL0ITc9UsIUeivBdItfSqWIxJiTo1tiH
         5M7XG+THkq7pCgQAk0LidvkGLut7VIK/flw5PVz0tWv6WktP5+8smPwLaz/8iyvR625A
         zoNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QxM9mJktlH2b9W/UrzlsSXilA2r8zVDwLuT+VMLdcm4=;
        b=MOdiK8ZkBIOQmIfLxjhbKxLEEbDEVUNUjmDvqjiy3y1KjDqYCJhFHhRlR4k9RedE+k
         dZoQGO4hnQQvJ07eU6unqfOA56CyKIYX7yK3KQQOZZ8ricTop0z3oLP6uPd0LBgrQeJ+
         OM6T6MyPj09LdJrPdM5pSRZWZvesUTXVg5AXf8sOLU/SdCyuZ+UuAOUMtOd6DWk1cwPo
         /kYsjFiulX5zyfU+BKpgev+uwZ2KH5QQ66MZVCH6zwrZaIf6kZxfZYbrTYrgsfa8MHhY
         gAZ3N2i4Cflcax2NZe4Oxonf+mcW3uhF31VuR1bJMBMN1EuAfbtSmQvGJturoTTpLG8Z
         hD/A==
X-Gm-Message-State: APjAAAW6i+yQFh+jsU7KeXmFCQ9Q94RudLnQUrzwovv5tCROJ5KC0aYi
        yVl3OetlBxli1H1Y4Svq/MN+bg==
X-Google-Smtp-Source: APXvYqzchdFdfE1hclnLKzl1/sGN9sqBpqJacSjdc7si3DfczRfamQmuNJFhSHuWNQ94FDn9AyIfeg==
X-Received: by 2002:a17:906:3485:: with SMTP id g5mr19264541ejb.76.1568046837302;
        Mon, 09 Sep 2019 09:33:57 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id w11sm1781938eju.9.2019.09.09.09.33.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 09:33:56 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 56B881029C4; Mon,  9 Sep 2019 19:33:55 +0300 (+03)
Date:   Mon, 9 Sep 2019 19:33:55 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        kirill.shutemov@linux.intel.com
Subject: Re: [PATCH v9 6/8] mm: Introduce Reported pages
Message-ID: <20190909163355.zueprine5zqwexi4@box>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190907172553.10910.72962.stgit@localhost.localdomain>
 <20190909144209.jcrx6o3ntecdaqmh@box>
 <acfe9744deaede8f8c4fa4f40a04514d9f843259.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acfe9744deaede8f8c4fa4f40a04514d9f843259.camel@linux.intel.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 09, 2019 at 09:25:04AM -0700, Alexander Duyck wrote:
> > Proper description for the config option?
> 
> I can add one. However the feature doesn't do anything without a caller
> that makes use of it. I guess it would make sense to enable this for
> something such as an out-of-tree module to later use.

Description under 'help' section will not make the option user selectable
if you leave 'bool' without description.

> > > +	mutex_lock(&page_reporting_mutex);
> > > +
> > > +	/* nothing to do if already in use */
> > > +	if (rcu_access_pointer(ph_dev_info)) {
> > > +		err = -EBUSY;
> > > +		goto err_out;
> > > +	}
> > 
> > Again, it's from "something went horribly wrong" category.
> > Maybe WARN_ON()?
> 
> That one I am not so sure about. Right now we only have one user for the
> page reporting interface. My concern is if we ever have more than one we
> may experience collisions. The device driver requesting this should
> display an error message if it is not able tor register the interface.

Fair enough.

> > > +	boundary = kcalloc(MAX_ORDER - PAGE_REPORTING_MIN_ORDER,
> > > +			   sizeof(struct list_head *) * MIGRATE_TYPES,
> > > +			   GFP_KERNEL);
> > 
> > Could you comment here on why this size of array is allocated?
> > The calculation is not obvious to a reader.
> 
> Would something like the following work for you?
>         /*
>          * Allocate space to store the boundaries for the zone we are
>          * actively reporting on. We will need to store one boundary
>          * pointer per migratetype, and then we need to have one of these
>          * arrays per order for orders greater than or equal to
>          * PAGE_REPORTING_MIN_ORDER.
>          */

Ack.

-- 
 Kirill A. Shutemov
