Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6915FA8B0
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 01:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiJJXmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 19:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiJJXmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 19:42:40 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4424606A1
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 16:42:39 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id b5so11445874pgb.6
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 16:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xqKkrd2lu8Xh5cK4nDD5aqyR1yEiOSkmlLZm4AZ1msI=;
        b=MzG0Nv1OttzYFH9m0+tas4lWCg7XvlwCS1ow5JSWFcF8+2rJ3/LgtnfVIlQxfVCjrB
         neKrbprPwLkqYeTnxO67j1SX6uUq/BZoyR5EHb04o+EKlVZvgVE+j3Fhb3G+YFtTkPRi
         bfg4jbHw+Q8dPxXNBeQXubOv8MvqUsKiWhFqX9StjwWRkgdnpFCqqiWiVkSyx3+UeExG
         0oKhpzyLMah7Bipx/sQK8RNoWOL92BCfSB/xqzeA9MhiwYXoU5jS4bveEH6ZnNY5ePRB
         dP9AMXMqiYolaJeOFD06mzFJiJbFcYuluOWFUyYQ/f1ByDxtJSyAI/hDi2JRXspoIHbP
         xktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xqKkrd2lu8Xh5cK4nDD5aqyR1yEiOSkmlLZm4AZ1msI=;
        b=Nv+tL6jrKxjXfkMu4p2vWr7XYpi0zT8gRkv+eH82vVD4VlSZ2VfvCJOoDa0OyEBu5X
         gBWnc6bebceSFP67svam/eLbOrP19lzANTNjBwgd/2iIpoE3+0P5pjOL8RnyGvntL1gR
         ThK6XEudDyJ3JBcy04MqG/9c/WksmCC8AdfSEQtXg0PJrO7Nx1xkpDUGfFzwAs9QocpV
         V6DA+/ycqXbQnmeHNF/wlz8j7CaJjIlwPBj+mLV2PGrjJQfRr3A0i+YaLXYxBVafN/KJ
         l6RFKuafh21BZt2MoCob6juQsB6UmcxhwsPnQn4WBwJbrGIgHF+kAgdNvM7Z98VWo+Zc
         tTAA==
X-Gm-Message-State: ACrzQf2sf/RanqeLe4zMswrNrFOo6y4C8VCSfmehSO5NT94hAcM6MrRJ
        XPFaU0XpBP/649K8rmtabcExrQ3EPCwt3g==
X-Google-Smtp-Source: AMsMyM4xsSkyxrAPgNx/5WRz5OelrZz2xuUcBH4v6o4h7k07ihNbhwTkKhJSZcxnJvWuBj1USTHL7Q==
X-Received: by 2002:a63:513:0:b0:462:f15e:5efc with SMTP id 19-20020a630513000000b00462f15e5efcmr5273576pgf.113.1665445359150;
        Mon, 10 Oct 2022 16:42:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w8-20020a17090a1b8800b00202aa2b5295sm9645352pjc.36.2022.10.10.16.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 16:42:38 -0700 (PDT)
Date:   Mon, 10 Oct 2022 23:42:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 4/8] KVM: x86: Store immutable gfn_to_pfn_cache properties
Message-ID: <Y0St61s2ec41Icvw@google.com>
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
 <20220921020140.3240092-5-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921020140.3240092-5-mhal@rbox.co>
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

On Wed, Sep 21, 2022, Michal Luczaj wrote:
> +int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
>  {
> -	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
> -

I think it's worth grabbing "kvm" in a local variable.  It minimizes the diff,
and we've had cleanup in other areas of KVM to replace repeated pointer chasing
with a local variable.  I'll do this in v2 as well.
