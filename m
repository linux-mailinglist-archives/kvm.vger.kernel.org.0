Return-Path: <kvm+bounces-12286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3934D881127
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:44:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E210E2818F6
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 11:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECBAE3EA76;
	Wed, 20 Mar 2024 11:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UoPeDmaF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053D03D0C4
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 11:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710935084; cv=none; b=I2b7MwraSxr184gklpBHjJkMI6ptFPSJRpU6P9lbZR5uDr0Wr9WAG3habCwAJsaQe6awf5z1nZi1E4Cf2+bU3OisiIwyVD0TAW8Dg0CwGP4tpN95ex7aCPcIUZqyeYUk/hw/5ypuGlRVLE/BcOYtXzSh9p/Q2IA09duAorzKFAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710935084; c=relaxed/simple;
	bh=7yPr+/fzHv8HEdeqQ0yykS7LxjZKEKKhrljmyL9/2l4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCmsMGnyL7BEFl/Eb+mNAadEkpr7I/SEN7iiAm81y/+1rwaZ1nyZiqxGeAU5Aq3fhvDCq6QKd4cbi0PTgjlGeG8MlaEgZsQkmGsh0owO16TdRXjKW1zk2FPaikpjCOwHPmopiK+u2qd3dB9+DGUthA9vszRYR66Jia2SuRh/k2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UoPeDmaF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710935080;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=caJB97+iohvjmPt5J8Pk8XyfnDlkj9PniJFqzu0+JW4=;
	b=UoPeDmaFJpD09QLdlZ7AMPrUvy0ZVVxLX2ybi8F9XU+prAoZGQX5vv5HXPqSkD2EMe8LQ1
	CQiswf8VaowPeV11kxNm1Eijy3Lriyt9ZliH3/bagVd7CvM0FSTGWbMi8npWibjtDZ4JU5
	nLU7F1+xdJs57D2B/jOvPoH7rRGB//o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-pd-k7ZWIMm6_f9L5o9HK4g-1; Wed, 20 Mar 2024 07:44:37 -0400
X-MC-Unique: pd-k7ZWIMm6_f9L5o9HK4g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C245C803F61;
	Wed, 20 Mar 2024 11:44:36 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.205])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1292540C6DB7;
	Wed, 20 Mar 2024 11:44:34 +0000 (UTC)
Date: Wed, 20 Mar 2024 11:44:13 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 21/49] i386/sev: Introduce "sev-common" type to
 encapsulate common SEV state
Message-ID: <ZfrMDYk-gSQF04gQ@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-22-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-22-michael.roth@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Wed, Mar 20, 2024 at 03:39:17AM -0500, Michael Roth wrote:
> Currently all SEV/SEV-ES functionality is managed through a single
> 'sev-guest' QOM type. With upcoming support for SEV-SNP, taking this
> same approach won't work well since some of the properties/state
> managed by 'sev-guest' is not applicable to SEV-SNP, which will instead
> rely on a new QOM type with its own set of properties/state.
> 
> To prepare for this, this patch moves common state into an abstract
> 'sev-common' parent type to encapsulate properties/state that are
> common to both SEV/SEV-ES and SEV-SNP, leaving only SEV/SEV-ES-specific
> properties/state in the current 'sev-guest' type. This should not
> affect current behavior or command-line options.
> 
> As part of this patch, some related changes are also made:
> 
>   - a static 'sev_guest' variable is currently used to keep track of
>     the 'sev-guest' instance. SEV-SNP would similarly introduce an
>     'sev_snp_guest' static variable. But these instances are now
>     available via qdev_get_machine()->cgs, so switch to using that
>     instead and drop the static variable.
> 
>   - 'sev_guest' is currently used as the name for the static variable
>     holding a pointer to the 'sev-guest' instance. Re-purpose the name
>     as a local variable referring the 'sev-guest' instance, and use
>     that consistently throughout the code so it can be easily
>     distinguished from sev-common/sev-snp-guest instances.
> 
>   - 'sev' is generally used as the name for local variables holding a
>     pointer to the 'sev-guest' instance. In cases where that now points
>     to common state, use the name 'sev_common'; in cases where that now
>     points to state specific to 'sev-guest' instance, use the name
>     'sev_guest'
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  qapi/qom.json     |  32 ++--
>  target/i386/sev.c | 457 ++++++++++++++++++++++++++--------------------
>  target/i386/sev.h |   3 +
>  3 files changed, 281 insertions(+), 211 deletions(-)
> 
> diff --git a/qapi/qom.json b/qapi/qom.json
> index baae3a183f..66b5781ca6 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -875,12 +875,29 @@
>    'data': { '*filename': 'str' } }
>  
>  ##
> -# @SevGuestProperties:
> +# @SevCommonProperties:
>  #
> -# Properties for sev-guest objects.
> +# Properties common to objects that are derivatives of sev-common.
>  #
>  # @sev-device: SEV device to use (default: "/dev/sev")
>  #
> +# @cbitpos: C-bit location in page table entry (default: 0)
> +#
> +# @reduced-phys-bits: number of bits in physical addresses that become
> +#     unavailable when SEV is enabled
> +#
> +# Since: 2.12

