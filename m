Return-Path: <kvm+bounces-25229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F577961F87
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 08:21:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 384F6288B86
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 06:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CE0158216;
	Wed, 28 Aug 2024 06:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OtK58o9r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D7D155A3C
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 06:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724825764; cv=none; b=TTwnk2NeI8OOvcWsLexbpd2Q2wA4hoNdDxhiRhTUx2jzY8G5hkABfmffUdU8p+S2PAohFr5MUTDwycMOq1Wfm1WmejfNdebHS94ZG+0f7rrGu2HVSq2n/jO7A5gmGmnHKlxPwo+psQMY78CUww3GjPheYjSC1RlqL5Zzj6mY9MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724825764; c=relaxed/simple;
	bh=KT+TwnUNQJxTTFJcO7//3nB2g4ynI7vEvQsuTqLFJKM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NizM9dWPV3A5r0JFL0eJKp92u6mZ4SzsEPTjp2+kzN5vIVIZ6YipUvubHnq3sEcsB3jn7wm076fvzYUMEyZ+4a3JdG841UzDZlNF79LiNTtTPC6tigydWawj5MbF7NWlEeRMh80S+i0SapxfdgTVRZJr9o7pU/WuHxnxieWKdeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OtK58o9r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724825758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=anw0eiHHc6iVRnxYqeB3eFZ+/gHPOJF7vc2zFd6U/Kw=;
	b=OtK58o9rXs6tWGaN4pbNeNcai7I3UDQDrGEW8xq72lgleLOM9u5+NMa5hBnm0B3608OS7h
	BT+sXM0eNIRSrka30H9pN2CEXLTJSJ7HIFnt7KJ6sPTyFxw/1hNEpr1X4DzassKvH8RRqQ
	e/6IjVYS3Ucc9hmbcQuGUh550u3Npvw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-164-W2B2JnpeMkSzIa3lYii-HQ-1; Wed,
 28 Aug 2024 02:15:55 -0400
X-MC-Unique: W2B2JnpeMkSzIa3lYii-HQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 253411955BED;
	Wed, 28 Aug 2024 06:15:51 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6816F19560A3;
	Wed, 28 Aug 2024 06:15:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 241C621E6A28; Wed, 28 Aug 2024 08:15:48 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  qemu-trivial@nongnu.org,
  zhao1.liu@intel.com,  kvm@vger.kernel.org,  qemu-devel@nongnu.org
Subject: Re: [PATCH v4 1/2] kvm: replace fprintf with error_report/printf()
 in kvm_init()
In-Reply-To: <20240827151022.37992-2-anisinha@redhat.com> (Ani Sinha's message
	of "Tue, 27 Aug 2024 20:40:21 +0530")
References: <20240827151022.37992-1-anisinha@redhat.com>
	<20240827151022.37992-2-anisinha@redhat.com>
Date: Wed, 28 Aug 2024 08:15:48 +0200
Message-ID: <87wmk1fa0b.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Ani Sinha <anisinha@redhat.com> writes:

