Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82A15B2283
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 17:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiIHPhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 11:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiIHPgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 11:36:55 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601F2F10EF
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 08:36:48 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v4so17086814pgi.10
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 08:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=2K9yM4gO41snBVkzSq5EbskGviVZmCwT6wLF/ufhIYw=;
        b=eOY85B940AXHYy+oPrDkHL0fYBRXMXzR15PBj3Yo+s1i8shl+Ap7Yx1fbAQY55wWCK
         xt6521ImSs8s5Whia4oKKRh2eZhW4fbH7uIAMpisA0QvAajdsBvfufs5fxhwkoQnuJEz
         SZm6vxWvXuIGr8b7rQjuqeIM6lAE9qd9GUYK1CRgEhlHhD9mQx+eKmmgm3iqWS11WJ7f
         6qOza+GGGYuo1OaBMEH+liqrLBEDlGZ+cVTwv8VORq2Ju/rPzj5qukNtVzolQForclVx
         NIt+vIQ+wwVUUWFifY1yUmEKL4OTC5YJuwpu7058wqN0ZXzLJOosRprkeyHjdqZ+BN4y
         KKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=2K9yM4gO41snBVkzSq5EbskGviVZmCwT6wLF/ufhIYw=;
        b=r6oI+e/QCmY1442t4BIxX7Z/6Y9Ag2Mxm1k4DXgnIHRtkqlGcrtiVkccETjSzRIwMf
         MyMb6mLYYCSbHCfokWOnU3EC3VjXvVFemwNZ8mVt3RMjUN0T9uJ2OE+RxEao+wDHunqM
         590cfSiSFTrZUezNHPAK+zjXkVYuNth4NtnbG9EToaBPhOddMCtdv/WeLSu6PEEkP6T8
         3f8IjYb72DzCPhW1bL5gHX+DYklaaHpEsJCwczErt88gsUWDm9dUiqyAjXbrUd642OKH
         q472+NyiXpnStFIgJ64/qIJvApqREBCjjy+rx4C5d+DDM9LY9ZNjnmzxxPZ7DKU+UGH1
         WA9Q==
X-Gm-Message-State: ACgBeo18iM24nU+F3QwWrhigkoowv7j6B5OzO9+Th4Cbq5NLD4kI6NCg
        64AwzIG0KE76RQeIKcfZaC/Gyw==
X-Google-Smtp-Source: AA6agR45NKB24H1MECWu4RCNOiCuz2m4d7TqOiG98PFWhMBlSe3Zk3mpex9v2oADnT8mPlJXDGuskA==
X-Received: by 2002:a63:4719:0:b0:42c:5586:de2 with SMTP id u25-20020a634719000000b0042c55860de2mr8612184pga.158.1662651406849;
        Thu, 08 Sep 2022 08:36:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ms9-20020a17090b234900b002006428f01esm1914152pjb.55.2022.09.08.08.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:36:46 -0700 (PDT)
Date:   Thu, 8 Sep 2022 15:36:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com
Subject: Re: [PATCH v3 0/7] KVM: x86: never write to memory from
 kvm_vcpu_check_block
Message-ID: <YxoMCp+rMV1ZmRlU@google.com>
References: <20220822170659.2527086-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822170659.2527086-1-pbonzini@redhat.com>
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

On Mon, Aug 22, 2022, Paolo Bonzini wrote:
> The following backtrace:
> Paolo Bonzini (6):
>   KVM: x86: check validity of argument to KVM_SET_MP_STATE

Skipping this one since it's already in 6.0 and AFAICT isn't strictly necessary
for the rest of the series (shouldn't matter anyways?).

>   KVM: x86: make vendor code check for all nested events
>   KVM: x86: lapic does not have to process INIT if it is blocked
>   KVM: x86: never write to memory from kvm_vcpu_check_block
>   KVM: mips, x86: do not rely on KVM_REQ_UNHALT
>   KVM: remove KVM_REQ_UNHALT
> 
> Sean Christopherson (1):
>   KVM: nVMX: Make an event request when pending an MTF nested VM-Exit

Pushed to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

with a cosmetic cleanup to kvm_apic_has_events() and the MTF migration fix squashed
in.
