Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2BE1C5E9C
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 19:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbgEERQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 13:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729199AbgEERQi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 13:16:38 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5BFC061A0F
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 10:16:37 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x25so3156616wmc.0
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 10:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j/K4PATbLRvXzOHJ5kuvFj7wv+7GxYy2AO2wgULDc48=;
        b=UdfGkBCaEekX1+Ogl521QElFibeK4JEuXmv+9Qyn1i1eO1zr1X48fFX03epvhY+IY6
         ndvidFnMb1LphudrcVRhoWifpNWD22iZNraDpuomYuRhOEn76EjZ3b9SSDCBtT8Y4GQ7
         jt6vabzBm6D8UD+o4kzd9GJibXajbtWD8IdhX9Lmgfrh0w0ORRwY8fXa2Ya6/ryu3evu
         SBcPxJ45+56nOeQDG0Egjl56sijaUTDF0SJfEaOmqBuxiSyv38xKB49H6095OwlH+Mad
         6s4qyd1ojEeGZwrkhd05xwnwU2rFCDNGqF17NcmacWdRCjdzQak93yG3czezNQwM0bZg
         /ISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j/K4PATbLRvXzOHJ5kuvFj7wv+7GxYy2AO2wgULDc48=;
        b=SN4VUZqcuFY5oLQ1wI26uwPF8h+TfKwlISupKLxyF3F/uq5gl5IWg5K9G3vkYRsagS
         E6WSYvl7CWhGXXLouLf1VEFS2x+yJJtTJsvRpPtcU6utA0nhbF0ojn02rKVWvgIpJe05
         sGc2gNfcc27ZsqEm5OddgomVxgVPS0drDIlL3gP1LZbIjie2ZPNLxV4ZX1YCpa7cIFCF
         LmvIFtlvw8tWrbjPnuphYTpnmg2KNACVsU1EasMjIp4HBvKAUiqDUi237tffx5396PSg
         OplL4o8Du5z0WI4uLgVNsgsIJkjnYHP+fsnfJDofQ7qeWYDcVxzR4/yXBYBKpBZMrG7e
         N9IQ==
X-Gm-Message-State: AGi0PuaPjcIrMJZunpbzRRIJ54c5xZbeHKnUufOnWquSaGLQfU2WdXKp
        ME2kaCAiUujTjN1kj8SrqG2EzEiYc3/KVA==
X-Google-Smtp-Source: APiQypLAF/GA9/GggAGCjJYWWbPUt/ZLtlJkLB0SJTpOIVPoR1ng5wPO0c9UIGGAGmCzyMuR7y9mNA==
X-Received: by 2002:a1c:3c87:: with SMTP id j129mr4234274wma.157.1588698996194;
        Tue, 05 May 2020 10:16:36 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id z22sm4692812wma.20.2020.05.05.10.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 10:16:35 -0700 (PDT)
Date:   Tue, 5 May 2020 18:16:31 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 06/26] arm64: Add level-hinted TLB invalidation helper
Message-ID: <20200505171631.GC237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-7-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422120050.3693593-7-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +#define __tlbi_level(op, addr, level)					\
> +	do {								\
> +		u64 arg = addr;						\
> +									\
> +		if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&	\
> +		    level) {						\
> +			u64 ttl = level;				\
> +									\
> +			switch (PAGE_SIZE) {				\
> +			case SZ_4K:					\
> +				ttl |= 1 << 2;				\
> +				break;					\
> +			case SZ_16K:					\
> +				ttl |= 2 << 2;				\
> +				break;					\
> +			case SZ_64K:					\
> +				ttl |= 3 << 2;				\
> +				break;					\
> +			}						\
> +									\
> +			arg &= ~TLBI_TTL_MASK;				\
> +			arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);		\

Despite the spec saying both tables apply to TLB maintenance
instructions that do not apply to a range of addresses I think it only
means the 4-bit version (bug report to Arm, or I'm on the wrong spec).

This is consistent with Table D5-53 and the macro takes a single address
argument to make misuse with range based tlbi less likely.

It relies on the caller to get the level right and getting it wrong
could be pretty bad as the spec says all bets are off in that case. Is
it worth adding a check of the level against the address (seems a bit
involved), or that it is just 2 bits or adding a short doc comment to
explain it?

(Looks like we get some constants for the levels in a later patch that
could be referenced with some form of time travel)

> +		}							\
> +									\
> +		__tlbi(op,  arg);					\

cosmetic nit: double space in here
