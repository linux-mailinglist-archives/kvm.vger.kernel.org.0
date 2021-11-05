Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368F7445D56
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 02:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhKEBgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 21:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhKEBgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 21:36:49 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F222FC061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 18:34:10 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id a10so4999302ljk.13
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 18:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WmJtXBkg7pd+AkHNmF/OOE0ZCZ7A0DUPGQ3AraUyTKE=;
        b=PZE9AjSPOY3ehFs177/vcSypOeEzbZbOjJTIP6cW52S5WQTctkopZtXJ8ZzGpp4Ftk
         X7/NIPtm/J/5VDoXx/Rk8S8UZL1YO1x3EzWDIGTtxRfd4KPeefDpEsG1u8daXYp9AqG+
         ERm34LdXlTc1oMG4MjN/+ZedoSmn6HMU7WNncJ0a8GhiBg++YuGmkY7sgeVTR00j4RQ0
         O6F1zstzgn2wLez4WTmwyygFlygy6VJXxNUKxBD5N1w99YYS1i9l6C4f3/9/BZXVXFJQ
         TBdoEpu2mzZovHHUC9PY1QP0DRbm7upXKQkmiBMSgs9gUyFpby5JJ0PbegWFoAG8mCC9
         tFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WmJtXBkg7pd+AkHNmF/OOE0ZCZ7A0DUPGQ3AraUyTKE=;
        b=hb8vHD/zVr6Yqo2znBd0THkVp1esksJ/sRiOMi8i9JVZcKyabvdoFrl75pqmlrNH+Z
         IpuM/5JgdHsY0BIAMo0pWBCKDZczBeQLkcaPZgzoXQ5/BO/2hHggswsZ8SOkclZ6ldZh
         VmUfJfwXSIzjSNtmGx8PqdTKGlTdDJp3bzN0IAYJkPLZKvr9NKz893w7cwCDOuY3SIZF
         Ak+H1Fr/HWaUJoe2FOpJXwNkY9+LyCEhow9wubrcCL1VQi6x9IIquPJSWKKMb20hQHvt
         jpvgpTfuZsDlEKdwll/L8vVbFsngdXMS0CIth/YsXLhx56nKOKqoRvd3vV0WAtyyQgnX
         BNmw==
X-Gm-Message-State: AOAM533LG6K6YFbxFX66otWqjgsb7hyVewxIKNv+/rhOixfMNCfud71D
        h3XiyNJf8XbdvIki0I4OeuabSajD83FUaQNzqbbqjQ==
X-Google-Smtp-Source: ABdhPJyewwZhYvIK3ydA+zOEsxVMwLZ6je5RssWrC6icEv9NcYFD1E5ThOQun0PMv8mV+NBDOBTesnHzih36VdxT/oQ=
X-Received: by 2002:a05:651c:984:: with SMTP id b4mr8397659ljq.170.1636076049067;
 Thu, 04 Nov 2021 18:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com> <20211103062520.1445832-3-reijiw@google.com>
 <YYQG6fxRVEsJ9w2d@google.com> <CAAeT=FzTxpmnGJ4a=eGiE1xxvbQR2HqrtRA3vymwdJobN99eQA@mail.gmail.com>
In-Reply-To: <CAAeT=FzTxpmnGJ4a=eGiE1xxvbQR2HqrtRA3vymwdJobN99eQA@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 4 Nov 2021 18:33:58 -0700
Message-ID: <CAOQ_QsjNDct2C8mrz4aezEu4hPU6RH8_1vLMq=RjngABu0qVjA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/28] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 4, 2021 at 2:39 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Oliver,
>
> On Thu, Nov 4, 2021 at 9:14 AM Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Tue, Nov 02, 2021 at 11:24:54PM -0700, Reiji Watanabe wrote:
> > > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > > registers' sanitized value in the array for the vCPU at the first
> > > vCPU reset. Use the saved ones when ID registers are read by
> > > userspace (via KVM_GET_ONE_REG) or the guest.
> >
> > Based on my understanding of the series, it appears that we require the
> > CPU identity to be the same amongst all vCPUs in a VM. Is there any
> > value in keeping a single copy in kvm_arch?
>
> Yes, that's a good point.
> It reminded me that the idea bothered me after we discussed a similar
> case about your counter offset patches, but I didn't seriously
> consider that.

Yeah, it was a good suggestion for the counter offsetting series, and
one that I plan to adopt once I get back to that set :)

--
Thanks,
Oliver
