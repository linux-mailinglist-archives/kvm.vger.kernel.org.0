Return-Path: <kvm+bounces-20290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A55F912926
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 17:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA46A1C22D56
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F31FD548F7;
	Fri, 21 Jun 2024 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XG0KATpF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B51C481A7
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 15:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718982868; cv=none; b=hgdiha501p6s2ZnMjG7Nd/4hBLezNyDzE1+GcqSW3i+BhCptMh3/su1FVnM+TgWtiaT3I5byL2y3mozURGOq6etf1qj2UI7hrKHHRvfl9mqUQ6XEmSzmamWQtYnKM/Rff9BG5PiB5nGI06jIfvFhoLO75FyiZO+DqQZuUSmwIN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718982868; c=relaxed/simple;
	bh=09NxsQhODWxYB+Uw+w6Xxlsstm/NOBhbhljFZ12IA/I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PwHp6y91uEFf2KkdZRAE1TLQfygLksxkotnJvPjhmY3it3dK7MmxM/PHZGOY0i7xDu6lgfnmSUpJlmwGStpLYWPk1IoSAZxQSWA4zpeP8gPAMFkMK6rAQ+hwLC/b7ok+DUoRJs1pLxYRzxjEhC6y6yh7qIpDCzILVGbZpikdsbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XG0KATpF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A37DFC4AF09
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718982867;
	bh=09NxsQhODWxYB+Uw+w6Xxlsstm/NOBhbhljFZ12IA/I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XG0KATpFlOgHf77ouFD5Ol6IMOSOh0Lf1pVunMHZLUksxsEAtFiYG5TdhEO96Fs6X
	 p5OERT9Ohk+qeyFupnX9DK8bevM+aWWdiRCAUbTncFQ6iQh5I74QdwSOMbxixkRcEm
	 4CAYcwsDlcPyoctSazWwzdmRv+cC5VY4a8c4Guxo3sBj3Sdtmt8xWgyDksI0MS/w9l
	 J+4PEm3LUlGpX/OjyKJmid7WwdDjZ9v46Y4zM30Upy+assbiQDPumYN26lKFFaDQGv
	 Hrk4snBhihZPu1xmZquoI0MDQP5HUoFYs0Yl7KG3VxvC783AlWRivNamvBvMAamdsO
	 GNct9JVu2Uu4g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 985F9C53BB9; Fri, 21 Jun 2024 15:14:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218739] pmu_counters_test kvm-selftest fails with (count !=
 NUM_INSNS_RETIRED)
Date: Fri, 21 Jun 2024 15:14:27 +0000
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
Message-ID: <bug-218739-28872-kbBw75gFrI@https.bugzilla.kernel.org/>
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

--- Comment #7 from mlevitsk@redhat.com ---
I ran the test overnight, not a single failure.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

