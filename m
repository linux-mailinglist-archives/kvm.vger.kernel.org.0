Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9862A38B99B
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 00:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhETWsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 18:48:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhETWsD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 18:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621550801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X5RpP/VMznC5Ftsyv3NUGp3x8DQXjxoDf9s9GoEB+v8=;
        b=dBWyzyT6JJwWOjo1bUX5Hvi2Vw3GJv9o1us+sTZYWqFyjx/6xiLO17kxpzkSjSOXs20CRG
        bDViuNP2zNuSyYpThhvN8nrfv2IlZB6LmKAv1GMeT529buAfeYn6TQlVbj6OIw7cv1UgQ6
        7pe7HdpPeNtb3mfavBoqs7xqESbN0Oo=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-hSZm6XcIPrSzujHm4DzAZw-1; Thu, 20 May 2021 18:46:39 -0400
X-MC-Unique: hSZm6XcIPrSzujHm4DzAZw-1
Received: by mail-qk1-f199.google.com with SMTP id d18-20020a05620a2052b02902eabc6fa35eso13909996qka.17
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 15:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X5RpP/VMznC5Ftsyv3NUGp3x8DQXjxoDf9s9GoEB+v8=;
        b=AG3Y7sVjN0d1iZohnQNs9IzVHcj24DfEUjRhbhRS6qo0CU5aBJG1VkyHwcZThmIXON
         CNhheoF4JxaZvX10jhZaazMsgENOpk17wITANohe1IeFbciqhzYs91P10pmS+QZS69fo
         p3apqQVEHNb5RGipnAuTsyrN/mpU5PjANWplYcrVEZzlW3Hsda7CMUVz3DKow1gTakEE
         y46Ec+6F+3N4vjmEIiXjQfqGLlMewkTfmArfCUV+bU8Nq025IHq+H16qiaBTRm3o+udU
         WXYX6KVkhGA1EczvWWL1pVp5NPIUTtjPUpC4oHfhZ3azO3qZphSFK2ZwMEF09SGo/iFY
         Cing==
X-Gm-Message-State: AOAM530n7JqLTrBWl0NDnc7waFbt1NoMu4MreyDUbj74+//iJ/HE9gda
        OjEpEjn1+5jwn+hgvNIA5QR8dZ3X8NPuOWdIBFe4E5USRzhYsRJ3U7eLWi62IzO1u2LjCy+WnLm
        9UynHo5E4P3np
X-Received: by 2002:a05:620a:752:: with SMTP id i18mr8224054qki.362.1621550799072;
        Thu, 20 May 2021 15:46:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmLvbWl8HwVVlidezkKkIhbi0kO1RGqOetIzS+fjHgVpq/DxT1PvEu3QXlSKuyA7Ts4LjZKQ==
X-Received: by 2002:a05:620a:752:: with SMTP id i18mr8224031qki.362.1621550798837;
        Thu, 20 May 2021 15:46:38 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id z17sm3372628qkb.59.2021.05.20.15.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:46:38 -0700 (PDT)
Date:   Thu, 20 May 2021 18:46:37 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()
Message-ID: <YKbmzUpR9AIoa9na@t490s>
References: <20210520212654.712276-1-dmatlack@google.com>
 <YKbZAT/cE5SobbGX@t490s>
 <CALzav=dixRORFDyeaj67=SyXko9t++qGgnCJrhWD7bBKqz_3mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=dixRORFDyeaj67=SyXko9t++qGgnCJrhWD7bBKqz_3mA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 02:56:41PM -0700, David Matlack wrote:
> On Thu, May 20, 2021 at 2:47 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Thu, May 20, 2021 at 09:26:54PM +0000, David Matlack wrote:
> > > vm_get_max_gfn() casts vm->max_gfn from a uint64_t to an unsigned int,
> > > which causes the upper 32-bits of the max_gfn to get truncated.
> > >
> > > Nobody noticed until now likely because vm_get_max_gfn() is only used
> > > as a mechanism to create a memslot in an unused region of the guest
> > > physical address space (the top), and the top of the 32-bit physical
> > > address space was always good enough.
> >
> > s/top/bottom/?
> 
> I guess it depends on your reference point :). The existing comments
> under tools/testing/selftests/kvm use the convention that "top" ==
> high addresses.

Ah I was thinking in another way (converting the unsigned int to u64 is taking
the "bottom" of the 8bytes field), while you meant we allocate memory from the
top. Yeah then it looks good.

> 
> >
> > Looks right.. thanks for fixing it!
> >
> > >
> > > This fix reveals a bug in memslot_modification_stress_test which was
> > > trying to create a dummy memslot past the end of guest physical memory.
> > > Fix that by moving the dummy memslot lower.
> >
> > Would it be better to split the different fixes?
> 
> I'm fine either way. I figured the net delta was small enough and the
> fixes tightly coupled so sending as one patch made the most sense. Is
> there value in splitting this up?

Feel free to keep it a single patch if no one else complains. :)

Thanks,

-- 
Peter Xu

