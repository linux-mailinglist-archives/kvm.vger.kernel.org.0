Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CEB38868F
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240828AbhESFe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237598AbhESFeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:34:50 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B80AC0613CE
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:32:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ep16-20020a17090ae650b029015d00f578a8so2822844pjb.2
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UhLf+eMTqvgVmDy1JnhP0/EYBvns5BKG0ZaFzBFNEck=;
        b=i2Y5024Ku0UYqibr3fbtLbTgkYGj63aqutNzgHEugRfo4iK30nrXYchV4fEuL/+s0l
         1q/Ns3ADPIF79+7O1lzlCqR2g1HoSon6U5z93DG7IZzWIGo7I0qlbp0kcVaYNAQSxrJF
         rqBSGDs/LcM6mg53ob75K6XRJdHXUeFNzmPqkOZrqE1WyU02o19LsMg7dPMq0mvXh5j0
         hWqKnLFUIrCyMqOZuXUotkm3lXIgOg43V0iUgYMPIIve+vw4aVvG90VZeTlC/0LGjAdq
         E1OyV6OLJFh3HYTYB6EJW9G+boXopMKDV5n2qsvl3JhDfdBTxde6NsCp5B2Pi23eK7DU
         yFCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UhLf+eMTqvgVmDy1JnhP0/EYBvns5BKG0ZaFzBFNEck=;
        b=m97NQEykgb5RxCp63w6uoDlExLj2XbcfjoscBJeqe2UKwZly//gifWjh55Wia+f9lP
         yCQ4g//eDIkK1BbdFYMYoi8ta16UCv+YHKqvG+3O45mt7Aa8Uqqp47r4+tLSnBzaNpyH
         QD7puzPuIAFuWvQ0NXPK3IvCT5DDAfCZIIBVQteTOzzuXweoNcKUtRdt3wc53owANYjU
         Achei4TJ27Y7prfxb765c6UGrsA90UVY3bkrzADStMcrek2APYkljhi0ECGD32FX3VJm
         WCxIgH/wRvL3Dsp2WStFNb/EtQoK55d9DZqZJnlgIv2WOCD2EIn1oSGybFdW2iSLNxFy
         xguA==
X-Gm-Message-State: AOAM532KAvOQ/875qkSlFOfZ8CcI7C56J+9KQqcq0TFQn2RqsVISfOU5
        tOeHmwE3jOhtxDIExn2P9cRDDLcvkS1YB4CER23h+g==
X-Google-Smtp-Source: ABdhPJyHf8aBcSGEAC466lj43/rFw+b51DrLrBcTKoV9XmrepGyYrUWRjJsBoUEkzRpOzt2TaY4g1J0q2qtUR95WCXU=
X-Received: by 2002:a17:902:b487:b029:ee:d04b:741e with SMTP id
 y7-20020a170902b487b02900eed04b741emr8755124plr.45.1621402367014; Tue, 18 May
 2021 22:32:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-9-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-9-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 May 2021 22:32:31 -0700
Message-ID: <CAAeT=FzE9BREDyK2C3LWdGxArucCi8jF24OLTsL4QrYz0p57Yg@mail.gmail.com>
Subject: Re: [PATCH 08/43] KVM: SVM: Drop explicit MMU reset at RESET/INIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 5:48 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop an explicit MMU reset in SVM's vCPU RESET/INIT flow now that the
> common x86 path correctly handles conditional MMU resets, e.g. if INIT
> arrives while the vCPU is in 64-bit mode.
>
> This reverts commit ebae871a509d ("kvm: svm: reset mmu on VCPU reset").
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
