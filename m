Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD11C3FEEED
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 15:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345284AbhIBNrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 09:47:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232466AbhIBNrL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 09:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630590372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PcQKXY/cQKOdShIe+YVlSE7XvlfimtQWI3kVCVJqZrE=;
        b=DpqwurnS2RKa228rtXj69wMrthiB6gtNWFoZntulVJjybYaYChQoOXvOulPZbbl5/UyBZM
        mt/jpQ57GdEmUuEfheKlgnK4EHMpaCtDszzr1VXJ4fuqQ0+hsi5RIl72yBMHmLiWyMCK//
        265oizJQaoD/HB5l+S/jRUe25V3Cpjo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-_t1q4Bj8Of2-Hx4TN5w6SA-1; Thu, 02 Sep 2021 09:46:08 -0400
X-MC-Unique: _t1q4Bj8Of2-Hx4TN5w6SA-1
Received: by mail-qk1-f198.google.com with SMTP id e22-20020a05620a209600b003d5ff97bff7so1706129qka.1
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 06:46:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PcQKXY/cQKOdShIe+YVlSE7XvlfimtQWI3kVCVJqZrE=;
        b=lVgbIVYjAV5/WbzI0O+XvMsz+/hwppJ91tiGM9uFHI7TRL71/TCa4bmbBcWKOG7A7s
         D96qq68wb/ItTVBJga4qbXbPRho0e7lGeAAADdi2/vcc+9gbVpRqMe9CEP9zYfM/TR1j
         J8zn/9iifcFMPesYpNJVBbeslIV6ZKSO3pU7UM9DDP0PRd2gE4xYbX5jGl/M+rMyGmqf
         3jL+KVEAo0Pwo8hv9JnauuwO/UlwLrvjGST+98eLciqoWhUm17TYsn8TnqGoXd8/XWFC
         ihqxkifTdQxyjYXhaxrvAoWsaCCq435/Vp4/APoG1Dge1UXdQBYVrWloE91fUbOEVhv/
         YnxA==
X-Gm-Message-State: AOAM531pup6LBCHzQzhydP7J1igwWS1n8f0hbPhzpgN+L21HO+IxTV5z
        ipcLucEw7bvTj2Cga5DBw28iA3pmXIO1g6AoTTCGD+jH/diH3F5C+X6CzLr6Gsw09YNS7heQPlK
        /NnzJxgS7yCSK
X-Received: by 2002:a0c:d804:: with SMTP id h4mr3371869qvj.37.1630590368131;
        Thu, 02 Sep 2021 06:46:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx83mm+WcK2lvoIW0v47pEySyGsM3Sm0Io+mwVAic5avZpGftQiWmMPlQQwHQjgqGnarNFYXg==
X-Received: by 2002:a0c:d804:: with SMTP id h4mr3371853qvj.37.1630590367962;
        Thu, 02 Sep 2021 06:46:07 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id d20sm1413091qkl.13.2021.09.02.06.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 06:46:07 -0700 (PDT)
Date:   Thu, 2 Sep 2021 15:46:03 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 03/12] KVM: arm64: selftests: Add support for cpu_relax
Message-ID: <20210902134603.zqdaqa4yfndi2dmc@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-4-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-4-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:03PM +0000, Raghavendra Rao Ananta wrote:
> Implement the guest helper routine, cpu_relax(), to yield
> the processor to other tasks.
> 
> The function was derived from
> arch/arm64/include/asm/vdso/processor.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
>  1 file changed, 5 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

