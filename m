Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C2571F7C7
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbjFBBZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjFBBZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:25:05 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B3B128
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:25:04 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b0116fefffso6554655ad.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685669103; x=1688261103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iK8lSs3YaneXBCRAzbjwsWp2npRQly6WzP0NZm/doWU=;
        b=BTotzJyO74t0U/JIX/3DDJDlMmcCiG9tjBWd4Z9EfBWXPRZa+wn7lmQEOHuBJT7+/F
         6qL97vbIMvSrXN9lSfuQctNufEcxa5CUo531kAHUDQ54g6zkby0TCW8jKf+zZWcjNIzl
         NuuCfPBoMx0RSo2B8LRn6iz8Tds3k5nxJCpAYYEj+3e+vEWjFwUP3CED0DnfCxRdZUBB
         N7377VxP2sqe2ePMi/MOSCbHqL16XXt/EPAA516+UigvQgrEA49k25IBiRkgL+P5LM0d
         IxsdHlICEx/nz2Ni78ePd0XLSzEqhLozVn2ydM49Nv9An06QTpNtiaSjNTM9WG5AtnTD
         14Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685669103; x=1688261103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iK8lSs3YaneXBCRAzbjwsWp2npRQly6WzP0NZm/doWU=;
        b=VpX1NMXnKFgBL8h0H0krd0Eakoj4l4+p7VzQVLEPbN3oUbuo5WBUhjEoas0GlE2SvL
         MgzZV0GXqERJYf5RFk5txBH2L/RFaM8UJgKlm9f0mbRlMEcjWabnWpLBAHRMu+Hqu5xv
         1LzEg/SmkdpyAGmQ4XWTLVOh9tZAp7slY+KxZcFGLm4SuCywNYB2+jU/M5sd7dIUnVTt
         fXIW9iRQu1b2HocJQN75pu0Xgo4EJ83xWF/T9mBVuFV9aIZTzMdCi8XXc+UJRoNythCn
         1/3CGK38/ttkWfnlJL/AZf2f0BJyYxC3ziaOXJh2To1f99ToDvAzrhTqWf8u07YPDaT2
         4Gqg==
X-Gm-Message-State: AC+VfDySi/BCLAIKR/Bg45MItKd5gUlfzXkdW6M5oxkUf6GsDMRdYWHo
        LKXwfhzh4kB4Jhuf60FCYIl6FJed1bs=
X-Google-Smtp-Source: ACHHUZ7XEpebUrUgs1x/mu5T0Qsko+BuvdEyHPqBlAtmZGpYafeD+7h4iwSxfk616ZwZgmqjp7cmInuDCtU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:22c3:b0:1b0:6038:e1c7 with SMTP id
 y3-20020a17090322c300b001b06038e1c7mr255034plg.7.1685669103727; Thu, 01 Jun
 2023 18:25:03 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:23:32 -0700
In-Reply-To: <20230131181820.179033-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230131181820.179033-1-bgardon@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168565341087.666819.6731422637224460050.b4-ty@google.com>
Subject: Re: [PATCH V5 0/2] selftests: KVM: Add a test for eager page splitting
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 Jan 2023 18:18:18 +0000, Ben Gardon wrote:
> David Matlack recently added a feature known as eager page splitting
> to x86 KVM. This feature improves vCPU performance during dirty
> logging because the splitting operation is moved out of the page
> fault path, avoiding EPT/NPT violations or allowing the vCPU threads
> to resolve the violation in the fast path.
> 
> While this feature is a great performance improvement, it does not
> have adequate testing in KVM selftests. Add a test to provide coverage
> of eager page splitting.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/2] selftests: KVM: Move dirty logging functions to memstress.(c|h)
      https://github.com/kvm-x86/linux/commit/de10b798055d
[2/2] selftests: KVM: Add dirty logging page splitting test
      https://github.com/kvm-x86/linux/commit/dfa78a20cc87

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
