Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9324FE8A2
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 21:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355344AbiDLTcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 15:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244968AbiDLTck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 15:32:40 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781063CFDF
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:30:22 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id s14so8072054plk.8
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sKmZh3PaYY26BR+B2dRs/R9LlgovoIyv4Z/3LkpHaas=;
        b=JUDPn7fn8Rx3FHzUo35cOmXSzjdDkCl5t6mkLSekhksynwyH45KuNzU4S/KEOecSK4
         EckijBrri7O1pTEPsDbxyPvQ1CN3SvrN65GC3o3ta+u7E0IkE/pSqbk4pf+tKmmHcUmo
         Jj6eBrapJ9GQGnSraNNGpgG8OyZeLzZZBzb/UcQYLDSZYAWXU8+VTjqsWoBfyYIPuFCd
         BPA6pQFyB6WluM0f1YcCaxEzvdzUYuGR3y8mfK6fyt8VuvP07i9h/X5kHLeE7xcCpniZ
         m3NvAY2ui3PGprmqlQGwxGxlOsfA0TxvuFtbimhYg8uLGB7c2B4jLjGyAE+bFK60sZ0O
         noWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sKmZh3PaYY26BR+B2dRs/R9LlgovoIyv4Z/3LkpHaas=;
        b=oA1ZtjIKTMJBVf8mTgKwSPHXueexAaUB1WexY4+5p2NM1aWHk7oAtdELwejJCOP2EH
         Rld6BNvvdSMjJD2w/ZLQC4tCImb+97SwyGZ4OMiB2PZfi6n73oZkluoozksicd5YfDvS
         xLYhu2jerr6PUm3m93aadv6A6BnWrDcSEVnk5c5bF8kk9n8UoaFvVPFyU3gvOsyns4ef
         myjcWKcBeeCEyOrjb/42IDsE+FXx1VKMvhJ0DHwkxNPrXZPtOMlBFZ+i8E8MvGQbGieU
         DB9irqPEQd0Cp61haNmAYE9P7d93p2DKnK5djY1E8RmnFnsmSK6DXeEY+77oBp4wNYvI
         ArrQ==
X-Gm-Message-State: AOAM532OZoCZ0EfS4O6B3H3b6EY1UlgCSUq9Ukz5tElZqDa3Bixt+P1+
        I8Fo1QUbZ8AkeiusDoM9A1NPXw==
X-Google-Smtp-Source: ABdhPJwl6pkdTRcJsFbNtPiE30Ma4FQuKKrig5lrk4zdsMcyG/04WVvZS5avSOgnQf2aam4QHX4kYA==
X-Received: by 2002:a17:90a:4fa6:b0:1cb:1b77:c931 with SMTP id q35-20020a17090a4fa600b001cb1b77c931mr6773525pjh.63.1649791821808;
        Tue, 12 Apr 2022 12:30:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004fe1a045e97sm28735604pfj.118.2022.04.12.12.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 12:30:21 -0700 (PDT)
Date:   Tue, 12 Apr 2022 19:30:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 7/9] KVM: x86/mmu: Add try_get_mt_mask to x86_ops
Message-ID: <YlXTSQ1k+glvT83K@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
 <20220321224358.1305530-8-bgardon@google.com>
 <YlSzI9ZfzPQZhPqj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlSzI9ZfzPQZhPqj@google.com>
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

On Mon, Apr 11, 2022, Sean Christopherson wrote:
> It's obviously not a hard dependency, but using a u64 for the mask here and then
> undoing the whole thing is rather silly.  Compile tested only at this point, I'll
> test on an actual system ASAP and let you know if I did something stupid.
> 
> From: Sean Christopherson <seanjc@google.com>
> Date: Mon, 11 Apr 2022 15:12:16 -0700
> Subject: [PATCH] KVM: x86: Restrict get_mt_mask() to a u8, use
>  KVM_X86_OP_OPTIONAL_RET0

Verified this works as expected when patching in RET0 on a 32-bit kernel (returning
a u64 results in reserved bits in the upper half being set due to EDX not being cleared).
