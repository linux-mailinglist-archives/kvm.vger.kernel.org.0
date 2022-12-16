Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FED64EF3D
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiLPQe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiLPQe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:34:56 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A1EE2D
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:34:55 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id t17so3000449pjo.3
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DaN+b2cOC3LbMhY1LUaQCaKn6ix8xCEgPdvcQ89ES2o=;
        b=KLePxd5ddrrB3BabRqKt1pwOAABnJkMBXauuEDa6M3B5+vRvQc/zmwesDHHeJbZDHI
         9gFh379DRMr8GFOTsydMEI60RWjxDMZ4ydIhaHIpQ4XWtthTsFsSrERnNuX36HngVuF+
         g7qjBUJmGZ6cy25e4VqLRZ3cTtnECf8vS1jRoQN7zbGkvYLF9BAWylI0kD1O2vVaYbo5
         BiBVCkgMQLmL3LadZu/3yGbCe+g9yttxAbAF3eZQFs64nj3YITSnA10KMX/KDAOuFBmO
         wpsPNpXJkikii1zQvBkoXwhcKavYidmjKUl+bQ0p/JlAfwrUVU1ofqDtM4N0mmEigvCp
         GyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DaN+b2cOC3LbMhY1LUaQCaKn6ix8xCEgPdvcQ89ES2o=;
        b=eO0neWHcjgkE3/WVwrIeM9Cy8HM9cEMHU0XjWxBRluY/u3OZqdGCj6W4RcYXPp4mjW
         fh3asTD16ouCg8NfCZiP9pLnZB3xvxog+bVgrlGu8CQGSTdPvO9rny9a4wfgrx3GdifL
         2WjjmbTXqDce8cPo0/uel4RYtwuzy7ISs+OnLzAPMJecRkLI8v+6CfiBqpfoUxWlGq8B
         kCk8S+jli0xf3QzwmSaWA1hiDJAtLZVTRA1RJ3InYrAZyE+cIJRje/qouwaqUfwmm8PL
         agBruypxNxahTDKbae9oK1ZOUJ9SPUK2wTLb2DcD9XJcF5da50zoncqywveLYvXckj0/
         EUpA==
X-Gm-Message-State: AFqh2kqhrzF6uSvYGmH4MZjG8uncmtvzLqnWwliTvPx6jY41+le42IUS
        KXTeRmL1LLBuUkW4wgxw5rIqEku/pfM0GLE0
X-Google-Smtp-Source: AMrXdXvIPWWHwqJEiDp0RmqVrjPtDLmehyEJGVbZ0e+qr5uFEvMXkCr+wO5HU2diEY/WBsRt7r5mWg==
X-Received: by 2002:a17:90a:e28d:b0:218:84a0:65eb with SMTP id d13-20020a17090ae28d00b0021884a065ebmr486899pjz.1.1671208495379;
        Fri, 16 Dec 2022 08:34:55 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mm7-20020a17090b358700b002191e769546sm1603599pjb.4.2022.12.16.08.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:34:54 -0800 (PST)
Date:   Fri, 16 Dec 2022 16:34:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, dwmw2@infradead.org,
        paul@xen.org
Subject: Re: [PATCH v4 1/2] KVM: MMU: Introduce 'INVALID_GFN' and use it for
 GFN values
Message-ID: <Y5yeKucYYfYOMXqp@google.com>
References: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
 <20221216085928.1671901-2-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216085928.1671901-2-yu.c.zhang@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 16, 2022, Yu Zhang wrote:
> Currently, KVM xen and its shared info selftest code uses
> 'GPA_INVALID' for GFN values, but actually it is more accurate
> to use the name 'INVALID_GFN'. So just add a new definition
> and use it.
> 
> No functional changes intended.
> 
> Suggested-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/xen.c                                   | 4 ++--
>  include/linux/kvm_types.h                            | 1 +
>  tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 4 ++--
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index d7af40240248..6908a74ab303 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -41,7 +41,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
>  	int ret = 0;
>  	int idx = srcu_read_lock(&kvm->srcu);
>  
> -	if (gfn == GPA_INVALID) {
> +	if (gfn == INVALID_GFN) {

Grrr!  This magic value is ABI, as "gfn == -1" yields different behavior than a
random, garbage gfn.
                                                                                
So, sadly, we can't simply introduce INVALID_GFN here, and instead need to do
something like:

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 20522d4ba1e0..2d31caaf812c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1766,6 +1766,7 @@ struct kvm_xen_hvm_attr {
                __u8 vector;
                __u8 runstate_update_flag;
                struct {
+#define KVM_XEN_INVALID_GFN    (~0ull)
                        __u64 gfn;
                } shared_info;
                struct {

>  		kvm_gpc_deactivate(gpc);
>  		goto out;
>  	}
