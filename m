Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103154D681E
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350393AbiCKR6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350253AbiCKR6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:58:31 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34EB9A4D6
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:57:26 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2dcc326fc4dso74372297b3.16
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XCuvtprnSb0PQ/tTeAtCenAIJT2ThbfBVkwuYC3SZPg=;
        b=kt7/mh7D7/XK6jC/qxq5AKckTCsDG9s1vf0i5tSAGW3qW+PMa+EbHCv7HEUNbZqBhn
         yWZM0d5kwmCn3UPnOiteAwCNH/RHYa1o5c1R5jo8a2mbiVT1BlQdcX08fWiKdTf3inGd
         /wA2Nspc1mpYoqG3077m2DcigYRNrisUBQxjc+WR8l6t9YyToIDr1FoyvzRozet51MAp
         WDbs7eygrxtaCKkB07ogoj7KfiS02MArxQf8AGUZemcSUnL+eKAi/V2jj/IgENgEnisM
         1AWYtPsvAfBxtwunoa98mEFgtQK3j9S0fT466vXE3yggcKERk61aovGUFw/uZZyAQ3CX
         5DFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XCuvtprnSb0PQ/tTeAtCenAIJT2ThbfBVkwuYC3SZPg=;
        b=3BJ5pkrFrDk1oQch+kCqFEPT0V4N2rYTZTvalu9Q/A9tQHQEhgzke8ZcqnD5IVaJd2
         dfMtuI0BNYkFdycxWJTckrxGrBB7mS+Vu38vOPgSQtRQD3+ySiP+KNMVZkaGOprOKctd
         5IniBWyvlGeAz+AaGlNhz0+iM6NJgxqiWQ7PjGnn0QrukKGQJSCEnjTvp1ujoUG/2M7D
         B7VPZ+S+h1OPF/i5T/SkZBW/OG4AFv6ZpXSeoPjmsqYBVtEi57Tx7NuXZINobjm3bFdQ
         AjFA9rrxYkuqYqGIKY5pHxcmBjTzCPVNGuQsXy8xRiBCI+oFZlaYzKwiRen79Ze3IAuy
         wtBQ==
X-Gm-Message-State: AOAM532LXOsj/rYreePWmIDmPXG2+wK3mpBV0Qiz8x+lbcIzIleb1E4T
        LhqAWWLs5MrFOVlqwcgjRI6bfI3sukw=
X-Google-Smtp-Source: ABdhPJzyWAv8S/KHu/ZXZs/nZFoiMKCNOwLwIUWaIPx4cyu6tv+ii6X96+maMdMohSISaf+E5F1ZO7oskvs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:fb05:0:b0:628:8c88:acf5 with SMTP id
 j5-20020a25fb05000000b006288c88acf5mr8952224ybe.187.1647021445912; Fri, 11
 Mar 2022 09:57:25 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:57:12 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311175717.616958-1-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH kvmtool 0/5] ARM: Implement PSCI SYSTEM_SUSPEND
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Oliver Upton <oupton@google.com>
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

This is a prototype for supporting KVM_CAP_ARM_SYSTEM_SUSPEND on
kvmtool. The capability allows userspace to expose the SYSTEM_SUSPEND
PSCI call to its guests.

Implement SYSTEM_SUSPEND using KVM_MP_STATE_SUSPENDED, which emulates
the execution of a WFI instruction in the kernel. Resume the guest when
a wakeup event is recognized and reset it to the requested entry address
and context ID.

Patches 2-4 are small reworks to more easily shoehorn PSCI support into
kvmtool.

Patch 5 adds some SMCCC handlers and makes use of them to implement PSCI
SYSTEM_SUSPEND. For now, just check the bare-minimum, that all vCPUs
besides the caller have stopped. There are also checks that can be made
against the requested entry address, but they are at the discretion of
the implementation.

Tested with 'echo mem > /sys/power/state' to see that the vCPU is in
fact placed in a suspended state for the PSCI call. Hacked the switch
statement to fall through to WAKEUP immediately after to verify the vCPU
is set up correctly for resume.

It would be nice if kvmtool actually provided a device good for wakeups,
since the RTC implementation has omitted any interrupt support.

kernel changes: http://lore.kernel.org/r/20220311174001.605719-1-oupton@google.com

Oliver Upton (5):
  TESTONLY: Sync KVM headers with pending changes
  Allow architectures to hook KVM_EXIT_SYSTEM_EVENT
  ARM: Stash vcpu_init in the vCPU structure
  ARM: Add a helper to re-init a vCPU
  ARM: Implement PSCI SYSTEM_SUSPEND

 arm/aarch32/kvm-cpu.c                 | 72 ++++++++++++++++++++
 arm/aarch64/kvm-cpu.c                 | 66 +++++++++++++++++++
 arm/include/arm-common/kvm-cpu-arch.h | 23 ++++---
 arm/kvm-cpu.c                         | 95 ++++++++++++++++++++++++++-
 arm/kvm.c                             |  9 +++
 include/kvm/kvm-cpu.h                 |  1 +
 include/linux/kvm.h                   | 21 ++++++
 kvm-cpu.c                             |  8 +++
 8 files changed, 283 insertions(+), 12 deletions(-)

-- 
2.35.1.723.g4982287a31-goog

