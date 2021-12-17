Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1996D479450
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 19:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbhLQSu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 13:50:27 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34860 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbhLQSu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 13:50:26 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639767025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XnCokuYZlFZCdB/L6abEHXrXzdEnC82APeZO2mVfjS8=;
        b=1cQYM3GthMvCC48wW2px5ZsAnnNECUHXHYYNPnC/ZuEasgYWIAAYU+NgPrBsSdsfvqwlUP
        TcYa4q/86a5YfnXAiD/XAWhgqeHl9P6B2hnUc/RwSDCGKygJPMJRKU+nTkkmGY/oVMrVvo
        G0DFQ1ommEZK2nGSVhcG5Z6ETEHuTSeiEpCt8O7oMGSrizzKs2sEDPJFXc1J13fo2RHajZ
        HhgxbxFO6uo8zoZRTRJsjSjlpM0aITcAK85s46KTgPvnfSEcfbj0O536c76puOKX0ui6pg
        ApfSMGxAz/97haaKYzAfKz9BaPGadbTWPi0RpRUP/6HxvHAkN7ux4qYtdBOucg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639767025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XnCokuYZlFZCdB/L6abEHXrXzdEnC82APeZO2mVfjS8=;
        b=CsNvWsrz+YRY9QTb/lqzRwOg02xPnEPpAoWX3j2zynEChsHy96cvda9atB0VWdZXTFBebL
        B1ag7y1tI+CHyTDA==
To:     Jing Liu <jing2.liu@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: Re: [PATCH v2 08/23] x86/fpu: Provide
 fpu_update_guest_perm_features() for guest
In-Reply-To: <20211217153003.1719189-9-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-9-jing2.liu@intel.com>
Date:   Fri, 17 Dec 2021 19:50:24 +0100
Message-ID: <87wnk3awwf.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

eviewed-by: Thomas Gleixner <tglx@linutronix.de>
On Fri, Dec 17 2021 at 07:29, Jing Liu wrote:
> +/*
> + * fpu_update_guest_perm_features - Enable xfeatures according to guest perm
> + * @guest_fpu:		Pointer to the guest FPU container
> + *
> + * Enable all dynamic xfeatures according to guest perm. Invoked if the
> + * caller wants to conservatively expand fpstate buffer instead of waiting
> + * until XCR0 or XFD MSR is written.
> + *
> + * Return: 0 on success, error code otherwise
> + */
> +int fpu_update_guest_perm_features(struct fpu_guest *guest_fpu)
> +{
> +	u64 expand;
> +
> +	lockdep_assert_preemption_enabled();
> +
> +	if (!IS_ENABLED(CONFIG_X86_64))
> +		return 0;
> +
> +	expand = guest_fpu->perm & ~guest_fpu->xfeatures;
> +	if (!expand)
> +		return 0;
> +
> +	return __xfd_enable_feature(expand, guest_fpu);
> +}
> +EXPORT_SYMBOL_GPL(fpu_update_guest_perm_features);

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
