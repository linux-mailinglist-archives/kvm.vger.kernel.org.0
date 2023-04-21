Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7F06EABC4
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 15:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjDUNh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 09:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjDUNh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 09:37:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35458900D;
        Fri, 21 Apr 2023 06:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C488464D73;
        Fri, 21 Apr 2023 13:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C51C433D2;
        Fri, 21 Apr 2023 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682084274;
        bh=ISek3mBnmrk/v8xm97ePpRSrFcxal1t9l018us4X0l0=;
        h=From:To:Cc:Subject:Date:From;
        b=MY8xjcw6d9YBvc53sBrvxuVcFNTnlBVTR7RY9vPoERVQpGFYzfK7hntaC43nwxw+9
         LvNBGl/K5U5Ve9JQLsY+YuZRxYxrgL71CZE4In4w+pz29ewlQeghQ1BxwBoX++RQDY
         lwOOfewD7VyyOThGvAQcumOhT3e1X/FTsgbS53drq3ZXeyd2Y6updhYa8HWqUh4aEN
         FAjKS6ihzLQMz18q/JH0vzClVVneGL8Wb7it1kT4iylwgLX5YedR78v0qk02POQeaQ
         txwu8ovInpz411UZDd9TlvQpQdQ2R/ugCZvqvRVs7YkM3doVu0rOURcTKNRYH7rHnZ
         9cJ1NTJcVUuaQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [GIT PULL] fork: user workers & vhost
Date:   Fri, 21 Apr 2023 15:37:12 +0200
Message-Id: <20230421-satzglied-cybernaut-b2b652a46bfa@brauner>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4973; i=brauner@kernel.org; h=from:subject:message-id; bh=3MrRKpKniv5TWBvrsE8XXXNmyDHvC5zHG1I4z4nBGAo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaQ4TWS+k2s7vUTK/WOAaZP7dZun4VGS81+ePnWxutT1j8Qf 0bBdHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPRjWFkWHtrapLmpsXhn1oUnreL2J sGn104QbIpfnWV/MxTz9+eEWZk2Ji70deo9HB0wSQfGYka11uPJafL1esucRC1sWcSfl7GAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Linus,

/* Summary */
This contains the work generalizing the ability to create a kernel
worker from a userspace process. Such user workers will run with the
same credentials as the userspace process they were created from
providing stronger security and accounting guarantees than the
traditional override_creds() approach ever could've hoped for.

The original work was heavily based and optimzed for the needs of
io_uring which was the first user. However, as it quickly turned out the
ability to create user workers inherting properties from a userspace
process is generally useful.

The vhost subsystem currently creates workers using the kthread api. The
consequences of using the kthread api are that RLIMITs don't work
correctly as they are inherited from khtreadd. This leads to bugs
where more workers are created than would be allowed by the RLIMITs of
the userspace process in lieu of which workers are created.

Problems like this disappear with user workers created from the
userspace processes for which they perform the work. In addition,
providing this api allows vhost to remove additional complexity. For
example, cgroup and mm sharing will just work out of the box with user
workers based on the relevant userspace process instead of manually
ensuring the correct cgroup and mm contexts are used.

So the vhost subsystem should simply be made to use the same mechanism
as io_uring. To this end the original mechanism used for
create_io_thread() is generalized into user workers:

* Introduce PF_USER_WORKER as a generic indicator that a given task is a
  user worker, i.e., a kernel task that was created from a userspace
  process. Now a PF_IO_WORKER thread is just a specialized version of
  PF_USER_WORKER. So io_uring io workers raise both flags.
* Make copy_process() available to core kernel code.
* Extend struct kernel_clone_args with the following bitfields allowing
  to indicate to copy_process():
  * to create a user worker (raise PF_USER_WORKER)
  * to not inherit any files from the userspace process
  * to ignore signals

After all generic changes are in place the vhost subsystem implements a
new dedicated vhost api based on user workers. Finally, vhost is
switched to rely on the new api moving it off of kthreads.

Thanks to Mike for sticking it out and making it through this rather
arduous journey.

/* Testing */
clang: Ubuntu clang version 15.0.6
gcc: (Ubuntu 12.2.0-3ubuntu1) 12.2.0

All patches are based on 6.3-rc1 and have been sitting in linux-next.
No build failures or warnings were observed. All old and new tests in
fstests, selftests, and LTP pass without regressions.

/* Conflicts */
At the time of creating this PR no merge conflicts were reported from
linux-next and no merge conflicts showed up doing a test-merge with
current mainline.

The following changes since commit fe15c26ee26efa11741a7b632e9f23b01aca4cc6:

  Linux 6.3-rc1 (2023-03-05 14:52:03 -0800)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/brauner/linux tags/v6.4/kernel.user_worker

for you to fetch changes up to 6e890c5d5021ca7e69bbe203fde42447874d9a82:

  vhost: use vhost_tasks for worker threads (2023-03-23 12:45:37 +0100)

Please consider pulling these changes from the signed v6.4/kernel.user_worker tag.

Thanks!
Christian

----------------------------------------------------------------
v6.4/kernel.user_worker

----------------------------------------------------------------
Mike Christie (11):
      csky: Remove kernel_thread declaration
      kernel: Allow a kernel thread's name to be set in copy_process
      kthread: Pass in the thread's name during creation
      kernel: Make io_thread and kthread bit fields
      fork/vm: Move common PF_IO_WORKER behavior to new flag
      fork: add kernel_clone_args flag to not dup/clone files
      fork: Add kernel_clone_args flag to ignore signals
      fork: allow kernel code to call copy_process
      vhost_task: Allow vhost layer to use copy_process
      vhost: move worker thread fields to new struct
      vhost: use vhost_tasks for worker threads

 MAINTAINERS                       |   2 +
 arch/csky/include/asm/processor.h |   2 -
 drivers/vhost/Kconfig             |   5 ++
 drivers/vhost/vhost.c             | 124 ++++++++++++++++++--------------------
 drivers/vhost/vhost.h             |  11 +++-
 include/linux/sched.h             |   2 +-
 include/linux/sched/task.h        |  13 +++-
 include/linux/sched/vhost_task.h  |  23 +++++++
 init/main.c                       |   2 +-
 kernel/Makefile                   |   1 +
 kernel/fork.c                     |  25 ++++++--
 kernel/kthread.c                  |  33 ++++------
 kernel/vhost_task.c               | 117 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c                       |   4 +-
 14 files changed, 263 insertions(+), 101 deletions(-)
 create mode 100644 include/linux/sched/vhost_task.h
 create mode 100644 kernel/vhost_task.c
