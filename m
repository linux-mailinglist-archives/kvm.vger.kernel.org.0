Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D871531E1A
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 23:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiEWVl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 17:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiEWVlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 17:41:17 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF8E38B7
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 14:41:15 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id c23-20020a62e817000000b005184501a73aso4615390pfi.4
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 14:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2vetEPlpDBl0Qvi4RegcmAW+O4fXPrjUjYZsg6ZwOBI=;
        b=eHVkWvRAzZwKyCxojcQIajgBsoy5I0Wd8kG4AjPsgHJVkuGxS646nBjA8KOpGlbnY+
         3Igdfbx9bzD91pPobVIJNkikslL5nj4ySKSKQ2hOL8utddPU5nxkEItxGrpnZIHALaCd
         nBh9dHZXWrxwkGhKl5RSdwJc7dpWWgH3NF2zXmH1LrNtWXCbVynymChncGHHR+G0pGre
         WYtZTjmP66F0xmhJtXEXhq1y66rpo68X8o1aqRIRXLEK+Jmn4bcZOMO5WsRxrVjb13CJ
         id0Y0f+bjthcsLDtjhmQJLZtre36Lan0c0cQGGb00KL2vZD7W5POvzTliBKjLHBceCCW
         Jxkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2vetEPlpDBl0Qvi4RegcmAW+O4fXPrjUjYZsg6ZwOBI=;
        b=5HwlVQh8Z86sj5FsVIM5Zv2mthVZA6EOxhB+0PGCCJ4WHwmW+obI8bGTNd1uqJdLAe
         /PQfnazNuZpDNNr9iXGJG3ta/ENOGxjxnrUZUnotbhzyGLa2bPM0f4bjZt2/gHGBRovn
         GvjDktlUx8wQH8EILXLMnBWYhaw/JQ/hZHZgv26ReH3n07oDPLArj5ujn5hG5Oq9UPJr
         CeHh8d0s5LlrAArlaRxV+VKNmKmyIz9TKYxPmvX8C081OqxF/quadJ7nzAafjWQlUXvS
         nr6zHZY76ZwIVNG7jiupK3eKP2w3UXZcNu/sdjLfbIvSdf9iTdyQIWpw2TGJTewc9Rhm
         sn5g==
X-Gm-Message-State: AOAM530dwBgtfAhN8UdSgH/+APSaePSAXURPURRFpw1FAnf3lanAPbCW
        pl6fvDa9oqur5YPxvIMHowm6rGVWEoowPHflIrHO8DFgluaC/5Cbo2gazxibOg4sIymvZZ8vxvK
        pPi7BoIrBfsO9v5+uJVQgX6n3Zj2W+UySiphkFciSf3BbUgS4VxMcrtbOKLK1IxQSLgJ6
X-Google-Smtp-Source: ABdhPJxnIfQdCfBpTyVty9A9uVn9W/q1WyUbWEY3axEWXqPwp/icSaGJTaojWHUV9qaTjWMMsFjNzgcbBaT89fSe
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a65:6b88:0:b0:3fa:1a35:fb89 with SMTP
 id d8-20020a656b88000000b003fa1a35fb89mr9082110pgw.303.1653342074921; Mon, 23
 May 2022 14:41:14 -0700 (PDT)
Date:   Mon, 23 May 2022 21:41:06 +0000
Message-Id: <20220523214110.1282480-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 0/4] kvm: x86/pmu: Introduce and test masked events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series introduces the concept of masked events to the pmu event filter.
Masked events can help reduce the number of events needed in the events field
of a pmu_event_filter by allowing a more generic matching method to be used
for the unit mask when filtering guest events in the pmu.  With masked
events, if an eventsel should be restricted from the guest, instead of
having to add a new eventsel for every unit mask, one encoded event can be
added that matches all possible unit masks. 

Aaron Lewis (4):
  kvm: x86/pmu: Introduce masked events to the pmu event filter
  selftests: kvm/x86: Add flags when creating a pmu event filter
  selftests: kvm/x86: Add testing for masked events
  selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER

 Documentation/virt/kvm/api.rst                |  46 +++++-
 arch/x86/include/uapi/asm/kvm.h               |   8 +
 arch/x86/kvm/pmu.c                            | 128 +++++++++++++--
 arch/x86/kvm/pmu.h                            |   1 +
 arch/x86/kvm/svm/pmu.c                        |  12 ++
 arch/x86/kvm/vmx/pmu_intel.c                  |  12 ++
 .../kvm/x86_64/pmu_event_filter_test.c        | 147 +++++++++++++++++-
 7 files changed, 332 insertions(+), 22 deletions(-)

-- 
2.36.1.124.g0e6072fb45-goog

