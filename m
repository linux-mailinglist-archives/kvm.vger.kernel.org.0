Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8866C1C5EB7
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 19:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgEERX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 13:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEERX6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 13:23:58 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2A8C061A0F
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 10:23:58 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k1so3715438wrx.4
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 10:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NP9OIn8aZdjTBigvGWGYSxvnTPBy4fLFwfAKc1uTAGA=;
        b=EkW9V00OjSI1/ZNXcCO2ShjrxSwU48K+ycq1QjcEjdt3BdAlSmprqkST87DvkZHvW6
         ZST12Yx3Rb0hndsh0l00CBau1Cf/oUxPDSegLM2wOvjW1oZ3mmLe0HrIFVwsaRMHLtrL
         y3EQDmTJY3lxI8pEKjhAA6jzzy6MwcCmS+GPtwseWuLaLEnXfYr7xFTByvjD01hW8yUn
         S12b0kRAP1CFSiKlwbTKv522AqxGPAVXHH8FQa97RDrW6lN1ipc+585tSMIzHup4aeoq
         bLHoC1L2d8tR/2XjckmTJfAB2Ip64/EXbwM+aGRIlTpnRSysscymNoa3RnH8fsebos5U
         2lXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NP9OIn8aZdjTBigvGWGYSxvnTPBy4fLFwfAKc1uTAGA=;
        b=m5Fttnb0iLOd+E5GmlEs/TnYelpgFaC2EVmaFLnsCEOmDcO1ThGFmynLroEbchtZvg
         itJvfMQfN668ufqUUXR4XJNXR47ArrfyrtbAXN7MZm4ZuXZvFn9Dz4cGJgVDqEXMzMJ1
         K/VoFlFtekXuWPCFKXGnO56OLyau4DFLfniGgqFi+wWJs9lofWmZDu+9sIDUzClSHrvo
         Rf+vrodiHjeq/JOKPm3UzetDiP4WLU101VKXR7XPUONuIgzHpPG+2IUZUnbGAVfs9S6K
         hKCWZFldZB1oiEdoOMrsuVJbyFyaHu8mis7JyU+6E3AQu1upSypeoEGdkhsBQr9RQANd
         tUmg==
X-Gm-Message-State: AGi0PubX5MajJHGT7c5vtssMUm1HiS/vCeCZ59knWHOmRNZbQLzOwHPm
        FRleorJ+qdjUN9pBlpUggTtztQ==
X-Google-Smtp-Source: APiQypL5oOSXK6EB6pTmE0GvhZKkN9bomyS/0POUiPH8tnXR5GIsMN5uQyBtW82Y8w+DwA9j1QGpNQ==
X-Received: by 2002:adf:fcc8:: with SMTP id f8mr4780563wrs.230.1588699436552;
        Tue, 05 May 2020 10:23:56 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id t67sm5496003wmg.40.2020.05.05.10.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 10:23:55 -0700 (PDT)
Date:   Tue, 5 May 2020 18:23:51 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 03/26] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
Message-ID: <20200505172351.GD237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-4-maz@kernel.org>
 <20200505152648.GA237572@google.com>
 <86pnbitka5.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pnbitka5.wl-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > +	/* VTCR_EL2 value for this VM */
> > > +	u64    vtcr;
> > 
> > VTCR seems quite strongly tied to the MMU config. Is it not controlled
> > independently for the nested MMUs and so remains in this struct?
> 
> This particular instance of VTCR_EL2 is the host's version. Which
> means it describes the virtual HW for the EL1 guest. It constraints,
> among other things, the number of IPA bits for the guest, for example,
> and is configured by the VMM.
> 
> Once you start nesting, each vcpu has its own VTCR_EL2 which is still
> constrained by the main one (no nested guest can have a T0SZ bigger
> than the value imposed by userspace for this guest as a whole).
> 
> Does it make sense?

It does up to my ignorance of the spec in this regard.

Simliar to James's question, should `vtcr` live inside the mmu struct
with the top level `kvm::mmu` field containing the host's version and
the nested mmus containing the nested version of vtcr to be applied to
the vCPU? I didn't noticed there being a vtcr for the nested version in
the ~90-patch series so maybe that just isn't something that needs
thinking about?
