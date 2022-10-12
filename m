Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD505FCBE0
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJLUPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiJLUO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:14:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E245E22
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 13:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665605697;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5EB/DMRCnjFi7ZgYNILnixPMhGaL5v8DVftfiPTripc=;
        b=dWQKEhV5r+jO8VCodyWFlVv5aWXS6Yri+WD1LLnEvvvyfp66ZUni4I9ycUTD46BTX0m7Mw
        Tpv1dPrJakGLR2lzofEyAFaVndSRSKCvYwydROZum+NuVZnJBPRFByXRnGf0+xx23eXYGr
        uIEiIuay+Fg7UCWwr7AIKSwE3QYUDNQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-390-bI3gxB35MZSZJS-jI1ssDA-1; Wed, 12 Oct 2022 16:14:55 -0400
X-MC-Unique: bI3gxB35MZSZJS-jI1ssDA-1
Received: by mail-qv1-f69.google.com with SMTP id h3-20020a0ceec3000000b004b17a25f8bcso10543480qvs.23
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 13:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5EB/DMRCnjFi7ZgYNILnixPMhGaL5v8DVftfiPTripc=;
        b=JmojfR548n9I28CewwzIb8ISAARHO/5J6JpK/2FUx7r1EecSKuEm9Qjsz9jE7+FTXk
         30BgPboHMYBLHwJyhkPiqDYDDs0QW6w+yYUUq8YFDreDWUHjn5Nijo+Xx4a7K6CJRd/t
         RAuI42oQL33T6NQD3Av8L6G6XFIl0vQy2f5PVr4K//1itYgkfiP+ShhyzOZuzFcqzLEP
         XZuOOK3mp50i9L0yP8NRVaRUzvlKDwX5I0JbK4ecZ2jlmLgyhpgDfi3wwxijl5wuFpQc
         ncdTTFygjnvTkxPmyXrvO2mo3Iq0Ev6wYVErQsNY9Y2jpme+zmh7spGifLuVClq74ho1
         wBww==
X-Gm-Message-State: ACrzQf1MwLTw/8SNmhPMIm7kmP9EPkujHBKvd0h8O/xtYlxYssRpckW3
        5+Etq7ZmL69ZpnktLHgKgArhWxR/w0fxde5BhmOeMmDlCwn0EbqgBBSjqZLhi3fRfH1mQd40j9u
        dxjFNzEnH7RK0
X-Received: by 2002:ad4:5765:0:b0:4b1:bf78:83cd with SMTP id r5-20020ad45765000000b004b1bf7883cdmr24119208qvx.81.1665605695063;
        Wed, 12 Oct 2022 13:14:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5hELiNb2iAcZbm+u2knphj7pDvXbYgBc89xcAg9YPNU6/ZOz6A+P6uasXPuS2tZ9FVOuJUjg==
X-Received: by 2002:ad4:5765:0:b0:4b1:bf78:83cd with SMTP id r5-20020ad45765000000b004b1bf7883cdmr24119193qvx.81.1665605694868;
        Wed, 12 Oct 2022 13:14:54 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id br7-20020a05620a460700b006e9b3096482sm14514681qkb.64.2022.10.12.13.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 13:14:54 -0700 (PDT)
Message-ID: <30e5d940-8964-1ca8-1f40-45e0d8c62724@redhat.com>
Date:   Wed, 12 Oct 2022 22:14:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH] KVM: arm64: vgic: fix wrong loop condition in
 scan_its_table()
Content-Language: en-US
To:     Eric Ren <renzhengeek@gmail.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc:     Marc Zyngier <maz@kernel.org>
References: <acd9f1643980fbd27cd22523d2d84ca7c9add84a.1665592448.git.renzhengeek@gmail.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <acd9f1643980fbd27cd22523d2d84ca7c9add84a.1665592448.git.renzhengeek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 10/12/22 18:59, Eric Ren wrote:
> Reproducer hints:
> 1. Create ARM virt VM with pxb-pcie bus which adds
>    extra host bridges, with qemu command like:
>
> ```
>   -device pxb-pcie,bus_nr=8,id=pci.x,numa_node=0,bus=pcie.0 \
>   -device pcie-root-port,..,bus=pci.x \
>   ...
>   -device pxb-pcie,bus_nr=37,id=pci.y,numa_node=1,bus=pcie.0 \
>   -device pcie-root-port,..,bus=pci.y \
>   ...
>
> ```
> 2. Perform VM migration which calls save/restore device tables.
>
> In that setup, we get a big "offset" between 2 device_ids (
> one is small, another is big), which makes unsigned "len" round
> up a big positive number, causing loop to continue exceptionally.
>
> Signed-off-by: Eric Ren <renzhengeek@gmail.com>

I fixed Marc's address and removed Christoffer's one. Please use the
scripts/get_maintainer.pl to identify the right email addresses.

Just to make sure I correctly understand, you mean len -= byte_offset
becomes negative and that is not properly reflected due to the unsigned
type. I agree we should be robust against that but doesn't it also mean
that the saved table has an issue in the first place (the offset points
to a location outside of the max size of the table)?

Thanks

Eric
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 24d7778d1ce6..673554ef02f9 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2141,7 +2141,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
>  			  int start_id, entry_fn_t fn, void *opaque)
>  {
>  	struct kvm *kvm = its->dev->kvm;
> -	unsigned long len = size;
> +	ssize_t len = size;
>  	int id = start_id;
>  	gpa_t gpa = base;
>  	char entry[ESZ_MAX];

