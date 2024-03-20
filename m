Return-Path: <kvm+bounces-12279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D982C880F29
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 10:58:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF44EB221DB
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3171C3BBE8;
	Wed, 20 Mar 2024 09:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjZs+BIi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CA938DE9
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 09:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710928718; cv=none; b=Ly0iOwUnEEWiT0s5csWVBZSjuZqigCZWXLSJw64B7z06AyKVv+PvKRlvlfguGDgKKT1u6A2orLHosR/fcdrscNKY4vpjRE2ZNsNuCHyqTf7D0xM87Fbg5P+hRqNnT5k+sKIfWAKZyRy6bqjyyq20qwkL5O7bVB3rScqf6Zd+O9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710928718; c=relaxed/simple;
	bh=bGgBjbSAltRu0sduT0VqpIM5fdeGW4hDeYxTzP7OoB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=laxaWNg+AosRq/y+/9gk+xzsnn5dEYrUidsn+8cN3ybBkQuKz8vFhh4ucuNW1Llgi+6VRUwqQOXASNlZd1ylVwLIK2YkB04HcKqqvD3p3Cx4C1hAvUQwQ6YhXDv6KktsfxVrIZRNbu6vUP5qQTChi3mrye77pcCS+g0jt01W8qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WjZs+BIi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710928715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=olzv6suonsfJIJXUtUo+TXh4fMZEnDFK6l1vA9ZtLSg=;
	b=WjZs+BIiZIIh25DkvwnIaSsFeb8VYSU1agpx9k5ba52iNpIP4FdCpXTNuV3KLlW80jgZFR
	LRgVfnaFeUvPe2GHpclaW7i0eoRoDWhM4RVXjZ8rM2PjY8hB+StSXM0C+atpqp87qxrG2a
	5VNluzzGNUMonf+lyKWB3vP+YXjoqew=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-NCqMpn88NfyphE4nNUqtYA-1; Wed, 20 Mar 2024 05:58:33 -0400
X-MC-Unique: NCqMpn88NfyphE4nNUqtYA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a46f5f2896dso27542166b.3
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 02:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710928712; x=1711533512;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=olzv6suonsfJIJXUtUo+TXh4fMZEnDFK6l1vA9ZtLSg=;
        b=mb6F325UGh6gkxiTeuKEWgrC4+6V4HAe7Nu8G/XlwcIJgGD+UfqjH8sRT5n0cwTSzu
         dl/x2SKjXSN4h3mx2r3orO5eyMFbbfMDxFM8FNQlf0n7ckUswKsBGmwx4grH0yQqdyoh
         YOvXjZ6V35q/e0LV8i8z58SIYbwNYl/PpBX0iUymZ9eAuXDouEUO4kHF08Ycuobqn8tu
         GRK++/LFeCqflV3GMRfSoQEp8s6alZkWjb4c9vFgdJNcgZMdEaX7Bw712iOcEzTu3KLP
         m35PPwNLxuaFhyj+wCM4FTeY+WQab3YKY+gfdqEUnxliC+y5ExfI3+nJQjofPhUlbHWl
         uE5Q==
X-Gm-Message-State: AOJu0Yx4lPp4eUWnuEvvAPsFUhTzDzNxYOKSOQ5uJ+FmnQDUxbTbNF2b
	6NDp2FmRjp+HyyhWuNPo21Te9dQCu7PCbSQNafFf+WleNaGchw1G59VnCeCSxJb8HYbNCkhuzqo
	lb/D7xrq3uDvugSdM9v8fiAmtX+VMxXsYAKbhaoyoNZpxo/pKNg==
X-Received: by 2002:a17:907:2d21:b0:a43:bf25:989 with SMTP id gs33-20020a1709072d2100b00a43bf250989mr16319691ejc.9.1710928712297;
        Wed, 20 Mar 2024 02:58:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTU/30fz8Oef1veksYmdHpfQ94fe1ioJBB+0DYY6hl0EdRS1Wuv3rb5HRubkg5yWc8V8V/Rw==
X-Received: by 2002:a17:907:2d21:b0:a43:bf25:989 with SMTP id gs33-20020a1709072d2100b00a43bf250989mr16319671ejc.9.1710928711925;
        Wed, 20 Mar 2024 02:58:31 -0700 (PDT)
