Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAF41F9226
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 10:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgFOItE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 04:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728522AbgFOItE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 04:49:04 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5BBC061A0E
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 01:49:03 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y17so16160976wrn.11
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 01:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xnddRkOdnpKmvgw1VTZ4tNEZP6mx+SwnzvEeJGa4n2I=;
        b=IdUUOc4QN2EUtr5PjBCK2Zqf0CL6mqEqyLIucODDtyyBluNXy7IPgKlGEsAn4RWzGs
         nW+xad357QPkJ4LjoK5MQHOBV/MxHoOxh4h+EMlehW3h749KHSVV+PHzbCMuh8DGiokx
         E5Sli76y1wzpiiggmJR1PCDk6ELgjg7ThLmIVxvuUDK+ZU76cOKgH/gJfp5F96Z/yLEd
         gKBPXOCkEIRjruMkus8iaygwDb7aOzrKjxqOZIIg+zYdgi/F90nRXjaaD2JBvYExE15i
         QLnl0/KSxESnJO5XZelyiSuMnO4PAbEWms4jfB7clTSzFR8IwXtO699TeR/xrKsD1TGv
         W+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xnddRkOdnpKmvgw1VTZ4tNEZP6mx+SwnzvEeJGa4n2I=;
        b=ck0dJsJ31nAFNHcvdkAfWLKzx/Qk+11QNBkH975GGR1lZ6ScxZ+/Eec03/HTQ+M42d
         MPu4TjESDnVM4MYfV7hDNdRtUunquyrioubZ1a33Ou1YPFSvEPbH0mrSLaTsAYGvTsjB
         FR8pdgDIUGypyWfwOOBgB1u5dv9XGCH+0aoQUae3XdUflwNTDfaZlJCBvrTwXw9nXxiG
         PDP7AGPZO+4WfWjWKG2vTYzgo7ZXAFSovf6waDDZMVmgT3eyYIRh5d6q+UX5Qq5jv8DS
         nUenMhBYdvJAzLL6GxZcKgg65yRFXJ5opNkM+5kBaeAdLq6SZZbwLYWeIuof8YNp8T/i
         8tmw==
X-Gm-Message-State: AOAM5306L2D5HsnFV0/L6TEPBsdZMCEc+j3F/eGUP1jPf1/CbPqVb/c2
        SCxcsIMey6yqlBt2R6OpbUAqZ9rV2wo=
X-Google-Smtp-Source: ABdhPJy6wOoCwROS2ko/uRFMhnKwrDbOnQ2R/qDxpfmtGlLbagTzm9WybMrfNKEgpZoPG5/t5RdqWQ==
X-Received: by 2002:adf:f847:: with SMTP id d7mr26976924wrq.261.1592210942617;
        Mon, 15 Jun 2020 01:49:02 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id c5sm10250109wmb.24.2020.06.15.01.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 01:49:02 -0700 (PDT)
Date:   Mon, 15 Jun 2020 09:48:57 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 1/4] KVM: arm64: Enable Pointer Authentication at EL2 if
 available
Message-ID: <20200615084857.GD177680@google.com>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-2-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 09:19:51AM +0100, Marc Zyngier wrote:
> While initializing EL2, switch Pointer Authentication if detected

                                ^ nit: on?

> from EL1. We use the EL1-provided keys though.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp-init.S | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index 6e6ed5581eed..81732177507d 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -104,6 +104,17 @@ alternative_else_nop_endif
>  	 */
>  	mov_q	x4, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
>  CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
> +alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
> +	b	1f
> +alternative_else_nop_endif
> +alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
> +	b	2f
> +alternative_else_nop_endif
> +1:
> +	orr	x4, x4, #(SCTLR_ELx_ENIA | SCTLR_ELx_ENIB)
> +	orr	x4, x4, #SCTLR_ELx_ENDA
> +	orr	x4, x4, #SCTLR_ELx_ENDB

mm/proc.S builds the mask with ldr and ors it in one go, would be nice
to use the same pattern.

> +2:
>  	msr	sctlr_el2, x4
>  	isb

Acked-by: Andrew Scull <ascull@google.com>
