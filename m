Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BAC3E85AC
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 23:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhHJVvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 17:51:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234947AbhHJVvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 17:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628632261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oH36/9wH82mNkALKpSBwfhqJr/0cHRA60oHpFS8duTI=;
        b=DAp0ugyrAOwGImwkGYC7NThWgRlljVL68YYInh+fZhUMU4CmSeM4ttc2Ap9Y5roMbJSd/f
        6pxyVPXYKnUYuqEf05rYygTeVCaTOrfcC5Cn+UE4vKGnI4ucLofwTMV8EgI4tggPmIy53O
        tZMCZYAA5GAiARH8pN1pxz5kFkCgcNU=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-guLvZdFxN4qru5qy-WofHg-1; Tue, 10 Aug 2021 17:51:00 -0400
X-MC-Unique: guLvZdFxN4qru5qy-WofHg-1
Received: by mail-ot1-f72.google.com with SMTP id r24-20020a0568302378b02904f21fcab643so243477oth.17
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 14:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oH36/9wH82mNkALKpSBwfhqJr/0cHRA60oHpFS8duTI=;
        b=FzBrA7ClT9zZ01xS9GT8s4eg5c2Q2GfWbePzhH1vewzIOt7na4D/tFljIhmXJESnLl
         k3w7XGt0gwAVhCbSFHVUv4ja95SfANc5TDdO66hGg8tCrN+LDbvIRfjBK78U4BqejMyX
         JE9rJDxhXpR2ppBrxaKjy0XnSQqr+8nP6qlcKTygoIJB6lfZLrPO9t4+UIKvDDvgWv4n
         hdICKAkReXSuqvfiyeWdaoxPogd8RL74eD03pLmAqCbwAdNt0zFg0T2cn6aOEYWsU7XI
         oQ0acJIuYJIm1JctGMKQqXcpOLZcc0IeGTUK716jDzwCYLnGjCkuYL3vCXmfJ27IRFDg
         Pl3A==
X-Gm-Message-State: AOAM5339c69EwcXSsMuW2u7tSk6fvwLq9XrqYKuYD53TBj5KC9l+FXfN
        rMdOGj0FAGeh/yo85OYwxL/NpRvcwi4UIGgIHD3SVLY3fZDONY9NFp4OIoLiHv8iZUHKEVBGr9f
        o8JtNbdEud2Zb
X-Received: by 2002:aca:1911:: with SMTP id l17mr7944504oii.160.1628632260032;
        Tue, 10 Aug 2021 14:51:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0YdnMUdm+pqFd5LmIbRWI/f3AmnZFLtHNMH7iPqJDMGpCMBi118Y1XtZ+GSFLbmgWeFotoA==
X-Received: by 2002:aca:1911:: with SMTP id l17mr7944498oii.160.1628632259915;
        Tue, 10 Aug 2021 14:50:59 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id e20sm655457otj.4.2021.08.10.14.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 14:50:59 -0700 (PDT)
Date:   Tue, 10 Aug 2021 15:50:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <20210810155058.4199a86b.alex.williamson@redhat.com>
In-Reply-To: <YRJ3JD7gyi11x5Hw@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
        <162818325518.1511194.1243290800645603609.stgit@omen>
        <20210806010418.GF1672295@nvidia.com>
        <20210806141745.1d8c3e0a.alex.williamson@redhat.com>
        <YRI9+7CCSq++pYfM@infradead.org>
        <20210810115722.GA5158@nvidia.com>
        <YRJ3JD7gyi11x5Hw@infradead.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Aug 2021 13:55:00 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Aug 10, 2021 at 08:57:22AM -0300, Jason Gunthorpe wrote:
> > I'm not sure there is a real performance win to chase here? Doesn't
> > this only protect mmap against reset? The mmap isn't performance
> > sensitive, right?
> > 
> > If this really needs extra optimization adding a rwsem to the devset
> > and using that across the whole set would surely be sufficient.  
> 
> Every mmio read or write takes memory_lock.

Exactly.  Ideally we're not using that path often, but I don't think
that's a good excuse to introduce memory access serialization, or even
dependencies between devices.  Thanks,

Alex

