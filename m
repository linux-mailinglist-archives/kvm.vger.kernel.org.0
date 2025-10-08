Return-Path: <kvm+bounces-59637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEF5BC48CC
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 13:26:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 006254F07BA
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 11:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2979B2F618B;
	Wed,  8 Oct 2025 11:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Av2DtcjJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F03021767A
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 11:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759922751; cv=none; b=pTiU+8MkCK6Wg0AhrkBPuu/lt5LjdI1dJfgP/LhQvFLxMlox+dEP0fWLc1bD8JJWVUyPah77La3BH30SikJ4WBIhJfJTdgWZc5D/KdyZzc3owa0cIuhC+v3IVk0pB+fzwRHwGuYivAX12oApMQhaUlyqvMF9B+EldDZtR6qPcek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759922751; c=relaxed/simple;
	bh=aFEhoYDAhCVC6PyY8ZrlUZht3yUsY0wyaIhThtFLA4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FSynmQy/VsI72LlSgDa8ypxZMdGMgXV7+9nkP27XV6GLwAjujaNHzPvUdstq/37LOjNfXJkh0qD52nI+Ex53I054ZaEM6DpTandEgHzL+nRzQe02MM6Y+4p6H9mardHqqcYJpDIE9rDIVUeYlBFQtL1hbMTaEnUmwfuImf0WTfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Av2DtcjJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678EEC4CEF4;
	Wed,  8 Oct 2025 11:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759922750;
	bh=aFEhoYDAhCVC6PyY8ZrlUZht3yUsY0wyaIhThtFLA4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Av2DtcjJQmsP+YtQHGNjSsL2X+ntVZ/zYB68yCy6zRaNnwSBw7/LsFpAh30eUwfYP
	 DLjjKVoaAUs7SvEAYnvu9AnAI4BTWJmZ+pzaLw9VQVGIan0Pmd9LnT3Na4mpJ5H097
	 14Aq2c2t1BQAIOZzP830CW84W1Qe1aw2BM6eM1Dd8iREnxI60HyrIj54WN2yrmazc8
	 CcajtzX+jVUFqIuJE0bq+QHRZVMZejtVjDWHex8mdE0HSSVBXdm8/2EIcgZA3hV/eW
	 2cM4BRdjLu6apGvFSQ5j/MMfdSvkMxfdNrJp1I7UXjuNX732+huzTboXLdSg961bYL
	 RtnCQV1I6Nbrw==
Date: Wed, 8 Oct 2025 15:22:52 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org, Nikunj A Dadhania <nikunj@amd.com>, 
	"Daniel P. Berrange" <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: Re: [PATCH v2 8/9] target/i386: SEV: Add support for setting TSC
 frequency for Secure TSC
Message-ID: <uzfmnzzhz7a7lghdpazb2sphtctphmsj2nyfqnu6erjt44h577@bjj57um7n2ze>
References: <cover.1758794556.git.naveen@kernel.org>
 <65400881e426aa0e412eb431099626dceb145ddd.1758794556.git.naveen@kernel.org>
 <6a9ce7bb-5c69-ad8b-8bfd-638122619c71@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9ce7bb-5c69-ad8b-8bfd-638122619c71@amd.com>

On Tue, Oct 07, 2025 at 08:31:47AM -0500, Tom Lendacky wrote:
> On 9/25/25 05:17, Naveen N Rao (AMD) wrote:

...

> > +
> > +static void
> > +sev_snp_guest_set_tsc_frequency(Object *obj, Visitor *v, const char *name,
> > +                                void *opaque, Error **errp)
> > +{
> > +    uint32_t value;
> > +
> > +    if (!visit_type_uint32(v, name, &value, errp)) {
> > +        return;
> > +    }
> > +
> > +    SEV_SNP_GUEST(obj)->tsc_khz = value / 1000;
> 
> This will cause a value that isn't evenly divisible by 1000 to be
> rounded down, e.g.: tsc-frequency=2500000999. Should this name instead
> just be tsc-khz or secure-tsc-khz (to show it is truly associated with
> Secure TSC)?

I modeled this after the existing tsc-frequency parameter on the cpu 
object to keep it simple (parameter is the same, just where it is 
specified differs). This also aligns with TDX which re-uses the 
tsc-frequency parameter on the cpu object.

> 
> Also, I think there is already a "tsc-freq" parameter for the -cpu
> parameter (?), should there be some kind of error message if both of
> these are set? Or a warning saying it is being ignored? Or ...?

This is validated when the TSC frequency is being set on the vcpu, so I didn't
add an explicit check.

As an example, with:
  -cpu EPYC-v4,tsc-frequency=2500000000 \
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on

qemu-system-x86_64: warning: TSC frequency mismatch between VM (2500000 kHz) and host (2596099 kHz), and TSC scaling unavailable
qemu-system-x86_64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument


Thanks,
Naveen


