Return-Path: <kvm+bounces-34799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC3EDA060B6
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59DD8188B4B7
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A10201010;
	Wed,  8 Jan 2025 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UlN72y0v"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366DC201001;
	Wed,  8 Jan 2025 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736351365; cv=none; b=GD1xwr7v3O5Pc8X4NOogf8QWdOiszsj56Nl9y+MEtC2OJnOZ43WdN+leZv2J1leHWi+uuCf07MQKL8uFzwAu9zMmDAC6gZqnfZ7oaYFkgqr/GoVhw8yJRUIy5EtN61QwUt74J3oPrXCbGQH8RrHGIGMdv8vw3z/Uyz7WDoepI2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736351365; c=relaxed/simple;
	bh=v7UeBoyLTolleVweHlq1wyadk/ZBS+sSwmAlVrw+isg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UEFfh5T5zTqM3b16CJvagAADtNXJ/ZYhDUHDsL3OCPeu9/VWk6maDS49HT1VNxaeoEFmT1QIvVzxMKepvdae3omzMxOOqlfCebn3wcdi+eL+OwQT3bh+iCQz20gFsxzIMqOCIsvTG/WUrW5Xp73JhN6JWNhU4YmVPIdtwVzXZNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=UlN72y0v; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E667D40E0289;
	Wed,  8 Jan 2025 15:49:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id nGQrH2sZeuPb; Wed,  8 Jan 2025 15:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736351357; bh=FKLFHqVstYnb7mqdEEdDZr5ggvkuz2A+ZxYv5ZN2N7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UlN72y0vwIKCjurpVrAi6ZzzmVmQQ5dDW6SLB15B0WKZ1jyD665I+2ox0KO6m6Giv
	 qr4F/lEVO3WsUu0A58GXA9Fsn3Zp5mrk8clnmDNp98wrpDPzhYU2SdExS3hLmmzt1x
	 XEBIwBeahtgPsWbL+JjMydxpEVj7SHMcFEwA7SGPLpeeYdnvTak15a9lJ8mCL1Ax+q
	 TZ0mROl8AYAQfBCyC/wlkcgx4QPfcKcpTlHeElxK2M106LVA+wQTxaLLfgPaYSu7Bv
	 8OG6aqSDOpStFAkYxKcty7euSPZE53cE6jB39BydIOCguZTPcuNlajvWEqKxI6UiPR
	 7bJxzn2Le6KAu6VEVjTHuahZFKnnxdNfRpWTOx/QNNBrGCYULa82ZTZS6jeRehNTRY
	 3TnplIuLkN75JPqOZL9kVGOfZJf0tUC7uLCFtryP0BQzZ+yDFvyYScvu71ud5vKPsi
	 gP1wByMGkU0iYlbVrS0HqhSn/ZEjl5GMwiCUcANMK4kt21QZdkT7T93Mj4/FQ7EpUA
	 ziwLhqccqSdjgek4r5l98tIS2mfGEE/sRy9RyuymgO4WfGzMEUXhZCGZ60dPiOzrOj
	 cXJt7dEX+i5DCTmGlKE+VcXxA43V0g/qy2leaxVIvItSTtYtmnHPZEjmZsOqG1YZxd
	 6gDOkTpnvP/wQRcgY7KscgpA=
Received: from zn.tnic (p200300Ea971F938F329c23FFfEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:938f:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3443640E0286;
	Wed,  8 Jan 2025 15:49:09 +0000 (UTC)
Date: Wed, 8 Jan 2025 16:49:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
References: <20241202120416.6054-1-bp@kernel.org>
 <20241202120416.6054-4-bp@kernel.org>
 <Z1oR3qxjr8hHbTpN@google.com>
 <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com>
 <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
 <Z35_34GTLUHJTfVQ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z35_34GTLUHJTfVQ@google.com>

On Wed, Jan 08, 2025 at 05:38:39AM -0800, Sean Christopherson wrote:
> The "host" value will only be restored when the CPU exits to userspace, so if
> there are no userspace tasks running on those CPUs, i.e. nothing that forces them
> back to userspace, then it's expected for them to have the "guest" value loaded,
> even after the guest is long gone.  Unloading KVM effectively forces KVM to simulate
> a return to userspace and thus restore the host values.

Aha, makes sense.

> Hmm, mostly out of curiosity, what's the "workload"?

Oh, very very exciting: booting a guest! :-P

> And do you know what 0xd23f corresponds to?

How's that:

$ objdump -D arch/x86/kvm/kvm.ko
...
000000000000d1a0 <kvm_vcpu_halt>:
    d1a0:       e8 00 00 00 00          call   d1a5 <kvm_vcpu_halt+0x5>
    d1a5:       55                      push   %rbp
    ...

    d232:       e8 09 93 ff ff          call   6540 <kvm_vcpu_check_block>
    d237:       85 c0                   test   %eax,%eax
    d239:       0f 88 f6 01 00 00       js     d435 <kvm_vcpu_halt+0x295>
    d23f:       f3 90                   pause
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    d241:       e8 00 00 00 00          call   d246 <kvm_vcpu_halt+0xa6>
    d246:       48 89 c3                mov    %rax,%rbx
    d249:       e8 00 00 00 00          call   d24e <kvm_vcpu_halt+0xae>
    d24e:       84 c0                   test   %al,%al


Which makes sense :-)

> Yeah, especially if this is all an improvement over the existing mitigation.
> Though since it can impact non-virtualization workloads, maybe it should be a
> separately selectable mitigation?  I.e. not piggybacked on top of ibpb-vmexit?

Well, ibpb-on-vmexit is your typical cloud provider scenario where you address
the VM/VM attack vector by doing an IBPB on VMEXIT. This SRSO_MSR_FIX thing
protects the *host* from a malicious guest so you need both enabled for full
protection on the guest/host vector.

 (And yeah, I'm talking about attack vectors because this way of thinking about
  the mitigations will simplify stuff a lot:

  https://lore.kernel.org/r/20241105215455.359471-1-david.kaplan@amd.com
  )

Ok, lemme send a proper patch...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

