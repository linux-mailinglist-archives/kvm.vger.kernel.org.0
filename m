Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239975F7B60
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 18:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiJGQ0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 12:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJGQ0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 12:26:09 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690DDC069A
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 09:26:09 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id v186so5303818pfv.11
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 09:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rKCVWP7FIIU7BgZxtc6EyrwLnzmtzIxeIAnTHdFwD/U=;
        b=coHFMAKYh2BS4oIDUm9dQT+Ecx0mhd33XzGXexHxdw9zo2duBhJRxJleyyvFaHvurg
         7aFPZ2cxj0Quarg3hQX5nedsCbJmm4My4t41pHH9ePWbAfM2KVxoljjysdeYUtRNCKNt
         IZAmiORFQ5upmbkZrBRdvXbnRTRJaJ5+B+NxgS6flV/XK0tM4yNFGm2tT96APkYN9bDM
         QdZrlyLIT46Ik0V6a2+MALwF5BiJ6YSdyxrFTdY3znZC+OgDYcdU7fxA1t66iL/8O8cj
         y7hROlJOTdApKGKqKKyvVk5QnjXDdv0zC6uwjwJbFFRZEBVvazlF6V/3LfygXv6c1C4c
         e+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rKCVWP7FIIU7BgZxtc6EyrwLnzmtzIxeIAnTHdFwD/U=;
        b=OlobcwhpGy0WosCQ85/qQGkD2tIsFcAxE4DPEHibRYshq0GpShyQ5UUXIfLzziAbhE
         2ekoc1TngKJ1gL72m/KNrlpVcDCD7VMIu/mMLamBdGXSksmNVY54UvWNPt8w1+AUzJw+
         RB0dGWplC8OXJADWOlByXvA4zLC4rHGWrML8029Y9jwwS3ZSVv0/5Qh8xcHtY7jg4gxs
         la2bEKGMa0OequwsWaxAvFjjQtIP8vKm2ushViRt3pcWlp+Fykk5DjfMwkdpt8xqKGLI
         jgr8BfLL7zIxSkOxKLnxavEoAJ+x3p17PketEQ3xYmcHh1rVksN3ficnhrP2lA8yY1Fe
         h2TQ==
X-Gm-Message-State: ACrzQf0CzPBYB/gWuAZKwpptPgeo3+SGaENxEjqr/W8tQPYtA6bhsicY
        +4v9mM0OKX/7rryMv75MJ6ZI+UX74PRwKw==
X-Google-Smtp-Source: AMsMyM7c1si2JIMyEnDT94/CdAEWz6qQxWsRGlJhQJip9q63r9p1voa/h14fw5ISS0N5tz/rG+Gmzw==
X-Received: by 2002:a63:8743:0:b0:45c:7ba1:54ae with SMTP id i64-20020a638743000000b0045c7ba154aemr5058555pge.545.1665159968869;
        Fri, 07 Oct 2022 09:26:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u11-20020a654c0b000000b0044ba7b39c2asm1875855pgq.60.2022.10.07.09.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 09:26:06 -0700 (PDT)
Date:   Fri, 7 Oct 2022 16:26:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 0/6] KVM: x86/mmu: Fix wrong usages of range-based tlb
 flushing
Message-ID: <Y0BTGmuFCoiopUmR@google.com>
References: <cover.1663929851.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1663929851.git.houwenlong.hwl@antgroup.com>
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

On Fri, Sep 23, 2022, Hou Wenlong wrote:
> Hou Wenlong (6):
>   KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
>     validate_direct_spte()

Only functional feedback from me is to move patch 1 and never introduce
kvm_flush_remote_tlbs_direct_sp()[*].

Stylistically, please wrap changelogs at ~75 chars, several of the changelogs
wrap at ~60, which is too aggressive/narrow.

Other than that, looks good.

[*] https://lore.kernel.org/all/YzSz1bFwD1XQ%2F%2FyY@google.com
