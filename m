Return-Path: <kvm+bounces-19257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA556902933
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 21:23:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BD201C21803
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 19:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E7DB14EC58;
	Mon, 10 Jun 2024 19:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="po5fQOWq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7316F14E2CC
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718047360; cv=none; b=KmzBTs2mgg8NXWTw3MuLwt6OdlWVVz+pu8lkXOpkXw7d8oNUDqm5lGRjfz40x493/iWoQ+4CrgkFsAk1LEN0ohB43c2sf+UmDkSIXA/Buyd/J/8Innj5mjKbrwS6By065vIqXihCcm7AgwqRYDmoWt+//n4zmqEuxyoPJZorirQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718047360; c=relaxed/simple;
	bh=h8gDsCnwGG5PEGyK90nn3qqB7pdNwHGUj+ZqC++577k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lwJ5gGwTpyvz8B/Mhh595Mm6wF+8YYNx+4tsUKfyPhKjSr9QZzVjw6jW+OVTk/L0ogZZH7ZXRQZue7E6gFkfT0IwhuagOaeUtfZY8SZS3MrgM/xgkbmL+chpw/dWzCd8zAQCd8RIDkQAyzQrNv0YrkZdheVLCKBvM+0kq5ePU4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=po5fQOWq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E94BCC4AF1A
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 19:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718047359;
	bh=h8gDsCnwGG5PEGyK90nn3qqB7pdNwHGUj+ZqC++577k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=po5fQOWqm3LQDjhboA+pUZKatDKCtCf7qCSJlZFLpjCBQ517tdxV2lmidvgljI15+
	 CvOMfdFOoCMPDy46jOA5G6vj1CqJ9xu4g7T62AhkNfVaAf2a+ZXWgZrtmJZWYOibWu
	 479tEb2srmfrB5KG+R28oA3f4dlyMOoAPLAS6wrH4pUkOhfi/k6GrkQSQfv0cgx0Y/
	 pbQTM2HMhDGqLRWCyD9epGGwEmF42gmgJSJS+eQhd4f1g3rXnYs6pqEus2nrRubUus
	 iaux1dG7i4hZb1W0SZjYt9Rt5WHcWTZVi52z+X0d7Zh2XyPX5J0sN3EZqq4Tkzjhy6
	 mR78COU79r4TQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DED3FC433E5; Mon, 10 Jun 2024 19:22:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218739] pmu_counters_test kvm-selftest fails with (count !=
 NUM_INSNS_RETIRED)
Date: Mon, 10 Jun 2024 19:22:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218739-28872-pbt2R1hFBq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218739-28872@https.bugzilla.kernel.org/>
References: <bug-218739-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218739

--- Comment #4 from mlevitsk@redhat.com ---
I did some more testing:

1. I double checked that INTEL_ARCH_LLC_MISSES_INDEX is the only event that
fails,
test survived whole night with only it commented out.

2. using CLFLUSH instead of CLFLUSHOPT doesn't help



Should we disable this event for now to avoid the failure until we figure o=
ut
how to use this event in a reliable way?

Best regards,
    Maxim Levitsky

PS: I also did initial testing for running this test nested - it fails with
invalid guest state in L1, but only sometimes.=20
I'll investigate that further soon.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

