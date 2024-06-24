Return-Path: <kvm+bounces-20392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38CDB9149CA
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 14:27:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC17A28488B
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 12:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF2D13B7BC;
	Mon, 24 Jun 2024 12:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFhnipz0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582194776A
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 12:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719232034; cv=none; b=KxgHNoTI28pOceI/YwxpZvW4Lgcc2YeA1kG1nesmtNDRn1OKdUNY65hIE/W7B3zcjU0kv4/CgZ9C3YFR6RO5e8E1Tk4xBa0mh/FAVDmXLplKl6xxCyegl+ryUnXjxglsKECNgBiFqlPGPAo+rWpGkyrOQHtyJYWBqa/mmi5tfbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719232034; c=relaxed/simple;
	bh=sUiqSzz7409Eumfc0OjBFtrSGLxTwrPN1xTUSXIFu7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=goFkmbkAE7SGp4ZuNttNC3O1/poOhR1R8ogE5FaS5d2ZBy9gWPgU073T1JiUqmv+UDDUDT/mmE5DKfORWiChV5caZDKG9sm3FYaPnhZDM9FA00Vw8Pj32G0MvubvXCrJc69J6k+b6zaIz2+sRuvIpF5QaHShAKWzESM3T5AFf5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IFhnipz0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719232031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2TWK+sfwtHYlg1TGDTvMfWnHFSmraa886QsMrQY+oCU=;
	b=IFhnipz0mft5QJiGdlauvImE/FrqwlvQj53N0Y10fNTtpEGPsMlR78lpjk31rm2kaB9eLL
	K5I8yMBnvWoXVp6pPjtCbEfDtCg8n72wAZXdTR7FxpMBsiCRXNWbVI/JkR7D0khCnV50T0
	84rN8dq+evqtWvL7BIM1Swi3aHWEsIA=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-tAxwYD3sNPCaCfrEZOdFug-1; Mon, 24 Jun 2024 08:27:09 -0400
X-MC-Unique: tAxwYD3sNPCaCfrEZOdFug-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52cdbc21fa2so1701691e87.0
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 05:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719232028; x=1719836828;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2TWK+sfwtHYlg1TGDTvMfWnHFSmraa886QsMrQY+oCU=;
        b=cPzaeZ2SB9cnEbajp2XOSWzk65SsOhXhN7awvizkXXRByB9DUeObNGXwSXX9fW1wQu
         1G2tQY10KCEOVHPLDMTgljGC6oUu3nFkD4+clyAVOQ1or+wCYHqA4SWm8Z3EfhYYGKit
         nSjLumch8Hrezq8VCYRuElnvZJ9YXo9rTrOBl5Grxgs7FfQfZYNB0U8Opafrdq0R+Ll1
         lLQ+nv4ucDAIYGRPFxkuEFb1s8x3YoU3Y03DV2HVf0lxzjhyOVgbRYw7OeaqAsoei/RM
         1DvC0W+htZ6dSQdbrym0FF9v3Y3CiKSGj5VjpCZhcXSI8r95xbw6NJOMz/mwyPHogdKO
         tvlA==
X-Forwarded-Encrypted: i=1; AJvYcCWkaOBqyYPnn2I/bLTdI6TkD8VhFuoOdWN0+qTK7z//eBAqlmNKzSgWzohduRC/+iMnKXpyLYVBP61egH4Jejke5sBE
X-Gm-Message-State: AOJu0YyhyouCavhMRsKiIcsKwjzwtdVUe613xkSYDCvlGJLdDk2rS8wo
	2YXEWPWV/8gUy5nqSf+7MamhDyk4mXGhAivk9AoR78TsWj/R9oQPy1K5BLtpEgg3KoguxMqh7xF
	j3ZuI2spGariPPYNLI0iZ17YI1XstRPoIvWagvC3vV4Kp/TSHWA==
X-Received: by 2002:ac2:5ded:0:b0:52c:dac0:59f8 with SMTP id 2adb3069b0e04-52ce185fb12mr2622560e87.53.1719232027863;
        Mon, 24 Jun 2024 05:27:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGypNezLYvbgrPRJVO8xMHU9PQhPBSJ/O+uOgMOiAgMLLFOYLeIE4z87cK0nU4upF/BOyuLkA==
X-Received: by 2002:ac2:5ded:0:b0:52c:dac0:59f8 with SMTP id 2adb3069b0e04-52ce185fb12mr2622542e87.53.1719232027066;
        Mon, 24 Jun 2024 05:27:07 -0700 (PDT)
