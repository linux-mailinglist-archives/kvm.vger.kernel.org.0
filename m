Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB21037AD38
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhEKRmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbhEKRmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:42:16 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4AAC061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:41:08 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id f1so1636189edt.4
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hb8ENtE+WmEFZrZrZSzUY6de4U1+BMFcRlEGa6h5Kww=;
        b=GuhNGqiQfx1bBZwxc3e/58Q/s8O8u+lNRyWZ3uMocUlpfSUT9EjA44yKwnBq3N7FG3
         CwBZa7cdaZFiBKgJGBBP5z/3ZfFw/VV1osJr0xxG40aN9+dHJJsMdOOapziAxx/3sIsD
         oaTxmGaJtRdGHtE1DgHGdr+JLgaGRFxYW8ZL7mPANmBZMjWLwkwrhX2C9DyOB5X/fxYD
         ALBGoExMZZzEoQUL38pEEESWWS90z2HuSFz8YuJj3xavQ1RxOAPqbk2naB+LnJjQKapN
         lHakbpadYXCVRaF6Q7tE2T2CsWanMAaOyETGE3rjwmC+coa43SFD8VQ9uLwG4AtXa4x9
         kmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=hb8ENtE+WmEFZrZrZSzUY6de4U1+BMFcRlEGa6h5Kww=;
        b=hqjea9ySSGjiP2wGahyHcRZzjCq9dW8l7JY+OWoFISfnHAAlO2Zgm1TAZzENVI7sup
         jQwM0hTACcTLJbe3M9CY8MRuQM+MuwsrGlbKgLo0z/qUM4PiC0s9sf6H2s26zRD0Tzbo
         JH1Kt6RUSzGcZch08lGLcWONr0hGbM+MJ/T+y5bLCrGHt1U99Ls/6nq3faTiKpSL9KbB
         iOqcNjJZ05MmvK7M10gMrsJLVB7nJssWtBdcp+/cM62qifEGSxMLvNx0yuoV2EglLc0H
         H0464cMyww3gVmNXaa/J0VJf9/YEOInk8KjOhfeV+KiMg8+1o9lkc1jyG0cT2AJ3Pb89
         RPfA==
X-Gm-Message-State: AOAM532UfqAYAinT5BwIi0dL6lfTELgMxISbx25kv2c0mEyXlEWfBxfJ
        8ebAea8hwY460Awy29dw1StS3ETOIr4=
X-Google-Smtp-Source: ABdhPJzofeBYTmNyTtnxG1sFbqnijrlE7iKupdTiKWGWjfwfYge5LiQVfuqKzMLt4w0WjXuM8qGu3Q==
X-Received: by 2002:a05:6402:11ca:: with SMTP id j10mr38115160edw.184.1620754867547;
        Tue, 11 May 2021 10:41:07 -0700 (PDT)
Received: from avogadro.redhat.com ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v23sm15239073eda.8.2021.05.11.10.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 10:41:06 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvm-unit-tests 0/2] fix long division routines for ARM eabi
Date:   Tue, 11 May 2021 19:41:04 +0200
Message-Id: <20210511174106.703235-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As reported by Alexandru, ARM follows a different convention than
x86 so it needs __aeabi_ldivmod and __aeabi_uldivmod.  Because
it does not use __divdi3 and __moddi3, it also needs __divmoddi4
to build the eabi function upon.

Paolo

Paolo Bonzini (2):
  libcflat: clean up and complete long division routines
  arm: add eabi version of 64-bit division functions

 arm/Makefile.arm  |  1 +
 lib/arm/ldivmod.S | 32 ++++++++++++++++++++++++++++++++
 lib/ldiv32.c      | 28 +++++++++++++++++++++++++---
 3 files changed, 58 insertions(+), 3 deletions(-)
 create mode 100644 lib/arm/ldivmod.S

-- 
2.31.1

