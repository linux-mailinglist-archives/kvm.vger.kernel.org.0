Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A816940A6DD
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 08:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240186AbhINGuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 02:50:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234506AbhINGuI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 02:50:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631602130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UZ7o8ZJ24gb5TbRY3xTVpN4Kfg4Yx3sUWIRCXgdvIDA=;
        b=IVKIH0iBchAmoRgcJyQy7BlOOV8W/aEAJK0WrZ2Wz0k8pk8/6b4YPGbWSJYEW89qWL/EPq
        0XebMLuLxFg4iWBlF9DTF9rP0DwEOfs6bTv5oOvlwPn3L0vE7xbb/UvaJAWpNFV/K07INf
        NquzX9p6q3RJzR4FKJKgcs9u2fhIsw8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-afUqV4gfNZK0yzP_Ctj26w-1; Tue, 14 Sep 2021 02:48:49 -0400
X-MC-Unique: afUqV4gfNZK0yzP_Ctj26w-1
Received: by mail-ej1-f69.google.com with SMTP id n18-20020a170906089200b005dc91303dfeso4829079eje.15
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 23:48:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UZ7o8ZJ24gb5TbRY3xTVpN4Kfg4Yx3sUWIRCXgdvIDA=;
        b=pTiPMzGag+XiA+qMQIv44Rg+3aIPbC6jq6BzbGvgJSpK05A04368NLChLNqPJKbbBY
         Bkdn4S2gP4vTmiyW/RLjx/8r2A5JArGzgoQEtNZKzJwkNbP/YIk+5l2Rz1/fLIxX8uSI
         kuol7oSZnLfTvw+rjug/V4tgvfM3aKcMaNThstpTeI3cHtwm5VICpDmNUgY+ZzP5ryLE
         QB0pRlikeu5yYxDo9NDJpsNwumzLPUZtCE6TKsQhORsTvAKwW+fVVB3NUiJgrxGXbuFw
         RWMj4O+3S8XA7evnf5Kk6BHw1jctwf9GlW2+VrgtuxVYfqoPvo1DM8I0CzVzarkkoIdZ
         HaZg==
X-Gm-Message-State: AOAM533fkPReiIUen8eb1LA+ucqOCLQJ96mmE58uPZwEj4q1MVxbOnG8
        SreScnJ7jE+sN1eCdp+tyWil5dmuiHl5nDKM238Aw3WXrG7XKbt5Y6rYg1e6G/ASIL4JqGo686r
        cIp05kdzUZsJo
X-Received: by 2002:a17:906:8481:: with SMTP id m1mr17698372ejx.459.1631602128197;
        Mon, 13 Sep 2021 23:48:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxw/4k09BImJGGLEkWCmc0EMaDoeTSkvL0ybA8OStqRMYzS/MmU4Z+f7vH4tYT3VtEQ0mZWKQ==
X-Received: by 2002:a17:906:8481:: with SMTP id m1mr17698349ejx.459.1631602128062;
        Mon, 13 Sep 2021 23:48:48 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id m10sm4338731ejx.76.2021.09.13.23.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 23:48:47 -0700 (PDT)
Date:   Tue, 14 Sep 2021 08:48:45 +0200
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
Subject: Re: [PATCH v6 02/14] tools: arm64: Import sysreg.h
Message-ID: <20210914064845.4kdsn4h4r6ebdhsb@gator.home>
References: <20210913230955.156323-1-rananta@google.com>
 <20210913230955.156323-3-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913230955.156323-3-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 11:09:43PM +0000, Raghavendra Rao Ananta wrote:
> Bring-in the kernel's arch/arm64/include/asm/sysreg.h
> into tools/ for arm64 to make use of all the standard
> register definitions in consistence with the kernel.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/arch/arm64/include/asm/sysreg.h | 1296 +++++++++++++++++++++++++
>  1 file changed, 1296 insertions(+)
>  create mode 100644 tools/arch/arm64/include/asm/sysreg.h

Looks like an older version than what is available now (v5.15-rc1?)
was used, but it's expected that these tools copies go out of date
quickly and it doesn't matter.

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

