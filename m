Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980D63903BD
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 16:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhEYOS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 10:18:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233728AbhEYOSq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 10:18:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621952235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qs8EjzEOCz++s3CVPlPwuFgTHOtbAQXpJzzRW8nZD74=;
        b=eQWwSNP00prQajd0SYcxyxBIlCbBWdOQ2xHOz+++28sKbxcKGjiimr4L9g5sdd4GeTl2GG
        6tSquJotv84E1gSPz01dfka/gapPAWPg3mRJSpIFCB6BJW62C0v75goeh0vmnYax6kh0Ym
        QKYMMO7FItGrYnuPkWgI+h4Ixfzsitc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-HJN5gWhHNqG-whwXDW4xfQ-1; Tue, 25 May 2021 10:17:13 -0400
X-MC-Unique: HJN5gWhHNqG-whwXDW4xfQ-1
Received: by mail-ed1-f71.google.com with SMTP id w22-20020a05640234d6b029038d04376b6aso17329362edc.21
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 07:17:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qs8EjzEOCz++s3CVPlPwuFgTHOtbAQXpJzzRW8nZD74=;
        b=Ga1ipPV1LQIeptvUw2tNMrVskXGcDK0UUWaxna50llDYi4q026RyGseB23GF0/53uA
         6HKhkI1afod5StuTFJDBmxjT46Rye14iJ6vJDGkJLfPUIOwBufqL+pytiPvj8JRHtiZF
         V3OEgqbncepV/xkHNk6TP9cAm1eSW4yRWWWNSZcJehfKYpLCxWU4V7pVf35ue/VSeH/d
         lF3kdd+qjMml5C1SC2Zfws2T9Gy3AfMKpnMJY1CY16tFbK8ed0uEhlOBZiXezGBXaJ47
         97km9euQK9KosikH519qSFGMLJXAP9zVoHQwVgDmCSgEwpKFcNsj9drT7laLvyq/2APb
         Cq7A==
X-Gm-Message-State: AOAM531ikH6weUzCQAHCx1PRcvH7CUnFCclVy4KTur96zlhxIM6WA9ci
        zR7vPMeqrsZyk5qmQLfblHnLQmFAAdFe5PrtOeJzzg7zOaCV+JZtHgOzTbm+ZW+2+s+qAkdkeUe
        OlPXRS3n4HLk0
X-Received: by 2002:a05:6402:190e:: with SMTP id e14mr32337344edz.146.1621952231503;
        Tue, 25 May 2021 07:17:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFKL2as0znk9EfRE37BQywDQJb+X3ks+d5tVQoRqTJJqOiRkyF4ZCUMGJz3wAnrUijDO8n7A==
X-Received: by 2002:a05:6402:190e:: with SMTP id e14mr32337320edz.146.1621952231368;
        Tue, 25 May 2021 07:17:11 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id bv17sm9143813ejb.37.2021.05.25.07.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 07:17:10 -0700 (PDT)
Date:   Tue, 25 May 2021 16:17:08 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 06/18] af_vsock: rest of SEQPACKET support
Message-ID: <20210525141708.nklo776yq2nnhju7@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191639.1271423-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191639.1271423-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 10:16:36PM +0300, Arseny Krasnov wrote:
>To make SEQPACKET socket functional, socket ops was added
>for SEQPACKET type and such type of socket was allowed
>to create.

If you need to resend, I think is better to use the present in the 
commit message.

Maybe you can rephrase something like this:
"Add socket ops for SEQPACKET type and .seqpacket_allow() callback
to query transports if they support SEQPACKET"


>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   |  1 +
> net/vmw_vsock/af_vsock.c | 36 +++++++++++++++++++++++++++++++++++-
> 2 files changed, 36 insertions(+), 1 deletion(-)

The patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

