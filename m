Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F3217F51
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfEHRrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:47:39 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40501 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfEHRrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:47:39 -0400
Received: by mail-pl1-f193.google.com with SMTP id b3so10262881plr.7
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 10:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PFlfinL4QrH6+E0rbK20t90kmF3LL+L0LytJ6mzGHQI=;
        b=R7UIKb1Vw92WlTOAb+YpulW36qj6DEUfI7u662d4lqpl11Kv4ufl05J09Q3A+tXnuL
         VsD4kkhNX6QLJmlJhcfCxnMkk1xKqREbFS5uhEa7hA1UZHU6bX7QVBh6ApX5qmDmBp5d
         LwW5oHtc1/4EChXGg5SBHmbn07sqvvbj5Ckwsbvn8/pqQVuxpasDwpBkjnrHsuCNRZiB
         5cfp9dtyG6fE0ykxrZP106ZKVx4zftL0Y2kXTbDpZhPty0OP36C84aAT89oetlC0wn/M
         gCSsGlE9ArRHG2oBgXJuAbpqBT/nvkfnlU+TWDTi38417QV/tcnPm2JrdG3xHaDXyO6f
         zZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PFlfinL4QrH6+E0rbK20t90kmF3LL+L0LytJ6mzGHQI=;
        b=YImMdfYduxyAanl8KuJFcVWq+4YkEBDCjUmnsZwZ+6SVoj/ly9cANbvfqBEcYyCoMf
         8PiWGaD1MriDTvERn+tddAhVJ46acMPWtxLIHFgfJd7WZlb0s+ilG6BX9HxQ/SX60kbJ
         4sol5i+rC5EVlrv9NTY8mK2S6ade8JFg70r08z6pQ3TF/bxKEDkhMxCx5V6Bf5jlLGhC
         t9BZfEWPhZ/eXVa6nNFb/r/iHc6+aa/x176hZxXwsgwUJ1ZSL2rVIxZHDj/Mip60/a7y
         aAzzvRLONwNio7t5t4KcXIT6bWrTI9j81NVGk11NJ/KrM8MnKmNeNxIYrOTjMx2PhcAV
         Sdqw==
X-Gm-Message-State: APjAAAWluVpaUSPSfb5A0NDW+nVJaoJbGuipQ2/KyTPaGVl99HJclvDl
        TGIRS9xxPH58D56zeeCz2jQ=
X-Google-Smtp-Source: APXvYqyxIZXCvVoLniUi5d45oaxPcNz2wgjGjZU0arqFitekTZj0cA06y5bJEDuU/HJElw+mIXPN7g==
X-Received: by 2002:a17:902:6843:: with SMTP id f3mr48669302pln.218.1557337658480;
        Wed, 08 May 2019 10:47:38 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id q14sm10097189pgg.10.2019.05.08.10.47.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 10:47:37 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH 0/2] x86: nVMX: Fix NMI/INTR-window tests
Date:   Wed,  8 May 2019 03:27:13 -0700
Message-Id: <20190508102715.685-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

The NMI/INTR-window test in VMX have a couple of bugs. The first bug is
clearly a test issue (and a KVM bug), and is fixed by the first patch.

The second bug is more interesting, and looks as a silicon bug (or
documentation bug, as Intel likes to call them). The second patch just
ensures that a failure of the test would allow the next tests to run.

Cc: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>

Nadav Amit (2):
  x86: nVMX: Use #DB in nmi and intr tests
  x86: nVMX: Set guest as active after NMI/INTR-window tests

 x86/vmx_tests.c | 74 +++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

-- 
2.17.1

