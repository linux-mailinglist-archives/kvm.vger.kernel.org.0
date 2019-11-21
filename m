Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2CC105B29
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 21:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKUUeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 15:34:24 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:35135 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUUeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 15:34:24 -0500
Received: by mail-pf1-f202.google.com with SMTP id x3so2838847pfr.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 12:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OdnAgYVZPnAd48x7oEygPbtJpfpk8LTS6oFm8dIEa10=;
        b=D0HtL5M8pwn3H1chHic7xgm/BAaQvnEX6QevihD+9jQ6mV5W0FKK5GnTuao5oM6n8a
         yH3siAyyJORnYmdr5NHHw/h7swYylsPUBKL+6Wq5lsJORb1aggC13YUuDp/Yz5j+jTEk
         FLUL4qPqr7ZMc3LcS54VmdZ4pHL2iOTczGGc/2f0Rq/kRLIY4kg7UUKvgXBa5Hfu+2sY
         B0a3kacBgeoH7g6WCe7pKYs6FCNZXii5FDxgVmuHDq+g/U/xxOkxGLGN6vDVgkIOwmCF
         7TijKkAfhfY3An2viFWPfvtsg0MIqY92+GSTvcGLw6nAtef0MQ2MWciDo70cWCWbg2R8
         RHtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OdnAgYVZPnAd48x7oEygPbtJpfpk8LTS6oFm8dIEa10=;
        b=ErexdQqTH+BfSXhDoUNKZ8mqs29knTLbJHIrumVJKYwl3oeLS6TweUbl0WFX7SOOLY
         A80TCWQKRed4Nl8sAIpfGWBCcXnW/n6M00622UrBmr8XU2Z4FcPIjMBFdN2w5S3NnZA8
         RX3xfutMqVsY5dkIhrW/sIftGr0pj8or+G+RCHYHo8YODmye0xO/GFl87Z7IwPdfkmMl
         F4PVblbiEwDSL+1y1+wmzW20foT9SN9a+jtCcJrul3eKYpLJxS4uEMd5lIRcGu8h7NaC
         qh8kw5nu62AMrvkZf1/OUfNKpXO/GNSqPUga3Re2EE+wqKIVDDLB/iQTWygvXhTeMkFh
         Iyqw==
X-Gm-Message-State: APjAAAVuIwZTYHRT5bSMZuUNIZWsqtdmz9PRh96oPZkmiDK7UASZw+Eh
        Yvr5K/xFnroehZp6deA+wdIsjoEQxFs=
X-Google-Smtp-Source: APXvYqxV+WDp0EZRJJQb55WQBxo3rCIdnIhG5+ijkXveOJJ24zEtSTvhqAvfyG+tCFKtGtbrHjXoBQDV46w=
X-Received: by 2002:a63:ca06:: with SMTP id n6mr11483439pgi.81.1574368463460;
 Thu, 21 Nov 2019 12:34:23 -0800 (PST)
Date:   Thu, 21 Nov 2019 12:33:42 -0800
Message-Id: <20191121203344.156835-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH 0/2] Limit memory encryption cpuid pass through
From:   Peter Gonda <pgonda@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GET_SUPPORTED_CPUID for 0x8000001F currently passes through all data if
X86_FEATURE_SEV is enabled. Guests only need the SEV bit and Cbit location
to work correctly. This series moves handing of this cpuid function out of
svm.c to the general x86 function and masks out host data.

Peter Gonda (2):
  KVM x86: Move kvm cpuid support out of svm
  KVM x86: Mask memory encryption guest cpuid

 arch/x86/kvm/cpuid.c | 11 +++++++++++
 arch/x86/kvm/svm.c   |  7 -------
 2 files changed, 11 insertions(+), 7 deletions(-)

-- 
2.24.0.432.g9d3f5f5b63-goog

