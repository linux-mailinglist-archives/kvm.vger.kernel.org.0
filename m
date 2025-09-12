Return-Path: <kvm+bounces-57392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA21B54AF5
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 13:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EFEEA05E61
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 11:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71B3301463;
	Fri, 12 Sep 2025 11:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L0OtoQ2Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4E32FFDD6
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 11:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757676153; cv=none; b=CQvX9NtYHVtBSKiL8oqFDPmwDf5AINFdxtyAe1x2IY1jF8CWo+4nwE6xJmX+0Nm+MDEglAAjYPUehtDf2/b1kKLJGRfVGF4C7rFfRbUi+D6SThmFruaSsGOoNGxkr38egw+9WKp7hId+RSrZLL5dKznM22TI1QOkqSjAidMi838=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757676153; c=relaxed/simple;
	bh=O9tmDEDiYdfECDlWIT7oabY9/hdkBwOiNYRxbgQnUig=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NpgFqS4hECS3Z680f7yTa+powQ8+ToRl4lLh4PJZOrLJI7M1hblOD1PmaRwokhJYLBMulX7t5K/valMw15OpQTnmpHXRmlclmRc8wuxunJQGccXIYvHiIxVQOESMZe5gTFgfzmfppdbl7bVYTINDoEDFuUGeb1secI9rTXukhTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L0OtoQ2Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757676150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JBBrlNDeYgfjdowSghqxoXE7iIKNSQ/itbg/58J5Nuw=;
	b=L0OtoQ2QOFUalJRvQ5vFeU0AjmNhe1lZdZ2BULCWWAnZ7BxQ/bGjW34yLZBQjxQehkfmKA
	eHjjXybsCSOqJ1PGdw6fECOXMrsz8qIf15EUznVKB3oALJaNCskTZuWv0C3OzVlKJa4D7R
	VAyVITJXPEmv9mWcDZ2DmNizkbXK4P4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-ZOMYNIcVPL-jhWTgVzYORw-1; Fri,
 12 Sep 2025 07:22:28 -0400
X-MC-Unique: ZOMYNIcVPL-jhWTgVzYORw-1
X-Mimecast-MFC-AGG-ID: ZOMYNIcVPL-jhWTgVzYORw_1757676146
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 882511800451;
	Fri, 12 Sep 2025 11:22:26 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F176518003FC;
	Fri, 12 Sep 2025 11:22:25 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 683E721E6A27; Fri, 12 Sep 2025 13:22:23 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Sean Christopherson
 <seanjc@google.com>,  qemu-devel <qemu-devel@nongnu.org>,
  <kvm@vger.kernel.org>,  "Daniel P. Berrange" <berrange@redhat.com>,
  Eduardo Habkost <eduardo@habkost.net>,  Eric Blake <eblake@redhat.com>,
  Markus Armbruster <armbru@redhat.com>,  Marcelo Tosatti
 <mtosatti@redhat.com>,  Zhao Liu <zhao1.liu@intel.com>,  Nikunj A Dadhania
 <nikunj@amd.com>,  Tom Lendacky <thomas.lendacky@amd.com>,  Michael Roth
 <michael.roth@amd.com>,  Neeraj Upadhyay <neeraj.upadhyay@amd.com>,  Roy
 Hopkins <roy.hopkins@randomman.co.uk>,  Ketan Chaturvedi
 <Ketan.Chaturvedi@amd.com>
Subject: Re: [RFC PATCH 6/7] target/i386: SEV: Add support for setting TSC
 frequency for Secure TSC
In-Reply-To: <23a293fca3e2ac22c7da052123e27c2794f40932.1757589490.git.naveen@kernel.org>
	(Naveen N. Rao's message of "Thu, 11 Sep 2025 17:24:25 +0530")
References: <cover.1757589490.git.naveen@kernel.org>
	<23a293fca3e2ac22c7da052123e27c2794f40932.1757589490.git.naveen@kernel.org>
Date: Fri, 12 Sep 2025 13:22:23 +0200
Message-ID: <87frcr9aq8.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

"Naveen N Rao (AMD)" <naveen@kernel.org> writes:

> Add support for configuring the TSC frequency when Secure TSC is enabled
> in SEV-SNP guests through a new "tsc-frequency" property on SEV-SNP
> guest objects, similar to the vCPU-specific property used by regular
> guests and TDX. A new property is needed since SEV-SNP guests require
> the TSC frequency to be specified during early SNP_LAUNCH_START command
> before any vCPUs are created.
>
> The user-provided TSC frequency is set through KVM_SET_TSC_KHZ before
> issuing KVM_SEV_SNP_LAUNCH_START.
>
> Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

[...]

> diff --git a/qapi/qom.json b/qapi/qom.json
> index b05a475ef499..5b99148cb790 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1102,6 +1102,9 @@
>  #
>  # @secure-tsc: enable Secure TSC (default: false) (since 10.2)
>  #
> +# @tsc-frequency: set secure TSC frequency. Only valid if Secure TSC
> +#     is enabled (default: zero) (since 10.2)

Two spaces between sentences for consistency, please.

> +#
>  # Since: 9.1
>  ##
>  { 'struct': 'SevSnpGuestProperties',
> @@ -1114,7 +1117,8 @@
>              '*author-key-enabled': 'bool',
>              '*host-data': 'str',
>              '*vcek-disabled': 'bool',
> -            '*secure-tsc': 'bool' } }
> +            '*secure-tsc': 'bool',
> +            '*tsc-frequency': 'uint32' } }
>  
>  ##
>  # @TdxGuestProperties:


