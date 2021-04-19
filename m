Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581E53649DD
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 20:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240058AbhDSSgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 14:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238725AbhDSSgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 14:36:50 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D4BC06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:36:20 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id k25so36427993oic.4
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+EaVodVxNSn+D/fwaJGQ+R1xLJuoh8guKpmNOWOYpgk=;
        b=o6hFMHegkbxozBAYktu5Big4qdDiidO++tuq0jNMkwH/Or4wQw0+rxlJr4FNQHxh96
         QRsv4nztG6DjRR1IKAUVvjBMZP1d9IVOZriFILzL2IgcT3GdSgBbGI1MX8ik/kjqxdtL
         m+TzTz9DE+YYm0j8SWft53zDVKPO4+GzEKPkv1rHgbmxiqx1m4Ec3wS5HEVf3nxOrGgz
         KkrArrXUIf/RUd1EvHz97aVBUcQIRbFNTV7QM2cdh53tLd+QFgaFDD99CkJPbot8kQ8o
         B4qtTWghuoIy9LBaGqYqpoc4mrBiYitukZVkh/8iCB2+VieFUGXCZrc60mHa0nIsINgM
         Ol7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+EaVodVxNSn+D/fwaJGQ+R1xLJuoh8guKpmNOWOYpgk=;
        b=Eqz9ADQnkV7DZA6gV1Pd8GLSMf7gCZLjxYZNgKSAf2ORLERIB7UHmOw1oDuBjTxB79
         eu/5p+bEJR+xOqhitkV5NaKHywJUF7jbDeGlKlqBPDeV9pngvZ3azK5fNXqq4BWym0iu
         lUspNOerYM78GHKiZyfi5EhuvKopogq7evzjK27rwOTFYZ9a1VZlMB7B5OLD2udtWwMi
         Igx43CN913K6LoiMqbRahHPwM8hKpn62UNMseBy4MGRR52ixKOibwu7L3prdqZNJuvhf
         hhzVERW0YCKJv8+RqYncMlD3ukm1l0PRffteGBqwfVj8wdZy7gFtXNcUSONxUYKTJyXJ
         502w==
X-Gm-Message-State: AOAM531OJgbt/+AkbjZD/w6krXaVwE2AulexnfB+BzWA7bhTqLCdrTPh
        YRVfqB8aLkGPwriyNlXWzisxd/atBVuhhfujRad5Kg==
X-Google-Smtp-Source: ABdhPJxJwG/eXheK5gyTmyWuMYOmw1WV+rmHlw5Xsv4/FWBbo/X0N1oJqGLcag0w84v0AfVnu+kfrN2wwi1E3TOncts=
X-Received: by 2002:aca:3cd6:: with SMTP id j205mr337103oia.28.1618857379779;
 Mon, 19 Apr 2021 11:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-3-krish.sadhukhan@oracle.com> <fdf27d2b-d0b6-96fa-f661-bef368f04469@redhat.com>
 <711a0aa9-c46e-7bd3-5161-49bd9dd56286@oracle.com> <7106e7c6-c920-86fb-003e-51a42dfaf700@redhat.com>
In-Reply-To: <7106e7c6-c920-86fb-003e-51a42dfaf700@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 19 Apr 2021 18:36:08 +0000
Message-ID: <CALMp9eSuUuBHT8k8jxsyi9sOzMMXZEf3cpkRKyCEBpGtExGung@mail.gmail.com>
Subject: Re: [PATCH 2/7 v7] KVM: nSVM: Define an exit code to reflect
 consistency check failure
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021 at 11:28 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 19/04/21 19:57, Krish Sadhukhan wrote:
> > The reason why I thought of this is that SVM implementation uses only
> > the lower half, as all AMD-defined exit code are handled therein only.
> > Is this still going to cause an issue ?
>
> I would have to check what happens on bare metal, but VMEXIT_INVALID is
> defined as "-1", not "FFFFFFFFh", so I think it should use the high 32
> bits (in which case KVM is wrong in not storing the high 32 bits).

And VMEXIT_BUSY is -2.
