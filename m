Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE7C542576
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444029AbiFHBBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588710AbiFGXy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:54:58 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5B11C4231
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 16:38:53 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w21so16896970pfc.0
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 16:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NUegXqW9LzmkBfY7DxTxhaAQ1AhdKbFukAoFdwvxQCA=;
        b=jPvQidTu5+raLDu+v304vNocGEp644rFe99IjU8FwjuyWQmAVP7dqExs4/o0n61Gee
         mVlDg24zvBuQ0aq1eNRGWRBDbRA0t88AQsPigABCJwVQBN7BQDMQiZY4+SWFItPL7bnx
         c8XcftWfQWOwDPuGujynski1qxt0w6FlSaiBXZfyidSZ5YG9JXN7cfwtkneKj87q2Bxn
         LxoZv2xH3ZL/zKMDoeP/o/WmG/39hKVjjipuyTOpWT/Q8ub1oAtXWFsoTP4qcm45k293
         +fTjWdLhTzPXqg+uKxqUsq6qcPHYYKLihWJFTO3Nefov4WELS3vYBtY0h1G9qQBRYfU4
         AjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NUegXqW9LzmkBfY7DxTxhaAQ1AhdKbFukAoFdwvxQCA=;
        b=lMTzwBPL0Q1KERkmZDHiZPJdmn+L5b0PqUoGB8+S3N/1k6XO7lsBfxsO5H05cQsVky
         8BJV1OyTmjN+VHbZAvEOkCCQmJx07mTyv2FVa9UBn4cMTO3bRE184MhM3npZ4+wVEeUS
         Kwe6OAfrSUjYEomrBLzjPyfflKaKFjEwlLzLFPKfzR14Niau53ZyhhLVzUJvZvAmHb/I
         olClXSJYB+z5k7+zSvMhX92seqQLQrZ01rQdslp3c3b1uNsKGMG65etvoLz1N2IxNjBD
         /R4mf/Sj5MsHgM+50u2cKOYOtyiQdvyOg3/M+yr9OEo5o4pcT4sJLv7ou3uhAQWONNMf
         Q/pA==
X-Gm-Message-State: AOAM5311VOsWRVaTVtM8IznUBTdMke5IpDu1l9qEF8EjQ04O0ixosXH0
        3wB4DgpX4ur1vP9k92WCuN5mgg==
X-Google-Smtp-Source: ABdhPJzXCWVCiCTCSz598flQCNLPk337229bVblysUjn6w1K4m4Oppv8XJDTTL+6nU8pj/acNT/3zw==
X-Received: by 2002:a63:1e49:0:b0:3fd:cf48:3694 with SMTP id p9-20020a631e49000000b003fdcf483694mr9997920pgm.275.1654645132460;
        Tue, 07 Jun 2022 16:38:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s18-20020aa78d52000000b0050dc76281fdsm13366276pfe.215.2022.06.07.16.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:38:52 -0700 (PDT)
Date:   Tue, 7 Jun 2022 23:38:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Yuan Yao <yuan.yao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH 1/1] KVM: MMU: Fix VM entry failure and OOPS for shdaow
 page table
Message-ID: <Yp/hiOxrOhEuIWj6@google.com>
References: <20220607074034.7109-1-yuan.yao@intel.com>
 <Yp9nsbNzoIEyJeDv@google.com>
 <20220607233045.a3sz7v2u6cdeg3sb@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607233045.a3sz7v2u6cdeg3sb@yy-desk-7060>
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

On Wed, Jun 08, 2022, Yuan Yao wrote:
> On Tue, Jun 07, 2022 at 02:58:57PM +0000, Sean Christopherson wrote:
> > Everything below here can be dropped as it's not relevant to the original bug.
> >
> > E.g. the entire trace can be trimmed to:
> 
> Ah, I thought that the original trace carries most information
> which maybe useful to other people. Let me trim them as you
> suggested in V2, thanks.

For bug reports, it's helpful to have the raw trace as the context is useful for
debug.  But for changelogs, the goal is only to document the failure signature,
e.g. so that reviewers understand what broke, users that encounter a similar splat
can find a possible fix, etc...