Received: from redhat.com ([2.52.146.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-366bd575f6asm9284881f8f.6.2024.06.24.05.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 05:27:06 -0700 (PDT)
Date: Mon, 24 Jun 2024 08:27:01 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
	Markus Armbruster <armbru@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] i386: revert defaults to 'legacy-vm-type=true' for
 SEV(-ES) guests
Message-ID: <20240624080458-mutt-send-email-mst@kernel.org>
References: <20240614103924.1420121-1-berrange@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240614103924.1420121-1-berrange@redhat.com>

On Fri, Jun 14, 2024 at 11:39:24AM +0100, Daniel P. Berrangé wrote:
> The KVM_SEV_INIT2 ioctl was only introduced in Linux 6.10, which will
> only have been released for a bit over a month when QEMU 9.1 is
> released.
> 
> The SEV(-ES) support in QEMU has been present since 2.12 dating back
> to 2018. With this in mind, the overwhealming majority of users of
> SEV(-ES) are unlikely to be running Linux >= 6.10, any time in the
> forseeable future.
> 
> IOW, defaulting new QEMU to 'legacy-vm-type=false' means latest QEMU
> machine types will be broken out of the box for most SEV(-ES) users.
> Even if the kernel is new enough, it also affects the guest measurement,
> which means that their existing tools for validating measurements will
> also be broken by the new default.
> 
> This is not a sensible default choice at this point in time. Revert to
> the historical behaviour which is compatible with what most users are
> currently running.
> 
> This can be re-evaluated a few years down the line, though it is more
> likely that all attention will be on SEV-SNP by this time. Distro
> vendors may still choose to change this default downstream to align
> with their new major releases where they can guarantee the kernel
> will always provide the required functionality.
> 
> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>

This makes sense superficially, so

Acked-by: Michael S. Tsirkin <mst@redhat.com>

and I'll let kvm maintainers merge this.

However I wonder, wouldn't it be better to refactor this:

    if (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) == KVM_X86_DEFAULT_VM) {
        cmd = sev_es_enabled() ? KVM_SEV_ES_INIT : KVM_SEV_INIT;
        
        ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
    } else {
        struct kvm_sev_init args = { 0 };
                
        ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
    }   

to something like:

if (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) != KVM_X86_DEFAULT_VM) {
        struct kvm_sev_init args = { 0 };
                
        ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
	if (ret && errno == ENOTTY) {
		cmd = sev_es_enabled() ? KVM_SEV_ES_INIT : KVM_SEV_INIT;

		ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
	}
}


Yes I realize this means measurement will then depend on the host
but it seems nicer than failing guest start, no?




> ---
>  hw/i386/pc.c      |  1 -
>  qapi/qom.json     | 12 ++++++------
>  target/i386/sev.c |  7 +++++++
>  3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 0469af00a7..b65843c559 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -82,7 +82,6 @@
>  GlobalProperty pc_compat_9_0[] = {
>      { TYPE_X86_CPU, "x-l1-cache-per-thread", "false" },
>      { TYPE_X86_CPU, "guest-phys-bits", "0" },
> -    { "sev-guest", "legacy-vm-type", "true" },
>      { TYPE_X86_CPU, "legacy-multi-node", "on" },
>  };
>  const size_t pc_compat_9_0_len = G_N_ELEMENTS(pc_compat_9_0);
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 8bd299265e..714ebeec8b 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -912,12 +912,12 @@
>  # @handle: SEV firmware handle (default: 0)
>  #
>  # @legacy-vm-type: Use legacy KVM_SEV_INIT KVM interface for creating the VM.
> -#                  The newer KVM_SEV_INIT2 interface syncs additional vCPU
> -#                  state when initializing the VMSA structures, which will
> -#                  result in a different guest measurement. Set this to
> -#                  maintain compatibility with older QEMU or kernel versions
> -#                  that rely on legacy KVM_SEV_INIT behavior.
> -#                  (default: false) (since 9.1)
> +#                  The newer KVM_SEV_INIT2 interface, from Linux >= 6.10, syncs
> +#                  additional vCPU state when initializing the VMSA structures,
> +#                  which will result in a different guest measurement. Toggle
> +#                  this to control compatibility with older QEMU or kernel
> +#                  versions that rely on legacy KVM_SEV_INIT behavior.
> +#                  (default: true) (since 9.1)
>  #
>  # Since: 2.12
>  ##
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 004c667ac1..16029282b7 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -2086,6 +2086,13 @@ sev_guest_instance_init(Object *obj)
>      object_property_add_uint32_ptr(obj, "policy", &sev_guest->policy,
>                                     OBJ_PROP_FLAG_READWRITE);
>      object_apply_compat_props(obj);
> +
> +    /*
> +     * KVM_SEV_INIT2 was only introduced in Linux 6.10. Avoid
> +     * breaking existing users of SEV, since the overwhealming
> +     * majority won't have a new enough kernel for a long time
> +     */
> +    sev_guest->legacy_vm_type = true;
>  }
>  
>  /* guest info specific sev/sev-es */
> -- 
> 2.45.1


