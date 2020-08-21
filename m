Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE71624CFE0
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 09:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgHUHrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 03:47:45 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55462 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgHUHro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 03:47:44 -0400
Received: from zn.tnic (p200300ec2f0eda00b4e1d8975031aaf0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:da00:b4e1:d897:5031:aaf0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 522451EC013E;
        Fri, 21 Aug 2020 09:47:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1597996063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=x0qqa/IvqrLY60Nv10kXxs4ZIliJBY04I896OOhUGRs=;
        b=juC3rw6mRkclVIO9LDa0WrzWnTCqKSyhGOm2CZ5oQY1OW1o37YT2e/7Q/fzIblYhrqVhXM
        cAzBNBKLHa+HLide6l50783CgJZIn/YZbkq+OmkwWjwMTgzUOMiDlUaNEiKoBboXSnGqd/
        aXtqVIr/+gWx0Una9QOIpG/Md4MpqeI=
Date:   Fri, 21 Aug 2020 09:47:43 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is
 enabled
Message-ID: <20200821074743.GB12181@zn.tnic>
References: <20200821025050.32573-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200821025050.32573-1-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 07:50:50PM -0700, Sean Christopherson wrote:
> +	 * Disallow RDPID if KVM is enabled as it may consume a guest's TSC_AUX
> +	 * if an NMI arrives in KVM's run loop.  KVM loads guest's TSC_AUX on
> +	 * VM-Enter and may not restore the host's value until the CPU returns
> +	 * to userspace, i.e. KVM depends on the kernel not using TSC_AUX.
>  	 */

And frankly, this is really unfair. The kernel should be able to use any
MSR. IOW, KVM needs to be fixed here. I'm sure it context-switches other
MSRs so one more MSR is not a big deal.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