Received: from [192.168.10.118] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id gq5-20020a170906e24500b00a46be5c78f4sm3425428ejb.142.2024.03.20.02.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 02:58:31 -0700 (PDT)
Message-ID: <366370f2-3d2d-4d14-81db-11fddadc2f24@redhat.com>
Date: Wed, 20 Mar 2024 10:58:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 37/49] i386/sev: Add the SNP launch start context
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-38-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240320083945.991426-38-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 09:39, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The SNP_LAUNCH_START is called first to create a cryptographic launch
> context within the firmware.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   target/i386/sev.c        | 42 +++++++++++++++++++++++++++++++++++++++-
>   target/i386/trace-events |  1 +
>   2 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 3b4dbc63b1..9f63a41f08 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -39,6 +39,7 @@
>   #include "confidential-guest.h"
>   #include "hw/i386/pc.h"
>   #include "exec/address-spaces.h"
> +#include "qemu/queue.h"
>   
>   OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
>   OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
> @@ -106,6 +107,16 @@ struct SevSnpGuestState {
>   #define DEFAULT_SEV_DEVICE      "/dev/sev"
>   #define DEFAULT_SEV_SNP_POLICY  0x30000
>   
> +typedef struct SevLaunchUpdateData {
> +    QTAILQ_ENTRY(SevLaunchUpdateData) next;
> +    hwaddr gpa;
> +    void *hva;
> +    uint64_t len;
> +    int type;
> +} SevLaunchUpdateData;
> +
> +static QTAILQ_HEAD(, SevLaunchUpdateData) launch_update;
> +
>   #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
>   typedef struct __attribute__((__packed__)) SevInfoBlock {
>       /* SEV-ES Reset Vector Address */
> @@ -668,6 +679,30 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
>       return 0;
>   }
>   
> +static int
> +sev_snp_launch_start(SevSnpGuestState *sev_snp_guest)
> +{
> +    int fw_error, rc;
> +    SevCommonState *sev_common = SEV_COMMON(sev_snp_guest);
> +    struct kvm_sev_snp_launch_start *start = &sev_snp_guest->kvm_start_conf;
> +
> +    trace_kvm_sev_snp_launch_start(start->policy, sev_snp_guest->guest_visible_workarounds);
> +
> +    rc = sev_ioctl(sev_common->sev_fd, KVM_SEV_SNP_LAUNCH_START,
> +                   start, &fw_error);
> +    if (rc < 0) {
> +        error_report("%s: SNP_LAUNCH_START ret=%d fw_error=%d '%s'",
> +                __func__, rc, fw_error, fw_error_to_str(fw_error));
> +        return 1;
> +    }
> +
> +    QTAILQ_INIT(&launch_update);
> +
> +    sev_set_guest_state(sev_common, SEV_STATE_LAUNCH_UPDATE);
> +
> +    return 0;
> +}
> +
>   static int
>   sev_launch_start(SevGuestState *sev_guest)
>   {
> @@ -1007,7 +1042,12 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>           goto err;
>       }
>   
> -    ret = sev_launch_start(SEV_GUEST(sev_common));
> +    if (sev_snp_enabled()) {
> +        ret = sev_snp_launch_start(SEV_SNP_GUEST(sev_common));
> +    } else {
> +        ret = sev_launch_start(SEV_GUEST(sev_common));
> +    }

Instead of an "if", this should be a method in sev-common.  Likewise for 
launch_finish in the next patch.

Also, patch 47 should introduce an "int (*launch_update_data)(hwaddr 
gpa, uint8_t *ptr, uint64_t len)" method whose implementation is either 
the existing sev_launch_update_data() for sev-guest, or a wrapper around 
snp_launch_update_data() (to add KVM_SEV_SNP_PAGE_TYPE_NORMAL) for 
sev-snp-guest.

In general, the only uses of sev_snp_enabled() should be in 
sev_add_kernel_loader_hashes() and kvm_handle_vmgexit_ext_req().  I 
would not be that strict for the QMP and HMP functions, but if you want 
to make those methods of sev-common I wouldn't complain.

Paolo

>       if (ret) {
>           error_setg(errp, "%s: failed to create encryption context", __func__);
>           goto err;
> diff --git a/target/i386/trace-events b/target/i386/trace-events
> index 2cd8726eeb..cb26d8a925 100644
> --- a/target/i386/trace-events
> +++ b/target/i386/trace-events
> @@ -11,3 +11,4 @@ kvm_sev_launch_measurement(const char *value) "data %s"
>   kvm_sev_launch_finish(void) ""
>   kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa 0x%" PRIx64 " hva 0x%" PRIx64 " data 0x%" PRIx64 " len %d"
>   kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
> +kvm_sev_snp_launch_start(uint64_t policy, char *gosvw) "policy 0x%" PRIx64 " gosvw %s"


