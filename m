Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CB12C87F6
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 16:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgK3P1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 10:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgK3P1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 10:27:46 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64762C0613D2
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 07:26:59 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id l1so16717584wrb.9
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 07:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tONxU2U9GL0gMUjpyZwJygnVpWZHjPgrlpNaw6Fic48=;
        b=oZtkSq2Ljzo+vuM1EdpYt4mGvnekUHwbfMD4nZGtJHrP3zH3OmY4r/NK/mDNQkqyiz
         q5zRZLHniWJSmOEsxXeY96qUHXaMuceZhg0phtxUHF7iibJmUmyWkkKKZJJRqnZt+t5A
         clolipjKljpNA5i1MtZZQzEi8jZ3SW36zfPRzzMG9iTsiEkyvwQUtLPFsvji0U6fLdI7
         mWrDEZMXrOPf6cc3OCHYxGMRMKUBDPIc30+Kp7aK3rLbKlvvLsnW2EhLtn3yk7EsbNv2
         z1v0kX6t0wVpcYgfQH45SV2nNdsuqwdg/xORx8NrmNpDubBvXRdWvN0RGBgJAF5NZxRO
         /jpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tONxU2U9GL0gMUjpyZwJygnVpWZHjPgrlpNaw6Fic48=;
        b=aZtmxpM3Q6w4jV43wziHSaJ0UCnV5kmTzPy6aWinplqiKOdBdqxYazKlp5BuerSkGU
         bYboP/Eoro9Dl01h+LRSwB4VK+gpvtMk7dAjt7v4mVxre9ENVMGZw51RyWn8b52gXMQb
         GEMQHtUKe6UoLCdug7rxpSO3uxLEPze4FiXhCOokaoqX70s/7LyOykZkwVgoW9WgZshl
         LpVHi1tAOR6pKmZatE681i7fOhARpRMAy8Z45K+bX2feDuJ8+YzMAY+aCSpSBCVuK4Ce
         jMUQkL7ThkdxsaTlnkOK5y3VJfjitaaJbRAgZMmG09IiAVk/X8q2hlBVc455WX5Ye1lI
         cPeA==
X-Gm-Message-State: AOAM533uVP/MCQCcaffD3AzL8Rha/VQntWVMEGyGcnWZNnchiSIBD3fM
        XBJXmwIn1GMrkQkvJkwb/lvx4g==
X-Google-Smtp-Source: ABdhPJxpMmIXCRaiBBxkPTGUoiQKyhIZmvSM1oRqrg7e8aAjHI9Ui3kbXFIzmmmqQTpXTmWMypzCkw==
X-Received: by 2002:a5d:4349:: with SMTP id u9mr28116179wrr.319.1606750017869;
        Mon, 30 Nov 2020 07:26:57 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:acd2:909f:46a6:675])
        by smtp.gmail.com with ESMTPSA id b14sm27372063wrq.47.2020.11.30.07.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 07:26:56 -0800 (PST)
Date:   Mon, 30 Nov 2020 15:26:55 +0000
From:   David Brazdil <dbrazdil@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 2/2] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV3=1 if the
 CPUs are Meltdown-safe
Message-ID: <20201130152655.oyzs2l4qg2pfzxmv@google.com>
References: <20201128124659.669578-1-maz@kernel.org>
 <20201128124659.669578-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128124659.669578-3-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> @@ -1227,9 +1229,16 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
>  		return -EINVAL;
>  
> -	/* We can only differ with CSV2, and anything else is an error */
> +	/* Same thing for CSV3 */
> +	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV3_SHIFT);
> +	if (csv3 > 1 ||
> +	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
> +		return -EINVAL;
> +
> +	/* We can only differ with CSV[23], and anything else is an error */
>  	val ^= read_id_reg(vcpu, rd, false);
> -	val &= ~(0xFUL << ID_AA64PFR0_CSV2_SHIFT);
> +	val &= ~((0xFUL << ID_AA64PFR0_CSV2_SHIFT) ||
> +		 (0xFUL << ID_AA64PFR0_CSV3_SHIFT));

That boolean OR looks like a typo.

David
