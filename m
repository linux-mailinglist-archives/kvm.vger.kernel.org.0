Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5BE5F729E
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 03:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiJGBrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 21:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiJGBrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 21:47:07 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C629D51E
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 18:47:05 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id v186so3632950pfv.11
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 18:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AWItWK9YLUWWwwboY77Joh0sASU1yMjtM5uf/oLRhBc=;
        b=OTXcccrUeNvHldGtl0qGzhPHflhjjC7gQoRJhlkRSpAJDqVzPuqUsYFPGajeU/ycyV
         IxvPV+wlcDD3mIYV7d80ECLIH92ivBz7EzuMf0GETazFuxLQjYM05QSvCfm2D4ugNQ2q
         GCSHe2Hn6sbaNND6nZZGAOSEI1rr5FvP5BT+9BunXGwms+xr53hfeKk7mSZ7R0tg7NpT
         LUOGIZgDWXYZhstjyZIkpSHHrD7CBOy3pr1UArtWgoFi9PqxwNSaFqYtH6+AGpUef2AL
         n9SbnpZazz3y9uTwEKAB5bV8GaEQo4dwiQ8AiNhWtpLoApzgNbc5uhJWoeOqEQ2w7ib1
         kfwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AWItWK9YLUWWwwboY77Joh0sASU1yMjtM5uf/oLRhBc=;
        b=3F2432APaXDObC0y0n+EbOSDYhfbxrQ9FB/0Wtr2QqHHd687vFXMtLVsgenSOYQrfu
         auDV8iTsKFXiaDRIPJbozwMuO5auqFKfK1hueRFmLdDuOOze6Gkm8aaKKKIf7yD7hd+H
         RQW6V6H1WJWiU46sIAxCv5aOGEtiwQxQ0R/3Z8QQOOcF4efmwFWppAS6TBjr93C4Q0Em
         het/ug++hhIjuzdBk0AVnh2soFdwOTQia+IOQYaZj4/2WFmh9GrkmzYnSvDjoY5WC1IU
         GN6P5FSdelC+pgQ9e3MfrGZdDuZ1ee+eQtbE3E/BUF/Rlx5vnBpA0IixeiJqXd083o+e
         ppzw==
X-Gm-Message-State: ACrzQf1NzdtKTy/PXzg2CABvBqHp87Rz00CHiMxHEms/c8NQnHBCJs2w
        oVuycjAPfe3Zycmfs70meb6LAA==
X-Google-Smtp-Source: AMsMyM60OC1FgXiRevexoPDWM3HIuuPrR5gY3pSyagiuA5kJcfh0KyVtqej/O6xu1+CkjNp7zUTN9w==
X-Received: by 2002:a05:6a00:804:b0:544:4e98:3ff3 with SMTP id m4-20020a056a00080400b005444e983ff3mr2589148pfk.36.1665107224177;
        Thu, 06 Oct 2022 18:47:04 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f17-20020a170902ce9100b00172f4835f60sm266167plg.189.2022.10.06.18.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 18:47:02 -0700 (PDT)
Date:   Fri, 7 Oct 2022 01:46:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Wyes Karny <wyes.karny@amd.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] x86/cpufeatures: Add macros for Intel's new fast
 rep string features
Message-ID: <Yz+FE+bR8zJOa3vY@google.com>
References: <20220901211811.2883855-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901211811.2883855-1-jmattson@google.com>
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

On Thu, Sep 01, 2022, Jim Mattson wrote:
> KVM_GET_SUPPORTED_CPUID should reflect these host CPUID bits. The bits
> are already cached in word 12. Give the bits X86_FEATURE names, so
> that they can be easily referenced. Hide these bits from
> /proc/cpuinfo, since the host kernel makes no use of them at present.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
