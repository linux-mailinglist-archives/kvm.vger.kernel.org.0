Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302CE473A1A
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 02:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240325AbhLNBSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 20:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237681AbhLNBSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 20:18:31 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727B7C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:18:31 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id a23-20020a62bd17000000b004a3f6892612so11028922pff.22
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VwHa1xV9Oddl2t4jFc3iTpguMeWuNJtOcjfWBbLCPAE=;
        b=OdoQOpVXB9WhoxyZEEcMwa5ezswmkECVnE2BWvfYE/FpTZ+O2dYoH3VD09mTYr/dxP
         HWuL509Aj/ANc5S9BRZvI45nUnul55lPdNvYMo9QcjAoc4iZC+L9xpVWZBdVrFif0l5u
         eqaTrZMwxdGio0M4J5qdMkcmeum4Ugeovfu94ScYtdM4kdIYDMqBRWL3ibj8Psgt9E2D
         6qiINXX9ksXugd3nqhf5/rfc3GyV+fgdpMnbH2pyIgl2jfs82JT+/MIvxMrFJ+90HkrB
         xIzH9LQrXXYWwdd8p3d/Xsz71mf5zzrYZ9pjHS4JwoJyhipnx/7quePmn3zK4NCJBYQF
         bCfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VwHa1xV9Oddl2t4jFc3iTpguMeWuNJtOcjfWBbLCPAE=;
        b=ujM64tsTRufmYp0HCR17PV8BajLHtF1vHlKhzvBBu8g4quff8mK1eIj3bXmvW5ppzf
         X1uXBI3kLCCTiEgHsLyMM4oq7vTK5C1lqxfuCDPOjcow5z+OuB+AirYFVQMjhQq6FejG
         BkItEbJpdH7qRVLApQ8AWqnNDU+F4U4spF/NnGTQ0aMneMBIbvp7bLGcJGxAexBOeJ1s
         YZJK4lTZDpT1XOae0uDUJ0piIFqnZm3JvPIGq4qfnUej6YlNLOAO+XtJ2oVf2JB9oJNC
         Ceod8W8/KRlmIlSesQTfsqjwy8eEqEz83iR6o3wg+86j89Yig2UUudjKObswgOwMmnSu
         0+eg==
X-Gm-Message-State: AOAM531JEHnaTxO7Zg99Z7HGSY7WsYrUu/h2f0MsPn5NIZlx9Le2sgiM
        jjtz5d9h11DS5pzJIl0VObP9AXU1y/Luq1napwFJQunuc46OvqtYyg8bQ/4sC4k2OP1jmbtag3A
        VxGAvvrBUhxBnnrGhSxPj5wxgCh/sg9iblPJbx/7Oz85lcUOTlI9Etbu0wcorgzNDepsq
X-Google-Smtp-Source: ABdhPJx6KqjLUv5vrEMItuabbYYuhDmhUMV0OXdBJ4cg/tzzp6KEOsOsVUZt+vlWDpjOByq+rCw9A4edg3gO2Q7d
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:1516:b0:4a0:2c42:7f17 with
 SMTP id q22-20020a056a00151600b004a02c427f17mr1571250pfu.74.1639444710149;
 Mon, 13 Dec 2021 17:18:30 -0800 (PST)
Date:   Tue, 14 Dec 2021 01:18:19 +0000
Message-Id: <20211214011823.3277011-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH v2 0/4] Add additional testing for routing L2 exceptions
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In a previous series testing was added to verify that when a #PF occured
in L2 the exception was routed to the correct place.  In this series
other exceptions are tested (ie: #GP, #UD, #DE, #DB, #BP, #AC).

The first two commits in this series are bug fixes that were discovered
while making these changes.  The last two implement the tests.

v1 -> v2:
 - Add guest_stack_top and guest_syscall_stack_top for aligning L2's
   stacks.
 - Refactor test to make it more extensible (ie: Added
   vmx_exception_tests array and framework around it).
 - Split test into 2 commits:
   1. Test infrustructure.
   2. Test cases.

Aaron Lewis (4):
  x86: Fix a #GP from occurring in usermode library's exception handlers
  x86: Align L2's stacks
  x86: Add a test framework for nested_vmx_reflect_vmexit() testing
  x86: Add test coverage for nested_vmx_reflect_vmexit() testing

 lib/x86/desc.c     |   2 +-
 lib/x86/desc.h     |   5 ++
 lib/x86/usermode.c |   3 +
 x86/unittests.cfg  |   7 ++
 x86/vmx.c          |  28 ++++++--
 x86/vmx.h          |   2 +
 x86/vmx_tests.c    | 161 +++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 201 insertions(+), 7 deletions(-)

-- 
2.34.1.173.g76aa8bc2d0-goog

