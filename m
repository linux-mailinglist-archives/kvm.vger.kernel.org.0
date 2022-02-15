Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60374B7089
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 17:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241550AbiBOQ1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 11:27:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241544AbiBOQ1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 11:27:05 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B8F66F97
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 08:26:53 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso1117382pjs.1
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 08:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4AlrkeeOh0/Ufcc3UhsLjdJdRVpoM+riWwT9RuQlIRU=;
        b=d0pWAwFclxXSjZn3YA4K8V/CwPcWGI1yTN7bKBa+B683NUF8r5WKYsm+VGWk7Vqaez
         eTDpe4b4sWabolPl84kzQWLnIryk75cvpwhx2vHaq12wHPi7IgJ+ljgw5QChAU6b5KGs
         MUQQtkJ/4tjH/8foiyaxX4P+jQnNGaAQ0nH+3PY2H8gezxYZRMALMexDENJVdWb+uMVo
         c4aV+Hs0FpOVSU4MRhW+Rmo3C9OAtWlmSmAe/5zkGSHJNUI7lEIjhFjcy2ltYGPlx4Rz
         2UFm0jzGVjjjUg9G6lONM41KO33LGQH0Mh/CJNrLs7WjgctuadQu5dImAX0RerSwTTAY
         C2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4AlrkeeOh0/Ufcc3UhsLjdJdRVpoM+riWwT9RuQlIRU=;
        b=QX0WkbX/LJk3g8B9ueXfsk8kpWH0DGXxw1Z3uwWGPbDSEj3P8rj3YsRzbJ3usPaNmT
         f/pApRclZsyedlkvBr29XxLEFbGm5TBhDazCN32E4DbIChsXFJaBokXLxJE9ZqorZDYb
         7vTcM5OLJfAw5iIQG29rz9UjzEh9MKRl84b9nk1lRg39/vBepTbVaKadKNM+EwHV2BNQ
         XO++kZhr7fHhXnJnnGY8fC4EADcPJxhLtrvcSk1RMpUoDPYKfqcqv8Jm+NRfOIWGe2kI
         u7EDUL/geQPpczvN95SdvKzxx0I/QTtYo6l2an1WcFuVnnt9daLWW6qm8QiDcygjBGmL
         AgEQ==
X-Gm-Message-State: AOAM532TgViEtCjY1ScEsaROltaVcs8NVWMcTI5vbDmXaZ/xQg0D5Qh7
        aqoCsQ55mGNMcye/mgI7jJQgIQ==
X-Google-Smtp-Source: ABdhPJzwgO018qz0B77mszx1CmVsyurVkt4dBBqXVTV6Jfw1+PjyE7MG5D5NZVyMRs+57WNG/ZcL2w==
X-Received: by 2002:a17:902:ed89:: with SMTP id e9mr5235867plj.88.1644942412865;
        Tue, 15 Feb 2022 08:26:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g6sm20404223pfv.158.2022.02.15.08.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 08:26:52 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:26:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: Fix lockdep false negative during host resume
Message-ID: <YgvUSCjukIxvpDlf@google.com>
References: <1644920142-81249-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1644920142-81249-1-git-send-email-wanpengli@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 15, 2022, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> I saw the below splatting after the host suspended and resumed.
> 
>    WARNING: CPU: 0 PID: 2943 at kvm/arch/x86/kvm/../../../virt/kvm/kvm_main.c:5531 kvm_resume+0x2c/0x30 [kvm]
>    CPU: 0 PID: 2943 Comm: step_after_susp Tainted: G        W IOE     5.17.0-rc3+ #4
>    RIP: 0010:kvm_resume+0x2c/0x30 [kvm]
>    Call Trace:
>     <TASK>
>     syscore_resume+0x90/0x340
>     suspend_devices_and_enter+0xaee/0xe90
>     pm_suspend.cold+0x36b/0x3c2
>     state_store+0x82/0xf0
>     kernfs_fop_write_iter+0x1b6/0x260
>     new_sync_write+0x258/0x370
>     vfs_write+0x33f/0x510
>     ksys_write+0xc9/0x160
>     do_syscall_64+0x3b/0xc0
>     entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> lockdep_is_held() can return -1 when lockdep is disabled which triggers
> this warning. Let's use lockdep_assert_not_held() which can detect 
> incorrect calls while holding a lock and it also avoids false negatives
> when lockdep is disabled.
> 

Fixes: 2eb06c306a57 ("KVM: Fix spinlock taken warning during host resume")

> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 83c57bcc6eb6..3f861f33bfe0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5528,7 +5528,7 @@ static void kvm_resume(void)
>  {
>  	if (kvm_usage_count) {
>  #ifdef CONFIG_LOCKDEP

The #ifdef can be dropped, it was added only to omit the WARN_ON.

With that,

Reviewed-by: Sean Christopherson <seanjc@google.com>

> -		WARN_ON(lockdep_is_held(&kvm_count_lock));
> +		lockdep_assert_not_held(&kvm_count_lock);
>  #endif
>  		hardware_enable_nolock(NULL);
>  	}
> -- 
> 2.25.1
> 
