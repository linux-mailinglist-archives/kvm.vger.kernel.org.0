Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902D060537B
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 00:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJSWyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 18:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiJSWyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 18:54:02 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DC31C19E7
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:53:41 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g8-20020a17090a128800b0020c79f987ceso1555692pja.5
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ccMna22QiTRl0kiep9mD3Zwjtq2oWNnQ6Qiv8MzFFE=;
        b=YyEfcIVUwXaYT7lhpRxnr30ps3Eo4TUjF9Yfs3LTA1JQWYUG0QtFWdTJfGrhbbTi2g
         E98Hlt+oabpZSeojhMgSVcdPiFWy3HkXSCfDDo2wN9Rx/j+sZMT0DnBnoxtVGtNuj8Cy
         E3Uc6eav3jmWzcTo3FQc9XW6+WEApu4RqVyl4CecAdWW7PmlyoDfny4WK01gPyifOEA0
         sWWLGgyIzN7+26num2zy7ZowzfiBd5vOqCAD983I7ho1s1P4ypDa9rynCR7zx/8WI6Yt
         S2ndM4V+aFwBUVw5eR8ZSuwpikxl0p1EuGUtB921nx+q2aV2xzDTHFMhZvUEXR2ZXlqt
         7BuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ccMna22QiTRl0kiep9mD3Zwjtq2oWNnQ6Qiv8MzFFE=;
        b=ZfUzNsMk4rqyZJJ6usmBboixIn7PqTr5Hmuq2M7RVZdaMfjEJrK7OkL8tMH7hd4K3s
         1n9HkDExVWTL0EGLZmArMoDKcgwNoypWd2a6Ww6dz+iwzB3MC0Vy6XHT1JFFp+fY6+R4
         6TpFpEht8acclA2oDfJn+xR+nKtzyskMLBsxbfz3RDi+rqAURVfMbtA4asyPGINahR8a
         QbxKMPrBKTq6TpWb+acmmac/BSJYEilsnkrTndSlDAByrFVRz1EkZ8zy1aoF2NRgvIYs
         ZXKHZrkaZ1aVopmh/oLh3VfXZqP/hbNXvMCGQ2vcHKC96X9XhK8SkZjfBEmBdYNKZJ1q
         IaOg==
X-Gm-Message-State: ACrzQf1RKcnnANn0bzL6UT0PcxHIinXOhori0jephgDnkZCf5EsrUYp1
        yA+6wa80z/1IhUUnp7Qons9kXQ==
X-Google-Smtp-Source: AMsMyM70HhlwJuhwpMRX/Y76BagPTr8X6o0TC3bYCQvT5054ppmeDaZmC3m3yFa2+9oSp1n7W6u2Sg==
X-Received: by 2002:a17:903:2286:b0:185:3948:be93 with SMTP id b6-20020a170903228600b001853948be93mr10889924plh.121.1666220018554;
        Wed, 19 Oct 2022 15:53:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902eb8800b00176a2d23d1asm11160952plg.56.2022.10.19.15.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 15:53:38 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:53:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 5/6] KVM: x86: Mask off reserved bits in CPUID.8000001EH
Message-ID: <Y1B/7r4rBd0xHCvu@google.com>
References: <20220929225203.2234702-1-jmattson@google.com>
 <20220929225203.2234702-5-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929225203.2234702-5-jmattson@google.com>
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

On Thu, Sep 29, 2022, Jim Mattson wrote:
> KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
> actually supports. The following ranges of CPUID.8000001EH are reserved
> and should be masked off:
>     EBX[31:16]
>     ECX[31:11]

LOL, APM is buggy, it says all bits in ECX are reserved.

  31:0  -                Reserved.
  10:8 NodesPerProcessor
  7:0  NodeId

Advertising NodeId seems all kinds of wrong :-(

>     EDX[31:0]
> 
> Fixes: 382409b4c43e ("kvm: x86: Include CPUID leaf 0x8000001e in kvm's supported CPUID")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5d1ec390aa45..576cbcf489ce 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1179,6 +1179,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->ebx = entry->ecx = entry->edx = 0;
>  		break;
>  	case 0x8000001e:
> +		entry->ebx &= ~GENMASK(31, 16);
> +		entry->ecx &= ~GENMASK(31, 11);
> +		entry->edx = 0;
>  		break;
>  	case 0x8000001F:
>  		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
> -- 
> 2.38.0.rc1.362.ged0d419d3c-goog
> 
