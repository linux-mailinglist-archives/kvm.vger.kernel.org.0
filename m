Return-Path: <kvm+bounces-21491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C7992F71D
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 10:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 116C9282759
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726D81422C9;
	Fri, 12 Jul 2024 08:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxL2AI0N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CCA13D891
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720773654; cv=none; b=TlA0nVe2LD4imc+t2X03C7fXC+ydNgLl1KDG99ILVoS/Q28LkeHw/eny7BbxZudocmrYBQqfjtTCYE2NAsEFnkI7Sa0eSvUvC6PpXdPJYnaLzHzjSUBo1DjkMcgZVrIF2VnlUOdzLiisvrw830EoNBJF4Trd90t0K5frTEki+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720773654; c=relaxed/simple;
	bh=uXIBaGGiV0VYe15WVe5IR64Hy2xVdRl+xA4ImIh4aT0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WyGoouq+Mvw6MrZZWG9S48/I3SmE5xACVPW8DhSxxlyxAvGW+xV/XOgkMr/zEhB04GYl4tI/2+KXg6nyEWIdEyVQTDhPRfC/SIxs7KYN6/aVkV2h/Q+41DNNrshpPuAobtJ+NkWV9/Jmxfokhw/CYrVDOxVUQR0pa3udVeaYEeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxL2AI0N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C45AC4AF0B
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720773654;
	bh=uXIBaGGiV0VYe15WVe5IR64Hy2xVdRl+xA4ImIh4aT0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MxL2AI0N5jNydIT2SQqSVhY9xD67CZymtZyUiYuPPr61X/m1aGK4waYLZL2afeXpX
	 OKMTkss4VykBvj0AqxfALdkWvLY/Mq8FyvaYvzqONNK3Cogm+WstqeKuBqkSEGaXKe
	 yRHQ21WxRj8WZ6Csj4IAxx0CXiEvrn0nCMej1HJt7xN3D8dPOGA12918LUiwLN44AH
	 ob45SJIoNDHBObm6TOis9gS+6UtDJaMC1gtrsm4EBL+Uz0pPcd5PAcwos1X1m0P09c
	 DDhrEF5G4ornSe+gtscsu5oTsyBUl6bMOSuW+VA6dnWvCcH13eXQ3pUp31y16vzyr9
	 /QyMG1M0bwa7Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 25654C53B73; Fri, 12 Jul 2024 08:40:54 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218792] Guest call trace with mwait enabled
Date: Fri, 12 Jul 2024 08:40:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xiangfeix.ma@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218792-28872-XmuOsBYZgk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218792-28872@https.bugzilla.kernel.org/>
References: <bug-218792-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218792

--- Comment #4 from Ma Xiangfei (xiangfeix.ma@intel.com) ---
(In reply to Ma Xiangfei from comment #3)
> I have tried this patch, but it can still be reproduced.
> Host/Guest OS: CentOS 9
> Host kernel: 6.10.0-rc2
> Guest kernel: 6.10.0-rc7+ (Using Sean patch)
> Host commit: 02b0d3b9 (https://git.kernel.org/pub/scm/virt/kvm/kvm.git)
> Guest commit: 43db1e03c086ed20cc75808d3f45e780ec4ca26e
> QEMU commit: b9ee1387

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

