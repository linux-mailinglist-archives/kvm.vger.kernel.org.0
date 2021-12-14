Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5599474993
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 18:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbhLNRg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 12:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235559AbhLNRg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 12:36:26 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A8EC06173E
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:36:25 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y7so14143105plp.0
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8qfoCk9NYj36wSO78chHeHprCwWDcDj2DQwomY20Cuc=;
        b=OUZQ8DCHjP9TRW8CJm+8LSgPbnAxZlVxs4OzE40QKhFaYd2m7JZEn+vySxLM0pB3pX
         Gr8+TxFGWRg4W9UQMIh2Jbe7wm7b+SSyDou3BBhjhTI4AEy8hWAd83ri8jlQ7SBhyfZD
         xlFNBekQNhOZtE62lEBj6v3PWDZ/jfAnYzaW72F9JuI/51oT1G/N2Yt/vGLJLjf8qCzE
         lf6nyfzhhSqy7H3VAGjwDma+i9bTJ+ZSpEtgqGt+u2cWi8hvc/3Piy4pG+p8RsbzvdaT
         7VpNg20B0AwbsvgVnqRfkk6/WBLpkQK/LU8ft30oYEyHUaj5U+3n+mIagSlvuturhVf/
         DyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8qfoCk9NYj36wSO78chHeHprCwWDcDj2DQwomY20Cuc=;
        b=6tA6QQ6uHbCdL31iCG8RisDnBjiWUMPiNyhfQij7PxroWWWVMLvnBa03yZ+eYI8hb7
         gI0pkvzfAwps8mtr65f5ssHXM9F33wtvz3JhkW9Q4LFo2aoyDHgRrKAiUHMZ1cJ8/djG
         3CYyIo9QnIqbP3VpCpQyGG68Kx2iGyMdQ1jznSBhruWfCKpGSDJv8vWYeBlC3oD7+X+Q
         DqEoc+Y05giyyeonz99dMnIWxqjqc01k+04Hww5fby6wXRNTi0lNFylI338b/PNSD0Ri
         GuZeGcOiqz1iYhCKIF2RCPDnxInyVoCUgqj/+Dr0MBnPWHMCfp+/a8SMnsIwfIQFfEy+
         cyNA==
X-Gm-Message-State: AOAM5320ZaWQJwzoFWPXBO73C3+Z7f5tFQv6apBQsXPPX4KHNO8kmJqU
        NQ5UHISqPdaADKqHCOvoMY6g5Q==
X-Google-Smtp-Source: ABdhPJybrbbAKyROLXuOjybmV0nvQSHW/baM2Y1cBztL8vk2eAGw9GH1zzra5MJK4rFe86GdrgSg+w==
X-Received: by 2002:a17:903:283:b0:142:1243:d879 with SMTP id j3-20020a170903028300b001421243d879mr6960928plr.61.1639503385324;
        Tue, 14 Dec 2021 09:36:25 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z8sm325250pgc.53.2021.12.14.09.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 09:36:24 -0800 (PST)
Date:   Tue, 14 Dec 2021 17:36:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: The vcpu won't be wakened for a long time
Message-ID: <YbjWFTtNo9Ap7kDp@google.com>
References: <73d46f3cc46a499c8e39fdf704b2deaf@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73d46f3cc46a499c8e39fdf704b2deaf@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14, 2021, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
> Hi guys,
> 
> We find a problem in kvm_vcpu_block().
> 
> The testcase is:
>  - VM configured with 1 vcpu and 1 VF (using vfio-pci passthrough)
>  - the vfio interrupt and the vcpu are bound to the same pcpu
>  - using remapped mode IRTE, NOT posted mode

What exactly is configured to force remapped mode?

> The bug was triggered when the vcpu executed HLT instruction:
> 
> kvm_vcpu_block:
>     prepare_to_rcuwait(&vcpu->wait);
>     for (;;) {
>         set_current_state(TASK_INTERRUPTIBLE);
> 
>         if (kvm_vcpu_check_block(vcpu) < 0)
>             break;
> 					<------------ (*)
>         waited = true;
>         schedule();
>     }
>     finish_rcuwait(&vcpu->wait);
> 
> The vcpu will go to sleep even if an interrupt from the VF is fired at (*) and
> the PIR and ON bit will be set ( in vmx_deliver_posted_interrupt ), so the vcpu
> won't be wakened by subsequent interrupts.
> 
> Any suggestions ? Thanks.

What kernel version?  There have been a variety of fixes/changes in the area in
recent kernels.
