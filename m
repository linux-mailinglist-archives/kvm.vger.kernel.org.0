Return-Path: <kvm+bounces-68874-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ALwOMCkFcmmvZwAAu9opvQ
	(envelope-from <kvm+bounces-68874-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:08:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F14965BC3
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7472D70B8BE
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 10:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA26421F07;
	Thu, 22 Jan 2026 10:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G3hSEh4I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8FD3ACEF4
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 10:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769078956; cv=none; b=b2LgaSbIdyfAvo7b9HnSsJfKQfMXHUmRuHmUHUzOEm+8XXwqbAEghH8cwgk//ckGq2kcVQlacM/CMaVD/vRM3yFkFNSAx/buHpjZj/ZET97vI4rf+In4+Ww3+n/Uvl6+L5KNl1OwC1G/iTR/U+NGSwFsDx7lQxpVIUqL+LoqQ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769078956; c=relaxed/simple;
	bh=IG6qrmkb043AssFhLRgMTBgJ94hkC2o2HTvQcRAzH8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9EkxkSvsqbArHHYL6EEuA72pTiERPq3y7XBCFr3Ug4a5fjqP6riIYzr8mk19Ol7D8iJs+4uKYcT02+ZwrojqiyZyfitl4yKxRDBlIM1stjpzrTsUV/8dj6aUafv9heZIDnZYdg2LASeqw8HmE6v8kr4OUEt0ThERZAyuotraks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G3hSEh4I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769078951;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogBQH7o4vvflWNg6xtgOStE2EmdaiLu9Qw5jeXLxEeU=;
	b=G3hSEh4I/PmC9eFWIIlCu6+8fdRkOEsWj/kSVSIOW7o9tNraC4WaHqAUmrnTzjuvAyenqH
	SdqL0QiXd9zl/QSHzej3f659tGjcnEGWTnAVaL7xOb6+pQbxPgodySXFVUHWZLKaEaaNW3
	NywcAzoVqj7iXwLWStFpelaH4lSbG80=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-oHLLlz18O-SSOf9Ky-3hzg-1; Thu,
 22 Jan 2026 05:49:08 -0500
X-MC-Unique: oHLLlz18O-SSOf9Ky-3hzg-1
X-Mimecast-MFC-AGG-ID: oHLLlz18O-SSOf9Ky-3hzg_1769078947
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23F8719775A4;
	Thu, 22 Jan 2026 10:49:07 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.63])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2E8F18001D5;
	Thu, 22 Jan 2026 10:49:00 +0000 (UTC)
Date: Thu, 22 Jan 2026 10:48:57 +0000
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
Message-ID: <aXIAmeEWMFjQM84o@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
 <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
 <aXH4PpkC4AtccsOE@redhat.com>
 <130b8f26-2369-48f5-bbd6-e27210707b9f@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <130b8f26-2369-48f5-bbd6-e27210707b9f@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-68874-lists,kvm=lfdr.de];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[instagram.com:url,libvirt.org:url,entangle-photo.org:url,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,berrange.com:url,qemu.org:url];
	HAS_REPLYTO(0.00)[berrange@redhat.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[berrange@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 2F14965BC3
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 11:43:35AM +0100, Thomas Huth wrote:
> On 22/01/2026 11.14, Daniel P. Berrangé wrote:
> > On Tue, Jan 20, 2026 at 04:42:38PM -0500, Stefan Hajnoczi wrote:
> > > Hi Marc-André,
> > > I haven't seen discussion about the project ideas you posted, so I'll
> > > try to kick it off here for the mkosi idea here.
> > > 
> > > Thomas: Would you like to co-mentor the following project with
> > > Marc-André? Also, do you have any concerns about the project idea from
> > > the maintainer perspective?
> 
> I'm fine with co-mentoring the project, but could you do me a favour and add
> some wording about AI tools to
> https://wiki.qemu.org/Google_Summer_of_Code_2026 to set the expectations
> right? Since we don't allow AI generated code in QEMU, I'd appreciate if we
> could state this in a prominent place here to avoid that some people think
> they could get some quick money here by using AI tools, just to finally
> discover that AI generated code is not allowed in the QEMU project. Thanks!
> 
> > IMHO, our baseline for functional testing images ought to be
> > a Linux Kconfig recipe used to build a dedicate kernel, plus
> > a busybox build for the target.
> 
> Not sure if we want to add kernel compilation time to the functional tests
> (even if it's only done once during the initial build)...? That could easily
> sum up to a couple of hours for a fresh checkout of QEMU...

That's absolutely *NOT* what I was suggesting.

We should have a 'qemu-test-images.git' repository that maintains all
the recipes, with CI jobs to build and publish them (along with corresponding
source). Those prebuilt images would be consumed by QEMU functional tests.
This would be quicker than what we have today, as the images downloaded by
functional tests could be an order of magnitude smaller, and boot more
quickly too.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


