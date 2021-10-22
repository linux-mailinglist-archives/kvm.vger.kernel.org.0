Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26765436F32
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 03:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhJVBC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 21:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbhJVBCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 21:02:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE105C061766
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 18:00:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b126-20020a251b84000000b005bd8aca71a2so2300349ybb.4
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 18:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=2UgrQ0TbtiMygLAQ30KfcdaZWOVXfYDqo/7DzZr+kXQ=;
        b=byM4g7M7PQ6D9fyuA99DCXow3SbtSFZcOZHnjVJgMCkmnQpxYhRff/XgUrEh9Vxg1T
         nmz22mu5RQ389eShoWaL3DnSFZKvNBs25oHnbbyhf1WuZfWXjhMr/USNfZfNYkyhsSl6
         zOXDlCiUxaZy+qIOMhYDAdyQd+s19y7Ri1jT93ynQFPLYyxtLZvt7aUpjg3TYdk9aR8t
         CzTJ6whgeBUQwbqMW/jQx5Aa3WAM334TSkBgG5wIhKfj9EKluyZw1knuMihj3p1gA9LE
         7/YpB4xWuPsGmlJIMBlqXJ3aOkFq763Vjgzw66YdNfOvYAENSFS0DEuslpVapCgeFvL3
         ahHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=2UgrQ0TbtiMygLAQ30KfcdaZWOVXfYDqo/7DzZr+kXQ=;
        b=UiOD878ANGHJ8w4dJWcPcVi9gIOUTsyhPS1s1VkNi/2+X1DvSMtKRPFujuviIjqN9m
         +Dz1WY3Llm0GZZshSLSZ7Z1pgIs+zpHaVyXaA3FP134D90bAbjCbHFYV365jDyl1YIAc
         /lHY2fU/+loSPNMDWVcKOOr9X9ETNPah6dQGpsOeub9Afi1o6b5774ur/ZdCjjMl7fCK
         XfC+LEXDnuf7HvVCbo1fEfK0Yz9+xHTYVTFGPkI+oTkGXPIQpHUhGASU4gxoPzjl22cb
         4jJzWSPcHaNaH1ZwscP/nf7Qb10oDZPbh2nNqwWSnptnkh+bg7gHq5oe7+ab2x+DWnk7
         lt8A==
X-Gm-Message-State: AOAM530+Hb365xP3dK1k6gFKEQWWTLeRYiDR3TX07TFvotZxdjNGtnsS
        y4ophiS+Ggwg+ochvLJKOWYIhw5HRbY=
X-Google-Smtp-Source: ABdhPJyGehmVoo4k9RzI/CYf0VDRHZeq6+k4r/GhNtjW89q9nT4bvfEEaLKrZ1l/mRdMJYXQyuzlxB5dU1Y=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:db63:c8c0:4e69:449d])
 (user=seanjc job=sendgmr) by 2002:a25:8411:: with SMTP id u17mr10278689ybk.376.1634864408165;
 Thu, 21 Oct 2021 18:00:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Oct 2021 18:00:02 -0700
Message-Id: <20211022010005.1454978-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH 0/3] KVM: x86/mmu: Clean up kvm_zap_gfn_range()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix overzealous flushing in kvm_zap_gfn_range(), and clean up the mess
that it's become by extracting the legacy MMU logic to a separate
helper.

Sean Christopherson (3):
  KVM: x86/mmu: Drop a redundant, broken remote TLB flush
  KVM: x86/mmu: Drop a redundant remote TLB flush in kvm_zap_gfn_range()
  KVM: x86/mmu: Extract zapping of rmaps for gfn range to separate
    helper

 arch/x86/kvm/mmu/mmu.c | 61 ++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

