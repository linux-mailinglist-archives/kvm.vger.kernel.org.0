Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2BB194643
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 19:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgCZSPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 14:15:12 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:33235 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgCZSPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 14:15:12 -0400
Received: by mail-qk1-f202.google.com with SMTP id g25so5691447qka.0
        for <kvm@vger.kernel.org>; Thu, 26 Mar 2020 11:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9W2imRwNIX90Y+pv7hvZUio45RVHKjTkCMpOp3XQz5g=;
        b=L4H51g1ye0QBy1pKesN7K+qpxcMZHaR/pvy4tsx/SOQ791OkKaMGWDK8acZTk9VIvo
         79JW3+veC4INQH6pDPz3HMLI5aMFnzztdMR7KcXsOg2upVPHvZ5+/9NY9d99M9AwsHxr
         0HywX1EfJOf+TjX+zojuN3zm1Rq0DcTyRlJCyG9OMVaQwX1VwLwOH89FeCWjtk0CaNY9
         DxCYvgfbdWT2LSpz7hnG+2EE6W3BuqfCdVvxI2Qj0jh6oObj8Zd456/UGglmhP8oo3pF
         IpTY/tcb2l+BkqjcDQeaamxI4lbEhzTiRJJtuLRYW4vTY8iTvatwecihnymCxzMYIDbS
         hvfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9W2imRwNIX90Y+pv7hvZUio45RVHKjTkCMpOp3XQz5g=;
        b=jXKvp3fJ4WQ2qu1k8mlWG11cNFHD3/j7nevOhpkxkBptiyINIoqYcA0xX7ZdekJbQJ
         iXVZBmm1vQ43Mw/zZY+TkM3Epon4nruiizWzdhmer97cELKjSVvzI67uiXxt2PWMVaOr
         YPOzBcQDP47ZRfepXjYDsEGpuMRgtren4zZz/c1YW/4O+zk2ZY3DumkbnE43f2ev++EV
         m76E2fpU1AnNun9eR9cZIwnuPBrYWsroaeY6kkLhNZmPsfXDbElwG8zxZdNJ35pTv2F9
         zIllrSr3cqTtG0yzdj7j5J8kc6LnecHEfxSX1I6A6D3GCpT6odRnPVC0OfTvLrxsI9Ja
         xEwg==
X-Gm-Message-State: ANhLgQ0uD/t+tZP+gEZuzPiII7w3rzVAwBoZZRjtj/roTkIknGvHHoKc
        ydWhgMXmQr1CRQBfOxJOJJrBrwEQamc=
X-Google-Smtp-Source: ADFU+vuXYWs53KZQSCzq/xUwtE1DCsUixB0nXsvXZzDLn/OQfnLie5fjL6+pvJ2MBJlcFVtiiQax9ZZZqwI=
X-Received: by 2002:aed:37c3:: with SMTP id j61mr639522qtb.284.1585246510936;
 Thu, 26 Mar 2020 11:15:10 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:14:53 -0700
In-Reply-To: <20200214032635.75434-1-dancol@google.com>
Message-Id: <20200326181456.132742-1-dancol@google.com>
Mime-Version: 1.0
References: <20200214032635.75434-1-dancol@google.com>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
Subject: [PATCH v3 0/3] SELinux support for anonymous inodes and UFFD
From:   Daniel Colascione <dancol@google.com>
To:     timmurray@google.com, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, viro@zeniv.linux.org.uk, paul@paul-moore.com,
        nnk@google.com, sds@tycho.nsa.gov, lokeshgidra@google.com,
        jmorris@namei.org
Cc:     Daniel Colascione <dancol@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userfaultfd in unprivileged contexts could be potentially very
useful. We'd like to harden userfaultfd to make such unprivileged use
less risky. This patch series allows SELinux to manage userfaultfd
file descriptors and in the future, other kinds of
anonymous-inode-based file descriptor.  SELinux policy authors can
apply policy types to anonymous inodes by providing name-based
transition rules keyed off the anonymous inode internal name (
"[userfaultfd]" in the case of userfaultfd(2) file descriptors) and
applying policy to the new SIDs thus produced.

Inside the kernel, a pair of new anon_inodes interface,
anon_inode_getfile_secure and anon_inode_getfd_secure, allow callers
to opt into this SELinux management. In this new "secure" mode,
anon_inodes creates new ephemeral inodes for anonymous file objects
instead of reusing the normal anon_inodes singleton dummy inode. A new
LSM hook gives security modules an opportunity to configure and veto
these ephemeral inodes.

This patch series is one of two fork of [1] and is an
alternative to [2].

The primary difference between the two patch series is that this
partch series creates a unique inode for each "secure" anonymous
inode, while the other patch series ([2]) continues using the
singleton dummy anonymous inode and adds a way to attach SELinux
security information directly to file objects.

I prefer the approach in this patch series because 1) it's a smaller
patch than [2], and 2) it produces a more regular security
architecture: in this patch series, secure anonymous inodes aren't
S_PRIVATE and they maintain the SELinux property that the label for a
file is in its inode. We do need an additional inode per anonymous
file, but per-struct-file inode creation doesn't seem to be a problem
for pipes and sockets.

The previous version of this feature ([1]) created a new SELinux
security class for userfaultfd file descriptors. This version adopts
the generic transition-based approach of [2].

This patch series also differs from [2] in that it doesn't affect all
anonymous inodes right away --- instead requiring anon_inodes callers
to opt in --- but this difference isn't one of basic approach. The
important question to resolve is whether we should be creating new
inodes or enhancing per-file data.

Changes from the first version of the patch:

  - Removed some error checks
  - Defined a new anon_inode SELinux class to resolve the
    ambiguity in [3]
  - Inherit sclass as well as descriptor from context inode

Changes from the second version of the patch:

  - Fixed example policy in the commit message to reflect the use of
    the new anon_inode class.

[1] https://lore.kernel.org/lkml/20200211225547.235083-1-dancol@google.com/
[2] https://lore.kernel.org/linux-fsdevel/20200213194157.5877-1-sds@tycho.nsa.gov/
[3] https://lore.kernel.org/lkml/23f725ca-5b5a-5938-fcc8-5bbbfc9ba9bc@tycho.nsa.gov/

Daniel Colascione (3):
  Add a new LSM-supporting anonymous inode interface
  Teach SELinux about anonymous inodes
  Wire UFFD up to SELinux

 fs/anon_inodes.c                    | 196 ++++++++++++++++++++++------
 fs/userfaultfd.c                    |  30 ++++-
 include/linux/anon_inodes.h         |  13 ++
 include/linux/lsm_hooks.h           |   9 ++
 include/linux/security.h            |   4 +
 security/security.c                 |  10 ++
 security/selinux/hooks.c            |  54 ++++++++
 security/selinux/include/classmap.h |   2 +
 8 files changed, 272 insertions(+), 46 deletions(-)

-- 
2.25.1.696.g5e7596f4ac-goog

