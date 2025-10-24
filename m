Return-Path: <kvm+bounces-61023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A55F5C069C2
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 16:05:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 681421C20689
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 14:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C33F731D36A;
	Fri, 24 Oct 2025 14:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gLLrpYfY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A4D2D47F3
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 14:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761314744; cv=none; b=RDmEVZeQGYoLjSLzKr67sJNVObGp0JPPdd8Z5urtsP7S+eIo4qHmrKQbTNyhwnskcsVqk0HMcSgwkvT+lyT83ewapx8eoDw6313pxCUx3KoYKqswJf+m3d1i/+x/3ITHuxDGZTdnFwvkzFSuHYVDGX1kt4+q8IVte/ya+boOSV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761314744; c=relaxed/simple;
	bh=kEPbTDZac7CjluEtE5j18ISVJGK6g6nGBRg4GbTVTXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LveMH9/Oa9ZLUZsRa5Ju5yXyAic1Oj/gjL8gkwYN3p2jAOlGw0xt/bUKDGuQis/rqXslNjVyOwtuUJS0okCRLJgXdMujsbZB3QGXlNyynOSBrAMjZ18L9dCO/lrc+tjCHq+aLUcmiBJiAZGoVye89sC4ZP84qWjOqtLUfs8zF+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gLLrpYfY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078E3C4CEF1;
	Fri, 24 Oct 2025 14:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761314743;
	bh=kEPbTDZac7CjluEtE5j18ISVJGK6g6nGBRg4GbTVTXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gLLrpYfYY+N8x2bnVbq/kQ4p3chpY7BnLHMvtGumF3h8HRl8eVqyWRcU+EmcHioQe
	 crgRy0hCv9eZTpp1z8PuHIJPDPmWtI0VslXA12NzWqAICWUx5AquXcNiybjNAfUdOS
	 KKuaz5t5WXPbMfXAKs9EEHWQy07XKse3D4gq0GloinbaWYlSTapWV7mxS5UKgucidW
	 AxsSGlztFyXCzEHLbpmHJb/aAOFnXOgcYPrw56D/1FmmtShIFnioWdn0ZwGvq50Ztd
	 IYcdN5uNDFyZvKnUWUj29x/RPAZQ9i2NZOaQkKQvidq79mm+H6v9sPrNGl7Qm8mS4p
	 9gjFHC3i2fQ/Q==
Date: Fri, 24 Oct 2025 19:29:01 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	"Daniel P. Berrange" <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: Re: [PATCH v2 0/9] target/i386: SEV: Add support for enabling VMSA
 SEV features
Message-ID: <tu7zyirbskj7gfr3mrwt6wlezslthrzbzvvmuszubvfvclcdhc@oxsy3cjmicoz>
References: <cover.1758794556.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1758794556.git.naveen@kernel.org>

On Thu, Sep 25, 2025 at 03:47:29PM +0530, Naveen N Rao (AMD) wrote:
> This series adds support for enabling VMSA SEV features for SEV-ES and
> SEV-SNP guests. Since that is already supported for IGVM files, some of
> that code is moved to generic path and reused.
> 
> Debug-swap is already supported in KVM today, while patches for enabling
> Secure TSC have been accepted for the upcoming kernel release.

Any other comments on this series?

So far, the only minor change I have on top of this series is the change 
suggested by Markus:

diff --git a/qapi/qom.json b/qapi/qom.json
index 5b830a9ba000..a2b9ccdfe43e 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1010,7 +1010,8 @@
 #     designated guest firmware page for measured boot with -kernel
 #     (default: false) (since 6.2)
 #
-# @debug-swap: enable virtualization of debug registers
+# @debug-swap: enable virtualization of debug registers. This is only
+#     supported on SEV-ES/SEV-SNP guests
 #     (default: false) (since 10.2)
 #
 # Since: 9.1

Otherwise, this series still applies cleanly to current master.

> 
> Roy,
> I haven't been able to test IGVM, so would be great if that is tested to 
> confirm there are no unintended changes there.

I took a stab at this with the buildigvm tool from Roy. I am able to 
boot a Linux guest with an IGVM file generated from that using qemu 
built with this series applied. In addition, with the below change to 
buildigvm, I am able to see Secure TSC being enabled in the guest:

diff --git a/src/vmsa.rs b/src/vmsa.rs
index 3d67a953055e..ac150264c244 100644
--- a/src/vmsa.rs
+++ b/src/vmsa.rs
@@ -70,6 +70,7 @@ fn construct_vmsa(reset_addr: u32, platform: Platform) -> Result<Box<SevVmsa>, B

     if let Platform::SevSnp = platform {
         vmsa.sev_features.set_snp(true);
+        vmsa.sev_features.set_secure_tsc(true);
     }

     Ok(vmsa_box)

I couldn't get it to work with > 1 vCPUs though (I'm possibly missing 
OVMF changes or such).


- Naveen


