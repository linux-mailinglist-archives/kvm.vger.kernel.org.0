Return-Path: <kvm+bounces-61041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D48C07887
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6B40F4F2201
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 17:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF76E3431EA;
	Fri, 24 Oct 2025 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zntnr1aC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29001990A7
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 17:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761326743; cv=none; b=I5HxwlDSsxrYeXWTzFNShRzANSxNNZMObOySnDKOXYNVY6ChNFlilyvIQxpjYzOU762PhHp6EM5fkvKNxIJstYxRCSy57PL9nuqesDZi9Qdf9lG21s/FS26+vAq50zp7cYvQ8YGpm3+L2CCv4pFqMWbmNRuNorvrjOG0sG9tKYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761326743; c=relaxed/simple;
	bh=whe1EgFnKNzU49GGbQWXa7d8Iw0DdHK2jOM6pT46VoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VOTKvCZ7l833iqg8TpW53h/vrZgH63rtSDV9A0PZtF5oULnMuziKYbfdtB3EB0Sog5WDCYelsbZmyq2xMsDM/al2+UksYTV24MUBhSWXAuxk6VREhs6ZITcpG3flfbzeb0T1d37w2FcyKhA7H8o/lmkZ9eAp72s6uYcwWK/qbaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zntnr1aC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3475C4CEF1;
	Fri, 24 Oct 2025 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761326743;
	bh=whe1EgFnKNzU49GGbQWXa7d8Iw0DdHK2jOM6pT46VoM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zntnr1aCVUG/d5vY3i7gDibOEN38IWE+AYb//5q4eSLKSwwDp9uAnww0yT2Wsr/qk
	 QEq6u3AfTJB88X/uLA2zjE3Q4pwOEG32e/Q0jE3X58VZz1MnMV2RnxAcYyqR95xMAt
	 BMmw2hOV2n+O/s/BBp7CSrqiLrPc1bvni8JNi+Q7EC/UXQ9gsPefZ2YS/YsarQ67WB
	 91fZL64VVmdDFOCQeAv+AcnJZOOkEp51/PedDU6aCIxQvJr0NBfN76IHie7TiI3YA5
	 fW8LwloSrckfdUiVqEgd7iy0mV2rFOxCxGn/gB4r43RGcueLjjU7B+2KFQJTI23NmI
	 +Xd9hPTGUZFIw==
Date: Fri, 24 Oct 2025 22:46:48 +0530
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
Message-ID: <boyf3kr7uo7jnlratgmgaklm2a4leg37hsgfno5ywsl6qvbcvo@5dwlbncvaogv>
References: <cover.1758794556.git.naveen@kernel.org>
 <65400881e426aa0e412eb431099626dceb145ddd.1758794556.git.naveen@kernel.org>
 <6a9ce7bb-5c69-ad8b-8bfd-638122619c71@amd.com>
 <uzfmnzzhz7a7lghdpazb2sphtctphmsj2nyfqnu6erjt44h577@bjj57um7n2ze>
 <a8a324ba-e474-4733-b998-7d36be06b7f7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8a324ba-e474-4733-b998-7d36be06b7f7@amd.com>

On Fri, Oct 24, 2025 at 10:00:08AM -0500, Tom Lendacky wrote:
> On 10/8/25 04:52, Naveen N Rao wrote:
> > On Tue, Oct 07, 2025 at 08:31:47AM -0500, Tom Lendacky wrote:
> >> On 9/25/25 05:17, Naveen N Rao (AMD) wrote:
> > 
> > ...
> > 
> >>> +
> >>> +static void
> >>> +sev_snp_guest_set_tsc_frequency(Object *obj, Visitor *v, const char *name,
> >>> +                                void *opaque, Error **errp)
> >>> +{
> >>> +    uint32_t value;
> >>> +
> >>> +    if (!visit_type_uint32(v, name, &value, errp)) {
> >>> +        return;
> >>> +    }
> >>> +
> >>> +    SEV_SNP_GUEST(obj)->tsc_khz = value / 1000;
> >>
> >> This will cause a value that isn't evenly divisible by 1000 to be
> >> rounded down, e.g.: tsc-frequency=2500000999. Should this name instead
> >> just be tsc-khz or secure-tsc-khz (to show it is truly associated with
> >> Secure TSC)?
> > 
> > I modeled this after the existing tsc-frequency parameter on the cpu 
> > object to keep it simple (parameter is the same, just where it is 
> > specified differs). This also aligns with TDX which re-uses the 
> > tsc-frequency parameter on the cpu object.
> 
> So why aren't we using the one on the cpu object instead of creating a
> duplicate parameter? There should be some way to get that value, no?

I had spent some time on this, but I couldn't figure out a simple way to 
make that work.

TDX uses a vcpu pre-create hook (similar to KVM) to get access to and 
set the TSC value from the cpu object. For SEV-SNP, we need the TSC 
frequency during SNP_LAUNCH_START which is quite early and we don't have 
access to the cpu object there.

Admittedly, my qemu understanding is limited. If there is a way to 
re-use the cpu tsc-frequency field, then that would be ideal.

Any ideas/suggestions?


Thanks,
Naveen


