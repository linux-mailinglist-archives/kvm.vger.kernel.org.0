Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895BE2E8E1F
	for <lists+kvm@lfdr.de>; Sun,  3 Jan 2021 21:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbhACUiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jan 2021 15:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbhACUiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jan 2021 15:38:21 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF28CC061573
        for <kvm@vger.kernel.org>; Sun,  3 Jan 2021 12:37:40 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id x20so59936121lfe.12
        for <kvm@vger.kernel.org>; Sun, 03 Jan 2021 12:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=uYMEY+UEi59vRzbLfirzkFbbh9cnnN/4kmEHrCuTA2k=;
        b=jO7e2NGBKVDhQ6ByJNLifmobWecrmIDxcVPgLWK4NFyBkCqP5wbntg6tmtBbXhz1uB
         PZlBKQR9fr7uIu3PxovoJPoSec8YY4Z0MUz2jAJMEa9Njr3Dpez+NuAoHBMFhkxDR78j
         wQUgIfv6esF+n9/3E9JcHtzCtTxw/abYw6lL8wIhtr1AEJMaLAMio3P54IgpLX7/BlnJ
         YA/N0uyrNlR2cpnRtfDK76zo5zXvst9By+uDw9gJdSH8cxekAnwLJiA6YdQ72N4YRXj+
         ZpQ2gn7n2NIBTQQqLOFGMQq6uxlFc5I56hm0UjT5NDuWmGdS39ooDm4x6gEgLeRuqp7A
         jkgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uYMEY+UEi59vRzbLfirzkFbbh9cnnN/4kmEHrCuTA2k=;
        b=UFGzdi2lHzMC+ebSYALmkff+KF+14bQb+xvpvOW0d5Z/qJ+MFJfXkdFEb0bjgSKRmr
         0TXvQ0Pfm830pXhsPj5AFhrB9hirVbWKoTQ3qUwl9uw7FaMOg3u11Xs6XNdupOdekUma
         TDqILC9TyRoW6CKC4cXWShhd9ybJIvzbkTpRFOoOXD4aLyYw6Viog0RnXJzuy9o2jbYM
         lPMwx6q4YLcd1oUzaEUEyTtxxmF0DwoyWhUBNCXanBUCoUF+aDLlvFaQhQWKHTglGhP+
         xhuUGHMiqZOprsraysQvkKCDx1sNksVMG2GYIbbEfZ2F16sLocSLaz0UhMDRtLyjmBzM
         xfVQ==
X-Gm-Message-State: AOAM533h/Renww7VaJL5hgXsQCB9vGtj1QwvOYv/SjMocj4Uk4bITFFM
        FxC1td8aUECWP9tHwdhIqVc=
X-Google-Smtp-Source: ABdhPJziRaevNNCa7PZPmaBXIovm2NsvXHYbN11e/08hlRPPLo8kJB1j7sHyUqhYbzjmw/0ITTFxWA==
X-Received: by 2002:ac2:538a:: with SMTP id g10mr32498211lfh.91.1609706259207;
        Sun, 03 Jan 2021 12:37:39 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id j5sm7131192lfm.11.2021.01.03.12.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 12:37:38 -0800 (PST)
Message-ID: <90e04958a3f57bbc1b0fcee4810942f031640a05.camel@gmail.com>
Subject: Re: [RFC 2/2] KVM: add initial support for ioregionfd blocking
 read/write operations
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Date:   Sun, 03 Jan 2021 12:37:24 -0800
In-Reply-To: <72556405-8501-26bc-4939-69e312857e91@redhat.com>
References: <cover.1609231373.git.eafanasova@gmail.com>
         <a13b23ca540a8846891895462d2fb139ec597237.1609231374.git.eafanasova@gmail.com>
         <72556405-8501-26bc-4939-69e312857e91@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-12-31 at 11:46 +0800, Jason Wang wrote:
> On 2020/12/29 下午6:02, Elena Afanasova wrote:
> > Signed-off-by: Elena Afanasova<eafanasova@gmail.com>
> > ---
> >   virt/kvm/ioregion.c | 157
> > ++++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 157 insertions(+)
> > 
> > diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> > index a200c3761343..8523f4126337 100644
> > --- a/virt/kvm/ioregion.c
> > +++ b/virt/kvm/ioregion.c
> > @@ -4,6 +4,33 @@
> >   #include <kvm/iodev.h>
> >   #include "eventfd.h"
> >   
> > +/* Wire protocol */
> > +struct ioregionfd_cmd {
> > +	__u32 info;
> > +	__u32 padding;
> > +	__u64 user_data;
> > +	__u64 offset;
> > +	__u64 data;
> > +};
> > +
> 
> I wonder do we need a seq in the protocol. It might be useful if we 
> allow a pair of file descriptors to be used for multiple different
> ranges.
> 
I think it might be helpful in the case of out-of-order requests. 
In the case of in order requests seq field seems not to be necessary
since there will be cmds/replies serialization. I’ll include the
synchronization code in a RFC v2 series.

> Thanks
> 
> 
> > +struct ioregionfd_resp {
> > +	__u64 data;
> > +	__u8 pad[24];
> > +};

