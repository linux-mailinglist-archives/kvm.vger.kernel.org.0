Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2145F168C
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiI3XOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiI3XOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:14:41 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7B210F
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:14:33 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-131b7bb5077so7125701fac.2
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Rih4dRLQPmoXFQqvyiybCfnV+B844XEcFs6s2kNsPVk=;
        b=XmA/gs+sA/OBMvOaY1K4gSKEC0sImTCgESP0NGa75a9etT2rE90olSdo5X6eLk84ng
         l3mYbWSrXtaRxXgu0ylM8SpIPXPXs/ehOUPEUqH1cke0nywkLuF8G2X7uibz4+f+l8SM
         X5d7ai5Z0A1JtOs+tAzYMsseqaUDvymJTfH/ThsMxTpbqtURPzN770llZpXUua8K7+5m
         jKHn2P5H6NFx4hynN89Rh3yooFxWL67H7Sgej2TVPMuTgi6mmzpcXcfYKIoNwMCno0VB
         ZGsLG+9VdWftHCe3rBhjTLvxwxtawaSkMGTDjARP5X6JFA2jjz/x9eaK2OqrkRsdJ/Ji
         ZF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rih4dRLQPmoXFQqvyiybCfnV+B844XEcFs6s2kNsPVk=;
        b=y5xAotn5pABX6QeDv+Y3XvaIcBekPsKFfDb2MlI7M6h+mHu/BXJ6+lx1DZuH7x4yHi
         NabL9dZbA0OmM83VWwrl43DN8idFsxhWl5DxuGtyWQ+WAbFpO9z+9ESJFAgIcho62gy5
         doi0CYkUelu1VQm1vafW8cbQGz7E53bVWv9zeGkSArWm43mJ3KiKsH7v14mWoDvPXTj1
         g8E23qwYdFxHTtlbj+v26P44ydU3RXUZpcxbxJVXsukf99rTZN9nIG9O4ve/L8UYcMuE
         iZuykc+YRkA5+f4r+wDXHmMNuYtDg6nmMI+97sUpTnwV1oqPAa2ftrf29ZKz1NqehEO5
         tjyQ==
X-Gm-Message-State: ACrzQf1Blcn8QCXXK+TmQt+7XsAOwcNZQ+M9lMO4dybwxW8NjvvSSyrz
        Dd0n7/Uf9AnDzXkKNbrxLd75RErbLv9LLLQk679JLA==
X-Google-Smtp-Source: AMsMyM7TLtHMmHkk2px3a/xAJQAH6olcUCSihaMUrjxU9AjdCSOUZ4JUNelqQQ6/tFR/DK8VLNho+hQAuiiWzkYg3x0=
X-Received: by 2002:a05:6870:580c:b0:12a:f136:a8f5 with SMTP id
 r12-20020a056870580c00b0012af136a8f5mr222960oap.269.1664579672876; Fri, 30
 Sep 2022 16:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220929225203.2234702-1-jmattson@google.com> <BL0PR11MB30425351024AC155FFC377268A569@BL0PR11MB3042.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB30425351024AC155FFC377268A569@BL0PR11MB3042.namprd11.prod.outlook.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 30 Sep 2022 16:14:22 -0700
Message-ID: <CALMp9eS=gDJH9j7oDsWoHDV8uc5pSxUCVtRz6T7yUwmbgU3c6w@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: x86: Mask off reserved bits in CPUID.80000001H
To:     "Dong, Eddie" <eddie.dong@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Sep 30, 2022 at 2:04 PM Dong, Eddie <eddie.dong@intel.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Jim Mattson <jmattson@google.com>
> > Sent: Thursday, September 29, 2022 3:52 PM
> > To: kvm@vger.kernel.org; pbonzini@redhat.com; Christopherson,, Sean
> > <seanjc@google.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Subject: [PATCH 1/6] KVM: x86: Mask off reserved bits in CPUID.80000001H
> >
> > KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
> > actually supports. CPUID.80000001:EBX[27:16] are reserved bits and should
> > be masked off.
> >
> > Fixes: 0771671749b5 ("KVM: Enhance guest cpuid management")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c index
> > 4c1c2c06e96b..ea4e213bcbfb 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1119,6 +1119,7 @@ static inline int __do_cpuid_func(struct
> > kvm_cpuid_array *array, u32 function)
> >                       entry->eax = max(entry->eax, 0x80000021);
> >               break;
> >       case 0x80000001:
> > +             entry->ebx &= ~GENMASK(27, 16);
>
> ebx of leaf 0x80000001 is reserved, at least from SDM of Intel processor. Do I miss something?

This is an AMD defined leaf, so the APM is authoritative.

> >               cpuid_entry_override(entry, CPUID_8000_0001_EDX);
> >               cpuid_entry_override(entry, CPUID_8000_0001_ECX);
> >               break;
> > --
> > 2.38.0.rc1.362.ged0d419d3c-goog
>
