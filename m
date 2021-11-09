Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A861444B8FD
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 23:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbhKIWyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 17:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344352AbhKIWxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 17:53:32 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD240C110F30
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 14:23:53 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id n22-20020a6563d6000000b0029261ffde9bso304042pgv.22
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 14:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=kpTVRTG30gb5sZCl4YKhxq65GFDXRjPxhbltBMSsgmo=;
        b=fyYpg6LcGCdHWz5166bjt35JMMxbTcll+RT0DcLpzfCrrvCmGlPFhYHDAbJKQseKDk
         590fjhGfucR5U5CtiYSrXD+f8mY7EHULiHXOKBnmfUaOP7vfzzBYAk+IZZ+iEzFAYRoh
         WpoUMWTGHyxomHNH64RddIemfgCHqUnxS2ZwAToHVPrbyarTzGFfbIarwh+JC0PebZsY
         1oBsRfGOWVioxx3T69uh3GYXiVA1ZfGn7FefO1V2mxbZOK1Pua04ZatKvoVxDSxS1yMU
         1IZICp6lmTgx3YYlUzcvPPX17sw7Gmn4ebce81EeJa1Hn+i48wW0+dV/51V6LbIBM1sD
         6jwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=kpTVRTG30gb5sZCl4YKhxq65GFDXRjPxhbltBMSsgmo=;
        b=D2RrTHvcMhBNTAp7iYXnmhOIiUj8PGipQ8qylQB05oHOrZPHh0swBTR6IQSJ7QS3ca
         qNKIssE316D4vyus9+ru9LcXqmcklQeUNjqBa3mzkCHwBczSRDoXeuV3R5rgNNgKsdc2
         B3SwoG0d6Yz97zRtHdlNMt1/dEfnSo+pxhf3DUpWp//MVdX6ctUGPF271tpWMIYWQk7W
         qCJm3wg7snZR97HnzX34MwKVc+ld9n9XVtKEC5jsm8OVqsEkfdoaimQ3zJaTwbddrbGz
         9B7sYStinOcOuUMku/SQLISAuQ4B4QOGqFe+4/1o+Sday2FByvvZNMlPoxKfXXQGGRJw
         T8AA==
X-Gm-Message-State: AOAM530H9efA2e+uEpv+mN21zFjrJpnXxeX85qm4cbG9NWx7mmWclD1i
        NuDbCNa8n84fule2u2ILbv9cghSD8dU=
X-Google-Smtp-Source: ABdhPJySbBTdtDcaJZoWwUGjaiI6PuTHdGY1VH9cdyB+hlZtOyy2LqPP8Kso19nlBt6aMMACAnVgm7f8rW4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74e:b0:142:fa5:49f1 with SMTP id
 p14-20020a170902e74e00b001420fa549f1mr10858327plf.84.1636496633290; Tue, 09
 Nov 2021 14:23:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Nov 2021 22:23:48 +0000
Message-Id: <20211109222350.2266045-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 0/2] KVM: SEV: Fall back to __vmalloc() for SEV-ES scratch
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two cleanups related to handling failure to setup the GHCB scratch area
for SEV-ES.  Found by inspection when reviewing the SNP series.  Compile
tested only.

Sean Christopherson (2):
  KVM: SEV: Return appropriate error codes if SEV-ES scratch setup fails
  KVM: SEV: Fall back to __vmalloc() for SEV-ES scratch area if
    necessary

 arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

-- 
2.34.0.rc0.344.g81b53c2807-goog

