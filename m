Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD7857A835
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 22:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237206AbiGSUbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 16:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiGSUbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 16:31:09 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98B14506B
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:31:08 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s18-20020a17090aa11200b001f1e9e2438cso86748pjp.2
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=66lOoODJK8E+OBaGCxybOPnfHghyFR1wn5dp+ysHQ2o=;
        b=Ym9n0ZrSB1bTD6E6GT9WF4NK05xCS/Hs8NQ7w6dcppIMHX1dTKQLcKP1fLlk9SfpiB
         Nf+sueQuI4VabNfv91MRC69FaGhc77IlSGWIyJ/GtOj8TI4QPAE82NwYFaYcXBrnNv+1
         0t/vuk9iV3tZWYIueZF2FxNDwhkRbD+AgWvJmSLsCISZeNRWCHwNOMlXqFEuri9c5MI4
         DSNSPUx85JI2Lbr6WWUMfMStPewa/davVbaRVz3NXZ1n12AdqT8N9o0WLlu2ddCgJiX0
         VS7qnmtlikDjTxYpawPI+ghiJeNAVBwV840QVYjGlOez/ZYxV3VOGi+7ZlDvalmXqvB/
         9onw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=66lOoODJK8E+OBaGCxybOPnfHghyFR1wn5dp+ysHQ2o=;
        b=wzqMBLflT+KC1ylQkqBEM0TybjdQuzF1ygx0fmes8wc2ZwVn3iBdD0cBwuWGAOGY39
         +gPSwpJAlGeOpW7wWYgjsSOHiwuD1meLX6vTnOZrFD2Gz1ChAJ54RBZTkK0a4f1PNbtU
         3YNxh//4sjt1XG2w/64pHDywljmQPnifnQ5ZsBjTLfc/OUktkyAA5kMH31ZmBKd938YI
         r7IYdu45vskCcBVO+3KCkm9r8SmQmDHVP8s26u+L2Mlh4PnvDePdV8dV5QOpwbfRv96J
         w1oYwDnBJJgfaQPcYh4Hec1O81f0YYFxsinto0ApCkssg/7Q4KrFYWsowRdc8osOwtz4
         3P7w==
X-Gm-Message-State: AJIora9P79HDIR5mk/pSvpqSSDC3XwBIOR9xIuKgefVFaSjx7eLIugCr
        bivYCpPzpMXxokqGUM+d4NEjKgbzgwdJmg==
X-Google-Smtp-Source: AGRyM1tspa78Llu6KSQWUFSducFa/Xip5dNasrYOi7hPrQXdasfvrDrRoR+BQPQsrQc87XI3XgJ0EQ==
X-Received: by 2002:a17:902:ccc4:b0:156:5d37:b42f with SMTP id z4-20020a170902ccc400b001565d37b42fmr34886845ple.157.1658262668176;
        Tue, 19 Jul 2022 13:31:08 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090322c300b0016a6caacaefsm12258717plg.103.2022.07.19.13.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 13:31:07 -0700 (PDT)
Date:   Tue, 19 Jul 2022 20:31:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 08/12] KVM: X86/MMU: Remove the useless idx from struct
 kvm_mmu_pages
Message-ID: <YtcUiJtbWvKpq2B1@google.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-9-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605064342.309219-9-jiangshanlai@gmail.com>
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

It's arguably not useless, e.g. it's still used for a sanity check.  Not sure
how to word that though.  Maybe?

  KVM: x86/mmu: Drop no-longer-necessary mmu_page_and_offset.idx

On Sun, Jun 05, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> The value is only set but never really used.

Please elaborate on why it's no longer truly used.  Something like:

  Drop mmu_page_and_offset.idx, it's no longer strictly necessary now that
  KVM doesn't recurse up the walk to clear unsync information in parents.
  The field is still used for a sanity check, but that sanity check will
  soon be made obsolete by further simplifying the gathering of unsync
  shadow pages
