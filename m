Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9619D42196E
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 23:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhJDVqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 17:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbhJDVqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 17:46:18 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E33AC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 14:44:28 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id e15so77575179lfr.10
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 14:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8GEkiv0sq6zlMGv4NF1lNy8C8AUqg+nP0Bqg175vseE=;
        b=NG02/Ikbk4YGE8T2Vt8L0RsICL38NHXIaBpmggRGOFu4AuA1qz2/4V3JJV1NI/YLt1
         Z3/Lqv5SSUGtd+WsinHuA5KdO/1igwtODKhc86vFgIdcL8DESxbsfFpaEIfPwAfUUPxY
         MksFPpsQC9clzfOwvQNLkDhaLRIx2HIY+ViZnmmxYfI8t9fOB1E1wcsFoMQ1xeKP58sI
         VNhcZ9UXvfjttx6ttE6rvV57fFyXFBFv6vtUS3R8D7fyYryA8bzpVws8fD4UwtBmWxBp
         Z4NW8AgihNRhGT3GH9DcYhSyl6Rqlb+/4wA/lP4hjvr6Y/LIuL3Cx9QuOEIURlUeDYZa
         oZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8GEkiv0sq6zlMGv4NF1lNy8C8AUqg+nP0Bqg175vseE=;
        b=wiMf38NlWaFziIuBqU6FTsqCW3ZkKQrXSgHz+7bsACWsKadfFYWCwyTzeUl44h6F67
         40lnEOGm7Y25+XdD3quSpb7CjmbusVfgar5rvN/6lEaGQdnf5EwEdk9UThCn6aZF+xjS
         eE3gJU2mzHmKpSex1nUQOJOd7NwEOasz0BQCCT8canv1P3+IQnbJUEGh5vZniXGkYzRV
         TEeEgCeanVnLqA7YZVRgIBq36teBT8coWL7U3gBxmKwS2tYP7LcDBeNUJJWMRFwL4UiS
         bjMXmvlAnOGB31udhek1UjCaVrLQZYGbOqNONA5lhNSx8bD2hVAsw8n6p7PkksysChBV
         uaew==
X-Gm-Message-State: AOAM532hbYjiJ5j4u5YuaXgJeaX3hXcwho4lf84AMlwOsXs8yoLtZrck
        uaZR8f+wvyuviuyxEP2cQWVldpBHLpszbDWJENE=
X-Google-Smtp-Source: ABdhPJy0oKsBg8OcqP9J1F71J6aDXeOW8ISXw5wZ2bMJoGJes1O88QOgLgdeTcs5PAOOifnxn2MsDQlnzCc34LKj5AM=
X-Received: by 2002:a05:6512:10cf:: with SMTP id k15mr15834197lfg.617.1633383866704;
 Mon, 04 Oct 2021 14:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-8-zixuanwang@google.com> <20211004130640.hdse6xkg4m6jx5c2@gator>
In-Reply-To: <20211004130640.hdse6xkg4m6jx5c2@gator>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 4 Oct 2021 14:43:52 -0700
Message-ID: <CAEDJ5ZS14keuvWEofbi2YD9QZ8ZE3nGZoq421wWEXy5jQnFkaQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 07/17] x86 UEFI: Set up memory allocator
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 4, 2021 at 6:08 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 27, 2021 at 03:12:12AM +0000, Zixuan Wang wrote:
> > KVM-Unit-Tests library implements a memory allocator which requires
> > two arguments to set up (See `lib/alloc_phys.c:phys_alloc_init()` for
> > more details):
> >
> >  #endif /* TARGET_EFI */
> > --
> > 2.33.0.259.gc128427fd7-goog
> >
>
> How about just getting the memory map (efi_boot_memmap) and then exiting
> boot services in arch-neutral code and then have arch-specific code decide
> what to do with the memory map?
>
> Thanks,
> drew
>

I see, I will try to refactor the code in the next version:

1. Defines an arch-neutral data structure to store the memory map
2. Calls an arch-neutral function to get the memory map
3. Exits UEFI boot services
4. Calls an arch-specific function to process the memory map

Best regards,
Zixuan
