Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA624BBC70
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 16:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237202AbiBRPtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 10:49:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237221AbiBRPs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 10:48:26 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0002C663
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 07:46:39 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id i10so7487560plr.2
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 07:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0h0yzaW462ZF9lyYj1aHP10k4uXSQPfG+Ko5s+1LJxg=;
        b=Vblj9l7DSl6NjW4P3nEo+yA4pBRc6GV5wKlIkQI9RYk9QxeAYDmff7Wt96DQ419OxE
         venDArEZzh23AuQhZaL0x9N7i0BohjnLY2hSowm4bhh1u4EF8PXFB90+NYdQxVtqL0vX
         4N6sHfws37oWBIEmcxSVmrzyBfvJuzdh53JXuzCYoUED5Gc6IKy2PPvNJcHVrGzbeTLJ
         w5lgAW46wmvaDEwj7/HqAu2jmWfdw84YAU0tcWig2mC0GaeECKjEvy5uU0HBiEx1kBUa
         MeO75fomWOPLzf62CyyjhQb3n+PedNP2hZxYSoz2xtof3EFX7+3wlFnldDHO2G2Bi5kU
         5KsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0h0yzaW462ZF9lyYj1aHP10k4uXSQPfG+Ko5s+1LJxg=;
        b=hFJenSUt8ckFG0jXdgoFhMILIDFEqQJZqpal3mVdKX1fXzcssO4C7Iu9VQ7v4wWf1K
         K4jdj9uMTslFOLNZ1HN5dZ5DwkdLwVqhCPihWHXlnyOb8lJ5TKHCORR0XMEZRNawPiSy
         MQqkEfG9EOchTt05D+9v5G9+Wevsc6h8K+WDw2WQEeCt8WRVrUWmtbFLYlkb6WhemGbf
         EgxJpl6mYNNoRMFU+xqlcg9MIhXiDAXC2kE/N3nSFqRR2mkBz91tCdGFYSKKdb+4Mrtj
         iNcPThinrvM+TAnh5WRGq0exqjzeGci5Fe1RxPDEHp6PVi4CIGKqmp+sR2nPTOLhu1PH
         kZKA==
X-Gm-Message-State: AOAM533e7ta+g5H0cQzwAxgUziBMAzDhVtzE/p8JTf7yzldFuKdIKpQY
        ZBYZYRAun5ALnQea17pDutbfNw==
X-Google-Smtp-Source: ABdhPJwTapBayvFSHcTphOCuoc0Liz2WvP8m0tyMK3bULiLHZ4HyYwgRZwfW19JzdRRkOIM//07CzA==
X-Received: by 2002:a17:902:eb85:b0:14d:b906:cbd3 with SMTP id q5-20020a170902eb8500b0014db906cbd3mr7909810plg.122.1645199199015;
        Fri, 18 Feb 2022 07:46:39 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 14sm11614010pgk.85.2022.02.18.07.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 07:46:38 -0800 (PST)
Date:   Fri, 18 Feb 2022 15:46:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/6] KVM: x86: use static_call_cond for optional
 callbacks
Message-ID: <Yg+/WirqvhO0Zx1q@google.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
 <20220217180831.288210-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217180831.288210-3-pbonzini@redhat.com>
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

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> SVM implements neither update_emulated_instruction nor
> set_apic_access_page_addr.  Remove an "if" by calling them
> with static_call_cond().
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
