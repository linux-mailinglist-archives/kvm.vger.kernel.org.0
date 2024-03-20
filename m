Return-Path: <kvm+bounces-12288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15E6C881168
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 773B11F217BC
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 11:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AB93F8D6;
	Wed, 20 Mar 2024 11:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jJbB+CD0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985883D0A3
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 11:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710935955; cv=none; b=BGfXlcGEhvnulvm4zSw4BXBEuQh60Reuw1zNvmI4Wo8IcAvqrwoxuvf9fNb5cOIPSeHqjTYwEIv+rWYrpkLd4E4ty4RTYfsAL/IKgPJes3mRs93A/aptKaokqKUBoSDohFMZHGojOmOnKffvzxFl0OpN5wxJ+vXY6hRH1ewrYGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710935955; c=relaxed/simple;
	bh=F87Vx3vO9wY/8Aak6V5VEpXvBmZQKO1R/mbGFfnArYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rAjjEd/ClWqGzbbbMB8vrs++SbtlY8h/Ugn/IMLsjgrMbXi6iVwl1fnX6fOtmtYeQmsDCfmF0YXcA+zk0TqIZUKqXSb9MhCrz7pjJWi8QQR3ewhUeJ6K5HMQxzVsoIZlupfB0xn24eaeEduTeMGIO4x9iEwN1K/f2gqeg3RQrh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jJbB+CD0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710935950;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=5Jc2jD1UR3Os5XzgHanwqV8FW15jWqTpocLCNx0whFY=;
	b=jJbB+CD0YtGdSBnzPGVRwKB6Q7D7Gc/mJjW81aucR2NtOUXOvY//sccXrJHUGVW+BJHHz5
	rA6WPSABExiEWTfU2VWbsQD+JZNEv0mijmtP808giCIvaYN0I/x0jAgF+DR8PZnEROORVZ
	Kh9qiA9vr2DoCPBoDKso/kjkE4aqduQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-HQGCw31zNO29W9-a76bh5Q-1; Wed,
 20 Mar 2024 07:59:06 -0400
X-MC-Unique: HQGCw31zNO29W9-a76bh5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DE662802269;
	Wed, 20 Mar 2024 11:59:05 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.205])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77A5D10E47;
	Wed, 20 Mar 2024 11:59:03 +0000 (UTC)
Date: Wed, 20 Mar 2024 11:58:57 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v3 22/49] i386/sev: Introduce 'sev-snp-guest' object
Message-ID: <ZfrPgeF4nDCa3lPm@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-23-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-23-michael.roth@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Wed, Mar 20, 2024 at 03:39:18AM -0500, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> SEV-SNP support relies on a different set of properties/state than the
> existing 'sev-guest' object. This patch introduces the 'sev-snp-guest'
> object, which can be used to configure an SEV-SNP guest. For example,
> a default-configured SEV-SNP guest with no additional information
> passed in for use with attestation:
> 
>   -object sev-snp-guest,id=sev0
> 
> or a fully-specified SEV-SNP guest where all spec-defined binary
> blobs are passed in as base64-encoded strings:
> 
>   -object sev-snp-guest,id=sev0, \
>     policy=0x30000, \
>     init-flags=0, \
>     id-block=YWFhYWFhYWFhYWFhYWFhCg==, \
>     id-auth=CxHK/OKLkXGn/KpAC7Wl1FSiisWDbGTEKz..., \
>     auth-key-enabled=on, \
>     host-data=LNkCWBRC5CcdGXirbNUV1OrsR28s..., \
>     guest-visible-workarounds=AA==, \
> 
> See the QAPI schema updates included in this patch for more usage
> details.
> 
> In some cases these blobs may be up to 4096 characters, but this is
> generally well below the default limit for linux hosts where
> command-line sizes are defined by the sysconf-configurable ARG_MAX
> value, which defaults to 2097152 characters for Ubuntu hosts, for
> example.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Acked-by: Markus Armbruster <armbru@redhat.com> (for QAPI schema)
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  docs/system/i386/amd-memory-encryption.rst |  78 ++++++-
>  qapi/qom.json                              |  51 +++++
>  target/i386/sev.c                          | 241 +++++++++++++++++++++
>  target/i386/sev.h                          |   1 +
>  4 files changed, 369 insertions(+), 2 deletions(-)
> 

