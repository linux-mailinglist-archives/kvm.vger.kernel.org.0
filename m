Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAD6436652
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhJUPeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:34:17 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36064 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhJUPeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 11:34:15 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EB6B31FD50;
        Thu, 21 Oct 2021 15:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634830318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXPwudmomqzIqQrwGaXyiAXLub/qasPhIndmnj6Vycs=;
        b=VNZ+cAUb1uxMz7nvY0ksOnREW+p6njGEeTVBlbXbCDFnkqveTJSin9Y0jtWrYLx52V8Hsd
        k/1NG0JVRU1xEf1qr0yC9iZZ0SsJTR5JBxLZ0Plx/DUgzOHWWj34ansfUrGeJr+OTzZ3FF
        nOpq7sl8Pgy2X6V1CznSwELhPAxN1jA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634830318;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXPwudmomqzIqQrwGaXyiAXLub/qasPhIndmnj6Vycs=;
        b=mBodyqUoS7Pu4V3oQzCZ2VWqrdsSfmo3Yzqq5LMVVuFuTMBlnRZ7ntJOmxr0Qwx+GzniUB
        Bu8rnHj+ti/obzCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D95AF13AE4;
        Thu, 21 Oct 2021 15:31:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YsmCNO6HcWFWWwAAMHmgww
        (envelope-from <bp@suse.de>); Thu, 21 Oct 2021 15:31:58 +0000
Date:   Thu, 21 Oct 2021 17:32:01 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <YXGH8Y/flJWCCrbt@zn.tnic>
References: <20211021133931.1a0e096b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211021133931.1a0e096b@canb.auug.org.au>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 01:39:31PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the kvm tree got a conflict in:
> 
>   arch/x86/kvm/x86.c
> 
> between commit:
> 
>   126fe0401883 ("x86/fpu: Cleanup xstate xcomp_bv initialization")
> 
> from the tip tree and commits:
> 
>   5ebbc470d7f3 ("KVM: x86: Remove defunct setting of CR0.ET for guests during vCPU create")
>   e8f65b9bb483 ("KVM: x86: Remove defunct setting of XCR0 for guest during vCPU create")
>   583d369b36a9 ("KVM: x86: Fold fx_init() into kvm_arch_vcpu_create()")
> 
> from the kvm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc arch/x86/kvm/x86.c
> index 04350680b649,3ea4f6ef2474..000000000000
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@@ -10615,10 -10687,10 +10590,9 @@@ int kvm_arch_vcpu_create(struct kvm_vcp
>   		pr_err("kvm: failed to allocate vcpu's fpu\n");
>   		goto free_user_fpu;
>   	}
>  -	fpstate_init(&vcpu->arch.guest_fpu->state);
>  -	if (boot_cpu_has(X86_FEATURE_XSAVES))
>  -		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
>  -			host_xcr0 | XSTATE_COMPACTION_ENABLED;
>  +
>  +	fpu_init_fpstate_user(vcpu->arch.user_fpu);
>  +	fpu_init_fpstate_user(vcpu->arch.guest_fpu);
> - 	fx_init(vcpu);
>   
>   	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>   	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);

LGTM too, thx Stephen!

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
