Return-Path: <kvm+bounces-71920-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QClpCpnbn2nEeQQAu9opvQ
	(envelope-from <kvm+bounces-71920-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 06:35:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 936211A10DD
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 06:35:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A4DD9306AEC7
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 05:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE1738A73F;
	Thu, 26 Feb 2026 05:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="phWNYzJq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ED92517AC;
	Thu, 26 Feb 2026 05:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772084107; cv=none; b=n+WWTxbUDLNApRGufQjzmW/fycnHOYTfGUkc/CfbH61YJEDm0Qr2aoYlf2JHt7oW9b71tjRmtmw3jsit3lFhRI35mt3lQKnHwap7KaHNUmauhryfHkbGRClHTh0yttVjY2nwDIRcgSol7ARx1rmFJSRgjywLkCCMSXx+qNmfSs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772084107; c=relaxed/simple;
	bh=UKleEny1/JQ6LsxuyQpxUdj8aXwYqz05GSLHZOSrMOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I92uzMOGUy88+VaeLP9io65lhhetH9j3o1SVkyCmkV6LB/MtDeDPPSOf5yIYodMMeoELhTyAYBg+c4lC6MQwXZfhTDjFp78yvueyGpGpmgrJ9oeQ2Iy3NkfYjY2L0fSDLrJ6YvIqZxPrh8dNSY+JObZ6N6Y7BzIht9NR0CfALBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=phWNYzJq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99077C19422;
	Thu, 26 Feb 2026 05:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772084106;
	bh=UKleEny1/JQ6LsxuyQpxUdj8aXwYqz05GSLHZOSrMOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=phWNYzJqrDHO6GiHb/abuN7mVdvd7ta4HvBjTwv9NRh38ftAFXHWtKTa/HycaapEp
	 0Op8LT3XHkLJgaPBmNAUpB+ShSJLAoVG2X0X5ja1McAwJ7z/a8p8chNM5Hy3JTf+av
	 O9zKWbvUwaTt4MEFVEWrKMAChwQKTyljHAkn74hvjbYWIxxla98W1/BkhSs73moYWi
	 Nh9KwiqBqrJ5Z+Uras2Kc2TUkYS7lW2PzaGGYcZYxBAnw7GSZqJo8XY/Nm7OAauOqV
	 pNnwIBKYp6f3WJ2mjvwNCaul7M5WwsdmPAW3Z6KMexWF5BKVMl8c0mnlfjmy7JHA3x
	 /LlbY1Thp/Orw==
Date: Thu, 26 Feb 2026 11:05:01 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Gal Pressman <gal@nvidia.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH v2 1/2] KVM: SVM: Fix UBSAN warning when reading avic
 parameter
Message-ID: <aZ_bb_1cSwqYn1W6@blrnaveerao1>
References: <20260225145050.2350278-1-gal@nvidia.com>
 <20260225145050.2350278-2-gal@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225145050.2350278-2-gal@nvidia.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71920-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naveen@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nvidia.com:email]
X-Rspamd-Queue-Id: 936211A10DD
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 04:50:49PM +0200, Gal Pressman wrote:
> The avic parameter is stored as an int to support the special value -1
> (AVIC_AUTO_MODE), but the cited commit changed it from bool to int while
> keeping param_get_bool() as the getter function.
> This causes UBSAN to report "load of value 255 is not a valid value for
> type '_Bool'" when the parameter is read via sysfs.
> 
> The issue happens in two scenarios:
> 
> 1. During module load: There's a time window between when module
>    parameters are registered, and when avic_hardware_setup() runs to
>    resolve the value, where the value is -1.
> 
> 2. On non-AMD systems: On non-AMD hardware, the kvm_is_svm_supported()
>    check returns early. The avic_hardware_setup() function never runs,
>    so avic remains -1.
> 
> Fix that by implementing a getter function that properly reads and
> converts the -1 value into a string.
> 
> Triggered by sos report:
>   UBSAN: invalid-load in kernel/params.c:323:33
>   load of value 255 is not a valid value for type '_Bool'
>   CPU: 0 UID: 0 PID: 4667 Comm: sos Not tainted 6.19.0-rc5net_mlx5_1e86836 #1 NONE
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x69/0xa0
>    ubsan_epilogue+0x5/0x2b
>    __ubsan_handle_load_invalid_value.cold+0x47/0x4c
>    ? lock_acquire+0x219/0x2c0
>    param_get_bool.cold+0xf/0x14
>    param_attr_show+0x51/0x80
>    module_attr_show+0x19/0x30
>    sysfs_kf_seq_show+0xac/0xf0
>    seq_read_iter+0x100/0x410
>    copy_splice_read+0x1b4/0x360
>    splice_direct_to_actor+0xbd/0x270
>    ? wait_for_space+0xb0/0xb0
>    do_splice_direct+0x72/0xb0
>    ? propagate_umount+0x870/0x870
>    do_sendfile+0x3a3/0x470
>    __x64_sys_sendfile64+0x5e/0xe0
>    do_syscall_64+0x70/0x8c0
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
> 
> Fixes: ca2967de5a5b ("KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC is support")
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> ---
>  arch/x86/kvm/svm/avic.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)

LGTM.
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen


