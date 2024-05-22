Return-Path: <kvm+bounces-17980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 048B88CC738
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 21:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99A991F228DF
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 19:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354FE146A6E;
	Wed, 22 May 2024 19:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFpS18XL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C73E59147
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 19:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716406365; cv=none; b=ErhFZ5zpCdWkiwNTBEj12MtM4oNrFy1+rT8HmiQ06C9+Ayfy/HnLWOVmnliOc7HXSBBiXa1CIplCHvQXEkN/POJofC67w1Bw0xQ5TRngqT/PrITT+PNtNRCXYI9eTvScQ4T7pHr1tfCs0Gq9Owu0umEtYK5PpJnvkBL1rM+y0d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716406365; c=relaxed/simple;
	bh=ay+bnMk9Al6X7lbd+YefSpF6u/DJoR9vIDgxEmy4zls=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J4L1gY/LvFedJkCDvaAiUBB95mlK+ITXYeB+qoOyNk4ELY1Butkrhk0Akjv0pA/AVAkzvIbAEtri9qi5DPvSOsCC3YZLwmTHP4hkjTb9WWGFUo+Kbwexz0LCA0kgDYdtKSBQlpF3904ylGx8UcPbuNvz5Ae3HLzNMKWENjVmTtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFpS18XL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E00E0C32781
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 19:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716406364;
	bh=ay+bnMk9Al6X7lbd+YefSpF6u/DJoR9vIDgxEmy4zls=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FFpS18XLyI3rFsc+f39aMJ1SMZVWhMbIZWuIubCOKtPnXL2y30hNx6CTta7u5KS0e
	 S/DLJ5RHwPjIDPW0s8eP7h4B4yC+ya71V8nN/Gl9XHf3mB23rr7kuQMNhhnhsDBZ+9
	 Qt28Nf+2v+vHG2ksgxXi04es9NfwqbM1Dk7zFKDmuInkN6F5rxcmh1vXPQcW6Tu+hF
	 UPkY7FQZj/tEWs+/ROcbih6zyD7EOX7AgDMwr2RBmWe8A/G7WNEDY7gxa1WJYvzVdc
	 MR2yEWBIBa4KFjWRNxDzPE/B6mpdkNi3rWDa1FxjFVkdnjOY1UJH7q7yFW+gcRS0hm
	 uyVAQcYrzk87Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D9E0AC53BB8; Wed, 22 May 2024 19:32:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB
 Device to virtual machine
Date: Wed, 22 May 2024 19:32:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dan@danalderman.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218876-28872-abWO1O0hNr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218876-28872@https.bugzilla.kernel.org/>
References: <bug-218876-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218876

--- Comment #1 from Dan Alderman (dan@danalderman.co.uk) ---
Created attachment 306324
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306324&action=3Dedit
Boot log and what happens when I try to start vm with VFIO PCIe passthrough

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

