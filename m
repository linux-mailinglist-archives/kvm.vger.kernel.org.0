Return-Path: <kvm+bounces-61817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A7A3C2B34C
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 12:00:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D57F34E7820
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 11:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2584F2FE58F;
	Mon,  3 Nov 2025 11:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AhLcoQGI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C65A34D38E
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 11:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762167647; cv=none; b=aHEI+aNc0OEvQ7N53v11OfQsFqfzi4I+UsPMqbBLu3jHol9qPGr8DOheJFXPl6Ct/7UTKxsEwS+JbZk7z8zqfxfviiae/OVM1+/WUV0qP9E1ZltjJtcJ82egIGitsr7kX7pCo4mNL4mRf8QsbKJBgq9WHW2GQqPqqU1hOKLZZ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762167647; c=relaxed/simple;
	bh=7KlQ6SyNHBa4lk3dkpiYR4iscB2B68Q7KOAeVXNjiSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b5rDOKSQOg63YSFHXcy9WzIGnB9FvpvRQN6qFFbbTKUaV9mwUrWzemDxDo0BJuQIgztK9CIoYWQIE+G3OwIj5+x9E7IeqheKoEMnYCDtstecdqPNUcmOYZmKlCjb/j3JaYPaE7D8DMUR3tDVZKqa05A8+YgkjT/cOuLxsaw39VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AhLcoQGI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F806C4CEE7;
	Mon,  3 Nov 2025 11:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762167646;
	bh=7KlQ6SyNHBa4lk3dkpiYR4iscB2B68Q7KOAeVXNjiSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AhLcoQGIUn+XILCnMIYp24uIaR3p69oXI/V6fr2s4n4Ec3dMk6596cJc8JewLsa4h
	 KH5DwHU+y64yKfd8NNeimWaZw1szCfwTuusS6gzNKNATMviBmyE+MoOdp3QnN28hIR
	 3E0UeStC9All56Gp2pdVeTWwenSKVRqubFlPtJ2+pS1KuzMH3B2FH0RmZ/TnN2nNyk
	 EMt7J7LPi9rFPVn+cmbUk3Bv/t5UvugJbWayoVuYrfsVT6o76K8yFJd0epMFsa1XJX
	 1sQkHZGC+JKDimTmCwtmVY/gilo49irmmg9oPAnPj9OcsFleJisA43gCgRZCIYaAar
	 1djVvz8IQq03g==
Date: Mon, 3 Nov 2025 16:25:02 +0530
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
Message-ID: <hbfmcwhus6oyggzfrjz3rdkdrzfmeeuab45bnipta2bo5wj6z3@os4yj4ywoahn>
References: <cover.1758794556.git.naveen@kernel.org>
 <65400881e426aa0e412eb431099626dceb145ddd.1758794556.git.naveen@kernel.org>
 <6a9ce7bb-5c69-ad8b-8bfd-638122619c71@amd.com>
 <uzfmnzzhz7a7lghdpazb2sphtctphmsj2nyfqnu6erjt44h577@bjj57um7n2ze>
 <a8a324ba-e474-4733-b998-7d36be06b7f7@amd.com>
 <boyf3kr7uo7jnlratgmgaklm2a4leg37hsgfno5ywsl6qvbcvo@5dwlbncvaogv>
 <acb88951-b46f-4a08-8cd7-4e2d20e153f4@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acb88951-b46f-4a08-8cd7-4e2d20e153f4@amd.com>

On Tue, Oct 28, 2025 at 10:11:13AM -0500, Tom Lendacky wrote:
> On 10/24/25 12:16, Naveen N Rao wrote:
> > On Fri, Oct 24, 2025 at 10:00:08AM -0500, Tom Lendacky wrote:
> >> On 10/8/25 04:52, Naveen N Rao wrote:
> >>> On Tue, Oct 07, 2025 at 08:31:47AM -0500, Tom Lendacky wrote:
> >>>> On 9/25/25 05:17, Naveen N Rao (AMD) wrote:
> >>>
> >>> ...
> >>>
> >>>>> +
> >>>>> +static void
> >>>>> +sev_snp_guest_set_tsc_frequency(Object *obj, Visitor *v, const char *name,
> >>>>> +                                void *opaque, Error **errp)
> >>>>> +{
> >>>>> +    uint32_t value;
> >>>>> +
> >>>>> +    if (!visit_type_uint32(v, name, &value, errp)) {
> >>>>> +        return;
> >>>>> +    }
> >>>>> +
> >>>>> +    SEV_SNP_GUEST(obj)->tsc_khz = value / 1000;
> >>>>
> >>>> This will cause a value that isn't evenly divisible by 1000 to be
> >>>> rounded down, e.g.: tsc-frequency=2500000999. Should this name instead
> >>>> just be tsc-khz or secure-tsc-khz (to show it is truly associated with
> >>>> Secure TSC)?
> >>>
> >>> I modeled this after the existing tsc-frequency parameter on the cpu 
> >>> object to keep it simple (parameter is the same, just where it is 
> >>> specified differs). This also aligns with TDX which re-uses the 
> >>> tsc-frequency parameter on the cpu object.
> >>
> >> So why aren't we using the one on the cpu object instead of creating a
> >> duplicate parameter? There should be some way to get that value, no?
> > 
> > I had spent some time on this, but I couldn't figure out a simple way to 
> > make that work.
> > 
> > TDX uses a vcpu pre-create hook (similar to KVM) to get access to and 
> > set the TSC value from the cpu object. For SEV-SNP, we need the TSC 
> > frequency during SNP_LAUNCH_START which is quite early and we don't have 
> > access to the cpu object there.
> > 
> > Admittedly, my qemu understanding is limited. If there is a way to 
> > re-use the cpu tsc-frequency field, then that would be ideal.
> > 
> > Any ideas/suggestions?
> 
> Any Qemu experts know how the SEV support would be able to access the
> TSC value from the -cpu command line option at LAUNCH time?

Bump. Any feedback on this, please?

Otherwise, kindly review v3 posted here:
http://lore.kernel.org/r/cover.1761648149.git.naveen@kernel.org


Thanks,
Naveen


