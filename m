Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F79652F36C
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 20:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353035AbiETSss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 14:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353013AbiETSsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 14:48:47 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7B7135688
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 11:48:46 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q18so8049909pln.12
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 11:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9MFOaAM6SritB1AUY+vgPuUQcwHCXP4JENIYW8kmRCU=;
        b=rwRfRRz5P+63lZfIYNZM0r/UpngSzOvwxn3xC7owpVfczCrLJPrLjFuxIl7eIf1DJ1
         PJVjyYvtDwSv3dcEF2RARXdaoOaVGCifLSBWXXwxxPHmyP8wuiHeGEOejdL7dcT8smxM
         UzAA4djNY6A9Zifw2suFj5IGkgTRW/1rCFSZtO0HN4a53UAsKEG33vmj10gzEhiHc/DA
         93vwr4bWH4IuHozeaRr/HXmIZDR+ezqJM3nLfyINOZ1XVzdIEGxBNUMDWTIU7pvV2OY4
         wwQRad+aM1nGw5W0juraLidqbroFvwOWmxwwVJ4Iqt44vlPrjdO4wm0spQ4AMH+xvZsT
         qAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9MFOaAM6SritB1AUY+vgPuUQcwHCXP4JENIYW8kmRCU=;
        b=cys0jP9YtxgKIStSj9czAD9mSibidExh5cNj24PQbyyCSaptkXEMDxDmMdEHP0CtI5
         LaZnYnU99PKC0xUJgK5L+Mkt4gafxt8wb/VxryNyZgupyNPntzSPH022EJ/49UjNE0cu
         m1CEx+wnVLQMpfokON7UvqO6XaMU0/AVwVBnHIN00/KhhkMqzlVJhcuAe7FpFhdLVZKG
         iawR/blmQQzh7KRoiXvDomQwuuAL1qAxem/pvUMq1Il9rxY1QCAqqwQ936Gyd62/SmlR
         DoxyRxIrjPv9cR+R2646gG19DNn+P7K0Goi8oIo86pZJ+zITGYwiWekihQe3XZ2PAAz0
         OYWQ==
X-Gm-Message-State: AOAM531P6nV2PwADG3HoQ+FYtOnQuemElLZhB//sWRQW/G6MTZKSTTvy
        5g3dRsbNc7+0fIukeq5t+9ax/w==
X-Google-Smtp-Source: ABdhPJwabEUfr21Xnx9zb4VHZ0+AQnbXbGG2mNAhE3IytmiA+GyXXdmAnIAawPRE0sRKLpdk81gHzQ==
X-Received: by 2002:a17:902:d2c3:b0:161:ab47:8afe with SMTP id n3-20020a170902d2c300b00161ab478afemr10630779plc.8.1653072525402;
        Fri, 20 May 2022 11:48:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t9-20020a17090a3e4900b001d960eaed66sm2148755pjm.42.2022.05.20.11.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 11:48:44 -0700 (PDT)
Date:   Fri, 20 May 2022 18:48:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/emulator: Bounds check reg nr against reg array
 size
Message-ID: <YofiiZZu4/ja3C5R@google.com>
References: <20220520165705.2140042-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520165705.2140042-1-keescook@chromium.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022, Kees Cook wrote:
> GCC 12 sees that it might be possible for "nr" to be outside the _regs
> array. Add explicit bounds checking.
> 
> In function 'reg_read',
>     inlined from 'reg_rmw' at ../arch/x86/kvm/emulate.c:266:2:
> ../arch/x86/kvm/emulate.c:254:27: warning: array subscript 32 is above array bounds of 'long unsigned int[17]' [-Warray-bounds]
>   254 |         return ctxt->_regs[nr];
>       |                ~~~~~~~~~~~^~~~
> In file included from ../arch/x86/kvm/emulate.c:23:
> ../arch/x86/kvm/kvm_emulate.h: In function 'reg_rmw':
> ../arch/x86/kvm/kvm_emulate.h:366:23: note: while referencing '_regs'
>   366 |         unsigned long _regs[NR_VCPU_REGS];
>       |                       ^~~~~
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/kvm/emulate.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 89b11e7dca8a..fbcbc012a3ae 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -247,6 +247,8 @@ enum x86_transfer_type {
>  
>  static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
>  {
> +	if (WARN_ON(nr >= ARRAY_SIZE(ctxt->_regs)))
> +		return 0;
>  	if (!(ctxt->regs_valid & (1 << nr))) {
>  		ctxt->regs_valid |= 1 << nr;
>  		ctxt->_regs[nr] = ctxt->ops->read_gpr(ctxt, nr);
> @@ -256,6 +258,8 @@ static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
>  
>  static ulong *reg_write(struct x86_emulate_ctxt *ctxt, unsigned nr)
>  {
> +	if (WARN_ON(nr >= ARRAY_SIZE(ctxt->_regs)))
> +		return 0;

This is wrong, reg_write() confusingly returns a pointer the register to be written,
it doesn't actually do the write.  So if we want to guard against array overflow,
it would be better to cap @nr and continue on, i.e. assume some higher bit was
spuriously set.

The other oddity here is that VCPU_REGS_RIP should never be read, the RIP relative
code reads _eip directly.  I.e. _regs[] should really be VCPU_REGS_R15+1.  And
adding a #define for that would clean up this bit of code in writeback_registers()
that hardcodes 16 (rax - r15) GPRs:

	for_each_set_bit(reg, (ulong *)&ctxt->regs_dirty, 16)
		ctxt->ops->write_gpr(ctxt, reg, ctxt->_regs[reg]);

Lastly, casting regs_dirty to an unsigned long pointer is all kinds of gross, e.g.
if it were moved to the end of struct x86_emulate_ctxt then the above could trigger
an out-of-bounds read.

I'll whip up a small series to clean this code up and add WARNs similar to above.
