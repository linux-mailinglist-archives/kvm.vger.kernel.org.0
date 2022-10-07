Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821865F805C
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 23:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJGV6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 17:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJGV6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 17:58:06 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AB112791B
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 14:58:03 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id h13so4586770pfr.7
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 14:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=brNBXr+8/wzZA+nIy3egINBkzFrPq5ruF6R05GO6Hrg=;
        b=RUGA2S7sdUtmxjzn27zRSKLTchu19o/wBZ+twIGuoBNaeqkIBV8KlGGpurJN7KVe9D
         A08AAzMvMG4pshxlFQLnZyJX/mDOkxeKZdJASytXQwCamw46VWmxt+RPxDGe5sNiPV1v
         aWqhbk/GgBpUfNd0f6M+WtpRaKiUDfLFlhGma6HCMAFIUtL2ougz5TsVV/s89HCvMmKY
         I8mk705OQv+XJKSG5NA0DAM/T2hABEFLCoFg8B2NA+i1RYm+0hxx9+wiD3XvimVZYv79
         q5PBhWvpdQ9sBeHl+hoQjyuhLW7dcZFZerOEMPEACSjGZcTmmsyr0w35b6armnMr8sGJ
         pOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=brNBXr+8/wzZA+nIy3egINBkzFrPq5ruF6R05GO6Hrg=;
        b=ZW0ZHr0hZr0XsdAeZZKOqv6pxfL6H5NguJnQK/kpdm57OVp3ez2I2omEReCChhM7AN
         3mSvjeqlXfdE54VQ6nBDoJHOFF6gdkbKDXpktC6+1XQMqESEszPyTItRiFZhZ0msGd85
         iZNNFPfTIFOJjUzbA9+9h0dyhozms7YgNh0PjOml2Z0b4+wtnFkvBvMLol5iWA6+c/N5
         W5uGZE64JuR+xWNCmS8oBXc7TAdvbWn4o5hPYvWpjFmWIN/hpsbt/YiBuY+DU9bNf41x
         eoIJxje4PXAqs4VYvpnJuAvGFDUkhSLDBhBYkqUNVrFVaCk8Zmd/r8Z7labpl9/DR7zP
         oyEg==
X-Gm-Message-State: ACrzQf148l9WkAgSlUEO8cVJYId6E2rZtmF8BnUkv3/4mgaJILmTiPU3
        JCGZZ7V8UIhVi13fckUnwnUSYQ==
X-Google-Smtp-Source: AMsMyM7XbnkBjpWb+HSCPMbMUTi6gsW4BX2AxXGEWTzBQpkldATEkpjeh/6Fj8YCcftto2okxXOarA==
X-Received: by 2002:a05:6a00:218c:b0:561:bd69:dca6 with SMTP id h12-20020a056a00218c00b00561bd69dca6mr7307893pfi.83.1665179883323;
        Fri, 07 Oct 2022 14:58:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a10-20020a1709027e4a00b001806f4fbf25sm845116pln.182.2022.10.07.14.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 14:58:02 -0700 (PDT)
Date:   Fri, 7 Oct 2022 21:57:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v4 1/5] KVM: x86: Disallow the use of
 KVM_MSR_FILTER_DEFAULT_ALLOW in the kernel
Message-ID: <Y0Cg5zPruZZPg9Ed@google.com>
References: <20220921151525.904162-1-aaronlewis@google.com>
 <20220921151525.904162-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921151525.904162-2-aaronlewis@google.com>
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

On Wed, Sep 21, 2022, Aaron Lewis wrote:
> Protect the kernel from using the flag KVM_MSR_FILTER_DEFAULT_ALLOW.
> Its value is 0, and using it incorrectly could have unintended
> consequences. E.g. prevent someone in the kernel from writing something
> like this.
> 
> if (filter.flags & KVM_MSR_FILTER_DEFAULT_ALLOW)
>         <allow the MSR>
> 
> and getting confused when it doesn't work.
> 
> It would be more ideal to remove this flag altogether, but userspace
> may already be using it, so protecting the kernel is all that can
> reasonably be done at this point.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> Google's VMM is already using this flag, so we *know* that dropping the
> flag entirely will break userspace.  All we can do at this point is
> prevent the kernel from using it.

LOL, nice.
