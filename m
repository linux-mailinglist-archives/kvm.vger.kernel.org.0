Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A34D543897
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 18:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245213AbiFHQN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 12:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245191AbiFHQN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 12:13:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D43B0DECF7
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 09:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654704835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V6/KVFYBezL5r8u9gDn3/M/o65ARGjiSjwNuOA5jmSE=;
        b=bfX/CiA8ZgV4u0tRW0N7bcmVL4idr93qg2mD1jKm79Q7JTAPimf5xci70kkTkcdreG4vjg
        /PtDdtgEO8CyDLB0FDi15Um/ItGAgiWmzOGoMKu2dYbA3q4In8gMiO1hL9NJaR5eR7n1QV
        2NfhcVNswVx/sa1tbBQDriDKj/O2F6s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-wSfuWU-4NB2BTzHSjWxnfQ-1; Wed, 08 Jun 2022 12:13:54 -0400
X-MC-Unique: wSfuWU-4NB2BTzHSjWxnfQ-1
Received: by mail-wr1-f70.google.com with SMTP id h14-20020adfa4ce000000b00218518b622eso1668466wrb.4
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 09:13:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V6/KVFYBezL5r8u9gDn3/M/o65ARGjiSjwNuOA5jmSE=;
        b=AXn48GpQvWyfSg9oMdj6tvroitGL2Pwc9YltJFXBhQuj44K5Sh4SwufmxB3E4gYbTJ
         RBT8XbNCq0diCaHCc3eH1cuVlFTrxzXI2aWJR7X1BZvisfbCLAIL691F5PeEGAPx5nHo
         LB7EtcLVMDwiL95sLTXx+7eIV5VUUMxV8SJ/84GLPMWqp/0JpHCz9DQxkz1gMhI1IbvQ
         B1+d9mVJ3jEAVGeObObH6iFDGxNCxExbOHb1PP6uiyYtY6t3VLB318wxPLUsuMRsXdJM
         vUJhOZjJBJlH6UkLq2GH6RyWIUMMD+HISW/XIuLTZzMufQz226qzjK7HEGrQj6NWCklC
         N2Ew==
X-Gm-Message-State: AOAM533NAVvRF0azc5XAVL33RZ2Tixb5Vn10ZEDlCMjWTo7iWu69Vycs
        34ReuiExktGJOwJE4+6LvnBA2A6EC8erFbK0u7Tipzgt0J4q4mHqob9HZw/OuDu/Azk6wZdO799
        DMNOvLr3qLLI8
X-Received: by 2002:a05:6000:18a8:b0:212:ae71:a3f6 with SMTP id b8-20020a05600018a800b00212ae71a3f6mr32955040wri.635.1654704833167;
        Wed, 08 Jun 2022 09:13:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwp6W60XuDhi1wHmd7D6q1nJKUu0UVfAuRkXbrvd5t24utVbdoCL1xFF3/INal2nX6xkKu0aQ==
X-Received: by 2002:a05:6000:18a8:b0:212:ae71:a3f6 with SMTP id b8-20020a05600018a800b00212ae71a3f6mr32955019wri.635.1654704832964;
        Wed, 08 Jun 2022 09:13:52 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id bi11-20020a05600c3d8b00b0039c3ecdca66sm16717698wmb.23.2022.06.08.09.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:13:52 -0700 (PDT)
Date:   Wed, 8 Jun 2022 18:13:50 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 093/144] KVM: selftests: Track kvm_vcpu object in
 tsc_scaling_sync
Message-ID: <20220608161350.abq5hqr6t3wu5q52@gator>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-94-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603004331.1523888-94-seanjc@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 12:42:40AM +0000, Sean Christopherson wrote:
> Track the added 'struct kvm_vcpu' object in tsc_scaling_sync instead of
> relying purely on the VM + vcpu_id combination.  Ideally, the test
> wouldn't need to manually manage vCPUs, but the need to invoke a per-VM
> ioctl before creating vCPUs is not handled by the selftests framework,
> at least not yet...
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/x86_64/tsc_scaling_sync.c     | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
> index f0083d8cfe98..b7cd5c47fc53 100644
> --- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
> +++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
> @@ -46,38 +46,41 @@ static void guest_code(void)
>  
>  static void *run_vcpu(void *_cpu_nr)
>  {
> -	unsigned long cpu = (unsigned long)_cpu_nr;
> +	unsigned long vcpu_id = (unsigned long)_cpu_nr;
>  	unsigned long failures = 0;
>  	static bool first_cpu_done;
> +	struct kvm_vcpu *vcpu;
>  
>  	/* The kernel is fine, but vm_vcpu_add_default() needs locking */
>  	pthread_spin_lock(&create_lock);
>  
> -	vm_vcpu_add_default(vm, cpu, guest_code);
> +	vm_vcpu_add_default(vm, vcpu_id, guest_code);
> +	vcpu = vcpu_get(vm, vcpu_id);
>  
>  	if (!first_cpu_done) {
>  		first_cpu_done = true;
> -		vcpu_set_msr(vm, cpu, MSR_IA32_TSC, TEST_TSC_OFFSET);
> +		vcpu_set_msr(vm, vcpu->id, MSR_IA32_TSC, TEST_TSC_OFFSET);
>  	}
>  
>  	pthread_spin_unlock(&create_lock);
>  
>  	for (;;) {
> -		volatile struct kvm_run *run = vcpu_state(vm, cpu);
> +		volatile struct kvm_run *run = vcpu->run;
>                  struct ucall uc;
>  
> -                vcpu_run(vm, cpu);
> +		vcpu_run(vm, vcpu->id);
>                  TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
>                              "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
>                              run->exit_reason,
>                              exit_reason_str(run->exit_reason));
>  
> -                switch (get_ucall(vm, cpu, &uc)) {
> +		switch (get_ucall(vm, vcpu->id, &uc)) {

The two changes above show that this file had some space vs. tab issues.
I just checked and these two lines weren't the only ones, so I guess we
can add cleaning up whitespace of x86_64/tsc_scaling_sync.c to the rainy
day TODO.

Thanks,
drew

>                  case UCALL_DONE:
>  			goto out;
>  
>                  case UCALL_SYNC:
> -			printf("Guest %ld sync %lx %lx %ld\n", cpu, uc.args[2], uc.args[3], uc.args[2] - uc.args[3]);
> +			printf("Guest %d sync %lx %lx %ld\n", vcpu->id,
> +			       uc.args[2], uc.args[3], uc.args[2] - uc.args[3]);
>  			failures++;
>  			break;
>  
> -- 
> 2.36.1.255.ge46751e96f-goog
> 

