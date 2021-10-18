Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0550F432A8A
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 01:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhJRX46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 19:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJRX46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 19:56:58 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E48C06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 16:54:46 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y7so16029836pfg.8
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 16:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ynOhmjUOkwSpnrJ88zMEmxNB0eI9c/2L1iHrpBkEpk4=;
        b=EFOaBD2lQnyqIAAG5lrCqU/8zu6qACMCiE/0CRBR75mPq/VJ6w6L8PDbEje9d0OiaJ
         5eFaONYYZuOumyI17zC4o/vaZRO8CjnVUYDishxFaY6QkQVZDEZKaPF4TfWTBEQQ2bZn
         nIHOqtbKge9kX9oRaTxIs5lD1nsPmp3dlb+5vQxOA00ewEMo3WgiF3MVdQ2E5CEV+Jem
         mkZOcvGaZ1UHqdF+6hvJIiM4mBZDZBNWf9PxZ5clWM2kplQwTSaA87Z5+H13SX/2aGFn
         6QkehEXNPY3Kf07patc7zcFiBrweGIjWJwpXKYeQxGjWkE4SWH6Gd2wXEN2x6YReAs6M
         fLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ynOhmjUOkwSpnrJ88zMEmxNB0eI9c/2L1iHrpBkEpk4=;
        b=RyVGVKFWNOG0Z0zsc9qql3Ua3C3w4XWu2dY7x4pRTF7poNH8cYjrXPkeqKJqW5Wvea
         oPwHVwsumQIN8sF2xScDbxDq7IfjCXI9DIUBteFzu2BOFFutg3cKFDu3RlDC5b6JTEIE
         8Mf5xQvsYhRcsZI2M8gjrYrFId25Skpcsk6zm6sGJboK6vj9xjz0PJbyNGBzmJbOChiG
         9px7HoUHnH+qnWCsNhBzcUScntkLT+HMyrYMRvieQF/oNRc3GzM5dzOMQVB8K7t7IjgY
         XaUfN3VdOmhDCLLZOAl5CVBAgjFR9t8yA2nzU0yOCMKNC20Csq7vD3ot8JqIeabN80YL
         ZBdQ==
X-Gm-Message-State: AOAM5334NrKSCJJeKOY57YVL6Q3+yHYBxYxsN/C6yq64MycYpUZUJxpc
        3sExqcySMuph43i5Cb/ZosTjnSoQuMmR0gpBIuLPog==
X-Google-Smtp-Source: ABdhPJzVbYDhkj/gRXc6UEHpqQBV4tybyVWFXS4+PBSGTI/Gq/Fn+h+wfokG4GSqJyDfn5rly0rCn5FHhXPB3vizLTc=
X-Received: by 2002:a63:d806:: with SMTP id b6mr26403649pgh.395.1634601285698;
 Mon, 18 Oct 2021 16:54:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com> <20211012043535.500493-3-reijiw@google.com>
 <20211015130918.ezlygga73doepbw6@gator> <CAAeT=Fx9zUet2HvFe8dwhXjyozuggn+qcQBoyb_8hUGJNKFNTQ@mail.gmail.com>
 <20211018143040.nhkv67cxni6ind6k@gator.home>
In-Reply-To: <20211018143040.nhkv67cxni6ind6k@gator.home>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 18 Oct 2021 16:54:29 -0700
Message-ID: <CAAeT=FzK1dNaJvR9u98-M63pPdeou=KfKoxHE+WN0cadeQUKHw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/25] KVM: arm64: Save ID registers' sanitized value
 per vCPU
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> > >
> > > Since not all ID registers will use this, then maybe name it
> > > reset_sanitised_id_reg?
> >
> > Thank you for the suggestion.
> >
> > I named it 'reset_id_reg' according to the naming conventions of
> > set_id_reg, get_id_reg, and access_id_reg which are used for the same
> > set of ID registers (ID_SANITISED ones) as reset_id_reg.
> > I would think it's better to use consistent names for all of them.
> > So, I am a bit reluctant to change only the name of reset_id_reg.
> >
> > What do you think about the names of those other three functions ?
>
> I think I like the shorter names, so please disregard my suggestion.

Thank you for the confirmation. I will keep those names as they are.

Regards,
Reiji
