Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5369056C55F
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 02:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbiGHXXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 19:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237480AbiGHXXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 19:23:09 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B2E419B8
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 16:23:08 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i5-20020a170902c94500b0016a644a6008so39558pla.1
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 16:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=+6AcP1HWw661Qpr+lBZwEqnetiODARhUxEJKO0pVxWU=;
        b=j/tiBmyZblQHV+HNo+8wJ4bia1A4rlEbbmJw7VT15wepVlBA4N3bOcEu5H7Sa5994x
         L0yl+Csc6g1gSFJUeVfxdH9pf4Q4QkPqD17crVXXtT6VyIFLPhUIRF4tV5cfbfkU6wam
         1JlFyQmvSc9lyOtPpXudz0Zkr7v11SbJJupEeV4n9D4geJC0CEoj7cSGQ3bNEwYLytGp
         L52TxW867lXpOW5wNg5ZbMqr7Lwc9o3yi0HB9dxcWi5xKC6iGwRYB0OIGEEbKvhhmjsm
         8ZDo5kSt11btuPU8dH8kPUbsE4W+27qYlWWWi6VvnVEoqoxAX7/BPMj5f3Lyy2FYmRvM
         W53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=+6AcP1HWw661Qpr+lBZwEqnetiODARhUxEJKO0pVxWU=;
        b=S/rqmNaNdgR0HjoPpfjUa8WUGdUpBbRavQbeB+H0COz0EKHZNjBPpsczLXIfAdHs3M
         WtCrpOtDfnZDj+z68d5N9ugN3D0zUI4UvZr83wGYhelDiqKThgSBB0en5HROJ0dl89iD
         nEJhZgxrOsTBT1NpWWe17EmrwVmIsTT1AiuJ8BT/QXLGNCujHQuBpPJq5KeJtijmSeKU
         bVSb2Yl4Y+qdPrLWi8mru/r/VHfHZ2v9DmzkYEn0nIgMUIgRhlm6ahJ7loK8C8H2Hrgy
         +rxTKNdr2lEbGaHV6ZdEJ0tM5YKGlAK3oR3lEoGxpVoYWNw2sYB7sdfB25Rw9Plw3Rzt
         HGJQ==
X-Gm-Message-State: AJIora8k/Uqn+x8X9GNa6C8VspBZCes8UxHOC9HUbECem3TG0OiKy+nd
        KiAI3VdKvhWyPOqJ0X3hasxWTqAVWS2t
X-Google-Smtp-Source: AGRyM1sMnSAK5x1LioJXvUOqDZwyZnrYbj/8VTx9+GqrlJTmSFDKn1x7xTu9SL5jVQzzY+TCHZA1W8+Brf/3
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a63:ea05:0:b0:411:f94f:b80f with SMTP id
 c5-20020a63ea05000000b00411f94fb80fmr5116719pgi.189.1657322587944; Fri, 08
 Jul 2022 16:23:07 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri,  8 Jul 2022 23:23:02 +0000
Message-Id: <20220708232304.1001099-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 0/2] Extend KVM trace_kvm_nested_vmrun() to support VMX
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set update trace_kvm_nested_vmrun() to support VMX:
 - Change the print of EPT/NPT enabled boolean to print of nested
   EPT/NPT address in the trace;
 - Add a caller from vmx/nested.c.
 - Fix some minor format fixes from the callsites and Update the trace
   output naming according to the x86 vendor.

David Matlack (1):
  kvm: nVMX: add tracepoint for kvm:kvm_nested_vmrun

Mingwei Zhang (1):
  KVM: nested/x86: update trace_kvm_nested_vmrun() to suppot VMX

 arch/x86/kvm/svm/nested.c |  4 +++-
 arch/x86/kvm/trace.h      | 19 +++++++++++++------
 arch/x86/kvm/vmx/nested.c |  9 +++++++++
 3 files changed, 25 insertions(+), 7 deletions(-)

-- 
2.37.0.144.g8ac04bfd2-goog

