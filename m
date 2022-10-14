Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F925FEFDD
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 16:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiJNOKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 10:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiJNOKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 10:10:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373333AB1C
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 07:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665756599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BrQ5y1JLetbsFHwRysDZJqLCG1uMk5W5RNBPwooSzyA=;
        b=NImyH9caeHY74hmw4RFUfiDwCudUgJqo97i/8EddqpVJ7G1Hs8UW5YfaGCN8Db6Ob3pa0Y
        hbyQ7zGEv6UMyuKX5OV6Og7YFRc5KcphT//YhKSKdtfesTQEoqDaHRbC53cYITerh2vBLI
        JCwxKzyLbWI5rxjhfV5S6G8nnBSvUTI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-41-gP9F1DoiOTq1jWionMrbog-1; Fri, 14 Oct 2022 10:09:58 -0400
X-MC-Unique: gP9F1DoiOTq1jWionMrbog-1
Received: by mail-qv1-f69.google.com with SMTP id i7-20020a0cab47000000b004b4376895bfso3564890qvb.20
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 07:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrQ5y1JLetbsFHwRysDZJqLCG1uMk5W5RNBPwooSzyA=;
        b=wwp+zC1IFsS+h2F4BkKtHYwxcWbugQTUiAlGa3nrQHZVXLPQ3fFHpvLrvVsBxEUGED
         R13eFq9mZbRDM/3F0gMAsCWMkZOhMsE3L1r9cLjcpbSc5vVpOf61vBRGG6uBgz7vtmh2
         zNQeaWTmNQ+ET4AkdSB/fi/lIgE3aRB1DPa+n7bDa3uccWbUWk9WlijvKbl+WvmVddsW
         a8k3nQYoaSGg7dx6cbqYDp5plqO6A7dAnSLAFVXG0yq25g3mx7wBQ3fhi2fz73/oLRIS
         pFy3r1NdpPtedZv7AYj6jojUrJuHMUo0RALLxXyLRYt23+hkcT2Dt9+B5IljLPqoFstt
         rq+Q==
X-Gm-Message-State: ACrzQf1taMlI4brGbA9CpkL7cE5JCGneviqR7XTeDei29YIsxYfLLh/f
        La1JZFCAHNwcOej0aT+DZqxd2g6VJ2Tv4iNKU/Pq7Q1FJkZvnmkPjLAijbQCM8UV1bthmT0ivdD
        3Zngyxr+r4+Zc
X-Received: by 2002:a05:620a:4310:b0:6ac:f9df:178d with SMTP id u16-20020a05620a431000b006acf9df178dmr3912611qko.773.1665756597734;
        Fri, 14 Oct 2022 07:09:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7uiPeiTnM1by4JoPLRKmkuCK9zPOvPq+0/hVb+9k0XqimWJFG7UGjmTWAJt4dbb4pP9Xz8yg==
X-Received: by 2002:a05:620a:4310:b0:6ac:f9df:178d with SMTP id u16-20020a05620a431000b006acf9df178dmr3912564qko.773.1665756597250;
        Fri, 14 Oct 2022 07:09:57 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id u6-20020a05620a430600b006e16dcf99c8sm2527098qko.71.2022.10.14.07.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 07:09:56 -0700 (PDT)
Date:   Fri, 14 Oct 2022 10:09:55 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Reduce refcount if single_open() fails in
 kvm_mmu_rmaps_stat_open()
Message-ID: <Y0lts0nU6fO7rrSK@x1n>
References: <a75900413bb8b1e556be690e9588a0f92e946a30.1665733883.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a75900413bb8b1e556be690e9588a0f92e946a30.1665733883.git.houwenlong.hwl@antgroup.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 03:55:11PM +0800, Hou Wenlong wrote:
> Refcount is increased before calling single_open() in
> kvm_mmu_rmaps_stat_open(), If single_open() fails, refcount should be
> restored, otherwise the vm couldn't be destroyed.
> 
> Fixes: 3bcd0662d66fd ("KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file")
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/debugfs.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> index cfed36aba2f7..412ed1b341fa 100644
> --- a/arch/x86/kvm/debugfs.c
> +++ b/arch/x86/kvm/debugfs.c
> @@ -162,7 +162,12 @@ static int kvm_mmu_rmaps_stat_open(struct inode *inode, struct file *file)
>  	if (!kvm_get_kvm_safe(kvm))
>  		return -ENOENT;
>  
> -	return single_open(file, kvm_mmu_rmaps_stat_show, kvm);
> +	if (single_open(file, kvm_mmu_rmaps_stat_show, kvm)) {
> +		kvm_put_kvm(kvm);
> +		return -ENOMEM;
> +	}

Thanks for fixing this.  Would it be nicer to wire the single_open retval
(even though it'll only fail with -ENOMEM with current code base)?

-- 
Peter Xu

