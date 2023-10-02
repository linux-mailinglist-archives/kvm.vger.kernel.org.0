Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED6F7B5AC8
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 21:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238511AbjJBTBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 15:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjJBTBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 15:01:17 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D392BC6
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 12:01:13 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59b5a586da6so336137b3.1
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 12:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696273273; x=1696878073; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ckwzzbSxH95zbV9Ph3aAP9Fp5FbPi93+Tiiv+0bzk7M=;
        b=dWkherERAXJwUbcB4LVAVI1asYxXGO6aXixpYhOyv9kIuSGUTcEjwh4BLaWTgxTXzG
         7K75V63eR7A9o2tbKD9nu3ZUi6DCeuqdVU46vGgMHiVcsE7jyOrIIRC2Dd45vyIhwQD8
         52XgV67+fPs2zds8XPK82H1yn3qWhe2Spt9tYu3s8ojXckAEtHGQ8zuIDyJ9UmRPpnUm
         nO1+y0hjz5Cn/WLMQiq9x+AFz0CHu1mcIKMPgkAo1L4Toou4V5CTnOJLtm7xJJgG1keC
         xT/3VtMtPu+S9SeTzmV3HEeYnN+D3NvCIS6yYJtY6Isn/07bXyW3PiKNOzTBvWTNemd7
         hNsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696273273; x=1696878073;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ckwzzbSxH95zbV9Ph3aAP9Fp5FbPi93+Tiiv+0bzk7M=;
        b=sm/iO8PlukUrrFgLeB0Jm88w1sQNXUp46skReOSbFxB9HpEAqo0ZNPhzbsDKdKQjKc
         9GENdgRK6egEivzVNya35sXv8+QSQBrHjyqUTQ1YqcBTNaudzcddhZDDQDKKwbHLv4uO
         VmSAbEW1PygT922AgmYK2K+7uDgX8E5Q5MJmzuBDRgG9Z5R4qsYN2zZEFHe+Hdk4MqtY
         d6G46b84W7Iq141OKH/zyuAjyU1ip0I4P9hCqQaI8eV76I/RuJts4ujQksyPsNSVUAA8
         mTAClswTrm+x1HK+RyoAOYpsL3CQv1zTOtzrDh3ScX23mXiKrM0Qe9ZpnQ0pwL2qvsoS
         FZZw==
X-Gm-Message-State: AOJu0Yzz+NId64MGuSgVahDQfFCtQN++ZfiZGC2Egke4wAskrvykuggj
        QHqIE+SZ4Q4S8ycEBOi6QLxveA5Jg1s=
X-Google-Smtp-Source: AGHT+IFYEOOv4UwLqviXbR+k+OW+wIzCw/xJ4qlPUj28o767UlOg6AdRosVhdf5F+RckQFM18g4YOtNNMdw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac07:0:b0:59b:eb4b:2cad with SMTP id
 k7-20020a81ac07000000b0059beb4b2cadmr9775ywh.5.1696273272964; Mon, 02 Oct
 2023 12:01:12 -0700 (PDT)
Date:   Mon, 2 Oct 2023 12:01:11 -0700
In-Reply-To: <0da9874b6e9fcbaaa5edeb345d7e2a7c859fc818.1696271334.git.thomas.lendacky@amd.com>
Mime-Version: 1.0
References: <0da9874b6e9fcbaaa5edeb345d7e2a7c859fc818.1696271334.git.thomas.lendacky@amd.com>
Message-ID: <ZRsTd9FEIvgERrte@google.com>
Subject: Re: [PATCH] KVM: SVM: Fix build error when using -Werror=unused-but-set-variable
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023, Tom Lendacky wrote:
> Commit 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support for
> virtualized TSC_AUX") introduced a local variable used for the rdmsr()
> function for the high 32-bits of the MSR value. This variable is not used
> after being set and triggers a warning or error, when treating warnings
> as errors, when the unused-but-set-variable flag is set. Mark this
> variable as __maybe_unused to fix this.
> 
> Fixes: 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9507df93f410..4c917c74a4d3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -691,7 +691,7 @@ static int svm_hardware_enable(void)
>  	 */
>  	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
>  		struct sev_es_save_area *hostsa;
> -		u32 msr_hi;
> +		u32 __maybe_unused msr_hi;

Argh, the abomination that is rdmsrl() strikes again :-/  We really should be able
to do:

		hostsa->tsc_aux = (u32)rdmsrl(MSR_TSC_AUX);

I don't see a better quick fix than __maybe_unused though.

Reviewed-by: Sean Christopherson <seanjc@google.com>
