Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4232D44F017
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 00:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhKLXzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 18:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhKLXzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 18:55:46 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A73CC061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 15:52:55 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id h8-20020a05620a284800b0045ec745583cso7594292qkp.6
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 15:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=N82n/Qfw0LA8CZqdiHx/4o/4vJjX7O/QxZFdGuCj9A8=;
        b=brbLt+aIzarvy/QrtCwTdYmWHYvK5wCNnv/DVt6eyjsyuTxYg1Nc7z8M2rAbIw6V2D
         XSFd7RssRslLL2bGMQM6AMoyEMyuVIyAo+x88WNPudY/f2U0qjPzmh7/wTTRbFcNzQsF
         3seR6xBiJjiyzZgZH04xlXoksI4OWS+Zs+Vo+MPIXWYqK4v4Om1WS+kTIXMIMkJiwaCX
         6Zap0+horzyvLKSlNFg29DOdJEUWsqc//3/LmGYdurZvt2WzlLd5b/KD9v0GsFfn46fC
         k59BWRbJGuDhqM841C4S5dy6LEnpcaWRdt2PbR/v0W7K9q4xCJJ0GoqIYchWdqJdxIg9
         N03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=N82n/Qfw0LA8CZqdiHx/4o/4vJjX7O/QxZFdGuCj9A8=;
        b=L/jrXmMavxE/H2DRUc9KT5F3LX+Vs6hvOmOF3GGXCbyy+IkqOjLVuevn5OcYyIhCEX
         GvmARZn0z/niNZS3DkLCdnd+ZX49RZ0uYRPDiEFZ082FYboiq4YqTjMyZmlj3T84tQpP
         3pC7OMDBWpuEEvXtIEDIUxF6x/Y2ZXwmjV3GiyZdPyiLnAlLzYn71vHckFASiyiazZC7
         dCPV4B9c9biT34t9ojxy/CGeR443STl6+2BKDIgGCs7w3OrF0838Nrew3O7PtsJIwsh0
         ftJb0vsJfx4/zYUTDTmUrd64RHgI9XYC141O2Sp09JHwHh9NZWrhz3KYbQ4vdjvMJfgR
         3cow==
X-Gm-Message-State: AOAM532WS7LtHZIRafabyNEkiztx0Ci0MoSsCiTkW188vmFzOz6L6IOk
        LwO0ZlGhGipVZ2EZoTllDmOhvDk3PszS0tj+U7DzpAv12S97pDn4v5ZIeyU+r9FVfPPmtVcrOFU
        9fr5JqZOcRbtsssEezTKXC5W4wd6KS70Z7PEgRNrvl0FZLBmyyckVTm5kfpWzd2s=
X-Google-Smtp-Source: ABdhPJyUbjTw3E7Gct9aQpKO/XFLeYW+mnciKyaA1ifqlnuGeDUReX+BXsZSNriTGT7+iC8Natt2wsem/n2ueg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:622a:1102:: with SMTP id
 e2mr20006837qty.171.1636761174462; Fri, 12 Nov 2021 15:52:54 -0800 (PST)
Date:   Fri, 12 Nov 2021 15:52:33 -0800
Message-Id: <20211112235235.1125060-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 0/2] kvm: x86: Fix PMU virtualization for some basic events
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Google Cloud has a customer that needs accurate virtualization of two
architected PMU events on Intel hardware: "instructions retired" and
"branch instructions retired." The existing PMU virtualization code
fails to account for instructions that are emulated by kvm.

Accurately virtualizing all PMU events for all microarchitectures is a
herculean task, but there are only 8 architected events, so maybe we
can at least try to get those right.

Eric Hankland wrote this code originally, but his plate is full, so
I've volunteered to shepherd the changes through upstream acceptance.

Jim Mattson (2):
  KVM: x86: Update vPMCs when retiring instructions
  KVM: x86: Update vPMCs when retiring branch instructions

 arch/x86/kvm/emulate.c     | 57 +++++++++++++++++++++-----------------
 arch/x86/kvm/kvm_emulate.h |  1 +
 arch/x86/kvm/pmu.c         | 31 +++++++++++++++++++++
 arch/x86/kvm/pmu.h         |  1 +
 arch/x86/kvm/vmx/nested.c  |  6 +++-
 arch/x86/kvm/x86.c         |  5 ++++
 6 files changed, 75 insertions(+), 26 deletions(-)

-- 
2.34.0.rc1.387.gb447b232ab-goog

