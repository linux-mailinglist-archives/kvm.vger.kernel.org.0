Return-Path: <kvm+bounces-57391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F1EB54ADC
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 13:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A9215A0F1D
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 11:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4213009D9;
	Fri, 12 Sep 2025 11:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ur4kWVDq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437952EB5BD
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 11:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757676057; cv=none; b=oqHVLGSmxOgP1xo71ic0bvHh42O4dsuOlxe53FWEvkbHFBHjYU45CSNL/N/9Qe8Dsgkt3xNUh+ZqSswfdYsIJMHNkvNXYyPRo5kOPHfsBDXGbx0iGXSGC5Xa+pRmzjTU1wPb92LpLvheiShfeoI4JV68pjwArhjR/mEEBiCOJ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757676057; c=relaxed/simple;
	bh=8Dw3lVR2xucpJIiN549egDMsYKgC7uUhzdU3uBZexjc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=do+Fe6xe8wXwQhyCuFHb8Hha/miPtsUNWgORHS2IOsxsg98mOv9oGtAGjostdGNWE76jJLQkV6bYZbsx7CrL0MRWoopg/iDPoFrRjAo4plwbZ54b0spWZkeGRJfZ4L1tY6ytJ9H9iE2dI0fIi2sc3/Svjpa8kqK8D9Tuf4byhZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ur4kWVDq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757676053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gSEQ4Qczks8i0U7Ra7o1VfmOwUG1VbNgYYjOq2bb5cc=;
	b=Ur4kWVDqNJ4JbJofBZ5Am8qURVHIfC5UDM4Wur/1NZSOjwcb3r8A/XYLTl90ihfaMlFECY
	6PHAd8TdTvzAM8cmJJe2Fpft5TUJQ0ekkZgifzAnTyu14tSAGcs73zHsE6FRrtfE04id9Y
	HCT0kN/ZV3HHddbPGfVLjN3JAt55b68=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-491-9qeUdjA9PSKj3r4VcW3dHw-1; Fri,
 12 Sep 2025 07:20:49 -0400
X-MC-Unique: 9qeUdjA9PSKj3r4VcW3dHw-1
X-Mimecast-MFC-AGG-ID: 9qeUdjA9PSKj3r4VcW3dHw_1757676047
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39BF5180045C;
	Fri, 12 Sep 2025 11:20:47 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E59A19560B1;
	Fri, 12 Sep 2025 11:20:46 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id E2B6D21E6A27; Fri, 12 Sep 2025 13:20:43 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Sean Christopherson
 <seanjc@google.com>,  qemu-devel <qemu-devel@nongnu.org>,
  <kvm@vger.kernel.org>,  "Daniel P. Berrange" <berrange@redhat.com>,
  Eduardo Habkost <eduardo@habkost.net>,  Eric Blake <eblake@redhat.com>,
  Marcelo Tosatti <mtosatti@redhat.com>,  Zhao Liu <zhao1.liu@intel.com>,
  Nikunj A Dadhania <nikunj@amd.com>,  Tom Lendacky
 <thomas.lendacky@amd.com>,  Michael Roth <michael.roth@amd.com>,  Neeraj
 Upadhyay <neeraj.upadhyay@amd.com>,  Roy Hopkins
 <roy.hopkins@randomman.co.uk>
Subject: Re: [RFC PATCH 3/7] target/i386: SEV: Add support for enabling
 debug-swap SEV feature
In-Reply-To: <0a77cf472bc36fee7c1be78fc7d6d514d22bca9a.1757589490.git.naveen@kernel.org>
	(Naveen N. Rao's message of "Thu, 11 Sep 2025 17:24:22 +0530")
References: <cover.1757589490.git.naveen@kernel.org>
	<0a77cf472bc36fee7c1be78fc7d6d514d22bca9a.1757589490.git.naveen@kernel.org>
Date: Fri, 12 Sep 2025 13:20:43 +0200
Message-ID: <87jz239at0.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

"Naveen N Rao (AMD)" <naveen@kernel.org> writes:

> Add support for enabling debug-swap VMSA SEV feature in SEV-ES and
> SEV-SNP guests through a new "debug-swap" boolean property on SEV guest
> objects. Though the boolean property is available for plain SEV guests,
> check_sev_features() will reject setting this for plain SEV guests.

Let's see whether I understand...

It's a property of sev-guest and sev-snp-guest objects.  These are the
"SEV guest objects".

I guess a sev-snp-guest object implies it's a SEV-SNP guest, and setting
@debug-swap on such an object just works.

With a sev-guest object, it's either a "plain SEV guest" or a "SEV-ES"
guest.

If it's the latter, setting @debug-swap just works.

If it's the former, and you set @debug-swap to true, then KVM
accelerator initialization will fail later on.  This might trigger
fallback to TCG.

Am I confused?

> Add helpers for setting and querying the VMSA SEV features so that they
> can be re-used for subsequent VMSA SEV features, and convert the
> existing SVM_SEV_FEAT_SNP_ACTIVE definition to use the BIT() macro for
> consistency with the new feature flag.
>
> Sample command-line:
>   -machine q35,confidential-guest-support=sev0 \
>   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,debug-swap=on
>
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

[...]

> diff --git a/qapi/qom.json b/qapi/qom.json
> index 830cb2ffe781..71cd8ad588b5 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1010,13 +1010,17 @@
>  #     designated guest firmware page for measured boot with -kernel
>  #     (default: false) (since 6.2)
>  #
> +# @debug-swap: enable virtualization of debug registers (default: false)
> +#              (since 10.2)

Please indent like this:

   # @debug-swap: enable virtualization of debug registers
   #     (default: false) (since 10.2)

> +#
>  # Since: 9.1
>  ##
>  { 'struct': 'SevCommonProperties',
>    'data': { '*sev-device': 'str',
>              '*cbitpos': 'uint32',
>              'reduced-phys-bits': 'uint32',
> -            '*kernel-hashes': 'bool' } }
> +            '*kernel-hashes': 'bool',
> +            '*debug-swap': 'bool' } }
>  
>  ##
>  # @SevGuestProperties:


