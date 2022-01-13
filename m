Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B036248DB3B
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 17:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbiAMQFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 11:05:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236389AbiAMQFy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 11:05:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642089953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pMP5V6IIJzefWd2gyk8a8aMEx8ssEhjQKcu5NcxyEzo=;
        b=i8AipnUUWff/NVto3Gv8mUVzML/K1An1o5bxMiAiMgekoHoQssn6UmnML/W6n02J+Gxa75
        FMFTt1GxLuIE2EhDiqN9qYqsPMpkxet+RmfFztMNk+Omz85Y+bzI26+5XfPz/S+MLKWOpD
        cI2yq9kxpAKZIO5YQ7vJy+1UKU0AJ1E=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-skR3Kv0KNK62YSD0hbPX0A-1; Thu, 13 Jan 2022 11:05:51 -0500
X-MC-Unique: skR3Kv0KNK62YSD0hbPX0A-1
Received: by mail-ed1-f70.google.com with SMTP id v18-20020a056402349200b003f8d3b7ee8dso5741561edc.23
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 08:05:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pMP5V6IIJzefWd2gyk8a8aMEx8ssEhjQKcu5NcxyEzo=;
        b=Em3hh5/s48eFkFQFLh8iQmNSN+gff44W7SsDTWhwQajxERTT5S37EmuhK/MiYEUlYE
         Xaj5rWqcmsoG5OIEgj/Cw2il13Ygv+QRdGpLmHXU5LWWGHjQgVmCMWLAeEutaQs0CJ/a
         ZqSDpm/CL3G3dM3/ZhD07yEnKDbPOddJDQ9ZHId1EP6s7MePS/QM56qWtV9pW2eiM56W
         Umpi9Rquc8V6wLvMQDt99nInKEJUHKnvNwaXE9yYt3qL8naeIQYI1bQA1DKlEuIs/Uz/
         YfVmz0zWCE3Nqa7LhhPqkKAe7hgYdPz7QFseggArfzFRVy/K2rXoAQFtlLA9PPOeyhih
         QAEg==
X-Gm-Message-State: AOAM530jFllT86HM+fyyLCtk5uoUdhJ1CiZMArZnPwKuqWzXPTbvB9V0
        UqkMcHQM7ELosuN2P2IGElS1gZRhSdt8VKaIe72RhQc/er2HsaL/YhGghAsBmNx1ZgfTRc9H//j
        i3L8CsNPXI9kn
X-Received: by 2002:aa7:df18:: with SMTP id c24mr4817276edy.164.1642089948518;
        Thu, 13 Jan 2022 08:05:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy3pzQgWFbNJYbAAeR1DJUYSp+AERU5tSgP/iptt6EhUsQbH6QvqAghcwb32Rc2kr3RUAkf/Q==
X-Received: by 2002:aa7:df18:: with SMTP id c24mr4817254edy.164.1642089948288;
        Thu, 13 Jan 2022 08:05:48 -0800 (PST)
Received: from redhat.com ([2.55.154.210])
        by smtp.gmail.com with ESMTPSA id z16sm1438618edm.49.2022.01.13.08.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 08:05:47 -0800 (PST)
Date:   Thu, 13 Jan 2022 11:05:44 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stefanha@redhat.com, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH] vhost: cache avail index in vhost_enable_notify()
Message-ID: <20220113110506-mutt-send-email-mst@kernel.org>
References: <20220113145642.205388-1-sgarzare@redhat.com>
 <20220113101922-mutt-send-email-mst@kernel.org>
 <20220113154301.qd3ayuhrcjnsaim7@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113154301.qd3ayuhrcjnsaim7@steredhat>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022 at 04:44:47PM +0100, Stefano Garzarella wrote:
> On Thu, Jan 13, 2022 at 10:19:46AM -0500, Michael S. Tsirkin wrote:
> > On Thu, Jan 13, 2022 at 03:56:42PM +0100, Stefano Garzarella wrote:
> > > In vhost_enable_notify() we enable the notifications and we read
> > > the avail index to check if new buffers have become available in
> > > the meantime. In this case, the device would go to re-read avail
> > > index to access the descriptor.
> > > 
> > > As we already do in other place, we can cache the value in `avail_idx`
> > > and compare it with `last_avail_idx` to check if there are new
> > > buffers available.
> > > 
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > I guess we can ... but what's the point?
> > 
> 
> That without this patch if avail index is new, then device when will call
> vhost_get_vq_desc() will find old value in cache and will read it again.
> 
> With this patch we also do the same path and update the cache every time we
> read avail index.
> 
> I marked it RFC because I don't know if it's worth it :-)
> 
> Stefano

Pls include info like this in commit log. Thanks!

-- 
MST

