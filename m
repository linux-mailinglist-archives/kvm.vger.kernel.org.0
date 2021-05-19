Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BF23886EB
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244588AbhESFrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349024AbhESFrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:47:01 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8374C061761
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:45:41 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso1115565pjb.0
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YX6bVogG7OVOPNM1yvwbjKO/m+OQLr7iv04qm+yLWgk=;
        b=qlBlhCYZ4jdvxAcFL4MFjLwB9Mr54MsVnnFEjADnPiNBOwQUrSJtPPRJInz72qIUD8
         09Xk+BS39Pw/LEB3HpuOPCD6uCaYNWIXPcOYeFGaRrPltssi0Bg2E5j1yTzRTyZpXDLV
         zDa6yg98Ych9jTAkdj33Mb1wdw4A1KagrOzIPGQJdcPn9pLf6Y77p/QV8CAlMnXwHVUe
         KqmaWsLgjnhuIE3/LHs2P0XAdtnj8MxdhEPSQDC7c1cGXJkxj46bWb8UFkch1wAU0+3s
         0nDL31uoeob59ZTqPqr7GIKWjPtX2voUMjBMcvyWwORcISYjO9rRSGbfh/lTOaMyJOXl
         f6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YX6bVogG7OVOPNM1yvwbjKO/m+OQLr7iv04qm+yLWgk=;
        b=PczQJeDfKWIrEBjdkR3HKJcb8Khq23LAVtgex19BkMnFzG1NHbAvNb+10sv6T5aaRE
         8n+9nEBUymlIxv7tjYLkI5Pl2rDMTxWQtTc2f2OT78L9hf1d3K3pUB8Ni1HcgqYcxog1
         dr+leryrj9hcEvZWCffRtLHeHwOkIID7FY36RyZsjeNkJIov2zIW5TpMRgwVEogt7RUh
         GTiqQDKRMNPk/GzQ/6bAQy25Rmvbvch3eG3+f2ivyY7CJ6uykYO8UyDYxipvPp8IsLsD
         E/Zwb19HTM/lUrzI4mApGxutG3UVCb2Y2Cg/uHs0vVusHqHftQl1KQDWLfkHHsptCDVK
         PYww==
X-Gm-Message-State: AOAM531PhwjN2pMQvO5nbh7jKbXbt376/Q49huZMa3Tyk/BqL1EIb1Ja
        xc4d0BWHWmP8Fsb4In4kFR1C/9dJ40lyjKAqHkMx2A==
X-Google-Smtp-Source: ABdhPJzFjlL3ldo/YTrnNY5oN/5DBrDGqVKohxRHJO2DbVshHNB6qfBiCQwKAgVDsFk8W1xhnfmVeBIw+jSWb7IZCkA=
X-Received: by 2002:a17:902:f20c:b029:f0:af3d:c5d8 with SMTP id
 m12-20020a170902f20cb02900f0af3dc5d8mr8801350plc.23.1621403141274; Tue, 18
 May 2021 22:45:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-20-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-20-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 May 2021 22:45:25 -0700
Message-ID: <CAAeT=FzuLL5JMW2orGWDfdZ1oLN0Bm+-scnYwEysVd_WCkibYA@mail.gmail.com>
Subject: Re: [PATCH 19/43] KVM: x86: Move EDX initialization at vCPU RESET to
 common code
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

On Fri, Apr 23, 2021 at 5:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Move the EDX initialization at vCPU RESET, which is now identical between
> VMX and SVM, into common code.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

All of those refactorings look great to me.

Thanks,
Reiji
