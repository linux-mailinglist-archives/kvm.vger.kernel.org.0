Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5328B58AE36
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 18:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240682AbiHEQc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 12:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238340AbiHEQc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 12:32:57 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0959C21BD
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 09:32:57 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id iw1so3076808plb.6
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 09:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=uNgIMraGQEvJv9IeiG/R7BNNwOlVOtJOj1OBE03AYVc=;
        b=IMDsjfU19RQWCKZgtvsrA4L1JSG2IHZwW/p00vXlnMhJ9uJbqkXAh47oo+H8I709mF
         7esbABe7yH96jMFRabePARNdoJg1ikr5Bdd9mXtja3aaQ3MwSiZOvtCGHUJO5i0AXwka
         gtFV3uo5QaPeiNcLpcaqkkfeRwGozCOTvKyViQ9LXmV6yNLNlO3lWr2takPdFveyA/L4
         UWl7bnuhF7ogFsroOh3O01FxaF9FZOFbbof4p7jpbprGY+iBAU3xcA2LhrpkquCSFwTf
         oUwVzq3ywVt1qaKdzW6tMyNAqqgH9XefcJpi3+Y5YUwDZTgJSbxnjtgDfE1poI3KflwQ
         HwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=uNgIMraGQEvJv9IeiG/R7BNNwOlVOtJOj1OBE03AYVc=;
        b=sVqwI8vZ4lbpG3IN4wPte/WgPZB+j/o6svnCmAm+DxgrHE9g7WVlBxljtxe0Qj+5kw
         dJq1JN1YJUhYAfz21CRY8Y1IRrWlYi3sFbUMyCLvu80fnDoZj/ZBYmzd2WdOIpAtyP61
         1iqExu9DNXC5YZxrmypd86m54WNODLGMd7VEhsm5RdFNxXB6z/Uz9PxhA3+5Zg117aJ1
         hq9EnHpQuPiwISN1jYm69CI4zuybeT+6IN8E4TTtt/zwQN07bPi6LH6dR9ZqBnXBouDs
         uVLEAZ5e4UcZ0tDo4EVxI/IYUy6nwAO7ozdBSG278MDYqTsUlY3T9Rm2PRLKEYcFw20y
         WOWw==
X-Gm-Message-State: ACgBeo00cs0RbWdN6dZDymNFtkGAu33IacXOdZXkPiWemSNRVgcTtWMd
        8nM6Ctbx/TqFzoucvAs+AYzYKw==
X-Google-Smtp-Source: AA6agR6U/hjD0gicqlU8MA3bvqOWWiO96pQCKsrWlUptyhWQdL3nxYqi8RqEH4sQQGUazQM5B2m61w==
X-Received: by 2002:a17:90b:1b07:b0:1f5:115c:79a4 with SMTP id nu7-20020a17090b1b0700b001f5115c79a4mr8458855pjb.166.1659717176367;
        Fri, 05 Aug 2022 09:32:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a205-20020a621ad6000000b005289fbef7c4sm3341986pfa.140.2022.08.05.09.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 09:32:55 -0700 (PDT)
Date:   Fri, 5 Aug 2022 16:32:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: selftests: Test writing PERF_CAPABILITIES after
 KVM_RUN is rejected
Message-ID: <Yu1GNEDQyrdgnV/G@google.com>
References: <20220805083744.78767-1-likexu@tencent.com>
 <20220805083744.78767-3-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805083744.78767-3-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> KVM should also disallow changing the feature MSR PERF_CAPABILITIES after
> KVM_RUN to prevent unexpected behavior. Implement run_vcpu() in a separate
> thread approach and opportunistically rearrange test cases.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 49 +++++++++++++------

Rather than add a one-off PERF_CAPABILITIES test, I would rather we rename and
extend get_msr_index_features, e.g. call it feature_msrs_test and then have it
test all feature MSRs.