> error_report() is more appropriate for error situations. Replace fprintf with
> error_report. Cosmetic. No functional change.
>
> CC: qemu-trivial@nongnu.org
> CC: zhao1.liu@intel.com
> CC: armbru@redhat.com
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
>  1 file changed, 18 insertions(+), 22 deletions(-)
>
> changelog:
> v2: fix a bug.
> v3: replace one instance of error_report() with error_printf(). added tags.
> v4: changes suggested by Markus.
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 75d11a07b2..d9f477bb06 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
>      QLIST_INIT(&s->kvm_parked_vcpus);
>      s->fd = qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
>      if (s->fd == -1) {
> -        fprintf(stderr, "Could not access KVM kernel module: %m\n");
> +        error_report("Could not access KVM kernel module: %m");

The use of %m gave me pause.  It's a GNU extension, but this
Linux-specific code, so it's fine.

>          ret = -errno;
>          goto err;
>      }
> @@ -2437,13 +2437,13 @@ static int kvm_init(MachineState *ms)
>          if (ret >= 0) {
>              ret = -EINVAL;
>          }
> -        fprintf(stderr, "kvm version too old\n");
> +        error_report("kvm version too old");
>          goto err;
>      }
>  
>      if (ret > KVM_API_VERSION) {
>          ret = -EINVAL;
> -        fprintf(stderr, "kvm version not supported\n");
> +        error_report("kvm version not supported");
>          goto err;
>      }
>  
> @@ -2488,26 +2488,22 @@ static int kvm_init(MachineState *ms)
       if (object_property_find(OBJECT(current_machine), "kvm-type")) {
           g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
                                                               "kvm-type",
                                                               &error_abort);
           type = mc->kvm_type(ms, kvm_type);
       } else if (mc->kvm_type) {
           type = mc->kvm_type(ms, NULL);
       } else {
           type = kvm_arch_get_default_type(ms);
       }

       if (type < 0) {
           ret = -EINVAL;
           goto err;

Note: the code assigning to @type is responsible for reporting an error
when it assigns a negative value.  I guess it does.  Even if it doesn't,
not your patch's problem.

       }

       do {
           ret = kvm_ioctl(s, KVM_CREATE_VM, type);
>      } while (ret == -EINTR);
>  
>      if (ret < 0) {
> -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
> -                strerror(-ret));
> +        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
> +                    strerror(-ret));

We don't normally report a numeric errno code in additon to its
description text.  Should we use the opportunity to drop it here?

>  
>  #ifdef TARGET_S390X
>          if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "Host kernel setup problem detected. Please verify:\n");
> -            fprintf(stderr, "- for kernels supporting the switch_amode or"
> -                    " user_mode parameters, whether\n");
> -            fprintf(stderr,
> -                    "  user space is running in primary address space\n");
> -            fprintf(stderr,
> -                    "- for kernels supporting the vm.allocate_pgste sysctl, "
> -                    "whether it is enabled\n");
> +            error_printf("Host kernel setup problem detected. Please verify:");
> +            error_printf("\n- for kernels supporting the"

Please keep the \n at the end of the string literal:

               error_printf("Host kernel setup problem detected."
                            " Please verify:\n");
               error_printf("- for kernels supporting the"

> +                        " switch_amode or user_mode parameters, whether");
> +            error_printf(" user space is running in primary address space\n");
> +            error_printf("- for kernels supporting the vm.allocate_pgste "
> +                         "sysctl, whether it is enabled\n");

Opportunity to break this line like we break the others:

               error_printf("- for kernels supporting the vm.allocate_pgste"
                            " sysctl, whether it is enabled\n");

>          }
>  #elif defined(TARGET_PPC)
>          if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
> -                    (type == 2) ? "pr" : "hv");
> +            error_printf("PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
> +                        (type == 2) ? "pr" : "hv");
>          }
>  #endif
>          goto err;
> @@ -2526,9 +2522,9 @@ static int kvm_init(MachineState *ms)
>                          nc->name, nc->num, soft_vcpus_limit);
>  
>              if (nc->num > hard_vcpus_limit) {
> -                fprintf(stderr, "Number of %s cpus requested (%d) exceeds "
> -                        "the maximum cpus supported by KVM (%d)\n",
> -                        nc->name, nc->num, hard_vcpus_limit);
> +                error_report("Number of %s cpus requested (%d) exceeds "
> +                             "the maximum cpus supported by KVM (%d)",
> +                             nc->name, nc->num, hard_vcpus_limit);
>                  exit(1);

Not this patch's problem, but why do we exit(1) here?

>              }
>          }
> @@ -2542,8 +2538,8 @@ static int kvm_init(MachineState *ms)
>      }
>      if (missing_cap) {
>          ret = -EINVAL;
> -        fprintf(stderr, "kvm does not support %s\n%s",
> -                missing_cap->name, upgrade_note);
> +        error_printf("kvm does not support %s\n%s",
> +                     missing_cap->name, upgrade_note);

This is an error message, so it should be marked as such:

           error_report("kvm does not support %s", missing_cap->name);
           error_printf("%s", upgrade_note);

>          goto err;
>      }

There are a few more uses of fprintf() for reporting errors in kvm.c.
Would be nice to have them cleaned up.  This is not a demand.


