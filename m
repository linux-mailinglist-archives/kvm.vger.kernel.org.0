Return-Path: <kvm+bounces-68884-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sKILEIsTcmksawAAu9opvQ
	(envelope-from <kvm+bounces-68884-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:09:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B0288666D9
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4277F7AC9E2
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09AA357729;
	Thu, 22 Jan 2026 11:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L+5oloap"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F361728AAEB
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 11:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769081082; cv=none; b=AvdrONsWVKYnXnAb5PHYhcxkqyhMTUiOUiP8svWt3oJgjF1UP83rei0vJPJ2Y0C7OIcXLy//LRpZVpokuMfgGb/9bXT+iexHlX85YJDE9LtH2pBN8XP/oFeFuPBF0M0NDIhPes9vK5AWv/UCk3QOGZThvkMKK9uLJGoFjbu48Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769081082; c=relaxed/simple;
	bh=qasutVXztcJ9HM+CyZWPrta1Bb08m8CU95TnRr2C528=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SK+7abSolVg9h2s/RJWu6338NLCaBKBnx/FVy+zc2Av1NJQAb4x8v7K9cS11iU44n0Ji52t7JTdJbABh56QoGfP+7CNPhwsK39Ts6dJaxr5/XM7NkkwFu8dJe3FZl6ZH2uGNm32EMUA+qo6liizDOw9zJtRJ0UKCee9NVP0Vs0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L+5oloap; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769081079;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9NgMyyWJCfzd8YQ/Mm3GEt0/9k5YoUbFP0YSsx5ZSgg=;
	b=L+5oloapRZFs9xIyNQUrnfl4ejSIBljmJBvOmaonL1ZPaA5XRHRDiTykxBbPTACtSCJSHu
	qYIU1J09weLGgi4okfw7tbGwdexmGiAl7of3do1OhWKmEE7SdxPhsgmrE0RAeMzDd5/F0j
	VRWv6LbLhRJq/kS03bcjsSu1TZmhozo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-261-7nFwJM6DOSO-uDud0z3tKQ-1; Thu,
 22 Jan 2026 06:24:36 -0500
X-MC-Unique: 7nFwJM6DOSO-uDud0z3tKQ-1
X-Mimecast-MFC-AGG-ID: 7nFwJM6DOSO-uDud0z3tKQ_1769081075
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AAC218003FC;
	Thu, 22 Jan 2026 11:24:35 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.63])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 648C31800109;
	Thu, 22 Jan 2026 11:24:27 +0000 (UTC)
Date: Thu, 22 Jan 2026 11:24:24 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	German Maglione <gmaglione@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Alex Bennee <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	John Levon <john.levon@nutanix.com>,
	Thanos Makatos <thanos.makatos@nutanix.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: Call for GSoC internship project ideas
Message-ID: <aXII6EfQ3D4fkWLg@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
 <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
 <aXH4PpkC4AtccsOE@redhat.com>
 <130b8f26-2369-48f5-bbd6-e27210707b9f@redhat.com>
 <aXIAmeEWMFjQM84o@redhat.com>
 <995d4aaf-bbff-42be-9114-1f04bb51e37c@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <995d4aaf-bbff-42be-9114-1f04bb51e37c@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk,nutanix.com];
	TAGGED_FROM(0.00)[bounces-68884-lists,kvm=lfdr.de];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qemu.org:url,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,buildroot.org:url,instagram.com:url,berrange.com:url,libvirt.org:url];
	HAS_REPLYTO(0.00)[berrange@redhat.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[berrange@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: B0288666D9
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 12:05:14PM +0100, Thomas Huth wrote:
> On 22/01/2026 11.48, Daniel P. Berrangé wrote:
> > On Thu, Jan 22, 2026 at 11:43:35AM +0100, Thomas Huth wrote:
> > > On 22/01/2026 11.14, Daniel P. Berrangé wrote:
> > > > On Tue, Jan 20, 2026 at 04:42:38PM -0500, Stefan Hajnoczi wrote:
> > > > > Hi Marc-André,
> > > > > I haven't seen discussion about the project ideas you posted, so I'll
> > > > > try to kick it off here for the mkosi idea here.
> > > > > 
> > > > > Thomas: Would you like to co-mentor the following project with
> > > > > Marc-André? Also, do you have any concerns about the project idea from
> > > > > the maintainer perspective?
> > > 
> > > I'm fine with co-mentoring the project, but could you do me a favour and add
> > > some wording about AI tools to
> > > https://wiki.qemu.org/Google_Summer_of_Code_2026 to set the expectations
> > > right? Since we don't allow AI generated code in QEMU, I'd appreciate if we
> > > could state this in a prominent place here to avoid that some people think
> > > they could get some quick money here by using AI tools, just to finally
> > > discover that AI generated code is not allowed in the QEMU project. Thanks!
> > > 
> > > > IMHO, our baseline for functional testing images ought to be
> > > > a Linux Kconfig recipe used to build a dedicate kernel, plus
> > > > a busybox build for the target.
> > > 
> > > Not sure if we want to add kernel compilation time to the functional tests
> > > (even if it's only done once during the initial build)...? That could easily
> > > sum up to a couple of hours for a fresh checkout of QEMU...
> > 
> > That's absolutely *NOT* what I was suggesting.
> > 
> > We should have a 'qemu-test-images.git' repository that maintains all
> > the recipes, with CI jobs to build and publish them (along with corresponding
> > source). Those prebuilt images would be consumed by QEMU functional tests.
> > This would be quicker than what we have today, as the images downloaded by
> > functional tests could be an order of magnitude smaller, and boot more
> > quickly too.
> 
> Ah, sorry for getting that wrong!
> 
> Ok, so this sounds basically just like a gitlab-CI wrapper around what
> buildroot.org already provides. ... not sure whether that's challenging
> enough for a GSoC project?

Given the number of machines we have, it is certainly time consuming
enough to figure out the build for each one, and integrate it with
the functional test. Not massively mentally challenging, but that's
not a bad thing for GSoC.

> Also, adding this as a separate repository will easily burn your gitlab-CI
> minutes if you don't have a dedicated runner for this, so developing this
> feature might be no fun at all...

I'd expect most of the work would be on a local machine to construct and
test images for all the different machines and validate them in functional
tests. The integration into GitLab CI is a small-ish part which could be
validated with just a couple of images, so you'd only burn major CI credits
towards the end when needing to do a full run across all images.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


