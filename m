Return-Path: <kvm+bounces-71270-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KMogOB4nlmnxbQIAu9opvQ
	(envelope-from <kvm+bounces-71270-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:54:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D57915998C
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:54:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 44D4E3020FDF
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 20:54:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F2B349B02;
	Wed, 18 Feb 2026 20:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="txRKTC99"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53F4311972;
	Wed, 18 Feb 2026 20:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771448084; cv=none; b=uZQrUEEbW+ZdhuDy4kjvQJmuCMYPQt4Xop3fUa0UQVFSRYIVZBi0dzW6UAQtajhnhJkfA+HHlu6twLDY6uS8fl3M+Aj2njcnlgGcNX3vL0msku08+DNFgDqoWsPTiA5YNKvVM8gwPAQ5zEcVCaubP7oN4sMQqoRgszTqxYdjgSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771448084; c=relaxed/simple;
	bh=NSU5ZxTFZs+vcgV4zbWJc+O5FYAL+ah44/3CcMJAvog=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=ffnhUSA+7uyQtoMwtFBviBh2yKgGdztRKwXZFdvbcJSBUsd0RjddiQKMHWM7lFyRmdda+u/xSmsTTKmeUa0wn5ko+1lOiryOUR4CTj30B46VW3tKRxfU46+jLYaC9jurfaEjmOQjrWRVEGLb/7doQEXXDpFS/QB5EHjOh4J1i/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=txRKTC99; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61IKbu3I2307125
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 18 Feb 2026 12:37:56 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61IKbu3I2307125
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1771447078;
	bh=/4gUyx2Ogqc4pykP2NXlf3ww6HtU65MDbCy+ciTKta0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=txRKTC99yxQoQhaycyi7tJEOgs9h1U2j5kNLU2/1fwUwtmdQCUwUeEffkAabj72/F
	 ukff8fZVPMHYRTwmPLaZZGgZSRPefZOtaglDoqq/xRMxcmW0y0HbctJr8LQsjWYLQK
	 O6BowOLQ73YDd32xR02o7iliOviwQfGShMkbSfNL1NNO3hDb124q5coP7LtTukCrv8
	 eFIsqBvQBtd8mP5roCm/HLGwm3E5AbDDDTSL/htD5wmZD5oyabOgyU4N/H2+l29yfi
	 tegGzouqXoi0lCfrG4Cfb4XcWEQvgvnEJNiY8Xg+H/e8oJU5xeLp+CxABvSA1teX2D
	 ggrrWY1MeeKrQ==
Date: Wed, 18 Feb 2026 12:37:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        llvm@lists.linux.dev
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Kiryl Shutsemau <kas@kernel.org>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, Ajay Kaher <ajay.kaher@broadcom.com>,
        Alexey Makhalov <alexey.makhalov@broadcom.com>,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Xin Li <xin@zytor.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>, andy.cooper@citrix.com
Subject: Re: [PATCH v3 00/16] x86/msr: Inline rdmsr/wrmsr instructions
User-Agent: K-9 Mail for Android
In-Reply-To: <20260218082133.400602-1-jgross@suse.com>
References: <20260218082133.400602-1-jgross@suse.com>
Message-ID: <3D1FE2A7-F237-4232-9E39-6AFC75F3A4F0@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026012301];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71270-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,redhat.com,alien8.de,linux.intel.com,intel.com,google.com,microsoft.com,oracle.com,lists.xenproject.org,broadcom.com,infradead.org,zytor.com,gmail.com,citrix.com];
	RCPT_COUNT_TWELVE(0.00)[36];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hpa@zytor.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[zytor.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,lkml];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,zytor.com:mid,zytor.com:dkim,suse.com:email]
X-Rspamd-Queue-Id: 5D57915998C
X-Rspamd-Action: no action

On February 18, 2026 12:21:17 AM PST, Juergen Gross <jgross@suse=2Ecom> wro=
te:
>When building a kernel with CONFIG_PARAVIRT_XXL the paravirt
>infrastructure will always use functions for reading or writing MSRs,
>even when running on bare metal=2E
>
>Switch to inline RDMSR/WRMSR instructions in this case, reducing the
>paravirt overhead=2E
>
>The first patch is a prerequisite fix for alternative patching=2E Its
>is needed due to the initial indirect call needs to be padded with
>NOPs in some cases with the following patches=2E
>
>In order to make this less intrusive, some further reorganization of
>the MSR access helpers is done in the patches 1-6=2E
>
>The next 4 patches are converting the non-paravirt case to use direct
>inlining of the MSR access instructions, including the WRMSRNS
>instruction and the immediate variants of RDMSR and WRMSR if possible=2E
>
>Patches 11-13 are some further preparations for making the real switch
>to directly patch in the native MSR instructions easier=2E
>
>Patch 14 is switching the paravirt MSR function interface from normal
>call ABI to one more similar to the native MSR instructions=2E
>
>Patch 15 is a little cleanup patch=2E
>
>Patch 16 is the final step for patching in the native MSR instructions
>when not running as a Xen PV guest=2E
>
>This series has been tested to work with Xen PV and on bare metal=2E
>
>Note that there is more room for improvement=2E This series is sent out
>to get a first impression how the code will basically look like=2E

