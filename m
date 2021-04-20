Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F3236598A
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 15:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhDTNLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 09:11:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230408AbhDTNLR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 09:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618924246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+zx2XFbE8gJYftGDtRd3mjOOLbDR+Xz7bpzucbSm34A=;
        b=ToRRhDD+r646bgFZ9jp8+MrncnZ2QcJqCls0nlVDGGyJ0d5Eip4kB7Zi6lsfyfR/4UxHjB
        wLO73ah9WiSmlcNX9YZZDaKEyfZNnuyBuo0hI/cvmDtM4OOlRjJeSxYOG3hsW7MTWT2kpH
        XSO/t2JW9B61uugSZBF4f41D1hOTdlY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-2Bokw5EfPbulq9Rf5gPShw-1; Tue, 20 Apr 2021 09:10:44 -0400
X-MC-Unique: 2Bokw5EfPbulq9Rf5gPShw-1
Received: by mail-qv1-f71.google.com with SMTP id z14-20020a0cf24e0000b02901ab51b95ae7so1036867qvl.10
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 06:10:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+zx2XFbE8gJYftGDtRd3mjOOLbDR+Xz7bpzucbSm34A=;
        b=fmNA0i222g0GQgSGoFUOzkjw2XpAuEPyp0dPP+8TWn+EGPbUUk3o5Cn8z82w8NLdVX
         mLbahes91xlnRj1PWCr2B1RFf8B9veVSj2cSA8LEPgEib5utQH18dktq/fehR1IEYfTL
         MAHQpTVFznamwy56486u1xoRx49qV9QpSnu953OfT+eBLtYJvuZYTgz1FINpL5YkLHEy
         EJQZnz29UmCWDLyVzt06G2t/DYTePRUP3+qoYmR0Y/mPa4rReR+2lFi/vnZ1jXCyY5KF
         qFua7bkCF1exUJBNHZRh4dAXawM5hYJbW6Umx2tciCslqT7dVaTmd7jWZEYHM+oXgvwn
         CHOg==
X-Gm-Message-State: AOAM533WTWR3MOskP9kJinJZF53mZ3tzFSKKr19Ayy2y9rSXRbAFnepk
        B+7beIrXrMRwWftI6RHco+twtI/IVlNM3PuRy10puevoeTE0Q0NeBkHI/wJ4lQyMk1eN5HANVmR
        RDNR6SIIwi7yQ
X-Received: by 2002:a05:620a:24c6:: with SMTP id m6mr1867260qkn.11.1618924243926;
        Tue, 20 Apr 2021 06:10:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeZ3xms+6PUbLdDTIPvaRzwj3NltarpvZMNVXG53FHuHheOUZSJ4pKUFysVDt4A0p2PVsHWA==
X-Received: by 2002:a05:620a:24c6:: with SMTP id m6mr1867217qkn.11.1618924243608;
        Tue, 20 Apr 2021 06:10:43 -0700 (PDT)
Received: from xz-x1 (bras-base-toroon474qw-grc-88-174-93-75-154.dsl.bell.ca. [174.93.75.154])
        by smtp.gmail.com with ESMTPSA id d4sm163480qtp.23.2021.04.20.06.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 06:10:42 -0700 (PDT)
Date:   Tue, 20 Apr 2021 09:10:41 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 1/2] KVM: selftests: Sync data verify of dirty logging
 with guest sync
Message-ID: <20210420131041.GZ4440@xz-x1>
References: <20210417143602.215059-1-peterx@redhat.com>
 <20210417143602.215059-2-peterx@redhat.com>
 <20210418124351.GW4440@xz-x1>
 <60b0c96c-161d-676d-c30a-a7ffeccab417@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <60b0c96c-161d-676d-c30a-a7ffeccab417@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021 at 10:07:16AM +0200, Paolo Bonzini wrote:
> On 18/04/21 14:43, Peter Xu wrote:
> > ----8<-----
> > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > index 25230e799bc4..d3050d1c2cd0 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > @@ -377,7 +377,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
> >          /* A ucall-sync or ring-full event is allowed */
> >          if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
> >                  /* We should allow this to continue */
> > -               ;
> > +               vcpu_handle_sync_stop();
> >          } else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
> >                     (ret == -1 && err == EINTR)) {
> >                  /* Update the flag first before pause */
> > ----8<-----
> > 
> > That's my intention when I introduce vcpu_handle_sync_stop(), but forgot to
> > add...
> 
> And possibly even this (untested though):
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index ffa4e2791926..918954f01cef 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -383,6 +383,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
>  		/* Update the flag first before pause */
>  		WRITE_ONCE(dirty_ring_vcpu_ring_full,
>  			   run->exit_reason == KVM_EXIT_DIRTY_RING_FULL);
> +		atomic_set(&vcpu_sync_stop_requested, false);
>  		sem_post(&sem_vcpu_stop);
>  		pr_info("vcpu stops because %s...\n",
>  			dirty_ring_vcpu_ring_full ?
> @@ -804,8 +805,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		 * the flush of the last page, and since we handle the last
>  		 * page specially verification will succeed anyway.
>  		 */
> -		assert(host_log_mode == LOG_MODE_DIRTY_RING ||
> -		       atomic_read(&vcpu_sync_stop_requested) == false);
> +		assert(atomic_read(&vcpu_sync_stop_requested) == false);
>  		vm_dirty_log_verify(mode, bmap);
>  		sem_post(&sem_vcpu_cont);
> 
> You can submit all these as a separate patch.

But it could race, then?

        main thread                 vcpu thread
        -----------                 -----------
                                  ring full
                                    vcpu_sync_stop_requested=0
                                    sem_post(&sem_vcpu_stop)
     vcpu_sync_stop_requested=1
     sem_wait(&sem_vcpu_stop)
     assert(vcpu_sync_stop_requested==0)   <----

Thanks,

-- 
Peter Xu

