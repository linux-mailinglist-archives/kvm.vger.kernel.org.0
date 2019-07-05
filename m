Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49CAF603AE
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 11:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfGEJ7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 05:59:21 -0400
Received: from foss.arm.com ([217.140.110.172]:34682 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbfGEJ7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 05:59:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3F0B1477;
        Fri,  5 Jul 2019 02:59:19 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 022663F246;
        Fri,  5 Jul 2019 02:59:18 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry@arm.com>
Cc:     kvm@vger.kernel.org, Dave Martin <dave.martin@arm.com>
Subject: [PATCH kvmtool 0/2] Add terminal detach feature
Date:   Fri,  5 Jul 2019 10:59:12 +0100
Message-Id: <20190705095914.151056-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment running a guest will tie it to the console where kvmtool
is running on. So one cannot logout of the terminal without killing the
guest. Existing workarounds are running in a terminal multiplexer like
screen or using the --tty option to detach kvmtool from the very
beginning.

Both of these solutions need to be invoked at guest creation time,
though. Patch 2 introduces a "detach" command, which can be invoked at
any point during the guest's runtime using the terminal escape sequence
("Ctrl+A d" by default). This will redirect the guest's serial output
to pseudo-terminals and detach the process from the console. More
details in the commit message.

Patch 1 contains a bugfix, which avoids the kvmtool terminal thread to
hog the full CPU time because poll() is not exactly doing what we think
it does.

Please have a look and comment!

Cheers,
Andre

Andre Przywara (2):
  term: Avoid busy loop with unconnected pseudoterminals
  Add detach feature

 builtin-run.c     |   3 +
 include/kvm/kvm.h |   2 +
 term.c            | 139 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 141 insertions(+), 3 deletions(-)

-- 
2.17.1

