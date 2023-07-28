Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79130767756
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 23:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbjG1VBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 17:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjG1VBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 17:01:37 -0400
Received: from mailrelay3-1.pub.mailoutpod2-cph3.one.com (mailrelay3-1.pub.mailoutpod2-cph3.one.com [IPv6:2a02:2350:5:402::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D63D448D
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 14:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=rsa1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=2M7I6GspW66DQLncO4JKL/r3gVWBlh/Z61h7j/4ZXwQ=;
        b=VmorxddsvliAc2zCAOdnHcnfpXk3HL6FA27GlnhkXSDoGE0taO0g/r11MTt0+sI0kBn9KF5g/nrJO
         YBHws5h7tg8z3vU2AXdiQl9zEYuH8U/rlDvV9qOR0LqdOqrOTT8Q280NatZ58QFneNl5qS40d2PF4M
         EUS5sJGrrFwpIycoYicR9+NrqKdO9dYIH7hOkxrBCPEzDbnuW5lyt3OSZ3qejIsC5BlnWolgnIV57W
         oWgE09YqMgvptwaf+e3S6UG3fSVu9ZZWZQL0aj4IVi0oMKAI1oKRsI8Jyw+i3pIMQPCcYbWIvLP5Ea
         2ZNE/tlQONtqNXH1lFqn6N8xJ+w3WZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=ed1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=2M7I6GspW66DQLncO4JKL/r3gVWBlh/Z61h7j/4ZXwQ=;
        b=dkD1HMHNc3u2lokBeS9EgDAhIVt0/YZ+STE3czXIeWa0urEuoYnPhcLDxQzwHTeu678MjBdhgtiY7
         JMYlTDXDg==
X-HalOne-ID: eaf56fd1-2d89-11ee-8d0f-b90637070a9d
Received: from ravnborg.org (2-105-2-98-cable.dk.customer.tdc.net [2.105.2.98])
        by mailrelay3 (Halon) with ESMTPSA
        id eaf56fd1-2d89-11ee-8d0f-b90637070a9d;
        Fri, 28 Jul 2023 21:01:29 +0000 (UTC)
Date:   Fri, 28 Jul 2023 23:01:27 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Helge Deller <deller@gmx.de>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 00/47] fbdev: Use I/O helpers
Message-ID: <20230728210127.GA1156027@ravnborg.org>
References: <20230728182234.10680-1-tzimmermann@suse.de>
 <c1a4b7c9-50f2-c43f-277d-c2af9ccc0b50@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1a4b7c9-50f2-c43f-277d-c2af9ccc0b50@gmx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Helge,

On Fri, Jul 28, 2023 at 08:46:59PM +0200, Helge Deller wrote:
> On 7/28/23 18:39, Thomas Zimmermann wrote:
> > Most fbdev drivers operate on I/O memory.
> 
> Just nitpicking here:
> What is I/O memory?
> Isn't it either memory, or I/O ?
> I mean, I would never think of the cfb* draw functions under I/O.
> 
> > And most of those use the
> > default implementations for file I/O and console drawing. Convert all
> > these low-hanging fruits to the fb_ops initializer macro and Kconfig
> > token for fbdev I/O helpers.
> 
> I do see the motivation for your patch, but I think the
> macro names are very misleading.
> 
> You have:
> #define __FB_DEFAULT_IO_OPS_RDWR \
>         .fb_read        = fb_io_read, \
>         .fb_write       = fb_io_write
> 
> #define __FB_DEFAULT_IO_OPS_DRAW \
>         .fb_fillrect    = cfb_fillrect, \
>         .fb_copyarea    = cfb_copyarea, \
>         .fb_imageblit   = cfb_imageblit
> 
> #define __FB_DEFAULT_IO_OPS_MMAP \
>         .fb_mmap        = NULL /* default implementation */
> 
> #define FB_DEFAULT_IO_OPS \
>         __FB_DEFAULT_IO_OPS_RDWR, \
>         __FB_DEFAULT_IO_OPS_DRAW, \
>         __FB_DEFAULT_IO_OPS_MMAP
> 
> I think FB_DEFAULT_IO_OPS is OK for read/write/mmap.
> But I would suggest to split out __FB_DEFAULT_IO_OPS_DRAW.
> Something like:
> #define FB_DEFAULT_IO_OPS \
>         __FB_DEFAULT_IO_OPS_RDWR, \
>         __FB_DEFAULT_IO_OPS_MMAP


> #define FB_DEFAULT_CFB_OPS \
>         .fb_fillrect    = cfb_fillrect, \
>         .fb_copyarea    = cfb_copyarea, \
>         .fb_imageblit   = cfb_imageblit

The prefix cfb, I have recently learned, equals color frame buffer.
They are named such for purely historical reasons.

What is important is where the data are copied as we have two
implementations of for example copyarea - one using system memory, the
other using IO memory.

The naming FB_DEFAULT_IO_OPS says this is the defaults to IO memory
operations, which tell what they do and avoid the strange cfb acronym.

Reserve cfb for color frame buffers only - and maybe in the end rename
the three cfbcopyarea, cfbfillrect, cfbimgblt to use the io prefix.
Which is much simpler to do after this series - and nice extra benefit.

I hope this properly explains why I like the current naming and
acked it when the macros were introduced.

	Sam
