Return-Path: <kvm+bounces-53115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8454EB0D7FC
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 13:15:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 712A47AEF01
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 11:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A622E2F1C;
	Tue, 22 Jul 2025 11:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="En2X7Xyr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786EB2E1C4E
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 11:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753182920; cv=none; b=sxj48MHFGUnaVpbgdXm1EF0le/UV6UsLtAKYHCqLzUXE2SV/BUxagKmggmKEF5E5UBYg4R0mCP4DgUNGpSUddLJHuGfx6ob9NLujKYgmAysTvJZ40KqnXu3cY96HyD9fStUrRMzxcTCtNbrc6XCWSOvFmTi+vYo0SRmr4FLTHSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753182920; c=relaxed/simple;
	bh=aLEJ6ZqhoL5hlEo6stfb7Q4Ui+vudmOYpxZgDNt9whI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XV62fPijqJfhXkfoRUVSFwdW5vlJA3XDnRkxpyCiuf9qPdXnjvwDH9542IrjO1MIPY7VoNSkB6kQFfTjlY0Uw2r2GuUPDeHj8H0l27wHdUDE8PPtZ+Cp60RScvwfbf1XiC17s7Er5o4KvRqRtHAO9Vf6PRLPzxrfN3Ovue/ySvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=En2X7Xyr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753182915;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=mt8jXBBN3/FYmXBz7vV+NEqaPPHu8BExBrX0Pgzpuc0=;
	b=En2X7XyrdsBaohEQhYrICd4tbqBSUE6hqM3dufjzbWplc/HdfN2JTCG06Kh7aTgc7cdCeA
	IXXBCZZWoAXM31xQxznUC4//GxCaIphxLLNgSQufTQQ579JtJsLgYvBBG3flWOCqW4UEZX
	Z9Yrz6eJSA/lPfdXO636Y2vBmhmO2cs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-487-2pTsa4eXMcO-_W4FgJzQLQ-1; Tue,
 22 Jul 2025 07:15:13 -0400
X-MC-Unique: 2pTsa4eXMcO-_W4FgJzQLQ-1
X-Mimecast-MFC-AGG-ID: 2pTsa4eXMcO-_W4FgJzQLQ_1753182912
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1DB11800C3F;
	Tue, 22 Jul 2025 11:15:11 +0000 (UTC)
Received: from redhat.com (dhcp-16-135.lcy.redhat.com [10.42.16.135])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FB3E180035E;
	Tue, 22 Jul 2025 11:15:09 +0000 (UTC)
Date: Tue, 22 Jul 2025 12:15:05 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Mathias Krause <minipli@grsecurity.net>, qemu-devel@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] i386/kvm: Disable hypercall patching quirk by default
Message-ID: <aH9yuVcUJQc4_-vP@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250619194204.1089048-1-minipli@grsecurity.net>
 <41a5767e-42d7-4877-9bc8-aa8eca6dd3e3@intel.com>
 <b8336828-ce72-4567-82df-b91d3670e26c@grsecurity.net>
 <3f58125c-183f-49e0-813e-d4cb1be724e8@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3f58125c-183f-49e0-813e-d4cb1be724e8@intel.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Jul 22, 2025 at 06:27:45PM +0800, Xiaoyao Li wrote:
> On 7/22/2025 5:21 PM, Mathias Krause wrote:
> > On 22.07.25 05:45, Xiaoyao Li wrote:
> > > On 6/20/2025 3:42 AM, Mathias Krause wrote:
> > > > KVM has a weird behaviour when a guest executes VMCALL on an AMD system
> > > > or VMMCALL on an Intel CPU. Both naturally generate an invalid opcode
> > > > exception (#UD) as they are just the wrong instruction for the CPU
> > > > given. But instead of forwarding the exception to the guest, KVM tries
> > > > to patch the guest instruction to match the host's actual hypercall
> > > > instruction. That is doomed to fail as read-only code is rather the
> > > > standard these days. But, instead of letting go the patching attempt and
> > > > falling back to #UD injection, KVM injects the page fault instead.
> > > > 
> > > > That's wrong on multiple levels. Not only isn't that a valid exception
> > > > to be generated by these instructions, confusing attempts to handle
> > > > them. It also destroys guest state by doing so, namely the value of CR2.
> > > > 
> > > > Sean attempted to fix that in KVM[1] but the patch was never applied.
> > > > 
> > > > Later, Oliver added a quirk bit in [2] so the behaviour can, at least,
> > > > conceptually be disabled. Paolo even called out to add this very
> > > > functionality to disable the quirk in QEMU[3]. So lets just do it.
> > > > 
> > > > A new property 'hypercall-patching=on|off' is added, for the very
> > > > unlikely case that there are setups that really need the patching.
> > > > However, these would be vulnerable to memory corruption attacks freely
> > > > overwriting code as they please. So, my guess is, there are exactly 0
> > > > systems out there requiring this quirk.
> > > 
> > > The default behavior is patching the hypercall for many years.
> > > 
> > > If you desire to change the default behavior, please at least keep it
> > > unchanged for old machine version. i.e., introduce compat_property,
> > > which sets KVMState->hypercall_patching_enabled to true.
> > 
> > Well, the thing is, KVM's patching is done with the effective
> > permissions of the guest which means, if the code in question isn't
> > writable from the guest's point of view, KVM's attempt to modify it will
> > fail. This failure isn't transparent for the guest as it sees a #PF
> > instead of a #UD, and that's what I'm trying to fix by disabling the quirk.
> > 
> > The hypercall patching was introduced in Linux commit 7aa81cc04781
> > ("KVM: Refactor hypercall infrastructure (v3)") in v2.6.25. Until then
> > it was based on a dedicated hypercall page that was handled by KVM to
> > use the proper instruction of the KVM module in use (VMX or SVM).
> > 
> > Patching code was fine back then, but the introduction of DEBUG_RO_DATA
> > made the patching attempts fail and, ultimately, lead to Paolo handle
> > this with commit c1118b3602c2 ("x86: kvm: use alternatives for VMCALL
> > vs. VMMCALL if kernel text is read-only").
> > 
> > However, his change still doesn't account for the cross-vendor live
> > migration case (Intel<->AMD), which will still be broken, causing the
> > before mentioned bogus #PF, which will just lead to misleading Oops
> > reports, confusing the poor souls, trying to make sense of it.
> > 
> > IMHO, there is no valid reason for still having the patching in place as
> > the .text of non-ancient kernel's  will be write-protected, making
> > patching attempts fail. And, as they fail with a #PF instead of #UD, the
> > guest cannot even handle them appropriately, as there was no memory
> > write attempt from its point of view. Therefore the default should be to
> > disable it, IMO. This won't prevent guests making use of the wrong
> > instruction from trapping, but, at least, now they'll get the correct
> > exception vector and can handle it appropriately.
> 
> But you don't accout for the case that guest kernel is built without
> CONFIG_STRICT_KERNEL_RWX enabled, or without CONFIG_DEBUG_RO_DATA, or for
> whatever reason the guest's text is not readonly, and the VM needs to be
> migrated among different vendors (Intel <-> AMD).
> 
> Before this patch, the above usecase works well. But with this patch, the
> guest will gets #UD after migrated to different vendors.
> 
> I heard from some small CSPs that they do want to the ability to live
> migrate VMs among Intel and AMD host.

Usually CSPs don't have full control over what their customers
are running as a guest. If their customers are running mainstream
modern guest OS, CONFIG_STRICT_KERNEL_RWX is pretty likely to be
set, so presumably migration between Intel & AMD will not work
and this isn't making it worse ?

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


