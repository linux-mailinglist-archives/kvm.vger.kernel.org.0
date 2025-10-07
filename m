Return-Path: <kvm+bounces-59558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9252CBC04E4
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 08:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5D1EC4E6CD8
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 06:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794BF221F1F;
	Tue,  7 Oct 2025 06:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HkbUD51o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8E61BC41
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 06:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759817688; cv=none; b=UxWevu6dMSnUKi0BgPB99bRU1FwWTL4wCZcssKsaQTqZIiL1rU1qiTZo6GUYacdLPQCWG9nvRP13sSCBtYuIaCjS2N5s9N6eUOL3ZsvVi5LjuTmPWhSUFDOUETKklEkXF5X//uWdlHciDiH66ZiGZu0TcoGgRUcSLrVVW5/yDug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759817688; c=relaxed/simple;
	bh=Geoz62Db/b3z7tcwIjjtlIL7qWBjbqCzogIlFuOhU7Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JMB4EKoUmDVTK+odgQvGyh7VstxX+Y40sG1xcxCfMcp/ZnczIWM/Wj+wZHo+sNFSjuH6ltbkS6RLkyVIo0uEZrnwqbzBBgEYeE9AHAd9RqIZFolIrZ0dYP628do+30djnHEtl4R+Lyrt7IuJNqExB38KzQxl32GegZQAgRibmSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HkbUD51o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759817685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6FXLO8IcYv0QG3L3A7h3vV2r8GS/Tp1CJIGCxvQld4=;
	b=HkbUD51o1ybJiCn6JezHMN/b4MJaHkWKT3ByUg5DOw+FDE+ATAqUFLwgSMn8T+21OFnqIU
	k0LAmvBVnu3lObnzLuUY7+7WTnjMD2eoOYXliv7Gf/9oxyO+14HqUhQy1EuQytnsuoR4vj
	iK3dy7kymBQz9rspZaXQwbdr35ms3WU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-245-Ed_t1rkdNQebrNeKulYJSg-1; Tue,
 07 Oct 2025 02:14:42 -0400
X-MC-Unique: Ed_t1rkdNQebrNeKulYJSg-1
X-Mimecast-MFC-AGG-ID: Ed_t1rkdNQebrNeKulYJSg_1759817680
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EF2B180028C;
	Tue,  7 Oct 2025 06:14:40 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.6])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0CD930002CC;
	Tue,  7 Oct 2025 06:14:39 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 263DF21E6A27; Tue, 07 Oct 2025 08:14:37 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Eric Blake <eblake@redhat.com>,
  Marcelo Tosatti <mtosatti@redhat.com>,  qemu-devel
 <qemu-devel@nongnu.org>,  <kvm@vger.kernel.org>,  Tom Lendacky
 <thomas.lendacky@amd.com>,  Nikunj A Dadhania <nikunj@amd.com>,  "Daniel
 P. Berrange" <berrange@redhat.com>,  Eduardo Habkost
 <eduardo@habkost.net>,  Zhao Liu <zhao1.liu@intel.com>,  Michael Roth
 <michael.roth@amd.com>,  Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: Re: [PATCH v2 6/9] target/i386: SEV: Add support for enabling
 debug-swap SEV feature
In-Reply-To: <4f0f28154342d562e76107dfd60ed3a02665fbfe.1758794556.git.naveen@kernel.org>
	(Naveen N. Rao's message of "Thu, 25 Sep 2025 15:47:35 +0530")
References: <cover.1758794556.git.naveen@kernel.org>
	<4f0f28154342d562e76107dfd60ed3a02665fbfe.1758794556.git.naveen@kernel.org>
Date: Tue, 07 Oct 2025 08:14:37 +0200
Message-ID: <871pnfjl0y.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

"Naveen N Rao (AMD)" <naveen@kernel.org> writes:

> Add support for enabling debug-swap VMSA SEV feature in SEV-ES and
> SEV-SNP guests through a new "debug-swap" boolean property on SEV guest
> objects. Though the boolean property is available for plain SEV guests,
> check_sev_features() will reject setting this for plain SEV guests.

Is this the sev_features && !sev_es_enabled() check there?

Does "reject setting this" mean setting it to true is rejected, or does
it mean setting it to any value is rejected?

> Though this SEV feature is called "Debug virtualization" in the APM, KVM
> calls this "debug swap" so use the same name for consistency.
>
> Sample command-line:
>   -machine q35,confidential-guest-support=sev0 \
>   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,debug-swap=on

Always appreciated in commit messages.

I get "cannot set up private guest memory for sev-snp-guest: KVM
required".  If I add the obvious "-accel kvm", I get "-accel kvm:
vm-type SEV-SNP not supported by KVM".  I figure that's because my
hardware isn't capable.  The error message could be clearer.  Not this
patch's fault.

> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  target/i386/sev.h |  1 +
>  target/i386/sev.c | 20 ++++++++++++++++++++
>  qapi/qom.json     |  6 +++++-
>  3 files changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 102546b112d6..8e09b2ce1976 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -45,6 +45,7 @@ bool sev_snp_enabled(void);
>  #define SEV_SNP_POLICY_DBG      0x80000
>  
>  #define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
> +#define SVM_SEV_FEAT_DEBUG_SWAP     BIT(5)
>  
>  typedef struct SevKernelLoaderContext {
>      char *setup_data;
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 88dd0750d481..e9d84ea25571 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -319,6 +319,11 @@ sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
>      sev_common->state = new_state;
>  }
>  
> +static bool is_sev_feature_set(SevCommonState *sev_common, uint64_t feature)
> +{
> +    return !!(sev_common->sev_features & feature);
> +}
> +
>  static void sev_set_feature(SevCommonState *sev_common, uint64_t feature, bool set)
>  {
>      if (set) {
> @@ -2744,6 +2749,16 @@ static int cgs_set_guest_policy(ConfidentialGuestPolicyType policy_type,
>      return 0;
>  }
>  
> +static bool sev_common_get_debug_swap(Object *obj, Error **errp)
> +{
> +    return is_sev_feature_set(SEV_COMMON(obj), SVM_SEV_FEAT_DEBUG_SWAP);
> +}
> +
> +static void sev_common_set_debug_swap(Object *obj, bool value, Error **errp)
> +{
> +    sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_DEBUG_SWAP, value);
> +}
> +
>  static void
>  sev_common_class_init(ObjectClass *oc, const void *data)
>  {
> @@ -2761,6 +2776,11 @@ sev_common_class_init(ObjectClass *oc, const void *data)
>                                     sev_common_set_kernel_hashes);
>      object_class_property_set_description(oc, "kernel-hashes",
>              "add kernel hashes to guest firmware for measured Linux boot");
> +    object_class_property_add_bool(oc, "debug-swap",
> +                                   sev_common_get_debug_swap,
> +                                   sev_common_set_debug_swap);
> +    object_class_property_set_description(oc, "debug-swap",
> +            "enable virtualization of debug registers");
>  }
>  
>  static void
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 830cb2ffe781..df962d4a5215 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1010,13 +1010,17 @@
>  #     designated guest firmware page for measured boot with -kernel
>  #     (default: false) (since 6.2)
>  #
> +# @debug-swap: enable virtualization of debug registers
> +#     (default: false) (since 10.2)
> +#

According to the commit message, setting @default-swap works only for
SEV-ES and SEV-SNP guests, i.e. it fails for plain SEV guests.  Should
we document this here?

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


