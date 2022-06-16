Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74A654E8D7
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 19:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238239AbiFPRtK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 13:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238190AbiFPRtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 13:49:02 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418514D625
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 10:48:59 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s135so1876506pgs.10
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 10:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eyrQYf3qGX/bwiZJZi/KY4gBIl7LqIwQjm23sBtKPrI=;
        b=dLj4xMG8sH329cgAbMfX4tibz1/aNHpDlse/GHLUZfNcXPLPRGaNdSjtQGH6XLAtTn
         Ct0ZQKG3l37BsMUtZkPSDHNI3+2Vk3Ixly2mEUb0UpdFYPjqpeoVQGF8rGet48bT2R8e
         OR82CUXov9HZTHEV4200fNxbwUi78GqRgEPz3V4QHjGNOX5mazUDeefs2574lLOR2Emz
         mlG/b64g/oFI0vl0EzVJ3tsVWF+JQJmVjWZm7JNx42Uz5yFgqvx+RoAXmOneLrqE4qE8
         rdJM2RCXUkV5CJXRlk2Z3PWyhcfdjFWGm2x9C1BaSsdRb4/2JIsiey+tcfhJjxfvRlcF
         gdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eyrQYf3qGX/bwiZJZi/KY4gBIl7LqIwQjm23sBtKPrI=;
        b=vhsdLZhNgeKIyTuFcGGO3idyPUCkLTuJalNOZHeDmi3UnOhKo4vxJQHgH+9yo2dN8b
         zCH5tR4+jk+Ggx2aHLYWJ8wQsm+a5GlQAIKDGe96NCVgelABFZlnyuarZm/furHPq08y
         vKqbZMD3+rtsFb1kD0qKZUZPLeGC6+kgkwLvPmnJaNPrRzxr83MufFoK3QfmpLvIjtP4
         zh2JzS+JZd3ZJ8zoOsSqkeKciT6D0zVqSFGrHImvHlQ2ihi6Tb04rZqkpTSC46Pq+EIG
         b9amCsE+T58GXYGNVx5eDGdSQp90D78zO8NN5Z20TdLbVUuGSkZ7g10vPMZzMJnhvyZJ
         ZHXQ==
X-Gm-Message-State: AJIora+vPcq3zJpRCLXCco+xnCOA893+dZG/YLfqngg3DNh2c7JoRkkQ
        dbZm+xNyrlg1oaFi5c6KUEoOuw==
X-Google-Smtp-Source: AGRyM1tkw3+ELT9V5Q3czRrAJteD0bdQXUGqzn4c0pF68MYM1bzAZEGqbvy2QHXqYw0iPw+VpC07HQ==
X-Received: by 2002:a65:6499:0:b0:3fc:dcaa:ad62 with SMTP id e25-20020a656499000000b003fcdcaaad62mr5533019pgv.63.1655401739091;
        Thu, 16 Jun 2022 10:48:59 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id jh7-20020a170903328700b0015e8d4eb2a8sm1904414plb.242.2022.06.16.10.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 10:48:58 -0700 (PDT)
Date:   Thu, 16 Jun 2022 17:48:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 1/5] KVM: Shove vm stats_id init into kvm_create_vm()
Message-ID: <YqttBirNDDwHLR2V@google.com>
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

After looking at the next patch, can you opportunistically tweak this to (a) have
the string on the first line, and (b) align indentation?  I.e.

	snprintf(kvm->stats_id, sizeof(kvm->stats_id), "kvm-%d",
		 task_pid_nr(current));

That makes it a lot easier to see what the string will look like.
