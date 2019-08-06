Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D3E832D1
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 15:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731450AbfHFNhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 09:37:07 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45550 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730006AbfHFNhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 09:37:07 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so62922591qkj.12
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2019 06:37:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+EmwYezlru/6l1RGke6OfmjMerhgmwmHntHPbq6+2AE=;
        b=nuU40vcfl31YmEKRFvjAXYABj/FcfqI+6AD2quXVgKPKtRruenbFVh4PG3U1OM3I0t
         UFPeGCniKLQlQtalTpOY0RUt+36p9E++iP1+UAjiSb5kyRmJOZCz0J/a26hdeaoqYYWc
         uleqgGeJ0lBy5c7mHfh7ECkFwRP13MaAb12mh9a06Ebh7Ui9y0/wn+wdvtbG8qA4O8by
         kdFYNFzZzQbMLfspbfE4LTpyF0LckhBzCj4/0Tq7AmeDgz0oES7X9UWLJ9gwNsF5rYyy
         /JdcOvjpR02HD2//f5+C34JprvPpFn8wGFQgffBMZSUoxJXrsrgqrOmJFrT7/jKXhQPZ
         RkNA==
X-Gm-Message-State: APjAAAUQo6Vxex/HfzNGA6xPS8KS/sIdkwG0ipL+Z/m5Ps7uSzR7s4Ok
        8fwqoycNsaYjZedkVueUXuD4Bg==
X-Google-Smtp-Source: APXvYqwQogResfBtEcBuAcFTuCtTWGzeNFF/0eeIOxkxJPkA8JpnI8WBDTcUIzFbb3AvBDILVnFfYQ==
X-Received: by 2002:ae9:efc6:: with SMTP id d189mr2946499qkg.323.1565098625407;
        Tue, 06 Aug 2019 06:37:05 -0700 (PDT)
Received: from redhat.com ([147.234.38.1])
        by smtp.gmail.com with ESMTPSA id q73sm24068906qke.90.2019.08.06.06.37.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 06:37:04 -0700 (PDT)
Date:   Tue, 6 Aug 2019 09:36:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190806093633-mutt-send-email-mst@kernel.org>
References: <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
 <20190802100414-mutt-send-email-mst@kernel.org>
 <20190802172418.GB11245@ziepe.ca>
 <20190803172944-mutt-send-email-mst@kernel.org>
 <20190804001400.GA25543@ziepe.ca>
 <20190804040034-mutt-send-email-mst@kernel.org>
 <20190806115317.GA11627@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806115317.GA11627@ziepe.ca>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 06, 2019 at 08:53:17AM -0300, Jason Gunthorpe wrote:
> On Sun, Aug 04, 2019 at 04:07:17AM -0400, Michael S. Tsirkin wrote:
> > > > > Also, why can't this just permanently GUP the pages? In fact, where
> > > > > does it put_page them anyhow? Worrying that 7f466 adds a get_user page
> > > > > but does not add a put_page??
> > > 
> > > You didn't answer this.. Why not just use GUP?
> > > 
> > > Jason
> > 
> > Sorry I misunderstood the question. Permanent GUP breaks lots of
> > functionality we need such as THP and numa balancing.
> 
> Really? It doesn't look like that many pages are involved..
> 
> Jason

Yea. But they just might happen to be heavily accessed ones....

-- 
MST
