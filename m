Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581EA534BEE
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 10:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346764AbiEZItX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 04:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346758AbiEZItW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 04:49:22 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C761A888A;
        Thu, 26 May 2022 01:49:21 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-300beab2b76so8068027b3.13;
        Thu, 26 May 2022 01:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lR+TDr5LsguOn0VlHOYnRCFxRx4+aXjTPws9yY6c9Ps=;
        b=dePYxaYADwy99/kEkfatg9gM+WrqLQn8Y+9iUnBjSFPp+2Tie1Y91tr9I4Hhr1T//N
         O8wmRHO23cRkZySp3l66x3VAYRl28qdPbYKZqVuGKqGHnbkcVB0EhFssTUB2+1j1f2xF
         rhF09KcK/nbrUAMUCGK4BiKhZtvgCR7Z+cpHcE1yKouDwNHZa0DXI+PZvFXk0QSNZvkx
         YvsKA0ALR5qS1zwW3Vw34gJ3o/InKGBkRQ7VvrST4pnXhgQteFJljhqe1jCJLpUuKI+0
         JLQ1SfuGwp2p7vREmVgwFXiWZxxzpnrbXpJ1cquOmhFhuuZyk7IeY/8XFRKV83JgDr90
         2cag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lR+TDr5LsguOn0VlHOYnRCFxRx4+aXjTPws9yY6c9Ps=;
        b=n52BjwyXH8iYW+XtFKr54XjZClQ99zjNkqTXR//4ttezigSwrRo3iDhggtSkfYY7wq
         essqhlrIA7a7vW67rudT5MjK0GoJsjkGivPiceGj3G6EjyXKc5nTi0+muYr2tGR2VzE+
         DrBxhq70Mbtje5a0tYtNKUnC4clD1d46yO6eAeFB9Ki+wkYygN4FRlQedGleq5ocdX8Q
         ff+7a+alt08dlU0C77NUpMib9mX5vZwyne/BeiZjlyjb2fNFU9byw9IQPY9RgOpH3Dez
         eBwxOKWUsMgO6iWGSJ1gdt6UE0bEUlXiuHAfNaTIEcAWOCU1PW8E9qtQT6vhuV2D086B
         pj1Q==
X-Gm-Message-State: AOAM532DaSh074UHMkl1ceIHSSkD//r4P00u7VfkyFRqnZD+YrmjS/SM
        DXCw7hUkPx7nbOCJKer3EVbepuzVE6x5gkAZFP3VNSj1ZiE=
X-Google-Smtp-Source: ABdhPJzialUr5kBtsF+rQDVp9AhSqEHOiDeC5+O03iQtIA8jRBZNf91Kul18LqL8NyuJNZ3koDIWcB8eaIBLTwG8bWU=
X-Received: by 2002:a81:b80d:0:b0:2ff:db8b:333a with SMTP id
 v13-20020a81b80d000000b002ffdb8b333amr20379755ywe.17.1653554960598; Thu, 26
 May 2022 01:49:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
In-Reply-To: <20220521131700.3661-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 26 May 2022 16:49:09 +0800
Message-ID: <CAJhGHyDSxN5haa6bx+44jRXw3PBad6DcmZNc115g5Vfve=xLEA@mail.gmail.com>
Subject: Re: [PATCH V3 00/12] KVM: X86/MMU: Use one-off local shadow page for
 special roots
To:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 21, 2022 at 9:16 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
>
> Current code uses mmu->pae_root, mmu->pml4_root, and mmu->pml5_root to
> setup special roots.  The initialization code is complex and the roots
> are not associated with struct kvm_mmu_page which causes the code more
> complex.
>
> So add new local shadow pages to simplify it.
>
> The local shadow pages are associated with struct kvm_mmu_page and
> VCPU-local.
>
> The local shadow pages are created and freed when the roots are
> changed (or one-off) which can be optimized but not in the patchset
> since the re-creating is light way (in normal case only the struct
> kvm_mmu_page needs to be re-allocated and sp->spt doens't, because
> it is likely to be mmu->pae_root)
>
> The patchset also fixes a possible bug described in:
> https://lore.kernel.org/lkml/20220415103414.86555-1-jiangshanlai@gmail.com/
> as patch1.
>

Ping and please ignore patch1 and patch9. It would not cause any conflict
without patch1 and patch9 if both are ignored together.

The fix is wrong (see new discussion in the above link).  So the possible
correct fix will not have any conflict with this patchset of one-off
local shadow page.  I don't want to add extra stuff in this patchset
anymore.

Thanks
Lai
