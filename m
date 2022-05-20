Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F4552F286
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 20:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352599AbiETSTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 14:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352652AbiETSTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 14:19:23 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE488689B4
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 11:19:20 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q18so7995821pln.12
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 11:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wgrcw3AWnI5MJ/JhXJfsPIWwbLCvXeysZUnODXN4Ko4=;
        b=guBYQwxKDovD2VNhx5zMFKN7LQYg5JtyW6Y7ASt3KAzn1dpSAkq5tqlNDPGO5pKpM/
         cVEeZiHJOfMPHIE5gtS0Fh1czT/Q2fxIWf06Skm68gqzf3NqPGIkp0eqSO0igmbVtltz
         ggiokUQwWAKEDsTlQ1XDEYgg1ub5xkkVymSxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wgrcw3AWnI5MJ/JhXJfsPIWwbLCvXeysZUnODXN4Ko4=;
        b=qm5BNmbmoeIwab7+nBhU/k7o/MQtqqe+Bg3UrbS/2Yu+avC2DK1V582g6bNs6Qr6F0
         ciN7y6HvWwMzyHiYgdNSUSMFDS488OrMRLMgf08o5yEneIJrA9oSzZKyOOT5kSYwFA/d
         exOte5yXr7wOHvETb4EamAaBY4Yu+Wd87vYTQox/q/8RzDgi4zK6D8Z3HYteKmYnwcco
         rPFjLqCeHAd52yVX6iZmvRBR4jea2VglJj/aGj1RRnFg+wuP/W/qIWosTcB6fZz1pNAQ
         HNZZQy9kdGzy1DEEUGgVAk3ZNIKGDI1FUOZPC8fFGdvqL+YedVkn2FHjffwpZm4cFy+A
         aVwQ==
X-Gm-Message-State: AOAM531njJilgxUXJ46YQXusEnPIjB7lTgKfnrcGKV1GJhMxLqyCkuB+
        l5eK8a36QWDQxKXrG442IeskvQ==
X-Google-Smtp-Source: ABdhPJzej/3St1PJgS9g4UCEKxkkv9Qgf+QM2ka3RrR3JIjvpUTa9IxTy16SHJm8NjocE+FYSdN8dw==
X-Received: by 2002:a17:90a:d713:b0:1df:d114:deef with SMTP id y19-20020a17090ad71300b001dfd114deefmr11291356pju.13.1653070760362;
        Fri, 20 May 2022 11:19:20 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v22-20020aa78096000000b0050dc76281d0sm2183516pff.170.2022.05.20.11.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 11:19:20 -0700 (PDT)
Date:   Fri, 20 May 2022 11:19:19 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/emulator: Bounds check reg nr against reg array
 size
Message-ID: <202205201115.5E830F0@keescook>
References: <20220520165705.2140042-1-keescook@chromium.org>
 <YofQlBrlx18J7h9Y@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YofQlBrlx18J7h9Y@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 05:32:04PM +0000, Sean Christopherson wrote:
> On Fri, May 20, 2022, Kees Cook wrote:
> > GCC 12 sees that it might be possible for "nr" to be outside the _regs
> > array. Add explicit bounds checking.
> 
> I think GCC 12 is wrong.

I think it's more like GCC is extremely conservative about these things,
and assumes the worst when, for whatever reason, it can't track
something.

> There are four uses of reg_rmw() that don't use hardcoded registers:
> 
>    $ git grep reg_rmw | grep -v VCPU_REGS_
>    emulate.c:static ulong *reg_rmw(struct x86_emulate_ctxt *ctxt, unsigned nr)
> 1  emulate.c:	ulong *preg = reg_rmw(ctxt, reg);
> 2  emulate.c:		p = (unsigned char *)reg_rmw(ctxt, modrm_reg & 3) + 1;
> 3  emulate.c:		p = reg_rmw(ctxt, modrm_reg);
> 4  emulate.c:		assign_register(reg_rmw(ctxt, reg), val, ctxt->op_bytes);
> 
> #1 has three users, but two of those use hardcoded registers.
> 
>   $ git grep register_address_increment | grep -v VCPU_REGS_
>   emulate.c:register_address_increment(struct x86_emulate_ctxt *ctxt, int reg, int inc)
>   emulate.c:	register_address_increment(ctxt, reg, df * op->bytes);
>  
> and that last one is string_addr_inc(), which is only called with RDI or RSI.
> 
> #2 can't overflow as the register can only be 0-3 (yay AH/BH/CH/DH operands).
> 
> #3 is the !highbyte path of decode_register(), and is a bit messy, but modrm_reg
> is always sanitized.
> 
>    $ git grep -E "decode_register\("
>    emulate.c:static void *decode_register(struct x86_emulate_ctxt *ctxt, u8 modrm_reg,
> a  emulate.c:      op->addr.reg = decode_register(ctxt, reg, ctxt->d & ByteOp);
> b  emulate.c:              op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
> c  emulate.c:                      ctxt->memop.addr.reg = decode_register(ctxt,
>                                                                           ctxt->modrm_rm, true);
> 
> For (b) and (c), modrm_reg == ctxt->modrm_rm, which is computed in one place and
> is bounded to 0-15:
> 
> 	base_reg = (ctxt->rex_prefix << 3) & 8; /* REX.B */
> 	ctxt->modrm_rm = base_reg | (ctxt->modrm & 0x07);
> 
> For (a), "reg" is either modrm_reg or a register that is encoded in the opcode,
> both of which are again bounded to 0-15:
> 
> 	unsigned reg = ctxt->modrm_reg;
> 
> 	if (!(ctxt->d & ModRM))
> 		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
> 
> and
> 
> 	ctxt->modrm_reg = ((ctxt->rex_prefix << 1) & 8); /* REX.R */
> 	ctxt->modrm_reg |= (ctxt->modrm & 0x38) >> 3;
> 
> #4 is em_popa() and is just funky hardcoding of popping RAX-RDI, minus RSP.
> 
> I did the same exercise for reg_reg() and write_reg(), and the handful of
> non-hardcoded use are all bounded in similar ways.

Thanks for digging into this. I tried to do the same and started to lose
track of things.

> 
> > In function 'reg_read',
> >     inlined from 'reg_rmw' at ../arch/x86/kvm/emulate.c:266:2:
> 
> Is there more of the "stack" available?  I don't mind the WARN too much, but if
> there is a bug lurking I would much rather fix the bug.

Agreed, but I haven't found a way to get more context here. I think I
found a separate place where GCC really does look to have a bug, as it
complains about array usage that is explicitly bounded. :P

-- 
Kees Cook
