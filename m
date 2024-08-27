Return-Path: <kvm+bounces-25151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7021F960B7A
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:13:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D04128607B
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 13:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A95D19EED3;
	Tue, 27 Aug 2024 13:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We6EHxD7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3BC1BA875;
	Tue, 27 Aug 2024 13:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764213; cv=none; b=rOxGaP1oSBKh+S4MXjzDrM3XMhZO2fRzv/01VZrRPl6i52wSaNfLGEliTfjnias1GtHMT9Nc6E2eUUhIZe/K+xE1sLc32GM99p9xe3y6YjXSRWMvWk7zBL8YrcWrXiSPi1YGmOgYlapFKVhQwVavu2hDV6CxjX9iDgukvut3smE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764213; c=relaxed/simple;
	bh=2huZQ9X3XwSEo8LeL5E6EMGsFsv20dAkqIQdgKsmyfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UZ4Lnky6fT1/Znx01p5OYo+RbnHGgAhyFOIuQBOL7x9ErZGp8xtK6qmCHFIsoGArqkVAFlIyF3N9r2BpviuEH/2jGxEGwziyS7iOFECCI9EZ0Amc8+iCDv70EcQiEtjkEu1aI2mTC6+g0VCsUamKjXyh1t/vvth3RG+Pxy12s6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We6EHxD7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EE9C61047;
	Tue, 27 Aug 2024 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724764213;
	bh=2huZQ9X3XwSEo8LeL5E6EMGsFsv20dAkqIQdgKsmyfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=We6EHxD7WtHu+7vU4VpLYXWAPrJWszHtp0QDTBeln/dC5Doa9HUg+Uc41tS6mRX+h
	 x82DeaG92201rsMH7L1vdBFRQgJ28+IHO4Qgt1SGgdXC+mu5ezwybSQhbYCZQ+e94M
	 apFgl6Y52xqq4vcCOnVMwNjnnfA7301fbuwMlFhY=
Date: Tue, 27 Aug 2024 15:10:10 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: David Hunter <david.hunter.linux@gmail.com>
Cc: seanjc@google.com, dave.hansen@linux.intel.com, hpa@zytor.com,
	javier.carrasco.cruz@gmail.com, jmattson@google.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	lirongqing@baidu.com, pbonzini@redhat.com, pshier@google.com,
	shuah@kernel.org, stable@vger.kernel.org, x86@kernel.org,
	Haitao Shan <hshan@google.com>
Subject: Re: [PATCH 6.1.y 2/2 V2] KVM: x86: Fix lapic timer interrupt lost
 after loading a snapshot.
Message-ID: <2024082759-theatrics-sulk-85f2@gregkh>
References: <ZsSiQkQVSz0DarYC@google.com>
 <20240826221336.14023-1-david.hunter.linux@gmail.com>
 <20240826221336.14023-3-david.hunter.linux@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826221336.14023-3-david.hunter.linux@gmail.com>

On Mon, Aug 26, 2024 at 06:13:36PM -0400, David Hunter wrote:
> 
> [ Upstream Commit 9cfec6d097c607e36199cf0cfbb8cf5acbd8e9b2]

This is already in the 6.1.66 release, so do you want it applied again?

> From: Haitao Shan <hshan@google.com>
> Date:   Tue Sep 12 16:55:45 2023 -0700 
> 
> When running android emulator (which is based on QEMU 2.12) on
> certain Intel hosts with kernel version 6.3-rc1 or above, guest
> will freeze after loading a snapshot. This is almost 100%
> reproducible. By default, the android emulator will use snapshot
> to speed up the next launching of the same android guest. So
> this breaks the android emulator badly.
> 
> I tested QEMU 8.0.4 from Debian 12 with an Ubuntu 22.04 guest by
> running command "loadvm" after "savevm". The same issue is
> observed. At the same time, none of our AMD platforms is impacted.
> More experiments show that loading the KVM module with
> "enable_apicv=false" can workaround it.
> 
> The issue started to show up after commit 8e6ed96cdd50 ("KVM: x86:
> fire timer when it is migrated and expired, and in oneshot mode").
> However, as is pointed out by Sean Christopherson, it is introduced
> by commit 967235d32032 ("KVM: vmx: clear pending interrupts on
> KVM_SET_LAPIC"). commit 8e6ed96cdd50 ("KVM: x86: fire timer when
> it is migrated and expired, and in oneshot mode") just makes it
> easier to hit the issue.
> 
> Having both commits, the oneshot lapic timer gets fired immediately
> inside the KVM_SET_LAPIC call when loading the snapshot. On Intel
> platforms with APIC virtualization and posted interrupt processing,
> this eventually leads to setting the corresponding PIR bit. However,
> the whole PIR bits get cleared later in the same KVM_SET_LAPIC call
> by apicv_post_state_restore. This leads to timer interrupt lost.
> 
> The fix is to move vmx_apicv_post_state_restore to the beginning of
> the KVM_SET_LAPIC call and rename to vmx_apicv_pre_state_restore.
> What vmx_apicv_post_state_restore does is actually clearing any
> former apicv state and this behavior is more suitable to carry out
> in the beginning.
> 
> Fixes: 967235d32032 ("KVM: vmx: clear pending interrupts on KVM_SET_LAPIC")
> Cc: stable@vger.kernel.org
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Haitao Shan <hshan@google.com>
> Link: https://lore.kernel.org/r/20230913000215.478387-1-hshan@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> (Cherry-Picked from commit 9cfec6d097c607e36199cf0cfbb8cf5acbd8e9b2)
> Signed-off-by: David Hunter <david.hunter.linux@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 87abf4eebf8a..4040075bbd5a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8203,6 +8203,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.load_eoi_exitmap = vmx_load_eoi_exitmap,
>  	.apicv_pre_state_restore = vmx_apicv_pre_state_restore,
>  	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
> +	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
>  	.hwapic_irr_update = vmx_hwapic_irr_update,
>  	.hwapic_isr_update = vmx_hwapic_isr_update,
>  	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,

Wait, this is just one hunk?  This feels wrong, you didn't say why you
modfied this from the original commit, or backport, what was wrong with
that?

thanks,

greg k-h

