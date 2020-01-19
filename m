Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1203141D0B
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 10:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgASJBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 04:01:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32174 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726538AbgASJBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 04:01:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579424513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E6uOIXtplXczZ5J5TTB/qREzR/gOXMQuJdW4hYcAmw0=;
        b=FqHWgA/JmPV4QvJ2jpp76x60kQwqFwdKxBxcAcMryiK7l7+hyf/qP4qIy8MGE2ZfHCMdsg
        l0Gz8t1CIYzDUrW2fv1i4mYJCqRsTLmNSHLz8g8D871fFGz60F4dyobGcQfdaiQdTqp4UR
        7bKXYF8s2mFjcEg69eb80pL6pFHPjZE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-EMkQ3JZMOxO7rajuUaG8Jw-1; Sun, 19 Jan 2020 04:01:51 -0500
X-MC-Unique: EMkQ3JZMOxO7rajuUaG8Jw-1
Received: by mail-wm1-f71.google.com with SMTP id y125so3706672wmg.1
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2020 01:01:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E6uOIXtplXczZ5J5TTB/qREzR/gOXMQuJdW4hYcAmw0=;
        b=RytmWJ5bhKfo5aRRykHT7Ex4iBzTHyi1miOZGQ4oQerGpVtUi3qL1DSQwX8eoKXy4z
         plofTNObpM48o97q2zT+gE6JH57NCFzElE3UyUfa8icvxdOxV7tA7FmSmIIEdgCSsbvx
         g47mkOaXi4HPm/ijG0NASARvPdoPVEvhZ9+UujaeZPeFPgDkr2COVc06HcAcgxkPljKX
         oR+2VXsjtoWpKzQOmu5Dv//wJwnNBD6pYwhbh1Yn5iGIvDOAhbyG40HD0PlHISWaKluy
         22jj5IHyk8eZov+GiWOOBqtPSZrzmH41jQ+GP/mh4QJbW45lU46B1g/H5n09KAur9Kbn
         UDtw==
X-Gm-Message-State: APjAAAX+ZrtEfVOABgRGpM/jeDg19EkrRMjVaDBQbeuRdolkI4UqEd5+
        TxXpLDc0Ax3hiyohOLlCKIeVSxCJ0//Qk/DcAgNdCQytKgj1cqgEwt0ey9Bk8PGNPV+0eUxg4MK
        qqwt5MyyzdflH
X-Received: by 2002:a7b:cfc9:: with SMTP id f9mr13440820wmm.1.1579424510437;
        Sun, 19 Jan 2020 01:01:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqz9cwlUMerOGBaIsqCvwFOOnm3YB+1U2JN4fr/0bbA4Yr+y+255aVffL/QuYKCXhICbVON19w==
X-Received: by 2002:a7b:cfc9:: with SMTP id f9mr13440787wmm.1.1579424510181;
        Sun, 19 Jan 2020 01:01:50 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p17sm2900651wmk.30.2020.01.19.01.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 01:01:49 -0800 (PST)
Subject: Re: [PATCH v3 09/21] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-10-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5af8e2ff-4bde-9652-fb25-4fe1f74daae2@redhat.com>
Date:   Sun, 19 Jan 2020 10:01:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200109145729.32898-10-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/01/20 15:57, Peter Xu wrote:
> -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> +/*
> + * If `uaddr' is specified, `*uaddr' will be returned with the
> + * userspace address that was just allocated.  `uaddr' is only
> + * meaningful if the function returns zero, and `uaddr' will only be
> + * valid when with either the slots_lock or with the SRCU read lock
> + * held.  After we release the lock, the returned `uaddr' will be invalid.
> + */

In practice the address is still protected by the refcount, isn't it?
Only destroying the VM could invalidate it.

Paolo

