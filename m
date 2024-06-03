Return-Path: <kvm+bounces-18643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A82D58D81D3
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AF06B22EB8
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 12:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DAF5126F27;
	Mon,  3 Jun 2024 12:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KNJker3N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B3084A4F
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 12:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717416179; cv=none; b=cjp3mp/0tbIYFlom709ZjXRU4EskjDArkHV6/mF/S79Di1S1QodGybxxgAiBCXqw6vH8CsT4iqV3yD2/eo3/DkUWZNhCamEDYMbH+iilEJKkfx/OqlEO3RkF2XzUpeNXJbwQflQe5FCzT/8v3rtGu+9hjWgTBPRaOtejEmJcqfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717416179; c=relaxed/simple;
	bh=TqxgXaBBlqnUdvXnDc4EyZ2VbnQ8XQSByWieEIUlTMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZC5UZiHrVfOQyHIzpu3d8zirL4rQ01G0MBe7EQj03pE2kACqH9yAXNyrAo8XIBbURgCH0lE8LLODDFg/D+JHev/pcCqDZ9vABzAU79//omDBhutvEWDXu7U6lczkSJYPDhlyz8whpgscI7ot9yxiCgjPeswl7Bmq3OtYrH1hA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KNJker3N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717416176;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=718OME3f206EimzGuV+41hjkPwMkk0sQs3pFEmAmivs=;
	b=KNJker3NHaJRCxb+mDlZBjYWbd8Rj5yJ79RhxN800Z0yj3q5DxsJ4SZg5F0uaG5uOWo9sc
	V2E9txBvgdIQKZ9R/rdqYAyrrwpcYrd5EHUJnRThNWubibLjLl85gq8tw7uHMSlXALzM7P
	M0Q8pwRE+fnSYxRZ8qlpI1ahUfXkhqg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-JFxUIcMROLyVjmcJGTsgXQ-1; Mon, 03 Jun 2024 08:02:53 -0400
X-MC-Unique: JFxUIcMROLyVjmcJGTsgXQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76D3E85A58C;
	Mon,  3 Jun 2024 12:02:52 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.80])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D5A3B402EB1;
	Mon,  3 Jun 2024 12:02:50 +0000 (UTC)
Date: Mon, 3 Jun 2024 13:02:48 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com,
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com,
	pbonzini@redhat.com, thomas.lendacky@amd.com,
	isaku.yamahata@intel.com, kvm@vger.kernel.org, anisinha@redhat.com
Subject: Re: [PATCH v4 07/31] i386/sev: Introduce 'sev-snp-guest' object
Message-ID: <Zl2w6KktLnFxq83Y@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-8-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240530111643.1091816-8-pankaj.gupta@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Thu, May 30, 2024 at 06:16:19AM -0500, Pankaj Gupta wrote:

> +# @policy: the 'POLICY' parameter to the SNP_LAUNCH_START command, as
> +#     defined in the SEV-SNP firmware ABI (default: 0x30000)
> +#
> +# @guest-visible-workarounds: 16-byte, base64-encoded blob to report
> +#     hypervisor-defined workarounds, corresponding to the 'GOSVW'
> +#     parameter of the SNP_LAUNCH_START command defined in the SEV-SNP
> +#     firmware ABI (default: all-zero)
> +#
> +# @id-block: 96-byte, base64-encoded blob to provide the 'ID Block'
> +#     structure for the SNP_LAUNCH_FINISH command defined in the
> +#     SEV-SNP firmware ABI (default: all-zero)
> +#
> +# @id-auth: 4096-byte, base64-encoded blob to provide the 'ID
> +#     Authentication Information Structure' for the SNP_LAUNCH_FINISH
> +#     command defined in the SEV-SNP firmware ABI (default: all-zero)
> +#
> +# @auth-key-enabled: true if 'id-auth' blob contains the 'AUTHOR_KEY'
> +#     field defined SEV-SNP firmware ABI (default: false)

In 'id-auth', 'auth' is short for 'authentication'

