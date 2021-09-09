Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFD14044ED
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 07:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350685AbhIIFXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 01:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350619AbhIIFXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 01:23:31 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2DBC061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 22:22:22 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id n24so760443ion.10
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 22:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7Ja+MA4OCzFYM/Hx8ySIku22LElZavZCzLsENm+S9Mc=;
        b=sSrKzdgbodHekgxN4FeKFtpd8Y4Csq7gzvDRQimT+tWyjS2LXY7/BuapliIukRhqkG
         Io+6kUubaiVrscaC82Af6p1nUdBkfSX4eUr2v4loWlgQDqFuH6d0WF3s+mSjHOFgKkll
         JnavnAYo7F0qxztVd/Pzz09WfH16Zrc+8IKrvs8libeSHlhU2XeB3Lje4p3qSeX2Rfce
         W1VW0vcIdi9Bw1ZuM4oJI+DPDjWoMOOG7xQ16u49oNtnrcc0HV2eINlwGZGBlLOohXK/
         Qo9en2g0liePMOSs+oEZeOm1FMQayg0KLs4qpa7kwSuOIXjJuDBgMRl0W1CUQ+d7Psp6
         A1Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Ja+MA4OCzFYM/Hx8ySIku22LElZavZCzLsENm+S9Mc=;
        b=FER0vnotisofhQ3OL5vEjd1o84Ki2EmjvhlRJGVJrcNgfwKNS9Yb+JjkLKD7arRFdw
         yFljqhY3TDB0z9b8QUcHENyK01TJJIC3S+ovPsdaOvLHHRZi76jJdNPwGGRhGIYv2t4K
         u8Bf2HhAtR6B26d80uj/+5Mm3cTSqikfWKfQNSw7gFnKMlAhFnvXdLIZCfwjBbB1ncND
         nx7wRZbXcy59kfZ2xeR6GbDha0YBp5d6OJwszJsXISMMpfxBG/JxRxc6yEqkRE54qgZK
         40cXEbNQz6sIWCwGlD+OL/1oTqiQWKGPxyAx0qZ3O/N0U8rusyiRXwUe4fESJpKzmMaH
         Gqnw==
X-Gm-Message-State: AOAM533cri3r1hQT8rq/0T7XHOeOSM0dichNBmsvH3gjSFZJkcquev7K
        m5Vrjle8fBwVZ5g1ItZQxQwhoQ==
X-Google-Smtp-Source: ABdhPJy8iklDSbE81P3I3H1zXA7m4JYm6w3j44cDkU5aPYiQLRdS7kUUAS26jVunWdjTARITmatx0Q==
X-Received: by 2002:a02:cc30:: with SMTP id o16mr1211625jap.101.1631164941450;
        Wed, 08 Sep 2021 22:22:21 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id t10sm408390iol.34.2021.09.08.22.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 22:22:20 -0700 (PDT)
Date:   Thu, 9 Sep 2021 05:22:17 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 12/18] KVM: selftests: Keep track of the number of
 vCPUs for a VM
Message-ID: <YTmaCWPkJ2TOeTsT@google.com>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-13-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-13-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 01:38:12AM +0000, Raghavendra Rao Ananta wrote:
> The host may want to know the number of vCPUs that were
> created for a particular VM (used in upcoming patches).
> Hence, include nr_vcpus as a part of 'struct kvm_vm' to
> keep track of vCPUs as and when they are added or
> deleted, and return to the caller via vm_get_nr_vcpus().
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h      | 1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 7 +++++++
>  tools/testing/selftests/kvm/lib/kvm_util_internal.h | 1 +
>  3 files changed, 9 insertions(+)

Shouldn't a test keep track/know how many vCPUs it has created?

--
Thanks,
Oliver