Not quite sure what we've done in this scenario before.
It feels wierd to use '2.12' for the new base type, even
though in effect the properties all existed since 2.12 in
the sub-class.

Perhaps 'Since: 9.1' for the type, but 'Since: 2.12' for the
properties, along with an explanatory comment about stuff
moving into the new base type ?

Markus, opinions ?

> +##
> +{ 'struct': 'SevCommonProperties',
> +  'data': { '*sev-device': 'str',
> +            '*cbitpos': 'uint32',
> +            'reduced-phys-bits': 'uint32' } }
> +
> +##
> +# @SevGuestProperties:
> +#
> +# Properties for sev-guest objects.
> +#
>  # @dh-cert-file: guest owners DH certificate (encoded with base64)
>  #
>  # @session-file: guest owners session parameters (encoded with base64)
> @@ -889,11 +906,6 @@
>  #
>  # @handle: SEV firmware handle (default: 0)
>  #
> -# @cbitpos: C-bit location in page table entry (default: 0)
> -#
> -# @reduced-phys-bits: number of bits in physical addresses that become
> -#     unavailable when SEV is enabled
> -#
>  # @kernel-hashes: if true, add hashes of kernel/initrd/cmdline to a
>  #     designated guest firmware page for measured boot with -kernel
>  #     (default: false) (since 6.2)
> @@ -901,13 +913,11 @@
>  # Since: 2.12
>  ##
>  { 'struct': 'SevGuestProperties',
> -  'data': { '*sev-device': 'str',
> -            '*dh-cert-file': 'str',
> +  'base': 'SevCommonProperties',
> +  'data': { '*dh-cert-file': 'str',
>              '*session-file': 'str',
>              '*policy': 'uint32',
>              '*handle': 'uint32',
> -            '*cbitpos': 'uint32',
> -            'reduced-phys-bits': 'uint32',
>              '*kernel-hashes': 'bool' } }
>  
>  ##

> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 9dab4060b8..63a220de5e 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -40,48 +40,53 @@
>  #include "hw/i386/pc.h"
>  #include "exec/address-spaces.h"
>  
> -#define TYPE_SEV_GUEST "sev-guest"
> +OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
>  OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
>  
> -
> -/**
> - * SevGuestState:
> - *
> - * The SevGuestState object is used for creating and managing a SEV
> - * guest.
> - *
> - * # $QEMU \
> - *         -object sev-guest,id=sev0 \
> - *         -machine ...,memory-encryption=sev0
> - */
> -struct SevGuestState {
> +struct SevCommonState {
>      X86ConfidentialGuest parent_obj;
>  
>      int kvm_type;
>  
>      /* configuration parameters */
>      char *sev_device;
> -    uint32_t policy;
> -    char *dh_cert_file;
> -    char *session_file;
>      uint32_t cbitpos;
>      uint32_t reduced_phys_bits;
> -    bool kernel_hashes;
>  
>      /* runtime state */
> -    uint32_t handle;
>      uint8_t api_major;
>      uint8_t api_minor;
>      uint8_t build_id;
>      int sev_fd;
>      SevState state;
> -    gchar *measurement;
>  
>      uint32_t reset_cs;
>      uint32_t reset_ip;
>      bool reset_data_valid;
>  };
>  
> +/**
> + * SevGuestState:
> + *
> + * The SevGuestState object is used for creating and managing a SEV
> + * guest.
> + *
> + * # $QEMU \
> + *         -object sev-guest,id=sev0 \
> + *         -machine ...,memory-encryption=sev0
> + */
> +struct SevGuestState {
> +    SevCommonState sev_common;
> +    gchar *measurement;
> +
> +    /* configuration parameters */
> +    uint32_t handle;
> +    uint32_t policy;
> +    char *dh_cert_file;
> +    char *session_file;
> +    bool kernel_hashes;
> +};
> +
>  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>  #define DEFAULT_SEV_DEVICE      "/dev/sev"
>  
> @@ -127,7 +132,6 @@ typedef struct QEMU_PACKED PaddedSevHashTable {
>  
>  QEMU_BUILD_BUG_ON(sizeof(PaddedSevHashTable) % 16 != 0);
>  
> -static SevGuestState *sev_guest;
>  static Error *sev_mig_blocker;
>  
>  static const char *const sev_fw_errlist[] = {
> @@ -208,21 +212,21 @@ fw_error_to_str(int code)
>  }
>  
>  static bool
> -sev_check_state(const SevGuestState *sev, SevState state)
> +sev_check_state(const SevCommonState *sev_common, SevState state)
>  {
> -    assert(sev);
> -    return sev->state == state ? true : false;
> +    assert(sev_common);
> +    return sev_common->state == state ? true : false;
>  }
>  
>  static void
> -sev_set_guest_state(SevGuestState *sev, SevState new_state)
> +sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
>  {
>      assert(new_state < SEV_STATE__MAX);
> -    assert(sev);
> +    assert(sev_common);
>  
> -    trace_kvm_sev_change_state(SevState_str(sev->state),
> +    trace_kvm_sev_change_state(SevState_str(sev_common->state),
>                                 SevState_str(new_state));
> -    sev->state = new_state;
> +    sev_common->state = new_state;
>  }
>  
>  static void
> @@ -289,111 +293,61 @@ static struct RAMBlockNotifier sev_ram_notifier = {
>      .ram_block_removed = sev_ram_block_removed,
>  };
>  
> -static void
> -sev_guest_finalize(Object *obj)
> -{
> -}
> -
> -static char *
> -sev_guest_get_session_file(Object *obj, Error **errp)
> -{
> -    SevGuestState *s = SEV_GUEST(obj);
> -
> -    return s->session_file ? g_strdup(s->session_file) : NULL;
> -}
> -
> -static void
> -sev_guest_set_session_file(Object *obj, const char *value, Error **errp)
> -{
> -    SevGuestState *s = SEV_GUEST(obj);
> -
> -    s->session_file = g_strdup(value);
> -}
> -
> -static char *
> -sev_guest_get_dh_cert_file(Object *obj, Error **errp)
> -{
> -    SevGuestState *s = SEV_GUEST(obj);
> -
> -    return g_strdup(s->dh_cert_file);
> -}
> -
> -static void
> -sev_guest_set_dh_cert_file(Object *obj, const char *value, Error **errp)
> -{
> -    SevGuestState *s = SEV_GUEST(obj);
> -
> -    s->dh_cert_file = g_strdup(value);
> -}
> -
> -static char *
> -sev_guest_get_sev_device(Object *obj, Error **errp)
> -{
> -    SevGuestState *sev = SEV_GUEST(obj);
> -
> -    return g_strdup(sev->sev_device);
> -}
> -
> -static void
> -sev_guest_set_sev_device(Object *obj, const char *value, Error **errp)
> -{
> -    SevGuestState *sev = SEV_GUEST(obj);
> -
> -    sev->sev_device = g_strdup(value);
> -}
> -
> -static bool sev_guest_get_kernel_hashes(Object *obj, Error **errp)
> -{
> -    SevGuestState *sev = SEV_GUEST(obj);
> -
> -    return sev->kernel_hashes;
> -}
> -
> -static void sev_guest_set_kernel_hashes(Object *obj, bool value, Error **errp)
> -{
> -    SevGuestState *sev = SEV_GUEST(obj);
> -
> -    sev->kernel_hashes = value;
> -}
> -
>  bool
>  sev_enabled(void)
>  {
> -    return !!sev_guest;
> +    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
> +
> +    return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_COMMON);
>  }
>  
>  bool
>  sev_es_enabled(void)
>  {
> -    return sev_enabled() && (sev_guest->policy & SEV_POLICY_ES);
> +    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
> +
> +    return sev_enabled() && (SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
>  }
>  
>  uint32_t
>  sev_get_cbit_position(void)
>  {
> -    return sev_guest ? sev_guest->cbitpos : 0;
> +    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> +
> +    return sev_common ? sev_common->cbitpos : 0;
>  }
>  
>  uint32_t
>  sev_get_reduced_phys_bits(void)
>  {
> -    return sev_guest ? sev_guest->reduced_phys_bits : 0;
> +    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> +
> +    return sev_common ? sev_common->reduced_phys_bits : 0;
>  }
>  
>  static SevInfo *sev_get_info(void)
>  {
>      SevInfo *info;
> +    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> +    SevGuestState *sev_guest =
> +        (SevGuestState *)object_dynamic_cast(OBJECT(sev_common),
> +                                             TYPE_SEV_GUEST);
>  
>      info = g_new0(SevInfo, 1);
>      info->enabled = sev_enabled();
>  
>      if (info->enabled) {
> -        info->api_major = sev_guest->api_major;
> -        info->api_minor = sev_guest->api_minor;
> -        info->build_id = sev_guest->build_id;
> -        info->policy = sev_guest->policy;
> -        info->state = sev_guest->state;
> -        info->handle = sev_guest->handle;
> +        if (sev_guest) {
> +            info->handle = sev_guest->handle;
> +        }
> +        info->api_major = sev_common->api_major;
> +        info->api_minor = sev_common->api_minor;
> +        info->build_id = sev_common->build_id;
> +        info->state = sev_common->state;
> +        /* we only report the lower 32-bits of policy for SNP, ok for now... */
> +        info->policy =
> +            (uint32_t)object_property_get_uint(OBJECT(sev_common),
> +                                               "policy", NULL);
>      }

I think we can change this 'policy' field to 'int64'.

Going from int32 to int64 doesn't change the encoding in JSON
or cli properites. SEV/SEV-ES guests will still only use values
that fit within int32, so existing users of QEMU won't notice
a change.

Apps that want to use SEV-SNP will know that they can have
policy values exceeding int32, but since that's net new code
to suupport SEV-SNP there's no back compat issue.


> @@ -519,6 +473,8 @@ static SevCapability *sev_get_capabilities(Error **errp)
>      size_t pdh_len = 0, cert_chain_len = 0, cpu0_id_len = 0;
>      uint32_t ebx;
>      int fd;
> +    SevCommonState *sev_common;
> +    char *sev_device;

Declare 'g_autofree char *sev_device = NULL;'

>  
>      if (!kvm_enabled()) {
>          error_setg(errp, "KVM not enabled");
> @@ -529,12 +485,21 @@ static SevCapability *sev_get_capabilities(Error **errp)
>          return NULL;
>      }
>  
> -    fd = open(DEFAULT_SEV_DEVICE, O_RDWR);
> +    sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> +    if (!sev_common) {
> +        error_setg(errp, "SEV is not configured");
> +    }

Missing 'return' ?

> +
> +    sev_device = object_property_get_str(OBJECT(sev_common), "sev-device",
> +                                         &error_abort);
> +    fd = open(sev_device, O_RDWR);
>      if (fd < 0) {
>          error_setg_errno(errp, errno, "SEV: Failed to open %s",
>                           DEFAULT_SEV_DEVICE);
> +        g_free(sev_device);
>          return NULL;
>      }
> +    g_free(sev_device);

These 'g_free' are redundant with g_autofree usage on the declaration.

>  
>      if (sev_get_pdh_info(fd, &pdh_data, &pdh_len,
>                           &cert_chain_data, &cert_chain_len, errp)) {
> @@ -577,7 +542,7 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
>  {
>      struct kvm_sev_attestation_report input = {};
>      SevAttestationReport *report = NULL;
> -    SevGuestState *sev = sev_guest;
> +    SevCommonState *sev_common;

I think it would have been nicer to just keep the variable
just called 'sev', except in the few cases where you needed to
have variables for both parent & subclass in the same method.
This diff would be much smaller too.

That's a bit bikeshedding though, so not too bothered either
way.

>      g_autofree guchar *data = NULL;
>      g_autofree guchar *buf = NULL;
>      gsize len;
> @@ -602,8 +567,10 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
>          return NULL;
>      }
>  
> +    sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> +
>      /* Query the report length */
> -    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> +    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
>              &input, &err);
>      if (ret < 0) {
>          if (err != SEV_RET_INVALID_LEN) {
> @@ -619,7 +586,7 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
>      memcpy(input.mnonce, buf, sizeof(input.mnonce));
>  
>      /* Query the report */
> -    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> +    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
>              &input, &err);
>      if (ret) {
>          error_setg_errno(errp, errno, "SEV: Failed to get attestation report"

> +
> +/* sev guest info common to sev/sev-es/sev-snp */
> +static const TypeInfo sev_common_info = {
> +    .parent = TYPE_X86_CONFIDENTIAL_GUEST,
> +    .name = TYPE_SEV_COMMON,
> +    .instance_size = sizeof(SevCommonState),
> +    .class_init = sev_common_class_init,
> +    .instance_init = sev_common_instance_init,
> +    .abstract = true,
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_USER_CREATABLE },
> +        { }
> +    }
> +};

It feels wierd to declare a type as "abstract", and at
the same time declare it "user creatable". I know this
was a simple short-cut to avoid repeating the .interfaces
on every sub-class, but I still think it would be better
to put the "user creatable" marker on the concrete impls
instead.

Also how about using OBJECT_DEFINE_ABSTRACT_TYPE here
and also converting the subclasses to use
OBJECT_DEFINE_TYPE_WITH_INTERFACES ?



With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


