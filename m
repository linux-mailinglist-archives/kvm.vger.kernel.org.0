Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6327A282C
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 22:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbjIOUeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 16:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237410AbjIOUeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 16:34:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04EF82721
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 13:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694809985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WrVjZ7kgC4jcFpjJhN66OHF12lqiZOVlHb3znhdjkek=;
        b=Bmy8n6yBFrSIg9KcCVOV1sfrTKJqte4EFS0iICDWpe3etF7BOiSXhUBfnC0AwFSvylQ/9w
        yLaJ1EAhu9Ajw6GPerM0eaZEiIBxNaA7oH7bzWdQuUfM+uz/hfWjwq6w/CidrCBrU94IVB
        JVOsv5SEXigo8cGYagUy6PB/4f10GGE=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-nqR01wBnPYiEwwdyP_14-Q-1; Fri, 15 Sep 2023 16:33:03 -0400
X-MC-Unique: nqR01wBnPYiEwwdyP_14-Q-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-573411a9ad6so3566002eaf.0
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 13:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694809983; x=1695414783;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WrVjZ7kgC4jcFpjJhN66OHF12lqiZOVlHb3znhdjkek=;
        b=fffLlZUwMjuErh+bxIWob2zMyfL9nEhtw5VoQvOqUCtHgKkyI5wchTZuQUkGNpCzQk
         sD3HkpfrM6zT5m08LBxKh5r3iD/Bhl/DFs/o7/y3Ieb8AALjtj4tIpMacC+DVVwk0T27
         SVpLKzvOYlmS1gGabm45xudcQr36xtakR7sbblGF7TkO/vv/UJ47ePnBPS6fedWeGuYX
         8LtuDg9NMZkMueMIbXo3z0HQQ5vreQa6XtIK8WCB6ABD9HwNcvAsYxajD/YztK+5sJww
         0tnb1jF68q4jJvRDODYRoDrqiaOmuqtp3LhpCNayf1V7qqliyE+VjuBkFoPRkMtaRhx+
         DyJg==
X-Gm-Message-State: AOJu0YzqUhsV9SYnnYuMUXR1ZzxUJdR6XnbWDp0WE0Xa0iLHi4ncH+oz
        Pje7Y2IsT1+RdjbOdbKYQkxdciXu9mVsR8j0/GmjdDHZqCEYMtxOuC/n9lJOVeP+FjxPZRUbnhr
        nK6OghDiIuOQ0
X-Received: by 2002:a05:6820:288:b0:571:28d5:2c78 with SMTP id q8-20020a056820028800b0057128d52c78mr3082797ood.4.1694809982781;
        Fri, 15 Sep 2023 13:33:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwxF2PNP32An2sFg0rqEJUH0BvQzKLEJn+zbHJmo4XuW0EFunfLplYJcbkoEVl93ib63Hqtw==
X-Received: by 2002:a05:6820:288:b0:571:28d5:2c78 with SMTP id q8-20020a056820028800b0057128d52c78mr3082766ood.4.1694809982501;
        Fri, 15 Sep 2023 13:33:02 -0700 (PDT)
Received: from redhat.com ([2804:1b3:a803:677d:42e9:f426:9422:f020])
        by smtp.gmail.com with ESMTPSA id e8-20020a4a5508000000b00573a3e283e1sm2172349oob.39.2023.09.15.13.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 13:33:02 -0700 (PDT)
Date:   Fri, 15 Sep 2023 17:32:51 -0300
From:   Leonardo Bras <leobras@redhat.com>
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     guoren@kernel.org, paul.walmsley@sifive.com, anup@brainfault.org,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        palmer@rivosinc.com, longman@redhat.com, boqun.feng@gmail.com,
        tglx@linutronix.de, paulmck@kernel.org, rostedt@goodmis.org,
        rdunlap@infradead.org, catalin.marinas@arm.com,
        conor.dooley@microchip.com, xiaoguang.xing@sophgo.com,
        bjorn@rivosinc.com, alexghiti@rivosinc.com, keescook@chromium.org,
        greentime.hu@sifive.com, jszhang@kernel.org, wefu@redhat.com,
        wuwei2016@iscas.ac.cn, linux-arch@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-csky@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V11 03/17] riscv: Use Zicbop in arch_xchg when available
Message-ID: <ZQS_cw2m3AtnkJxp@redhat.com>
References: <20230910082911.3378782-1-guoren@kernel.org>
 <20230910082911.3378782-4-guoren@kernel.org>
 <20230914-1ce4f391a14e56b456d88188@orel>
 <ZQQUQjOaAIc95GXP@redhat.com>
 <20230915-85238ac7734cf543bff3ddad@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915-85238ac7734cf543bff3ddad@orel>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023 at 01:07:40PM +0200, Andrew Jones wrote:
