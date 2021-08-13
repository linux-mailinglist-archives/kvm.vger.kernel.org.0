Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2883EAF17
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 06:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhHMEHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 00:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhHMEHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 00:07:13 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51E9C061756;
        Thu, 12 Aug 2021 21:06:46 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n12so9536926plf.4;
        Thu, 12 Aug 2021 21:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=aZMV7xGg6neTcrhuS2g8VMZBQv0q4yjk3+aUWZCahPY=;
        b=IdHtSUe98WVD0LhtCYHuvdl4u9hY8IFElNg7fPItKHdlrfgTVU6MVh4FcjtnTfz3mC
         lGTiwvXP9qvb+kRjG6cPPX8sIEdhFQNPhCn55ldS3OyQAAO3dHNk0EyiQgAo6bE+l7E2
         ZNIVZtK2pPanYtvXgYqlaGlAzPXNe/oPL/cSyco+Ogr3kfzTYf7vJqd98ZTU6I0e92B+
         3rAUMSRfjL1xLbXS4Cr0tRtG7AF9JLTD6+Hv+s/RZCsnq8tUlUby8p9pYpmpH+5+dZv/
         UO2WvCi0QksWJk77Co2jiDJtspeLkDhEsFvIGsw3aaictpa5mLSKJMphJNfg/Pzwq+j8
         9Kvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=aZMV7xGg6neTcrhuS2g8VMZBQv0q4yjk3+aUWZCahPY=;
        b=Fc9bLfPMdf6ZgHjGXiL2a08ksWOja/LAA3pYLhosuP1LIiyt/OaRVKLr79VnL0/tEn
         rsoXG0SZqJNEADDbs0xnOyzmEKb9xNHQpRndF4eMOws7KJpFhXne9tMZcw0TdotlXqPs
         xFuFqg8PtO+/Qm7l+isBHKrqAwyl4FMucEVkI7OOCeLKPEya25XsNJS1cTR+oWxoix/b
         Mm9zqCD1CopXSr/pkvkZZgMDpwQAWalR7o+1iVQ2IZrnHv/huoVHwcRj0r80v6Tou8Nq
         eHDF2+55hcFj11ETcl8aZpNqa3VfOjw97LDXYentYeWJhFvytCkADvCmItlz401tlF6o
         OOvQ==
X-Gm-Message-State: AOAM532JPl3oy0kmahqCoUzZAMjkdhawa3y2Pf+MSj6T0WAtKzVr408k
        WSlt8ci5btcoMhn0gtC/T9A=
X-Google-Smtp-Source: ABdhPJz8HvQRdrNoNnBk1WHF6zQMxOvzW3PRigZYSLQgzkjedHc8vxzZU7RRzxIoADU2D4qRq5AuKQ==
X-Received: by 2002:a05:6a00:23c5:b029:3e0:7350:efd6 with SMTP id g5-20020a056a0023c5b02903e07350efd6mr536118pfc.40.1628827606321;
        Thu, 12 Aug 2021 21:06:46 -0700 (PDT)
Received: from localhost (60-242-208-220.static.tpgi.com.au. [60.242.208.220])
        by smtp.gmail.com with ESMTPSA id 19sm302111pfw.203.2021.08.12.21.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 21:06:46 -0700 (PDT)
Date:   Fri, 13 Aug 2021 14:06:40 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH v0 5/5] pseries: Asynchronous page fault support
To:     Bharata B Rao <bharata@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     aneesh.kumar@linux.ibm.com, bharata.rao@gmail.com,
        kvm@vger.kernel.org
References: <20210805072439.501481-1-bharata@linux.ibm.com>
        <20210805072439.501481-6-bharata@linux.ibm.com>
In-Reply-To: <20210805072439.501481-6-bharata@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1628825941.uhcogyrzjc.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from Bharata B Rao's message of August 5, 2021 5:24 pm:
> Add asynchronous page fault support for pseries guests.
>=20
> 1. Setup the guest to handle async-pf
>    - Issue H_REG_SNS hcall to register the SNS region.
>    - Setup the subvention interrupt irq.
>    - Enable async-pf by updating the byte_b9 of VPA for each
>      CPU.
> 2. Check if the page fault is an expropriation notification
>    (SRR1_PROGTRAP set in SRR1) and if so put the task on
>    wait queue based on the expropriation correlation number
>    read from the VPA.
> 3. Handle subvention interrupt to wake any waiting tasks.
>    The wait and wakeup mechanism from x86 async-pf implementation
>    is being reused here.

I don't know too much about the background of this.

How much benefit does this give? What situations? Does PowerVM implement=20
it? Do other architectures KVM have something similar?

The SRR1 setting for the DSI is in PAPR? In that case it should be okay,
it might be good to add a small comment in exceptions-64s.S.

[...]

> @@ -395,6 +395,11 @@ static int ___do_page_fault(struct pt_regs *regs, un=
signed long address,
>  	vm_fault_t fault, major =3D 0;
>  	bool kprobe_fault =3D kprobe_page_fault(regs, 11);
> =20
> +#ifdef CONFIG_PPC_PSERIES
> +	if (handle_async_page_fault(regs, address))
> +		return 0;
> +#endif
> +
>  	if (unlikely(debugger_fault_handler(regs) || kprobe_fault))
>  		return 0;

[...]

> +int handle_async_page_fault(struct pt_regs *regs, unsigned long addr)
> +{
> +	struct async_pf_sleep_node n;
> +	DECLARE_SWAITQUEUE(wait);
> +	unsigned long exp_corr_nr;
> +
> +	/* Is this Expropriation notification? */
> +	if (!(mfspr(SPRN_SRR1) & SRR1_PROGTRAP))
> +		return 0;

Yep this should be an inline that is guarded by a static key, and then=20
probably have an inline check for SRR1_PROGTRAP. You shouldn't need to
mfspr here, but just use regs->msr.

> +
> +	if (unlikely(!user_mode(regs)))
> +		panic("Host injected async PF in kernel mode\n");

Hmm. Is there anything in the PAPR interface that specifies that the
OS can only deal with problem state access faults here? Or is that
inherent in the expropriation feature?

Thanks,
Nick
