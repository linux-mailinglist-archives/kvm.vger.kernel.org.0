Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95859689C38
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 15:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbjBCOvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 09:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbjBCOvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 09:51:39 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2029EE3F;
        Fri,  3 Feb 2023 06:51:29 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id s13so2133066pgc.10;
        Fri, 03 Feb 2023 06:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gAmcVcPzKUo0eaAoSFpK1K7dAWevdYPiTJfIGF4jlYI=;
        b=dyRSOie+8tzVcxe5LcM2tK32lZx7l2Ic5JYeuBNsiCGPu2RhSQ+er4TMjzaYZBuL3f
         DLYMfWray/BKrTeQKzXYkAMeUE5qWxKpnOht8qS2ddSxuCJZZKQuiTbkjwzCiDdnTNYR
         UYBTNnnhdOB8g75dy5fU837L14VAqUMfmgNQ/bLqEH8cGdImwrfXa9wmRfixCOROmA1H
         Jb0EHuEG09r/TVomNcJubhkxOi4bxTyVyZmWC6t7uDy55xOlOW12JeSPSfFknZbYeXOc
         VsSHtuFFwMYgxz1rrHzz74DceCHb030FSCm0UXOGwBpBrNqD1oauUjXkNtsp/rZR1g3m
         2Pdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gAmcVcPzKUo0eaAoSFpK1K7dAWevdYPiTJfIGF4jlYI=;
        b=AqADf0X8k5m3XSiWCvszAN4qtmIM72p/eQDJ6xUjPEbuWnvcx9rigSBxUFMMkAD5MC
         p9nMlfJf0Z2lMiuObPZtnnyJAbaZHY5GvxnGbIWCB7kK+o/wy4XIyR70rFmeEIOekCgX
         y0RUVIBEsWKL49nEgBrC4ax6gxgLSdp79trg7vDem5GJYBhxoP0YMqJs9RjwwGEUYQvc
         OQzaOXq+pth+o0RH1M9Qti2seiM4QRbCEiVYBZ0bEUX3tID55ctOMUHDCIIuZIu+9xsD
         7qdg+OJAAlzLH5pVPQY7j8zbNmrzogpjP9rMkwH9qYXhvis2pbA5RhHXei1+b+/D60jE
         5wWw==
X-Gm-Message-State: AO0yUKUxxDlrk/iojuCaTPQMsTKym0RIcysmoKltnwliqpCTnXIYN9nF
        2ta1TQN8jmmo2jzKGVhxyi/5F/X/9GB+9684LuY=
X-Google-Smtp-Source: AK7set/5l76jBwRfzbznsue7l9dATQ6NGs0WT3rY1ns61lxceUhsPvqBRqqI7PX1FgwABgchrebkdzuTr/5de1PLpCs=
X-Received: by 2002:a05:6a00:181e:b0:593:c9b8:4cc8 with SMTP id
 y30-20020a056a00181e00b00593c9b84cc8mr2406805pfa.42.1675435888799; Fri, 03
 Feb 2023 06:51:28 -0800 (PST)
MIME-Version: 1.0
References: <20230105095848.6061-1-jiangshanlai@gmail.com> <20230105095848.6061-2-jiangshanlai@gmail.com>
 <Y9sP/0B8A7fx2tkf@google.com>
In-Reply-To: <Y9sP/0B8A7fx2tkf@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 3 Feb 2023 22:51:15 +0800
Message-ID: <CAJhGHyCgSzH5x9=OutgOcxCEg784woz9VouAwJ=K0xqXTF9Avw@mail.gmail.com>
Subject: Re: [PATCH 1/7] kvm: x86/mmu: Use KVM_MMU_ROOT_XXX for kvm_mmu_invalidate_gva()
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 2, 2023 at 9:21 AM Sean Christopherson <seanjc@google.com> wrote:

>
> This is logically correct, but there's potential (weird) functional change here.
> If this is called with an invalid root, then KVM will invalidate the GVA in all
> roots prior to this patch, but in no roots after this patch.
>
> I _think_ it should be impossible get here with an invalid root.  Can you try
> adding a prep patch to assert that the root is valid so that this patch can
> reasonably assert that there's no functional change?
>
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 508074e47bc0..fffd9b610196 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -792,6 +792,8 @@ void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
>         fault_mmu = fault->nested_page_fault ? vcpu->arch.mmu :
>                                                vcpu->arch.walk_mmu;
>
> +       WARN_ON_ONCE(!VALID_PAGE(fault_mmu->root.hpa));
> +

I've been updating the patches as per your suggestions.

And I suddenly realized that when fault->nested_page_fault=false
with nested EPT, fault_mmu->root.hpa is always unset.

fault_mmu->root.hpa is just meaningless when fault_mmu is not
vcpu->arch.mmu.

I will add it as one of the reasons for replacing the argument
with KVM_MMU_ROOT_XXX.

>         /*
>          * Invalidate the TLB entry for the faulting address, if it exists,
>          * else the access will fault indefinitely (and to emulate hardware).
>
