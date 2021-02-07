Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30135312415
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 12:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhBGLuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 06:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhBGLtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 06:49:45 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F29C06174A;
        Sun,  7 Feb 2021 03:49:05 -0800 (PST)
Received: from zn.tnic (p200300ec2f287c00fd7d89ed8712b97d.dip0.t-ipconnect.de [IPv6:2003:ec:2f28:7c00:fd7d:89ed:8712:b97d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2B0E61EC0118;
        Sun,  7 Feb 2021 12:49:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1612698540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=akHfnhCK1MKhUH8obwmx+2AZkZVmst1LXxgWweXsm5k=;
        b=B86vde7CMxLdMdCsOpJ2LUaIaL/ZHoZe45q6NJxyrXBFxvwweJZQhvKRLdBQl2p/jjTU3x
        l6GL0bEgVSmxa8iGYaiXTcgIx9DEXlFhztFV/DUx4UtCibDcWzBq4lYW9bfXNNBsZA50JD
        aFR8usmB45sfTxnU6XsXaYbBwiqdQpU=
Date:   Sun, 7 Feb 2021 12:49:02 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jing Liu <jing2.liu@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com,
        x86-ml <x86@kernel.org>
Subject: Re: [PATCH RFC 3/7] kvm: x86: XSAVE state and XFD MSRs context switch
Message-ID: <20210207114902.GA6723@zn.tnic>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-4-jing2.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210207154256.52850-4-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 07, 2021 at 10:42:52AM -0500, Jing Liu wrote:
> diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
> index 7e0c68043ce3..fbb761fc13ec 100644
> --- a/arch/x86/kernel/fpu/init.c
> +++ b/arch/x86/kernel/fpu/init.c
> @@ -145,6 +145,7 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_min_size);
>   * can be dynamically expanded to include some states up to this size.
>   */
>  unsigned int fpu_kernel_xstate_max_size;
> +EXPORT_SYMBOL_GPL(fpu_kernel_xstate_max_size);
>  
>  /* Get alignment of the TYPE. */
>  #define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index 080f3be9a5e6..9c471a0364e2 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -77,12 +77,14 @@ static struct xfeature_capflag_info xfeature_capflags[] __initdata = {
>   * XSAVE buffer, both supervisor and user xstates.
>   */
>  u64 xfeatures_mask_all __read_mostly;
> +EXPORT_SYMBOL_GPL(xfeatures_mask_all);
>  
>  /*
>   * This represents user xstates, a subset of xfeatures_mask_all, saved in a
>   * dynamic kernel XSAVE buffer.
>   */
>  u64 xfeatures_mask_user_dynamic __read_mostly;
> +EXPORT_SYMBOL_GPL(xfeatures_mask_user_dynamic);
>  
>  static unsigned int xstate_offsets[XFEATURE_MAX] = { [ 0 ... XFEATURE_MAX - 1] = -1};
>  static unsigned int xstate_sizes[XFEATURE_MAX]   = { [ 0 ... XFEATURE_MAX - 1] = -1};

Make sure you Cc x86@kernel.org when touching code outside of kvm.

There's this script called scripts/get_maintainer.pl which will tell you who to
Cc. Use it before you send next time please.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
