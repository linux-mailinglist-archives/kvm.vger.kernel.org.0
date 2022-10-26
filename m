Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DE160EB97
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 00:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiJZWbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 18:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiJZWbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 18:31:07 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88754118781
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:31:06 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id k22so5280898pfd.3
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PpTnjN/+2hyr3jwibCEvE9NjcnyxcbjRhNVuW6NzIN0=;
        b=ZtoitwBxCHtbV4pQjW6FZF+oy1WzSBIBzqTnB4CUrONscxpVldB1SSfOlXJkRRtqDN
         2FaPddVsJSa4mZZLwfERcbY80oS3IkjHrrFP8Dl0RcMNLpQ0YSu9WkD9r0LlASZCS1lx
         NqIFSqrPF4Q1X+oIt1rJc/Ev9+Ctimu40I5hwxEstTH6Vx1SzruW5Yj33yAHcg8u2/ky
         t+XwKcqZJRRQ4Qd4l09HIJ2ukqm3X4YeyBG1pMwFs/IDdJrTLMipibGF/mthyulWXbkx
         ltkHyxF+2ZsJzgMBPQWS59vIanXv7c2EUDmvX7lte89YaVwN96YK6KHpyvMeF+8hf6Mm
         EowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PpTnjN/+2hyr3jwibCEvE9NjcnyxcbjRhNVuW6NzIN0=;
        b=leDzDlqF8JBxW7AXXmK5YSZbFZgoonPo/MVZ3pVOtavyLiJYP39yfMCaK+EFUpcOs3
         ftm+vWkGIQVYLySnEMBwgt9mSy99YBz/QmHJuoIC3lxg7JX9bOtnbMKRNfRJ27L3lfNw
         N36/SzEBRy47L36jYDPm7tOJCVQl7OTP+Y0pgHQVNEXllr06wUqjM3ggAPrlTMif6waa
         oEWmB6OsvdcjKSXcyI+wt/HJPM4Lu73knRuv/LJ6VKh+yte1ZP4WYuvcFMzCWYxlSqz2
         X36xS4Oe20Z6gyhbjRRzaziFFTf2Q9JjEs12NQvIrXJ+XrwjLtKsGy9iWE8vU1X7tM9j
         iUlA==
X-Gm-Message-State: ACrzQf1d+Jfh5jNH7vS11fv+L3KgFTQQeOh1OQDXq5nIpKE1OyeY5nG5
        XvEtdF2MK5g7NtuBTb8l7WuT67N7wzyeoQ==
X-Google-Smtp-Source: AMsMyM6bar2AE6sJe85gUEXBS22ocKkMAhvZ6HVrnsP45000FgnRmCg0qlWF1XG9pj+bu/HjdyTg7A==
X-Received: by 2002:a62:a512:0:b0:536:e2bd:e15e with SMTP id v18-20020a62a512000000b00536e2bde15emr47019512pfm.1.1666823465947;
        Wed, 26 Oct 2022 15:31:05 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i3-20020a170902cf0300b00178acc7ef16sm3370252plg.253.2022.10.26.15.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 15:31:05 -0700 (PDT)
Date:   Wed, 26 Oct 2022 22:31:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 00/46] KVM: x86: hyper-v: Fine-grained TLB flush + L2
 TLB flush features
Message-ID: <Y1m1Jnpw5betG8CG@google.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
 <Y1m0ef+LdcAW0Bzh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1m0ef+LdcAW0Bzh@google.com>
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

On Wed, Oct 26, 2022, Sean Christopherson wrote:
> On Fri, Oct 21, 2022, Vitaly Kuznetsov wrote:
> >   KVM: selftests: evmcs_test: Introduce L2 TLB flush test
> >   KVM: selftests: hyperv_svm_test: Introduce L2 TLB flush test
> 
> Except for these two (patches 44 and 45),
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Actually, easiest thing is probably for Paolo to queue everything through 43
(with a comment in patch 13 about the GPA translation), and then you can send a
new version containing only the stragglers.
