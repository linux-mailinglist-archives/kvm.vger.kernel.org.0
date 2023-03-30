Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED02E6D0CDD
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbjC3RcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjC3RcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:32:20 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ED0EC5A
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:32:14 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id hg20-20020a17090b301400b00240d154f381so540905pjb.9
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680197534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nnTxsagUavl4R5aNPiZp2P+s0f7o2Hc1Pg/eKFJp8lA=;
        b=Tbftoqox//lZxbaYckaOW2jLVCOWAr7GWaUOL82qbvrJCy/mMJPuj/3f2H7ZFuS5yB
         hBsKdEhNaqwUHaG/myxU4nSEcTVmPZd22Ai/s2inSUgRjPVi19MqgveLSoH3MXl/zBuK
         2OGO27X0nuriV2ZEcAPrBWGREVHFoUpSBXWZg6PY8pOlLEsU/vTFddtIWnD9UzHN8cLb
         MmaLjPpJF1yTTlI0gwiwKKSVbn+wFGFeAcimW7Bwe03gl2gYgrFS24rBYtHCoAi1/4dI
         IbNBf+BcaCMBhBTF0fa6zR3dswkAI5EeB6i4FNe1DNt5XwrwigVS/lgHxB+U5r6aiuu8
         X3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680197534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nnTxsagUavl4R5aNPiZp2P+s0f7o2Hc1Pg/eKFJp8lA=;
        b=2XNWwYnh7t7vI6ciFaRyhLEgvq05WCnjo32qKHFUR6ILiCB6O15ZAii0iiak19C+BK
         TLQ2E5rS1JppaGeY7SuAzP1Ey6oOiddEdfoVDsDgoXHAYOcHnFvB6OOG2L/zmsHNu2+X
         kulUxCVGrbcwBDn0EuQbAJrZ1htIG5oa5cVTQeg+sgbO3x4xif3kUMQHgfnDdiu1H63H
         0xZeFqicayoyPDvd78Xo4kYFenqSau9srKe+RfAxP/PspZPFGgl95svpV1pugrBnZcbu
         +46gSmBQIRlX8M4pIaPZrZZKrIBn0j3U0RazUgJB/BvKylJhrVYH4XkdWqwB1/RXoBcf
         DUVA==
X-Gm-Message-State: AAQBX9eiq/XOl0Sny+pBJ0YhAFHtWj0dlYR5mxdcHKlMBmQK4Ar0Ko/h
        rJFD0wRfx4uGv7l7P4VtikmY8H4rqyA=
X-Google-Smtp-Source: AKy350azwWwpDFQd4w8zJIPRbA66xXSs/muh2nz2rtjySYQAHjCaHNE9llrmnCWe8Mcu6uxntD2BlSaMQdY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e88e:b0:1a0:7630:8ef9 with SMTP id
 w14-20020a170902e88e00b001a076308ef9mr9302444plg.12.1680197534051; Thu, 30
 Mar 2023 10:32:14 -0700 (PDT)
Date:   Thu, 30 Mar 2023 10:32:12 -0700
In-Reply-To: <20230330154918.4014761-2-oliver.upton@linux.dev>
Mime-Version: 1.0
References: <20230330154918.4014761-1-oliver.upton@linux.dev> <20230330154918.4014761-2-oliver.upton@linux.dev>
Message-ID: <ZCXHnFz7gB8QJzvD@google.com>
Subject: Re: [PATCH v2 01/13] KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>
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

On Thu, Mar 30, 2023, Oliver Upton wrote:
> The 'longmode' field is a bit annoying as it blows an entire __u32 to
> represent a boolean value. Since other architectures are looking to add
> support for KVM_EXIT_HYPERCALL, now is probably a good time to clean it
> up.
> 
> Redefine the field (and the remaining padding) as a set of flags.
> Preserve the existing ABI by using bit 0 to indicate if the guest was in
> long mode and requiring that the remaining 31 bits must be zero.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

>  Documentation/virt/kvm/api.rst  | 3 +--
>  arch/x86/include/asm/kvm_host.h | 7 +++++++
>  arch/x86/include/uapi/asm/kvm.h | 3 +++
>  arch/x86/kvm/x86.c              | 6 +++++-
>  include/uapi/linux/kvm.h        | 9 +++++++--
>  5 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 62de0768d6aa..9b01e3d0e757 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6218,8 +6218,7 @@ to the byte array.
>  			__u64 nr;
>  			__u64 args[6];
>  			__u64 ret;
> -			__u32 longmode;
> -			__u32 pad;
> +			__u64 flags;
>  		} hypercall;
>  
>  Unused.  This was once used for 'hypercall to userspace'.  To implement

Note to self, this needs to be updated as "hypercall" is longer unused.
