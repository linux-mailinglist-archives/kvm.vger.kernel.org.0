Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F04B0AAB
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 10:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfILIvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 04:51:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfILIvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 04:51:50 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 430A481DEB
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 08:51:50 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id j2so3472088wre.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 01:51:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mx1kKrIiSmryWWn3Il/w12tQaldws+Bo5K0e/h/OmZw=;
        b=Wts52tM0m1lCtzADAgsFs/Izbm+U4x+qVPHwycqL7D6E0KdicKd38Fq9lywfqh4yNP
         02wyGNN/LdKkZ+gs1NicxKdcB32rNlgStSob9THzrgS0Fa9eUc5xFuIP4JPXxDWOAXIc
         0tjbds68RGhQ6IuyzTY7YiusccW0sPjNMLYmhmhKVVLt5+XqvOKu6SgJtnFSRZXny9Jv
         ShUeArlb0jfatlhlDFByNvB2bPn503PcgL793POffLA6w+Zjcl2Tf3gqrCbGTW64v4C1
         dutPbWKpsnhwdNEplh1vUiJ/cBKzWY34wxa9W6MiaZh+NCFo7tMuPk3TgeA4SvN6lnv6
         rWKQ==
X-Gm-Message-State: APjAAAUm2oiCTS55iOc4p9TrYYklC11xAiqRiiU5aBNADEhw3jH9lBbr
        zPQ5xGPVVZ19ZYqqJi91BDT/t4CgsLV5RRyGTAHvFUncA0rkaahMJW1gFc4du9yPKqZV7VLuDE5
        0HEshp/Wym9e4
X-Received: by 2002:adf:f44e:: with SMTP id f14mr32811309wrp.290.1568278308860;
        Thu, 12 Sep 2019 01:51:48 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxZZE+RhkaLzAZJ36RWJxFit5DZtSqEtla93L8pUsJW8tO6EZdN+nW+/hJlyMkag7t70ajcQw==
X-Received: by 2002:adf:f44e:: with SMTP id f14mr32811294wrp.290.1568278308638;
        Thu, 12 Sep 2019 01:51:48 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q3sm7850196wrm.86.2019.09.12.01.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 01:51:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: Re: [PATCH] KVM: x86: work around leak of uninitialized stack contents
In-Reply-To: <20190912041817.23984-1-huangfq.daxian@gmail.com>
References: <20190912041817.23984-1-huangfq.daxian@gmail.com>
Date:   Thu, 12 Sep 2019 10:51:47 +0200
Message-ID: <87tv9hew2k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fuqian Huang <huangfq.daxian@gmail.com> writes:

> Emulation of VMPTRST can incorrectly inject a page fault
> when passed an operand that points to an MMIO address.
> The page fault will use uninitialized kernel stack memory
> as the CR2 and error code.
>
> The right behavior would be to abort the VM with a KVM_EXIT_INTERNAL_ERROR
> exit to userspace;

Hm, why so? KVM_EXIT_INTERNAL_ERROR is basically an error in KVM, this
is not a proper reaction to a userspace-induced condition (or ever).

I also looked at VMPTRST's description in Intel's manual and I can't
find and explicit limitation like "this must be normal memory". We're
just supposed to inject #PF "If a page fault occurs in accessing the
memory destination operand."

In case it seems to be too cumbersome to handle VMPTRST to MMIO and we
think that nobody should be doing that I'd rather prefer injecting #GP.

Please tell me what I'm missing :-)

>  however, it is not an easy fix, so for now just ensure
> that the error code and CR2 are zero.
>
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
> ---
>  arch/x86/kvm/x86.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 290c3c3efb87..7f442d710858 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5312,6 +5312,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
>  	/* kvm_write_guest_virt_system can pull in tons of pages. */
>  	vcpu->arch.l1tf_flush_l1d = true;
>  
> +	memset(exception, 0, sizeof(*exception));
>  	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
>  					   PFERR_WRITE_MASK, exception);
>  }

-- 
Vitaly
