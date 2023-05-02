Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBB66F40F4
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 12:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbjEBKSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 06:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbjEBKSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 06:18:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1795272
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 03:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683022643;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=E1l3XMnkGIekijM50coq7K7cEkjPsryzXW5fy04pDPI=;
        b=Oe+6XBrwrSP0oo9sSnTXv/8lO/0kLuzcWuRp7JyDrWpsaT+N2w0502oQ88+3QkdFbZ87/f
        s8+gA+vuqfaMvSeov9L96QmEe1JlpqXzGLoxqpe0gDHIXAmC5HnFrAh7OKbZx6sC+yPmm6
        FlNctm1XsNSUBXZeZLIE5uc35S6z4ks=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-MDR7ZJVFOPGqS1-FboYXhQ-1; Tue, 02 May 2023 06:17:22 -0400
X-MC-Unique: MDR7ZJVFOPGqS1-FboYXhQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f187a7a626so10528845e9.0
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 03:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683022641; x=1685614641;
        h=mime-version:message-id:date:reply-to:user-agent:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E1l3XMnkGIekijM50coq7K7cEkjPsryzXW5fy04pDPI=;
        b=SnSXEYZLEnEBBxMg4vxSjUhOvf2jsW5xABytRWpxY59fpES8Ms4uZhW33jR2j3LQcv
         2bNXFwY9BeHVXWOY4HpeHTZxpFAMYLbzGyF7k8UedYbvBSGg7/v1ZDWmFR+LKimEBCU/
         5gbPK7W+jllteO+hkdeCvo8dQh5cNFyCQw6qSghk3JbRFmUYdxuqvNsEFe0nyGqnMwdn
         nPxGz0Rh0XDdDaUsONcf4aUnfHKiROMBZBeJ1l4JCyDSNGidfGJx4sbp/UI2m2ddbNVE
         +GN6YE0AXFHMdzItLj/s6dIi2CitXzsSIV2nYjbvWCXhBQONXcQlsxeUC+PhqQFXFWQQ
         ezYQ==
X-Gm-Message-State: AC+VfDzV/zbmbjAgCDpK3qcnjOONhru8TfaeCq5Hu5QSvJBUVsidW/+j
        UqtD1nCPhQr0Q3tu9uFlrPIyrJUV5Kr4wt2ovdm9VfsyPsDws8m6Dlr2UdSs45Q/3tRKHM8kG1c
        BHfj2n+NK1yLi
X-Received: by 2002:a7b:cb8c:0:b0:3ee:6cdf:c357 with SMTP id m12-20020a7bcb8c000000b003ee6cdfc357mr11126851wmi.20.1683022641202;
        Tue, 02 May 2023 03:17:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6aYYCmGWNu22f3ZczjUQm0EpC7Ltqa6zMrB1N4pBPPtJELAP2bahxhtT3qnAmTziX6RhXvIQ==
X-Received: by 2002:a7b:cb8c:0:b0:3ee:6cdf:c357 with SMTP id m12-20020a7bcb8c000000b003ee6cdfc357mr11126838wmi.20.1683022640901;
        Tue, 02 May 2023 03:17:20 -0700 (PDT)
Received: from redhat.com ([188.85.120.92])
        by smtp.gmail.com with ESMTPSA id l10-20020a1c790a000000b003f32f013c3csm9766832wme.6.2023.05.02.03.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 03:17:20 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Andrea Bolognani <abologna@redhat.com>
Subject: Re: [PATCH v7 1/1] arm/kvm: add support for MTE
In-Reply-To: <871qjzcdgi.fsf@redhat.com> (Cornelia Huck's message of "Tue, 02
        May 2023 11:03:25 +0200")
References: <20230428095533.21747-1-cohuck@redhat.com>
        <20230428095533.21747-2-cohuck@redhat.com>
        <87sfcj99rn.fsf@secure.mitica>
        <64915da6-4276-1603-1454-9350a44561d8@linaro.org>
        <871qjzcdgi.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 02 May 2023 12:17:17 +0200
Message-ID: <871qjzujf6.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cornelia Huck <cohuck@redhat.com> wrote:
> On Mon, May 01 2023, Richard Henderson <richard.henderson@linaro.org> wrote:
>
>> On 4/28/23 18:50, Juan Quintela wrote:
>>> Pardon my ignorance here, but to try to help with migration.  How is
>>> this mte tag stored?
>>> - 1 array of 8bits per page of memory
>>> - 1 array of 64bits per page of memory
>>> - whatever
>>> 
>>> Lets asume that it is 1 byte per page. For the explanation it don't
>>> matter, only matters that it is an array of things that are one for each
>>> page.
>>
>> Not that it matters, as you say, but for concreteness, 1 4-bit tag per 16 bytes, packed, 
>> so 128 bytes per 4k page.
>>
>>> So my suggestion is just to send another array:
>>> 
>>> - 1 array of page addresses
>>> - 1 array of page tags that correspond to the previous one
>>> - 1 array of pages that correspond to the previous addresses
>>> 
>>> You put compatiblity marks here and there checking that you are using
>>> mte (and the same version) in both sides and you call that a day.
>>
>> Sounds reasonable.
>
> Yes, something like that sounds reasonable as an interface.

Ok.

>>> Notice that this requires the series (still not upstream but already on
>>> the list) that move the zero page detection to the multifd thread,
>>> because I am assuming that zero pages also have tags (yes, it was not a
>>> very impressive guess).
>>
>> Correct.  "Proper" zero detection would include checking the tags as well.
>> Zero tags are what you get from the kernel on a new allocation.

That was a different thing.
On precopy, we handle zero page one way and non_zero page other way.

On upstream multifd, we detect and send zero page on the migration
thread, and everything else on the migration threads.

With my patches (on list) it send both zero and non-zero pages through
multifd.  My proposal will be that we send the 128bytes/page for every
page, included zero pages.  Here I mean zero page a page that is full of
zeros, independently of the tag.

>> A page can be dirtied by changing nothing but a tag.

I hope/expect that the dirty bitmap reflects that.

>> So we cannot of course send tags "early", they must come with the data.
>> I'm not 100% sure I understood your question here.
>
> Last time MTE migration came up, we thought that we would need to go
> with an uffd extension (page + extra data) to handle the postcopy case
> properly (i.e. use some kind of array for precopy, and that interface
> extension for postcopy.) TBH, I'm not sure if multifd makes any
> difference here.

uffd is a completely different beast, and I agree with you.  I was
meaning here the precopy/multifd case.

>>> Another question, if you are using MTE, all pages have MTE, right?
>>> Or there are other exceptions?
>>
>> No such systems are built yet, so we won't know what corner cases the host system will 
>> have to cope with, but I believe as written so far all pages must have tags when MTE is 
>> enabled by KVM.
>
> Has anyone been able to access a real system with MTE? (All the systems
> where I had hoped that MTE would be available didn't have MTE in the end
> so far, so I'd be interested to hear if anybody else already got to play
> with one.) Honestly, I don't want to even try to test migration if I only
> have access to MTE on the FVP...

So here we are.

I have seen the future.  And it is very blurred. O:-)

Later, Juan.

