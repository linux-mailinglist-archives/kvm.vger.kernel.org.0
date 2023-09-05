Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B8E792EE2
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 21:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243021AbjIETa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 15:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbjIETa4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 15:30:56 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAF694
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 12:30:38 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-52c9f1bd05dso4241906a12.3
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 12:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1693942233; x=1694547033; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DbvE2l6qu6o8lwEp1aweLnrA/XOcH4sUpdaaPXX6k2k=;
        b=KaTmuTp6B2FMrnAAGxX1UHenW8KrtHyrqqRaRz0pDD0bSY5D4SnnhOWoWay6nwckP4
         RmgoqAsPUC1ssfQKCqlpH0zsEau9WQ776mY8q8hR6k6IkQXnt01rgzjVOy3Wn5XXBylJ
         wKiWzuOVBHKfr0E8x+M88/DqjpYK+nUpPD4Yc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693942233; x=1694547033;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DbvE2l6qu6o8lwEp1aweLnrA/XOcH4sUpdaaPXX6k2k=;
        b=he4T0K57ku2+t+ogRHR9hbgp9VyA7MDvtZfOe5wC8Tuv/j4cWQI0U8C6EU/0+BNqo8
         vONhKjJMxBkRaVDAPTD2ev3Ab63V0oKmrN4ZF/2xpyvmHzGiAv+4yjJuE4Bgypvxco3F
         DXaxiAbhLUA9P/mCV+cAWJf5qWW+4qxyCo+ziF0lHmvv1oiD2CGBpCUjX0RFJXMFNO7o
         h8p5UPhrUI/Dm0rldbCZcQfMU/Bx8CMeqgToBG01F7VrZ9BiTo9HeSjURNUuY15UF2eb
         cNW1gHE7r41GKuNfMBWQEXcgB0UBQMXl/6vhBVbt+O6Mky5y/5wrJuRdFkQDUMucdvpN
         3m6A==
X-Gm-Message-State: AOJu0YzZKUNXslQ0rldanpQNuQjzqNPx534Cj6CMg1BAv0JP1b+iEzOc
        ylsnE6731FCXewv/9O5U0wwbMEMML3v3W2XVno9MYpTd
X-Google-Smtp-Source: AGHT+IH+VSvn8LjK484LGREIv38CyHcuq7QuUqvM9nDO/TJftMlBF1FtxWyAONFfTJxuGb0fEwu/Qw==
X-Received: by 2002:a50:ed97:0:b0:51d:d30d:a037 with SMTP id h23-20020a50ed97000000b0051dd30da037mr635682edr.10.1693942232812;
        Tue, 05 Sep 2023 12:30:32 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id x2-20020aa7dac2000000b005272523b162sm7413782eds.69.2023.09.05.12.30.30
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Sep 2023 12:30:30 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-52c74a2e8edso4236618a12.1
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 12:30:30 -0700 (PDT)
X-Received: by 2002:aa7:d316:0:b0:52e:33ad:4031 with SMTP id
 p22-20020aa7d316000000b0052e33ad4031mr515378edq.40.1693942230448; Tue, 05 Sep
 2023 12:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230808085056.14644-1-yan.y.zhao@intel.com> <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com> <ZN5elYQ5szQndN8n@google.com>
 <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com> <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com>
 <ZPd6Y9KJ0FfbCa0Q@google.com>
In-Reply-To: <ZPd6Y9KJ0FfbCa0Q@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 5 Sep 2023 12:30:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgFUBOOhOpvwkuH_hs=pTPLEf4YvOj1z2vudB3XFHpXJA@mail.gmail.com>
Message-ID: <CAHk-=wgFUBOOhOpvwkuH_hs=pTPLEf4YvOj1z2vudB3XFHpXJA@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 5 Sept 2023 at 11:59, Sean Christopherson <seanjc@google.com> wrote:
>
> IMO, rather than copying from the original memory, swiotlb_tbl_map_single() should
> simply zero the original page(s) when establishing the mapping.  That would harden
> all usage of swiotlb and avoid the read-before-write behavior that is problematic
> for KVM.

I don't disagree, but the argument at the time (I think from
Christoph, but I might be barking entirely up the wrong tree) was that
the swiotlb behavior should match hardware DMA, and we had known cases
where the hardware only did partial IO.

Honestly, even pre-zeroing sounds silly (and *much* too expensive,
even if less so than copying), and we'd be better off if we only zero
the rest once we have seen a partial DMA result, but I don't actually
know if we have that partial size knowledge.

            Linus
