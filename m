Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D35782649
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 11:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbjHUJbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 05:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbjHUJbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 05:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B707C9
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 02:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692610252;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=EYCyGoQNEU4xYIbssbxjHO1jV4aXkCa+aYH+TfRpxsM=;
        b=Zb4NdXElZ4DfR0EY1YsslkknqWkxr3hTMt1GqpJs4ygCrgGP7T7OMG/C4CnSEeaO34CYjL
        bbf5eD7H6SMPxSujziLCwhhwOb00uNK90x6+MOYDivHhyY49gVXh7ymi5lR/ewMoew71sY
        P2RGVieazkSpovbfTEEGJTcBrhtRJM4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-688-2G95SBrCNEeaqwzaCninFQ-1; Mon, 21 Aug 2023 05:30:50 -0400
X-MC-Unique: 2G95SBrCNEeaqwzaCninFQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8ED785CBEE;
        Mon, 21 Aug 2023 09:30:49 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26BD3492C13;
        Mon, 21 Aug 2023 09:30:47 +0000 (UTC)
Date:   Mon, 21 Aug 2023 10:30:45 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 21/58] i386/tdx: Implement user specified tsc frequency
Message-ID: <ZOMuxfyS8J0pUIph@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-22-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-22-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:50:04AM -0400, Xiaoyao Li wrote:
> Reuse "-cpu,tsc-frequency=" to get user wanted tsc frequency and call VM
> scope VM_SET_TSC_KHZ to set the tsc frequency of TD before KVM_TDX_INIT_VM.
> 
> Besides, sanity check the tsc frequency to be in the legal range and
> legal granularity (required by TDX module).
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
> Changes from RFC v4:
>   - Use VM scope VM_SET_TSC_KHZ to set the TSC frequency of TD since KVM
>     side drop the @tsc_khz field in struct kvm_tdx_init_vm
> ---
>  target/i386/kvm/kvm.c |  9 +++++++++
>  target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index d51067fdc12a..4a146bc42f63 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -859,6 +859,15 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
>      int r, cur_freq;
>      bool set_ioctl = false;
>  
> +    /*
> +     * TSC of TD vcpu is immutable, it cannot be set/changed via vcpu scope
> +     * VM_SET_TSC_KHZ, but only be initialized via VM scope VM_SET_TSC_KHZ
> +     * before ioctl KVM_TDX_INIT_VM in tdx_pre_create_vcpu()
> +     */
> +    if (is_tdx_vm()) {
> +        return 0;
> +    }
> +
>      if (!env->tsc_khz) {
>          return 0;
>      }
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 33d015a08c34..a72badfbfd65 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -32,6 +32,9 @@
>                                       (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
>                                       (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
>  
> +#define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
> +#define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
> +
>  #define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
>  #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
>  #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
> @@ -513,6 +516,27 @@ int tdx_pre_create_vcpu(CPUState *cpu)
>          goto out_free;
>      }
>  
> +    r = -EINVAL;
> +    if (env->tsc_khz && (env->tsc_khz < TDX_MIN_TSC_FREQUENCY_KHZ ||
> +                         env->tsc_khz > TDX_MAX_TSC_FREQUENCY_KHZ)) {
> +        error_report("Invalid TSC %ld KHz, must specify cpu_frequency between [%d, %d] kHz",
> +                      env->tsc_khz, TDX_MIN_TSC_FREQUENCY_KHZ,
> +                      TDX_MAX_TSC_FREQUENCY_KHZ);
> +        goto out;
> +    }
> +
> +    if (env->tsc_khz % (25 * 1000)) {
> +        error_report("Invalid TSC %ld KHz, it must be multiple of 25MHz", env->tsc_khz);
> +        goto out;
> +    }
> +
> +    /* it's safe even env->tsc_khz is 0. KVM uses host's tsc_khz in this case */
> +    r = kvm_vm_ioctl(kvm_state, KVM_SET_TSC_KHZ, env->tsc_khz);
> +    if (r < 0) {
> +        error_report("Unable to set TSC frequency to %" PRId64 " kHz", env->tsc_khz);
> +        goto out;
> +    }

error_setg(errp, ....) in all of these cases.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

