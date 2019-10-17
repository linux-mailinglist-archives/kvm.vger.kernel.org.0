Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE04DB3A0
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 19:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394466AbfJQRoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 13:44:21 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:54303 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfJQRoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 13:44:20 -0400
Received: by mail-vk1-f201.google.com with SMTP id i20so1224492vkk.21
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 10:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AepTsz+A74jxm03gyi80tnEG5pdCAiVEmB2VKmmYbAA=;
        b=txWXUG/bKJH+xYvRuY3lNWGbs0Fu/K7TeNieEqEzkwCbQ951DttsTLGCzkXdVPy3KY
         Km2w/kOt807GP8B2mwZNT/1sE4XCnhEOgDKdD2r4LCXjfxdltkSQyRv4CGCTq1VoGRr2
         91CJUZ7DeaO+yiJF+glAdddLlpQJvF72+eqedoBsFNo0bVaZHL++3E9pDK/04d2YWGe+
         np7G/lXqW7cVF7AenbULxn1+Hg8fqiLGg2q6O/L99nPop1TMN0R0LzXBRRMq6hiBGMPQ
         t+QwWnw5oWFay2e0WWPMTYmTGfrtu7hXElVim/VjermRHIFXL96frNDlAwKVbaRGZzxv
         pUGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AepTsz+A74jxm03gyi80tnEG5pdCAiVEmB2VKmmYbAA=;
        b=T6YflbqBIP6oAyRa0L5p43whmrnt7jKH5dEY1ZbDd6evx98hNGnLmHgTbOdRLeZdg7
         fGZehinyHNjZdaxQytY7Y5W3AXAa5AMuGjrbaaDLcIkcY4GAJKDkal4HCGd6m8MJ3ggB
         EaW5MCresBiflP6m8Ol/PnoCkSerlbldBu8C11Za5UCoUGD+pBAUbeLYKxWU702Pa3Qf
         0IfIklcPJiS3hiYMIDJvZ5+Vw7Beoy/J5exRVWuv9epNtwxErc0l/zS+Zrqe42fZ8RxQ
         0KcSpIoKXsMhQr8kSNICQDiHHxR9wuX9i7oGU0y8b3cN+VBGKyiVf+/UQ7KEBClyC+vO
         4xrA==
X-Gm-Message-State: APjAAAUy29lCQHhh0ex0/2ebBVktMMRC7BHbgoYbhHMhBEScxEt0Kxay
        f8wXlRYsAJIjNMVrXwUDgWrXeJJWHJjnHuq3
X-Google-Smtp-Source: APXvYqw6C55wAy116NWvppt7eDZT+fCR1ORnXW7Efx/dADnmZz5XHGPkhTIDMeFVShexmVeAGLoCcWUsVfibJxkz
X-Received: by 2002:a9f:200a:: with SMTP id 10mr2884411uam.42.1571334259331;
 Thu, 17 Oct 2019 10:44:19 -0700 (PDT)
Date:   Thu, 17 Oct 2019 19:44:12 +0200
Message-Id: <cover.1571333592.git.andreyknvl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH RFC 0/3] kcov: collect coverage from usb and vhost
From:   Andrey Konovalov <andreyknvl@google.com>
To:     linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Andrey Konovalov <andreyknvl@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset extends kcov to allow collecting coverage from the USB
subsystem and vhost workers. See the first patch description for details
about the kcov extension. The other two patches apply this kcov extension
to USB and vhost.

These patches have been used to enable coverage-guided USB fuzzing with
syzkaller for the last few years, see the details here:

https://github.com/google/syzkaller/blob/master/docs/linux/external_fuzzing_usb.md

Andrey Konovalov (3):
  kcov: remote coverage support
  usb, kcov: collect coverage from hub_event
  vhost, kcov: collect coverage from vhost_worker

 Documentation/dev-tools/kcov.rst |  99 +++++++
 drivers/usb/core/hub.c           |   4 +
 drivers/vhost/vhost.c            |  15 ++
 drivers/vhost/vhost.h            |   3 +
 include/linux/kcov.h             |  10 +
 include/linux/sched.h            |   6 +
 include/uapi/linux/kcov.h        |  18 ++
 kernel/kcov.c                    | 434 ++++++++++++++++++++++++++++---
 8 files changed, 554 insertions(+), 35 deletions(-)

-- 
2.23.0.866.gb869b98d4c-goog

