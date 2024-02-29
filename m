Return-Path: <kvm+bounces-10458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D22386C3D2
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 09:40:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C4F0B24865
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831C654BC5;
	Thu, 29 Feb 2024 08:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ujp2QTfT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE435381A
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 08:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709195876; cv=none; b=MVRI4cBrQYIK6Ma6vmeMJtL6XyepvcTXVETiMuYbvUy5amiDyafUVKtGMcrXRyfzPIslFZJSXrRAQ5EjislZQTTyEAxur/8y7bYHzZM2eNIdD8SxbbUERk7HvJJ7oilB7Kn9/Qht3anZdJiB2YfhIBkfe0feskzhyPadpoQO0PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709195876; c=relaxed/simple;
	bh=zVhlPddmaAAR4jzdb9Kbl/uj4RNVr0lC2Np7Xz7TybE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LLmYkjTleQ/t5g/C3xZchjVl5aEj+snUkKabdEMYR6zmrzIODS/bpDLI84yShIXyN+nDQudTKxkAIMCI6jeXITTp98it5BYAh9uWc2T8B3p1LDm6pu9hmXZRhNuCU+j2Mpsvro+O+L5v+g0X3C9DnEZTUDGWXavWYjEQ1HSES9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ujp2QTfT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709195872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bwmgSL8MZTBXd9LExpXGbveVK/spOqi1tYW6su6x9mk=;
	b=Ujp2QTfT/0V8ZVsEL+7R6tFsxR6H1f+CDsC2YlTKvArLClDJIPwPN9hNkgxf0Fbp+/gL3P
	6LSrtWtQk9yYIGVEeUdX3YJwje6jJlPPP9w5Pf+NZ72sUaP/IkqBvENoi5ojj9T9+WYBAT
	CfN+RwuUJShVfxBBob0BMFL/dhHBhH0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-mfh2rIjXNtKjOpe44CSN3w-1; Thu, 29 Feb 2024 03:37:49 -0500
X-MC-Unique: mfh2rIjXNtKjOpe44CSN3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2AAE83BA8E;
	Thu, 29 Feb 2024 08:37:48 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DE1D2166B33;
	Thu, 29 Feb 2024 08:37:48 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id A177021E6740; Thu, 29 Feb 2024 09:37:44 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  David Hildenbrand
 <david@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  Eduardo Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Yanan Wang
 <wangyanan55@huawei.com>,  "Michael S. Tsirkin" <mst@redhat.com>,  Richard
 Henderson <richard.henderson@linaro.org>,  Ani Sinha
 <anisinha@redhat.com>,  Peter Xu <peterx@redhat.com>,  Cornelia Huck
 <cohuck@redhat.com>,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eric
 Blake <eblake@redhat.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  kvm@vger.kernel.org,  qemu-devel@nongnu.org,  Michael Roth
 <michael.roth@amd.com>,  Claudio Fontana <cfontana@suse.de>,  Gerd
 Hoffmann <kraxel@redhat.com>,  Isaku Yamahata <isaku.yamahata@gmail.com>,
  Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v5 30/65] i386/tdx: Support user configurable
 mrconfigid/mrowner/mrownerconfig
In-Reply-To: <20240229063726.610065-31-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Thu, 29 Feb 2024 01:36:51 -0500")
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
	<20240229063726.610065-31-xiaoyao.li@intel.com>
Date: Thu, 29 Feb 2024 09:37:44 +0100
Message-ID: <87edcv1x9j.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
> can be provided for TDX attestation. Detailed meaning of them can be
> found: https://lore.kernel.org/qemu-devel/31d6dbc1-f453-4cef-ab08-4813f4e=
0ff92@intel.com/
>
> Allow user to specify those values via property mrconfigid, mrowner and
> mrownerconfig. They are all in base64 format.
>
> example
> -object tdx-guest, \
>   mrconfigid=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRW=
eJq83v,\
>   mrowner=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq=
83v,\
>   mrownerconfig=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wE=
jRWeJq83v
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>
> ---
> Changes in v5:
>  - refine the description of QAPI properties and add description of
>    default value when not specified;
>
> Changes in v4:
>  - describe more of there fields in qom.json
>  - free the old value before set new value to avoid memory leak in
>    _setter(); (Daniel)
>
> Changes in v3:
>  - use base64 encoding instread of hex-string;
> ---
>  qapi/qom.json         | 17 ++++++++-
>  target/i386/kvm/tdx.c | 87 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.h |  3 ++
>  3 files changed, 106 insertions(+), 1 deletion(-)
>
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 89ed89b9b46e..cac875349a3a 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -905,10 +905,25 @@
>  #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>  #     be set, otherwise they refuse to boot.
>  #
> +# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
> +#     e.g., run-time or OS configuration (base64 encoded SHA384 digest).
> +#     (A default value 0 of SHA384 is used when absent).

