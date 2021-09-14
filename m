Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA6340A6E1
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 08:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240350AbhINGw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 02:52:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240327AbhINGwZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 02:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631602267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uo1ypxwE99K2K4JA/RxOGUNqzLACfvlm1lsSRFgGyDc=;
        b=EQNsBltrWWf5LjAjwIqxvMllIzfBntk5QeIWJmTozRL+7vXjw98Ep7PWnSrgm/ulcf6AcB
        UKE33BOijLPOfa3LMIMLZysKj5uUAA1xdBlJx7bF4/IsJTmoHHLb0Z0v9/ZBIBv3nwCPwB
        Qb05mqN4aJgzF5hqXxwNInzuEGl/mwY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-z18wafzvPACc-sg3rNhAxA-1; Tue, 14 Sep 2021 02:51:02 -0400
X-MC-Unique: z18wafzvPACc-sg3rNhAxA-1
Received: by mail-ej1-f72.google.com with SMTP id ga42-20020a1709070c2a00b005dc8c1cc3a1so4835054ejc.17
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 23:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uo1ypxwE99K2K4JA/RxOGUNqzLACfvlm1lsSRFgGyDc=;
        b=kcqUj+5vph5xFE5TRJzN3oahVH6lLsf9btgXMe865KpraZQR7j80mFeQIE7iTw3AqE
         ny1f/0uzCK5Ans4RuoCqM0lCZ8A72nKbWxkKNNfVP+Stee2f/yVDJRuQvZ8m+5b8VmEX
         cvjtzTXnj8I+0/GNJy/SMy9IFeFNtkxZkraFp6ffQYifiqwLbO+NnCrxXaaR3P6FR+2Q
         9XDQV3Do7FEAcYNz76z+RXiKZ204/jpnJp/mWD8K4fvPkPXmE1aWbR+4wWcO9Q4uZDAK
         H+etf2Js5nmexAz+fiymX6BBR9bIPZSeQN7A5NITV2hsTlF0VQHxAvToRqrY+nInIQKt
         A9bQ==
X-Gm-Message-State: AOAM530WKRKLMcuw3JgwgFp1vWlhIxRtdW4xjCm8eAw0UXRu/btSwVMY
        3u3m6ydhymudmb9tt1hrXrBdLKqt+NRephhbgHVuy921AliKskBNAdHAh2GIX4djw72NVNsaW98
        lIMa47ECl7zvO
X-Received: by 2002:a17:906:686:: with SMTP id u6mr16587577ejb.569.1631602261016;
        Mon, 13 Sep 2021 23:51:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylIm78jMF8rvHMhD/z1+b0Q3pmhqeY5KYi6PHEiggzRATGOoFe+gFNpkPigFiX6dd/K2Nvxw==
X-Received: by 2002:a17:906:686:: with SMTP id u6mr16587561ejb.569.1631602260877;
        Mon, 13 Sep 2021 23:51:00 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id k21sm4417460ejj.55.2021.09.13.23.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 23:51:00 -0700 (PDT)
Date:   Tue, 14 Sep 2021 08:50:58 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 04/14] KVM: arm64: selftests: Introduce
 ARM64_SYS_KVM_REG
Message-ID: <20210914065058.3ujet4nesbzxy4vr@gator.home>
References: <20210913230955.156323-1-rananta@google.com>
 <20210913230955.156323-5-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913230955.156323-5-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 11:09:45PM +0000, Raghavendra Rao Ananta wrote:
> With the inclusion of sysreg.h, that brings in system register
> encodings, it would be redundant to re-define register encodings
> again in processor.h to use it with ARM64_SYS_REG for the KVM
> functions such as set_reg() or get_reg(). Hence, add helper macro,
> ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
> into ARM64_SYS_REG definitions.
> 
> Also replace all the users of ARM64_SYS_REG, relying on
> the encodings created in processor.h, with ARM64_SYS_KVM_REG and
> remove the definitions.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  |  2 +-
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c  |  2 +-
>  .../selftests/kvm/include/aarch64/processor.h | 20 ++++++++++---------
>  .../selftests/kvm/lib/aarch64/processor.c     | 16 +++++++--------
>  4 files changed, 21 insertions(+), 19 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

