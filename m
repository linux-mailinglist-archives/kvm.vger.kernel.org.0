Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE6633D1D6
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbhCPKcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236697AbhCPKbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 06:31:51 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64736C06174A
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 03:31:50 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v4so7147169wrp.13
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 03:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nidvh/89tn+Y/HVhz7QTE7lN1pMSoiQsRzITbdZvVck=;
        b=W1RROg28NSJY+h0JNcBa2OvIgqaoB2tDMiJU6Yuc1AWATHeOV/W7nAGnC706xuhnRg
         Y92LTO9v79rp5ZibisFG/OJXd1QSQsDUqLPYsba8dZx5W1og0IRzlUqMVm/Z7Ld7O8Pu
         ueWROCrphU1orMKIERU6TjPyZLuRJdEPKmsUKTyjpTkrJk/QiHEcaEBsASeatZkRJwI4
         zSqUBkLUmYjBtJv9M2MLl6MXRgwC5JHcFxprBmGIF5U6uDou5yifMF8RfGwWXEHog6i5
         Mzyl0VryqajrdJXkE/dw5iNFe47bk2QbScCn5nbuIWb0nSSurj/ZuiWicIY7YZe/kAmD
         vExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nidvh/89tn+Y/HVhz7QTE7lN1pMSoiQsRzITbdZvVck=;
        b=epmR3ljULFBlMMp2BFETu9AKYEFaK2AzHOTRUCBJ3nv9hf2xwLa/yvCq1+Ah5HswdX
         z4aBAmChITaeMatXeDIbr2i72a6FnjfSADTRDOr8O0bAKU3qM5PXHiNgTLnCegW2SDBx
         4JP4ro4i9X8P7i/jFqZ+6HbTvFOvnr5x5DWtJmIzjia1+joNzaZ/8B6fRi6+i9qAKU+P
         tDEGar5PUyCbW4l9v/5tuOmro5Po0rwSSF2glxAHBlUSc3NqaPCL5QCM/cclS516r8P/
         BPF9h7YFSBuetydCMBu1HLC+cs5hkA0oJOR2fvdxWwklBiVy/8nFyyK9ga3ZHRsEaIRp
         CASQ==
X-Gm-Message-State: AOAM532zMKkwtOq3/kXt5U7pbtD4Vc0W2LgpT09aEznimKB/1xYpzS16
        PVygoWKYtPGCv4WXnWVfwVin0g==
X-Google-Smtp-Source: ABdhPJz9EQO1Z6JuVEny9FQp/kgBd99pD2l8NgikvLXqL/mEIHDS8WGg/zebhRv8UldsnFywXQplgg==
X-Received: by 2002:a5d:400f:: with SMTP id n15mr4028400wrp.89.1615890709026;
        Tue, 16 Mar 2021 03:31:49 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com. [35.233.69.230])
        by smtp.gmail.com with ESMTPSA id s18sm24967422wrr.27.2021.03.16.03.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 03:31:48 -0700 (PDT)
Date:   Tue, 16 Mar 2021 10:31:46 +0000
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 01/10] KVM: arm64: Provide KVM's own save/restore SVE
 primitives
Message-ID: <YFCJEgjUZ5cnq0AK@google.com>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-2-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday 16 Mar 2021 at 10:13:03 (+0000), Marc Zyngier wrote:
> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> index 01f114aa47b0..e4010d1acb79 100644
> --- a/arch/arm64/kvm/hyp/fpsimd.S
> +++ b/arch/arm64/kvm/hyp/fpsimd.S
> @@ -19,3 +19,13 @@ SYM_FUNC_START(__fpsimd_restore_state)
>  	fpsimd_restore	x0, 1
>  	ret
>  SYM_FUNC_END(__fpsimd_restore_state)
> +
> +SYM_FUNC_START(__sve_restore_state)
> +	sve_load 0, x1, x2, 3, x4
> +	ret
> +SYM_FUNC_END(__sve_restore_state)

Nit: maybe this could be named __sve_load_state() for consistency with
the EL1 version?

> +SYM_FUNC_START(__sve_save_state)
> +	sve_save 0, x1, 2
> +	ret
> +SYM_FUNC_END(__sve_restore_state)

SYM_FUNC_END(__sve_save_state) here?

Thanks,
Quentin
