Return-Path: <kvm+bounces-33389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D7A9EA8F6
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 07:53:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09EC01889624
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 06:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 434C922CBE0;
	Tue, 10 Dec 2024 06:53:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E1B1D7E31;
	Tue, 10 Dec 2024 06:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733813613; cv=none; b=AzkSIoCE5qyKOnneC5bSeML17sSdbwsFpDS9aN34BqXVfF1un2ngdvBlyxWgNBh/o2IUOh6fHWceYUG2vnY4lS8MJhrBybW229FIMLXEK+kQbHUXwcEN6shqwmW0Nv1MdEqXRQI+RqcA3UHl+UeaPxiBOBLoZUmH73/jMXU3PkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733813613; c=relaxed/simple;
	bh=wVzmiXJnPULuK6Oa13N1YpzyRmHVfYBzuS8aODqslhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxZFKgCA5+97sBYQ7sjEJBqDZk1L2o2an/ZWnWG0xl2GBK5PF7Ud1OuQMaBTAEhsqkU72qzJzEY+5RslbGfrxfnhi428ftQqllW5DoGKZTftjenmtQVCEfjIzDaCIzTtYChbQAPHyXT6v5sDXZNy3GpSuYH1mveFKwtSYc99lT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFA5C4CEDD;
	Tue, 10 Dec 2024 06:53:33 +0000 (UTC)
Date: Mon, 9 Dec 2024 22:53:31 -0800
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Borislav Petkov <bp@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: Re: [PATCH v2 1/4] x86/bugs: Add SRSO_USER_KERNEL_NO support
Message-ID: <20241210065331.ojnespi77no7kfqf@jpoimboe>
References: <20241202120416.6054-1-bp@kernel.org>
 <20241202120416.6054-2-bp@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241202120416.6054-2-bp@kernel.org>

On Mon, Dec 02, 2024 at 01:04:13PM +0100, Borislav Petkov wrote:
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -2615,6 +2615,11 @@ static void __init srso_select_mitigation(void)
>  		break;
>  
>  	case SRSO_CMD_SAFE_RET:
> +		if (boot_cpu_has(X86_FEATURE_SRSO_USER_KERNEL_NO)) {
> +			pr_notice("CPU user/kernel transitions protected, falling back to IBPB-on-VMEXIT\n");
> +			goto ibpb_on_vmexit;

The presence of SRSO_USER_KERNEL_NO should indeed change the default,
but if the user requests "safe_ret" specifically, shouldn't we give it
to them?  That would be more consistent with how we handle requested
mitigations.

Also it doesn't really make sense to add a printk here as the mitigation
will be printed at the end of the function.

-- 
Josh

