Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F9942D627
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhJNJfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 05:35:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229992AbhJNJfo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 05:35:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634204020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g+qKgYe2or+Sc1RbFHq4jz8CZNRQL9bv8FnY68X7aPs=;
        b=AOuBD/BJcUBnw3D6Js0V+QFuGBbNRBId9NBbR0prCnddMyhdYJmbDG944R0jzNCKP4rBbW
        0LDv2wpWp9Z/VBWvu231oQRwuo/EFvK1w1wX2coI0jxPdQAfMAqNSqjEMJmsn8+R2WXta+
        zoanuDK0XJufNeEQ4goXkqyA5e7lX0w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-shlZvALnP4aqv8i4eqA5aA-1; Thu, 14 Oct 2021 05:33:38 -0400
X-MC-Unique: shlZvALnP4aqv8i4eqA5aA-1
Received: by mail-ed1-f69.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso4616594edj.20
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 02:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g+qKgYe2or+Sc1RbFHq4jz8CZNRQL9bv8FnY68X7aPs=;
        b=k0OBUJWk2pibJt46FrcjVi4ilMXBgZZQgfX+Zt+uCGVWfvJQHweOJ36J/jYDrSVPV+
         hj6QGrEA+rSWjoe49adROuaYK9Vvcz1tSLcMJF6+meYM6EyQsuY5XHK5tpStpTCEi3oe
         2j9kIuy+nRJMzseBaABWlWhjcL1sstlBPc7P+ByHcQybuyhkP0E+o3c5xGBJz/07tTLc
         +pebR9aLtLXnNZRT8/arbqwH70mZiWz28W8LHDLeYGK+bHMozu0MbAcjoU6EjBENBN2T
         YE7fxUDmd138lqFYlQt1BnhyuFD1lYapJLBR6bEEM8QWpw/21RyF84eRPhEFoS/05z0E
         xrcA==
X-Gm-Message-State: AOAM533LIT5n0qr9o5Zn+JPpH07P+79nwC40AUJAjlfLqWQKJK2I7Hy+
        Ao2I27nTGDWt08XVhuNIGgzesv0XHotdz0ZhhCp3hVJWTfSjM+0nKW4/jm7F0Qbq8/vn7F8/tAk
        ieITSb75UGfJc
X-Received: by 2002:a05:6402:26d3:: with SMTP id x19mr7209203edd.291.1634204017720;
        Thu, 14 Oct 2021 02:33:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7MSURCxOPkKwvOo5kN+vRvhSn3bfJNdQoM7O2vNnzKZ4pe0EdSxkj+IgJUCdS0zoiEpLTBg==
X-Received: by 2002:a05:6402:26d3:: with SMTP id x19mr7209183edd.291.1634204017549;
        Thu, 14 Oct 2021 02:33:37 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id p10sm1508944ejf.45.2021.10.14.02.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 02:33:37 -0700 (PDT)
Date:   Thu, 14 Oct 2021 11:33:35 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        oupton@google.com, qperret@google.com, kernel-team@android.com,
        tabba@google.com
Subject: Re: [PATCH v9 15/22] KVM: arm64: pkvm: Drop AArch32-specific
 registers
Message-ID: <20211014093335.puukcvmhts5t4jmh@gator.home>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <20211013120346.2926621-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013120346.2926621-5-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 01:03:39PM +0100, Marc Zyngier wrote:
> All the SYS_*32_EL2 registers are AArch32-specific. Since we forbid
> AArch32, there is no need to handle those in any way.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 042a1c0be7e0..e2b3a9e167da 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -452,10 +452,6 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
>  	HOST_HANDLED(SYS_CNTP_CVAL_EL0),
>  
>  	/* Performance Monitoring Registers are restricted. */
> -
> -	HOST_HANDLED(SYS_DACR32_EL2),
> -	HOST_HANDLED(SYS_IFSR32_EL2),
> -	HOST_HANDLED(SYS_FPEXC32_EL2),
>  };
>  
>  /*
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

