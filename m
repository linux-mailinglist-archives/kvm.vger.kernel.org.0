Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C14D6F8529
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjEEPAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbjEEPAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:00:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3385E17DD1
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 07:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683298784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBXNgO7aRryOo3aOK63YAEnZA6K4XoikS9SxHfhUh30=;
        b=Xdpu0TN5wUDqy1TFcaxWXsjJYrGZYlHWi+hj8K+e+VIY+DYuxSeFX0kLq5yWau31tcBkEF
        cS40AdKe38QfsHDqy+iqI9lAoJa52kf2tz8DKaxxpVmHiq09EY7sf1fYZ9rR0zYlBbu+/n
        o7OctNrG5uWmKpJaEN2HA9ndcyK90CY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-lcGp7EpJOWqlsQZ2cbU60Q-1; Fri, 05 May 2023 10:59:42 -0400
X-MC-Unique: lcGp7EpJOWqlsQZ2cbU60Q-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-50c9582877cso4196702a12.1
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 07:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683298781; x=1685890781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBXNgO7aRryOo3aOK63YAEnZA6K4XoikS9SxHfhUh30=;
        b=mDdfAUwGeMqZxI29K3JfsNCfDcYCtYAo+jK1gHXzgyGvxPNxmA9CbPWbXF0WBkqj3N
         niCx4N7/NOFBpo8T0lPDwIOeMUoeDrez6BDlxGUBQ42jp+eghWCS4jP62WzDIUfZq/WX
         sw3pcEK6DhmsfZLU90T9pgAh2/bwgiN8SKtkGVDPzJTv/Okci62a1B52nfiS25sDcN+q
         5uV3fXdpk2NvJF5s2hbDSYaOMUZkfwfUZ3pMkXDbo+QfYO2Sqq+uGp8vzZkiu/ANbfBb
         g2qCiEXgA7R5uAEIsAJ+zq3XxHguKDCVw/ruVZLcJgCzVgFQVAdacn0MnD+22oNeWWEu
         Fj4g==
X-Gm-Message-State: AC+VfDxKM0uWcf7IaW+1MvD4pVB4uvRw0nyBIH7CPihmIJ/zC9ad4jNt
        oaXbjiLU7S4ViiQrb0WBFf7HqOXjTc4wrb4GMoqSszT4TvIGqrfjiZACjFSAqOUPQpLAu8/J2kW
        irgduYmOZlK09
X-Received: by 2002:aa7:ccc6:0:b0:50b:dfe2:91 with SMTP id y6-20020aa7ccc6000000b0050bdfe20091mr1904398edt.7.1683298781577;
        Fri, 05 May 2023 07:59:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ41nBmpMVnXW7PKFZ8ZB30pUuvlx01dx8IxPbfnWfLUCXzpn0UbIn+XfcKAeqyn2xG3hPxzGw==
X-Received: by 2002:aa7:ccc6:0:b0:50b:dfe2:91 with SMTP id y6-20020aa7ccc6000000b0050bdfe20091mr1904374edt.7.1683298781292;
        Fri, 05 May 2023 07:59:41 -0700 (PDT)
Received: from redhat.com ([77.137.193.128])
        by smtp.gmail.com with ESMTPSA id h20-20020aa7c614000000b00501d73cfc86sm3024677edq.9.2023.05.05.07.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 07:59:40 -0700 (PDT)
Date:   Fri, 5 May 2023 10:59:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     ye xingchen <yexingchen116@gmail.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, ye.xingchen@zte.com.cn
Subject: Re: [PATCH] vhost_net: Use fdget() and fdput()
Message-ID: <20230505105811-mutt-send-email-mst@kernel.org>
References: <CACGkMEsmf3PgxmhgRCsPZe7fRWHDXQ=TtYu5Tgx1=_Ymyvi-pA@mail.gmail.com>
 <20230505084155.63839-1-ye.xingchen@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505084155.63839-1-ye.xingchen@zte.com.cn>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 05, 2023 at 04:41:55PM +0800, ye xingchen wrote:
> >>
> >> From: Ye Xingchen <ye.xingchen@zte.com.cn>
> >>
> >> convert the fget()/fput() uses to fdget()/fdput().
> >What's the advantages of this?
> >
> >Thanks
> >>
> >> Signed-off-by: Ye Xingchen <ye.xingchen@zte.com.cn>
> >> ---
> >>  drivers/vhost/net.c | 10 +++++-----
> >>  1 file changed, 5 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> >> index ae2273196b0c..5b3fe4805182 100644
> >> --- a/drivers/vhost/net.c
> >> +++ b/drivers/vhost/net.c
> >> @@ -1466,17 +1466,17 @@ static struct ptr_ring *get_tap_ptr_ring(struct file *file)
> >>
> >>  static struct socket *get_tap_socket(int fd)
> >>  {
> >> -       struct file *file = fget(fd);
> >> +       struct fd f = fdget(fd);
> >>         struct socket *sock;
> >>
> >> -       if (!file)
> >> +       if (!f.file)
> >>                 return ERR_PTR(-EBADF);
> >> -       sock = tun_get_socket(file);
> >> +       sock = tun_get_socket(f.file);
> >>         if (!IS_ERR(sock))
> >>                 return sock;
> >> -       sock = tap_get_socket(file);
> >> +       sock = tap_get_socket(f.file);
> >>         if (IS_ERR(sock))
> >> -               fput(file);
> >> +               fdput(f);
> >>         return sock;
> >>  }
> >>
> >> --
> >> 2.25.1
> >>
> fdget requires an integer type file descriptor as its parameter, 
> and fget requires a pointer to the file structure as its parameter.

In which kernel?

include/linux/file.h:extern struct file *fget(unsigned int fd);


> By using the fdget function, the socket object, can be quickly 
> obtained from the process's file descriptor table without 
> the need to obtain the file descriptor first before passing it 
> as a parameter to the fget function. This reduces unnecessary 
> operations, improves system efficiency and performance.
> 
> Best Regards
> Ye

