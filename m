Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD7C520B60
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 04:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbiEJCmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 22:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbiEJCmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 22:42:17 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1825C263DA3;
        Mon,  9 May 2022 19:38:22 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2f7b815ac06so164967387b3.3;
        Mon, 09 May 2022 19:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BPO52QBr44Bzr1xH0azS/RYPVxAq0DK85MFcX2XucZw=;
        b=JT86ApbO4rDLtelzKk4Q/0DlRg7xiTti/1AfWfvsNg8lZG2B+BfQuEZaJGnzP8CpKW
         DMF/40wNEEgVSUsy74nYYKgii47O8mCeBDajUKNSho9I8uwCTxN+Qe5TwVeLGvhnCWgy
         5ErojWR0Xx//v4OkdvAv6+v/XPbGKShR9ffNQcRGj08AoLRmV2uh9icyjTCqH1SkBI3S
         AayUpY1g7HKzaa8uWifqWsqaWSIaXjcBJzJAhKYTYCoSv0gT3H2/HcqYqHVcat6AH1UQ
         a2HKWky6TDsXySKgC2hhR4rLe5XS0G30YzAzU4F/FATZ58dyF/lCSy6bCWFerrpqTrCa
         uLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BPO52QBr44Bzr1xH0azS/RYPVxAq0DK85MFcX2XucZw=;
        b=atBYJONXkKDzo9OjD7H31AsNg5piDi7TzkubZkN42gs/xekdab4tkF8+XNtjsivp51
         /N5eFPiVdePbFG4XdoHj9GlKt53F5Hc8vyLEYgOwEXdeJY11IKGMRvni8I3vcdJIQ6+c
         SRLIR5jyxaTYTlmoz9tmp4fjO0Aq6AOQiEi4uKFEdJi6v5BLVoOIZ+QstIYFsIak5UMZ
         HcrtbmzQlwTy22MyVWKzl3NGlzgf/EoNXslf+aYb1Y8lCzkVOXiMws7Pl8rV9nhmPGCy
         CeIDxTjzYKnFLW1tnoafacF67BHrabl0oxBBg/4KeXnOP4POwKPUtB8pRE+duaEiFC8N
         4Y0A==
X-Gm-Message-State: AOAM530BeFKSsDUQx46/+YYOnSTfHg5CGJ1XYbT0O4FOZ1YC79CZxD6q
        0EkXw+BqeXd0d13I3GrD5LzLYz1DoTJTUw33TOg=
X-Google-Smtp-Source: ABdhPJxbovG+s+ky3Yc8xigW04JzC3pj0B0o8bnhR4lMsNn5dirjbXkA2nFy1JThd3LGiv0CwHX97WfwJfooHqhp2r0=
X-Received: by 2002:a81:c1:0:b0:2f7:d6ae:d0bf with SMTP id 184-20020a8100c1000000b002f7d6aed0bfmr18403646ywa.369.1652150301400;
 Mon, 09 May 2022 19:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com> <20220422210546.458943-4-dmatlack@google.com>
 <YnRGpDa/kG+9h7Jd@google.com> <CALzav=fK9T5YwbiTU1qq7DZuE3E+MVRGDTHpKch7W9jQ9AR8bA@mail.gmail.com>
In-Reply-To: <CALzav=fK9T5YwbiTU1qq7DZuE3E+MVRGDTHpKch7W9jQ9AR8bA@mail.gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 10 May 2022 10:38:10 +0800
Message-ID: <CAJhGHyBaaOghrNr77uhi_VYjfubu_Ai2YK0RriOFPEMeJrHeqQ@mail.gmail.com>
Subject: Re: [PATCH v4 03/20] KVM: x86/mmu: Derive shadow MMU page role from parent
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
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

On Tue, May 10, 2022 at 6:10 AM David Matlack <dmatlack@google.com> wrote:

>
> +Lai Jiangshan
>
> It looks like only root pages can be passthrough, so
> kvm_mmu_child_role() can hard-code passthrough to 0. Lai do you agree?
>


Agree.

Thanks
Lai
