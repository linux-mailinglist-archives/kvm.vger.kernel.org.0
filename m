Return-Path: <kvm+bounces-25960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE7796DEEC
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 17:53:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D9BE2827EF
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 15:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0479A19DF82;
	Thu,  5 Sep 2024 15:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PyMJaYjp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA191991A1
	for <kvm@vger.kernel.org>; Thu,  5 Sep 2024 15:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725551604; cv=none; b=NYDRcz3nVy4ucRPc/j1emZPrYXrPlZI9gfbXpOip10Y4TAom57HNkwq600onCWzy1Jp5z0gOC1qVUlF4rj1hhfKVh4XFusuxQlPP9hBx0aGyZOxxvCcEa3xL06oG3p6MM4u270EiV3aqzQl8OkDlT7LHb8LJxThktF7lJygERCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725551604; c=relaxed/simple;
	bh=fUdY6GHRgzcoUYE17sfsvkeoniC4TPZfRi50OZr9xW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgZHUjCXAoLbrLScjcFuWf+EZtOgryTIV4k6lbQSWirYtgnVWeKggsXgNkccS7TvDuEH9qZ7LlCZgZTXdS/P/k/QW08/0kEiFWbgLCyTSeMQg2WZ1cwF67+7/j7x08Wv9Li8J2N+hhT7eWj6iQP3YxOnBY333zcE6eekYqvae70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PyMJaYjp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725551601;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hqig8UZwoFRun80npWMliKvC3xyZmWTJfXhf0UJHq7A=;
	b=PyMJaYjpjPbQDZ6jFT3gzP+UD5JCTPfNqdh7fHIIrCTBt9JZuXVyeuWdwx53GGntmob7c0
	BLoolq1yuMrwPFhCd5TFbtR94EDjXkwpgFko3ZIj7hWDmbC7pWQrc346tCLtIy9b1BLaoL
	xtQm7nKFSvwt5ES6BEMBBN/cbpX9XTI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-VzmbyGjNOseYY_54WVDn5A-1; Thu,
 05 Sep 2024 11:53:14 -0400
X-MC-Unique: VzmbyGjNOseYY_54WVDn5A-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 188CF1955BF8;
	Thu,  5 Sep 2024 15:53:00 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4424E3000236;
	Thu,  5 Sep 2024 15:52:39 +0000 (UTC)
Date: Thu, 5 Sep 2024 16:52:36 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, alex.williamson@redhat.com,
	andrew@codeconstruct.com.au, andrew@daynix.com,
	arei.gonglei@huawei.com, berto@igalia.com,
	borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
	den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
	farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
	idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
	jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com,
	kwolf@redhat.com, leetroy@gmail.com, marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com, michael.roth@amd.com, mst@redhat.com,
	mtosatti@redhat.com, nsg@linux.ibm.com, pasic@linux.ibm.com,
	pbonzini@redhat.com, peter.maydell@linaro.org, peterx@redhat.com,
	philmd@linaro.org, pizhenwei@bytedance.com, pl@dlhnet.de,
	richard.henderson@linaro.org, stefanha@redhat.com,
	steven_lee@aspeedtech.com, thuth@redhat.com,
	vsementsov@yandex-team.ru, wangyanan55@huawei.com,
	yuri.benditovich@daynix.com, zhao1.liu@intel.com,
	qemu-block@nongnu.org, qemu-arm@nongnu.org, qemu-s390x@nongnu.org,
	kvm@vger.kernel.org, avihaih@nvidia.com
Subject: Re: [PATCH v2 01/19] qapi: Smarter camel_to_upper() to reduce need
 for 'prefix'
Message-ID: <ZtnTxNFmgJlaeLZy@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240904111836.3273842-1-armbru@redhat.com>
 <20240904111836.3273842-2-armbru@redhat.com>
 <ZthQAr7Mpd0utBD9@redhat.com>
 <87o75263pq.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o75263pq.fsf@pond.sub.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Sep 05, 2024 at 07:59:13AM +0200, Markus Armbruster wrote:
> Daniel P. Berrangé <berrange@redhat.com> writes:
> 
> > On Wed, Sep 04, 2024 at 01:18:18PM +0200, Markus Armbruster wrote:
> >> camel_to_upper() converts its argument from camel case to upper case
> >> with '_' between words.  Used for generated enumeration constant
> >> prefixes.
> >
> >
> >> 
> >> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> >> Reviewed-by: Daniel P. Berrang?? <berrange@redhat.com>
> >
> > The accent in my name is getting mangled in this series.
> 
> Uh-oh!
> 
> Checking...  Hmm.  It's correct in git, correct in output of
> git-format-patch, correct in the copy I got from git-send-email --bcc
> armbru via localhost MTA, and the copy I got from --to
> qemu-devel@nongnu.org, correct in lore.kernel.org[*], correct in an mbox
> downloaded from patchew.
> 
> Could the culprit be on your side?

I compared my received mail vs the mbox archive on nongnu.org for
qemu-devel.

In both cases the actual mail body seems to be valid UTF-8 and is
identical. The message in the nongnu.org archive, however, has

  Content-Type: text/plain; charset=UTF-8

while the copy I got in my inbox has merely

  Content-Type: text/plain

What I can't determine is whether your original sent message
had "charset=UTF-8" which then got stripped by redhat's incoming
mail server, or whether your original lacked 'charset=UTF8' and
it got added by mailman when saving the message to the mbox archives ?


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


