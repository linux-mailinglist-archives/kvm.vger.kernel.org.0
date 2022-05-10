Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E4C5226CF
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 00:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbiEJWYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 18:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235877AbiEJWYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 18:24:17 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF7B28ED34
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 15:24:16 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id bm18-20020a056820189200b0035f7e56a3dfso272517oob.8
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 15:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aBb2Acx4ZQsS24OdCgBPUHO+9Y3VhgqXr7HO20qkXpk=;
        b=qKikUQYzjr0La5+bezLa6p5PXSGp7DMTHsgzfyq9dM4lwwngClnXNieeszKwWPfxPT
         mEYEQDHTvhNmluvw5t3ejmwqS4ecZfEsQOh7TktEuKMtvV7DiEvJ9/9ZJGAchjlgdoB3
         mqj1r9Q5qnGD7aGs/c+puAZcaz52G/4FpjfnVQIFniPSORtns0MkWvCDKyOqgydABlUo
         NgvUr4MnIQkYXneMh6H78+xBQYnRZoO+HaFF8ebd5UtOGOH/2kc6C+REnfRoIfksXsZQ
         GRLbPO3SnIHMGZcXYXcBIQ6k/9Zaz55mWmXKgrOA8wFetEnkgd6IYd/z+gLbYeJf8sfn
         Lb0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aBb2Acx4ZQsS24OdCgBPUHO+9Y3VhgqXr7HO20qkXpk=;
        b=ePrVnCWPP888WW/gIgy0MZgUk55bJT6KzzIuLU80RvyvV8O3iZO+HiNtftjh1O3g01
         LxW/lGuouW6K9NrwPf1m7e8GChiz88Su/8E69tZWHmRU+optZvqPjr6Pb5bs7s1HRtek
         g+wTfv17KncA3G3yx3jmwz2a3dbUrclE7gH02gP3RqphOeephY8OeotNQW9HCET57uRM
         Qi5miupi07m8HS29Blt5Neraz8yNkzXJuDH4pSySGVrRAxptuage1Ne2r62s7+4JFEiQ
         XHAaVqlVbSJYzH/l/3F6M4w0CaugrlDUEvGcXnWoYNfqJmh6kpJlyZvnR3Ed4ClMFIJb
         TxQQ==
X-Gm-Message-State: AOAM531TQI7MvsPvyTsOJ/ZK9EUn1IX92+ypDGU05l7b1tfKm4zOPP2e
        /dFwzKv1czCz5VFJ2gYngL95SvGbuUH3ugvOkrtYOIHucjg=
X-Google-Smtp-Source: ABdhPJyoFY0Cy4B5DTZ3Hjej3ZFz0kT3mmmrnNFLarE8KLL5ntXlSptA25Rcq132HuPDPUtG8aogCuxFXGURUUwgzGg=
X-Received: by 2002:a05:6830:1c65:b0:606:3cc:862 with SMTP id
 s5-20020a0568301c6500b0060603cc0862mr8582386otg.75.1652221455801; Tue, 10 May
 2022 15:24:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220508040233.931710-1-jmattson@google.com> <YnqSecml2/Ooc0E/@google.com>
In-Reply-To: <YnqSecml2/Ooc0E/@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 May 2022 22:24:05 +0000
Message-ID: <CALMp9eQEaWxLTY3d8JRFWdGn6qLuOLTX3y-t+W-mkEzCe3n0hg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: VMX: Print VM-instruction error when it may be helpful
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 9:27 AM Sean Christopherson <seanjc@google.com> wrote:

> >  noinline void vmclear_error(struct vmcs *vmcs, u64 phys_addr)
> >  {
> > -     vmx_insn_failed("kvm: vmclear failed: %p/%llx\n", vmcs, phys_addr);
> > +     vmx_insn_failed("kvm: vmclear failed: %p/%llx err=%d\n",
>
> I highly doubt it will ever matter, but arguably this should be %u, not %d.
>

:-@

Okay; I will send out a V3, along with a separate patch to fix VMWRITE.
