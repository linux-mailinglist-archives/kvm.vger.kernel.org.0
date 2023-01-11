Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA1166621E
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjAKRjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236685AbjAKRiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:38:08 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DFE3D5CC
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 09:35:28 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso16252431pjl.2
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 09:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TANTmaZ5RKqXWZYLWNIZpA3McyHvxdOn2cx74kyL3x4=;
        b=qdy33hd/n8/36k5uhGWZOY5MLANfUIIZDNuhhjOFAFfKeWvdWAxAdRBqT1lgNRwZqL
         NkdiQO/WeA0xkt63rQi5CjWFnGDW64hI/yjjHQpwFKI3QmGgfPiAUXldmDHakn9l8wzS
         M8WUMDH+RWQXapdlHuilPaKfkw2GPDuFDK6it1PuPgTQwChBK88BIojh3dhKyOMUOSEL
         2FB/CN7X4FNfl1lJK4Vt4GClcxTvtcToSh9tvy722N9zfSm7hjsgQQTsKCMIzAbL4n8O
         CsjdkAh1XGRKV6jLZRanDlneizXcOyaE9WOaoc6q0AY225qQxu5M9AhSvDvVUIFryvML
         CHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TANTmaZ5RKqXWZYLWNIZpA3McyHvxdOn2cx74kyL3x4=;
        b=QOqhtw5MbM1ZeDJ/DjgirGXSSyw5MnzzyKiKhlWrItS/IhKSFuMtM0yFK+N0uO+BAJ
         0RXUurM9kuU3b5qPP79rLZ0fnyjz7c7Dj0yRTQnNF3PHq9b3+6YRqStoupqQSl2vmpX5
         VdM/KdQeSztmZNZ0RLlsBnZ/KTmJNRABYH0goTYUqejEG9OMwvgUmvO4N9GSCkVogyLC
         vmTZcG1HtRh2DKjYkhf4sPbSX7dT5tn1acR5DrXKMH7aNWj+ej6J7oSCxJVr2LHi8UFL
         WD2TyxPllCxrmW5Ur6zBKFss7nCIM0LVU9vBb48TtuN3RNutMGuO4dzk/LSrzKFEZJwt
         /GOA==
X-Gm-Message-State: AFqh2krBLMiQAQKgMedcrpI7wwjkeYf/s0IdSnrl3w02xt6MmKBOMkvq
        KrWrol26kytM75WEbYRRZfSvEA==
X-Google-Smtp-Source: AMrXdXttjPscxG9EggojmkfOvCnzhuYfmjRJCdSMm8ncg1/uAqUsyiBtEPv5jQrm7ogr3im+6WISKQ==
X-Received: by 2002:a17:902:ebc6:b0:192:8a1e:9bc7 with SMTP id p6-20020a170902ebc600b001928a1e9bc7mr616734plg.0.1673458527809;
        Wed, 11 Jan 2023 09:35:27 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i65-20020a626d44000000b0058173c4b3d1sm10222435pfc.80.2023.01.11.09.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:35:26 -0800 (PST)
Date:   Wed, 11 Jan 2023 17:35:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 2/9] KVM: x86: Add CR4.LAM_SUP in guest owned bits
Message-ID: <Y77zW6eSC8b5QYP2@google.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-3-robert.hu@linux.intel.com>
 <Y7i+/3KbqUto76AR@google.com>
 <5f2f0a44fbb1a2eab36183dfc2fcaf53e1109793.camel@linux.intel.com>
 <Y7xA53sLxCwzfvgD@google.com>
 <46da749bab77d680c37c9e4fcce34073a466923e.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46da749bab77d680c37c9e4fcce34073a466923e.camel@linux.intel.com>
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

On Tue, Jan 10, 2023, Robert Hoo wrote:
> On Mon, 2023-01-09 at 16:29 +0000, Sean Christopherson wrote:
> > As a base rule, KVM intercepts CR4 bits unless there's a reason not to,
> > e.g. if the CR4 bit in question is written frequently by real guests and/or
> > never consumed by KVM.
> 
> From these 2 points to judge:
> CR4.LAM_SUP is written frequently by guest? I'm not sure, as native
> kernel enabling patch has LAM_U57 only yet, not sure its control will
> be per-process/thread or whole kernel-level. If it its use case is
> kasan kind of, would you expect it will be frequently guest written?

Controlling a kernel-level knob on a per-process basis would be bizarre.  But
the expected use case definitely needs to be understood.  I assume Kirill, or
whoever is doing the LAM_SUP implementation, can provide answers.

> Never consumed by KVM? false, e.g. kvm_untagged_addr() will read this
> bit. But not frequently, I think, at least by this patch set.

Untagging an address will need to be done any time KVM consumes a guest virtual
address, i.e. performs any kind of emulation.  That's not super high frequency
on modern CPUs, but it's not exactly rare either.

> So in general, you suggestion/preference? I'm all right on both
> choices.

Unless guests will be touching CR4.LAM_SUP on context switches, intercepting is
unquestionably the right choice.
