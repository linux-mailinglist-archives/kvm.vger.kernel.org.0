Return-Path: <kvm+bounces-34069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 535249F6CED
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 19:12:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72C7316B55E
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 18:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917971FBCAF;
	Wed, 18 Dec 2024 18:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N2Ftb8LV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE1D1FA8E9
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734545512; cv=none; b=WOyoA7cNoTQhicJQdE3WwcJnMr9lWWQcfwstPw4Nq59aRnXU9fNyL8DU0sBWMA/xTYKfKoVXJdrw5FO/cpaUtZsTcdgIhHrfpLh/KCSyNZeLHbm6pky30EazX/Aqt7PQXIAUJgn/2o1imlJ+3ZGlWj5Z624gRl7FSfSIyGco+ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734545512; c=relaxed/simple;
	bh=MbGPsRddoKT2xegMgVoc5THA4ay7NQie7gRhxqy9mNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lz4Tv6cW3E9Pf37d0nqTa5c0jnv0mnQS8uVFiu2Ee5/g2v0BQw2IwHczKMXi6Hleiy5onlL78iBmUdgaEBjnh2C6RgmBNbI5VmGsuaSrdScLcX1L7+zGHZZ+GYpzffTDYU+qx5SeYIAtxLMizcx4I4SHcGN+9Jce2X7NmgzSB6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N2Ftb8LV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734545508;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5hJ2SHXu1pOna/DnfUkw5UMrkPPje5xxmW8kJSQbRmo=;
	b=N2Ftb8LVzna/wrv/zc6LhlGgDS5TOXV3J+mSI3knUnQaYeWzhYOMTEWO3pq8GTYKMxwhIn
	un9jGnFFBywiHYXYesyoYQukkolgkZy2B4MerewzfWTkQn8vo9RhRdpidU8EZcX8kUgEXp
	BoQBZULb9VsSE1DzBQIR2+tWiEkvLIY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-cO5fZVSEOy2f-r4Ot-m8kA-1; Wed,
 18 Dec 2024 13:11:44 -0500
X-MC-Unique: cO5fZVSEOy2f-r4Ot-m8kA-1
X-Mimecast-MFC-AGG-ID: cO5fZVSEOy2f-r4Ot-m8kA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AD851956096;
	Wed, 18 Dec 2024 18:11:38 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.61])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3ACE30044C1;
	Wed, 18 Dec 2024 18:11:31 +0000 (UTC)
Date: Wed, 18 Dec 2024 18:11:28 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Dionna Amalie Glaze <dionnaglaze@google.com>, pbonzini@redhat.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	thomas.lendacky@amd.com, john.allen@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	michael.roth@amd.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
Message-ID: <Z2MQUKknmqIwLSKk@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
 <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com>
 <Z2HvJESqpc7Gd-dG@google.com>
 <57d43fae-ab5e-4686-9fed-82cd3c0e0a3c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57d43fae-ab5e-4686-9fed-82cd3c0e0a3c@amd.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Dec 17, 2024 at 05:16:01PM -0600, Kalra, Ashish wrote:
> 
> 
> On 12/17/2024 3:37 PM, Sean Christopherson wrote:
> > On Tue, Dec 17, 2024, Ashish Kalra wrote:
> >>
> >>
> >> On 12/17/2024 10:00 AM, Dionna Amalie Glaze wrote:
> >>> On Mon, Dec 16, 2024 at 3:57 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >>>>
> >>>> From: Ashish Kalra <ashish.kalra@amd.com>
> >>>
> >>>> The on-demand SEV initialization support requires a fix in QEMU to
> >>>> remove check for SEV initialization to be done prior to launching
> >>>> SEV/SEV-ES VMs.
> >>>> NOTE: With the above fix for QEMU, older QEMU versions will be broken
> >>>> with respect to launching SEV/SEV-ES VMs with the newer kernel/KVM as
> >>>> older QEMU versions require SEV initialization to be done before
> >>>> launching SEV/SEV-ES VMs.
> >>>>
> >>>
> >>> I don't think this is okay. I think you need to introduce a KVM
> >>> capability to switch over to the new way of initializing SEV VMs and
> >>> deprecate the old way so it doesn't need to be supported for any new
> >>> additions to the interface.
> >>>
> >>
> >> But that means KVM will need to support both mechanisms of doing SEV
> >> initialization - during KVM module load time and the deferred/lazy
> >> (on-demand) SEV INIT during VM launch.
> > 
> > What's the QEMU change?  Dionna is right, we can't break userspace, but maybe
> > there's an alternative to supporting both models.
> 
> Here is the QEMU fix : (makes a SEV PLATFORM STATUS firmware call via PSP driver ioctl
> to check if SEV is in INIT state)
>  
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 1a4eb1ada6..4fa8665395 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -1503,15 +1503,6 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>          }
>      }
> 
> -    if (sev_es_enabled() && !sev_snp_enabled()) {
> -        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
> -            error_setg(errp, "%s: guest policy requires SEV-ES, but "
> -                         "host SEV-ES support unavailable",
> -                         __func__);
> -            return -1;
> -        }
> -    }

Sigh, that code exists in all versions of QEMU that shipped with SEV-ES
support. IOW the proposed kernel change is not limited to breaking
"older QEMU versions". Every QEMU for the last 3 years will break,
including the newest version released last week. Please don't do that.

If the kvm-svm  kmod supports both load time init and lazy init, then
the QEMU incompatibility still exists, and will likely get pushed on
users by the OS distro forcing use of the lazy-load option :-(

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


