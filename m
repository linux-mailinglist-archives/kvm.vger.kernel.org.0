Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814B546B983
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 11:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhLGKyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 05:54:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230370AbhLGKyc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 05:54:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638874262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=udL9WKP2yNriabxFxnKxM2IL53s1SHalsTV+LJUtcUQ=;
        b=jN9uIBdio3CfaK3OsnpeZakJsIFDZMI5Ds9xFc90gz3bO2wcOZa+h5tU2VY96Fhd7QYPHN
        W1vXJUytJiLpFyBBo4B7Lhth/Mgict3wJ2dfgmG81Bjpj6i7Ftf8J77IMSDLu1nygqGYQD
        nO7/h7/ul6s7TAXBHIRjJmLDl4r1LW4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-L3Fcw3SIPDeL9M_juCXa0Q-1; Tue, 07 Dec 2021 05:50:59 -0500
X-MC-Unique: L3Fcw3SIPDeL9M_juCXa0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8857F101F000;
        Tue,  7 Dec 2021 10:50:57 +0000 (UTC)
Received: from localhost (unknown [10.39.193.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2847F5D6BA;
        Tue,  7 Dec 2021 10:50:48 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
In-Reply-To: <20211206191500.GL4670@nvidia.com>
Organization: Red Hat GmbH
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com> <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <20211206191500.GL4670@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 07 Dec 2021 11:50:47 +0100
Message-ID: <87r1aou1rs.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Dec 03, 2021 at 11:06:19AM -0700, Alex Williamson wrote:

>> This is exactly the sort of "designed for QEMU implementation"
>> inter-operability that I want to avoid.  It doesn't take much of a
>> crystal ball to guess that gratuitous and redundant device resets
>> slow VM instantiation and are a likely target for optimization.
>
> Sorry, but Linus's "don't break userspace" forces us to this world.
>
> It does not matter what is written in text files, only what userspace
> actually does and the kernel must accommodate existing userspace going
> forward. So once released qemu forms some definitive spec and the
> guardrails that limit what we can do going forward.

But QEMU support is *experimental*, i.e. if it breaks, you get to keep
the pieces, things may change in incompatible ways. And it is
experimental for good reason! I don't want something that we don't
support in QEMU lock us into a bad kernel interface, that's just utterly
broken. It would mean that we must never introduce experimental
interfaces in QEMU that may need some rework of the kernel interface,
but need to keep those out of the tree -- and that can't be in the best
interest of implementing things requiring interaction between the kernel
and QEMU.

If you really think we cannot make changes, I vote for declaring the
current interface legacy and not further developed, and introduce a new,
separate one that doesn't carry all of the baggage that this one
does. We could even end up with a QEMU part that looks better!