Does that mean you are considering this patchset an RFC? If so, you should=
 put that in the subject header=2E=20

>Right now the same problem is solved differently for the paravirt and
>the non-paravirt cases=2E In case this is not desired, there are two
>possibilities to merge the two implementations=2E Both solutions have
>the common idea to have rather similar code for paravirt and
>non-paravirt variants, but just use a different main macro for
>generating the respective code=2E For making the code of both possible
>scenarios more similar, the following variants are possible:
>
>1=2E Remove the micro-optimizations of the non-paravirt case, making
>   it similar to the paravirt code in my series=2E This has the
>   advantage of being more simple, but might have a very small
>   negative performance impact (probably not really detectable)=2E
>
>2=2E Add the same micro-optimizations to the paravirt case, requiring
>   to enhance paravirt patching to support a to be patched indirect
>   call in the middle of the initial code snipplet=2E
>
>In both cases the native MSR function variants would no longer be
>usable in the paravirt case, but this would mostly affect Xen, as it
>would need to open code the WRMSR/RDMSR instructions to be used
>instead the native_*msr*() functions=2E
>
>Changes since V2:
>- switch back to the paravirt approach
>
>Changes since V1:
>- Use Xin Li's approach for inlining
>- Several new patches
>
>Juergen Gross (16):
>  x86/alternative: Support alt_replace_call() with instructions after
>    call
>  coco/tdx: Rename MSR access helpers
>  x86/sev: Replace call of native_wrmsr() with native_wrmsrq()
>  KVM: x86: Remove the KVM private read_msr() function
>  x86/msr: Minimize usage of native_*() msr access functions
>  x86/msr: Move MSR trace calls one function level up
>  x86/opcode: Add immediate form MSR instructions
>  x86/extable: Add support for immediate form MSR instructions
>  x86/msr: Use the alternatives mechanism for WRMSR
>  x86/msr: Use the alternatives mechanism for RDMSR
>  x86/alternatives: Add ALTERNATIVE_4()
>  x86/paravirt: Split off MSR related hooks into new header
>  x86/paravirt: Prepare support of MSR instruction interfaces
>  x86/paravirt: Switch MSR access pv_ops functions to instruction
>    interfaces
>  x86/msr: Reduce number of low level MSR access helpers
>  x86/paravirt: Use alternatives for MSR access with paravirt
>
> arch/x86/coco/sev/internal=2Eh              |   7 +-
> arch/x86/coco/tdx/tdx=2Ec                   |   8 +-
> arch/x86/hyperv/ivm=2Ec                     |   2 +-
> arch/x86/include/asm/alternative=2Eh        |   6 +
> arch/x86/include/asm/fred=2Eh               |   2 +-
> arch/x86/include/asm/kvm_host=2Eh           |  10 -
> arch/x86/include/asm/msr=2Eh                | 345 ++++++++++++++++------
> arch/x86/include/asm/paravirt-msr=2Eh       | 148 ++++++++++
> arch/x86/include/asm/paravirt=2Eh           |  67 -----
> arch/x86/include/asm/paravirt_types=2Eh     |  57 ++--
> arch/x86/include/asm/qspinlock_paravirt=2Eh |   4 +-
> arch/x86/kernel/alternative=2Ec             |   5 +-
> arch/x86/kernel/cpu/mshyperv=2Ec            |   7 +-
> arch/x86/kernel/kvmclock=2Ec                |   2 +-
> arch/x86/kernel/paravirt=2Ec                |  42 ++-
> arch/x86/kvm/svm/svm=2Ec                    |  16 +-
> arch/x86/kvm/vmx/tdx=2Ec                    |   2 +-
> arch/x86/kvm/vmx/vmx=2Ec                    |   8 +-
> arch/x86/lib/x86-opcode-map=2Etxt           |   5 +-
> arch/x86/mm/extable=2Ec                     |  35 ++-
> arch/x86/xen/enlighten_pv=2Ec               |  52 +++-
> arch/x86/xen/pmu=2Ec                        |   4 +-
> tools/arch/x86/lib/x86-opcode-map=2Etxt     |   5 +-
> tools/objtool/check=2Ec                     |   1 +
> 24 files changed, 576 insertions(+), 264 deletions(-)
> create mode 100644 arch/x86/include/asm/paravirt-msr=2Eh
>

Could you clarify *on the high design level* what "go back to the paravirt=
 approach" means, and the motivation for that?

Note that for Xen *most* MSRs fall in one of two categories: those that ar=
e dropped entirely and those that are just passed straight on to the hardwa=
re=2E

I don't know if anyone cares about optimizing PV Xen anymore, but at least=
 in theory Xen can un-paravirtualize most sites=2E

