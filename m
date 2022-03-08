Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF2A4D21EE
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 20:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350074AbiCHTu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 14:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350069AbiCHTu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 14:50:27 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6772F1DA6F
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 11:49:30 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id z4so25171pgh.12
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 11:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cjgPprY6uyRX3aGOYlBk1zY5PzKiJKEQbLNZ52r89Us=;
        b=YWuz4NWGI4VyuKnCx/9EFojtla02S9N4zZhgsiDSo9QF/8sf5tKZqNOHF4Q6tyfA0U
         d66nOCWsVlSfDSwI/i3UxqelSqkU7gZxq0MNJCJUXcaAqqZk5HL0C88BFu0rmoqkx5lP
         dU7pZUa9/DznH+IOATZv/YFT+VRiHfMjiTT5slub4MxJESLG9/85Aqax2ZqmuTib6Pa8
         zgPbdNv0PA3gEDsTG2e3CZ+Ca7Jfg796b8KNOrIkv3WxurzMmmQzhyK8AnZ4Wxgn2T0k
         9TA2L2YW4xFrJE7KeKILbs5evO4MHKF9ogIuge3OkTgWYzeslgKsAnjSZL8kerSBoJ0p
         vbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cjgPprY6uyRX3aGOYlBk1zY5PzKiJKEQbLNZ52r89Us=;
        b=5/5m8BPj9pZzvjMxfCY0Z+lFkwkrNXFpY3n/SbH62pMIAvGWRI4WzL3coSg0MaTjio
         LZWy3gAm+im2yY2kPtOGV/w2GoYlpQGUo30F8hegK0WZjVez+HWSm9NuJsQim6R/gXhP
         kEZLrs3CsJIp0beWIdqBGbjXaprUx0Veve9dENXQbo3qiyAGsTmgcZIGpEAPLeALzZzd
         9yUpVzaA6Rxj1aYGuVWydfNyGP8VePaaxZceZ7uWGBIqVnGupwQlD+pFvBpOQwworbZr
         +C2KGDuIxMkQc/JLsFZwUrI7KANVAGEQhhfc0Mp6Da1K1bvjUUoAhzWuLoqAKR9SHDR6
         FZnw==
X-Gm-Message-State: AOAM531bp5xnZ2g3LjMrfmNbiP8unqqwjFLDjPSH0KWezG9GPhmWGnj1
        o7SlHtbRDvVUphbXg0ehmcS3RA==
X-Google-Smtp-Source: ABdhPJz3Igu3LNYsXrjH9yXf2DIh33mlcRhdMqAhDuIQBKw03T6KEUZxrB+TJwJ+61r1NcR8+KoxEg==
X-Received: by 2002:aa7:9e07:0:b0:4f6:a7e3:1b57 with SMTP id y7-20020aa79e07000000b004f6a7e31b57mr19712256pfq.13.1646768969779;
        Tue, 08 Mar 2022 11:49:29 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j13-20020a63594d000000b003639cf2f9c7sm15911856pgm.71.2022.03.08.11.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 11:49:29 -0800 (PST)
Date:   Tue, 8 Mar 2022 19:49:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 22/25] KVM: x86/mmu: replace root_level with
 cpu_mode.base.level
Message-ID: <YiezRaEH9Y/pZpnp@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-23-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-23-pbonzini@redhat.com>
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

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> Remove another duplicate field of struct kvm_mmu.  This time it's
> the root level for page table walking; the separate field is
> always initialized as cpu_mode.base.level, so its users can look
> up the CPU mode directly instead.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/mmu/mmu.c          | 18 +++++++-----------
>  arch/x86/kvm/mmu/paging_tmpl.h  |  4 ++--
>  3 files changed, 9 insertions(+), 14 deletions(-)

Reviewed-by: Sean Christopherson <seanjc@google.com>
