Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE296E4650
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 13:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjDQLYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 07:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjDQLYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 07:24:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ED35273
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 04:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681730466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lQP0jhHOILHGUYqqiFPFEP0oFPfgZ69ufmXe3pOVD4k=;
        b=LeQGgC4PQfg7WDT9230E5d15H8jcC2aCH2JtDx9Do9t2jYnsFdHmeEQGmo7vvuNNQpK3fI
        7H5yl2584hUOFC69JEi/WHbTcXu0YK8YJElCdwfNG1ZyvmOQIJgrtIOySNX7WrNzlrdZ6I
        cqJQp3UuZhbFL9UjOx4sC+8SYh72C7s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-kXVl8Kr1MnSrud1x2ch6Gw-1; Mon, 17 Apr 2023 06:55:33 -0400
X-MC-Unique: kXVl8Kr1MnSrud1x2ch6Gw-1
Received: by mail-wm1-f71.google.com with SMTP id p3-20020a05600c358300b003f175c338d6so271327wmq.2
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 03:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681728932; x=1684320932;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lQP0jhHOILHGUYqqiFPFEP0oFPfgZ69ufmXe3pOVD4k=;
        b=cKeU2wU7MX0XqLmfKy/++CeZ5o33M0bwsAa1S3XBwO84S25h3atbE7NYidZPn2GGcc
         yQG7BJfynpIPpyLBpKS50Bjaf2sm9v/IwaiXbN5umYSckHpdey5C7sfIx1eXRIuoSzEs
         +h8jEtSfS5aMxU4RVCyePB7fFDs9IwOtTeyfyR6xWSZpLhGO2fmbWDAQ8+0p0qzQOE4i
         xA+2DrdK+kfjK2S9V2CyzVPgMrFcMZkkcW2WZNkP3H7UnlbJ/nzinltZa60qYK3zXXSN
         0sGiLjeQU2CVYXJ43xDzewFyx47IHT8Xi8sXR6yMH4XKDx2b35Zst5LOI8OIP9wUjRyJ
         04uQ==
X-Gm-Message-State: AAQBX9dAd1J6GSnHPrBv9R2BjbEI6m2x+bW7Mhn4YXsvMgCuyQN3r7qW
        EUiK7qF9vMbHS4GAkL5xmcF+BuPs60MUyxP6akz+3UkWfjQosrhgAqNVhZ0SMwWdemlvYBdDhZg
        /ns8fs96NUZQK
X-Received: by 2002:a05:600c:3793:b0:3f1:71b3:c6b5 with SMTP id o19-20020a05600c379300b003f171b3c6b5mr3472237wmr.26.1681728932430;
        Mon, 17 Apr 2023 03:55:32 -0700 (PDT)
X-Google-Smtp-Source: AKy350YH/86qIG88Tj0beqaD/3sOrt9ZF/SdVSy4Z1Oma4C+GIauFs3qJA38myjmhj9zrBrycpWLBQ==
X-Received: by 2002:a05:600c:3793:b0:3f1:71b3:c6b5 with SMTP id o19-20020a05600c379300b003f171b3c6b5mr3472203wmr.26.1681728932040;
        Mon, 17 Apr 2023 03:55:32 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:fc00:db07:68a9:6af5:ecdf? (p200300cbc700fc00db0768a96af5ecdf.dip0.t-ipconnect.de. [2003:cb:c700:fc00:db07:68a9:6af5:ecdf])
        by smtp.gmail.com with ESMTPSA id c10-20020a7bc2aa000000b003f0ad8d1c69sm10484005wmk.25.2023.04.17.03.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 03:55:31 -0700 (PDT)
Message-ID: <6ad9509c-11b6-9ada-0ee8-26cf40b3ac14@redhat.com>
Date:   Mon, 17 Apr 2023 12:55:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3 1/7] mm/gup: remove unused vmas parameter from
 get_user_pages()
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>, x86@kernel.org,
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
        Paolo Bonzini <pbonzini@redhat.com>
References: <cover.1681558407.git.lstoakes@gmail.com>
 <28967f170eceeebf2591a5e4370d0642e0516f9b.1681558407.git.lstoakes@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <28967f170eceeebf2591a5e4370d0642e0516f9b.1681558407.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.04.23 14:09, Lorenzo Stoakes wrote:
> No invocation of get_user_pages() uses the vmas parameter, so remove
> it.
> 
> The GUP API is confusing and caveated. Recent changes have done much to
> improve that, however there is more we can do. Exporting vmas is a prime
> target as the caller has to be extremely careful to preclude their use
> after the mmap_lock has expired or otherwise be left with dangling
> pointers.
> 
> Removing the vmas parameter focuses the GUP functions upon their primary
> purpose - pinning (and outputting) pages as well as performing the actions
> implied by the input flags.
> 
> This is part of a patch series aiming to remove the vmas parameter
> altogether.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

