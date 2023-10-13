Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6557C8B25
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjJMQVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbjJMQVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:21:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA4A5242
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:09:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8b2eec15d3so3190283276.1
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697213330; x=1697818130; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5jpQKDWlX2FMxNrIBcRrOyniIIs22PEbqHRQyt5DVnY=;
        b=OS/P6lnipweaR9lkIl2sv/lVVCO/HW8DzlkJurqfmlsTCcRwOC7G1FacUVRXdk7EFC
         fWi4MxicySmAkNK850XetT65hgXDWKOJdPFZNxzuovKPPOxtkoBmQKD3PZ8GSNsQ6n50
         J1YMOyxUSd5vBeCYl1Zpgsmp300vexSETUGu2nE/LOdn/QEelN7bSetYElcdua4S8EMG
         e2HpmgCkxSnEtKr0zYQ0G/9Vrkq7gFLwpMu0/z6t8v83lZ2g82r+I2+5fUVe4+bG2rYQ
         NQV9ByJmvYLCxq8GGzbgJPSNl2Ce/oMfgbIh5/42kMnhUuMV960Ka3wWvDYtX1pHRKJf
         Tj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697213330; x=1697818130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5jpQKDWlX2FMxNrIBcRrOyniIIs22PEbqHRQyt5DVnY=;
        b=P2jQ2ouApgiCCVCKon9sK6PVHfiP0Iu6kbxlmByNS9b68PngPOOFblJnXeT6RyS5Fz
         hGH99wMvnCA/brrN+9MTUSKoXnD6+w0R/XvU6DmvEJQMLTDXj0kpeaNSE7Y3VBSSy/Cl
         3O319O+0lSKN5bdGiYpGtKsPvqRbdV6aQ1sAbI3mpa1HFHZkqBvpJQc2rccCg6xlPFVr
         gtgFk217ExKnsBI+c71wMyFcrI9qR8lYzfU6dTd3PzFBW0rSppE3VrFAxxUDe2gq80sE
         edfj8g2KPu8cK5PJXEyTeOHhPZXM7vqc65CivZJCQxWo7tYuAcHl76rxUSY0zqJ0DWmc
         Wn1g==
X-Gm-Message-State: AOJu0Yyh3uVRdJdlS6QmkM7qtvObfb1FtVvCLcoQwsq5tGzB3ww9mxfg
        eF3S6PIUYbuUlZK9JRRd1+iTsilgi/Y=
X-Google-Smtp-Source: AGHT+IGr+qhBt8pjxzcVd1SRmV9WwBcC/LddWp+eOz/KUseqJ6SHMrtLAjMeiKp99TKb7WRh7jqSjWC2AUY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:138d:b0:d9a:4e29:6353 with SMTP id
 x13-20020a056902138d00b00d9a4e296353mr268090ybu.0.1697213330411; Fri, 13 Oct
 2023 09:08:50 -0700 (PDT)
Date:   Fri, 13 Oct 2023 09:08:48 -0700
In-Reply-To: <20231012152542.1355621-1-pbonzini@redhat.com>
Mime-Version: 1.0
References: <20231012152542.1355621-1-pbonzini@redhat.com>
Message-ID: <ZSlrkKHT_U64raV4@google.com>
Subject: Re: [PATCH] KVM: MIPS: fix -Wunused-but-set-variable warning
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HTML_MESSAGE,MIME_HEADER_CTYPE_ONLY,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023, Paolo Bonzini wrote:
> The variable is completely unused, remove it.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/mips/kvm/mmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 7b2ac1319d70..467ee6b95ae1 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -592,7 +592,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	int srcu_idx, err;
>  	kvm_pfn_t pfn;
> -	pte_t *ptep, entry, old_pte;
> +	pte_t *ptep, entry;
>  	bool writeable;
>  	unsigned long prot_bits;
>  	unsigned long mmu_seq;
> @@ -664,7 +664,6 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
>  	entry = pfn_pte(pfn, __pgprot(prot_bits));
>  
>  	/* Write the PTE */
> -	old_pte = *ptep;
>  	set_pte(ptep, entry);

Heh, 7 year old bug gets two fixes within a few days :-)

https://lore.kernel.org/all/20231010085434.2678144-1-chenhuacai@loongson.cn
