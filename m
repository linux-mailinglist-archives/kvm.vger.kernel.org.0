Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5F8260121
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731232AbgIGQ7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 12:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730592AbgIGQ7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 12:59:02 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA7DC061573;
        Mon,  7 Sep 2020 09:58:59 -0700 (PDT)
Received: from zn.tnic (p200300ec2f090900c4f00348aacf37a5.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:900:c4f0:348:aacf:37a5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EA64B1EC00F4;
        Mon,  7 Sep 2020 18:58:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1599497938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=f8SfAAyXeqxq2AQb205NNpHyD9AfmQyyAEljoRCFv6k=;
        b=KXJWYBon+qIU3Dc1jqyEl0uksmyVwjboVTQXyWOm6FdZvFVbSLGKec6ejmWNdxVLAbIvwp
        WFdL1LkX10BO5BGgpGw/Ma5JeXuDn2PCoEpdZMW/06MnMg6plGn/rQ/eG7Ad1IIX/E/Ndk
        LYheDfFOoz3D0esSwEqyajhwcrvprWo=
Date:   Mon, 7 Sep 2020 18:58:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 19/72] x86/boot/compressed/64: Add stage1 #VC handler
Message-ID: <20200907165851.GE16029@zn.tnic>
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-20-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200907131613.12703-20-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 07, 2020 at 03:15:20PM +0200, Joerg Roedel wrote:
> +static inline u64 sev_es_rd_ghcb_msr(void)
> +{
> +	unsigned long low, high;
> +
> +	asm volatile("rdmsr\n" : "=a" (low), "=d" (high) :
> +			"c" (MSR_AMD64_SEV_ES_GHCB));
> +
> +	return ((high << 32) | low);
> +}
> +
> +static inline void sev_es_wr_ghcb_msr(u64 val)
> +{
> +	u32 low, high;
> +
> +	low  = val & 0xffffffffUL;
> +	high = val >> 32;
> +
> +	asm volatile("wrmsr\n" : : "c" (MSR_AMD64_SEV_ES_GHCB),
			   ^^

No need for that newline and the one above. I've zapped it while applying.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
