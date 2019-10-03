Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177E4C9AAB
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 11:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfJCJWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 05:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbfJCJWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 05:22:18 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C5DBD796E9
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 09:22:17 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id v17so439194wru.12
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 02:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=HAKXNqxlu9hZBy+XRHRcb7TZaV3lei632APcndVyxUk=;
        b=VZhtS7XZNPPEk4/smKUQ40Js9BZ/bcDjuQnZ4aUtOI9x+KxC0XuY86d6PUqWwNnrwg
         wia75l9EylLAc4S9csKQ4Lwx7/ICcs5IsKY4Hs1tCOjKI5/IwJiTCRy7hLaiRgP/IAEz
         XY9rEiOiPUue9MAZEdM8BBSWXQvQstfVBpRRzN13KXrxWhyt1tAjacihidR316VsJowC
         dxE+rq3pmu0b0TxlT9kRzMArb8OrViSsWZ2bwMSv2DO7l3gzH2lgnhY0PlPRtWbi10Ga
         oUDPyx3MTjCzpBBWFik70JCcR38d2CZfb1LeJM2KPnIPGVQZPUNofRzxc5NXfDFvMMog
         +S0w==
X-Gm-Message-State: APjAAAX1SIxQD+O3cblFT2S4t6HX+1zchtU61EwCEr8nNRVWI7fLCO4s
        g7zr3PlTaMTY/5+o6w80bYIIgYChReav6dmHhzh3zut1rJVRER8mJ7WtxMSXo99kFuEftUbLfwm
        C+fss5Uu14Q0m
X-Received: by 2002:adf:e701:: with SMTP id c1mr6393786wrm.296.1570094536555;
        Thu, 03 Oct 2019 02:22:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyKdm7DfRH9ongAz9t7tr/3VrJ7SkrtbeY99qjcjiPSRnYpusQl2V4khxoImjgoyGDORVpe6Q==
X-Received: by 2002:adf:e701:: with SMTP id c1mr6393773wrm.296.1570094536306;
        Thu, 03 Oct 2019 02:22:16 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id l11sm2106255wmh.34.2019.10.03.02.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:22:15 -0700 (PDT)
Date:   Thu, 3 Oct 2019 11:22:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     qemu-devel@nongnu.org,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH] accel/kvm: ensure ret always set
Message-ID: <20191003092213.etjzlwgd7nlnzqay@steredhat>
References: <20191002102212.6100-1-alex.bennee@linaro.org>
 <05d59eb3-1693-d5f4-0f6d-9642fd46c32a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05d59eb3-1693-d5f4-0f6d-9642fd46c32a@redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 02, 2019 at 01:08:40PM +0200, Paolo Bonzini wrote:
> On 02/10/19 12:22, Alex Bennée wrote:
> > Some of the cross compilers rightly complain there are cases where ret
> > may not be set. 0 seems to be the reasonable default unless particular
> > slot explicitly returns -1.
> > 

Even Coverity reported it (CID 1405857).

> > Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> > ---
> >  accel/kvm/kvm-all.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index aabe097c41..d2d96d73e8 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -712,11 +712,11 @@ static int kvm_physical_log_clear(KVMMemoryListener *kml,
> >      KVMState *s = kvm_state;
> >      uint64_t start, size, offset, count;
> >      KVMSlot *mem;
> > -    int ret, i;
> > +    int ret = 0, i;
> >  
> >      if (!s->manual_dirty_log_protect) {
> >          /* No need to do explicit clear */
> > -        return 0;
> > +        return ret;
> >      }
> >  
> >      start = section->offset_within_address_space;
> > @@ -724,7 +724,7 @@ static int kvm_physical_log_clear(KVMMemoryListener *kml,
> >  
> >      if (!size) {
> >          /* Nothing more we can do... */
> > -        return 0;
> > +        return ret;
> >      }
> >  
> >      kvm_slots_lock(kml);
> > 
> 
> Queued, thanks.
> 
> Paolo
> 

-- 
