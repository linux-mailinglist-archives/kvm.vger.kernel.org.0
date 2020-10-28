Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8322E29CD6D
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 02:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgJ1BiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 21:38:17 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:45255 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832968AbgJ0XKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 19:10:50 -0400
Received: by mail-qt1-f202.google.com with SMTP id d1so1786917qtq.12
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 16:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=uVAAxKGJ44GQm3v30eEW5qbX5guH3UCpsLTIfZxxtQY=;
        b=JRHJXLuBj+LDLo6Q2/72KrMf25WUa/E7TLphQprRGfUPBe8sWa700mwqtq4VS7CQbt
         aFeV3o7ZdZxxKwnemWG1gFtqSo0OvKvdW4yeAsvdb4lYHROMaCkQc/eFDHiHTK9gXXOh
         V374M7ALafSs95G70oV2/5LMdpx7m1Ww6T5dquiuxBEJWEdrunpCL4G0Xf9tagr4o1LV
         ALLGIxTRV03sCuSkV6HJTZHbLbP+ucgPoN2mYTEdQpgbHmQEzge/OFDdQmU4Q1kGMaWL
         qr+wW9OaZeF30c4lfF1yq7gGKLNZvErNHhxf80qQsGPNB47GZefraObQ+pgdbQQBVzR0
         RP0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=uVAAxKGJ44GQm3v30eEW5qbX5guH3UCpsLTIfZxxtQY=;
        b=nKHXiPJX3i74sLDt73ntCp/o/2tydYWDTAfUweMoDcNli5S/wjWuwOGsMEom35+hML
         vA97k8zlwwLzuYwr8XBo37E6M5oZlZAdODRCr3jG1SzkVCO1jRgpU6/3wIYY5JO6biAJ
         6drsExVgJPdpVZta46roQ0Vr1ST88EzL7MZLns5q2X3IhciCq054SYsloyixz4xXl5Hx
         n5dcQ948LXVFschwRvUKJj+iV5lGRfd0Up8NEpq1wXHCuGMjUESU3J7jqARd3yowrOau
         Y4eGpvxgbO2wimIvpkQ6jUikW9NiXwu7vwzLDUS2pQwEt3bOjfIoY7n2asVIqt+Cn3U0
         vb7w==
X-Gm-Message-State: AOAM531fXSYUKfGwrkf7Kh3wDBd+Xsc6YdrtyAyf+P+njdL/hJysLd19
        WpCQ7PmtZv7gE/uJKyjJxwj9SccLJvJsB80VrV+LaBgMUPlnySAJtDl97YR7dQp2x+e+KSrf/YM
        UmW1S9gmHUlj6AnOco4SpLMYEfT1B06md6ButPsiBtmFFknwr7dODBrlawQ==
X-Google-Smtp-Source: ABdhPJwPzKC+hfIYYBnir3+51Cmml4y9HuMtFMH9mI9B/RyTufG7gwNGJX/UpKausFhYMPU7ih3WhxMCN3E=
Sender: "oupton via sendgmr" <oupton@oupton.sea.corp.google.com>
X-Received: from oupton.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef5:7be1])
 (user=oupton job=sendgmr) by 2002:a0c:c612:: with SMTP id v18mr4719294qvi.61.1603840248708;
 Tue, 27 Oct 2020 16:10:48 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:10:38 -0700
Message-Id: <20201027231044.655110-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 0/6] Some fixes and a test for KVM_CAP_ENFORCE_PV_CPUID
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patches 1-2 address some small issues with documentation and the kvm selftests,
unrelated to the overall intent of this series.

Patch 3 applies the same PV MSR filtering mechanism to guest reads of KVM
paravirt msrs.

Patch 4 makes enabling KVM_CAP_ENFORCE_PV_FEATURE_CPUID idempotent with regards
to when userspace sets the guest's CPUID, ensuring that the cached copy of
KVM_CPUID_FEATURES.EAX is always current.

Patch 5 fixes a regression introduced with KVM_CAP_ENFORCE_PV_CPUID, wherein
the kvm masterclock isn't updated every time the guest uses a different system
time msr than before.

Lastly, Patch 6 introduces a test for the overall paravirtual restriction
mechanism, verifying that guests GP when touching MSRs they shouldn't and
get -KVM_ENOSYS when using restricted kvm hypercalls. Please note that this test
is dependent upon patches 1-3 of Aaron's userspace MSR test, which add support
for guest handling of the IDT in KVM selftests [1].

This series (along with Aaron's aforementioned changes) applies to
commit 77377064c3a9 ("KVM: ioapic: break infinite recursion on lazy
EOI").

[1] http://lore.kernel.org/r/20201012194716.3950330-1-aaronlewis@google.com

Oliver Upton (6):
  selftests: kvm: add tsc_msrs_test binary to gitignore
  Documentation: kvm: fix ordering of msr filter, pv documentation
  kvm: x86: reads of restricted pv msrs should also result in #GP
  kvm: x86: ensure pv_cpuid.features is initialized when enabling cap
  kvm: x86: request masterclock update any time guest uses different msr
  selftests: kvm: test enforcement of paravirtual cpuid features

 Documentation/virt/kvm/api.rst                |   4 +-
 arch/x86/kvm/cpuid.c                          |  23 +-
 arch/x86/kvm/cpuid.h                          |   1 +
 arch/x86/kvm/x86.c                            |  38 ++-
 tools/testing/selftests/kvm/.gitignore        |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  12 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  28 +++
 .../selftests/kvm/lib/x86_64/processor.c      |  29 +++
 .../selftests/kvm/x86_64/kvm_pv_test.c        | 234 ++++++++++++++++++
 11 files changed, 364 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c

-- 
2.29.0.rc2.309.g374f81d7ae-goog

