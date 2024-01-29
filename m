Return-Path: <kvm+bounces-7382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C00841198
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 19:04:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12B921C247AD
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 18:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B84D53F9DC;
	Mon, 29 Jan 2024 18:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JiJBJ0/M"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5D86F064
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 18:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706551377; cv=none; b=qEeipTQbEMedtaPTrbQvjZsfsSFwlXHLly9vZ3hBGTdIDa0pleYc3iHCIaUlrj/otj5fTxRiJ8vIZL3uvLIs2UB1114TM9TGwh4dpLCQtx8eS7r+6FDJHeFvE057hd2H5ODl62LlKEH0ikihhoDViifmYaVPvIrgtD0Qu+8RBy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706551377; c=relaxed/simple;
	bh=oKhSE20ex3KHRHFaxxZywnjaKDVmLuojuWdHzncXgbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JtOXjKRJvHgFZFkTIyfNoMKFwF5JqhZOVvWe06F7lKsNPzqR1DOdXSE1cqI4IDXicujlVkXYv3OH7Bk1ApClfdNQGwDJb1Xh8TD/TfzwiHRgfp1NiHHFvduSpxa3aFYTmCyGmv9y9bPfntWduvOS1SBgcfVzc00SVcFZqTQvvKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JiJBJ0/M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706551373;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZIboMbZfeLZxnIqiS6J7g/YeatRtTZMZb3yHjyeSTS0=;
	b=JiJBJ0/Mclk6Ed1GmRCxVvPzMucyXSjot8gjpxPL9FxdRq4pvwUFuzYfDtKDyrQToLlS3p
	pB+Uba9HZfEi0c0OVUNiquiX/xBse2CsxIpeia6akuHQZsRlg2MP+JAdjLkumlyOMk3Law
	JVIygh6TF6tZvjifPq7OyJBE6ZdcuM0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-q8YqGlfrMYm-Ns4quOBMug-1; Mon, 29 Jan 2024 13:02:50 -0500
X-MC-Unique: q8YqGlfrMYm-Ns4quOBMug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DEB184AEA4;
	Mon, 29 Jan 2024 18:02:49 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA3EB8B;
	Mon, 29 Jan 2024 18:02:45 +0000 (UTC)
Date: Mon, 29 Jan 2024 18:02:42 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v4 13/66] target/i386: Introduce
 kvm_confidential_guest_init()
Message-ID: <ZbfoQsEuv6_zwl3b@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-14-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240125032328.2522472-14-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Wed, Jan 24, 2024 at 10:22:35PM -0500, Xiaoyao Li wrote:
> Introduce a separate function kvm_confidential_guest_init(), which
> dispatches specific confidential guest initialization function by
> ms->cgs type.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  target/i386/kvm/kvm.c | 11 ++++++++++-
>  target/i386/sev.c     |  1 -
>  target/i386/sev.h     |  2 ++
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index c961846777cc..f9a774925cf6 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2541,6 +2541,15 @@ int kvm_arch_get_default_type(MachineState *ms)
>      return 0;
>  }
>  
> +static int kvm_confidential_guest_init(MachineState *ms, Error **errp)
> +{
> +    if (object_dynamic_cast(OBJECT(ms->cgs), TYPE_SEV_GUEST)) {
> +        return sev_kvm_init(ms->cgs, errp);
> +    }
> +
> +    return 0;
> +}

if/else ladders checking object subclass type and then invoking a
subclass specific method are quite an object oriented code
anti-pattern. I think this suggests that ConfidentialGuestSupportClass
should gain a member

   void (*kvm_init)(ConfidentialGuestSpport *cgs, Error **errp);

and then an impl

   void confidential_guest_kvm_init(ConfidentialGuestSupport *cgs, Error *errp) {
       ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(cgs);
       klass->kvm_init(cgs, errp)
   }

that way, kvm.c arch code doesn't get directly bound to the APIs
for the different CVM technologies, the ConfidentialGuestSupport
object will act as a proper isolation layer. 

This is likely to apply in other parts of KVM code that need to
call into SEV/TDX specific functions too.

> +
>  int kvm_arch_init(MachineState *ms, KVMState *s)
>  {
>      uint64_t identity_base = 0xfffbc000;
> @@ -2561,7 +2570,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>       * mechanisms are supported in future (e.g. TDX), they'll need
>       * their own initialization either here or elsewhere.
>       */
> -    ret = sev_kvm_init(ms->cgs, &local_err);
> +    ret = kvm_confidential_guest_init(ms, &local_err);
>      if (ret < 0) {
>          error_report_err(local_err);
>          return ret;
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 173de91afe7d..27d58702d6dc 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -39,7 +39,6 @@
>  #include "hw/i386/pc.h"
>  #include "exec/address-spaces.h"
>  
> -#define TYPE_SEV_GUEST "sev-guest"
>  OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
>  
>  
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index e7499c95b1e8..1fe25d096dc4 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -20,6 +20,8 @@
>  
>  #include "exec/confidential-guest-support.h"
>  
> +#define TYPE_SEV_GUEST "sev-guest"
> +
>  #define SEV_POLICY_NODBG        0x1
>  #define SEV_POLICY_NOKS         0x2
>  #define SEV_POLICY_ES           0x4
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


