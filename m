Return-Path: <kvm+bounces-37687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 304C5A2E79C
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 10:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3925B1888999
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 09:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339841C07D6;
	Mon, 10 Feb 2025 09:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dYwl569r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1DA1A8F9E
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 09:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739179494; cv=none; b=QuPdsT89FBhjV57pJ9U/1ZgfrZgywTl7EvPlR4BS+Vv91tCCCrL/gp46+tTnW3VARIqxF1Z5xWEZ4TNpVyglLKsy/IgOvemo1e3fbHP+unqoaToo2ij0p1yPp6gsfG7NyDv9rmIXiB4BPCm8c6lwpJs/+1KCH+jxAy8oIRpk/Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739179494; c=relaxed/simple;
	bh=z+kXMgYe/ajtp3LLneaAl9n6r24GtiOZW7fQnR7aHA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAHtLG2j7Nh0qOcRzcwb8q78CvwC5ZzJEN04QciTVAiZ5XLNcylZknmKoa4f2+qMciCduSDvfiVKtUW58FASuY+18DUK0y7pxE271xwjqDU7PcBYHY2EArDML0wdCe6TzQ+ruV4erwe9IuH5PfzkUXlNeqLRqUXmoAnL1DIwFEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dYwl569r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739179491;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=CQxZL5xoLK6Tb2nweuMpnv3OC+qEnohkK5KbgeI3dqg=;
	b=dYwl569rchwVhunDIYyuF19HlZqkCDgy8EhrkXUgjFpoxJ1E7JBnzzi2XukzSumJK/90lE
	mWodZk8+j70qWXxxni9gRhPCV6wqZ+lxbqiwKXOZXCFlHHJf9pNW/d8TwfYA98nCzcItTI
	o0DVg+lVdAKzNAECHJSHn+Eaqny/udU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-Sy4BxvDkM3C9g5qeK7ULqA-1; Mon,
 10 Feb 2025 04:24:44 -0500
X-MC-Unique: Sy4BxvDkM3C9g5qeK7ULqA-1
X-Mimecast-MFC-AGG-ID: Sy4BxvDkM3C9g5qeK7ULqA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 977FB195608B;
	Mon, 10 Feb 2025 09:24:41 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.104])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E1931800115;
	Mon, 10 Feb 2025 09:24:35 +0000 (UTC)
Date: Mon, 10 Feb 2025 09:24:31 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Kim Phillips <kim.phillips@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	"Nikunj A . Dadhania" <nikunj@amd.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] target/i386: sev: Add cmdline option to enable the Allowed
 SEV Features feature
