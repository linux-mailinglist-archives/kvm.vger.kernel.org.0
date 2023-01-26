Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55AE67D89C
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 23:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbjAZWi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 17:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjAZWiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 17:38:25 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C9330EC
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 14:38:15 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id a18so3237652plm.2
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 14:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yjwyCG9JXzDKn+vDhfH0kpK0ETcmqJGPtt6bSVFd3gU=;
        b=DiVQWzOCixDcKXwPwIgk4cMkSAyvqYOxY6ENGfvkVfUSvC9yyjt1e1/E7SwI9JDZht
         P3SXIz0KY/cBo3/5FRBuPqIAzM6C7WG2ZU5gkKJm6EL/vDzHWo3inQ19rczdxmmyqKl+
         wJCqlea6s95EseKRR2esJKKWHmFrJYB9e4Nbc3ACHx7t2aEIfBjSzUgynovFc328cD9m
         OQkH8Cuwn0s31lj+NEd4j3mMw3coJexuwTjnTy1viv8XzyXZpUtDAyFho4NNUjvDCUZI
         vV6wDaAQBd60YkLmG8J3i1UvZddOOKvConq+er4YVJAjoLkd7dDgGfsxBD0UXbH3fzFg
         iVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjwyCG9JXzDKn+vDhfH0kpK0ETcmqJGPtt6bSVFd3gU=;
        b=NdD1SfOrmWv9rU++TET+4dRWxjdB45GIk5QUdAJkYOi+0INdwUpMcbgdf9eX8nzP2a
         BcbRCkCM+ISlApmuX9BHHnBQ7WRj3Ok3Ie1vFAz3Qa5tiMCE7tqdxJGqZikZ2ZZ6ICMx
         u6NOasVAoV1O6JCYbxEOX4sPLrCHIp3ugaknTF008JgALhiuaKQoL0bZVGjz4PrzSTKf
         xzaB+jZgoW3ZvOyUGz8ExQN7UGzavg0Q6kxL0cRbqbuNZDJVBYZ0XtR34SjzJLP1gpoW
         4JBxTJ+YILeCOiv4YISdfxs0/NOU2WDcW834urUhsbjwo3sGZerfBRPSD6a0JEcwGv8o
         wVRA==
X-Gm-Message-State: AO0yUKVoOYnP0OCaWps+O8iC/YSYjBlZitDz0Dtqo2U2ChxuBBQMfXS1
        Q4HjKNeAPG0DQUjZDkZB/sa14EZ2nSIqv3BtFbE=
X-Google-Smtp-Source: AK7set9tg2+OzKsHAvFRUZXDaBDoZoGjBDW6hsBiwjMgB43kOcguCfDd/BYn9ILWZcGm0vN7wDwTdA==
X-Received: by 2002:a17:902:c9d2:b0:189:6624:58c0 with SMTP id q18-20020a170902c9d200b00189662458c0mr1089809pld.3.1674772695230;
        Thu, 26 Jan 2023 14:38:15 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h11-20020a170902f7cb00b001926392adf9sm1434498plw.271.2023.01.26.14.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 14:38:14 -0800 (PST)
Date:   Thu, 26 Jan 2023 22:38:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Replace tdp_mmu_page with a bit in the role
Message-ID: <Y9MA0+Q/rO5Voa0D@google.com>
References: <20230126210401.2862537-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126210401.2862537-1-dmatlack@google.com>
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

On Thu, Jan 26, 2023, David Matlack wrote:
> Replace sp->tdp_mmu_page with a bit in the page role. This reduces the
> size of struct kvm_mmu_page by a byte.

No it doesn't.  I purposely squeezed the flag into an open byte in commit

  ca41c34cab1f ("KVM: x86/mmu: Relocate kvm_mmu_page.tdp_mmu_page for better cache locality")

I double checked just to make sure: the size is 184 bytes before and after.

I'm not opposed to this change, but I also don't see the point.  The common code
ends up with an arch hook in the appropriate place anyways[*], and I think we'll
want to pay careful attention to the cache locality of the struct as whole, e.g.
naively dumping the arch crud at the end of the common kvm_mmu_page structure may
impact performance, especially for shadow paging.

And just drop the WARN_ON() sanity check in kvm_tdp_mmu_put_root() .

Hmm, actually, if we invert the order for the shadow MMU, e.g. embed "struct
kvm_mmu_page" in a "struct kvm_shadow_mmu_page" or whatever, then the size of
TDP MMU pages should shrink substantially.

So my vote is to hold off for now and take a closer look at this in the common
MMU series proper.

[*] https://lore.kernel.org/all/20221208193857.4090582-20-dmatlack@google.com

> Note that in tdp_mmu_init_sp() there is no need to explicitly set
> sp->role.tdp_mmu=1 for every SP since the role is already copied to all
> child SPs.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Link: https://lore.kernel.org/kvm/b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com/

Drop the trailing slash, otherwise directly clicking the link goes sideways.

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
