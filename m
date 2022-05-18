Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837F952B1DD
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 07:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiERFXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 01:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiERFXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 01:23:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E981D167E9
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 22:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652851385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s5aF1SwBsINrQMkQK6jj8/AJIyTgJ8TbouQ8o7y74Qw=;
        b=QP0bpDPI0FEwra+LGxvXt8D5Ma4QbOEmTj56ON62a1CyPSEOUQc7Ew7XCRxAosyofalcGz
        29yNCptMkztf4O6OjfzKsgKlbtiVN8/xOjMcnTw7Nl9pdE9OWee/P0vL/riJRYSKNsB2/G
        DjMUjoOmRtth5xolbZOHXi3DMv1I7ro=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-mMyzgQ_JNUaMvHz-knulcQ-1; Wed, 18 May 2022 01:23:02 -0400
X-MC-Unique: mMyzgQ_JNUaMvHz-knulcQ-1
Received: by mail-ej1-f71.google.com with SMTP id qw30-20020a1709066a1e00b006f45e7f44b0so364203ejc.5
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 22:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s5aF1SwBsINrQMkQK6jj8/AJIyTgJ8TbouQ8o7y74Qw=;
        b=quajnJnloe4FrbQ7eZTrPlP2Ep2IjpgmJaH9PMkhpVwaMaCWFo/ArdTcYjpcOCnR/9
         RK13FOrDdie+fpfEPNxtmPrjAmRp4S1rg/PhJpz5exo9eoIeREWHoEGY9N+4EP6o91FJ
         zotbZyAUlK06vi/SODCNcxg5+ZhVVXMHh6ZCENgDmEKQyTF845voecfa8lBeqPvbPqaP
         Ct+kQF08h87jZ1jbB1cZy0niwy6QCsmGyEJBRyRA1P1VkIvGYtOHkiTXr+kh8R/tZTGn
         bLRXKrlKwsFVStQA80LX/6KEtcKUXgXCSAGAFaEtgYXf6PUKE5/yOzLWQjOenvZZ5kMz
         LgDA==
X-Gm-Message-State: AOAM532riV+XsKFQSIROcmo2fpEyko96YWvstLwKsct3ZYyZoqUZNLYA
        3m7fJ2xNmbko4XJK1pdw6lOI7nmj/XJVNE3SPesaH1Bq8OSy2c5ixQGjAk/sDsIJTUhQKjKTzHS
        G9YHYc4v4u28Y
X-Received: by 2002:aa7:cd87:0:b0:427:f800:220d with SMTP id x7-20020aa7cd87000000b00427f800220dmr23052126edv.112.1652851381428;
        Tue, 17 May 2022 22:23:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrTT0RINL0V+teBiwef2JunFlgvMj8o5XGCORUKJ0vEF3/8oynflK7QSDzhoZBgKLTc3+BTA==
X-Received: by 2002:aa7:cd87:0:b0:427:f800:220d with SMTP id x7-20020aa7cd87000000b00427f800220dmr23052110edv.112.1652851381223;
        Tue, 17 May 2022 22:23:01 -0700 (PDT)
Received: from redhat.com ([109.253.208.62])
        by smtp.gmail.com with ESMTPSA id ay18-20020a056402203200b0042aa08c7799sm712321edb.62.2022.05.17.22.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 22:23:00 -0700 (PDT)
Date:   Wed, 18 May 2022 01:22:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ebiggers@kernel.org, davem@davemloft.net
Subject: Re: [PATCH] vhost_net: fix double fget()
Message-ID: <20220518012236-mutt-send-email-mst@kernel.org>
References: <20220516084213.26854-1-jasowang@redhat.com>
 <20220516044400-mutt-send-email-mst@kernel.org>
 <YoQa4wzy9jSwDY7E@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoQa4wzy9jSwDY7E@zeniv-ca.linux.org.uk>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 10:00:03PM +0000, Al Viro wrote:
> On Mon, May 16, 2022 at 04:44:19AM -0400, Michael S. Tsirkin wrote:
> > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > 
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > and this is stable material I guess.
> 
> It is, except that commit message ought to be cleaned up.  Something
> along the lines of
> 
> ----
> Fix double fget() in vhost_net_set_backend()
> 
> Descriptor table is a shared resource; two fget() on the same descriptor
> may return different struct file references.  get_tap_ptr_ring() is
> called after we'd found (and pinned) the socket we'll be using and it
> tries to find the private tun/tap data structures associated with it.
> Redoing the lookup by the same file descriptor we'd used to get the
> socket is racy - we need to same struct file.
> 
> Thanks to Jason for spotting a braino in the original variant of patch -
> I'd missed the use of fd == -1 for disabling backend, and in that case
> we can end up with sock == NULL and sock != oldsock.
> ----
> 
> Does the above sound sane for commit message?  And which tree would you
> prefer it to go through?  I can take it in vfs.git#fixes, or you could
> take it into your tree...

Acked-by: Michael S. Tsirkin <mst@redhat.com>
for the new message and merging through your tree.

-- 
MST

