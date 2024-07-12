Return-Path: <kvm+bounces-21481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A54E092F6B9
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 10:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 361C5283F26
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E82D13F439;
	Fri, 12 Jul 2024 08:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfxZNaj7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8584B13D899
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720771890; cv=none; b=c7Nr5GnHe8GBVBaW79vHfbd0a6fH19YbNKSRFZa9I6xWaGlGXtvo0aWCWOwc6t8kQ51nkzPnPJefh4L+w5DiIgvIQ+I+2GH5a1XW7bQ9u8FKrUx44grCp7rp0qiYFa2EFblg5GgG9ivhTFTy29slAXsT1af3r54ndNwSnAzUl2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720771890; c=relaxed/simple;
	bh=b0gpcZMXO6SUcpC/p492TLLEr30JP0Y/YvqtaV2TrcE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N1zU2odj3cO2JFTMF6dpb0d0bkuPFUrzGOdyCy49XZDl+TQV0pGx6aFJysuG3u1xoE6BxScWCQLUFnbaVoFPqJwxt6Y1xhdUJMbKkdwZH1NXLRwBNxlOjkT089KdhvGIJkPHxUbLhAQRoa4sBLYVsmO0JDvkSqbvmqKqrYGlrGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfxZNaj7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC83AC4AF07
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720771890;
	bh=b0gpcZMXO6SUcpC/p492TLLEr30JP0Y/YvqtaV2TrcE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AfxZNaj7Rd7NrOEDiz7HaaHpiCvCjMWpT/reuhmCR6R5HkUBFG+UmMSB/EYX/HI73
	 2uyoVZGgxgZdymJmJKLoIOp4GSnKNCT0TUvP+Gcb9nVTIRUCQtVD6UxfsAaTnzmOO5
	 F7FCOavbDHCgAuppO+ThW9UKWIqAKzt8tk+OaH1sK4zO73xqX3OXuTvRNDQOCu06Xo
	 p2FHJcQZ/Pz2F1I9GD2Sgp3XsuvYZ8Rf8Rg498NxnG2HdsajOEuCEpRQ30I+ar17fp
	 VaS6eAgNCTXG7TpW82fqdj3ztOz9f9L0mXsyEMj4F808v8LxtXmQVKh7Bgg0Au27Zj
	 r4AiMZFuPgNvg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DD812C53BB8; Fri, 12 Jul 2024 08:11:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218792] Guest call trace with mwait enabled
Date: Fri, 12 Jul 2024 08:11:29 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218792-28872-kd7z3WJqKt@https.bugzilla.kernel.org/>
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

Ma Xiangfei (xiangfeix.ma@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xiangfeix.ma@intel.com

--- Comment #3 from Ma Xiangfei (xiangfeix.ma@intel.com) ---
I have tried this patch, but it can still be reproduced.
Host/Guest OS: CentOS 9
Host kernel: 6.10.0-rc2
Guest kernel: 6.10.0-rc7+
Host commit: 02b0d3b9 (https://git.kernel.org/pub/scm/virt/kvm/kvm.git)
Guest commit: 43db1e03c086ed20cc75808d3f45e780ec4ca26e
QEMU commit: b9ee1387

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

