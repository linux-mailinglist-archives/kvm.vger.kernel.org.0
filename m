Return-Path: <kvm+bounces-37314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8014A28689
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:30:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABB7C1884241
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 09:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A0522A7EC;
	Wed,  5 Feb 2025 09:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hfzIKYIZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D4D22A7E2
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 09:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738747748; cv=none; b=K9Y38ElLAtoQT/friC6LXgXi7XhVycP+/ofAU3RjNlOCt3WSYC0dXqWVnDEvzr9eH22x3jNwPc/bIiXPqYOSSuGatFQRaFIFPUulo1KyYEQYIMf9GpznJf1jJJI3Aa2b1YgV5qwcwRUm4LsNICKNeP5YSxu9sk+g4efkdisjDAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738747748; c=relaxed/simple;
	bh=v4x/tnSUbWOu33tEXCaOWEFpmQlWFCYXXspppal0zZE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JmSaAqkLkLM6MR1WWdXrbiUh4EmSHSVW+SMDphiBuG3sGrlFHwCOR9X+FqDkpbhpTGp7vgcYPIQlhVdOIzebXqGZ94PDiEMwSR1azuHQpSOUjFttOnN7aKEUf+pgIMtYUQMnQ22saOuKcdG5ZaiW9FdBIb6m/W9NSY5cOd5yGVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hfzIKYIZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738747746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iHa01BNtNcX3iTcO26w0aRNngCZY4JV7FZ6ob4PLOV4=;
	b=hfzIKYIZRuwdnefMdxFp6maMukzur4RhX/CgS0zKNSJB3Z2jOzx9FgvX4ktlWFiFMcv2UO
	sy1TPnV3ctm962CjpMWvf8Sm/RbM1er307qSUqPToEgNp2Z1t4vszBZ8w1ecoXMzNNobTQ
	riOcEKeObGYggs0NRbGecQ2CUCBn8Q8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-pcs6IkN5NZuN9NGIZ65rrw-1; Wed,
 05 Feb 2025 04:29:01 -0500
X-MC-Unique: pcs6IkN5NZuN9NGIZ65rrw-1
X-Mimecast-MFC-AGG-ID: pcs6IkN5NZuN9NGIZ65rrw
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1EC7B180056F;
	Wed,  5 Feb 2025 09:29:00 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.40])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BDEB1800360;
	Wed,  5 Feb 2025 09:28:59 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 4C8B021E6A28; Wed, 05 Feb 2025 10:28:57 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9?=
 <berrange@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,  Igor
 Mammedov <imammedo@redhat.com>,  Zhao Liu <zhao1.liu@intel.com>,  "Michael
 S. Tsirkin" <mst@redhat.com>,  Eric Blake <eblake@redhat.com>,  Peter
 Maydell <peter.maydell@linaro.org>,  Marcelo Tosatti
 <mtosatti@redhat.com>,  Huacai Chen <chenhuacai@kernel.org>,  Rick
 Edgecombe <rick.p.edgecombe@intel.com>,  Francesco Lavra
 <francescolavra.fl@gmail.com>,  qemu-devel@nongnu.org,
  kvm@vger.kernel.org
Subject: Re: [PATCH v7 48/52] i386/tdx: Fetch and validate CPUID of TD guest
In-Reply-To: <20250124132048.3229049-49-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Fri, 24 Jan 2025 08:20:44 -0500")
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
	<20250124132048.3229049-49-xiaoyao.li@intel.com>
Date: Wed, 05 Feb 2025 10:28:57 +0100
Message-ID: <87o6zg3fl2.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Use KVM_TDX_GET_CPUID to get the CPUIDs that are managed and enfored
> by TDX module for TD guest. Check QEMU's configuration against the
> fetched data.
>
> Print wanring  message when 1. a feature is not supported but requested
> by QEMU or 2. QEMU doesn't want to expose a feature while it is enforced
> enabled.
>
> - If cpu->enforced_cpuid is not set, prints the warning message of both
> 1) and 2) and tweak QEMU's configuration.
>
> - If cpu->enforced_cpuid is set, quit if any case of 1) or 2).
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/cpu.c     | 33 ++++++++++++++-
>  target/i386/cpu.h     |  7 +++
>  target/i386/kvm/tdx.c | 99 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 137 insertions(+), 2 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index f1330627adbb..a948fd0bd674 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -5482,8 +5482,8 @@ static bool x86_cpu_have_filtered_features(X86CPU *=
cpu)
>      return false;
>  }
>=20=20
> -static void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64=
_t mask,
> -                                      const char *verbose_prefix)
> +void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
> +                               const char *verbose_prefix)
>  {
>      CPUX86State *env =3D &cpu->env;
>      FeatureWordInfo *f =3D &feature_word_info[w];
> @@ -5510,6 +5510,35 @@ static void mark_unavailable_features(X86CPU *cpu,=
 FeatureWord w, uint64_t mask,
>      }
>  }
>=20=20
> +void mark_forced_on_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
> +                             const char *verbose_prefix)
> +{
> +    CPUX86State *env =3D &cpu->env;
> +    FeatureWordInfo *f =3D &feature_word_info[w];
> +    int i;
> +
> +    if (!cpu->force_features) {
> +        env->features[w] |=3D mask;
> +    }
> +
> +    cpu->forced_on_features[w] |=3D mask;
> +
> +    if (!verbose_prefix) {
> +        return;
> +    }
> +
> +    for (i =3D 0; i < 64; ++i) {
> +        if ((1ULL << i) & mask) {
> +            g_autofree char *feat_word_str =3D feature_word_description(=
f);

Does not compile for me:

    ../target/i386/cpu.c: In function =E2=80=98mark_forced_on_features=E2=
=80=99:
    ../target/i386/cpu.c:5531:46: error: too few arguments to function =E2=
=80=98feature_word_description=E2=80=99
     5531 |             g_autofree char *feat_word_str =3D feature_word_des=
cription(f);
          |                                              ^~~~~~~~~~~~~~~~~~=
~~~~~~
    ../target/i386/cpu.c:5451:14: note: declared here
     5451 | static char *feature_word_description(FeatureWordInfo *f, uint3=
2_t bit)
          |              ^~~~~~~~~~~~~~~~~~~~~~~~

> +            warn_report("%s: %s%s%s [bit %d]",
> +                        verbose_prefix,
> +                        feat_word_str,
> +                        f->feat_names[i] ? "." : "",
> +                        f->feat_names[i] ? f->feat_names[i] : "", i);
> +        }
> +    }
> +}
> +
>  static void x86_cpuid_version_get_family(Object *obj, Visitor *v,
>                                           const char *name, void *opaque,
>                                           Error **errp)

[...]


