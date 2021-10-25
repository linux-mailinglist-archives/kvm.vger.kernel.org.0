Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C5C439398
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 12:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhJYK0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 06:26:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232340AbhJYK0I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 06:26:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635157426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w2+eCOoraI98VwusL2Ww6vNBWcx0Cj4tYXoK77zGYfw=;
        b=VgW1OFCZ1kokM2qVcjMqbEEwO0rVUbRYGlNDhdlaIVVjnzQ+fWRqe/twTCku1nSz0RkZoU
        DVOVnVe+vMDzM4N84mMqPWvB7HuMPfAVif4QxYmvrWoRlJKt0bRSOucghYcvC5gR3JwzC9
        IDKI0Y3qN71qCXygb4bVMT5Ptcil1Qk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-HSZQHjfmM7Of8XiQuuhC6Q-1; Mon, 25 Oct 2021 06:23:45 -0400
X-MC-Unique: HSZQHjfmM7Of8XiQuuhC6Q-1
Received: by mail-ed1-f72.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so9379159edj.21
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 03:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w2+eCOoraI98VwusL2Ww6vNBWcx0Cj4tYXoK77zGYfw=;
        b=MV3+0F926h6QMvyDzBc8LG+kR0erWYZCgJORyJsKUZ/pOovEcNqUwlF3Tn/a9Jk08r
         G/wb1EYPeLdrzeoF7ff4Q5X4U9W5a/aXSTqgkjxBReUluHkixKhZFwHyAqBNgNwuiQ/L
         bDjNeFHWqkfJ93wnA54x2n7CrH0V4PNeLbuyUVQRAkVKVobJ6AyBan1316fRj1VeQrsD
         RkYhOWbEfdiyb7nfo7aeHoOnLNvPFqQpSrGJUqDwmrMDtN7b2M4a5jdS8eSwsRthD84E
         B+pygHuBgO10INXkc1lCKiAxA+0uLPnWgfICfr48q5Wh9aTLBXvYECAix02rva0YPsLd
         Tblg==
X-Gm-Message-State: AOAM533zp9YYskUt7Kn7AIJ7zzyolPFWK7JSW1Nyj3hQDspD5sXjXzXa
        MUHHvfNn4aeHZqyNBWvn9u6X6Qqi8k7rmHZ4GiSI7POLgkRVxcezVpHRoiD9BrKKZ0OQug7it0m
        +DNCBkDajgB2E
X-Received: by 2002:a17:906:5804:: with SMTP id m4mr21362705ejq.295.1635157423916;
        Mon, 25 Oct 2021 03:23:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKKQrfnnXWyBSPxyIBF3xNVjNaHailttWUMksBd7mrflUSeDxlk5gEmp3bCkXv8cU4nej1sw==
X-Received: by 2002:a17:906:5804:: with SMTP id m4mr21362685ejq.295.1635157423687;
        Mon, 25 Oct 2021 03:23:43 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id s22sm1035093edq.56.2021.10.25.03.23.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 03:23:43 -0700 (PDT)
Message-ID: <09f4468b-0916-cf2c-1cef-46970a238ce4@redhat.com>
Date:   Mon, 25 Oct 2021 12:23:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86/xen: Fix runstate updates to be atomic when
 preempting vCPU
Content-Language: en-US
To:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/21 21:47, Woodhouse, David wrote:
> I almost switched to using a gfn_to_pfn_cache here and bailing out if
> kvm_map_gfn() fails, like kvm_steal_time_set_preempted() does — but on
> closer inspection it looks like kvm_map_gfn() will*always*  fail in
> atomic context for a page in IOMEM, which means it will silently fail
> to make the update every single time for such guests, AFAICT. So I
> didn't do it that way after all. And will probably fix that one too.

Not every single time, only if the cache is absent, stale or not 
initialized.

In the case of steal time, record_steal_time can update the cache 
because it's never called from atomic context, while 
kvm_steal_time_set_preempted is just advisory and therefore can fail 
just fine.

One possible solution (which I even have unfinished patches for) is to 
put all the gfn_to_pfn_caches on a list, and refresh them when the MMU 
notifier receives an invalidation.

Paolo

