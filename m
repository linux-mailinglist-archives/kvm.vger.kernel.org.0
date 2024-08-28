Return-Path: <kvm+bounces-25242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20CD89625F0
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 13:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 455DB1C2370B
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 11:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14CFB1553BC;
	Wed, 28 Aug 2024 11:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e5mGa8Qd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755BD3FEC
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 11:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724844199; cv=none; b=sonHqpVjieIEqVqXH699o86LxfrK3dtx7kX34mLX2ohjnfdltoD0pRW+01l3hAt/kExp+3E1S6VOPBr+unhUechm9DH53ihECVQI5MNhGfcv1pw0bBIDZLbGf5wSa7MqPGyW/5YQetV+PATOd72wCmxbb10LKepL7u2S67/J7w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724844199; c=relaxed/simple;
	bh=nbPQLzfzYM20rrwCtRiiclAxBxp1BUjK7SM3pjygeuM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fACb1nJImvwXuIHLoTJ/T9SaP3VP+2aToG/DIoaXxzCM/nUW91XS3k7jixXdUA88HuP+ByWCYf5VVyeVBuOJkMyChuuRvFg95CfmEhjw+U2A/RXnd5qF0LkS/1OoFkTyROfsTgNuIlAFeYFhBGo3FU1PDSOdS8hzPf5dDIgoUfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e5mGa8Qd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724844196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sjPscny8RpBp/Hq/MF0Txq0RsmBmvhMA9j1IvksC6Zg=;
	b=e5mGa8QdE95hpQF6Ga2GuAA0gFBc3mNVpX0mROmBDImpqd/h94GJvuDFtZAwdXlXq7RApd
	dQvfJ+4PA5fqn6o7b4sGzko+RNFpUATdSOQcFOIIVDsgFZUTymApjGHgWBxmvT58i9HMvi
	5S4XlNOdfq44BXirc6ovWCLiMLYGyp4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-VVMG9EtQNq6uKZ4tlwC9Sw-1; Wed,
 28 Aug 2024 07:23:13 -0400
X-MC-Unique: VVMG9EtQNq6uKZ4tlwC9Sw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AB3F1955F4A;
	Wed, 28 Aug 2024 11:23:12 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 151FE19560A3;
	Wed, 28 Aug 2024 11:23:11 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id E498221E6A28; Wed, 28 Aug 2024 13:23:08 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  qemu-trivial@nongnu.org,
  zhao1.liu@intel.com,  kvm@vger.kernel.org,  qemu-devel@nongnu.org
Subject: Re: [PATCH v5 1/2] kvm: replace fprintf with
 error_report()/printf() in kvm_init()
In-Reply-To: <20240828075630.7754-2-anisinha@redhat.com> (Ani Sinha's message
	of "Wed, 28 Aug 2024 13:26:28 +0530")
References: <20240828075630.7754-1-anisinha@redhat.com>
	<20240828075630.7754-2-anisinha@redhat.com>
Date: Wed, 28 Aug 2024 13:23:08 +0200
Message-ID: <87ikvkriw3.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Ani Sinha <anisinha@redhat.com> writes:

> error_report() is more appropriate for error situations. Replace fprintf with
> error_report() and error_printf() as appropriate. Cosmetic. No functional
> change.

Uh, I missed this last time around: the change is more than just
cosmetics!  The error messages change, e.g. from

    $ qemu-system-x86_64 -nodefaults -S -display none --accel kvm
    qemu-system-x86_64: --accel kvm: Could not access KVM kernel module: Permission denied
    qemu-system-x86_64: --accel kvm: failed to initialize kvm: Permission denied

to

    $ qemu-system-x86_64 -nodefaults -S -display none --accel kvm
    Could not access KVM kernel module: Permission denied
    qemu-system-x86_64: --accel kvm: failed to initialize kvm: Permission denied

Note: the second message is from kvm_init()'s caller.  Reporting the
same error twice is wrong, but not this patch's problem.

Moreover, the patch tweaks an error message at [*].

Suggest something like

  Replace fprintf() with error_report() and error_printf() where
  appropriate.  Error messages improve, e.g. from

      Could not access KVM kernel module: Permission denied

  to

      qemu-system-x86_64: --accel kvm: Could not access KVM kernel module: Permission denied

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
> v5: more changes from Markus's comments on v4.
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 75d11a07b2..fcc157f0e6 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
>      QLIST_INIT(&s->kvm_parked_vcpus);
>      s->fd = qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
>      if (s->fd == -1) {
> -        fprintf(stderr, "Could not access KVM kernel module: %m\n");
> +        error_report("Could not access KVM kernel module: %m");
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
>      } while (ret == -EINTR);
>  
>      if (ret < 0) {
> -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
> -                strerror(-ret));
> +        error_report("ioctl(KVM_CREATE_VM) failed: %s", strerror(-ret));

[*] This is where you change an error message.

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
> +            error_printf("Host kernel setup problem detected."
> +                         " Please verify:\n");
> +            error_printf("- for kernels supporting the"
> +                        " switch_amode or user_mode parameters, whether");
> +            error_printf(" user space is running in primary address space\n");
> +            error_printf("- for kernels supporting the vm.allocate_pgste"
> +                         " sysctl, whether it is enabled\n");
>          }
>  #elif defined(TARGET_PPC)
>          if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
> -                    (type == 2) ? "pr" : "hv");
> +            error_printf("PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
> +                         (type == 2) ? "pr" : "hv");
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
>              }
>          }
> @@ -2542,8 +2538,8 @@ static int kvm_init(MachineState *ms)
>      }
>      if (missing_cap) {
>          ret = -EINVAL;
> -        fprintf(stderr, "kvm does not support %s\n%s",
> -                missing_cap->name, upgrade_note);
> +        error_report("kvm does not support %s", missing_cap->name);
> +        error_printf("%s", upgrade_note);
>          goto err;
>      }

With the commit message corrected:
Reviewed-by: Markus Armbruster <armbru@redhat.com>


