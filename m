Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD3A518C8E
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 20:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241630AbiECSvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 14:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241617AbiECSvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 14:51:48 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDA92F3AF
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 11:48:13 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so2748520pjf.3
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 11:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zepmySBnv63WSkAXdeQNdsshIcZAMk3EbNb3138mR5I=;
        b=bPTLq9HfixcNLyVJaD/IrjOzYpPYh6ISpk4y9g70RAzYOYURAhNFSKi9A8tlEgtCuJ
         iHj76bj+ybFYWsdpewyIJ3JKcaRbYMR7FX+0Q/hYkNlr8qX9BEK1lv4F9wffhLucBx3q
         SylUmT+RO9ZZ/BVTL5k64FhSzsgHlNaUBFLmE/U4/LP9YcLC2OZCh7DaHU0TaxBPJ2Dx
         2NbnofXzs6vgcN9+tV/SLoEc+zEYD3D5rICX0xAIdUFNtq7wKMpc5IglomUTKK4yxDaY
         ShhRYAJ/B66lGc7uGfFrMJbYDfmbVro4tMSlHoufl/pWmplvDYL/1g+YQftWwZAso+8+
         8HlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zepmySBnv63WSkAXdeQNdsshIcZAMk3EbNb3138mR5I=;
        b=5u2CqsTTSpAF5wBvUf2wgebUj2AKYQ0y2t2tmqwf87IjqGyo1fam0jUR0duKIKvBGe
         yXA8Zu+3tniEENRNZi2dzX+HfhIPLOgeF/1H/ojzG7uDtZSDkPJDfBkb4ZnCD3IE7wKg
         Ak8E6sQ4EbpvUfBAPryktFHDnEej/tvDpkNUrljMW7bTxU9JJFFvk3XVCqgCbm1idu2x
         rPgleW15eoYLY0RXaEE9AZmYnx0k458KCRPelzXZJ3ctqvynD6SII1EbxTZe37JPn5GM
         7ahrRWXB4HQBGYg66r+gXEYeB/HmEQwjpsw03Fp90vcuqH75DEfJwf8rZLTFk9yrZRp/
         /Z5w==
X-Gm-Message-State: AOAM532bKE/92nBsKhJI4t/Dl3EHKWNIecrj9w1YDg1wR9sNjfPqAI9A
        52QGeA6O/Db0fMwxx6QEzbpwEQ==
X-Google-Smtp-Source: ABdhPJzGH6bZd7Lk7Z4f76hg2wclxCUfrHdcZ+b6yafpH1Mw5FD+OJyW444A9VnG32wg6W+XMssHDQ==
X-Received: by 2002:a17:903:246:b0:153:857c:a1f6 with SMTP id j6-20020a170903024600b00153857ca1f6mr17679441plh.153.1651603692636;
        Tue, 03 May 2022 11:48:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 30-20020a63125e000000b003c291b46f7esm824358pgs.18.2022.05.03.11.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 11:48:12 -0700 (PDT)
Date:   Tue, 3 May 2022 18:48:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/12] KVM: SVM: Fix soft int/ex re-injection
Message-ID: <YnF46K33TOKqpAUs@google.com>
References: <cover.1651440202.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1651440202.git.maciej.szmigiero@oracle.com>
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

On Mon, May 02, 2022, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> This series is an updated version of Sean's SVM soft interrupt/exception
> re-injection fixes patch set, which in turn extended and generalized my
> nSVM L1 -> L2 event injection fixes series.
> 
> Detailed list of changes in this version:
> * "Downgraded" the commit affecting !nrips CPUs to just drop nested SVM
> support for such parts instead of SVM support in general,
> 
> * Removed the BUG_ON() from svm_inject_irq() completely, instead of
> replacing it with WARN() - Maxim has pointed out it can still be triggered
> by userspace via KVM_SET_VCPU_EVENTS,
> 
> * Updated the new KVM self-test to switch to an alternate IDT before attempting
> a second L1 -> L2 injection to cause intervening NPF again,
> 
> * Added a fix for L1/L2 NMI state confusion during L1 -> L2 NMI re-injection,
> 
> * Updated the new KVM self-test to also check for the NMI injection
> scenario being fixed (that was found causing issues with a real guest),
> 
> * Changed "kvm_inj_virq" trace event "reinjected" field type to bool,
> 
> * Integrated the fix from patch 5 for nested_vmcb02_prepare_control() call
> argument in svm_set_nested_state() to patch 1,
> 
> * Collected Maxim's "Reviewed-by:" for tracepoint patches.
> 
> Previous versions:
> Sean's v2:
> https://lore.kernel.org/kvm/20220423021411.784383-1-seanjc@google.com
> 
> Sean's v1:
> https://lore.kernel.org/kvm/20220402010903.727604-1-seanjc@google.com
> 
> My original series:
> https://lore.kernel.org/kvm/cover.1646944472.git.maciej.szmigiero@oracle.com
> 
> Maciej S. Szmigiero (4):
>   KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
>   KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0

LOL, this should win some kind of award for most ridiculous multi-author patch :-)

Series looks good, thanks!