> +##
> +# @SevSnpGuestProperties:
> +#
> +# Properties for sev-snp-guest objects. Most of these are direct arguments
> +# for the KVM_SNP_* interfaces documented in the linux kernel source
> +# under Documentation/virt/kvm/amd-memory-encryption.rst, which are in
> +# turn closely coupled with the SNP_INIT/SNP_LAUNCH_* firmware commands
> +# documented in the SEV-SNP Firmware ABI Specification (Rev 0.9).
> +#
> +# More usage information is also available in the QEMU source tree under
> +# docs/amd-memory-encryption.
> +#
> +# @policy: the 'POLICY' parameter to the SNP_LAUNCH_START command, as
> +#          defined in the SEV-SNP firmware ABI (default: 0x30000)
> +#
> +# @guest-visible-workarounds: 16-byte, base64-encoded blob to report
> +#                             hypervisor-defined workarounds, corresponding
> +#                             to the 'GOSVW' parameter of the
> +#                             SNP_LAUNCH_START command defined in the
> +#                             SEV-SNP firmware ABI (default: all-zero)
> +#
> +# @id-block: 96-byte, base64-encoded blob to provide the 'ID Block'
> +#            structure for the SNP_LAUNCH_FINISH command defined in the
> +#            SEV-SNP firmware ABI (default: all-zero)
> +#
> +# @id-auth: 4096-byte, base64-encoded blob to provide the 'ID Authentication
> +#           Information Structure' for the SNP_LAUNCH_FINISH command defined
> +#           in the SEV-SNP firmware ABI (default: all-zero)
> +#
> +# @auth-key-enabled: true if 'id-auth' blob contains the 'AUTHOR_KEY' field
> +#                    defined SEV-SNP firmware ABI (default: false)
> +#
> +# @host-data: 32-byte, base64-encoded, user-defined blob to provide to the
> +#             guest, as documented for the 'HOST_DATA' parameter of the
> +#             SNP_LAUNCH_FINISH command in the SEV-SNP firmware ABI
> +#             (default: all-zero)
> +#
> +# Since: 7.2

This will be 9.1 at the earliest now.

> +##
> +{ 'struct': 'SevSnpGuestProperties',
> +  'base': 'SevCommonProperties',
> +  'data': {
> +            '*policy': 'uint64',
> +            '*guest-visible-workarounds': 'str',
> +            '*id-block': 'str',
> +            '*id-auth': 'str',
> +            '*auth-key-enabled': 'bool',
> +            '*host-data': 'str' } }
> +

> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 63a220de5e..7e6dab642a 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -42,6 +42,7 @@
>  
>  OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
>  OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
> +OBJECT_DECLARE_SIMPLE_TYPE(SevSnpGuestState, SEV_SNP_GUEST)
>  
>  struct SevCommonState {
>      X86ConfidentialGuest parent_obj;
> @@ -87,8 +88,22 @@ struct SevGuestState {
>      bool kernel_hashes;
>  };
>  
> +struct SevSnpGuestState {
> +    SevCommonState sev_common;
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
>  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>  #define DEFAULT_SEV_DEVICE      "/dev/sev"
> +#define DEFAULT_SEV_SNP_POLICY  0x30000
>  
>  #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
>  typedef struct __attribute__((__packed__)) SevInfoBlock {
> @@ -1473,11 +1488,237 @@ static const TypeInfo sev_guest_info = {
>      .class_init = sev_guest_class_init,

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
> +    if (sev_snp_guest->guest_visible_workarounds) {
> +        g_free(sev_snp_guest->guest_visible_workarounds);
> +    }

Redundant 'if' test - g_free is happy with NULL

> +
> +    /* store the base64 str so we don't need to re-encode in getter */
> +    sev_snp_guest->guest_visible_workarounds = g_strdup(value);
> +
> +    blob = qbase64_decode(sev_snp_guest->guest_visible_workarounds, -1, &len, errp);
> +    if (!blob) {
> +        return;
> +    }
> +
> +    if (len > sizeof(start->gosvw)) {

The QAPI docs said this property must be '16 bytes', so I'd
suggest we do a strict equality test, rather than min size
test to catch a wider set of mistakes.

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
> +    if (sev_snp_guest->id_block) {
> +        g_free(sev_snp_guest->id_block);
> +        g_free((guchar *)finish->id_block_uaddr);
> +    }

Assuming 'id_block_uaddr' is also initialized to 0, when id_block
is NULL, then you can remove the 'if' conditional.

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
> +    if (len > KVM_SEV_SNP_ID_BLOCK_SIZE) {

Again, lets do a strict equality test to match the documented
required size.

> +        error_setg(errp, "parameter length of %lu exceeds max of %u",
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
> +    if (sev_snp_guest->id_auth) {
> +        g_free(sev_snp_guest->id_auth);
> +        g_free((guchar *)finish->id_auth_uaddr);
> +    }

Same probably redundant 'if'

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

Equality test.

> +        error_setg(errp, "parameter length of %lu exceeds max of %u",
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
> +    if (sev_snp_guest->host_data) {
> +        g_free(sev_snp_guest->host_data);
> +    }

Redundant 'if'

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
> +    if (len > sizeof(finish->host_data)) {

Equality test

> +        error_setg(errp, "parameter length of %lu exceeds max of %lu",
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

Use the OBJECT_DEFINE_TYPE_WITH_INTERFACES macro here.

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
> 2.25.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


