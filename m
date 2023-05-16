Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01C77050ED
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 16:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbjEPOgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 10:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbjEPOgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 10:36:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D23195
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 07:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684247763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HDtlWQaTJft8O2op6owZ91p6/RHXC3pnklg9iA3D7Gs=;
        b=clY8y2JdvJussDMqGzd+NG0jvmQpmNLGrzYUXVIwXOsMSunrcailfjLYVBbhGgpjnUCQ2q
        Fndb0SblLIJKvzzU5wlk/c6ZI1D9OmJo3+zktxNd7IF181Yx/yy7PQwBAsuLkBYJJGhaM3
        17yNeUjieTh6cvpvxoDyvabAw7tNBPs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-WxHdZsvPNxiAWPASp8B7ew-1; Tue, 16 May 2023 10:36:01 -0400
X-MC-Unique: WxHdZsvPNxiAWPASp8B7ew-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3078b9943d6so4229299f8f.1
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 07:36:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684247760; x=1686839760;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HDtlWQaTJft8O2op6owZ91p6/RHXC3pnklg9iA3D7Gs=;
        b=U4BhgGyPaPv3R8gCM6pMqe4+v3+aiEO8aJAEzi7UtXMYdLK150o+45Jt91Aeqn4nx2
         6JxEew5uKPpzWFzNJV9HnbJfPfbcfU8auXcgcu5nOKEGN07tXmmwx4RNT52ljZn/36yg
         6/bFqb0gNGYJVCA4x2IAM+iuftO/+mfvQscxCTOtx+9lT4CvdaYB3mchCnWbC9nWuD4V
         EZpAz73ABvoYWRPwAncrgED49GxxcTkOhQ59ErzVX64z6q+NIoRngqC5qLyiHXV1tci3
         t/v/p4O8Z0q3KZz7gSFEdMltF4sJ0ckW/quYRHxRYJXVViNoqkKra9BR+mSFdYZ/sKP0
         MQTw==
X-Gm-Message-State: AC+VfDwCANcA2XB02plt/JAosbZ7XhC/tXUO2uoSCdihYvulvHbGDbpX
        0ifusSQ4Er2UhgpFjprPrA/I4c28ogyABryzsQ0MBwaMsyH6XngkgtHtwcSc3P0rzH2PwYveXox
        Nfsnu8suYat5+
X-Received: by 2002:adf:f58f:0:b0:306:b3f9:e2c9 with SMTP id f15-20020adff58f000000b00306b3f9e2c9mr28308371wro.6.1684247760146;
        Tue, 16 May 2023 07:36:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ43W1M/r+a9sBvXVLNjQ1rWzK4b+y6axsJM1bg4sF6/pP33gd7tOg3iz5gfyS0T7ZUiF6igvw==
X-Received: by 2002:adf:f58f:0:b0:306:b3f9:e2c9 with SMTP id f15-20020adff58f000000b00306b3f9e2c9mr28308347wro.6.1684247759798;
        Tue, 16 May 2023 07:35:59 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74f:2500:1e3a:9ee0:5180:cc13? (p200300cbc74f25001e3a9ee05180cc13.dip0.t-ipconnect.de. [2003:cb:c74f:2500:1e3a:9ee0:5180:cc13])
        by smtp.gmail.com with ESMTPSA id x2-20020a05600c21c200b003f508777e33sm2586081wmj.3.2023.05.16.07.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 07:35:59 -0700 (PDT)
Message-ID: <7e9651d6-382a-287c-cd08-03762ccce1f7@redhat.com>
Date:   Tue, 16 May 2023 16:35:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 1/6] mm/gup: remove unused vmas parameter from
 get_user_pages()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Xinhui Pan <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>,
        Christian Konig <christian.koenig@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1684097001.git.lstoakes@gmail.com>
 <b61d5999a4fc6d50b7e073cc3c3efa8fe79bbd94.1684097002.git.lstoakes@gmail.com>
 <ZGKC9fHoE+kDs0ar@google.com>
 <b97e8c2a-b629-f597-d011-395071011f1b@redhat.com>
 <ZGOTadDG/b0904YI@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZGOTadDG/b0904YI@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.05.23 16:30, Sean Christopherson wrote:
> On Tue, May 16, 2023, David Hildenbrand wrote:
>> On 15.05.23 21:07, Sean Christopherson wrote:
>>> On Sun, May 14, 2023, Lorenzo Stoakes wrote:
>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>> index cb5c13eee193..eaa5bb8dbadc 100644
>>>> --- a/virt/kvm/kvm_main.c
>>>> +++ b/virt/kvm/kvm_main.c
>>>> @@ -2477,7 +2477,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
>>>>    {
>>>>    	int rc, flags = FOLL_HWPOISON | FOLL_WRITE;
>>>> -	rc = get_user_pages(addr, 1, flags, NULL, NULL);
>>>> +	rc = get_user_pages(addr, 1, flags, NULL);
>>>>    	return rc == -EHWPOISON;
>>>
>>> Unrelated to this patch, I think there's a pre-existing bug here.  If gup() returns
>>> a valid page, KVM will leak the refcount and unintentionally pin the page.  That's
>>
>> When passing NULL as "pages" to get_user_pages(), __get_user_pages_locked()
>> won't set FOLL_GET. As FOLL_PIN is also not set, we won't be messing with
>> the mapcount of the page.

For completeness: s/mapcount/refcount/ :)

> 
> Ah, that's what I'm missing.



-- 
Thanks,

David / dhildenb

