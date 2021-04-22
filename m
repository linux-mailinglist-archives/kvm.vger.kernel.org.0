Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0342A3677B0
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhDVDF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbhDVDFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:05:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8819C06138D
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:15 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o187-20020a2528c40000b02904e567b4bf7eso18377803ybo.10
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CFrfdhHcfVHH2B4N1kkHicPXGlQbaEwRSh3X/p7ZWO8=;
        b=rRFMu29y2q2rLh3Nol3quvg8x+YkZ50Jlt/SAvLAacDEKEJ2qov7jg7NJcYBiQ/x0K
         +lea+tRxIhyYn9GKoXvOY38zk9p/AewpDtAF2QOTJedmLaczwq+/MpxApfvrkzKv0/82
         cv1gM263WECZ0Q6+P1imqjbCaQnBK5Yhh/ar00zGWujrSNU+Atvx8eVZCEnKiO+wFiw9
         OEo9Y5Tu/+U5AhNZ5IoTktQLqZ/jepYueP5wvjlfO9tjSh7C/wLSpDFdZBIDHGWP66gK
         FH8LVhAogdZTFxvyZH949VNU67N4Po/7h7G9+dvsva6c2n2ioNQqgpalc5H44MwDi4q9
         DOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CFrfdhHcfVHH2B4N1kkHicPXGlQbaEwRSh3X/p7ZWO8=;
        b=DXagYYUfRcXtBWeBGVtCJAFHhU3ldNIxJVsI+vKn6ArMMZZbJ7meFKEIgc78M13Fhm
         RLcfhEqOa/2dwYFp8mRyTlUSAE3Qzom3+8n2ooa/XcAF2ErdaITF2uNGeEpf2okUUWvN
         Ostn45yDYzO9hqE5xrcNci+Nuv6Uhr9n2+0LSm0ejyTuIBNrMPn5uuRFm+Scf8hOPePq
         N9uQdmWU8cEmWFtEyn/GanMCVoPiSw9bVJzWGfFDwBngjJeb97p77vxQ39Oqv2RT3T7K
         hZKCyz4A0BHbq9ZLYPX219D+3WiaB4fuevDdYPtRjXxoS2gOBBVW2OS4daeqCagNP3fB
         PTRg==
X-Gm-Message-State: AOAM533N5JEkjJ/DS11DnB+p6FJ6iKsqqOb8BRzYckRDyK83L5obXLZN
        BUyIXWcz/WjW1ewBJCdxoTX4VstdzAM=
X-Google-Smtp-Source: ABdhPJwNejR3BEOg0e6pNe6b5BfqU3WCTVPOoc8AUSNljl6bz40btenbii7kubhnSF4cdnMx8nfQl+l0itQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:5d0b:: with SMTP id r11mr1600979ybb.380.1619060715130;
 Wed, 21 Apr 2021 20:05:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:04:53 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 03/14] x86: msr: Advertise GenuineIntel as
 vendor to play nice with SYSENTER
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Run msr.flat as vendor GenuineIntel so that KVM SVM will intercept
SYSENTER_ESP and SYSENTER_EIP in order to preserve bits 63:32.
Alternatively, this could be handled in the test, but fudging the
config is easier and it also adds coverage for KVM's aforementioned
emulation.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 0698d15..c2608bc 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -167,7 +167,10 @@ extra_params = -cpu max
 arch = x86_64
 
 [msr]
+# Use GenuineIntel to ensure SYSENTER MSRs are fully preserved, and to test
+# SVM emulation of Intel CPU behavior.
 file = msr.flat
+extra_params = -cpu qemu64,vendor=GenuineIntel
 
 [pmu]
 file = pmu.flat
-- 
2.31.1.498.g6c1eba8ee3d-goog

