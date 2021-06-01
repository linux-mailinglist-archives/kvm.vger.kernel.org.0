Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBE0397A52
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 21:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhFATBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 15:01:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233970AbhFATBq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 15:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622574003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nvA+Gv0qzYzkzDgkZ33nkaovQzbyK0edeORhGDjTiZ8=;
        b=LXUdRTjnevDAfYyCEHm87p3HvHhoaLI3Igpijifao6GA4u9lUUKFBHAP8fX51ZzqHEw6WD
        wSzRUOjbgyDValth/2ZRkOfxJK6O4H3HWG+mAt+eMEPqlqx1Jsis9tHRi0O3RuqRirYwUU
        FTYns1p5jg4o1pOjePiZE52QleKoKyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-qnQHwXqiNlejzyv9R5J8Ng-1; Tue, 01 Jun 2021 15:00:01 -0400
X-MC-Unique: qnQHwXqiNlejzyv9R5J8Ng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 326F8101372A;
        Tue,  1 Jun 2021 18:59:59 +0000 (UTC)
Received: from localhost (ovpn-112-239.rdu2.redhat.com [10.10.112.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBA5B5D9CD;
        Tue,  1 Jun 2021 18:59:55 +0000 (UTC)
Date:   Tue, 1 Jun 2021 14:59:55 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Claudio Fontana <cfontana@suse.de>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-devel@nongnu.org
Subject: Re: [PATCH 2/2] i386: run accel_cpu_instance_init as
 instance_post_init
Message-ID: <20210601185955.upjlobdgi366ruhh@habkost.net>
References: <20210529091313.16708-1-cfontana@suse.de>
 <20210529091313.16708-3-cfontana@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210529091313.16708-3-cfontana@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 29, 2021 at 11:13:13AM +0200, Claudio Fontana wrote:
> This partially fixes host and max cpu initialization,
> by running the accel cpu initialization only after all instance
> init functions are called for all X86 cpu subclasses.

Can you describe what exactly are the initialization ordering
dependencies that were broken?

> 
> Partial Fix.

What does "partial fix" mean?

> 
> Fixes: 48afe6e4eabf ("i386: split cpu accelerators from cpu.c, using AccelCPUClass")
> Signed-off-by: Claudio Fontana <cfontana@suse.de>

The fix looks simple and may be obvious, my only concerns are:

1. Testing.  Luckily we are a bit early in the release cycle so
   we have some time for that.
2. Describing more clearly what exactly was wrong.  This can be
   fixed manually in the commit message when applying the patch.


An even better long term solution would be removing the
initialization ordering dependencies and make
accel_cpu_instance_init() safe to be called earlier.  Would that
be doable?


> ---
>  target/i386/cpu.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 6bcb7dbc2c..ae148fbd2f 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6422,6 +6422,11 @@ static void x86_cpu_register_feature_bit_props(X86CPUClass *xcc,
>      x86_cpu_register_bit_prop(xcc, name, w, bitnr);
>  }
>  
> +static void x86_cpu_post_initfn(Object *obj)
> +{
> +    accel_cpu_instance_init(CPU(obj));
> +}
> +
>  static void x86_cpu_initfn(Object *obj)
>  {
>      X86CPU *cpu = X86_CPU(obj);
> @@ -6473,9 +6478,6 @@ static void x86_cpu_initfn(Object *obj)
>      if (xcc->model) {
>          x86_cpu_load_model(cpu, xcc->model);
>      }
> -
> -    /* if required, do accelerator-specific cpu initializations */
> -    accel_cpu_instance_init(CPU(obj));
>  }
>  
>  static int64_t x86_cpu_get_arch_id(CPUState *cs)
> @@ -6810,6 +6812,8 @@ static const TypeInfo x86_cpu_type_info = {
>      .parent = TYPE_CPU,
>      .instance_size = sizeof(X86CPU),
>      .instance_init = x86_cpu_initfn,
> +    .instance_post_init = x86_cpu_post_initfn,
> +
>      .abstract = true,
>      .class_size = sizeof(X86CPUClass),
>      .class_init = x86_cpu_common_class_init,
> -- 
> 2.26.2
> 

-- 
Eduardo

