Return-Path: <kvm+bounces-30724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 780209BCB5F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36E12284155
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3F91D4154;
	Tue,  5 Nov 2024 11:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OxK+EoZ/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82961D3629
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 11:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730805261; cv=none; b=RauvX+C+SRHn3RMpysy0F4eUOyKH4WA1Lm2v6CZVDS/+fzr88DofD6YxbdEF7Wupq1XB9HvDjYmAcwzH9fOTCqjC/BOlRoL3+1PY7cJ6/tVXJrSix+Drw9MJdv6zX92MgONQYqd+uvgbtW9RnMLDVaoanYbh1NjmoKig8zkyDvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730805261; c=relaxed/simple;
	bh=ep8vzmwDe5FFVnuMaBH29D5iLcnRLgVXlfwlOWEv2CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YADtaN+1KO1GexrwB5dbitgEIswhjsxfCWbl+jkDYGH4cwt7gU0PjyCrYceEFr5f2Al/FJMWhs0oxwizIOwGg1xhTVVKnyoo9bDXoATuABCDhGtCkdmmwTCAKjaqkjVCFZwmlF94aPTtR9nik/ydlrKvWLJghyS+N5d+elMNxv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OxK+EoZ/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730805258;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=3FG8T0t0tfqrLp1wc3X1sk+VoTwvl6f29BL4XZWT+3M=;
	b=OxK+EoZ//OQhaUXl+H5/wa4mA1FI4b2m5STvSAHmHliZrE1QnT19D2OgYCLI9kuFKEXs4j
	og4DZ0xmOfQSWQv7b0tH9AiBKtlA0gqf/1gGeTZhp5v6H4VvId5YstDwyIQtNqwKKtN061
	1ohjteLtSY7Y1zQWlcr3aLMxPTVFFr8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-eTruY0xTNCeV66htOz5sfw-1; Tue,
 05 Nov 2024 06:14:15 -0500
X-MC-Unique: eTruY0xTNCeV66htOz5sfw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61CD219560B5;
	Tue,  5 Nov 2024 11:14:13 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AE4D19560AD;
	Tue,  5 Nov 2024 11:14:06 +0000 (UTC)
Date: Tue, 5 Nov 2024 11:14:03 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 60/60] docs: Add TDX documentation
Message-ID: <Zyn9-1N0XyOwjmf1@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-61-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-61-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Nov 05, 2024 at 01:24:08AM -0500, Xiaoyao Li wrote:
> Add docs/system/i386/tdx.rst for TDX support, and add tdx in
> confidential-guest-support.rst
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v6:
>  - Add more information of "Feature configuration"
>  - Mark TD Attestation as future work because KVM now drops the support
>    of it.
> 
> Changes in v5:
>  - Add TD attestation section and update the QEMU parameter;
> 
> Changes since v1:
>  - Add prerequisite of private gmem;
>  - update example command to launch TD;
> 
> Changes since RFC v4:
>  - add the restriction that kernel-irqchip must be split
> ---
>  docs/system/confidential-guest-support.rst |   1 +
>  docs/system/i386/tdx.rst                   | 155 +++++++++++++++++++++
>  docs/system/target-i386.rst                |   1 +
>  3 files changed, 157 insertions(+)
>  create mode 100644 docs/system/i386/tdx.rst
> 
> diff --git a/docs/system/confidential-guest-support.rst b/docs/system/confidential-guest-support.rst
> index 0c490dbda2b7..66129fbab64c 100644
> --- a/docs/system/confidential-guest-support.rst
> +++ b/docs/system/confidential-guest-support.rst
> @@ -38,6 +38,7 @@ Supported mechanisms
>  Currently supported confidential guest mechanisms are:
>  
>  * AMD Secure Encrypted Virtualization (SEV) (see :doc:`i386/amd-memory-encryption`)
> +* Intel Trust Domain Extension (TDX) (see :doc:`i386/tdx`)
>  * POWER Protected Execution Facility (PEF) (see :ref:`power-papr-protected-execution-facility-pef`)
>  * s390x Protected Virtualization (PV) (see :doc:`s390x/protvirt`)
>  
> diff --git a/docs/system/i386/tdx.rst b/docs/system/i386/tdx.rst
> new file mode 100644
> index 000000000000..60106b29bf72
> --- /dev/null
> +++ b/docs/system/i386/tdx.rst

> +Feature check
> +~~~~~~~~~~~~~
> +
> +QEMU checks if the final (CPU) features, determined by given cpu model and
> +explicit feature adjustment of "+featureA/-featureB", can be supported or not.
> +It can produce feature not supported warnning like

Typo in 'warnning' - repeated 'n'

> +
> +  "warning: host doesn't support requested feature: CPUID.07H:EBX.intel-pt [bit 25]"
> +
> +It will also procude warning like
> +
> +  "warning: TDX forcibly sets the feature: CPUID.80000007H:EDX.invtsc [bit 8]"
> +
> +if the fixed-1 feature is requested to be disabled explicitly. This is newly
> +added to QEMU for TDX because TDX has fixed-1 features that are enfored enabled
> +by TDX module and VMM cannot disable them.
> +
> +Launching a TD (TDX VM)
> +-----------------------
> +
> +To launch a TDX guest, below are new added and required:
> +
> +.. parsed-literal::
> +
> +    |qemu_system_x86| \\
> +        -object tdx-guest,id=tdx0 \\
> +        -machine ...,kernel-irqchip=split,confidential-guest-support=tdx0 \\
> +        -bios OVMF.fd \\
> +
> +restrictions

Capitalize initial "R"

> +------------


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