In 'auth-key-enabled', 'auth' is short for 'author'.

Shortening 'authentication' is a compelling win. Shorting 'author'
is not much of a win.

So to make it less ambiguous, how about '@author-key-enabled' for
the field ?

> +#
> +# @host-data: 32-byte, base64-encoded, user-defined blob to provide to
> +#     the guest, as documented for the 'HOST_DATA' parameter of the
> +#     SNP_LAUNCH_FINISH command in the SEV-SNP firmware ABI (default:
> +#     all-zero)
> +#
> +# @vcek-disabled: Guests are by default allowed to choose between VLEK
> +#     (Versioned Loaded Endorsement Key) or VCEK (Versioned Chip
> +#     Endorsement Key) when requesting attestation reports from
> +#     firmware. Set this to true to disable the use of VCEK.
> +#     (default: false) (since: 9.1)
> +#
> +# Since: 9.1
> +##
> +{ 'struct': 'SevSnpGuestProperties',
> +  'base': 'SevCommonProperties',
> +  'data': {
> +            '*policy': 'uint64',
> +            '*guest-visible-workarounds': 'str',
> +            '*id-block': 'str',
> +            '*id-auth': 'str',
> +            '*auth-key-enabled': 'bool',
> +            '*host-data': 'str',
> +            '*vcek-disabled': 'bool' } }
>  
>  ##
>  # @ThreadContextProperties:
> @@ -1007,6 +1062,7 @@
>      { 'name': 'secret_keyring',
>        'if': 'CONFIG_SECRET_KEYRING' },
>      'sev-guest',
> +    'sev-snp-guest',
>      'thread-context',
>      's390-pv-guest',
>      'throttle-group',
> @@ -1077,6 +1133,7 @@
>        'secret_keyring':             { 'type': 'SecretKeyringProperties',
>                                        'if': 'CONFIG_SECRET_KEYRING' },
>        'sev-guest':                  'SevGuestProperties',
> +      'sev-snp-guest':              'SevSnpGuestProperties',
>        'thread-context':             'ThreadContextProperties',
>        'throttle-group':             'ThrottleGroupProperties',
>        'tls-creds-anon':             'TlsCredsAnonProperties',
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index c141f4fed4..841b45f59b 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -42,6 +42,7 @@
>  
>  OBJECT_DECLARE_TYPE(SevCommonState, SevCommonStateClass, SEV_COMMON)
>  OBJECT_DECLARE_TYPE(SevGuestState, SevGuestStateClass, SEV_GUEST)
> +OBJECT_DECLARE_TYPE(SevSnpGuestState, SevSnpGuestStateClass, SEV_SNP_GUEST)
>  
>  struct SevCommonState {
>      X86ConfidentialGuest parent_obj;
> @@ -100,8 +101,26 @@ struct SevGuestStateClass {
>      SevCommonStateClass parent_class;
>  };
>  
> +struct SevSnpGuestState {
> +    SevCommonState parent_obj;
> +
> +    /* configuration parameters */
> +    char *guest_visible_workarounds;
> +    char *id_block;
> +    char *id_auth;
> +    char *host_data;
> +
> +    struct kvm_sev_snp_launch_start kvm_start_conf;
> +    struct kvm_sev_snp_launch_finish kvm_finish_conf;
> +};
> +
> +struct SevSnpGuestStateClass {
> +    SevCommonStateClass parent_class;
> +};
> +
>  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>  #define DEFAULT_SEV_DEVICE      "/dev/sev"
> +#define DEFAULT_SEV_SNP_POLICY  0x30000
>  
>  #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
>  typedef struct __attribute__((__packed__)) SevInfoBlock {
> @@ -1505,11 +1524,249 @@ static const TypeInfo sev_guest_info = {
>      .class_init = sev_guest_class_init,
>  };
>  
> +static void
> +sev_snp_guest_get_policy(Object *obj, Visitor *v, const char *name,
> +                         void *opaque, Error **errp)
> +{
> +    visit_type_uint64(v, name,
> +                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_start_conf.policy,
> +                      errp);
> +}
> +
> +static void
> +sev_snp_guest_set_policy(Object *obj, Visitor *v, const char *name,
> +                         void *opaque, Error **errp)
> +{
> +    visit_type_uint64(v, name,
> +                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_start_conf.policy,
> +                      errp);
> +}
> +
> +static char *
> +sev_snp_guest_get_guest_visible_workarounds(Object *obj, Error **errp)
> +{
> +    return g_strdup(SEV_SNP_GUEST(obj)->guest_visible_workarounds);
> +}
> +
> +static void
> +sev_snp_guest_set_guest_visible_workarounds(Object *obj, const char *value,
> +                                            Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +    struct kvm_sev_snp_launch_start *start = &sev_snp_guest->kvm_start_conf;
> +    g_autofree guchar *blob;
> +    gsize len;
> +
> +    g_free(sev_snp_guest->guest_visible_workarounds);
> +
> +    /* store the base64 str so we don't need to re-encode in getter */
> +    sev_snp_guest->guest_visible_workarounds = g_strdup(value);
> +
> +    blob = qbase64_decode(sev_snp_guest->guest_visible_workarounds,
> +                          -1, &len, errp);
> +    if (!blob) {
> +        return;
> +    }
> +
> +    if (len != sizeof(start->gosvw)) {
> +        error_setg(errp, "parameter length of %lu exceeds max of %lu",
> +                   len, sizeof(start->gosvw));
> +        return;
> +    }
> +
> +    memcpy(start->gosvw, blob, len);
> +}
> +
> +static char *
> +sev_snp_guest_get_id_block(Object *obj, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    return g_strdup(sev_snp_guest->id_block);
> +}
> +
> +static void
> +sev_snp_guest_set_id_block(Object *obj, const char *value, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
> +    gsize len;
> +
> +    g_free(sev_snp_guest->id_block);
> +    g_free((guchar *)finish->id_block_uaddr);
> +
> +    /* store the base64 str so we don't need to re-encode in getter */
> +    sev_snp_guest->id_block = g_strdup(value);
> +
> +    finish->id_block_uaddr =
> +        (uint64_t)qbase64_decode(sev_snp_guest->id_block, -1, &len, errp);
> +
> +    if (!finish->id_block_uaddr) {
> +        return;
> +    }
> +
> +    if (len != KVM_SEV_SNP_ID_BLOCK_SIZE) {
> +        error_setg(errp, "parameter length of %lu not equal to %u",
> +                   len, KVM_SEV_SNP_ID_BLOCK_SIZE);
> +        return;
> +    }
> +
> +    finish->id_block_en = (len) ? 1 : 0;
> +}
> +
> +static char *
> +sev_snp_guest_get_id_auth(Object *obj, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    return g_strdup(sev_snp_guest->id_auth);
> +}
> +
> +static void
> +sev_snp_guest_set_id_auth(Object *obj, const char *value, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
> +    gsize len;
> +
> +    g_free(sev_snp_guest->id_auth);
> +    g_free((guchar *)finish->id_auth_uaddr);
> +
> +    /* store the base64 str so we don't need to re-encode in getter */
> +    sev_snp_guest->id_auth = g_strdup(value);
> +
> +    finish->id_auth_uaddr =
> +        (uint64_t)qbase64_decode(sev_snp_guest->id_auth, -1, &len, errp);
> +
> +    if (!finish->id_auth_uaddr) {
> +        return;
> +    }
> +
> +    if (len > KVM_SEV_SNP_ID_AUTH_SIZE) {
> +        error_setg(errp, "parameter length:ID_AUTH %lu exceeds max of %u",
> +                   len, KVM_SEV_SNP_ID_AUTH_SIZE);
> +        return;
> +    }
> +}
> +
> +static bool
> +sev_snp_guest_get_auth_key_en(Object *obj, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    return !!sev_snp_guest->kvm_finish_conf.auth_key_en;
> +}
> +
> +static void
> +sev_snp_guest_set_auth_key_en(Object *obj, bool value, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    sev_snp_guest->kvm_finish_conf.auth_key_en = value;
> +}
> +
> +static bool
> +sev_snp_guest_get_vcek_disabled(Object *obj, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    return !!sev_snp_guest->kvm_finish_conf.vcek_disabled;
> +}
> +
> +static void
> +sev_snp_guest_set_vcek_disabled(Object *obj, bool value, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    sev_snp_guest->kvm_finish_conf.vcek_disabled = value;
> +}
> +
> +static char *
> +sev_snp_guest_get_host_data(Object *obj, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    return g_strdup(sev_snp_guest->host_data);
> +}
> +
> +static void
> +sev_snp_guest_set_host_data(Object *obj, const char *value, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
> +    g_autofree guchar *blob;
> +    gsize len;
> +
> +    g_free(sev_snp_guest->host_data);
> +
> +    /* store the base64 str so we don't need to re-encode in getter */
> +    sev_snp_guest->host_data = g_strdup(value);
> +
> +    blob = qbase64_decode(sev_snp_guest->host_data, -1, &len, errp);
> +
> +    if (!blob) {
> +        return;
> +    }
> +
> +    if (len != sizeof(finish->host_data)) {
> +        error_setg(errp, "parameter length of %lu not equal to %lu",
> +                   len, sizeof(finish->host_data));
> +        return;
> +    }
> +
> +    memcpy(finish->host_data, blob, len);
> +}
> +
> +static void
> +sev_snp_guest_class_init(ObjectClass *oc, void *data)
> +{
> +    object_class_property_add(oc, "policy", "uint64",
> +                              sev_snp_guest_get_policy,
> +                              sev_snp_guest_set_policy, NULL, NULL);
> +    object_class_property_add_str(oc, "guest-visible-workarounds",
> +                                  sev_snp_guest_get_guest_visible_workarounds,
> +                                  sev_snp_guest_set_guest_visible_workarounds);
> +    object_class_property_add_str(oc, "id-block",
> +                                  sev_snp_guest_get_id_block,
> +                                  sev_snp_guest_set_id_block);
> +    object_class_property_add_str(oc, "id-auth",
> +                                  sev_snp_guest_get_id_auth,
> +                                  sev_snp_guest_set_id_auth);
> +    object_class_property_add_bool(oc, "auth-key-enabled",
> +                                   sev_snp_guest_get_auth_key_en,
> +                                   sev_snp_guest_set_auth_key_en);
> +    object_class_property_add_bool(oc, "vcek-required",
> +                                   sev_snp_guest_get_vcek_disabled,
> +                                   sev_snp_guest_set_vcek_disabled);
> +    object_class_property_add_str(oc, "host-data",
> +                                  sev_snp_guest_get_host_data,
> +                                  sev_snp_guest_set_host_data);
> +}
> +
> +static void
> +sev_snp_guest_instance_init(Object *obj)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    /* default init/start/finish params for kvm */
> +    sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;
> +}
> +
> +/* guest info specific to sev-snp */
> +static const TypeInfo sev_snp_guest_info = {
> +    .parent = TYPE_SEV_COMMON,
> +    .name = TYPE_SEV_SNP_GUEST,
> +    .instance_size = sizeof(SevSnpGuestState),
> +    .class_init = sev_snp_guest_class_init,
> +    .instance_init = sev_snp_guest_instance_init,
> +};
> +
>  static void
>  sev_register_types(void)
>  {
>      type_register_static(&sev_common_info);
>      type_register_static(&sev_guest_info);
> +    type_register_static(&sev_snp_guest_info);
>  }
>  
>  type_init(sev_register_types);
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 668374eef3..bedc667eeb 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -22,6 +22,7 @@
>  
>  #define TYPE_SEV_COMMON "sev-common"
>  #define TYPE_SEV_GUEST "sev-guest"
> +#define TYPE_SEV_SNP_GUEST "sev-snp-guest"
>  
>  #define SEV_POLICY_NODBG        0x1
>  #define SEV_POLICY_NOKS         0x2
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


