Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFBB42280B
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhJENiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:38:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234551AbhJENiY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633440993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=spGyJ7Cf8vpJUL593O/kfEmvQHi4gSPemua27E8EnhM=;
        b=jIlr5zym47dNFdKccke7al8tgSLQJaYdHHZsbj5EIZRicCcJifnA+x3sT4kBYleYFEmSDR
        lRLMGF4j2K2oZML4UIjsxbkyfYqXdYUANvoDPh/WIFia4WrkbNtNFxrQ9hrJ7aEnt4vvCe
        xqUUsbiXyemWjoc7MG3o7b1WlvLXJaA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-eD4Icf6LN2qQ8LJVU8ERQw-1; Tue, 05 Oct 2021 09:36:32 -0400
X-MC-Unique: eD4Icf6LN2qQ8LJVU8ERQw-1
Received: by mail-ed1-f70.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso20645575edw.10
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 06:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=spGyJ7Cf8vpJUL593O/kfEmvQHi4gSPemua27E8EnhM=;
        b=IxmwziIyd8ic9XN32PNEmz0LgHnGNttffmBkrtAUdZcOHk/8eb7w4jC5kCCuavcWXP
         KfSLvXyEu30HR0A0buzmtS6mIjLv0a/mWZhUTi6nlOfklFvl2EvVk9ybr4ehtM/CMCGy
         W+AmGUEN5q/QBYeBQ5kEocacswVNsRHtOF/uK/rGJz8WoHdD2u8282HXSlZ17Y++/CYq
         Z8ijbSEvS3xQj7dPgCLZB2DB3DvVBPbO2RRrTxINM4YHNqVeHd2Z/xSX0HnccjA99z+v
         oPZZO3ZlXXQFjq4Y5k4spSNr8UOLd6A9f5fIzK9Ra9gdBadnJzjBsdUgfsnbZ96l4HO7
         uiLg==
X-Gm-Message-State: AOAM530idL+toa5oJKDxw+ofYvnmbGQWSzVzSh22dFvFRP3Hj9Bm1xPs
        q+0Is+aDRBB/e7hetZKuUZ2pPeFfO3FXH6PXd6Tmw11CJNF9JkLVakMOVL3VIA135ry7+Y0rmlg
        u+k+QLLpjKJS/
X-Received: by 2002:a50:e188:: with SMTP id k8mr27017969edl.119.1633440990815;
        Tue, 05 Oct 2021 06:36:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJVRETLF6a+xnd6Ktl0miKR+7KUXqOoxbXOa/2YXRrb3ceS8NbWdz2P9tIxcjJczoiyT/ukQ==
X-Received: by 2002:a50:e188:: with SMTP id k8mr27017950edl.119.1633440990695;
        Tue, 05 Oct 2021 06:36:30 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id u16sm2811733edy.55.2021.10.05.06.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 06:36:30 -0700 (PDT)
Date:   Tue, 5 Oct 2021 15:36:28 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 07/11] selftests: KVM: Rename psci_cpu_on_test to
 psci_test
Message-ID: <20211005133628.xzyftohm2xekaukq@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-8-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923191610.3814698-8-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 07:16:06PM +0000, Oliver Upton wrote:
> There are other interactions with PSCI worth testing; rename the PSCI
> test to make it more generic.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore                          | 2 +-
>  tools/testing/selftests/kvm/Makefile                            | 2 +-
>  .../selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c}   | 0
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename tools/testing/selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c} (100%)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 98053d3afbda..a11b89be744b 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  /aarch64/debug-exceptions
>  /aarch64/get-reg-list
> -/aarch64/psci_cpu_on_test
> +/aarch64/psci_test
>  /aarch64/vgic_init
>  /s390x/memop
>  /s390x/resets
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5d05801ab816..6907ee8f3239 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -86,7 +86,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
>  
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> -TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
> +TEST_GEN_PROGS_aarch64 += aarch64/psci_test
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += demand_paging_test
>  TEST_GEN_PROGS_aarch64 += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> similarity index 100%
> rename from tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> rename to tools/testing/selftests/kvm/aarch64/psci_test.c
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

