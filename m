Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B7F4F1BB5
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381005AbiDDVWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380581AbiDDUhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 16:37:11 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB88F25EB8
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 13:35:14 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 66so1776474pga.12
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 13:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o6Jps2kjgfU371gs4sTPnWDwSSEcT5HsdO32Ve4rCA0=;
        b=byVdCGvSfTN+YF9id0vNf0etolMj+qC4TWGVuif01wYvsnFC5p7Eu60+KIbGKtf23I
         L1qp2tXp3H1qKh8ID/YgvO4Ybb1z7p3HWhN/kQORzGDYtqImGFuN05iPemY1YyLo4EzI
         3ishUmMXZXenx+gdi8i6jAO6QIsdYFre3qQfqv3c3d4NhyYCjDwI/rNOFfiGfolSeoJP
         JoUrVPOPl/asUmrsT3wtoKAXy+HrlTccZUOmda/dERxQSHdN9IX5cmNpAB5G7kpgZMEj
         5AYpDcqrlhuTWK3zQUnxcB8C3vaEQWMzOovPhBnMh0pIKDJOBuMdUWGM19ni3OsuEgaN
         T+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o6Jps2kjgfU371gs4sTPnWDwSSEcT5HsdO32Ve4rCA0=;
        b=6EVGhA6K1SRYSH4+THC+Kv+87icSmpHcAZiHN4/55SkKyTxXqdueF44FEg5295vyrB
         NMHUNa3KN7Bjm0kwIyo33ny758tGaeykFDIIEkZ2IV910a9UuYMZMSH+wK3NMMhkhC8A
         j5fg63aHf6xz1/E06JO4eCYAy8Oxw6mhK4DhoQY1rgSvUsO/fkKo8EioSM9s3lei3cFk
         HSW0fWWvFLK/TC79eFGHh5Fo5ZoIUO4ZIxS9QLK02ecMRJjlz9lTSPWOw6J3vy2/GKOe
         CtbUew2WOtt9W1LdIuh7N315axXRDiquP/AUfyUlUw44AWJPrhc0ZogpKOdoV2TsZDni
         ltVQ==
X-Gm-Message-State: AOAM531V9D9+ZhM7G7a5I3+SOypF53wm0+9yOYUg/yMsrJbYx3zOP9Hk
        VyLvDRwqNBCOt7zSMZfYQ/WwdA==
X-Google-Smtp-Source: ABdhPJxf1tcimAHxmnX+3KpJwnG6PzgI/KP+QN+oSek+zwRxiAZ+7SLg4i1DQoAnErmOfKEUozNR9w==
X-Received: by 2002:a63:3e47:0:b0:382:366:64ea with SMTP id l68-20020a633e47000000b00382036664eamr1365270pga.210.1649104513958;
        Mon, 04 Apr 2022 13:35:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s26-20020a62e71a000000b004fde8486500sm7989821pfh.126.2022.04.04.13.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 13:35:12 -0700 (PDT)
Date:   Mon, 4 Apr 2022 20:35:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, John Sperbeck <jsperbeck@google.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SEV: Mark nested locking of vcpu->lock
Message-ID: <YktWfUbjz27OdbUA@google.com>
References: <20220404194605.1569855-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404194605.1569855-1-pgonda@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 04, 2022, Peter Gonda wrote:
> svm_vm_migrate_from() uses sev_lock_vcpus_for_migration() to lock all
> source and target vcpu->locks. Mark the nested subclasses to avoid false
> positives from lockdep.
> 
> Fixes: b56639318bb2b ("KVM: SEV: Add support for SEV intra host migration")
> Reported-by: John Sperbeck<jsperbeck@google.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> 
> Tested by running sev_migrate_tests with lockdep enabled. Before we see
> a warning from sev_lock_vcpus_for_migration(). After we get no warnings.
> 
> ---
>  arch/x86/kvm/svm/sev.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75fa6dd268f0..8f77421c1c4b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1591,15 +1591,16 @@ static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
>  	atomic_set_release(&src_sev->migration_in_progress, 0);
>  }
>  
> -
> -static int sev_lock_vcpus_for_migration(struct kvm *kvm)
> +static int sev_lock_vcpus_for_migration(struct kvm *kvm, unsigned int *subclass)
>  {
>  	struct kvm_vcpu *vcpu;
>  	unsigned long i, j;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (mutex_lock_killable(&vcpu->mutex))
> +		if (mutex_lock_killable_nested(&vcpu->mutex, *subclass))
>  			goto out_unlock;
> +
> +		++(*subclass);

This is rather gross, and I'm guessing it adds extra work for the non-lockdep
case, assuming the compiler isn't so clever that it can figure out that the result
is never used.  Not that this is a hot path...

Does each lock actually need a separate subclass?  If so, why don't the other
paths that lock all vCPUs complain?

If differentiating the two VMs is sufficient, then we can pass in SINGLE_DEPTH_NESTING
for the second round of locks.  If a per-vCPU subclass is required, we can use the
vCPU index and assign evens to one and odds to the other, e.g. this should work and
compiles to a nop when LOCKDEP is disabled (compile tested only).  It's still gross,
but we could pretty it up, e.g. add defines for the 0/1 param.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75fa6dd268f0..9be35902b809 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1591,14 +1591,13 @@ static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
        atomic_set_release(&src_sev->migration_in_progress, 0);
 }

-
-static int sev_lock_vcpus_for_migration(struct kvm *kvm)
+static int sev_lock_vcpus_for_migration(struct kvm *kvm, int mod)
 {
        struct kvm_vcpu *vcpu;
        unsigned long i, j;

        kvm_for_each_vcpu(i, vcpu, kvm) {
-               if (mutex_lock_killable(&vcpu->mutex))
+               if (mutex_lock_killable_nested(&vcpu->mutex, i * 2 + mod))
                        goto out_unlock;
        }

@@ -1745,10 +1744,10 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
                charged = true;
        }

-       ret = sev_lock_vcpus_for_migration(kvm);
+       ret = sev_lock_vcpus_for_migration(kvm, 0);
        if (ret)
                goto out_dst_cgroup;
-       ret = sev_lock_vcpus_for_migration(source_kvm);
+       ret = sev_lock_vcpus_for_migration(source_kvm, 1);
        if (ret)
                goto out_dst_vcpu;


