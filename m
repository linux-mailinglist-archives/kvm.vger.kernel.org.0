Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE93D509C2F
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 11:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387585AbiDUJZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 05:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387576AbiDUJZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 05:25:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D12E27FCB
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 02:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650532962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XT7ihGwtGHY1JPhZmh8zH+/EQhv9mO53k4ux+mRPHHs=;
        b=itjfbhoyFzWBoBX3iNxlTZ2iZsPJ54MWfP+Qfz45hKMehdYlLnm5x2PKWnW/EH78o7taIK
        sQLZBlaVH+aWRASwKerHEmIWnP9sN2qQyCKYqaF7EoSQjcJAvhk2yPV5Fc88n7zFN4E2dH
        TDZBtz6YDJYF3pCnnWmJrC+sVQ5KxIY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-XviGF4s_PkuwKe9FtrBXKA-1; Thu, 21 Apr 2022 05:22:39 -0400
X-MC-Unique: XviGF4s_PkuwKe9FtrBXKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B873C18A6581;
        Thu, 21 Apr 2022 09:22:38 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0490EC35991;
        Thu, 21 Apr 2022 09:22:36 +0000 (UTC)
Message-ID: <f6ba13c0e75b8d8ba22c5f95f5ada52350ccd757.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kernel test robot <lkp@intel.com>,
        Anton Romanov <romanton@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     kbuild-all@lists.01.org, seanjc@google.com, vkuznets@redhat.com
Date:   Thu, 21 Apr 2022 12:22:35 +0300
In-Reply-To: <202204211558.rjkmRfSe-lkp@intel.com>
References: <20220421005645.56801-1-romanton@google.com>
         <202204211558.rjkmRfSe-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-21 at 16:09 +0800, kernel test robot wrote:
> Hi Anton,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on kvm/master]
> [also build test WARNING on mst-vhost/linux-next v5.18-rc3 next-20220420]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Anton-Romanov/KVM-x86-Use-current-rather-than-snapshotted-TSC-frequency-if-it-is-constant/20220421-090221
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
> config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220421/202204211558.rjkmRfSe-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/c60b3070bd6e7e804de118dac10002e4f5f714a6
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Anton-Romanov/KVM-x86-Use-current-rather-than-snapshotted-TSC-frequency-if-it-is-constant/20220421-090221
>         git checkout c60b3070bd6e7e804de118dac10002e4f5f714a6
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    arch/x86/kvm/x86.c: In function '__get_kvmclock':
>    arch/x86/kvm/x86.c:2936:17: error: expected expression before 'struct'
>     2936 |                 struct timespec64 ts;
>          |                 ^~~~~~
> > > arch/x86/kvm/x86.c:2933:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
>     2933 |         if (ka->use_master_clock &&

The bot is right, looks like '{' got removed by a mistake, I didn't notice.

Best regards,
	Maxim Levitsky




>          |         ^~
>    arch/x86/kvm/x86.c:2938:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
>     2938 |                 if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
>          |                 ^~
>    arch/x86/kvm/x86.c:2938:53: error: 'ts' undeclared (first use in this function); did you mean 'tms'?
>     2938 |                 if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
>          |                                                     ^~
>          |                                                     tms
>    arch/x86/kvm/x86.c:2938:53: note: each undeclared identifier is reported only once for each function it appears in
>    arch/x86/kvm/x86.c: At top level:
>    arch/x86/kvm/x86.c:2952:11: error: expected identifier or '(' before 'else'
>     2952 |         } else {
>          |           ^~~~
>    In file included from include/linux/percpu.h:6,
>                     from include/linux/context_tracking_state.h:5,
>                     from include/linux/hardirq.h:5,
>                     from include/linux/kvm_host.h:7,
>                     from arch/x86/kvm/x86.c:19:
>    include/linux/preempt.h:219:1: error: expected identifier or '(' before 'do'
>      219 | do { \
>          | ^~
>    include/linux/smp.h:268:33: note: in expansion of macro 'preempt_enable'
>      268 | #define put_cpu()               preempt_enable()
>          |                                 ^~~~~~~~~~~~~~
>    arch/x86/kvm/x86.c:2956:9: note: in expansion of macro 'put_cpu'
>     2956 |         put_cpu();
>          |         ^~~~~~~
>    include/linux/preempt.h:223:3: error: expected identifier or '(' before 'while'
>      223 | } while (0)
>          |   ^~~~~
>    include/linux/smp.h:268:33: note: in expansion of macro 'preempt_enable'
>      268 | #define put_cpu()               preempt_enable()
>          |                                 ^~~~~~~~~~~~~~
>    arch/x86/kvm/x86.c:2956:9: note: in expansion of macro 'put_cpu'
>     2956 |         put_cpu();
>          |         ^~~~~~~
>    arch/x86/kvm/x86.c:2957:1: error: expected identifier or '(' before '}' token
>     2957 | }
>          | ^
> 
> 
> vim +/if +2933 arch/x86/kvm/x86.c
> 
>   2922	
>   2923	/* Called within read_seqcount_begin/retry for kvm->pvclock_sc.  */
>   2924	static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
>   2925	{
>   2926		struct kvm_arch *ka = &kvm->arch;
>   2927		struct pvclock_vcpu_time_info hv_clock;
>   2928	
>   2929		/* both __this_cpu_read() and rdtsc() should be on the same cpu */
>   2930		get_cpu();
>   2931	
>   2932		data->flags = 0;
> > 2933		if (ka->use_master_clock &&
>   2934			(static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz)))
>   2935	#ifdef CONFIG_X86_64
>   2936			struct timespec64 ts;
>   2937	
>   2938			if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
>   2939				data->realtime = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
>   2940				data->flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
>   2941			} else
>   2942	#endif
>   2943			data->host_tsc = rdtsc();
>   2944	
>   2945			data->flags |= KVM_CLOCK_TSC_STABLE;
>   2946			hv_clock.tsc_timestamp = ka->master_cycle_now;
>   2947			hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
>   2948			kvm_get_time_scale(NSEC_PER_SEC, get_cpu_tsc_khz() * 1000LL,
>   2949					   &hv_clock.tsc_shift,
>   2950					   &hv_clock.tsc_to_system_mul);
>   2951			data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
>   2952		} else {
>   2953			data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
>   2954		}
>   2955	
>   2956		put_cpu();
>   2957	}
>   2958	
> 


