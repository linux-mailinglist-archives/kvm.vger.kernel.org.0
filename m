Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720BC4E7400
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245078AbiCYNOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 09:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiCYNOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 09:14:31 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D639D0ABD
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 06:12:55 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2e5e176e1b6so82378007b3.13
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 06:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AZpjuFFTl/dm9JwX45C9HkZ4zP02fAm50fBmj/eKc24=;
        b=MDuTCzZqXNu3MurxUT6XKuZ8py+H/UWo9XXjk2ZSe137gGe6dkSUqIwQUcEoZUFAix
         iioVWl1aqpst3x70OCZYakPHYnTMr89sDakCKdRdpvfyiOIKw1Cj+BtqBoqyIVleG1N3
         RWDbSrHIH4DYF0pJYrUQusGqlNVQM0YVLrhmq5ct2Jsl3wMxpq1e/i56zvKJrKExdvyG
         yptuf7JjhLuGk6E+tanRBUVjCCPJwegLPYsmRBaB9FqRwUlguoV8CrWQPshxk+hM2K7J
         OcyzPmnD9r7mCg4P4VvFBqi43rbKcyf3dEokBc5ugiM8JqGk0ghLZXX36YkvTZdkCXXL
         Jdvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AZpjuFFTl/dm9JwX45C9HkZ4zP02fAm50fBmj/eKc24=;
        b=1FiKez+o8NmNUNweIpMC66UuMLsaujBkCqVeBU/Cw7uIwpyCmrI2tq+pa/KXjDtUA+
         5Li+H9XpS9NUCTBXZEPyPcvfWn+dlD5T9jVFd7N5cnzSKRs3BsD3Z89cMCGYAHjP17WQ
         UnUe/LcjYUVo1Z5qWFLD2xXl+F4vmUiuUtJqkPxTBGvIZ58OwCdmU8TAI9C3+qVbLbyI
         2l4oBjkWwbcpLdou2KwEoIJvLKsLJnQON1C+wF5xLDAQ504QpXUGmnEet3OOBGRWf7lM
         oVRO9jtJki4v3yAAIm/FfSPUlLQZpIBH50Om8YRh0ZFNmfRb7f33pKziPH0DM4Hn3QH0
         WtFw==
X-Gm-Message-State: AOAM5326bIDEc19+KIg9Zdq51Ktjo2/cj1zDtZYs5dBC0flaxmjZHxWu
        rMUST5Vd0vLYJU9JJW3CNraK3r9DS2uRiPEzZnAA2A==
X-Google-Smtp-Source: ABdhPJyysXq5eLimDLgPlp6UAlqerubnGEJMcsS79SqknmWKfMmF+kjiIkImD+dIO+wYTdvhD+heCuufdaXgorzZEWM=
X-Received: by 2002:a0d:f603:0:b0:2d1:57e5:234 with SMTP id
 g3-20020a0df603000000b002d157e50234mr10757640ywf.469.1648213972622; Fri, 25
 Mar 2022 06:12:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220318085931.3899316-1-liucong2@kylinos.cn>
In-Reply-To: <20220318085931.3899316-1-liucong2@kylinos.cn>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 25 Mar 2022 13:12:39 +0000
Message-ID: <CAFEAcA8uqRbZzEaZOh4xjeqhEbxy82UxjeRBMfhNsbAoXzk_Vg@mail.gmail.com>
Subject: Re: [PATCH] kvm/arm64: Fix memory section did not set to kvm
To:     Cong Liu <liucong2@kylinos.cn>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Mar 2022 at 14:24, Cong Liu <liucong2@kylinos.cn> wrote:
>
> on the arm64 platform, the PAGESIZE is 64k, the default qxl rom
> bar size is 8k(QXL_ROM_SZ), in the case memory size less than
> one page size, kvm_align_section return zero,  the memory section
> did not commit kvm.

Can you give more details on how this happens? The only place
we use QXL_ROM_SZ is in the qxl_rom_size() function, and that
rounds up the value it returns to the qemu_real_host_page_size.
That change was added in commit ce7015d9e8669e, exagctly to
fix what sounds like the same problem you're hitting where
KVM is in use and the host page size is larger than 8K.
Are you using an old version of QEMU that doesn't have that fix ?

> Signed-off-by: Cong Liu <liucong2@kylinos.cn>
> ---
>  accel/kvm/kvm-all.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 27864dfaea..f57cab811b 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -318,6 +318,7 @@ static hwaddr kvm_align_section(MemoryRegionSection *section,
>                                  hwaddr *start)
>  {
>      hwaddr size = int128_get64(section->size);
> +    size = ROUND_UP(size, qemu_real_host_page_size);
>      hwaddr delta, aligned;
>
>      /* kvm works in page size chunks, but the function may be called

The comment we can just see starting here says:

    /* kvm works in page size chunks, but the function may be called
       with sub-page size and unaligned start address. Pad the start
       address to next and truncate size to previous page boundary. */

but your change means that's no longer true.

More generally, rounding up the size here seems dubious -- there
is no guarantee that whatever follows the small lump of RAM
in the address space is sensible to treat as really being
part of the same thing.

thanks
-- PMM