> On Fri, Sep 15, 2023 at 05:22:26AM -0300, Leonardo Bras wrote:
> > On Thu, Sep 14, 2023 at 03:47:59PM +0200, Andrew Jones wrote:
> > > On Sun, Sep 10, 2023 at 04:28:57AM -0400, guoren@kernel.org wrote:
> > > > From: Guo Ren <guoren@linux.alibaba.com>
> ...
> > > > diff --git a/arch/riscv/include/asm/insn-def.h b/arch/riscv/include/asm/insn-def.h
> > > > index 6960beb75f32..dc590d331894 100644
> > > > --- a/arch/riscv/include/asm/insn-def.h
> > > > +++ b/arch/riscv/include/asm/insn-def.h
> > > > @@ -134,6 +134,7 @@
> > > >  
> > > >  #define RV_OPCODE_MISC_MEM	RV_OPCODE(15)
> > > >  #define RV_OPCODE_SYSTEM	RV_OPCODE(115)
> > > > +#define RV_OPCODE_PREFETCH	RV_OPCODE(19)
> > > 
> > > This should be named RV_OPCODE_OP_IMM and be placed in
> > > numerical order with the others, i.e. above SYSTEM.
> > > 
> > > >  
> > > >  #define HFENCE_VVMA(vaddr, asid)				\
> > > >  	INSN_R(OPCODE_SYSTEM, FUNC3(0), FUNC7(17),		\
> > > > @@ -196,4 +197,8 @@
> > > >  	INSN_I(OPCODE_MISC_MEM, FUNC3(2), __RD(0),		\
> > > >  	       RS1(base), SIMM12(4))
> > > >  
> > > > +#define CBO_prefetchw(base)					\
> > > 
> > > Please name this 'PREFETCH_w' and it should take an immediate parameter,
> > > even if we intend to pass 0 for it.
> > 
> > It makes sense.
> > 
> > The mnemonic in the previously mentioned documentation is:
> > 
> > prefetch.w offset(base)
> > 
> > So yeah, makes sense to have both offset and base as parameters for 
> > CBO_prefetchw (or PREFETCH_w, I have no strong preference).
> 
> I have a strong preference :-)
> 
> PREFETCH_w is consistent with the naming we already have for e.g.
> cbo.clean, which is CBO_clean. The instruction we're picking a name
> for now is prefetch.w, not cbo.prefetchw.
> 
> > 
> > > 
> > > > +	INSN_R(OPCODE_PREFETCH, FUNC3(6), FUNC7(0),		\
> > > > +	       RD(x0), RS1(base), RS2(x0))
> > > 
> > > prefetch.w is not an R-type instruction, it's an S-type. While the bit
> > > shifts are the same, the names are different. We need to add S-type
> > > names while defining this instruction. 
> > 
> > That is correct, it is supposed to look like a store instruction (S-type), 
> > even though documentation don't explicitly state that.
> > 
> > Even though it works fine with the R-type definition, code documentation 
> > would be wrong, and future changes could break it.
> > 
> > > Then, this define would be
> > > 
> > >  #define PREFETCH_w(base, imm) \
> 
> I should have suggested 'offset' instead of 'imm' for the second parameter
> name.
> 
> > >      INSN_S(OPCODE_OP_IMM, FUNC3(6), IMM_11_5(imm), __IMM_4_0(0), \
> > >             RS1(base), __RS2(3))
> > 
> > s/OPCODE_OP_IMM/OPCODE_PREFETCH
> > 0x4 vs 0x13
> 
> There's no major opcode named "PREFETCH" and the spec says that the major
> opcode used for prefetch instructions is OP-IMM. That's why we want to
> name this OPCODE_OP_IMM. I'm not sure where the 0x4 you're referring to
> comes from

Oh, you are right.

Sorry about this, I misinterpreted table 24.1 from the 
Unprivileged ISA (20191213). 

Yeap, everything make sense now, and the define below is not actually 
needed:

> > > > +#define RV_OPCODE_PREFETCH     RV_OPCODE(19)

Thanks!
Leo


> . A 32-bit instruction has the lowest two bits set (figure 1.1
> of the unpriv spec) and table 27.1 of the unpriv spec shows OP-IMM is
> 0b00100xx, so we have 0b0010011. Keeping the naming of the opcode macros
> consistent with the spec also keeps them consistent with the .insn
> directive where we could even use the names directly, i.e.
> 
>  .insn s OP_IMM, 6, x3, 0(a0)
> 
> > > 
> > > When the assembler as insn_r I hope it will validate that
> 
> I meant insn_s here, which would be the macro for '.insn s'
> 
> > > (imm & 0xfe0) == imm
> 
> I played with it. It won't do what we want for prefetch, only
> what works for s-type instructions in general, i.e. it allows
> +/-2047 offsets and fails for everything else. That's good enough.
> We can just mask off the low 5 bits here in our macro
> 
>  #define PREFETCH_w(base, offset) \
>     INSN_S(OPCODE_OP_IMM, FUNC3(6), IMM_11_5((offset) & ~0x1f), \
>            __IMM_4_0(0), RS1(base), __RS2(3))
> 
> Thanks,
> drew
> 

