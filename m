Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F426C72BC
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjCWWH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCWWH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:07:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C311F91E
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:07:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x15-20020a25accf000000b00b3b4535c48dso86718ybd.7
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679609246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SLk55RAEpi8IVeImdN+QwmQrqbECvyFfIFiNn0LHxgM=;
        b=H3VroSq/GKI1+xYF+gxhJLAoHSBc4DBsDruPJZ90rWUKZ6YCOWjI/EwprB40u3cGC4
         J/zBR985ltswwvY8v37quxtCfZ1fZVlzl0O+WdvlpHgg6sP6nQ6U4b179ET4kdaBYlHQ
         4TlM+vHHWiZEhfZkgLmhVsPCf2UYJBs+tbZNlwwUBe3mReqr44+EFTV+GteKJNjzneMb
         km2mAKUfoJip8owIfRkFBJxQ2GlfT62zweNEmV6D22qZvgKgN4vNsobT56kHbBBLP8/V
         7Dlj5Fb8IxayhgbPKrPCqQhRllIz1lvURzEMfMgDCDQa6rRI58nhEbA3COG8/KA6jR4w
         iUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679609246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SLk55RAEpi8IVeImdN+QwmQrqbECvyFfIFiNn0LHxgM=;
        b=WJ2SA5d2ChaSwgc7A2BThpopCrvNiWRISMnuyx9weBQCN8iTzcnVhRondbC7tbYWTK
         OCjp8u6JUJffXCOI+juj09YCx5XEQPyAHed4erPz3/2o0RkjrRhhASQZQU/Csv3nxwix
         LWnhUGLI93G7zreQMCBcQAsOXwc3OtXFEjRVI7GrhFEfPVcQvEMTvUhhctZUE+8oDiw5
         ZYIxjSIFewgMAcfw+hf7+wHAsg0uRnYj7aDf6CvrZRReSL/0KQudRgu/fTu53MbAWt1t
         0Ro01cwc7eU2p9Q9QPP+xrD5KHJ5O5PNPJYzknHUASQcb31ey6Y1gCM55rPv8JPHG6lt
         tRow==
X-Gm-Message-State: AAQBX9e+2G2VJOCfzOE4Xq+mIB33/Ctwyko+aFGD/HLjfjlk7nFyNdlZ
        VPf/5yzAZe2XPChb05eQtTOWD/4OZQA=
X-Google-Smtp-Source: AKy350bb6/4QZ3MEQFvRESMQUqCPHb50KxyL4aE65C1OHSI7MMZ4IeVxDSA0ZVJWSVDSpdo7Jmd567o4gnM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:120d:b0:b6f:dcd:6cd2 with SMTP id
 s13-20020a056902120d00b00b6f0dcd6cd2mr43504ybu.10.1679609246826; Thu, 23 Mar
 2023 15:07:26 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:07:25 -0700
In-Reply-To: <20230301053425.3880773-7-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com> <20230301053425.3880773-7-aaronlewis@google.com>
Message-ID: <ZBzNnepO0HMshwYD@google.com>
Subject: Re: [PATCH 6/8] KVM: selftests: Add additional pages to the guest to
 accommodate ucall
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023, Aaron Lewis wrote:
> Add additional pages to the guest to account for the number of pages
> the ucall framework uses.
> 
> This is done in preparation for adding string formatting options to
> the guest through ucall helpers.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  tools/testing/selftests/kvm/include/ucall_common.h | 1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c         | 4 ++++
>  tools/testing/selftests/kvm/lib/ucall_common.c     | 5 +++++
>  3 files changed, 10 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 1a6aaef5ccae..0b1fde23729b 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -34,6 +34,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
>  void ucall(uint64_t cmd, int nargs, ...);
>  uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>  void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
> +int ucall_header_size(void);

I like keeping the ucall_header definition in ucall_common.c, but we should hide
away the detail that it's a "header" (which doesn't even really make sense to me).

E.g. maybe ucall_nr_pages_required()?  And then obviously do the align_up() and
whatnot in the helper.
