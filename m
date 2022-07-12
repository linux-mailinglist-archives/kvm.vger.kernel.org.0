Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1E957263F
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 21:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiGLTqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 15:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiGLTpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 15:45:46 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ADAB31E0;
        Tue, 12 Jul 2022 12:35:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so9548081pjl.4;
        Tue, 12 Jul 2022 12:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pcWHAy3/tPHAoTp/hrAF2gP8rrXZmMAJZmgO7CXU4EA=;
        b=G5CiNtYkMY5QMG4CV9SpPEwSGdgknjRSKSP6Acd1oVu39w2xvd4UdcqYqf0I13/xFf
         5O+EQDSOCTT3jVBRLGf+XCSyxLnmW7pzJ41loqmiUO4JDExcOZ0xvkSyeGC41Cgz/Vcw
         x7HoZ47nuJLQFsuosMRvZdmW/mQAhN3GNK5rUXDP4Oo8ZWzL4OkFVUv+rXfHQ1e86j6Q
         D+lBQyIo/BbntxAIVEpJUu8jVC3RG94XuvnbMwYvHua0T/XEgB/N7eb6qloxW48w7hty
         oRCT26q2uADVuOQlykWjHRCiiZU/dOleJ84qzTaAA9w5U0w8yUl8szj/1OsJSWVylb+C
         8mXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pcWHAy3/tPHAoTp/hrAF2gP8rrXZmMAJZmgO7CXU4EA=;
        b=7macrgikBtyYrw1anTdvIDGNkB6dOWxOR6uplROO4CVDrHiEhd2cZ5fFpZm+1FFqmq
         XTPLnwrJrpsk7vnGFcaZLJ5C8e7Yo1YU8kbvJcYwXNXfE+mYQ8EV4EaGJUTxY+G2Y6d0
         2np1iw8l4wpw6eKSEpgOEe+AdEqRzagUhL0qsJD+JmtcEy/izUw/W3yRggSNlohidzPK
         rrcdTeC3kfUjqFre0vHHM2IG6Cuwzz5Ep9FaK4xmP69qdbp3Kq35lzq8ZAclk1CqR0xS
         B56yX9vVgMM1rN+ihFGaXrTzUr9e3P7TNhq9YSsBm8HjPdCmJMZcvAJ4DxWKOEGZfMtv
         8Jzg==
X-Gm-Message-State: AJIora/EMRb8rSYUNrEQLUbHutJJHEYikV07AMoHz3hCdvgRnDHJ98Ke
        M969i8gYz2orV57GLk1t5oU=
X-Google-Smtp-Source: AGRyM1uY9XFsLGlhVGw4Ys01vOg/7z0RsZ7y2ns8/B8pSvSBvfnvGcWTuBs/giPWFaerIYuB3xSoQw==
X-Received: by 2002:a17:90a:4211:b0:1f0:35bf:293e with SMTP id o17-20020a17090a421100b001f035bf293emr6182259pjg.165.1657654516566;
        Tue, 12 Jul 2022 12:35:16 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id k88-20020a17090a3ee100b001ef8ab65052sm7091558pjc.11.2022.07.12.12.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 12:35:16 -0700 (PDT)
Date:   Tue, 12 Jul 2022 12:35:15 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH 00/12] Documentation: tdx: documentation fixes
Message-ID: <20220712193515.GM1379820@ls.amr.corp.intel.com>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220709042037.21903-1-bagasdotme@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 09, 2022 at 11:20:26AM +0700,
Bagas Sanjaya <bagasdotme@gmail.com> wrote:

> Here is the documentation fixes for KVM TDX feature tree ([1]). There
> are 58 new warnings reported when making htmldocs, which are fixed.
> 
> [1]: https://github.com/intel/tdx/tree/kvm-upstream

Thank you for those fixes. I'll update the branch and include them for the next
respin.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
