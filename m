Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFE664880B
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 18:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiLIR5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 12:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLIR5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 12:57:45 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4400303C6
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 09:57:42 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-3704852322fso61969817b3.8
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 09:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bMZ9vaUyXosUBjlo9WUDdUBep5JMYYDWXkYuJRTyBRc=;
        b=PNNz0qgco2CC6vK8iX8A8CdQ9XYG/eiYEJI0PFBFwEDrAJkafbZh+wNNez+eyMKsNW
         dyYIVM2JUEXFIo3AsWaRZNjWiZwyFaVdNR0pQpuSKF0S76DLKWQFl1oZGEBDU5afM86c
         4MHyLC00G+IV14UOCOsjUR6HTn+tapMh3yj6v/QPIYSR6ep3HNH6Adic+iJisjvPkwA/
         hLPuSxDfDTXFbxYKTocYksmV9tgslNTPcnfgAPbkxh/jMNo9/8AxKFzwYVG9ZAJJI+XR
         ZLWDlt7dnT+fbIaDz/1md454IG3J2J19ANvQ4CvzY4M0DlboF2jrnlXjyCT1tHR69aMt
         lUDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bMZ9vaUyXosUBjlo9WUDdUBep5JMYYDWXkYuJRTyBRc=;
        b=n5JEo8g1ucIwez1rBgVTz0Q2GjYlJF+hbq2PmHNwLHMU1ScCTbU7b8IcABr2Ni5bFk
         jWkE++ym7hTjKRETBH/ZBVj20BTpU4HkU8QhQzT7+WuSkgV9nY/BaUJEjr4j/mHRZsIh
         Cq1hw2dV3TgMztCzcw6W2xR+iFVb2MSfYlWtD4OuvuZY6r1+VAeT5nlbNsaL+bdbVbXX
         PflF3rnKM/4waqJ8lGQp7iYw5i63LNWoMO9S7r6DCdxhYj4HIRqQ53kjtGAngUqIwy6W
         40EzO/Ej1e2tNUjS69qzdAZBpUNBeud6Wc22mvDCaHBOYfUbSCgh/AaErkA60xdy1uVQ
         q+Lw==
X-Gm-Message-State: ANoB5pmow4hXCVsBYuchh2hDVxls+fiOEl9AFALW/1dzZMsVGK5xzqE+
        5/pvFq3OobeqO0H26AuJFRphz3ijAqfEe91QQJCj6w==
X-Google-Smtp-Source: AA0mqf7ZLFzH7tn8G3mgBGvDrhVn7KNrvvpffIzBOW371A0vYuDJaiDqvxR+ZPRcFAJZ2LX4aVuYJ3WS6sGEmfbkAcg=
X-Received: by 2002:a81:148d:0:b0:36a:75b3:fdda with SMTP id
 135-20020a81148d000000b0036a75b3fddamr7388556ywu.168.1670608661842; Fri, 09
 Dec 2022 09:57:41 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-24-dmatlack@google.com>
 <Y5NxCYz9XV3hgGYX@google.com>
In-Reply-To: <Y5NxCYz9XV3hgGYX@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 9 Dec 2022 09:57:15 -0800
Message-ID: <CALzav=f-qDqJcvPEo1ZxxVizAE77crMFsbKUVif5B-mNgGEHyQ@mail.gmail.com>
Subject: Re: [RFC PATCH 23/37] KVM: MMU: Move VM-level TDP MMU state to struct kvm
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 9, 2022 at 9:32 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hey David,
>
> On Thu, Dec 08, 2022 at 11:38:43AM -0800, David Matlack wrote:
> > Move VM-level TDP MMU state to struct kvm so it can be accessed by
> > common code in a future commit.
> >
> > No functional change intended.
>
> Could you instead introduce a structure to hold all of the MMU state and
> stick that in struct kvm? If the goal is to eventually supersede all
> uses of the arm64 pgtable library we are going to need the ability to
> operate outside of a KVM VM context.

This patch does introduce a tdp_mmu struct to hold all of the TDP MMU
state. Did you have something else in mind?
