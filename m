Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67398453DB
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 07:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbfFNFN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 01:13:57 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43912 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfFNFN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 01:13:57 -0400
Received: by mail-pf1-f194.google.com with SMTP id i189so662523pfg.10
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 22:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7L7uajw4KCsbL/S4E35UjNUKEFnxH/l2jD/CiFHPlB4=;
        b=iVgLfh3u2rK3LSidDHhJBtdtNtpSlz4dIEb1BDsj4Re2fjkTLPAq5VHIrDbtF7rfc6
         5a9vwqPeA/oCez/a3NCM+60PRvHQV0ltptm4u18TbaZDEEEiYlVGWcXj0ugZtZMkqFnM
         ltnmFCb7F68lK6w+sv8Frqic/ZXdf9np/Ivm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7L7uajw4KCsbL/S4E35UjNUKEFnxH/l2jD/CiFHPlB4=;
        b=gv90lYS3LoMsZUpTX0DKr4Y+2d6HPuTrujw0NO0dOr4akBjp1w3+cTMRu9JSO6Gk57
         I7gi17q8memQuR5IoFMTw0qcF8R7Z5UNpdMvlYrOKG2Ud1Nyd56rsZ4GSZ1YJYvoRQvV
         TGGftpOE7oX7gc/lbNVf2ub84e2HFLJKIpa1cuCt2RQZHmrurVqCsNhoZDoejhP3q6IR
         1n99z7OANb6tZ8/NFIHJItc8uAKZTLkHkcoyMr9OGfdOYYYuU4aaNujQjHqXzuAKJLrd
         l+Pgwb4jmWhgUTqQ5ye34jVyvMPyI9gJ73x6EXAujYWkSYslZsNaAp6Wg8Bl44h6/EHa
         Jpsw==
X-Gm-Message-State: APjAAAWxS5T3XLPl0G7yKhXW6uWpkj5aXaeeh0F1g3sCUCet5bYRUgob
        BIelfaKKj6hnMRakxeMNvc/nefzhJZpPeQ==
X-Google-Smtp-Source: APXvYqzTfasIXQ0R9bH+BHnjS/rxhZOCyiy3olY/JYV+P2HTQ7p4rEZDPtcIb7Np5EQm4YDFboUW8Q==
X-Received: by 2002:a63:6948:: with SMTP id e69mr23166361pgc.441.1560489236782;
        Thu, 13 Jun 2019 22:13:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f13sm1417022pje.11.2019.06.13.22.13.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Jun 2019 22:13:55 -0700 (PDT)
Date:   Thu, 13 Jun 2019 22:13:54 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Dave Martin <Dave.Martin@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Kostya Serebryany <kcc@google.com>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Evgeniy Stepanov <eugenis@google.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Lee Smith <Lee.Smith@arm.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        enh <enh@google.com>, Robin Murphy <robin.murphy@arm.com>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: Re: [PATCH v17 03/15] arm64: Introduce prctl() options to control
 the tagged user addresses ABI
Message-ID: <201906132209.FC65A3C771@keescook>
References: <cover.1560339705.git.andreyknvl@google.com>
 <a7a2933bea5fe57e504891b7eec7e9432e5e1c1a.1560339705.git.andreyknvl@google.com>
 <20190613110235.GW28398@e103592.cambridge.arm.com>
 <20190613152632.GT28951@C02TF0J2HF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613152632.GT28951@C02TF0J2HF1T.local>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 04:26:32PM +0100, Catalin Marinas wrote:
> On Thu, Jun 13, 2019 at 12:02:35PM +0100, Dave P Martin wrote:
> > On Wed, Jun 12, 2019 at 01:43:20PM +0200, Andrey Konovalov wrote:
> > > +static int zero;
> > > +static int one = 1;
> > 
> > !!!
> > 
> > And these can't even be const without a cast.  Yuk.
> > 
> > (Not your fault though, but it would be nice to have a proc_dobool() to
> > avoid this.)
> 
> I had the same reaction. Maybe for another patch sanitising this pattern
> across the kernel.

That's actually already happening (via -mm tree last I looked). tl;dr:
it ends up using a cast hidden in a macro. It's in linux-next already
along with a checkpatch.pl addition to yell about doing what's being
done here. ;)

https://lore.kernel.org/lkml/20190430180111.10688-1-mcroce@redhat.com/#r

-- 
Kees Cook
