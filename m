Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3593D97C4
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 23:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhG1Vv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 17:51:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45960 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231126AbhG1VvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 17:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627509083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BgiDqK985Ktel1mCxB8sOugAZbOGexb63bUDm0TnYDk=;
        b=AiJ9xSxUOnxMoCq+5G7EFlLFMh9z4M1s9296Vb6ul5BR7wqjgrv5mpGw98VZEF8PqUJSR6
        uS9Ak3Uzo42dTMpn3YwPOXnywfnXmFTQu3ix5LacvrcYG5u+23Znw3c9yIy49hJ1xIK8n7
        GTk2yf4PZXffNoSrm0YgD9l0PocMj0g=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-T3HffbCUOLCrjTaD4wWlJg-1; Wed, 28 Jul 2021 17:51:22 -0400
X-MC-Unique: T3HffbCUOLCrjTaD4wWlJg-1
Received: by mail-qk1-f200.google.com with SMTP id w26-20020a05620a129ab02903b9eeb8b45dso2490605qki.8
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 14:51:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BgiDqK985Ktel1mCxB8sOugAZbOGexb63bUDm0TnYDk=;
        b=FRSdY8Yu/nKI7dd9Z/dqoDMBWKCmZjeVceGFYbVq6puk+iy5aByym5jYVJur4CEShg
         1P+akJmRaJuzCzghW1A0LDIiQ2XwK6rhwrZMxQgkaEOSYCxNO2ob7QZoORotNmcPtuJ2
         +tGr4Cn7r/yJhgSa/f2iJ4fdjiXvTgB1mBte0GzrmbUWopKfIHRNnowM8xbKpwwXWLu1
         378iMB1tRPV5jAbFRgTnDlwvQgY+sCcGZx2PC/tkfRLirGlxnxdJq7G8c2puI1WzvYRy
         IT266H0vLhpdxtGcEvROmw7R26CUNW523HtIgLN+00Qzy+KRMJb2qtmG80rnXQTmIV2c
         kj/Q==
X-Gm-Message-State: AOAM531Ax1P5ln5rQvlMyy4XL1dvviSI5qJjxTU2C18DB/5/VxRBt2II
        m3ImaVpb7X49liBflgEvWvxlbh7QhjuSYPLa1So2T4XlzSSU8v8xId8Pv1nT+hCHocKJp/ZGrbd
        OJss0zWmTwLi2
X-Received: by 2002:a05:622a:142:: with SMTP id v2mr1531753qtw.343.1627509081658;
        Wed, 28 Jul 2021 14:51:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjg24v44i0E2XNaQXy3CApzsAmGvMGrjOxbDpdx0PiWsCpkBDaJgrK3Kem/PGJhXXtIry3hw==
X-Received: by 2002:a05:622a:142:: with SMTP id v2mr1531743qtw.343.1627509081473;
        Wed, 28 Jul 2021 14:51:21 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id h68sm642530qkf.126.2021.07.28.14.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 14:51:20 -0700 (PDT)
Date:   Wed, 28 Jul 2021 17:51:19 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 8/9] KVM: X86: Optimize pte_list_desc with per-array
 counter
Message-ID: <YQHRV/uEZ4LqPVNI@t490s>
References: <20210625153214.43106-1-peterx@redhat.com>
 <20210625153415.43620-1-peterx@redhat.com>
 <YQHGXhOc5gO9aYsL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YQHGXhOc5gO9aYsL@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 09:04:30PM +0000, Sean Christopherson wrote:
> >  struct pte_list_desc {
> >  	u64 *sptes[PTE_LIST_EXT];
> > +	/*
> > +	 * Stores number of entries stored in the pte_list_desc.  No need to be
> > +	 * u64 but just for easier alignment.  When PTE_LIST_EXT, means full.
> > +	 */
> > +	u64 spte_count;
> 
> Per my feedback to the previous patch, this should be above sptes[] so that rmaps
> with <8 SPTEs only touch one cache line.  No idea if it actually matters in
> practice, but I can't see how it would harm anything.

Reasonable.  Not sure whether this would change the numbers a bit in the commit
message; it can be slightly better but also possible to be non-observable.
Paolo, let me know if you want me to repost/retest with the change (along with
keeping the comment in the other patch).

Thanks for looking!

-- 
Peter Xu

