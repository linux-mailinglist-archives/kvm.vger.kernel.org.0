Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7732E314B87
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 10:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBIJ0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 04:26:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229646AbhBIJVF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 04:21:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612862378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BFjv4UtzY9Kq1FYF0dpb6VHrc3ljOiW5dWjb2Re6blw=;
        b=PLFNavfW+GMNCji0tDjhaHVOAEB6Y3Jva66Pfj6+4RY6xZwkhoy81zxKt2wKk2frYiSj7X
        Vyot/NPXBD7jNcILq1LccuXve74FuichFDWizbyUgKjHKFmj3ic1kYnMRCL6Pfoi6C5Yvl
        xesyNUrHw7DyJqFTel4ciuKLn7er0/w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-ncBa8qdKMCutvmENUoW6tA-1; Tue, 09 Feb 2021 04:19:37 -0500
X-MC-Unique: ncBa8qdKMCutvmENUoW6tA-1
Received: by mail-wm1-f69.google.com with SMTP id j204so2268369wmj.4
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 01:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BFjv4UtzY9Kq1FYF0dpb6VHrc3ljOiW5dWjb2Re6blw=;
        b=JK/LMZX9U/43mqLcBjnllBhpBRY7ZPXSKs2MFD91vIOwoqR1OKwJcwZtzVXOHvfQkH
         RSHTctteacLTh5XoiKTf9EOV5wLRoJdmd+bimueNN4zurEL1I6FOPFujnOgN6CmjTow9
         ubrk7MV0cH/tfLg3KsVd1mymo/iioSKdCD9tdDhS2Vn/EpH+2ODVhUp8U66gsOYlodtX
         ZVvlkQ5UjUmiAh1Jgp1o+arQ0Cp8YIAZVfll33aaAvOZ4egmeQA0zMBFLDscy6PGJdc/
         sOnya1Ixf61UcgdMur59KDjEzE3JgPMZY+mRvPtg2adiQ4YD4FwGfItT5fa6riNyxAmo
         Cugg==
X-Gm-Message-State: AOAM531XXZgTZYorJCa54lgvNIY1Gn26jt+kG0uaFXgYHnQJcRSzTWAK
        rEuiaDdtruUg817VtGXSjz6AB83Mwg0oU0MzKIgRUvJXn5Xhe6b8Z0hkx1DpoF7hNR3UWf2gzVo
        ll5knFoXy9j1s
X-Received: by 2002:a1c:7905:: with SMTP id l5mr2532084wme.171.1612862375892;
        Tue, 09 Feb 2021 01:19:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJylyGxN6rAcQNsffz+2zGcPZnteVoUtmo8yoEcEep7Stu6LpFbD+RJDHfXVYYs7gR1qW5cazQ==
X-Received: by 2002:a1c:7905:: with SMTP id l5mr2532068wme.171.1612862375679;
        Tue, 09 Feb 2021 01:19:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u142sm3652118wmu.3.2021.02.09.01.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 01:19:34 -0800 (PST)
Subject: Re: [PATCH 1/2] mm: provide a sane PTE walking API for modules
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgg@ziepe.ca,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        dan.j.williams@intel.com, Daniel Vetter <daniel@ffwll.ch>
References: <20210205103259.42866-1-pbonzini@redhat.com>
 <20210205103259.42866-2-pbonzini@redhat.com>
 <20210208173936.GA1496438@infradead.org>
 <3b10057c-e117-89fa-1bd4-23fb5a4efb5f@redhat.com>
 <20210209081408.GA1703597@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d238b495-dbae-1bc4-3397-5bceadfddb7e@redhat.com>
Date:   Tue, 9 Feb 2021 10:19:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210209081408.GA1703597@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/21 09:14, Christoph Hellwig wrote:
> On Mon, Feb 08, 2021 at 07:18:56PM +0100, Paolo Bonzini wrote:
>> Fair enough.  I would expect that pretty much everyone using follow_pfn will
>> at least want to switch to this one (as it's less bad and not impossible to
>> use correctly), but I'll squash this in:
> 
> 
> Daniel looked into them, so he may correct me, but the other follow_pfn
> users and their destiny are:
> 
>   - SGX, which is not modular and I think I just saw a patch to kill them
>   - v4l videobuf and frame vector: I think those are going away
>     entirely as they implement a rather broken pre-dmabuf P2P scheme
>   - vfio: should use MMU notifiers eventually

Yes, I'm thinking mostly of vfio, which could use follow_pte as a 
short-term fix for just the missing permission check.

There's also s390 PCI, which is also not modular.

Paolo

> Daniel, what happened to your follow_pfn series?


