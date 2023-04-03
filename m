Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26796D5113
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 21:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjDCTGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 15:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjDCTGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 15:06:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BD22101
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 12:06:16 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c2-20020a62f842000000b0062d93664ad5so9696068pfm.19
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 12:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680548776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IZEM6mvYmZj+yiKdKb8IHOdr6k0jIGoRnFbSKqxXi3U=;
        b=sblg4pgEQBWs8JbOVsr4ajhbSddvrck4MJsagGRyIVa+QhdSFiUOGWC5ubx/A8gjog
         EmIxHg0skJ4R1x8NJXyMTyHLspeP70cCU+c++/zzOekAn6DA4lu/uHXnmoYzzsoaVEiU
         2buAOS0XySr0jR8Lt/P6m5zUeYBoLS3qfShCBVhtrT2mYsjG3NMEAIEebkiO086Sdpv1
         xCnkyoGfEHexLT8/I7o60UxbSBLaHAyj9WzpSdwS+pNE8GXoOPTr/0MCZ1LBYVCoWGax
         rM9Vdiw2nnXuOLFnPWPYwPCHiIKc00MGjyBU+xeAS8cnfSRSe++TTazhP8/RFxALxG/7
         /xkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680548776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IZEM6mvYmZj+yiKdKb8IHOdr6k0jIGoRnFbSKqxXi3U=;
        b=0R3BtgvqU1Uz77fNJhNeKAE7eNFrqFoy//GueI0l91SrzNm4HJ8hhjCwZZOEopwpaq
         JU9G37hS6U2//0ecr1InDhHkjUNW+72SmOP0TwkJsmP/iuGNNF2Gs7cHzwQj2QmI+x/s
         JgU1+4hV+6QqCCC5bylLiFVjqXW48bx3xmDgMlTWSsNqZ50Fc3n33Sn8JPmgx0hmPI7o
         dwNa6B8ghziqM81ExQn+6eewcnyqvECCuXe0efazwS28sRBKjOuSxUpV3DO+Oat7h2Ks
         BgJhYMRaj2n3+YqYUiuaAWIpn5wag6skEfZM2U8AGFMhKGvhTCQDl2nxOBiKdSh8b3kh
         i3ag==
X-Gm-Message-State: AAQBX9cF9dDeyUzQJ0loLhQOqHX+dD6KCRD/YrKEPYcfmvzSKPptEovk
        2o0hw2pCKP5bOGBASj6dNioudd43D/M=
X-Google-Smtp-Source: AKy350bZDON9g0ZW2ia4qZBmjIdUuuyQ5Jd65Dmh/EkxZrK24Xe2zxbrOsGtP2v8NStboovWAKubwLEC8aQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:2b09:b0:23d:33e5:33ec with SMTP id
 x9-20020a17090a2b0900b0023d33e533ecmr24068pjc.1.1680548776557; Mon, 03 Apr
 2023 12:06:16 -0700 (PDT)
Date:   Mon, 3 Apr 2023 12:06:15 -0700
In-Reply-To: <dc285a74-9cce-2886-f8aa-f10e1a94f6f5@grsecurity.net>
Mime-Version: 1.0
References: <20230403105618.41118-1-minipli@grsecurity.net>
 <20230403105618.41118-4-minipli@grsecurity.net> <dc285a74-9cce-2886-f8aa-f10e1a94f6f5@grsecurity.net>
Message-ID: <ZCsjp0666b9DOj+n@google.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/4] x86/access: Forced emulation support
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023, Mathias Krause wrote:
> On 03.04.23 12:56, Mathias Krause wrote:
> > Add support to enforce access tests to be handled by the emulator, if
> > supported by KVM. Exclude it from the ac_test_exec() test, though, to
> > not slow it down too much.
> 
> I tend to read a lot of objdumps and when initially looking at the
> generated code it was kinda hard to recognize the FEP instruction, as
> the FEP actually decodes to UD2 followed by some IMUL instruction that
> lacks a byte, so when objdump does its linear disassembly, it eats a
> byte from the to-be-emulated instruction. Like, "FEP; int $0xc3" would
> decode to:
>    0:	0f 0b                	ud2
>    2:	6b 76 6d cd          	imul   $0xffffffcd,0x6d(%rsi),%esi
>    6:	c3                   	retq
> This is slightly confusing, especially when the shortened instruction is
> actually a valid one as above ("retq" vs "int $0xc3").
> 
> I have the below diff to "fix" that. It adds 0x3e to the FEP which would
> restore objdump's ability to generate a proper disassembly that won't
> destroy the to-be-emulated instruction. As 0x3e decodes to the DS prefix
> byte, which the emulator assumes by default anyways, this should mostly
> be a no-op. However, it helped me to get a proper code dump.a

I agree that the objdump output is annoying, but I don't love the idea of cramming
in a prefix that's _mostly_ a nop.

Given that FEP utilizes extremely specialized, off-by-default KVM code, what about
reworking FEP in KVM itself to play nice with objdump (and other disasm tools)?
E.g. "officially" change the magic prefix to include a trailing 0x3e.  Though IMO,
even better would be a magic value that decodes to a multi-byte nop, e.g.
0F 1F 44 00 00.  The only "requirement" is that the magic value doesn't get
false positives, and I can't imagine any of our test environments generate a ud2
followed by a multi-byte nop.

Keeping KVM-Unit-Tests and KVM synchronized on the correct FEP value would be a
pain, but disconnects between KVM and KUT are nothing new.
