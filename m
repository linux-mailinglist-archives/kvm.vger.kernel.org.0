Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911ED3E5E6A
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 16:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241945AbhHJOxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 10:53:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239763AbhHJOxV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 10:53:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628607178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ekEuvzfZnyXdDySvWdnVn2xizC3vsgCvucSk9Xy3aGE=;
        b=gEXAaZt5jH9f5sKMw6TsASOKZQMvEdudvh4TWFDj4zxNPfndNPTQ/fVKDIlesosYQLaCkm
        +hY8t3lwcYDj2NA+a3N70Zf7JTnOMHvt2oZ9K9cSCw38WlFqUQrGD4C95DRXl7Qtzc0QNu
        caHIXUfmKNR7laLmrw8UGORHs4UXQ5U=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-zN39VgeZMdm7gS4YRHtLrQ-1; Tue, 10 Aug 2021 10:52:57 -0400
X-MC-Unique: zN39VgeZMdm7gS4YRHtLrQ-1
Received: by mail-ot1-f71.google.com with SMTP id m32-20020a9d1d230000b02905103208125aso341795otm.3
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 07:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ekEuvzfZnyXdDySvWdnVn2xizC3vsgCvucSk9Xy3aGE=;
        b=R5x6d4lvvGROjMfE7kqwAI4mosYfkwpbTmQDoeKxCzUWK5ORNdVbzHSVDRpIrxamp4
         v8nAjojwms2ssPJ3fA8eAO89BspMkwof6jwOqYim8JPLqfV5Jp7jW9x2qN5sa9YZ8mQB
         uyj4F2py7xnITTVeJZ1YH3OBbWJxWsNNo2NjhQzvJBAo3TYkQSPvKM5Gty4HQ98WHj91
         dZLFGYktmDyNL9z6j0JlcKKEGogI/+l2gQobh8BLiWqvp1BotRCVkTPIlSXqiE04Jg3y
         8n7ivAPf7ht8xVKijL6hSZkKo7llkvk1C0f9fH+7uiC0Cub1EsymOiLaZ0SdkB5fCyNt
         2YNg==
X-Gm-Message-State: AOAM5307Aw86CGEeRL7SwBTMVf5cmj/m9L8BtHhnT3aixCuPMBLVX2gs
        LuSmD3tgF0ngPwf+bRI0vKxcQP5mZA/kIOYcpz7Qcon9wAPerhanPzJMVa6h8VWe7hOcMc4IpRP
        e4XDTfbUXhqZ9
X-Received: by 2002:a9d:65d9:: with SMTP id z25mr10321641oth.200.1628607176522;
        Tue, 10 Aug 2021 07:52:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5U3PkziXWQue+MNkIOceNv+9XivDBQIBIxcuIGM5MTxDrOa75HV/5J98PWs4/7O8GRuxFoQ==
X-Received: by 2002:a9d:65d9:: with SMTP id z25mr10321623oth.200.1628607176318;
        Tue, 10 Aug 2021 07:52:56 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id 89sm3864023ott.19.2021.08.10.07.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 07:52:55 -0700 (PDT)
Date:   Tue, 10 Aug 2021 08:52:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 1/7] vfio: Create vfio_fs_type with inode per device
Message-ID: <20210810085254.51da01d6.alex.williamson@redhat.com>
In-Reply-To: <YRI8Mev5yfeAXsrj@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
        <162818322947.1511194.6035266132085405252.stgit@omen>
        <YRI8Mev5yfeAXsrj@infradead.org>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Aug 2021 10:43:29 +0200
Christoph Hellwig <hch@infradead.org> wrote:

> > + * XXX Adopt the following when available:
> > + * https://lore.kernel.org/lkml/20210309155348.974875-1-hch@lst.de/  
> 
> No need for this link.

Is that effort dead?  I've used the link several times myself to search
for progress, so it's been useful to me.  Thanks,

Alex

