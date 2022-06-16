Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1B754E8C2
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 19:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiFPRq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 13:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiFPRqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 13:46:54 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252DC3D4BF
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 10:46:54 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id k7so1833184plg.7
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 10:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fT8Qe/1se5MIxsDXsCMXOWyhFjF0PUaqi+lyXewdZ9U=;
        b=Z2vqJyIHx4VUaVInZKwpIa4SqqMfsBYINdz0K5crvLskB3jvCQMsftiUhh9qnfoffs
         6o1rcJOJhdAquPI4nGX7clzaZSlvhBUdq1CyE7Au+9ytyzOx88LQ8iYTIvjQE7HXDfmy
         n3dYiQdVZanlP4SwVmlNDrPVhmIPcE3jpjcJx1/2N55A9GPNmoGoMnvCaEbwrAO92UAO
         RuacUOI63j78Ntx83bU6kk7nVUrM3vic021Mqkvho2xvc21iLaKXFYE7Ts9eKwOI6cRl
         vSr36O+75YgPXHxGHGgS0DxO1DUuCFY7ToS3IbZn1GzrOEwb+0yxBlpzq2vMZLJLy2N3
         gzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fT8Qe/1se5MIxsDXsCMXOWyhFjF0PUaqi+lyXewdZ9U=;
        b=V/55wuFRYvyyc9GzJjfyFWerWVrBK9YW8e8N7GZta49fPLWIas+k4izOnMgHCEGxXl
         48hOTc4tkUW0kiV2WnbbgGimGihqfoYBme8aZN0avf1SiauRd+sZ4VabQbuXPHvPTXbm
         bVB/t95ny2aK3vvGmK/fXTCfhhIpjxJb1cppnot/rb1UO+O/3xPSCP2ceCEkZ9p8Ghiw
         jkgjLqVpJE7W2KIJidVFXknW3zD5AfVyILA5SUUzkIhPUJrOJpGDq/0A7MJIXWI+NF7r
         /aYsZwQQuUoR1u0sQba7ChW8HE3yLAgwHhGYLwGfhPSaxRA++W/fMY/iYuqNu7LkqBIz
         ESjg==
X-Gm-Message-State: AJIora/w6RkNkcJibWdaoXD02d4BCyLx2teSTYe/YKp/Xdc+05PzHO3R
        /8xCWPp6fuH/vfjZyl2HxaO+Og==
X-Google-Smtp-Source: AGRyM1vJW90dKvuKmbfTG/3yItlYqn9Y3J9LlaKlq2PbhgfpZ3NISFzo2PT2a0SbOGiOYl5Kt5Ifmw==
X-Received: by 2002:a17:902:f687:b0:167:58bb:c43f with SMTP id l7-20020a170902f68700b0016758bbc43fmr5456701plg.136.1655401613425;
        Thu, 16 Jun 2022 10:46:53 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id 201-20020a6217d2000000b0050e006279bfsm2177587pfx.137.2022.06.16.10.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 10:46:52 -0700 (PDT)
Date:   Thu, 16 Jun 2022 17:46:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 1/5] KVM: Shove vm stats_id init into kvm_create_vm()
Message-ID: <YqtsiGOOHSxzbdir@google.com>
References: <20220518175811.2758661-1-oupton@google.com>
 <20220518175811.2758661-2-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518175811.2758661-2-oupton@google.com>
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

On Wed, May 18, 2022, Oliver Upton wrote:
> Initialize the field alongside the other struct kvm fields. No

Restate "stats_id" instead of "the field", it's literally fewer characters and
having to go read subject/shortlog to grok the change is annoying.  IMO, changelogs
should be 100% coherent without the shortlog.

Explaining why would also be helpful.  AFAICT there's no actual "need" for this
in this series, rather that this is futureproofing KVM since there's no reason
not to fill kvm->stats_id from time zero.

> functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  virt/kvm/kvm_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6d971fb1b08d..36dc9271d039 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1101,6 +1101,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	 */
>  	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
>  
> +	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
> +			"kvm-%d", task_pid_nr(current));
> +
>  	if (init_srcu_struct(&kvm->srcu))
>  		goto out_err_no_srcu;
>  	if (init_srcu_struct(&kvm->irq_srcu))
> @@ -4787,9 +4790,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
>  	if (r < 0)
>  		goto put_kvm;
>  
> -	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
> -			"kvm-%d", task_pid_nr(current));
> -
>  	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
>  	if (IS_ERR(file)) {
>  		put_unused_fd(r);
> -- 
> 2.36.1.124.g0e6072fb45-goog
> 
