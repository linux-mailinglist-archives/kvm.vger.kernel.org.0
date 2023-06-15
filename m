Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1FD7317FD
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 13:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344564AbjFOL7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 07:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239781AbjFOL6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 07:58:52 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEC75FC6;
        Thu, 15 Jun 2023 04:53:44 -0700 (PDT)
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3E2F01EC0749;
        Thu, 15 Jun 2023 13:53:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1686829992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=wxx0qdnUOOYnbup4Znm2tq4zQENWDCpnvV6oAPsdkAg=;
        b=ADhx5Ub18zM1M6PB7MHD51zugq/SynPXioDzHwEU/pT07joa3amUdauPwFmz1MKhrLhAC7
        hH+ISBPo5nPUygmDGi15x+Eq1wYh8YgsOV4FboiRVY51lvDER5xJXxprtcypiqo322WOZg
        fJONi9NuNVbjMYT7Qiru+oNdHuufM8E=
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZWS2hly03rUI; Thu, 15 Jun 2023 11:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1686829989; bh=wxx0qdnUOOYnbup4Znm2tq4zQENWDCpnvV6oAPsdkAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R8/5LRVPr0veLqJEuqgRazKB+gmbce55d+P5aiROaQYNmgoAxUwtW1EronwPDd3YJ
         d/7l0XcQXGOkjyAWjWd3JQSNgeiiIoVlBDG7Xe1P0m7GLenTkIHS2hmJgLLSRuj7nC
         Bt6Wu6Yy4TXpvCwBb9VNvYFKQkvadJbaNdAIIIg503xDWdQ4Q85uG2r+p+bZx6yd+t
         k8BexxWJNaF5ppfy1DbUZreHjInujbqdXP12R5vWXhZ40lEHSY9kfCxkBfKjpd3uIb
         RiM4zb/nsgkiQxfZlHhqa38UoPSuphyV4KcXb7hEXfxsClJ2/QTJ0PpdXIcmSX8QuS
         HfqyQkT5QCqFXJg86rHlJS4zZAqUwwqc/VnrSYBafFk8TApJunSfmHeCcyvAYnNCCO
         FJDU1w2TfKV3+GrZnzrVEKUDfQZkwTghX6avga7uYh2SmpTDQSLGkZMFPf2aEaiT/Z
         eavsBQOg9H5uDOMoLgw43TTsRNu826CPwRNsRaVQ17qoTqOruwEhssOZNFW1HVX4Z9
         Z6qkfmAVNQCtT5S9LtrK/4AoQJM8CFS4JySDwCcRmopkh3i/lvQRWa/0I/jzkFCNtb
         DLWx+inlciVRfHQ27ZyIoFezpr2by1KbFten8stFHJV4DsICYENBiB89XAj6ii3+iK
         bSr/W9QdFSJ88U1Aj1Nr/fdE=
Received: from zn.tnic (p200300ea971dC500329c23FfFEA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971d:c500:329c:23ff:fea6:a903])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0D80F40E01D0;
        Thu, 15 Jun 2023 11:53:00 +0000 (UTC)
Date:   Thu, 15 Jun 2023 13:52:55 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, seanjc@google.com, x86@kernel.org,
        thomas.lendacky@amd.com
Subject: Re: [RFC PATCH v2] x86/sev-es: Include XSS value in GHCB CPUID
 request
Message-ID: <20230615115255.GBZIr7l2XNKau16ayl@fat_crate.local>
References: <20230524155619.415961-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230524155619.415961-1-john.allen@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023 at 03:56:19PM +0000, John Allen wrote:
> +	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx <= 1) {
> +		unsigned long lo, hi;
> +		u64 xss;
> +
> +		/*
> +		 * Since vc_handle_cpuid may be used during early boot, the
> +		 * rdmsr wrappers are incompatible and should not be used.
> +		 * Invoke the instruction directly.
> +		 */
> +		asm volatile("rdmsr" : "=a" (lo), "=d" (hi)
> +			     : "c" (MSR_IA32_XSS));
> +		xss = (hi << 32) | lo;
> +		ghcb_set_xss(ghcb, xss);

$ git grep ghcb_set_xss
$

So this patch needs some tree which I'm not aware of.

Also, this passing through of host XSS to the guest looks like it is
bypassing the vcpu->arch.ia32_xss copy which KVM seems to maintain. It
looks to me like the handling needs to be synchronized with it or so.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
