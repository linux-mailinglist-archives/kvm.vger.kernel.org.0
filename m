Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D384454FB45
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 18:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383359AbiFQQk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 12:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382444AbiFQQkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 12:40:19 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D50749913
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 09:40:19 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r5so4496460pgr.3
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 09:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eG0CUva5Aq4SOJEaRyyUrYQ3pgRfX3tijfJSsmDkrlo=;
        b=oql6iRN5/gsSfty7rLXaF9XMuzqGGVuYoACTvV+VTUpudAPb8cZsJrRZQOeEIE8n3B
         qQPvIY0a/b5OEPVGOHKYQL3vtMzHhYLNXOPDZjcRqgZzQnvBpfIgIZ/BtglNaRKE+CWj
         cRDO3Xdi35/Hu9QW1BoxHcIXhiWBJvgRmf1fDxQ0GHX94C2a9Ryti64UwgoQjugmu/Uh
         hmxSmuyIaTYUZuKWz5E6SsIeUcLynKcxq59V2r9IIUYYHkQFegz14jt6ABrsACO16H/O
         Az4ZJHSIMxPutm+fa28G8gV7xCut2++vxVuZO9229EUe8uknNCZeJvpUHYrW9xNM/fGV
         1REQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eG0CUva5Aq4SOJEaRyyUrYQ3pgRfX3tijfJSsmDkrlo=;
        b=nvRj2xK0Ns53Ay1hBkdrogOzBkhLhQCuB02g2VagsAJVIvdd+7ajbm5pp0t92H1JG3
         9kaAiT2jnyS8ZcyTNUvF3c0s/S+4QuuoE4QkurpsSIYTojUXajHwKEQhhDdQvRFW3SI9
         sM/qnirA64EgCs5NQUnxxUQ4WWKenPf118S55htOniADT/hLAeYjqUU21vWGWvMJ35E1
         ssIbnLl0Yca3YHD4423ZW3f7KakvP/a4/TH41+e1uk15TT4MCPaSZnkFPWEaPfWtSOxy
         +/8Uwlpok3P0tprGLT87LhxVEeu6iJBif0qqfjnOlfshvzQk91GjFznPHPuWy8ZW8P+P
         ZCvQ==
X-Gm-Message-State: AJIora/97rTiNYGHnQMR+ieZJVorOB5gkBC716EkZTpRcAvDcb5f7hSd
        UlZHYm9cfGUmkumV3TOnY2SYIQ==
X-Google-Smtp-Source: AGRyM1vkErVIo60E1+xRn2pCYtk39EnT3UcKBOjotLOLSMAz1iO59Xe+kUiU++BGXT85af7uxf+tVw==
X-Received: by 2002:a63:7d42:0:b0:40c:570d:f736 with SMTP id m2-20020a637d42000000b0040c570df736mr2986595pgn.306.1655484018570;
        Fri, 17 Jun 2022 09:40:18 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id e10-20020a17090301ca00b0016796cdd802sm3948290plh.19.2022.06.17.09.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 09:40:18 -0700 (PDT)
Date:   Fri, 17 Jun 2022 16:40:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v6 16/22] KVM: x86/mmu: Update page stats in __rmap_add()
Message-ID: <YqyubojzB7zeHag6@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-17-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-17-dmatlack@google.com>
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

On Mon, May 16, 2022, David Matlack wrote:
> Update the page stats in __rmap_add() rather than at the call site. This
> will avoid having to manually update page stats when splitting huge
> pages in a subsequent commit.
> 
> No functional change intended.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
