Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF6B4C4D50
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 19:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbiBYSHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 13:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiBYSHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 13:07:33 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6E11E6EA8
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:07:00 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id w10-20020a4ae08a000000b0031bdf7a6d76so7194091oos.10
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NN5kUdin7citIfmsQk9dU1OmhSvd2Lzcs2UPLOuI96I=;
        b=mZgUDHNQER4VN5jp1nQ+UOooKupVC14mE+ybXlq0GFuOTKAKgCScsKJvcQGhwYht6g
         ADtrQysZaUbKJJ19rzSH/wl68dYebZWMjQTOFut1JcRerkMYl2ihS4ByNHAaHjex7h4v
         +IhzLX/hd9wmJHdvKqey5LNtKgCQoF4vaz6XAk7nhicCmbXxzgZ2ZbbLl8MG59+1pfVs
         6gpsx9/RUKSpG+C5CCV9SXXLkZhsXy1EgDOSuy8QxQNoHl0v9hoL0oaoJdlEQCzTYmhy
         LUw0C5WFNUJDoSMnPZ74J9aVuDcw8GwlubVOHrsohk+dOgGnfsDvQdyFWdNvzCbUbPX8
         Ce2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NN5kUdin7citIfmsQk9dU1OmhSvd2Lzcs2UPLOuI96I=;
        b=fDIgBBUdUD7yKp3SqAR1y7hbuc/ReL1qUzOYOhgby0aGnDi9lCZ2RxgZbVul+lrkyZ
         ACHCV14L8HVTOF9rs75tj/oscjlHYNmZIMmB9akMaWXrGWEsoxH/UQEtzH1erG4I3Myo
         gl0VzTufX1vGc9vFcumxSS5u11UZLoGXE9EVxeGu+i5jXoBDdJl1RO1/ZVzYFWhIJ5XY
         l+n05Z3smzywZBDX9PTro/+X4k++n4Z9V2eDBu0jAfimiLOoMPCEXsU0ss6JzzUuYG9w
         H8QOhikMm237Qne4NKlLOs9vWbV4aaloEfaekocVT3cUa4xMWHave3obl/FRRFCD5CMK
         siWw==
X-Gm-Message-State: AOAM533+TO85xIj/TWGdSeL6NsuOgHRvKBiYA9dz/5s5YqLvAAjHb7aM
        bboiOWtfqhAMbWvguRpZRb+oVI/q7NQG87Tt0VYfcQ==
X-Google-Smtp-Source: ABdhPJwpr/Ifbo68q2+J4j/DBvPxK7bgpP1DW9yuyBh1wSi+UvI2AhGyYgCTxCmjYyEQl3QZtsML4iCA3H8W1zG2M3M=
X-Received: by 2002:a05:6870:6490:b0:d6:d161:6dbb with SMTP id
 cz16-20020a056870649000b000d6d1616dbbmr1808297oab.129.1645812419250; Fri, 25
 Feb 2022 10:06:59 -0800 (PST)
MIME-Version: 1.0
References: <20220223062412.22334-1-chenyi.qiang@intel.com>
 <CALMp9eT50LjXYSwfWENjmfg=XxT4Bx3RzOYubKty8kr_APXCEw@mail.gmail.com>
 <88eb9a9a-fbe3-8e2c-02bd-4bdfc855b67f@intel.com> <6a839b88-392d-886d-836d-ca04cf700dce@intel.com>
 <7859e03f-10fa-dbc2-ed3c-5c09e62f9016@redhat.com>
In-Reply-To: <7859e03f-10fa-dbc2-ed3c-5c09e62f9016@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 25 Feb 2022 10:06:48 -0800
Message-ID: <CALMp9eQHKn=ApthER084vKGiQCMdVX7ztB5iLupBPdUY59WV_A@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: VMX: Enable Notify VM exit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Feb 25, 2022 at 7:13 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 2/25/22 16:12, Xiaoyao Li wrote:
> >>>>
> >>>
> >>> I don't like the idea of making things up without notifying userspace
> >>> that this is fictional. How is my customer running nested VMs supposed
> >>> to know that L2 didn't actually shutdown, but L0 killed it because the
> >>> notify window was exceeded? If this information isn't reported to
> >>> userspace, I have no way of getting the information to the customer.
> >>
> >> Then, maybe a dedicated software define VM exit for it instead of
> >> reusing triple fault?
> >>
> >
> > Second thought, we can even just return Notify VM exit to L1 to tell L2
> > causes Notify VM exit, even thought Notify VM exit is not exposed to L1.
>
> That might cause NULL pointer dereferences or other nasty occurrences.

Could we synthesize a machine check? I haven't looked in detail at the
MCE MSRs, but surely there must be room in there for Intel to reserve
some encodings for synthesized machine checks.
