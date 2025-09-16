Return-Path: <kvm+bounces-57733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA6BB59B99
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D658484C32
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7713A369972;
	Tue, 16 Sep 2025 15:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQKt3fVD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6F63680B9
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758034999; cv=none; b=lWPTaTKzFVmiI+0EZpQ7szZEHckL7VXyC8Pin2+TVeYzCHM0GEjli4jlVACbvzmbRdxihSr/Z+EFp8JbhU6RZpDFcEhe3Y/xtOq05hv8dMC0sn7FbExRV5CjkpUPbuU5HUMz7ricSP/8NvhVFcTdsI9sINN+VvzPMaaMjJj49to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758034999; c=relaxed/simple;
	bh=3DgrfhjWWAgiCqvaEJI17qhQ5oMiVyTwKQrB4jc7bfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwlfPM/cIz8sIYscJgMhKMhWTH6P7fqG2tetqjFblAS4vc/kn3eMIeoof1/tCrokIzgcXFCo1PfmJ6AD+g8+mPkVa4WwtK3TFvV7hJw0vbnjYekATDs/0naP/p/Hiyh4JzBjcyWJcGzLlfKzwvkBEXTzPxGzb8/R5epOLlGj9fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cQKt3fVD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758034995;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=mz4q4r7x8FVp7T3wM1kV8XwhENOApW+a+HoqsplWyoU=;
	b=cQKt3fVDU/EcSdDvLO8xXQgNUc81OBwwjFPt4lDDmrMN6UjUhlwPmbr3XRo8GyaR82ud4O
	aE6FIQX+CVtVRhSHdLK8YD7FNXMK0EhEWfSn1eAp0xTMZEVFbzDSiq/Rd0QrHavUcM9mOM
	Nl8c4yqf8jhYHAGGoc3JUUqZr9k80VA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-461-9DU3rbQlOaCjfqxPuMXTFw-1; Tue,
 16 Sep 2025 11:03:12 -0400
X-MC-Unique: 9DU3rbQlOaCjfqxPuMXTFw-1
X-Mimecast-MFC-AGG-ID: 9DU3rbQlOaCjfqxPuMXTFw_1758034990
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC0E91955D6E;
	Tue, 16 Sep 2025 15:03:09 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.153])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4D1B180057B;
	Tue, 16 Sep 2025 15:03:05 +0000 (UTC)
Date: Tue, 16 Sep 2025 16:03:02 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Naveen N Rao <naveen@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
	Eduardo Habkost <eduardo@habkost.net>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>, Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Neeraj Upadhyay <neeraj.upadhyay@amd.com>,
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: Re: [RFC PATCH 3/7] target/i386: SEV: Add support for enabling
 debug-swap SEV feature
Message-ID: <aMl8JsHtO0Cmbb1p@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <cover.1757589490.git.naveen@kernel.org>
 <0a77cf472bc36fee7c1be78fc7d6d514d22bca9a.1757589490.git.naveen@kernel.org>
 <87jz239at0.fsf@pond.sub.org>
 <m5fnfafkzxqamg4iyc6xjun7jlxulcuufgugtrweap6myvmgov@5cmxu5n3pl2p>
 <87plbqo998.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87plbqo998.fsf@pond.sub.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Sep 16, 2025 at 02:46:27PM +0200, Markus Armbruster wrote:
> Naveen N Rao <naveen@kernel.org> writes:
> 
> > Hi Markus,
> >
> > On Fri, Sep 12, 2025 at 01:20:43PM +0200, Markus Armbruster wrote:
> >> "Naveen N Rao (AMD)" <naveen@kernel.org> writes:
> >> 
> >> > Add support for enabling debug-swap VMSA SEV feature in SEV-ES and
> >> > SEV-SNP guests through a new "debug-swap" boolean property on SEV guest
> >> > objects. Though the boolean property is available for plain SEV guests,
> >> > check_sev_features() will reject setting this for plain SEV guests.
> >> 
> >> Let's see whether I understand...
> >> 
> >> It's a property of sev-guest and sev-snp-guest objects.  These are the
> >> "SEV guest objects".
> >> 
> >> I guess a sev-snp-guest object implies it's a SEV-SNP guest, and setting
> >> @debug-swap on such an object just works.
> >> 
> >> With a sev-guest object, it's either a "plain SEV guest" or a "SEV-ES"
> >> guest.
> >> 
> >> If it's the latter, setting @debug-swap just works.
> >> 
> >> If it's the former, and you set @debug-swap to true, then KVM
> >> accelerator initialization will fail later on.  This might trigger
> >> fallback to TCG.
> >> 
> >> Am I confused?
> >
> > You're spot on, except that in the last case above (plain old SEV 
> > guest), qemu throws an error:
> > 	qemu-system-x86_64: check_sev_features: SEV features require either SEV-ES or SEV-SNP to be enabled
> 
> Okay.
> 
> Can you (or anyone) explain to me why SEV-SNP gets its own object type,
> but SEV-ES does not?

SEV-ES is a minor incremental enhancement over SEV, with the user provided
configuration in QEMU largely common between the two.

SEV-SNP is a significant improvement that requires new/different user
config data to be provided to QEMU. It also changes the way attestation
is driven, moving out of host/QEMU, into the guest.

It made more sense to separate the configuration for SEV-SNP from that
used for SEV/SEV-ES. It also helps reinforce the message that SEV-SNP
is where the long term focus should be, with SEV/SEV-ES (ideally) only
used on old platforms that predate SNP, or running OS that lack the
more recent software support for SNP.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


