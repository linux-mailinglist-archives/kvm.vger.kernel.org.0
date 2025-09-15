Return-Path: <kvm+bounces-57577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63ACCB57EDE
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA1ED161832
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 14:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0836326D65;
	Mon, 15 Sep 2025 14:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyC3l+XO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B5430B507
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757946368; cv=none; b=LhS0JapPhpjFyvYDOtwuLkU/QqCcpvQ8C9JP6oMdHEsAnQhF4RjrWbJ/1dsYY6lOVo3LTFJxu3E+yRGl5dJBlnaOLoLeyUySDMNn4x63TmP7DWQUyuKcaSrzF10FoOYXFj8p7whtSqdHiKfwMbLZaYMiYr6DTq3Uj8c2VhgAGGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757946368; c=relaxed/simple;
	bh=C2jK1UFUtb8LaJFNih+XJciK25lF0de4y5xAZpbInJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spcDndPSzIbrIaVcDl1qEHZxa/wb7vXPDzGhU3F6p2G+525H/zkYz5P8+wvNhicczpwjF1l+Wapp2IdWNq3Pt0O7a15OBYyIp0V1g/YlbObfNhkhrwO6JXOG2/EPRxBSKfthkmJ4e4qJTKJ8hEHp1gAj8m9acn9fM1AVR7KaJ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyC3l+XO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A03C4CEF1;
	Mon, 15 Sep 2025 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757946368;
	bh=C2jK1UFUtb8LaJFNih+XJciK25lF0de4y5xAZpbInJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZyC3l+XOuZTNl7SgDwLRuzYJ+jj1PM30v55sUhInAzQllch8vOIGpgNXIjw1eoxgP
	 y3U8A8nWTGBIP28CsserT4T6kq3ezLerT0SxpjaiZA7YlYFmY2i25m57QvbpiZskIN
	 q8hB52T9bqTYq+rbFjqiebgJ9IIeBp/VBXFOPiVhd79P1ZUPgNoxyGtKqloFPcywqq
	 0Zlk20/J8BnhQifvv6HQWVpzCAct21i31mwDPR70pfzpZTlLDx5fN+lHYJbZtldt6p
	 C6oUiMtWh1LFu4Ge6vyx+tOEXoA6EAQ7kPAlRuhoYaPhc6d8u0HKbzxMegk/sWgM60
	 /swHXglUau/2g==
Date: Mon, 15 Sep 2025 19:55:02 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org, 
	"Daniel P. Berrange" <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Eric Blake <eblake@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Zhao Liu <zhao1.liu@intel.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Neeraj Upadhyay <neeraj.upadhyay@amd.com>, Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: Re: [RFC PATCH 3/7] target/i386: SEV: Add support for enabling
 debug-swap SEV feature
Message-ID: <m5fnfafkzxqamg4iyc6xjun7jlxulcuufgugtrweap6myvmgov@5cmxu5n3pl2p>
References: <cover.1757589490.git.naveen@kernel.org>
 <0a77cf472bc36fee7c1be78fc7d6d514d22bca9a.1757589490.git.naveen@kernel.org>
 <87jz239at0.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jz239at0.fsf@pond.sub.org>

Hi Markus,

On Fri, Sep 12, 2025 at 01:20:43PM +0200, Markus Armbruster wrote:
> "Naveen N Rao (AMD)" <naveen@kernel.org> writes:
> 
> > Add support for enabling debug-swap VMSA SEV feature in SEV-ES and
> > SEV-SNP guests through a new "debug-swap" boolean property on SEV guest
> > objects. Though the boolean property is available for plain SEV guests,
> > check_sev_features() will reject setting this for plain SEV guests.
> 
> Let's see whether I understand...
> 
> It's a property of sev-guest and sev-snp-guest objects.  These are the
> "SEV guest objects".
> 
> I guess a sev-snp-guest object implies it's a SEV-SNP guest, and setting
> @debug-swap on such an object just works.
> 
> With a sev-guest object, it's either a "plain SEV guest" or a "SEV-ES"
> guest.
> 
> If it's the latter, setting @debug-swap just works.
> 
> If it's the former, and you set @debug-swap to true, then KVM
> accelerator initialization will fail later on.  This might trigger
> fallback to TCG.
> 
> Am I confused?

You're spot on, except that in the last case above (plain old SEV 
guest), qemu throws an error:
	qemu-system-x86_64: check_sev_features: SEV features require either SEV-ES or SEV-SNP to be enabled

> 
> > Add helpers for setting and querying the VMSA SEV features so that they
> > can be re-used for subsequent VMSA SEV features, and convert the
> > existing SVM_SEV_FEAT_SNP_ACTIVE definition to use the BIT() macro for
> > consistency with the new feature flag.
> >
> > Sample command-line:
> >   -machine q35,confidential-guest-support=sev0 \
> >   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,debug-swap=on
> >
> > Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> 
> [...]
> 
> > diff --git a/qapi/qom.json b/qapi/qom.json
> > index 830cb2ffe781..71cd8ad588b5 100644
> > --- a/qapi/qom.json
> > +++ b/qapi/qom.json
> > @@ -1010,13 +1010,17 @@
> >  #     designated guest firmware page for measured boot with -kernel
> >  #     (default: false) (since 6.2)
> >  #
> > +# @debug-swap: enable virtualization of debug registers (default: false)
> > +#              (since 10.2)
> 
> Please indent like this:
> 
>    # @debug-swap: enable virtualization of debug registers
>    #     (default: false) (since 10.2)

Sure.

Thanks for the review,
- Naveen


