Return-Path: <kvm+bounces-16438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D673A8BA1E4
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:10:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AFC11F22C3E
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 21:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 620C91C0DCC;
	Thu,  2 May 2024 21:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="me3UiuiT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-190f.mail.infomaniak.ch (smtp-190f.mail.infomaniak.ch [185.125.25.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA93194C9D
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 21:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714684191; cv=none; b=mETMeoCto96jVE4tbV6Gr/reibU+Zu6ruy+Z9dZIXqcZUmZEvzlC7AL7a3hfKIN7pSKmTftGkfuMXeykHZYhsozzo1dXcdGRmT2Na2SCpkJo7SdUiIn357d94PEUqbPZT4HHo62K1Yq6E6RtfhWUxmWrUTpl1BOtgzJSykyV+EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714684191; c=relaxed/simple;
	bh=6QKYOrdzJppIqKyHAIvgA7WW5vjmQK1fdvdMiBvid54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IXJCTFC2giXPyIUb8hUbJ3FRqD7unWX+JZz3RZMBNd2lBBjgtofW74O2S25Db0Gef6CCHxN7lIKOSSJSm80+DGUHqbgsZ8HGczvLzazD9F7DXEZ0hwhHkHNqaMRoic43saVvW3McHSEXkiyh6mNk81iwJQ/R0OFiXz9+eA9I6Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=me3UiuiT; arc=none smtp.client-ip=185.125.25.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VVmlv741fzLQ2;
	Thu,  2 May 2024 23:09:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1714684187;
	bh=6QKYOrdzJppIqKyHAIvgA7WW5vjmQK1fdvdMiBvid54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=me3UiuiTo9L4KbjRC31w7Yq+MfVhL+ME0ZFXeZJlS8sv2/4VjHU/NpfMs9etTiCC6
	 SD6s7G6p2gmfPDxQGFLBJIaUcJTt9Kt6l5POZAWhpAXq4zFdIzTXr4e0FPPevvlwCe
	 62bOqF9KHfmnxtDfs/LizG28HFnpM5Zw8dvsIxlg=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4VVmlv30fKzLRB;
	Thu,  2 May 2024 23:09:47 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Christian Brauner <brauner@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Shengyu Li <shengyu.li.evgeny@gmail.com>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	"David S . Miller" <davem@davemloft.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Will Drewry <wad@chromium.org>,
	kernel test robot <oliver.sang@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v4 07/10] selftests/pidfd: Fix wrong expectation
Date: Thu,  2 May 2024 23:09:23 +0200
Message-ID: <20240502210926.145539-8-mic@digikod.net>
In-Reply-To: <20240502210926.145539-1-mic@digikod.net>
References: <20240502210926.145539-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

Replace a wrong EXPECT_GT(self->child_pid_exited, 0) with EXPECT_GE(),
which will be actually tested on the parent and child sides with a
following commit.

Cc: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240502210926.145539-8-mic@digikod.net
---

Changes since v1:
* Extract change from a bigger patch (suggested by Kees).
---
 tools/testing/selftests/pidfd/pidfd_setns_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/pidfd/pidfd_setns_test.c b/tools/testing/selftests/pidfd/pidfd_setns_test.c
index 6e2f2cd400ca..47746b0c6acd 100644
--- a/tools/testing/selftests/pidfd/pidfd_setns_test.c
+++ b/tools/testing/selftests/pidfd/pidfd_setns_test.c
@@ -158,7 +158,7 @@ FIXTURE_SETUP(current_nsset)
 	/* Create task that exits right away. */
 	self->child_pid_exited = create_child(&self->child_pidfd_exited,
 					      CLONE_NEWUSER | CLONE_NEWNET);
-	EXPECT_GT(self->child_pid_exited, 0);
+	EXPECT_GE(self->child_pid_exited, 0);
 
 	if (self->child_pid_exited == 0)
 		_exit(EXIT_SUCCESS);
-- 
2.45.0


