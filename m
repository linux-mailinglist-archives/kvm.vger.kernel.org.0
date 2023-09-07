Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017AE7977F5
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbjIGQiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243895AbjIGQiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:38:15 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD93A6190
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 09:13:11 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-502934c88b7so1417885e87.2
        for <kvm@vger.kernel.org>; Thu, 07 Sep 2023 09:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1694103133; x=1694707933; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XeBbVRtX/aIWzlXHiHUn4OCigEvkTh1dLDX2VajCG9M=;
        b=I9pYhI4cbi4i2ksJ4Q+hdVFqs0CJYiCiY4NKwlgrr3JdmXoDZ2DQofYkOhvesPnJu3
         ydYFmWxU3p9GLZ1z/Z+XXB52f4487vT+xrTTMDxa8qvjRlW8aduRE7LNbvzaKzhCT1h7
         QCCn0jqoS0USuQrqoDOWlzLUz71O5u0pCVOMoY/w/7v8hT7Xom93CqELUTTxTBMRoWgq
         ZTNevq/krmYz4DfrziO0Vb5UGb1N/aOXFEneFysPJ15WxpbODbsYvMDH5p8wsI9NkXaH
         LJz7MOf1n8BJeu+fyGkVSJL+FBpiQGr7+zjB/EgtySi1/8y6vqGcfNpjtSTPcGNq6iQl
         ARWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694103133; x=1694707933;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XeBbVRtX/aIWzlXHiHUn4OCigEvkTh1dLDX2VajCG9M=;
        b=Asd0ujQEvvJwZklorfaf74h1nqHpUtHUuGmRrnrNVgiC6k01/WuI/lyFXNoj/umagw
         23IZ3kx5r0b7/Kv9pH9P/usDY39W6vA3rRDH1xAnhjHv63/0XQ3G8DPHuy0DlBn+H9lY
         RD3KZQITaWOaXs8AFyoSgmKeeqNIzij603PMDs0DFoDO2/BmltjPGpw/q12WPGI8iIum
         vz9glD8eJeHWLluVKRMb2L5tkQW9Mq7ya2yPg6JC8Kz9MrLJBewwuDxHyFnN92z5vC7a
         WmPdURdNZ3JU6v/YB+dDran4j/ECu4OoUTNa45YOVLMx5Hjo3a5nkP0A6+krsRuBICSv
         eV7Q==
X-Gm-Message-State: AOJu0YwEN34RprBUHkX8CXYA1jVInZBCmLmG1Ed/P4FD355JeGbdSbWu
        OpBtlguRd1kNQHpRl25hoG2XTsSm7I9RLEtikyI=
X-Google-Smtp-Source: AGHT+IGEGmreaznUgLT0wco7186DbxtRAxnnEI6albp1jZXrz+2WijzMa2iZXNVK2n5/iINTQ0Yxlw==
X-Received: by 2002:adf:fd4d:0:b0:316:fb57:26d1 with SMTP id h13-20020adffd4d000000b00316fb5726d1mr4496582wrs.8.1694076710917;
        Thu, 07 Sep 2023 01:51:50 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id l21-20020a1c7915000000b003fef6881350sm1853914wme.25.2023.09.07.01.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 01:51:50 -0700 (PDT)
Date:   Thu, 7 Sep 2023 10:51:49 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Charlie Jenkins <charlie@rivosinc.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>, jrtc27@jrtc27.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        bpf@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, peterz@infradead.org, jpoimboe@kernel.org,
        jbaron@akamai.com, rostedt@goodmis.org,
        Ard Biesheuvel <ardb@kernel.org>, anup@brainfault.org,
        atishp@atishpatra.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        bjorn@kernel.org, luke.r.nels@gmail.com, xi.wang@gmail.com,
        namcaov@gmail.com
Subject: Re: [PATCH 00/10] RISC-V: Refactor instructions
Message-ID: <20230907-304f53e7de4e0386d04f4dcf@orel>
References: <ZN5OJO/xOWUjLK2w@ghost>
 <mhng-7d609dde-ad47-42ed-a47b-6206e719020a@palmer-ri-x1c9a>
 <20230818-63347af7195b7385c146778d@orel>
 <ZPjKGd7VstwIKDV5@ghost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPjKGd7VstwIKDV5@ghost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023 at 11:51:05AM -0700, Charlie Jenkins wrote:
> On Fri, Aug 18, 2023 at 09:30:32AM +0200, Andrew Jones wrote:
> > On Thu, Aug 17, 2023 at 10:52:22AM -0700, Palmer Dabbelt wrote:
> > > On Thu, 17 Aug 2023 09:43:16 PDT (-0700), Charlie Jenkins wrote:
> > ...
> > > > It seems to me that it will be significantly more challenging to use
> > > > riscv-opcodes than it would for people to just hand create the macros
> > > > that they need.
> > > 
> > > Ya, riscv-opcodes is pretty custy.  We stopped using it elsewhere ages ago.
> > 
> > Ah, pity I didn't know the history of it or I wouldn't have suggested it,
> > wasting Charlie's time (sorry, Charlie!). So everywhere that needs
> > encodings are manually scraping them from the PDFs? Or maybe we can write
> > our own parser which converts adoc/wavedrom files[1] to Linux C?
> > 
> > [1] https://github.com/riscv/riscv-isa-manual/tree/main/src/images/wavedrom
> 
> The problem with the wavedrom files is that there are no standard for
> how each instruction is identified. The title of of the adoc gives some
> insight and there is generally a funct3 or specific opcode that is
> associated with the instruction but it would be kind of messy to write a
> script to parse that. I think manually constructing the instructions is
> fine. When somebody wants to add a new instruction they probably will
> not need to add very many at a time, so it should be only a couple of
> lines that they will be able to test.
>

OK, we'll just have to prop our eyelids open with toothpicks to get
through the review of the initial mass conversion.

Thanks,
drew
