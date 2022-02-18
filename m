Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5954BBE84
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 18:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbiBRRiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 12:38:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238677AbiBRRiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 12:38:01 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4550275FF
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:37:44 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id c4so2835318pfl.7
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0PWeW9TOznAf0ie4DW4wq8JQF3QFYCHLxww3wrnBvIU=;
        b=EbN3I3lYaAI7NQqvx2UJS389LeGKPjaMtDfqoQzJTN0G61W24z//yc8dPA2PC1Jwcj
         CxxC8sGYs92+Cw1MCQMex93ncWLm+H8G5pdH3Ry6QuT9jFVs3GGhlYg6QF5O0fI1DvBz
         3id1Oq3H7wJh/dM/4SwVGarwAIHBWsQCypbX/vWMEAJY+M6f7VmZdRzMmWqhAoE0G6Y4
         YBHGvmACdfu3onCnIsztcLT4AG1BwCAXWFDkKX7iPMJLf/V86WyqVBGa+Rr4vBSLJ+yP
         bY6OmucqxeVD+gad8EPQKp68GfsvXUEUsytdnoBtGpTbDmm+8fR6ISafdWhx/CmbD1pu
         +bgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0PWeW9TOznAf0ie4DW4wq8JQF3QFYCHLxww3wrnBvIU=;
        b=HiZablLyeZSM0aLbyG1X70iWdWd1BVqkmhT56nYrfYf45nBhfNeaq2I3/+RXbMsciT
         vh9IxI1eKsId/yDZqmC9X23r5EOJmDeeFhdRuUGIcbJaae0OWY1h19VQhCGgJT7xYsdw
         FJR9kbJlzzfroXPAqqor3X0sEEPloD0Un2p+vEDcPW3ZEZysfBQ5iQw+rWbfQJz2y/Je
         iGyw9H3+bAarj+f+iioGl4Hakc0fg5AycAnyLkyigKBLghIANSo74f+gqk/tICMVQRBL
         YVYaFmdK2Z43LrzyVoL6iLYbRGSSap0OIFhAv0QGqOgeLhB5VSHAp/SGKzWVEwvkr8V4
         neSA==
X-Gm-Message-State: AOAM532jXhb+BkZ2gcP6uXNyzwA1tb2neNd6hPaDkxqh9qyihTMnQGcT
        WCZ+VzwV2LfrElqQ21WilOrGc753YU8p0w==
X-Google-Smtp-Source: ABdhPJxPjF9hfb1SnD6YEsWPIM6IK1NZPPVDWfLQopr0tBJG+dQxi8BDWwjveHiXvj2DocWKtP9RmQ==
X-Received: by 2002:a63:d4e:0:b0:34d:fedc:46e1 with SMTP id 14-20020a630d4e000000b0034dfedc46e1mr7160586pgn.407.1645205863942;
        Fri, 18 Feb 2022 09:37:43 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c23sm3527710pfi.136.2022.02.18.09.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 09:37:43 -0800 (PST)
Date:   Fri, 18 Feb 2022 17:37:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 5/6] KVM: x86: make several AVIC callbacks optional
Message-ID: <Yg/ZZMAz7XZ6wn/u@google.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
 <20220217180831.288210-6-pbonzini@redhat.com>
 <Yg/IGUFqqS2r98II@google.com>
 <eff2543a-10ab-611a-28e2-18999d21ddd8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eff2543a-10ab-611a-28e2-18999d21ddd8@redhat.com>
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

On Fri, Feb 18, 2022, Paolo Bonzini wrote:
> On 2/18/22 17:23, Sean Christopherson wrote:
> > The "AVIC" callbacks are being deleted, not
> > made optional, it's kvm_x86_ops' APICv hooks that are becoming optional.
> 
> Maybe "make several APIC virtualization callbacks optional".

Works for me.

> > > +KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
> > 
> > apicv_post_state_restore() isn't conditional, it's implemented and wired up
> > unconditionally by both VMX and SVM.
> 
> True, on the other hand there's no reason why a hypothetical third vendor
> would have to support it.  The call is conditional to apicv_active being
> true.

Ah, right, even if the the static_call_cond() is unnecessary because we want to
make the hook mandatory if APICv is supported, APICv itself may not be supported.

With the new shortlog,

Reviewed-by: Sean Christopherson <seanjc@google.com>
