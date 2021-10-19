Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5761D433C04
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 18:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbhJSQZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 12:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhJSQZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 12:25:32 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43511C061746
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 09:23:19 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 75so19866891pga.3
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 09:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xPCNz7fYtKV1tSXpn8cPHZ9DQAOcY8mt7zL2GKr0oCg=;
        b=C4DR8PewB52Vu23rnXrvECk1DGFOOD6r7dOnucz7osENb97w7cNhiDolrALkjdopOB
         0bYD7vfw82zCtzwEOH6TREQq+G3zMDbX4eF5PQRGMKtMipwqO7XfEm/rZjqn4e4cgbuF
         VsRqhzLbJuHCKySpKUqczcpD4+L658R9BlFYb5wGdHslgDjctadlrDUHGdqe0qXQIQuh
         HnYDVA/yPlGQys9zmuFLSjiL9blPkJyhiPMOvPKztGp8W67O3VQ4rQYBAKyYPhn7kwn1
         r0H3BIHy6eQiQT6f0jCyXcKKdXl8CXsSlVupj2b+NqywYIM2ehTgqj6HJUPiK7XY2wQ7
         fRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xPCNz7fYtKV1tSXpn8cPHZ9DQAOcY8mt7zL2GKr0oCg=;
        b=2TERoAo6frJzE9WVZTMWN6Z1ntlAKsk+GV5V5GOb2vQrjonweoP142FJwfgxC9OzKP
         8V8jGXpwQ1/DyGaBToEF5ypTB+f8tC+14YnrBDSPXQrxWNozNGN5EYTeDvxieiVrKfqH
         CaaRva3zf9XHdoiaF8ggar75JGVsMD0qPnQ4e5IPslfubKInBV45xN0FPhbjJ5TVJrVe
         ZKAzqPBCy/l7GOkRHd33JBRWbnyHPK7AbMESmyk5tA5jiHjy/nXURV7K62L1YhmdXl2/
         0arCp+7HUxJARdb74Q50DUBS//AcN/KP0vYi0wWP3m/zkJUDYkHb+aQXEH7G4k2Ofx4n
         DgDQ==
X-Gm-Message-State: AOAM531/7p5GhTVVAyMhxgf2Z9mlNX44ek+9O4qt1mKLnWQuvPNCuMeg
        koQI3gn3i6fk7n/1x0ZigNBLYg==
X-Google-Smtp-Source: ABdhPJykIdd8Sw9FfoQxMGxe2V3LHwmo39heoQy8bV8XbZ4e14z419jzM9fWjy1Z1Y60sXm/mcuXAQ==
X-Received: by 2002:a05:6a00:1592:b0:44d:25e9:759e with SMTP id u18-20020a056a00159200b0044d25e9759emr724398pfk.19.1634660598457;
        Tue, 19 Oct 2021 09:23:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id bt5sm3160437pjb.9.2021.10.19.09.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 09:23:17 -0700 (PDT)
Date:   Tue, 19 Oct 2021 16:23:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Li Yu <liyu.yukiteru@bytedance.com>
Cc:     pbonzini@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Warn on nx_huge_pages for possible problems
Message-ID: <YW7w8g+65PjGs2wc@google.com>
References: <b2713829-1dad-de6b-5850-0c3a74e2f6f3@redhat.com>
 <20211019141101.327397-1-liyu.yukiteru@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019141101.327397-1-liyu.yukiteru@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021, Li Yu wrote:
> Add warning when `nx_huge_pages` is enabled by `auto` for hint that
> huge pages may be splited by kernel.
> 
> Add warning when CVE-2018-12207 may arise but `nx_huge_pages` is
> disabled for hint that malicious guest may cause a CPU lookup.

For the shortlog and changelog, "warning" is misleading.  A "warn" usually means
a WARN with a backtrace.  This is really just an information message that happens
to be displayed at level=warn, and that's an implementation detail.

> Signed-off-by: Li Yu <liyu.yukiteru@bytedance.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1a64ba5b9437..32026592e566 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6056,19 +6056,26 @@ static void __set_nx_huge_pages(bool val)
>  	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
>  }
>  
> +#define ITLB_MULTIHIT_NX_ON  "iTLB multi-hit CPU bug present and cpu mitigations enabled, huge pages may be splited by kernel for security. See CVE-2018-12207 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/multihit.html for details.\n"
                                                                                            ^                  ^^^^^^^
											    |- guest           split
> +#define ITLB_MULTIHIT_NX_OFF "iTLB multi-hit CPU bug present and cpu mitigations enabled, malicious guest may cause a CPU lookup. See CVE-2018-12207 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/multihit.html for details.\n"
                                                                                    ^^^^^^^
										    disabled

This is almost entirely redundant with the information that is displayed in
/sys/devices/system/cpu/vulnerabilities/itlb_multihit and
/sys/module/kvm/parameters/nx_huge_pages.  It also makes the below helper more
than a bit messy.

I kind of agree with Paolo's feedback that KVM should log a message if the bug
is present but the mitigation is off.  But if the admin explicitly turns off the
mitigation, logging the message every time KVM is loaded is obnoxious.  IMO, if
we want to display a message then we should do something similar to l1tf_mitigation
and give the admin the option to suppress any logging.

Personally, I don't see much value in a message of any kind.  Anyone that is
running untrusted guests should darn well do a lot of performance testing and
risk analysis before touching the knob.  And any use case that cares enough about
performance to explicitly turn off the mitigation should already know exactly how
KVM' params affect performance.

The L1D flushing messages are justified because a data leak is theoretically possible
when SMT is enabled even when the kernel's default mitigation is enabled.  That's not
the case here.

>  static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>  {
>  	bool old_val = nx_huge_pages;
>  	bool new_val;
>  
>  	/* In "auto" mode deploy workaround only if CPU has the bug. */
> -	if (sysfs_streq(val, "off"))
> +	if (sysfs_streq(val, "off")) {
>  		new_val = 0;
> -	else if (sysfs_streq(val, "force"))
> +		if (get_nx_auto_mode() && new_val != old_val)
> +			pr_warn(ITLB_MULTIHIT_NX_OFF);
> +	} else if (sysfs_streq(val, "force"))
>  		new_val = 1;
> -	else if (sysfs_streq(val, "auto"))
> +	else if (sysfs_streq(val, "auto")) {
>  		new_val = get_nx_auto_mode();
> -	else if (strtobool(val, &new_val) < 0)
> +		if (new_val && new_val != old_val)
> +			pr_warn(ITLB_MULTIHIT_NX_ON);
> +	} else if (strtobool(val, &new_val) < 0)

All branches need braces if any branch has braces.

>  		return -EINVAL;
>  
>  	__set_nx_huge_pages(new_val);
> @@ -6095,8 +6102,11 @@ int kvm_mmu_module_init(void)
>  {
>  	int ret = -ENOMEM;
>  
> -	if (nx_huge_pages == -1)
> +	if (nx_huge_pages == -1) {
>  		__set_nx_huge_pages(get_nx_auto_mode());
> +		if (is_nx_huge_page_enabled())
> +			pr_warn_once(ITLB_MULTIHIT_NX_ON);
> +	}
>  
>  	/*
>  	 * MMU roles use union aliasing which is, generally speaking, an
> -- 
> 2.11.0
> 