Suggest to drop the parenthesis in the last sentence.

@mrconfigid is a string, so the default value can't be 0.  Actually,
it's not just any string, but a base64 encoded SHA384 digest, which
means it must be exactly 96 hex digits.  So it can't be "0", either.  It
could be
"00000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000".
More on this below.

> +#
> +# @mrowner: ID for the guest TD=E2=80=99s owner (base64 encoded SHA384 d=
igest).
> +#     (A default value 0 of SHA384 is used when absent).
> +#
> +# @mrownerconfig: ID for owner-defined configuration of the guest TD,
> +#     e.g., specific to the workload rather than the run-time or OS
> +#     (base64 encoded SHA384 digest). (A default value 0 of SHA384 is
> +#     used when absent).
> +#
>  # Since: 9.0
>  ##
>  { 'struct': 'TdxGuestProperties',
> -  'data': { '*sept-ve-disable': 'bool' } }
> +  'data': { '*sept-ve-disable': 'bool',
> +            '*mrconfigid': 'str',
> +            '*mrowner': 'str',
> +            '*mrownerconfig': 'str' } }
>=20=20
>  ##
>  # @ThreadContextProperties:
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index d0ad4f57b5d0..4ce2f1d082ce 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -13,6 +13,7 @@
>=20=20
>  #include "qemu/osdep.h"
>  #include "qemu/error-report.h"
> +#include "qemu/base64.h"
>  #include "qapi/error.h"
>  #include "qom/object_interfaces.h"
>  #include "standard-headers/asm-x86/kvm_para.h"
> @@ -516,6 +517,7 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>      X86CPU *x86cpu =3D X86_CPU(cpu);
>      CPUX86State *env =3D &x86cpu->env;
>      g_autofree struct kvm_tdx_init_vm *init_vm =3D NULL;
> +    size_t data_len;
>      int r =3D 0;
>=20=20
>      object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
> @@ -528,6 +530,38 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>      init_vm =3D g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>                          sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_=
ENTRIES);
>=20=20
> +#define SHA384_DIGEST_SIZE  48
> +
> +    if (tdx_guest->mrconfigid) {
> +        g_autofree uint8_t *data =3D qbase64_decode(tdx_guest->mrconfigi=
d,
> +                              strlen(tdx_guest->mrconfigid), &data_len, =
errp);
> +        if (!data || data_len !=3D SHA384_DIGEST_SIZE) {
> +            error_setg(errp, "TDX: failed to decode mrconfigid");
> +            return -1;
> +        }
> +        memcpy(init_vm->mrconfigid, data, data_len);
> +    }

When @mrconfigid is absent, the property remains null, and this
conditional is not executed.  init_vm->mrconfigid[], an array of 6
__u64, remains all zero.  How does the kernel treat that?

> +
> +    if (tdx_guest->mrowner) {
> +        g_autofree uint8_t *data =3D qbase64_decode(tdx_guest->mrowner,
> +                              strlen(tdx_guest->mrowner), &data_len, err=
p);
> +        if (!data || data_len !=3D SHA384_DIGEST_SIZE) {
> +            error_setg(errp, "TDX: failed to decode mrowner");
> +            return -1;
> +        }
> +        memcpy(init_vm->mrowner, data, data_len);
> +    }
> +
> +    if (tdx_guest->mrownerconfig) {
> +        g_autofree uint8_t *data =3D qbase64_decode(tdx_guest->mrownerco=
nfig,
> +                              strlen(tdx_guest->mrownerconfig), &data_le=
n, errp);
> +        if (!data || data_len !=3D SHA384_DIGEST_SIZE) {
> +            error_setg(errp, "TDX: failed to decode mrownerconfig");
> +            return -1;
> +        }
> +        memcpy(init_vm->mrownerconfig, data, data_len);
> +    }
> +
>      r =3D kvm_vm_enable_cap(kvm_state, KVM_CAP_MAX_VCPUS, 0, ms->smp.cpu=
s);
>      if (r < 0) {
>          error_setg(errp, "Unable to set MAX VCPUS to %d", ms->smp.cpus);

[...]


