Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3309E5227CF
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 01:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbiEJXur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 19:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiEJXuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 19:50:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EE8DEA7
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 16:50:45 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id iq10so673835pjb.0
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 16:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uXNW2Ma966gBaKmqxlxAmGf7PzWdvI/fxxV9fWVIL2E=;
        b=BQ+/N4DMOhsJhN2doQjaoYb6RUpUK6UwyVtYJ4A/2vNmBD1O1F1sJYH6lF5G8SlHZq
         CbLkZokQr2X2GeXxaoxF+0T86uQRJ7FyVAlima8comgq0Diyr59LRZh1b1g9PalgP1Tj
         qdLvaLKb9sWGDGk3si+/72o0vxIxXrevZ1TZhOKEE8Xx6LtG+z27L4D99dVCyUy0GoBn
         RA5UijI4ygx2981Rekh3mYBnfdylOw56qDI22VnNpOHG33XM5yc0UwxcgmfK3xCpXjCD
         hV6cBqwurnYuSIIERD+NtnknLwj2HgtxY1Z/s1Uqt5+e1dtYsR8SNxA1foI1GzeGLXUT
         90GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uXNW2Ma966gBaKmqxlxAmGf7PzWdvI/fxxV9fWVIL2E=;
        b=3fP3yVqJ2c5tGn8ixZIK/sAKyHtWVLQTtMWJRqu+QiRTnHmYCTKaY4HIsCLQeuDWAP
         dr0NxT+p0P1P01NBRWtyA45y+hihE5XYzyRS2VsnP/eSthTUrP0ykcnwpWpOgtFUDJrG
         Ac9mLFYYpuiN6zhP6IR0ttLIanypYYECVJkfSpYZp948j5hzS0a7j7AqSQxAMNpTYUUx
         25ctZzxMSD+BgSGTz8kza/aft1DbTjltN3JFrcXzvj0v6a0AAZjvXPwF20DfDN9NrD9X
         MyDkU9XILQ3R9Tv1N+xcCATFJ88WhV+kBUtR8XVYmQXNMyTUgSeMCLf0vTciJb5tkf3N
         gcOg==
X-Gm-Message-State: AOAM532zbzNf9CcnMJmLIyDfjHKV8Sywvc//DlCmLffmePG6c0hpJTwm
        DEupzVzSXyZJms3XDNA+cys0KqzNR21R3g==
X-Google-Smtp-Source: ABdhPJxtO/2wbfb6zZ2sN48qDFm9HA/k40ExF6pRC+wsCyjRXq1MgvDwVa+bG/lsKNhRSmvDhfjEBw==
X-Received: by 2002:a17:902:eb85:b0:15e:bf29:bd9f with SMTP id q5-20020a170902eb8500b0015ebf29bd9fmr22554705plg.135.1652226644991;
        Tue, 10 May 2022 16:50:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v3-20020a62a503000000b0050dc7628146sm129410pfm.32.2022.05.10.16.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 16:50:44 -0700 (PDT)
Date:   Tue, 10 May 2022 23:50:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 1/2] KVM: VMX: Print VM-instruction error when it may
 be helpful
Message-ID: <Ynr6UeaXEYx58A+W@google.com>
References: <20220510224035.1792952-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510224035.1792952-1-jmattson@google.com>
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

On Tue, May 10, 2022, Jim Mattson wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Include the value of the "VM-instruction error" field from the current
> VMCS (if any) in the error message for VMCLEAR and VMPTRLD, since each
> of these instructions may result in more than one VM-instruction
> error. Previously, this field was only reported for VMWRITE errors.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> [Rebased and refactored code; dropped the error number for INVVPID and
> INVEPT; reworded commit message.]
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---

I do think it'd be worthwhile to add the safe VMREAD variant, but I don't care
enough to hold this up.

Reviewed-by: Sean Christopherson <seanjc@google.com>
