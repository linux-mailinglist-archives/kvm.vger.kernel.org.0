Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E4F52E0B6
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 01:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343723AbiESXov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 19:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343678AbiESXor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 19:44:47 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109FB1207DD
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 16:44:41 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i17so6037368pla.10
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 16:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T7TMhWp0SAA5jCPI+KmjChJGEDhSNE7gjRtO2nBQMRY=;
        b=BzegkdqL04SDprwN3BH/yJoSzWsLHcyLmAGGCEygbOdvHy4tYEJYBiKWOptkLQozzC
         HyDWCA3IvrWI9y/I4CdWbk1sDNCn/9d0MLbjeECNUWs6jJoKwb6C8dLGQ0frIy+owMvD
         ONHfSqTfyu6HoAcMV78W6yWv3NOt4V5b+TtXodoAwFzCRyIx3dBKRQIhKfejJpFNDlSY
         JxhrLMvqg9MGPoYnDAxQlJZvV24y3ef+V+o+GBOiZaWeH+8UpkEP9qfU8M7zaHpNZOMx
         HdD4qBq8iNGMti572kJjIMhTiHehFb817O24qw59XZQ+rnuGBMn6vVQYxK1Ronei/2aV
         YJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T7TMhWp0SAA5jCPI+KmjChJGEDhSNE7gjRtO2nBQMRY=;
        b=oL2d+q46QiRKhdwMlIPWdtyz8WfBBVSBvObHJCHLooI3BXmsI8JhEVgRSgVlKeraxU
         e4Ktky5hevud5zqRpqfKpqmCiPXsqD4E8G1JlbJ9vrI9ggZIKizFXiOOi3Yfl1Zqp3gU
         Xomp/g7tE1X5tfoLYgN6IsVia0EwhzRua2vXfSnTmfztk9Ihca/Zx1tvUPgcKGMoWEJA
         qg9J3SYf3HWAMPE4Gu9p+p7m0MQWlGNaa2Lgs9CWe90u7LQieQzr7ET16ArpqkYalG5A
         5clGu9XkvR0SnJTBhayOMj7HHBsXtkGZyLPdwKuoxeSN1MP5X3wvXdxIj8YHb0Fyb/mI
         fuwQ==
X-Gm-Message-State: AOAM532s2BDUP61JSEgDmFvRnr8a08hTWKnZ7j/+sORwe49p2UEEH9Xm
        Y+cpMoe1CIEZi1MonvdPMGfIJfeBbpJg5Q==
X-Google-Smtp-Source: ABdhPJyHFOCMJV+CyCoxWknfQ8NqR0JS4gDvoJu+C1UV67ZhJqkTrdelVCUD8uOqNzc2ybutuw8y7A==
X-Received: by 2002:a17:902:c409:b0:161:b135:87c9 with SMTP id k9-20020a170902c40900b00161b13587c9mr7135944plk.94.1653003869609;
        Thu, 19 May 2022 16:44:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q22-20020a17090aa01600b001cd4989ff5esm352938pjp.37.2022.05.19.16.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 16:44:29 -0700 (PDT)
Date:   Thu, 19 May 2022 23:44:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 20/34] KVM: x86: KVM_REQ_TLB_FLUSH_CURRENT is a
 superset of KVM_REQ_HV_TLB_FLUSH too
Message-ID: <YobWWW1gzZtmL6BO@google.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-21-vkuznets@redhat.com>
 <6c9add3244d86080ccd8c3c72a37b9ee112d45b8.camel@redhat.com>
 <87mtfdubro.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtfdubro.fsf@redhat.com>
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

On Thu, May 19, 2022, Vitaly Kuznetsov wrote:
> This, however, made me think there's room for optimization here. In some
> cases, when both KVM_REQ_TLB_FLUSH_CURRENT and KVM_REQ_TLB_FLUSH_GUEST
> were requested, there's no need to flush twice, e.g. on SVM
> .flush_tlb_current == .flush_tlb_guest. I'll probably not go into this
> territory with this series as it's already fairly big, just something
> for the future.

Definitely not worth your time.  On VMX, CURRENT isn't a superset of GUEST when
EPT is enabled.  And on SVM, the flush doesn't actually occur until VM-Enter, i.e.
the redundant flush is just an extra write to svm->vmcb->control.tlb_ctl (or an
extra decrement of asid_generation).
