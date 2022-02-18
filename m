Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97A64BC31D
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 00:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240263AbiBRX7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 18:59:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240256AbiBRX73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 18:59:29 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A1C1D5F41
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 15:59:10 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id p8so3570557pfh.8
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 15:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BnFj/P/sSAUJ2PBj29OMx3Is3iN4AQ1QPVNV5MwbNxA=;
        b=Uz9m8eA4rTALEnbc5wY9Pgp+Xe5r1/1hunUlI+cghaJ4UcTU/ChhyHcXUwKWnyyKuU
         5MK3Aya0BRxRvnkAu64K0uO69vc+6iYGZNR6/1JzVot9iCbQLR7gF0JHoq1ZhEONCC+J
         WcbT2rFhXPkFSmr9+USj+p4PzEx8c/8zNQYfun+FGOjWVRe9RtAKUg9jA4ZjGLzUZ75T
         hF2aT3F8smJBm4y/AXOfC7NQb6CM+KLtUWLw7qr3e36YKnZL8AVFG2nc4Ew7+IwKs3GP
         yogBeZg4bDOU/HKhljTgkgI/xpxrBVkVkWsn+9Oy77FpfJzGPIcXOGl/xuZ0ynfaLRZJ
         uvCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BnFj/P/sSAUJ2PBj29OMx3Is3iN4AQ1QPVNV5MwbNxA=;
        b=maeYqM9wtgBzI3KOXikHKx4vl3CCJLaQpVZ2aO1G9ORIVq6VQJeclY7pBA/XgNdSab
         PdeS0XZP9RDufOstYBd3TurldPVHPziJJrgyp10fA126fZ0U9C8HT8K4iNd5gjtQKIl5
         /hR55TNm45eT6PRX9cv0CcmgoDRYAW9Bf+zZzZMaXNB6exiO2QkQuy2cDGcvEZolOxtc
         U4eD5MUpoEkAjzIe6UeL+EFcrubXnmGXgPIpjlqMAcu1Wcn9mycQjaCx52GVwal3rIpQ
         0pdftHQn+enX3GfDkqykMlFx/xUUZL+vjs6Q4PulWgIyYiZbxRCyj61xSKtYUjZQ8L08
         2rMw==
X-Gm-Message-State: AOAM533ryurUbDrrv4ITH4o4Nnh+sFl0dCDt57QNuN/H9feXCoXNAK9C
        L9bYsHzlXnF1dl9DvLL/OtOuWmqtOoOBdw==
X-Google-Smtp-Source: ABdhPJxn6B5kdlQ/wyFRCfmUM1KEAt0TwuBVoOYa6puiIqlbhJOWVs6MyXPr8xetD/doVw0NbNkaew==
X-Received: by 2002:a05:6a00:a83:b0:4e1:2bd9:7566 with SMTP id b3-20020a056a000a8300b004e12bd97566mr10078164pfl.63.1645228750327;
        Fri, 18 Feb 2022 15:59:10 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b13sm4070619pfm.27.2022.02.18.15.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 15:59:09 -0800 (PST)
Date:   Fri, 18 Feb 2022 23:59:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 10/18] KVM: x86/mmu: load new PGD after the shadow MMU
 is initialized
Message-ID: <YhAyyq7Atsdu4kTR@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-11-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-11-pbonzini@redhat.com>
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

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> Now that __kvm_mmu_new_pgd does not look at the MMU's root_level and
> shadow_root_level anymore, pull the PGD load after the initialization of
> the shadow MMUs.
> 
> Besides being more intuitive, this enables future simplifications
> and optimizations because it's not necessary anymore to compute the
> role outside kvm_init_mmu.  In particular, kvm_mmu_reset_context was not
> attempting to use a cached PGD to avoid having to figure out the new role.
> It will soon be able to follow what nested_{vmx,svm}_load_cr3 are doing,
> and avoid unloading all the cached roots.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
