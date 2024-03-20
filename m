Return-Path: <kvm+bounces-12296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C22548811A3
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:28:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEF861C2171D
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9833FBA8;
	Wed, 20 Mar 2024 12:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gAoOu961"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605E93FB85
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710937699; cv=none; b=JO2E2CALyJ0XsZwpuk5U8t/vvJvZEEMUc75srqYfhnHrp9IW3ObVTkUzwAHR8kgGcsZR1EXn6DcWNHx75y1rAdXsO6ZHSOleaBJ8UEKaMSGCMPzV/YtYCwYbpMl2iR7NQM0ea/6Ak+kae8x4gXo7OmJ7dgBw47EbWLB+tZbTAAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710937699; c=relaxed/simple;
	bh=dUItWHK87EhWLN9gQkuRfAb9s3a4Ia3qfb2kiIelSXg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ftpPrQShuJ+4mSH+R9QmiZdLcO8/bZPWufijQZCH3wyWiuDQrOEFDjxsZW938R6SyevO5QjixmrtTkPR0+H1BZWoAihfYqxZpuAGsnFF0Ng4sZweCkdkG6sUNZsHhxG1OA+bo7OC1WT2tQbKHaamNznf82E4ifRgG/kXWYnFr8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gAoOu961; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710937696;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZW5UtiL+EzjpbdstQ5Akgncb1Ct4JD3lPWufk7fPXok=;
	b=gAoOu961vrjQwlvBOZHd3ZHXUTz8u5lUpJyO/XTF9jhZzobhtGdAZZZ0hesOffEWWqKpSV
	IwMVdiHjL6qvjg/3/bFlRVg4XESYRVTmab4ZqHtxgTfffZ5bQJtVj04E0lT+DJO+CjxY1d
	fqiA0n0WVW2ZWTzjtARwhdC3pH7Y1RQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-OvRDoVnXO6e6Hsa9_Z61ZQ-1; Wed, 20 Mar 2024 08:28:13 -0400
X-MC-Unique: OvRDoVnXO6e6Hsa9_Z61ZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55455853060;
	Wed, 20 Mar 2024 12:28:13 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.205])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AB9140C6DAD;
	Wed, 20 Mar 2024 12:28:12 +0000 (UTC)
Date: Wed, 20 Mar 2024 12:27:50 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 32/49] i386/sev: Don't return launch measurements for
 SEV-SNP guests
Message-ID: <ZfrWRlgzuMH5-NZG@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-33-michael.roth@amd.com>
 <ZfrTQyEHrxXBq1nB@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfrTQyEHrxXBq1nB@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Wed, Mar 20, 2024 at 12:15:00PM +0000, Daniel P. Berrangé wrote:
> On Wed, Mar 20, 2024 at 03:39:28AM -0500, Michael Roth wrote:
> > For SEV-SNP guests, launch measurement is queried from within the guest
> > during attestation, so don't attempt to return it as part of
> > query-sev-launch-measure.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  target/i386/sev.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index b03d70a3d1..0c8e4bdb4c 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -803,7 +803,9 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
> >  
> >  static char *sev_get_launch_measurement(void)
> >  {
> > -    SevGuestState *sev_guest = SEV_GUEST(MACHINE(qdev_get_machine())->cgs);
> > +    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
> > +    SevGuestState *sev_guest =
> > +        (SevGuestState *)object_dynamic_cast(OBJECT(cgs), TYPE_SEV_GUEST);
> >  
> >      if (sev_guest &&
> >          SEV_COMMON(sev_guest)->state >= SEV_STATE_LAUNCH_SECRET) {
> 
> The QAPI docs for query-sev-launch-measurement should be updated
> to reflect that this command is only valid to call for SEV/SEV-ES,
> not SNP.

Also, the same question about whether query-sev-attestation-report
and sev-inject-launch-secret need updating to declare them SEV/SEV-ES
only, or if they are expected work with SNP too ?


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


