Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03C94E97CC
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243052AbiC1NSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 09:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243185AbiC1NSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 09:18:25 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2692E9CB
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 06:16:44 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id j2so26003512ybu.0
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 06:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2DLkdz0V/hl7pCwokIEg7z7bgOwF2a/LFOZjgc0AZ2U=;
        b=HVK6WA1zwxordU3dNjCxpMBwUYvKmUkBnJfhUrE4v8Ul8s9ju5E8mqzYDsSiS6B+4k
         Armb7r5MbB6QqI5ioFOrYiE98zE/I3oGeTyJpO/Gb2Ql3fhEzokz4cELjRiFVqidVvQ2
         20bZ6XKK1XMyZgK8HgmXnqz1sFF3rozS6yg8YvsEU5qOs1NeaI1jXU2jwGA3KhMJ3+E+
         3HEyB6bBJHS+tPDH25JtPyMhZqOZd7fVO+HpEMz8LL/1wRidIJJF9brP1WXRb+kRyzem
         ZbkZUDR/NOz36Wjwng2Bb/GU8h/eZBYUCgYccHwX3s+whITUVX+4gUGZWksQDeiQOba4
         4KGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2DLkdz0V/hl7pCwokIEg7z7bgOwF2a/LFOZjgc0AZ2U=;
        b=dJvek1P7RYM/dc/5tPCOidyeOguITFf5CzIH14/b9/agu5g+ow35saEVgPIQBbXvVB
         JLZUxLHatcUl5KxUzcOh6U6mik8nhpJ+ruX66NqGhOgZfxTfRqa/VcExd29WH0AM1Hrk
         xoDmX++O52urNOOcoja5KWvjTr1uo806+gv5XbVz2JZwBLWOS/pi65iK+a3fUb/TEdyL
         GdhVw9h/NDW+gfq8/LkB5+UMVJj/zP5TQ5WM1XMc/kTwq3MA31OpANtKO00YzRSZXyUR
         acC44f6bOttxsm+tvJP+OKj393Lf30yOEAIhTBaWUbr0LZ6DtNtONYzL11tgvMSu79j/
         DP4w==
X-Gm-Message-State: AOAM532/8SB42ZfDp42Lk7OglXUlD07jswhCgW0anb59q+juQhKdyddQ
        YJc5vYFMvJyYYnfO8gJ+wCfOlmf2iZBNts+teVsblQ==
X-Google-Smtp-Source: ABdhPJwlO9YNLpniRSjIpUEMFfW/A5S71DBwalVJ9CX876ChT6kgAg6nGEVQIlVOwD8T90xI5NMOzSWI2OggaKyjinc=
X-Received: by 2002:a05:6902:1147:b0:634:6e83:70b4 with SMTP id
 p7-20020a056902114700b006346e8370b4mr23440871ybu.85.1648473403899; Mon, 28
 Mar 2022 06:16:43 -0700 (PDT)
MIME-Version: 1.0
References: <149i84ajr3d-149ji23ysx6@nsmail6.0>
In-Reply-To: <149i84ajr3d-149ji23ysx6@nsmail6.0>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 28 Mar 2022 13:16:29 +0000
Message-ID: <CAFEAcA_-ZtiJwO858DBXGw5iL_Cs1XKNUqQT0mKypDkYm_j4NQ@mail.gmail.com>
Subject: Re: Re: [PATCH] kvm/arm64: Fix memory section did not set to kvm
To:     liucong2@kylinos.cn
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

On Mon, 28 Mar 2022 at 13:17, <liucong2@kylinos.cn> wrote:
>
> thanks for you explain, I will learn it later.
>
>
> in the scenario of rom bar size 8k, page size 64k, the value of
>
> 'size = ROUND_UP(size, qemu_real_host_page_size)' is 64k, kvm_align_section
>
> also return 64k bytes.  just the same size as the size of RAMBlock. I still
>
> did not understand why it is wrong.

Because if the size of the memory region is 8K, not 64K, then
we should not map into the guest 64K, but only 8K.

I'm still not sure what exactly you're trying to fix here.
The specific case of the QXL ROM BAR we already have the fix for.
Is there another specific case you are running into ?

-- PMM
