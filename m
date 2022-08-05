Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC7458B025
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240994AbiHETC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiHETCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:02:25 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3009B6581F
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:02:24 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 130so2971483pfv.13
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=HT+KR1/49fypZO9Kffg3Ya3DvCd4GLHV/qfcLH1yDI8=;
        b=mWCShU9Qgxa1GQdNZDZYOM0tHf8BtWzCxFEZC0/Pg2U1OEpBTL6mbFsTgDqO9vibT5
         4hq3azt3bX5i1yav66wTOJKvNkA7METTY3eiuMnvFsGcvr2dnyvDi+mAkZecd1PpbE+o
         IdEQs8d9PHhjL8MybZeLjUC/v8vO8eVR3mN4asHGHv4MRXyFIlzoCiD4R/V7+PDBWgF2
         rTrlwEtGWMzgR0Pbxk2ta0WA6Ibp6S3F0fAEIAVnf2Zc4VX+aeF/q64wmCNJOVW45Iel
         hq+MC2Acg8oDHzIbMuFL7eOMVHm2x7/reYkqUSWm7w1IJYOS1uW3+27x7G254PiphLjZ
         aGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=HT+KR1/49fypZO9Kffg3Ya3DvCd4GLHV/qfcLH1yDI8=;
        b=2rzvVcCi5k57uVt24cWrzwZvuWElabjVrFn/WNcv3jPK5skOqXE7Gt1w5LX+THXigz
         MGffpCYRkq5hhfTBkGAcZT9Fxb8UJt0TdDmvGL3cyxCmYDbaA34tWjgXrLYtuE4x75mW
         dg+lG2A3KbaHXvYuL2EgK01WQxp3Tud9jO9+5n095e188YkW3vLgdgkW4qhiu521IAWs
         zVbyDVbh01lxWt2tQ1CCaVZxmwSFTb0zgGKbvAhPKDtt8Uh2nE4r2zSPzyfNwdH8oLr/
         dhmCe9EebptPpAfFrvtqaDTny+UtOYZCVw1FMR3LbJREHUAMDAgBOCQ1DCDgX7CFmo1O
         E45g==
X-Gm-Message-State: ACgBeo1phqw2bfnxDCqYKSSnqemHyEo8/iw3e4FMBq9Qp0Cx2YFH4YU8
        6yOW1bFmn8BXC3wt2eJomWlU/g==
X-Google-Smtp-Source: AA6agR585p7qxjO/yYJb+WeMe4SBTrQVZR63y4dec0Y1hZakXSbTbr5TrbrDVsmwZ+/SiTT9m7OUYg==
X-Received: by 2002:a63:d94a:0:b0:412:6986:326e with SMTP id e10-20020a63d94a000000b004126986326emr6909073pgj.56.1659726143399;
        Fri, 05 Aug 2022 12:02:23 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b16-20020aa79510000000b0052dab7afa04sm3403358pfp.47.2022.08.05.12.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:02:23 -0700 (PDT)
Date:   Fri, 5 Aug 2022 19:02:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 6/6] KVM: Hoist debugfs_dentry init to
 kvm_create_vm_debugfs() (again)
Message-ID: <Yu1pO/ovmMBktzpN@google.com>
References: <20220720092259.3491733-1-oliver.upton@linux.dev>
 <20220720092259.3491733-7-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720092259.3491733-7-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022, Oliver Upton wrote:
> From: Oliver Upton <oupton@google.com>
> 
> Since KVM now sanely handles debugfs init/destroy w.r.t. the VM, it is
> safe to hoist kvm_create_vm_debugfs() back into kvm_create_vm(). The
> author of this commit remains bitter for having been burned by the old
> wreck in commit a44a4cc1c969 ("KVM: Don't create VM debugfs files
> outside of the VM directory").
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Heh, so this amusingly has my review, but I'd rather omit this patch and leave
the initialization with the pile of other code that initializes fields for which
zero-initialization is insufficient/incorrect.

Any objections to dropping this?

> ---
>  virt/kvm/kvm_main.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 609f49a133f8..7ac60f75cfa1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1032,6 +1032,12 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
>  	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
>  				      kvm_vcpu_stats_header.num_desc;
>  
> +	/*
> +	 * Force subsequent debugfs file creations to fail if the VM directory
> +	 * is not created.
> +	 */
> +	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
> +
>  	if (!debugfs_initialized())
>  		return 0;
>  
> @@ -1154,12 +1160,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>  
>  	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
>  
> -	/*
> -	 * Force subsequent debugfs file creations to fail if the VM directory
> -	 * is not created (by kvm_create_vm_debugfs()).
> -	 */
> -	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
> -
>  	snprintf(kvm->stats_id, sizeof(kvm->stats_id), "kvm-%d",
>  		 task_pid_nr(current));
>  
> -- 
> 2.37.0.170.g444d1eabd0-goog
> 
