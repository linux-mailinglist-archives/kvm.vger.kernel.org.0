Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7968B5987C9
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 17:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343884AbiHRPtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 11:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245445AbiHRPtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 11:49:10 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCE53DF0E
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:49:09 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id z187so1882512pfb.12
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=LQ6UTD1yLdKaL5goe/L0O22+iQnu8B1xU3ILfSRgLVU=;
        b=ORK33PPK2YMP/eBCehAb42fbmv5vTU6yt8havKC23HmQcG+OAYh2OiafQyDYwhdM5g
         k7kJX39oN9vTjbU8tWzRW9r7cXrZ7vjJWDGv5FvQXuZJdW/njaY7dsYEcCNXWT9z+9J9
         BO4s+IXcrRw3pFWg1EUTjXc3kYHYNPrryjlXrjOT198NuKz/0BUyRkBSF9J9L18EQ7Nn
         u9oEP4D5LtIFV7fULPfc7P+5Qwi2LLVYeOy3kYgvuNBaXaTSYPL7yEUuU2QVxAOXrzjo
         b95RdyszkjZVtAErs8b5myNT8P4sgRJbkCihDweoeUm7sEt6vHxaG1/gN20Fx/NiOSBa
         JKmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=LQ6UTD1yLdKaL5goe/L0O22+iQnu8B1xU3ILfSRgLVU=;
        b=59U/y6TwTD1l97t1TgKMJGdcVDdCLZpgwo7K4MZCBZ80wD1E4R+KjP6xPjLnuxzbhw
         ZtqZwwekWveasV3KXC0ZkOIbNagITXwDSlgDaxsFG6Xuz6n7F1OnqMkHlPSP0AfDgidu
         7frxjR9gNIa2WG6caI5GQZS8sWN3FZDsZUYwOUd+ANYcA0Ur1rAhqstNOvc25oMK1ogM
         /N2t+H9Jb8khYdrzSJVJq4xsRKqTf9nsIzMtaQCc/zAZA0xvDA9DksosdEx+zn0Z3Y0w
         /tzI9e1qtrT2fz8OLs7JXXSReh07ceZ+x7galhatSC+1FiymrIFM35JXhxthbdMD4hsR
         bptw==
X-Gm-Message-State: ACgBeo2zt9DE20M6gSXMyy3T6Myr9NaJJmQ1b37wYcqq62USF6MfDMld
        5NDZetEyt5pl0kSEl27gkG8Mng==
X-Google-Smtp-Source: AA6agR6E4897lIuYKGsSz0ut9vsvJlkvFxFYvtJrCtNMpXYg1SBoAvrzoosw4V61otC455Hi5rzF3A==
X-Received: by 2002:a63:2008:0:b0:41d:7ab5:ca31 with SMTP id g8-20020a632008000000b0041d7ab5ca31mr2837101pgg.17.1660837748592;
        Thu, 18 Aug 2022 08:49:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z16-20020aa79590000000b0052d8405bcd2sm1786323pfj.163.2022.08.18.08.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 08:49:08 -0700 (PDT)
Date:   Thu, 18 Aug 2022 15:49:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/26] KVM: x86: hyper-v: Expose access to debug MSRs
 in the partition privilege flags
Message-ID: <Yv5fcKOEVAlAh0px@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-2-vkuznets@redhat.com>
 <Yv5XPnSRwKduznWI@google.com>
 <878rnltw7b.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rnltw7b.fsf@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 18, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
> >> For some features, Hyper-V spec defines two separate CPUID bits: one
> >> listing whether the feature is supported or not and another one showing
> >> whether guest partition was granted access to the feature ("partition
> >> privilege mask"). 'Debug MSRs available' is one of such features. Add
> >> the missing 'access' bit.
> >> 
> >> Note: hv_check_msr_access() deliberately keeps checking
> >> HV_FEATURE_DEBUG_MSRS_AVAILABLE bit instead of the new HV_ACCESS_DEBUG_MSRS
> >> to not break existing VMMs (QEMU) which only expose one bit. Normally, VMMs
> >> should set either both these bits or none.
> >
> > This is not the right approach long term.  If KVM absolutely cannot unconditionally
> > switch to checking HV_ACCESS_DEBUG_MSRS because it would break QEMU users, then we
> > should add a quirk, but sweeping the whole thing under the rug is wrong.
> >
> 
> First, this patch is kind of unrelated to the series so in case it's the
> only thing which blocks it from being merged -- let's just pull it out
> and discuss separately.

Regarding the series, are there any true dependencies between the eVMCS patches
(1 - 11) and the VMCS sanitization rework (12 - 26)?  I.e. can the VMCS rework
be queued ahead of the eVMCS v1 support?