Message-ID: <Z6nFzwwOZDx4p6yq@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250207233327.130770-1-kim.phillips@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250207233327.130770-1-kim.phillips@amd.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Fri, Feb 07, 2025 at 05:33:27PM -0600, Kim Phillips wrote:
> The Allowed SEV Features feature allows the host kernel to control
> which SEV features it does not want the guest to enable [1].
> 
> This has to be explicitly opted-in by the user because it has the
> ability to break existing VMs if it were set automatically.
> 
> Currently, both the PmcVirtualization and SecureAvic features
> require the Allowed SEV Features feature to be set.
> 
> Based on a similar patch written for Secure TSC [2].
> 
> [1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
>     Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
>     https://bugzilla.kernel.org/attachment.cgi?id=306250
> 
> [2] https://github.com/qemu/qemu/commit/4b2288dc6025ba32519ee8d202ca72d565cbbab7

Despite that URL, that commit also does not appear to be merged into
the QEMU git repo, and indeed I can't find any record of it even being
posted as a patch for review on qemu-devel.

This is horribly misleading to reviewers, suggesting that the referenced
patch was already accepted :-(

> 
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>  qapi/qom.json     |  6 ++++-
>  target/i386/sev.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++
>  target/i386/sev.h |  2 ++
>  3 files changed, 67 insertions(+), 1 deletion(-)
> 
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 28ce24cd8d..113b44ad74 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -948,13 +948,17 @@
>  #     designated guest firmware page for measured boot with -kernel
>  #     (default: false) (since 6.2)
>  #
> +# @allowed-sev-features: true if secure allowed-sev-features feature
> +#     is to be enabled in an SEV-ES or SNP guest. (default: false)

Missing 'since' annotation.

> +#
>  # Since: 9.1
>  ##
>  { 'struct': 'SevCommonProperties',
>    'data': { '*sev-device': 'str',
>              '*cbitpos': 'uint32',
>              'reduced-phys-bits': 'uint32',
> -            '*kernel-hashes': 'bool' } }
> +            '*kernel-hashes': 'bool',
> +            '*allowed-sev-features': 'bool' } }
>  
>  ##
>  # @SevGuestProperties:
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 0e1dbb6959..85ad73f9a0 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -98,6 +98,7 @@ struct SevCommonState {
>      uint32_t cbitpos;
>      uint32_t reduced_phys_bits;
>      bool kernel_hashes;
> +    uint64_t vmsa_features;
>  
>      /* runtime state */
>      uint8_t api_major;
> @@ -411,6 +412,33 @@ sev_get_reduced_phys_bits(void)
>      return sev_common ? sev_common->reduced_phys_bits : 0;
>  }
>  
> +static __u64
> +sev_supported_vmsa_features(void)
> +{
> +    uint64_t supported_vmsa_features = 0;
> +    struct kvm_device_attr attr = {
> +        .group = KVM_X86_GRP_SEV,
> +        .attr = KVM_X86_SEV_VMSA_FEATURES,
> +        .addr = (unsigned long) &supported_vmsa_features
> +    };
> +
> +    bool sys_attr = kvm_check_extension(kvm_state, KVM_CAP_SYS_ATTRIBUTES);
> +    if (!sys_attr) {
> +        return 0;
> +    }
> +
> +    int rc = kvm_ioctl(kvm_state, KVM_GET_DEVICE_ATTR, &attr);
> +    if (rc < 0) {
> +        if (rc != -ENXIO) {
> +            warn_report("KVM_GET_DEVICE_ATTR(0, KVM_X86_SEV_VMSA_FEATURES) "
> +                        "error: %d", rc);
> +        }
> +        return 0;
> +    }
> +
> +    return supported_vmsa_features;
> +}
> +
>  static SevInfo *sev_get_info(void)
>  {
>      SevInfo *info;
> @@ -1524,6 +1552,20 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      case KVM_X86_SNP_VM: {
>          struct kvm_sev_init args = { 0 };
>  
> +        if (sev_es_enabled()) {
> +            __u64 vmsa_features, supported_vmsa_features;
> +
> +            supported_vmsa_features = sev_supported_vmsa_features();
> +            vmsa_features = sev_common->vmsa_features;
> +            if ((vmsa_features & supported_vmsa_features) != vmsa_features) {
> +                error_setg(errp, "%s: requested sev feature mask (0x%llx) "
> +                           "contains bits not supported by the host kernel "
> +                           " (0x%llx)", __func__, vmsa_features,
> +                           supported_vmsa_features);

This logic is being applied unconditionally, and not connected to
the setting of the new 'allowed-sev-features' flag value. Is that
correct  ? 

Will this end up breaking existing deployed guests, or is this a
scenario that would have been blocked with an error later on
regardless ?

> +            return -1;

Malformed indentation.

> +            }
> +            args.vmsa_features = vmsa_features;
> +        }
>          ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
>          break;
>      }
> @@ -2044,6 +2086,19 @@ static void sev_common_set_kernel_hashes(Object *obj, bool value, Error **errp)
>      SEV_COMMON(obj)->kernel_hashes = value;
>  }
>  
> +static bool
> +sev_snp_guest_get_allowed_sev_features(Object *obj, Error **errp)
> +{
> +    return SEV_COMMON(obj)->vmsa_features & SEV_VMSA_ALLOWED_SEV_FEATURES;
> +}
> +
> +static void
> +sev_snp_guest_set_allowed_sev_features(Object *obj, bool value, Error **errp)
> +{
> +    if (value)
> +        SEV_COMMON(obj)->vmsa_features |= SEV_VMSA_ALLOWED_SEV_FEATURES;
> +}
> +
>  static void
>  sev_common_class_init(ObjectClass *oc, void *data)
>  {
> @@ -2061,6 +2116,11 @@ sev_common_class_init(ObjectClass *oc, void *data)
>                                     sev_common_set_kernel_hashes);
>      object_class_property_set_description(oc, "kernel-hashes",
>              "add kernel hashes to guest firmware for measured Linux boot");
> +    object_class_property_add_bool(oc, "allowed-sev-features",
> +                                   sev_snp_guest_get_allowed_sev_features,
> +                                   sev_snp_guest_set_allowed_sev_features);
> +    object_class_property_set_description(oc, "allowed-sev-features",
> +            "Enable the Allowed SEV Features feature");
>  }
>  
>  static void
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 373669eaac..07447c4b01 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -44,6 +44,8 @@ bool sev_snp_enabled(void);
>  #define SEV_SNP_POLICY_SMT      0x10000
>  #define SEV_SNP_POLICY_DBG      0x80000
>  
> +#define SEV_VMSA_ALLOWED_SEV_FEATURES BIT_ULL(63)
> +
>  typedef struct SevKernelLoaderContext {
>      char *setup_data;
>      size_t setup_size;
> -- 
> 2.43.0
> 
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


