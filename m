Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6864FE7A3
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 20:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358614AbiDLSLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 14:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345883AbiDLSLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 14:11:21 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4029327
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 11:09:02 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id be5so11518076plb.13
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 11:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NaJfvw6r9C6/6ZgE258KkI8EH6VfRa6X6YWrh9oOleA=;
        b=OX3eqNGbpCTJAk6dwMvyfHeuP5RqVZeaO43LUmBjMPpBFmmjd2fev0QkELsTN6iMJf
         PQpbikonv7csqVlUvEC8FRiMhPuSAKdfV8nLSTHPPjuv4asXoDf0bHDzwqrU1ap1ZjFl
         K1zhzcyUXwd9vbS5a19iJQwiVix2BecT29Ukkzi9gQlsgjLKvhLXLGZ3PHMYutmfLv2W
         UDmj8uCvm7jhOj8q+5ktdJqWnya4Orq+1PviAeNt0w89uiSe23RVvYOLtVNdDR3yJklD
         bgQzcCBflkNRTZf7uD2+FV/KpLGPPZBPIcCuoh1CfpAhRjMfYgVyXkcxhLx0ots4riYn
         nlyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NaJfvw6r9C6/6ZgE258KkI8EH6VfRa6X6YWrh9oOleA=;
        b=saHoVAncQzQQbgr98Dw0jkGIqDZQRAElT4sjahgRYiy15HOsomMuctr2VplfNBveM9
         TYuta9ttv4WG6iZBkGm/w5V1ysNVd1eLVU1M4Xlti9TTjxs/HrllaxAGAyla6oSNzqTr
         +4rH63i5w03cozrOAIeZYLIZWRWIRA1IrtBmXKmtF6Ryb/cNlzkK4voBqRSVzOFgTzlb
         J+9Xo1M9DtzK8GRZIZ1OWGxtdLlUIgFiPFr39qVT41WREgBV9bBNETslWqjf8raPIFpn
         DUIqeIxqlCaBytnUK3vxm3rN0GjNa6tuXoLGksT6mdjJtEan+8g5ep6sPqd/X68SNFze
         Kmaw==
X-Gm-Message-State: AOAM532PDdqVUa0g1SylPmhQpJACbdgV+KOU4urtSkJgSlsQmi1MeMDF
        5EjPFgG8nhTPnPQyZ54PFbuKjA==
X-Google-Smtp-Source: ABdhPJxEQAVjHzb1MYHA+nWtHDUctstRHCxXpm9/b/levkniy7oeG3hEG34Teo7aaYwmaPAZGbzCNA==
X-Received: by 2002:a17:90b:1d04:b0:1c7:b10f:e33d with SMTP id on4-20020a17090b1d0400b001c7b10fe33dmr6467766pjb.165.1649786942210;
        Tue, 12 Apr 2022 11:09:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lx13-20020a17090b4b0d00b001c9989c721esm176444pjb.17.2022.04.12.11.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:09:01 -0700 (PDT)
Date:   Tue, 12 Apr 2022 18:08:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v4 09/10] KVM: x86/MMU: Require reboot permission to
 disable NX hugepages
Message-ID: <YlXAOQOMu4Unryt6@google.com>
References: <20220411211015.3091615-1-bgardon@google.com>
 <20220411211015.3091615-10-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411211015.3091615-10-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022, Ben Gardon wrote:
> Ensure that the userspace actor attempting to disable NX hugepages has
> permission to reboot the system. Since disabling NX hugepages would
> allow a guest to crash the system, it is similar to reboot permissions.
> 
> This approach is the simplest permission gating, but passing a file
> descriptor opened for write for the module parameter would also work
> well and be more precise.
> The latter approach was suggested by Sean Christopherson.

State _why_ the latter approach wasn't chosen, vague hand waving about this
being simpler doesn't help the reader understand how unbelievably painful it would
be to actually get at the module param (I looked briefy, it'd be beyond ugly).
We can still hand wave a bit, but there should at least be a hint as to why
option A was chosen instead of option B.

It'd also be helpful to call out what is lost by requiring CAP_SYS_BOOT, because
again "precision" is rather vague.  The important aspect of loss of precision
is that a userspace process can't be given access to _just_ the NX module param
to opt out of the workaround, it needs full reboot permissions.

E.g.

  Ideally, KVM would require userspace to prove it has access to KVM's
  nx_huge_pages module param, e.g. so that userspace can opt out without
  needing full reboot permissions.  But getting access to the module param
  file info is a mess since it's buried in layers of sysfs and module
  glue, and requiring CAP_SYS_BOOT is sufficient for all known use cases.

> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 ++
>  arch/x86/kvm/x86.c             | 9 +++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 31fb002632bb..021452a9fa91 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7861,6 +7861,8 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>  :Capability KVM_CAP_PMU_CAPABILITY
>  :Architectures: x86
>  :Type: vm
> +:Returns 0 on success, -EPERM if the userspace process does not
> +	 have CAP_SYS_BOOT
>  
>  This capability disables the NX huge pages mitigation for iTLB MULTIHIT.
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index de1d211f8aa3..8d3d6c48c5ec 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6081,6 +6081,15 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		mutex_unlock(&kvm->lock);
>  		break;
>  	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> +		/*
> +		 * Since the risk of disabling NX hugepages is a guest crashing
> +		 * the system, ensure the userspace process has permission to
> +		 * reboot the system.
> +		 */
> +		if (!capable(CAP_SYS_BOOT)) {
> +			r = -EPERM;
> +			break;
> +		}

This needs to go with the introduction of the cap.  There is zero reason to create
a window where the kernel is vulnerable.
