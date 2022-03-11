Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFAC4D690C
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 20:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351086AbiCKTVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 14:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351083AbiCKTVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 14:21:30 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D981CA5D3
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 11:20:26 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v1-20020a25fc01000000b006289a83ed20so8123411ybd.7
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 11:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iXUDk7TrJlm1QOyLX+NxkHA4lehzztyAWo9ut7fzmsk=;
        b=pX2g3pHxPMqugiHJe+B5zYkUUl4FJBmA4Sp/mcZtGsow2wD2VZKpivb8d//3qb8xuj
         I0klA4Z6dSivc6W+O6mPUEE4u+hNuw+lkvoFq3e8XBwOk8av2DMYmxb+YjNXYmU3SNlk
         vVavqGcASFkobPdgOj2r4IE2RWt8vZH93BKi58OYRJgFZTYUCGOzhAkVLDwcTZNs/u40
         UpcQ2wjFF2WKZilRrtiuulhjf6ixhJmipjayKgRv6MbqCBu+T11FaPbpm0G4e1MeMoXI
         VjK+kuNXkm3SMwvFD8ZduyReEx+FEtWlW03x3yQHR+qrBe7bdmMcBukdu9FW5CwtPIX1
         hARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iXUDk7TrJlm1QOyLX+NxkHA4lehzztyAWo9ut7fzmsk=;
        b=Z/kG0tOBHL2VmNDavPwr7/R7CzJgv844UsmlPfhhsUymA3pUGMGNUC55RcEakTKAg6
         SrVf0m2qvE5klPokpdb2gKUByjw/NmlcC3SN02WI87HFyeTwVuXKB+Ebt4/7aqFYHNic
         O+woFFqyaYqK8hvEtGlBjE1LfQYEQWROazCzDF41HMdjnDKdmdD7E7y8s/39SKWkGnAm
         /94gjzx0lpK+/g2M7ZtgMS4qrvql3mttjVkJMKMk193TzK+yr3YgdOuyILfJhtLvYohx
         sG8vg3lW315aedzXMIaPJyRiROdiWudOiP0IHMhgpglRV02uUsbd+HT4SZnATEFJVf8M
         x1+Q==
X-Gm-Message-State: AOAM532HaxzF20Hxx8eQQCVhfx3ewJd+y4n+v8vtyK/yjQmwMgd8fXIK
        vP/s4xtxU3EfwgsqclUSYIFfhCOh1LPkaA==
X-Google-Smtp-Source: ABdhPJwybyxxz79cCgbHhbb7VkGguSMUiuMhAuO8jFP51i0YOQyFPjtrceIJkQTnvybYxlUT61Yo1YcMtOSSPQ==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:28b])
 (user=shakeelb job=sendgmr) by 2002:a81:3d4:0:b0:2e2:af31:ce2 with SMTP id
 203-20020a8103d4000000b002e2af310ce2mr5537135ywd.290.1647026426012; Fri, 11
 Mar 2022 11:20:26 -0800 (PST)
Date:   Fri, 11 Mar 2022 19:20:23 +0000
In-Reply-To: <20220311001252.195690-1-yosryahmed@google.com>
Message-Id: <20220311192023.ocjybjc6q2yozrix@google.com>
Mime-Version: 1.0
References: <20220311001252.195690-1-yosryahmed@google.com>
Subject: Re: [PATCH] KVM: memcg: count KVM page table pages used by KVM in
 memcg pagetable stats
From:   Shakeel Butt <shakeelb@google.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Junaid Shahid <junaids@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:12:52AM +0000, Yosry Ahmed wrote:
> Count the pages used by KVM for page tables in pagetable memcg stats in
> memory.stat.


This is not just the memcg stats. NR_PAGETABLE is exposed in system-wide
meminfo as well as per-node meminfo. Memcg infrastructure maintaining
per-memcg (& per-node) NR_PAGETABLE stat should be transparent here.
Please update your commit message.

BTW you are only updating the stats for x86. What about other archs?
Also does those arch allocated pagetable memory from page allocator or
kmem cache?

