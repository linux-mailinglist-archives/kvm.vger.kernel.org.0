Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA4258179F
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 18:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbiGZQl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 12:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239600AbiGZQlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 12:41:11 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A2830F49
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 09:40:49 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o20-20020a17090aac1400b001f2da729979so4185800pjq.0
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 09:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=07KAz0zc9BpNVKSXk/utJXELfFPx4QqPldQNrvBFPX8=;
        b=R2Yj5ylsAiL2aP8qQ4IwhH4DOoQWEEhLw6D+zknOkETnYeDc+Sxw93kCNf6IWluHDP
         J1iBfQM1ZLAucRvF93I5GRqm2mmdQIQIwnVnf6hiPsO8AH+cOgTHbuZNs1lx0rGaQyXk
         qOZvyg7g7WDJkTjaBWQD4ieBtX67Kl6xrkQSexHp9CCuKbkPDTg21HQtryqCErkhBJJe
         S/XWGngVUAVHgioD3dN/IFONMIn64UvToc15sA3xnGvkKiybxCm9a/qZCsv4GltjT8UE
         ZY/RDjeGZk8C4il9mtXvGUCfSuuvATg8A5aRcxQoZBRizEOaEoOdrsGoVUPBEB8E13yL
         YAzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=07KAz0zc9BpNVKSXk/utJXELfFPx4QqPldQNrvBFPX8=;
        b=13ngsUm5hrWP5gDFNYHuvzJm1onThZAy522lOP+UTlXcygp+UlaOG7wJHoRP1a4ybr
         /4nJ8E6UuhH44eN43HaHV0qbTYtrwbiT8r2++WdrPMxOEDfbZEStmJRf9uhXBSsPX76Q
         ORjUzYxDsE1mmJtAd9kRxrkYLReSX7MB5mIv4XshlO6HBkZqJGQ2wXomaBSp4snbcjiQ
         ID0P9smESgpbPTtBXVwbYA+qJgt9z6kI7NPHzi7DEaZha3Fo7bFtsZk5PQRumrqb6kh9
         DQzyfPGn79x+3+W+k0djVmt/D+P4VSf3yflvQszwJ3YIRt0mE3begflh4yLT91uTlofC
         NQog==
X-Gm-Message-State: AJIora9KMbHDm5pPxbvg9DdSTWyoZhEaPtSJh1XDqmnrOk/Opzf9mF7Y
        XhKVBd9KH590bXkMPHzKRKEC3w==
X-Google-Smtp-Source: AGRyM1uj3QCByBbwtYwbCQH6PHyV5wHW/AH6N9tQZi91z50BlIcn5Qc2r5degmPG8QQ6U2fx43RgFw==
X-Received: by 2002:a17:90b:4b11:b0:1f2:baa4:35db with SMTP id lx17-20020a17090b4b1100b001f2baa435dbmr57000pjb.195.1658853649168;
        Tue, 26 Jul 2022 09:40:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z7-20020a170902ccc700b0016c09a0ef87sm9415214ple.255.2022.07.26.09.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 09:40:48 -0700 (PDT)
Date:   Tue, 26 Jul 2022 16:40:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 0/6] KVM: x86: Apply NX mitigation more precisely
Message-ID: <YuAZDbg9Dzw0LKkp@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <Yt99jpf5l/cInivs@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt99jpf5l/cInivs@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 26, 2022, Mingwei Zhang wrote:
> On Sat, Jul 23, 2022, Sean Christopherson wrote:
> > Patch 6 from Mingwei is the end goal of the series.  KVM incorrectly
> > assumes that the NX huge page mitigation is the only scenario where KVM
> > will create a non-leaf page instead of a huge page.   Precisely track
> > (via kvm_mmu_page) if a non-huge page is being forced and use that info
> > to avoid unnecessarily forcing smaller page sizes in
> > disallowed_hugepage_adjust().
> > 
> > v2: Rebase, tweak a changelog accordingly.
> 
> hmm, I applied this patch set (v2) on top of kvm/queue (HEAD:
> 1a4d88a361af) and it seems kvm-unit-tests/vmx failed on both ept=1 and
> ept=0. And it did not work on our internel kernel either (kernel
> crashed).
> 
> Maybe there is still minor issues?

Heh, or not so minor issues.  I'll see what I broke.  I have a bad feeling that
it's the EPT tests; IIRC I only ran VMX on a platform with MAXPHYADDR < 40.
