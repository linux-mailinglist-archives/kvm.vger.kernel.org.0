Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F615974BF
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 19:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241022AbiHQRGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 13:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240899AbiHQRGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 13:06:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D70098D01
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 10:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660755966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GM7xEfwIL/rtVq+hrRvQ1hKtp4szoR86mfFhzUxnc2Q=;
        b=gA67Z01zDe00jhSYiaWrQjPXh7UFdb+EUimAjIi88GuYihD/2bK39Ji11OoTcNtgAAjs0y
        w767H0YTsDxuwc2rzRiL/Giwj0GsEfQvYJ1IaberEGUhKZJsWqc74R3tJ9KL+2UHjAcYgY
        cOHBx8klMvOfk3lihb5WBGg9ciIL9Zw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-178-zAifqdAKN06dPjkertHfhw-1; Wed, 17 Aug 2022 13:05:56 -0400
X-MC-Unique: zAifqdAKN06dPjkertHfhw-1
Received: by mail-wm1-f69.google.com with SMTP id az42-20020a05600c602a00b003a552086ba9so1324297wmb.6
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 10:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=GM7xEfwIL/rtVq+hrRvQ1hKtp4szoR86mfFhzUxnc2Q=;
        b=6gO4rW01pr/9xK4psOXnheuq9y7jYk4+aWlcbqoRDvlCLVialwkoqw19KkYw7wSZaF
         4qaTh+1mTms07/DWGqxRBGVLmeDYJd0g1E6kjs3ypIUgy7eblrvSCFqRwGn1DhHCD8LI
         2hGp1Is2wiHcyLZ0CBNlGZTdwqgaEJ53wO9ShE0GwrJWBFOniqe3jv4XlkLPg5Cgyoo8
         IH04shcVvNj0vQ093TJOHgcDDOeOaP7UdB9NrqGLYlybU7lig6e0AtYUWD5s9/vpKJtz
         FwjauWGuBzelGuLIrQu+XvwCiOkhzeTaTBR4vuHshYLCg8y99/YspZfMW+zb1R+LqP7k
         6BjQ==
X-Gm-Message-State: ACgBeo13UBkTdj7Kexz7j/bOx7esAP33pyuAMK8UAdY4mj4brkKZ4YIi
        PX1UpPI38iL7DY+Gshko0NEZ4YXlzEYwRoGyscqB2sMg4d21GMupyDmynchTUd72jXTwN+gFghP
        ODfxJpT2+w80b
X-Received: by 2002:a05:600c:4f4f:b0:3a5:a530:4fd7 with SMTP id m15-20020a05600c4f4f00b003a5a5304fd7mr2807124wmq.36.1660755955456;
        Wed, 17 Aug 2022 10:05:55 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7W0d2By6SxNehemYA/+2Tlkpn9sxMVpxE7j6tOqnVgLuFdYAz5FyA4g0pMz5pYYDOiSN6AMw==
X-Received: by 2002:a05:600c:4f4f:b0:3a5:a530:4fd7 with SMTP id m15-20020a05600c4f4f00b003a5a5304fd7mr2807106wmq.36.1660755955238;
        Wed, 17 Aug 2022 10:05:55 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id m9-20020a7bce09000000b003a3442f1229sm2645479wmc.29.2022.08.17.10.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:05:54 -0700 (PDT)
Date:   Wed, 17 Aug 2022 13:05:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Will Deacon <will@kernel.org>
Cc:     stefanha@redhat.com, jasowang@redhat.com,
        torvalds@linux-foundation.org, ascull@google.com, maz@kernel.org,
        keirf@google.com, jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        crosvm-dev@chromium.org
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
Message-ID: <20220817130510-mutt-send-email-mst@kernel.org>
References: <20220805181105.GA29848@willie-the-truck>
 <20220807042408-mutt-send-email-mst@kernel.org>
 <20220808101850.GA31984@willie-the-truck>
 <20220808083958-mutt-send-email-mst@kernel.org>
 <20220817134821.GA12615@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817134821.GA12615@willie-the-truck>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 02:48:22PM +0100, Will Deacon wrote:
> On Mon, Aug 08, 2022 at 08:45:48AM -0400, Michael S. Tsirkin wrote:
> > > > Also yes, I think it's a good idea to change crosvm anyway.  While the
> > > > work around I describe might make sense upstream I don't think it's a
> > > > reasonable thing to do in stable kernels.
> > > > I think I'll prepare a patch documenting the legal vhost features
> > > > as a 1st step even though crosvm is rust so it's not importing
> > > > the header directly, right?
> > > 
> > > Documentation is a good idea regardless, so thanks for that. Even though
> > > crosvm has its own bindings for the vhost ioctl()s, the documentation
> > > can be reference or duplicated once it's available in the kernel headers.
> > > 
> > So for crosvm change, I will post the documentation change and
> > you guys can discuss?
> 
> FYI, the crosvm patch is merged here:
> 
> https://github.com/google/crosvm/commit/4e7d00be2e135b0a2d964320ea4276e5d896f426
> 
> Will

Great thanks a lot!
I'm on vacation next week but will work on it afterwards.

-- 
MST

