Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC8C37F9E8
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 16:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhEMOp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 10:45:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234679AbhEMOpN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 10:45:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620917043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hdpFzlw0w4/uVzT3jAhrSWNr+fsmMmecEBNQv5uklac=;
        b=IJZ036W3E6OkZsIQz6PqEnai54Px1IdSIhz55tq1J4PAg0iUIEUGCqU064ZCpx+zSJ0hyK
        AtSpgBOeFePJSOh9emNa8PMA6Bdl4IyxrEBM1dNyuT9N2PfKIIymGkB2iXOTYo3UifeBXz
        rDW19DR82esgUnFZicLLvawY0bTxebc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-l3dFiQnBO3GVfxpNXsh7Eg-1; Thu, 13 May 2021 10:44:02 -0400
X-MC-Unique: l3dFiQnBO3GVfxpNXsh7Eg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77B20107ACCD;
        Thu, 13 May 2021 14:44:00 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D8C161145;
        Thu, 13 May 2021 14:44:00 +0000 (UTC)
Date:   Thu, 13 May 2021 08:43:59 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     tkffaul@outlook.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@linux.intel.com>
Subject: Re: [PATCH] vfio/pci: Sanity check IGD OpRegion Size
Message-ID: <20210513084359.274353e9@redhat.com>
In-Reply-To: <YJjO3n6jWYDoYPAo@infradead.org>
References: <162041357421.21800.16214130780777455390.stgit@omen>
        <YJjO3n6jWYDoYPAo@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 07:12:46 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, May 07, 2021 at 12:53:17PM -0600, Alex Williamson wrote:
> > +	/*
> > +	 * The OpRegion size field is specified as size in KB, but there have been
> > +	 * user reports where this field appears to report size in bytes.  If we
> > +	 * read 8192, assume this is the case.
> > +	 */  
> 
> Please avoid pointlesly spilling the comment line over 80 chars.

Oops, I didn't notice I was using a wider terminal.  Fixed.

> > +	if (size == OPREGION_SIZE)  
> 
> Shouldn't this be a range tests, i.e. >= ?

My concern here is how far we go down the path of trying to figure out
what a sane size range is for this table an how/if we try to assume the
BIOS intentions.  The precise value of 8192 is not only absurdly large,
but happens to coincide with the default table size, so it seems likely
that we can infer this specific misinterpretation.  If the BIOS has
used a different value, suggesting they're trying to do something more
extensive than a basic implementation, but still managed to botch the
units for the size field, we should probably disregard it entirely.  We
can probably do that for smaller values as well, but I don't know where
the line between reasonable and absurd is crossed.

Would it make more sense to export e820__get_entry_type() so that we
can validate that the full range of the table fits within an e820
mapping, which I understand should be ACPI NVS in this case?  Thanks,

Alex

