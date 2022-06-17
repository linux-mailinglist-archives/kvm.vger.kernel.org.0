Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33D054FA52
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 17:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347292AbiFQPaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 11:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbiFQPau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 11:30:50 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399FF3DDDA
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 08:30:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f8so4162506plo.9
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 08:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JX9xGdiptLoNDTC4kLICm3LWkZE4wnBomWiv9D2Jt+A=;
        b=FroTbfKQXF4oe57u8/z01s4H2lPuFDNHQSRgJovvAXDxEMhjV6urKT0B8sHR2d8L3n
         ae5hlfF9DTvZ3c4JoenCBYAcFC4Cg8LCcOK2JrDuN6oUMXhIoi9o/mdMIV451aYKFaHM
         hsdOfB+Hs+/CcS7myUfGVKpDlXbB3fjN6geQn+KJQKA17rR8Sm9IHtsMFgdomwiKqeEC
         T71kaL/J/sl8yWloLQdFRdTBTWZOAvcg6ooTQr6dWni9zBgS6eSDRk96BL8uwMhSgZPi
         PQtlmqwUfOUCyJu9V8Rp++e8ZGmSuy0PGyvVrA380adh0l3CDL5Obk4WtrHI/VRK72em
         XaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JX9xGdiptLoNDTC4kLICm3LWkZE4wnBomWiv9D2Jt+A=;
        b=v+B+ccZJdvyujwachB3TZVcWGu1vp5jHiWHhXIo0QfOaF9UW8Bn5Ib0K0PRtvQhq0U
         4GJBX3sAb0cpP+mAQ5NBGY9eFd93rYcl+QSORGvQriZfcVNDQHhnFjatq6FaE6XFLRUC
         9HifSLdZ8Zr5Ay59pe3AxhAPZRQtjcstCR4Eu3CzLf0JCcfc1rrjchHX/3pY6MDGIka+
         Q/VH6qfAp4RBXuX8pYyTbzZssqaBAeAGWWwZtUQ+yJRK98+zb6QclyQw66hO/wn1h2RT
         wJDNA879Z0hJmd+UbVqVddXaCc1Klsr73hU8nRtpxbYahI9eVLsubOtJbESYMVQbnY8C
         0eGg==
X-Gm-Message-State: AJIora/XG6ztGwifzXKZTD7ZaFi5/jR2vJf03Mu8KCHkGzGGqQqUikz2
        Z/0Jjvi5qM4IU0NQOnT6gR52+w==
X-Google-Smtp-Source: AGRyM1sShni0HcA+wwvElgEG+uhqDvpiuI/Mbz6fR5xrdxpUTVbxDXYkPyaLGZqxKkWHjKOvWmjOaA==
X-Received: by 2002:a17:903:2ca:b0:156:f1cc:7cb6 with SMTP id s10-20020a17090302ca00b00156f1cc7cb6mr10651437plk.174.1655479849528;
        Fri, 17 Jun 2022 08:30:49 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id o4-20020a1709026b0400b00163de9e9342sm3758558plk.17.2022.06.17.08.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 08:30:48 -0700 (PDT)
Date:   Fri, 17 Jun 2022 15:30:44 +0000
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
Subject: Re: [PATCH v6 14/22] KVM: x86/mmu: Pass const memslot to rmap_add()
Message-ID: <YqyeJKMcqkO5zynw@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-15-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-15-dmatlack@google.com>
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

Please restate the shortlog in the changelog, it doesn't require much more typing
and means readers don't have to mentally preserve context across "paragraphs".

  Constify rmap_add()'s @slot parameter, the is just passed on to
  gfn_to_rmap(), which takes a const memslot.

> rmap_add() only uses the slot to call gfn_to_rmap() which takes a const
> memslot.
> 
> No functional change intended.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
