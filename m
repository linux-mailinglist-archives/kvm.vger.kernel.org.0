Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AB35A8CD
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2019 05:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfF2DxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 23:53:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34672 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfF2DxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 23:53:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id c85so3930923pfc.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 20:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AWP9ilU5/d/cRlyFilykjm7YgXW5glYDFQzoduKe5xQ=;
        b=KEHhA1GYWr7MF+kiMKJqm6NlyZ9dTYbYETlJVcgAHbYQ3fvT0BJoe6YkvpOW8vQIvU
         gSp5Oxk2mGUWrdcnCjc4I07ZN9MN4EtSA0vsih+HDkRdVChjoOIQXXoeBLY2xtrBKzVX
         r7C7f6pGAqrQKcwsmjckDZpueaqcHo+CrZu/5FEmMk+TSbJOMVcznx9E/3Dcq+FW8xqQ
         f0FMHvKSZU3xjJ4wx28FsL41y6V/0gRfZVAKzKfo1dZaXRPnY9+c5CL28Mu5EQpbsnxK
         K0qc5rQXOGxWIBwfBhc5jU9KMdmiEc6s9QKo2uLtH+hijH4stsfsEabovBzq0t0kN9mN
         Xzbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AWP9ilU5/d/cRlyFilykjm7YgXW5glYDFQzoduKe5xQ=;
        b=kvhR7WTCna2M3MRpCwYgfJuuc155upX26v+Ck+ImWID5RgwOXk0/5xPYGsALp4CmJC
         Z2qn9lDkb0WhfPeNg8A98gNS1CSe79mzgX2xmofbEz4FGFztHqCbh7hVawWGMsGxAPcW
         c/qaLIg/MokG1kcVpS6uTb7WJJ9047ZuNnYhawm4F4G2UeXRjbpWkjRwnb6MpjwPB8db
         9nUckSjWwsFkYMzsYyEchJGilgfTA4T61KQt8lHDhL7gbV25j5C10R3aqKHZQTot+1OW
         Sd9qyJc0PBs4Sqjhf0X12HYwpur8DufPG5VG5p9xK3pL5KvjNCBNTfxEfcFFYD+DX20A
         Yt0g==
X-Gm-Message-State: APjAAAV8DRifpMGNovUEmTmB3XnKVA7xK7O4eSkjaiAn1xzE+bRHD3/a
        DhVfvKp8Jsidh50mWnG+XDqiImB4s/8=
X-Google-Smtp-Source: APXvYqxuUZE4SIaVFBaSyUpjmAhHyh3AJ7cYFhnfuRiDIhUKHabXf5I3vlSR2amjpdnpZghDEv5Z8Q==
X-Received: by 2002:a65:63d1:: with SMTP id n17mr1165983pgv.382.1561780390632;
        Fri, 28 Jun 2019 20:53:10 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id p27sm5597052pfq.136.2019.06.28.20.53.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 20:53:09 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 0/3] x86: Running tests on bare-metal
Date:   Fri, 28 Jun 2019 13:30:16 -0700
Message-Id: <20190628203019.3220-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the final bit of enabling KVM-unit-tests to run on bare-metal
environment. It requires some pending patches, which I sent before, to
be applied first.

I have run most of the tests (e.g., vmx, apic, pmu, eventinj) and they
seem to be working fine. Not all the tests run the same way they run on
KVM, of course, due to the lack of emulated devices. There are some
issues with some other tests due to failure of 1GB page allocations.

There are several known issues. On my machine I get an error due to
errtum (BDX30, BDE31, etc.):
  FAIL: VMX_VMCS_ENUM.MAX_INDEX expected at least: 2e, actual: 2a

And there are also many test errors such as:
  FAIL: valid link pointer: field 1418: VMREAD and VMWRITE permission:
        VMX_INST_ERROR (0) is as expected (12)

These are test bugs, which Paolo and Liran know about.

It is possible to build some automation environment that builds boot
entries based on the .cfg file, but I was too busy (or lazy) to do so in
a manner that is not distribution-specific.

Nadav Amit (3):
  libcflat: use stdbool
  x86/vmx: Use plus for positive filters
  x86: Support environments without test-devices

 lib/libcflat.h    |  5 +---
 lib/x86/fwcfg.c   | 62 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/fwcfg.h   |  4 +++
 x86/apic.c        |  4 ++-
 x86/cstart64.S    | 13 +++++++---
 x86/eventinj.c    | 20 ++++++++++++---
 x86/unittests.cfg | 32 ++++++++++++------------
 x86/vmx.c         |  4 +--
 x86/vmx_tests.c   |  7 ++++++
 9 files changed, 121 insertions(+), 30 deletions(-)

-- 
2.17.1

