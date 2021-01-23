Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51038301160
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 01:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbhAWAHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 19:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbhAWAES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 19:04:18 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97706C0613D6
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 16:03:38 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 9so7168733ybj.16
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 16:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=huNlIJ7Yg75JoKdNsl5GEWjhm3+dWcG2HYvnr3aNRuc=;
        b=szY1n9iTsc/aaqj41mQ3HmYUSlKuHHupuib3xZUD9DyiOSeFw9sORxon7bApTIvxJh
         71u7D2GJgBezhMnEzszrGWnoBMGD1E31yIi9LVNx827d7m39p0QnOQkvpmbNlafQHvTR
         93J/KA/AgoHEodiIxjn7NDyopvVg3vUWXBpkIrJ4iPjm5/S1Kij/inN52V9hzcnusg3t
         HAeUJdM24uelQ9qAl2c7LQMBKHevbSxAfYIg25qx3lcTruPUSeBVVB35Nlp7cj6ZIjUb
         CZVIQ8Ny9WEhJwMyCdVbclIHI/RJgH8nztNZ1pngqDit3NdiAJgzI5bINot/OyjRAG2c
         h63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=huNlIJ7Yg75JoKdNsl5GEWjhm3+dWcG2HYvnr3aNRuc=;
        b=aa3enEBKn2iEITsXmLk0wppdyxxgFNTdLUG/Wz7Uu/v/ijB8l4EVwbZjHOw0QadF3L
         +6oR75M52QQDSqvsJz06PxPyMwsAzJISQfBxlaKfCc2Su2UkUQwkL/HQ3TKyfUhU9VK9
         NlQHMdBA/9j6YluwMw/hGUcsaK2EAOG5ly4Ar7PjnwMpLkomAxtKeYvCnfiaA8c+CuTF
         fJgVZ2fCOI3qYIJOJ/YoRG0s3/ep3vjB8GSrwIcHbf+Kge+gM/y3ky23jQDBbEqjS1Hl
         joXgzRd+X//temsIRfqhreU+XJcJhcrTquS2m6OXxvgjWgZ87vDZDU2V6wKKS0stiOnp
         M0/w==
X-Gm-Message-State: AOAM530jzRSgkg7zQvwc3nhD5L4TJlQ5sIGDZoVDREIshLxl5pXztlI+
        OekzTmcbFIw3A5+1vVpGaogIJaiC7Rw=
X-Google-Smtp-Source: ABdhPJylkXbvRZTR5m0tqnFQUTNKRv6PkJ+Bi3QAo5kYyYoKj4yHKAnYaQAQfnzzkicXxVRPZCGtEBzpC8c=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:2388:: with SMTP id j130mr10249555ybj.301.1611360217905;
 Fri, 22 Jan 2021 16:03:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 16:03:32 -0800
Message-Id: <20210123000334.3123628-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH 0/2] KVM: x86: Minor steal time cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cleanups and a minor optimization to kvm_steal_time_set_preempted() that
were made possible by the switch to using a cache gfn->pfn translation.

Sean Christopherson (2):
  KVM: x86: Remove obsolete disabling of page faults in
    kvm_arch_vcpu_put()
  KVM: x86: Take KVM's SRCU lock only if steal time update is needed

 arch/x86/kvm/x86.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

-- 
2.30.0.280.ga3ce27912f-goog

