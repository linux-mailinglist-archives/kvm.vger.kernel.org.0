Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31ACC3DF535
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 21:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239525AbhHCTPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 15:15:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239079AbhHCTPM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 15:15:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628018101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+rSWKM/T14hSNJ7CCzHqgndf9sQoQa3vUJu76cRGCd4=;
        b=VJwvzzvHIrjPvzGs/SV6VENfbCCSvdt3tPaDL8IkN9MlN7rahXuWzeExUzZSMiCB7Sv3se
        /VEMjxzRlTrWZffBmg0YmjSU8+bKHXIm0yUJylKJVsOdBrPSuIruPHi9jO4Y8nGra4w6Je
        8aiJ34Av2ot83zQj4f0wNEqrbgzSm1c=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-AQhjPkj6MgSPZLjx8bNDYw-1; Tue, 03 Aug 2021 15:15:00 -0400
X-MC-Unique: AQhjPkj6MgSPZLjx8bNDYw-1
Received: by mail-qk1-f197.google.com with SMTP id b4-20020a3799040000b02903b899a4309cso206018qke.14
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 12:14:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+rSWKM/T14hSNJ7CCzHqgndf9sQoQa3vUJu76cRGCd4=;
        b=TIK8JBI4EMlbhu8TELO3iUr0n/eZ6wdGpxevV8E82+wdVqHFaz0iTrVvR9ypAdBaN9
         U8S9YvGafWUXlUA5QDG1Lv2tO1E3tUxrZcG+oGTJfKB7pVJQX3OvltmiwS7tItAU1SRT
         ZS0y5KoooPyDY/Zm+k34gkbMyJOW69a1HQpxD+ZLN1SGPbW0/lQqHnTi7nmZeYWtGY0J
         kJHWv9oCwtqj76tl5pF5BfZN0Aqs1dk2OPqtjDjWBPucJ/wKgYV0PU5/4+OZb1hVtVYf
         s/h/nSC9b0TQf/JVTi7+vCBn4k4DF3N+GTOecGdVyHLqiAwHpN4SguAyphPGPwoWzr3i
         HJ+Q==
X-Gm-Message-State: AOAM532JOcCB4x6KLZ/BW1LozMNbTCJv9Hya8ihi/iaHtWe78MQaflGS
        4sdTTPaPoZhXAUQzq9jSmQgma7CoM3g6nKIvB3ZxmwNqmLUk/rbkmjhhfgzc0kTD7wHFGHvcdfu
        piQfvQeSpDkhK
X-Received: by 2002:a37:d8c:: with SMTP id 134mr22409453qkn.433.1628018099292;
        Tue, 03 Aug 2021 12:14:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/g25mwjJPBW3GRsT658xAjK7WfPFxd5+EX8D2glJQaP3nTHkoEEbGh1NCY2uO0kxMEiXzLw==
X-Received: by 2002:a37:d8c:: with SMTP id 134mr22409441qkn.433.1628018099094;
        Tue, 03 Aug 2021 12:14:59 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-92-76-70-75-133.dsl.bell.ca. [76.70.75.133])
        by smtp.gmail.com with ESMTPSA id v6sm8503245qkp.117.2021.08.03.12.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 12:14:58 -0700 (PDT)
Date:   Tue, 3 Aug 2021 15:14:57 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v3 4/7] KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs
 file
Message-ID: <YQmVsSKIPooRQakQ@t490s>
References: <20210730220455.26054-1-peterx@redhat.com>
 <20210730220455.26054-5-peterx@redhat.com>
 <8964c91d-761f-8fd4-e8c6-f85d6e318a45@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8964c91d-761f-8fd4-e8c6-f85d6e318a45@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021 at 05:25:12PM +0200, Paolo Bonzini wrote:
> On 31/07/21 00:04, Peter Xu wrote:
> > Use this file to dump rmap statistic information.  The statistic is done by
> > calculating the rmap count and the result is log-2-based.
> > 
> > An example output of this looks like (idle 6GB guest, right after boot linux):
> > 
> > Rmap_Count:     0       1       2-3     4-7     8-15    16-31   32-63   64-127  128-255 256-511 512-1023
> > Level=4K:       3086676 53045   12330   1272    502     121     76      2       0       0       0
> > Level=2M:       5947    231     0       0       0       0       0       0       0       0       0
> > Level=1G:       32      0       0       0       0       0       0       0       0       0       0
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >   arch/x86/kvm/x86.c | 113 +++++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 113 insertions(+)
> 
> This should be in debugfs.c, meaning that the kvm_mmu_slot_lpages() must be
> in a header.  I think mmu.h should do, let me take a look and I can post
> myself a v4 of these debugfs parts.

Thanks, Paolo!

-- 
Peter Xu

