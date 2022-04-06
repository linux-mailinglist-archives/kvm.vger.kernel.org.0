Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83CF4F6B74
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 22:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiDFUdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 16:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbiDFUdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 16:33:04 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715E236501C
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 11:55:01 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 125so2932479pgc.11
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 11:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3UwS67a96Tb6SDCw770nS82cwtsxoFoCCEDFi2dayKs=;
        b=QwvBgZECwWIxCMgkRGEbJujhDdTc1utsklWF3FNHR8M0OKB3ndAMk1Oi9O7LSZ1AQg
         fpECfDRnjuzQn4OziK063RbFwCQsPJ/CGgTT4fUv46pDflCTY210/+biid5NTqduYLbb
         Sb+4gTvmccRJzQ0Fd1SXDeS2WNttTR0uVFXW27AoRQrh+VG1Jw12m8q8dJR81Mrv81My
         wFgBTdmEmZDwjLuluHqRo6qWH2Pi+z9BOwhw1oHO+a2en3n7sv0npOiUMA00YI7pWrfP
         JKizjxX0m0ckqqhQAVQUAjZzqWIyADy/kMB3zdFrsnSwOqTDGXtyWwzWqaeKSUfYptUa
         myTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3UwS67a96Tb6SDCw770nS82cwtsxoFoCCEDFi2dayKs=;
        b=UpHZpzp/i63ZWtl9GQCXeCdwSdKE/G6aZpilEzdy6iksvVvACWACu9v3YMLkl4YlUd
         jFtGJIJSlXsN/00aB3yqHW8GZAawVXiRLK8yRtbcrawZswYUlUUnB5KpXzOp0R+Sjavz
         oXQHemgaEKg8x3MpxrhvQAOY74IZyYMSe7cxuHpECYGCYXE4MUEShqoF2vHyb0ng8tVQ
         O0nErFeZtvnL2BH+hhVdkQ3q+a209JR0kHRcze88AUAcqPRQrNHJGKjuwxxX0V8Ckxsk
         qCnXkcLKqqJt9qK6UxNOME+GU181/bvG+bbml+lKDKUOYg5rX3uBpWLLgbBrX0dg581L
         FCpw==
X-Gm-Message-State: AOAM531nfKK78p9oKwV4YIsLBpN24Tq+wWIhUJ29cbYZ2nQ/IAPEmMCz
        WU3ay5KObfcSJ6ujq8jzrAQTGQ==
X-Google-Smtp-Source: ABdhPJwLt1JpqlwVw3x5E2e7SNXCzHby2VVZ2genX56F+WKjgXE6zz87d/CzoeM8HMRx1mtQwFoFYg==
X-Received: by 2002:a05:6a00:1252:b0:4fa:afcc:7d24 with SMTP id u18-20020a056a00125200b004faafcc7d24mr10142251pfi.85.1649271300765;
        Wed, 06 Apr 2022 11:55:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k20-20020aa788d4000000b004fb07f819c1sm20270581pff.50.2022.04.06.11.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 11:55:00 -0700 (PDT)
Date:   Wed, 6 Apr 2022 18:54:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tao Xu <tao3.xu@intel.com>
Subject: Re: [PATCH v5 2/3] KVM: VMX: Enable Notify VM exit
Message-ID: <Yk3iAKW1sdA4StiC@google.com>
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
 <20220318074955.22428-3-chenyi.qiang@intel.com>
 <YkzgLGlCAG2ZwgqS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkzgLGlCAG2ZwgqS@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 06, 2022, Sean Christopherson wrote:
> On Fri, Mar 18, 2022, Chenyi Qiang wrote:
> Ha, and I think skipping this path on VMX_EXIT_REASONS_FAILED_VMENTRY is also
> technically wrong.  That's still a VM-Exit, I'm pretty sure failed VM-Entry only
> skips the MSR load/store list processing (because the load lists on VM-Entry are
> processed after the final consistency checks).

Nope, I'm wrong, the SDM explicit states that only EXIT_QUALIFICATION is modified
on VM-Entry failure VM-Exits.  Which means we actually have the opposite bug as
KVM is clearing a bunch of fields.
