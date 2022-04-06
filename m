Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE684F6A9D
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 21:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbiDFT47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 15:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbiDFT4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 15:56:45 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2F62C11F
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 11:06:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ku13-20020a17090b218d00b001ca8fcd3adeso6541952pjb.2
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 11:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nb6RuM1kQ3N1+wdD8MtdIAi3hVbOL3jme3zHG3d+zzY=;
        b=Ax6btunV2GWM4qIC58kjn0rOZMU0+pEvioaMXdzKDhztkpzYIts0+adz+4TnJxKQrw
         B3Z13q0QBt5g72zhD8eLKLqP9t1441t45A43Omp6GxCvRozvemOP9KEp5iE1sin1E0Kl
         nehGTE1u2frFU+WfuL76n39et0FIdEIgB+uKiFF6DyiToiJLomGLW5GymGvM0M5VwSNK
         cnVLLK+MYIoIru53z4eWJWVENC8kf1NVILOINWENWlr+TAkWaEtELVNugNKSjevRnCkB
         EXu2Auy/ESyZq6ObI/+GXnjFScqup43IOVrXxnuAz0SpOGGIXKDgBKUTVKSu3Od+qmMj
         HVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nb6RuM1kQ3N1+wdD8MtdIAi3hVbOL3jme3zHG3d+zzY=;
        b=zXbqUMohpopoaDxUlKdFpJqWxGfENV1KrKsSiWzFMD0fR3Hle+beOEdgWHXaCLoI5+
         Rd8YsRUBxqU2BGsMlvZnk+2gXEkia+slv6v2XdkslseFfULL21jz5AN5gKdur7PTrC3T
         mLnVrFcn9XfsG40/FVX2n1JJ9GKf3Baua14fXqX0OFv3Q9MAuFSqkSpNReZ2s+Jts8do
         jzvocTQ6y/HhJIabmA49TTOtdivqIhup/7Hkwu4kdy1ubOJN3QqLM9ZPOaJ83nGsWZS4
         ZiTB4Q4VwLEt9OE4CSMTnAgYWNBqZaxo8zncWe2WbrnJI+a3UYXG0OYdCAHaShBTXPFg
         ChPA==
X-Gm-Message-State: AOAM531x+qoqiKWjLt8ycsIrcHFRGr8he0wsIFHst/gVlmNbPiQxsM0H
        oUrv0tM/EgqB8SXC4uBR9NgbVQ==
X-Google-Smtp-Source: ABdhPJw0p+5J2gneCfqDwqAFCfqGhiieEpDsPCxk4p4DRvY8VKYeyeofjFLycg52d+QW1heqPFrqZA==
X-Received: by 2002:a17:90a:e2c3:b0:1ca:75b7:63d5 with SMTP id fr3-20020a17090ae2c300b001ca75b763d5mr11183941pjb.111.1649268359396;
        Wed, 06 Apr 2022 11:05:59 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a11-20020a056a000c8b00b004fade889fb3sm21115809pfv.18.2022.04.06.11.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 11:05:58 -0700 (PDT)
Date:   Wed, 6 Apr 2022 18:05:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, John Sperbeck <jsperbeck@google.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: SEV: Mark nested locking of vcpu->mutex
Message-ID: <Yk3Wg3eZsGZKb3Wm@google.com>
References: <20220405174637.2074319-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405174637.2074319-1-pgonda@google.com>
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

On Tue, Apr 05, 2022, Peter Gonda wrote:
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75fa6dd268f0..673e1ee2cfc9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1591,14 +1591,21 @@ static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
>  	atomic_set_release(&src_sev->migration_in_progress, 0);
>  }
>  
> +#define SEV_MIGRATION_SOURCE 0
> +#define SEV_MIGRATION_TARGET 1
>  
> -static int sev_lock_vcpus_for_migration(struct kvm *kvm)
> +/*
> + * To avoid lockdep warnings callers should pass @vm argument with either

I think it's important to call that these are false positives, saying "avoid
lockdep warnings" suggests we're intentionally not fixing bugs :-)

> + * SEV_MIGRATION_SOURCE or SEV_MIGRATE_TARGET. This allows subclassing of all
> + * vCPU mutex locks.
> + */

If we use an enum, that'll make the param self-documenting.  And we can also use
that to eliminate the remaining magic number '2'.  E.g. this as fixup.

---
 arch/x86/kvm/svm/sev.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 673e1ee2cfc9..1e07d5d3f85a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1591,21 +1591,27 @@ static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 	atomic_set_release(&src_sev->migration_in_progress, 0);
 }

-#define SEV_MIGRATION_SOURCE 0
-#define SEV_MIGRATION_TARGET 1

 /*
- * To avoid lockdep warnings callers should pass @vm argument with either
- * SEV_MIGRATION_SOURCE or SEV_MIGRATE_TARGET. This allows subclassing of all
- * vCPU mutex locks.
+ * To suppress lockdep false positives, subclass all vCPU mutex locks by
+ * assigning even numbers to the source vCPUs and odd numbers to destination
+ * vCPUs based on the vCPU's index.
  */
-static int sev_lock_vcpus_for_migration(struct kvm *kvm, int vm)
+enum sev_migration_role {
+	SEV_MIGRATION_SOURCE = 0,
+	SEV_MIGRATION_TARGET,
+	SEV_NR_MIGRATION_ROLES,
+};
+
+static int sev_lock_vcpus_for_migration(struct kvm *kvm,
+					enum sev_migration_role role)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i, j;

 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (mutex_lock_killable_nested(&vcpu->mutex, i * 2 + vm))
+		if (mutex_lock_killable_nested(&vcpu->mutex,
+					       i * SEV_NR_MIGRATION_ROLES + role))
 			goto out_unlock;
 	}


base-commit: 6600ddafa53b35fd5c869aff4a5efb981ed06955
--

