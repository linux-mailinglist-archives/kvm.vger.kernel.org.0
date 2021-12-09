Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C163346F48E
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 21:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhLIUIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 15:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbhLIUIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 15:08:05 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5299AC061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 12:04:31 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so7807285pja.1
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 12:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hV49pi0xuCvdmrCu3BkT5P4T1hTATMD4kSIi+h3DNq4=;
        b=j/tjc2jreciA8uakIxY+3NSIChT2h1S5xfJKzh0w+gOPvfwRxFlBHG9PioCwj4fNyr
         IA0LQq8EDrVhX1WWMngsHaqr3KwX3R9VsfHyseqOriuOoPXvAeztxEKySUEGL53k66Tj
         TLTv1ZdxE4+WAMwK4x0Hxe3jusueyaCjFlMpiZeNKPhh8QyDhIVg/eH4Iql5qhuSFIPh
         bVK1aGu1S8rjWZwBidb8iHDanQvHeiqrrMC9romc1tPK3ARnQA5rlT+3LJtz2Mtu3F93
         SyoolcJvlc1+FyAHW4eOryL6JM5QyUs2vkF3Kr68Bm4PC95ZG3Exs/zz3LLd4ANDOIkE
         Fkmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hV49pi0xuCvdmrCu3BkT5P4T1hTATMD4kSIi+h3DNq4=;
        b=zmOji4JWEdyD0R3gFvYWMj6HewR7KNkV3ZjFTMDjgCY7S5QYVRfO6uq9nVRTN6q/hh
         aNNkdfncLXq53q9b8eE0+1ImwwGrGD+Lhidlq/oZmS0Q9zXLFLcSmkFl67WoMLGjOHCN
         POAqWkpoKC/DaYO+CXdn4C/QydZYJlRTsk/nRBfsrCIyjMcS3cqNvChL/KgQlSdgm+NM
         Cal1EH4K5FlWbjh9AGr75AmLEKuselrXjAB2ANfQ3qKSNTPJkk3dXsBOLdimYS3WkTdY
         9cBRIPsrt9ub0hx1co0W3Ez7IRRZB95mLtK0gXHIgjwChZQuISWRH8sYMGA1z8KC79GU
         qp2g==
X-Gm-Message-State: AOAM531gg2SDVxEF+aLplDASznVqlWP5gbIH77adLsXoeXZ7cDd/Rgb1
        ZeJIVA5wJVAUyrcEvh/+i7886A==
X-Google-Smtp-Source: ABdhPJxU1wn4/d68aoBUiCFmy9/1u0l3fbjqq8b5yPP3FQ9T2K81xhm7eJBYA3GwCe0mHA1OYgbLjg==
X-Received: by 2002:a17:90a:590d:: with SMTP id k13mr18068171pji.184.1639080270691;
        Thu, 09 Dec 2021 12:04:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h5sm516654pfi.46.2021.12.09.12.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 12:04:30 -0800 (PST)
Date:   Thu, 9 Dec 2021 20:04:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Fix a #GP from occurring in
 usermode's exception handlers
Message-ID: <YbJhSq0xsUMow1Pb@google.com>
References: <20211209182624.2316453-1-aaronlewis@google.com>
 <20211209182624.2316453-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209182624.2316453-2-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit on the subject, "usermode's exception handlers" reads like KUT is handling
exceptions in usermode.  Maybe "usermode library's exception handlers"?

On Thu, Dec 09, 2021, Aaron Lewis wrote:
> When handling an exception in usermode.c the exception handler #GPs when
> executing 'iret' to return from the exception handler.  This happens
> because the stack segment selector does not have the same privilege
> level as the return code segment selector.  Set the stack segment
> selector to match the code segment selector's privilege level to fix the
> issue.
> 
> This problem has been disguised in kvm-unit-tests because a #GP
> exception handler has been registered with run_in_user() for the tests
> that are currently using this feature.  With a #GP exception handler
> registered, the first exception will be processed then #GP on the
> return.  Then, because the exception handlers run at CPL0, SS:RSP for

s/return/IRET for clarity

> CPL0 will be pushed onto the stack matching KERNEL_CS, which is set in
> ex_regs.cs in the exception handler.

The IRET from the second #GP will then succeed, and the subsequent lngjmp() will
restore RSP to a sane value.  But if no #GP handler is installed, e.g. if a test
wants to handle only #ACs, the #GP on the initial IRET will be fatal.

> This is only a problem in 64-bit mode because 64-bit mode
> unconditionally pops SS:RSP  (SDM vol 3, 6.14.3 "IRET in IA-32e Mode").
> In 32-bit mode SS:RSP is not popped because there is no privilege level
> change when returning from the #GP.
> 
> Signed-off-by:  Aaron Lewis <aaronlewis@google.com>

Reviewed-by: Sean Christopherson <seanjc@google.com> 
