Return-Path: <kvm+bounces-14107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6160689EF1E
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 11:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9324B1C20FC6
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 09:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F31156C69;
	Wed, 10 Apr 2024 09:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FuyqxwlZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639D615539F
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 09:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712742563; cv=none; b=l0Qjx006Ve1A6LzsqxBvnCtr5sa4KZHxbr/1HVFymE8FAPzxHtQ5lXn5euD0028mBKOH8nlEBNerX8InfvABgSq+3phGINmF1NOiyxlcGAU0HMs1masO8Y0RBdYEauBjwIo8B+gNtqvMjfvylFtn75n0Vpccpu3jvUpOqYSN8No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712742563; c=relaxed/simple;
	bh=RkHH0iLbzoCrO+c/gbICO72stmkMKrxoynN522dPhus=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K5loIDQvWG+oSEd9aY4xqsDBjgVBfpkK4sL6l5rYqvQRLhSUv8DusEN5azDd9gR6aHp2yXbAzCkYZ6deTlNpZQWGEG8U2/aH/b4PqcrElxFrnTS9Vy3qGN/mJc304S4iE8ryhS3r+ifdyd1GHDeHwoh8+3omZnSbnz092YankaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FuyqxwlZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2DBCC43399
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 09:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712742562;
	bh=RkHH0iLbzoCrO+c/gbICO72stmkMKrxoynN522dPhus=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FuyqxwlZc1SANZm5WZL6Y+SSGv/HejzICuwEk2kltniel3+KmLLYVQQ1627gflp9G
	 CEGk7rOJuvWIuOx0X06LuemILStq1L+/fq2kVwT8Z06EsAznqbSHvGxhENPAt49Xjv
	 CdjzbE8y0LnDF3s5ZJoOlMYt+QhiBLMwy9UKqn0HXqukv4LAjBK7oLp4O3jPXdPQny
	 UZ01Pa5Cy0ntLmD+k5UhO6VLI+Zxl8Bc4k/nveQgaUnrcdZdIMxrZEeWn0FblRE2Ah
	 ORahUZOR0HFWxHBP1lRamNtdiBoyi+X4Pvj3I9IP5SOs4DV7h63Ms+vhFsuZPom2O6
	 HGMRFZ3Hzv/jA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CA857C4332E; Wed, 10 Apr 2024 09:49:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218698] Kernel panic on adding vCPU to guest in Linux 6.9-rc2
Date: Wed, 10 Apr 2024 09:49:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status component assigned_to product
 cf_regression short_desc
Message-ID: <bug-218698-28872-v38ZQNpxxs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218698-28872@https.bugzilla.kernel.org/>
References: <bug-218698-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218698

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |NEEDINFO
          Component|Kernel                      |kvm
           Assignee|linux-kernel@kernel-bugs.ke |virtualization_kvm@kernel-b
                   |rnel.org                    |ugs.osdl.org
            Product|Linux                       |Virtualization
         Regression|No                          |Yes
            Summary|Guest happens Call Trace    |Kernel panic on adding vCPU
                   |when adding vCPU to guest   |to guest in Linux 6.9-rc2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

