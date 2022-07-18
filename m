Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B2457860D
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 17:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiGRPKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 11:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbiGRPKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 11:10:44 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EAD17045
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:10:43 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id e132so10858314pgc.5
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y3DD+UASViCc3fGdQ/4ByzAJsHsn6yyQz8QF1rik9EE=;
        b=h9Hv3MgK7LZRMkwACMwTdtHyUH/P1a01EyGvrqF3l38fy5uYYAe3UFO9XZ/vIwZxFH
         qZJWQL6MJzwiPlwd8qDQTfBj6wpufP9E/X+d5zmM8Q44lFTsFOWxOAw+J33uhi0Ubza4
         Y4hfFHlUImM8cDDAE+y2OjZMtXP9NwIF5Bvop5+bgc2NJK135H+CNAtmrS2j0ahPofMH
         xUIGn6OoRs/jz+rslOPPI0hjQsUtWhaoN5JiDcqhAt6/gCKeRUJW4Ir+eF8avxETlVKo
         Y0QezJpf/Qlv6clWXlpgyM+0cPE+EQoIWm9yJb4dRcIXQfOCkFHcMFJcnamlyuG/kjJB
         VtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y3DD+UASViCc3fGdQ/4ByzAJsHsn6yyQz8QF1rik9EE=;
        b=avfLke1pTjYirDvQdi9qn3Dfo6pEPwgY5Y8iJByCsdu3SsZQFOyWZsUw04o2TAOHgQ
         hWxKf7WAuFvm/LlwPTRZ3mTdP/e7+lpedfNsBQue0CWwne/Mj6p8avldcxj2x9EMDM4e
         FFHkSLZl6oMsBMRCwEmv+TMCbtvYzcgwa3wtAtDOs/UN78SmlL7jUX9cOGhd5L10+6DE
         QbClJ80PalnJGrMcT5MUX2IrMOYk7WYgljrAI2gwU1OodXlXAe9hIIvJVHMref5wJwzQ
         baZIC8IUwcdeQFenDBlDEaqCgoPLbmhypFirLAUTaee5zAerp0P7FPUm2ipClKPLK0kz
         8SmQ==
X-Gm-Message-State: AJIora879G7Eyp+s/DsvrbP1OU+o5NqcOaeOLR5P+BkJdiTZnFWe4kpx
        ypoTYMND0sR/2psSHzsXGxdzKQ==
X-Google-Smtp-Source: AGRyM1u+3wS+b7zUB2a5r4bYSCQZtSYfdQnZbz9rgZATqgwj5v932UogCgeV7eQflosiypDbBNuV7g==
X-Received: by 2002:a05:6a00:1781:b0:528:c839:9886 with SMTP id s1-20020a056a00178100b00528c8399886mr28676389pfg.71.1658157042532;
        Mon, 18 Jul 2022 08:10:42 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id f19-20020a17090aa79300b001efff0a4ca4sm9415305pjq.51.2022.07.18.08.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 08:10:42 -0700 (PDT)
Date:   Mon, 18 Jul 2022 15:10:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: x86: Drop unnecessary goto+label in
 kvm_arch_init()
Message-ID: <YtV37rQaExsfITH3@google.com>
References: <20220715230016.3762909-1-seanjc@google.com>
 <20220715230016.3762909-3-seanjc@google.com>
 <2c8fd8e1179fc63084ec451496df5b68caae2756.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c8fd8e1179fc63084ec451496df5b68caae2756.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022, Maxim Levitsky wrote:
> I honestly don't see much value in this change, but I don't mind it either.

Yeah, this particular instance isn't a significant improvement, but I really dislike
the pattern (if the target is a raw return) and want to discourage its use in KVM.

For longer functions, having to scroll down to see that the target is nothing more
than a raw return is quite annoying.  And for more complex usage, the pattern sometimes
leads to setting the return value well ahead of the "goto", which combined with the
scrolling is very unfriendly to readers.

E.g. prior to commit 71a4c30bf0d3 ("KVM: Refactor error handling for setting memory
region"), the memslot code input validation was written as so.  The "r = 0" in the
"Nothing to change" path was especially gross.

        r = -EINVAL;
        as_id = mem->slot >> 16;
        id = (u16)mem->slot;

        /* General sanity checks */
        if (mem->memory_size & (PAGE_SIZE - 1))
                goto out;
        if (mem->guest_phys_addr & (PAGE_SIZE - 1))
                goto out;
        /* We can read the guest memory with __xxx_user() later on. */
        if ((id < KVM_USER_MEM_SLOTS) &&
            ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
             !access_ok((void __user *)(unsigned long)mem->userspace_addr,
                        mem->memory_size)))
                goto out;
        if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_MEM_SLOTS_NUM)
                goto out;
        if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
                goto out;

        slot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
        base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
        npages = mem->memory_size >> PAGE_SHIFT;

        if (npages > KVM_MEM_MAX_NR_PAGES)
                goto out;

        new = old = *slot;

        new.id = id;
        new.base_gfn = base_gfn;
        new.npages = npages;
        new.flags = mem->flags;
        new.userspace_addr = mem->userspace_addr;

        if (npages) {
                if (!old.npages)
                        change = KVM_MR_CREATE;
                else { /* Modify an existing slot. */
                        if ((new.userspace_addr != old.userspace_addr) ||
                            (npages != old.npages) ||
                            ((new.flags ^ old.flags) & KVM_MEM_READONLY))
                                goto out;

                        if (base_gfn != old.base_gfn)
                                change = KVM_MR_MOVE;
                        else if (new.flags != old.flags)
                                change = KVM_MR_FLAGS_ONLY;
                        else { /* Nothing to change. */
                                r = 0;
                                goto out;
                        }
                }
        } else {
                if (!old.npages)
                        goto out;

                change = KVM_MR_DELETE;
                new.base_gfn = 0;
                new.flags = 0;
        }

