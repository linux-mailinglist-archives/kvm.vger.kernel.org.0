Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9DB534C5E
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 11:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344653AbiEZJP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 05:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235707AbiEZJPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 05:15:25 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63785C6E4F;
        Thu, 26 May 2022 02:15:24 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2ff90e0937aso8950437b3.4;
        Thu, 26 May 2022 02:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nuQuuCBVbrPqmTSYx6tUR7yIqqFNAWXTE4+uB81J2UE=;
        b=fq/Q21s/iUO8ofTLAKo+TyWwAM0uPaQWr2DmHRxlMTOo6FtN9wf+Rgww1VeueHQhMp
         5vfaZJlEkoEvcjBxpyR+U5SljFerjhyPOi3RIOuOjHsP5M7Im5QP+UMEkjzrzRD5eC3k
         xiNYXeTXoJj8dm0AK1rW4jyOTBINck/t08WOeDuOI6g16GuVMZM3YWMNb+C2IbyiXDtF
         RYb8LSgkpVczXfQ1KJRGRAJDo2Q/CGgqBVVhxShFzChmEycFNeYfWmsq1lOIhRTsxmUy
         F5EMwGnP67ppXHDB+tt2lGAHI26HuKQQ3NHCMSyRNsC+QKrawpLc+nN8OF0FC5i+fY12
         pNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nuQuuCBVbrPqmTSYx6tUR7yIqqFNAWXTE4+uB81J2UE=;
        b=q5M3FQd/DyOpremlwlsZcrmxSf+qAKhiD78b9tvtmfLgYnqogQE25Qcf538BhRx8gn
         qScR8d6J8TRC2GmCZk1YXM5GPns+OmvaHq+2XWgqHT2Oc7k9nBfXvkhib2C5F/aNUVSL
         wvf2gmGjWYWzVF/6Ab2D2eIHVdqW7viUpDlAzA7omemPusT02TDSezEkV4IGEYJq70k0
         yVmycuLNH3TVdJ8m1E7WSKr6HFI6VUZDCh3OhN820NmAB/Tx49BX3F79RGCHC5m3oMO0
         Pk5iVC//0gKPa2V7WktWop/XEk5ttjK6iFh73rbrReqLE+4s8kZ3Kuz90+wpjNpxzNcJ
         rc9g==
X-Gm-Message-State: AOAM533+OlskOYISSN0fDvmtY27zYgUqZaKjGBdFGC2Ik4dx/i8R/B0C
        JqClINqmlkUyFMfh5oz/aWt0zyeB0k9FK4106rw=
X-Google-Smtp-Source: ABdhPJxTnuH6PXmLiJgLino0nmQUgEEUbKVZvCISw8inI/dpudyfKqigg2++US8rXs4cLnhTnHbCCfxrKCum5WliGHU=
X-Received: by 2002:a0d:f743:0:b0:2fe:e466:a482 with SMTP id
 h64-20020a0df743000000b002fee466a482mr38540814ywf.151.1653556523683; Thu, 26
 May 2022 02:15:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-5-jiangshanlai@gmail.com> <YoLpY9MFxNTBidqB@google.com>
In-Reply-To: <YoLpY9MFxNTBidqB@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 26 May 2022 17:15:12 +0800
Message-ID: <CAJhGHyDS0NXmcW99rtvxp3YTGFcD_eOxRs+_3caUN6ki6z1BuA@mail.gmail.com>
Subject: Re: [PATCH V2 4/7] KVM: X86/MMU: Activate special shadow pages and
 remove old logic
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 8:16 AM David Matlack <dmatlack@google.com> wrote:

>
> This comment does not explain why FNAME(fetch) might pass these values
> to allocate special shadow pages. How about adjust it to something like
> this:
>
>   /*
>    * Initialize the guest walker with default values.  These values will
>    * be used in cases where KVM shadows a guest page table structure
>    * with more levels than what the guest. For example, KVM shadows
>    * 2-level non-PAE guests with 3-level PAE paging.
>    *
>    * Note, the gfn is technically ignored for these special shadow
>    * pages, but it's more consistent to always pass 0 to
>    * kvm_mmu_get_page().
>    */

The comment is copied into V3 with slightly changed.

>
> > +     for (i = 2; i < PT_MAX_FULL_LEVELS; i++) {
>
> s/2/PT32_ROOT_LEVEL/
>

Did in v3

Thanks
Lai
