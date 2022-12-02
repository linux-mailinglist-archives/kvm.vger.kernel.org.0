Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30A66400B6
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 07:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbiLBGyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 01:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiLBGyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 01:54:53 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93063BBBFD
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 22:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669964092; x=1701500092;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YikgxWHkjXBdW36x0bhe9MX4hxGxON7eQ2q2fKy1Od4=;
  b=N+SGnPx5ycKNxaHfyWaCJjNAFoLv8UsJ7+75Kp0jWGL4BunAAnI+dt0f
   ikEQ9zvXtdBIfmyjq8rbBbd/63mXg22D0DkIKWTEdxOvNqi9uq1pA3CEz
   FnAap9nAO0xmAK/4t4+WvjvmpRY3myaFREXsCz5Mi4gn4emcNOJIbT7w8
   5VjAOuAvVuxz3JhvIDH365JAqxFdcMussZ4ASPSa/6FB+CBPGbzR5PYn4
   AMVbu9k3gkDzeSQvIRxEgJLeKxSRsh3lICRtAksPs7jpHo5xwPOBtff2u
   yyMaIqEYHG5mdSjvt6K9vigYTOsEozv3MaQghm4ptb4APTVAYD/diFB81
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="342820202"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="342820202"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 22:54:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="733710089"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="733710089"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Dec 2022 22:54:29 -0800
Message-ID: <c7971c8ad3b4683e2b3036dd7524af1cb42e50e1.camel@linux.intel.com>
Subject: Re: [PATCH v3 2/3] KVM: keep track of running ioctls
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Date:   Fri, 02 Dec 2022 14:54:28 +0800
In-Reply-To: <20221111154758.1372674-3-eesposit@redhat.com>
References: <20221111154758.1372674-1-eesposit@redhat.com>
         <20221111154758.1372674-3-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-11-11 at 10:47 -0500, Emanuele Giuseppe Esposito wrote:
> Using the new accel-blocker API, mark where ioctls are being called
> in KVM. Next, we will implement the critical section that will take
> care of performing memslots modifications atomically, therefore
> preventing any new ioctl from running and allowing the running ones
> to finish.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index f99b0becd8..ff660fd469 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2310,6 +2310,7 @@ static int kvm_init(MachineState *ms)
>      assert(TARGET_PAGE_SIZE <= qemu_real_host_page_size());
>  
>      s->sigmask_len = 8;
> +    accel_blocker_init();
>  
>  #ifdef KVM_CAP_SET_GUEST_DEBUG
>      QTAILQ_INIT(&s->kvm_sw_breakpoints);
> @@ -3014,7 +3015,9 @@ int kvm_vm_ioctl(KVMState *s, int type, ...)
>      va_end(ap);
>  
>      trace_kvm_vm_ioctl(type, arg);
> +    accel_ioctl_begin();
>      ret = ioctl(s->vmfd, type, arg);
> +    accel_ioctl_end();
>      if (ret == -1) {
>          ret = -errno;
>      }
> @@ -3032,7 +3035,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type,
> ...)
>      va_end(ap);
>  
>      trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
> +    accel_cpu_ioctl_begin(cpu);

Does this mean that kvm_region_commit() can inhibit any other vcpus
doing any ioctls?

>      ret = ioctl(cpu->kvm_fd, type, arg);
> +    accel_cpu_ioctl_end(cpu);
>      if (ret == -1) {
>          ret = -errno;
>      }
> @@ -3050,7 +3055,9 @@ int kvm_device_ioctl(int fd, int type, ...)
>      va_end(ap);
>  
>      trace_kvm_device_ioctl(fd, type, arg);
> +    accel_ioctl_begin();
>      ret = ioctl(fd, type, arg);
> +    accel_ioctl_end();
>      if (ret == -1) {
>          ret = -errno;
>      }

