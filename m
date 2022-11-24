Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C528636FA4
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 02:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiKXBMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 20:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiKXBMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 20:12:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E247107E48
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 17:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669252296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EAEgtP7Q33YGnUJhuj9bYcu+q0J+VmQ8nHbLiIupI94=;
        b=RIQI81KJpykKZLkDKvLsUKwh2Ycw+FI399q+uSLtr/Sirf1p687OxYBh2d0o2x8We6pfKS
        4hLXqi8EYJo0YuhkH060KKwrWHKAdRwNHNObDRGeZ5NKBQRo4T7KG/2aUqioifW0rJYKMV
        JxyDxQPsQ6rRknb0i3XT6Wt19ez4/D8=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-128-jPSwxm8RPFKup4HdtNckYA-1; Wed, 23 Nov 2022 20:11:35 -0500
X-MC-Unique: jPSwxm8RPFKup4HdtNckYA-1
Received: by mail-ua1-f69.google.com with SMTP id q9-20020ab04a09000000b003dfecbdc5cdso159970uae.15
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 17:11:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EAEgtP7Q33YGnUJhuj9bYcu+q0J+VmQ8nHbLiIupI94=;
        b=EwdsZxswVx0Hk+OnVwXiqPCs/v8XO1DDqxCuPcyZKihFbH+/iBmPFI90GZkgMrgDEO
         8pBk7s50OSPSnv6N7h1y9VRHgAM4UCvAtyuyq9N08W6+BuhrjthiHBIbJPepusw0RpqQ
         9+XU6PGgCBJQ/P9aHGmBT9wVLGA3jZEg0KDjG6P8NwYawv4AV9gUhO1aEstYJiQ5zMbj
         Fk/XF7amuCLWfG3NcxAgTwu1zj+skqJR9O9NOjIcDGWIVcbUofKXTtHSV1pS4LK6RCXk
         bEYrsSlHzrazUszmLwAtFhbb57IJKNF+1+25FtIijVbq/ZD7iwr077/RK9/nwHgx+6LK
         HYmA==
X-Gm-Message-State: ANoB5plZuiv3KSJurk2JoKMuBzZIcbS7+uWqAJpXqb57yEUNwZ8X+Aoi
        Pk55nYh3O40PJ4xUGb2ywexDpXBsJlT6s1eDa8XyHDt8iGOp5oJJGTolJzeXdK1eWkrr2iTDmhD
        xDDQjXLTHUtdASIVI+WULi0Ga6Hti
X-Received: by 2002:a67:ee95:0:b0:3aa:2354:b5d2 with SMTP id n21-20020a67ee95000000b003aa2354b5d2mr7613821vsp.16.1669252294539;
        Wed, 23 Nov 2022 17:11:34 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7MT26o5teqlVG/BcHQR/wbsOcwWOomO2xd2bViGPzfqbgb9z48SkJJPFDpEG3QA3rdsSpRKY0ViXUPGmam0kI=
X-Received: by 2002:a67:ee95:0:b0:3aa:2354:b5d2 with SMTP id
 n21-20020a67ee95000000b003aa2354b5d2mr7613818vsp.16.1669252294341; Wed, 23
 Nov 2022 17:11:34 -0800 (PST)
MIME-Version: 1.0
References: <20221119094659.11868-1-dwmw2@infradead.org> <20221119094659.11868-3-dwmw2@infradead.org>
 <681cf1b4edf04563bba651efb854e77f@amazon.co.uk> <Y3z3ZVoXXGWusfyj@google.com>
 <d7ae4bab-e826-ad0f-7248-81574a5f2b5c@gmail.com> <c552b55c926d8e284ba24773a02ea7da028787f5.camel@infradead.org>
 <CABgObfY=jePpPmZJVLdA7nyuPut7B7qCYA64UVwGFxPsmvAVqg@mail.gmail.com> <a9d826ca775d0d250fa6dc8fa208d2ae20a345db.camel@infradead.org>
In-Reply-To: <a9d826ca775d0d250fa6dc8fa208d2ae20a345db.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 24 Nov 2022 02:11:23 +0100
Message-ID: <CABgObfYw7mwt7Jk72Gg57izHduWBWUXKD+fNPix4s-4kKXRVQg@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: Update gfn_to_pfn_cache khva when it moves
 within the same page
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paul Durrant <xadimgnik@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mhal@rbox.co" <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022 at 1:55 AM David Woodhouse <dwmw2@infradead.org> wrote:
>
> On Thu, 2022-11-24 at 01:31 +0100, Paolo Bonzini wrote:
> > Yet another possibility is to introduce a
> >
> > /* Copy from src to dest_ofs bytes into the combined area pointed to by
> >  * dest1 (up to dest1_len bytes) and dest2 (the rest). */
> > void split_memcpy(void *dest1, void *dest2, size_t dest_ofs, size_t
> > dest1_len, void *src, size_t src_len)
> >
> > so that the on-stack struct is not needed at all. This makes it possible to
> > avoid the rs_state hack as well.
>
> FWIW I did one of those in
> https://lore.kernel.org/kvm/6acfdbd3e516ece5949e97c85e7db8dc97a3e6c6.camel@infradead.org/
>
> Hated that too :)

Aha, that may be where I got the idea. Won't win a beauty contest indeed.

What if vx contained a struct vcpu_runstate_info instead of having
separate fields? That might combine the best of the on-stack version
and the best of the special-memcpy version...

Going to bed now anyway.

Paolo

