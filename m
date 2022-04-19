Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCEA506634
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 09:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243286AbiDSHtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349553AbiDSHtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:49:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBACC2E0BD
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 00:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650354387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gn/QQHDd1WMkLVfZyI1nYZ7LAtHIpd/JrDkDW5rnOy4=;
        b=bzgSur5HGMuN+cIPfmRq7z5l0a2+VKnYv0TXbHd1KsDewsJS/otGhiEBqfpkIAUIRdK0Yi
        od/hC1LtCAWDQHt30KIX+2cZT3yzsrlE6IthRgvo2/Ly6s5FiFPZOrdn6ooPe0WDfl05Cf
        +CUmioJe2EQtX37lKC3Z6Wi+gqnYm9Y=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-7JpbGNh8NKe581yLITr2nQ-1; Tue, 19 Apr 2022 03:46:25 -0400
X-MC-Unique: 7JpbGNh8NKe581yLITr2nQ-1
Received: by mail-ej1-f70.google.com with SMTP id qa31-20020a170907869f00b006ef7a20fdc6so2079995ejc.5
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 00:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Gn/QQHDd1WMkLVfZyI1nYZ7LAtHIpd/JrDkDW5rnOy4=;
        b=M0O93zSc3yuyh6kkfvOQdEPPKSY5lkK/QwrmE8KNPQE3ATOqaZAjUhVCrWaRx1ifHX
         ubbxjZ7d7GoUC328UCr4oej3fHduQixuKQ8HNi4Dn6elS2W1FGPgncBIVJWPfetT9RnD
         QzPMsPuHbMblLp/yGZzi2I75HIPXUF1+ERrDOGTMItIn1gJtV3VQZWYsOufoJ1ILjzYX
         +hqs3O5qQh/86hXPNp5AWN6QzZyjEXlNNW13llDqr0UnbkVBvlioruaPLda6Nr3YGpi/
         SbvPTxhI9dqvpRCaqOHajib0AcixtvKK9X+TKcUPBq+D2oQUV12yL03y9H6Var7jSqWz
         jB9A==
X-Gm-Message-State: AOAM533ebbjYs2CUHZDVfVUiNJJjeeLdgFes1Q3zq2fblI/ccrVP6G/O
        2tyRgDJfuPyJK2tJRLpvSPefoh47bxYq0++ak/Dmt32v1X8DsYxml/qjAtnF4BUZtJTrB2uO1sh
        NpENsqhieWxC+
X-Received: by 2002:a17:907:d90:b0:6eb:557e:91e6 with SMTP id go16-20020a1709070d9000b006eb557e91e6mr12138593ejc.376.1650354384408;
        Tue, 19 Apr 2022 00:46:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLnRfOzlVdWfc2WzaZG+0vGSVJigsAqJVIie4FNXYj3x7jHKUoImfSoKneidyOusSzH594sA==
X-Received: by 2002:a17:907:d90:b0:6eb:557e:91e6 with SMTP id go16-20020a1709070d9000b006eb557e91e6mr12138578ejc.376.1650354384200;
        Tue, 19 Apr 2022 00:46:24 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p17-20020a17090635d100b006efcc06218dsm1204686ejb.18.2022.04.19.00.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 00:46:23 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Anton Romanov <romanton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
In-Reply-To: <Ylh3HNlcJd8+P+em@google.com>
References: <20220414183127.4080873-1-romanton@google.com>
 <Ylh3HNlcJd8+P+em@google.com>
Date:   Tue, 19 Apr 2022 09:46:23 +0200
Message-ID: <877d7l5xdc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> +Vitaly
>
> On Thu, Apr 14, 2022, Anton Romanov wrote:

...

>> @@ -8646,9 +8659,12 @@ static void tsc_khz_changed(void *data)
>>  	struct cpufreq_freqs *freq = data;
>>  	unsigned long khz = 0;
>>  
>> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
>> +		return;
>
> Vitaly,
>
> The Hyper-V guest code also sets cpu_tsc_khz, should we WARN if that notifier is
> invoked and Hyper-V told us there's a constant TSC?
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ab336f7c82e4..ca8e20f5ffc0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8701,6 +8701,8 @@ static void kvm_hyperv_tsc_notifier(void)
>         struct kvm *kvm;
>         int cpu;
>
> +       WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_CONSTANT_TSC));
> +
>         mutex_lock(&kvm_lock);
>         list_for_each_entry(kvm, &vm_list, vm_list)
>                 kvm_make_mclock_inprogress_request(kvm);
>

(apologies for the delayed reply)

No, I think Hyper-V's "Reenlightenment" feature overrides (re-defines?)
X86_FEATURE_CONSTANT_TSC. E.g. I've checked a VM on E5-2667 v4
(Broadwell) CPU with no TSC scaling. This VM has 'constant_tsc' and will
certainly get reenlightenment irq on migration.

Note, Hyper-V has its own 'Invariant TSC control', see commit
dce7cd62754b5 ("x86/hyperv: Allow guests to enable InvariantTSC"). When
enabled, X86_FEATURE_TSC_RELIABLE is forced. I *think* (haven't checked
as I don't have two suitable hosts to test migration handy) this will
suppress reenlightenment so the check should be

       WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_TSC_RELIABLE));

instead. There is a chance that reenlightenment notifications still
arrive but the reported 'new' TSC frequency remains unchanged (silly,
but possible), I'll need to check.

-- 
Vitaly

