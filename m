Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C089019484A
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 21:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgCZUGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 16:06:45 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:46114 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgCZUGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 16:06:45 -0400
Received: by mail-pf1-f202.google.com with SMTP id f75so6163002pfa.13
        for <kvm@vger.kernel.org>; Thu, 26 Mar 2020 13:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WqHax6ECl9wbInrMxjIjOM9cZAwTrPkoL2M2jFKPBQE=;
        b=oQg2HiJAJN0uq3CanDGzoJhuUjBYjvhnGM82wp7T8u1ZLdJc0emxPSWGDOVo2hwXyD
         oYhF+R4VmJyHhW9agDvAQwLEQehvPDqs2xMeloGW6iyyNl7BkF+BMNrw6sO8n5tEHSRW
         Bj9P4BPDq3/5vV7bdFky1PCeCR2OwIF62INk4/iglpEogfPbio/6/tuFzLNw2BTLZnIM
         szYZf1bycO6HgHYsEnY0Fz1gYItaYnVEORPALjWBYguN7JqK9Z7cKiRowmRewMd8xCuQ
         6QR0/l8leAZRocfTh5jgbffUm6anAdrZ0D82jPJYwvqKEtPgt/HsDIA4PDCLHV2pVl9e
         5qwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WqHax6ECl9wbInrMxjIjOM9cZAwTrPkoL2M2jFKPBQE=;
        b=GExU6TZJM8MsJXtJ6RPGARqg8xK0FdB3zR1Tpfny+nLsYy4SkbAu/BFW6YXMC7is6F
         fidZCNiLHPa75Zx6mPvHJV2tsAALDPbVJVQCFv0g5z18A/7Tv/GbY3rewDvT5eCxtYd/
         5I0W8hcmVleRsHS3UOLK79V3hZQcFPv4M2FqI4qKOiaFiPojBks4ZYtMAW0eT7YXlK1q
         w0tVoT/9GjGCPAnZmbxndn760Wtz7rlyIHUy3GlzWnCB0W7zaVcnhEqjtx/z/TUYlhcs
         x31PzuPmxdrPVzN2zcIbL5vdxsnR3mO404aJs5Qu1G/GSbIIsOudN6TgxO9Ni/jZ5xPu
         uv+Q==
X-Gm-Message-State: ANhLgQ0dH8KN2zEEHPv/uvhCk9FYc40fynJO4CKrY5qSjHPQChdsqEgl
        ox2oxlFJOUx7pN5eQiCy2uKVd3qwnEk=
X-Google-Smtp-Source: ADFU+vvsk68FMQSxurQFf3aAeMUtjRxGtYQGqNwjBsk1ShThaxSUYG2MrLAemrcldb5fjvyCliNa2Z6slbk=
X-Received: by 2002:a17:90a:e289:: with SMTP id d9mr1801523pjz.172.1585253203623;
 Thu, 26 Mar 2020 13:06:43 -0700 (PDT)
Date:   Thu, 26 Mar 2020 13:06:31 -0700
In-Reply-To: <20200326181456.132742-1-dancol@google.com>
Message-Id: <20200326200634.222009-1-dancol@google.com>
Mime-Version: 1.0
References: <20200326181456.132742-1-dancol@google.com>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
Subject: [PATCH v4 0/3] SELinux support for anonymous inodes and UFFD
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

Changes from the third version of the patch:

  - Dropped the fops parameter to the LSM hook
  - Documented hook parameters
  - Fixed incorrect class used for SELinux transition
  - Removed stray UFFD changed early in the series
  - Removed a redundant ERR_PTR(PTR_ERR())

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
 include/linux/lsm_hooks.h           |  11 ++
 include/linux/security.h            |   3 +
 security/security.c                 |   9 ++
 security/selinux/hooks.c            |  53 ++++++++
 security/selinux/include/classmap.h |   2 +
 8 files changed, 271 insertions(+), 46 deletions(-)

-- 
2.25.1.696.g5e7596f4ac-goog

