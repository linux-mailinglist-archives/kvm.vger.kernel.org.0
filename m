Return-Path: <kvm+bounces-18058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A171C8CD707
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 17:28:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D0DE283C92
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 15:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A60C111AD;
	Thu, 23 May 2024 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CLONxLzF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BAF101CA
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 15:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716478081; cv=none; b=swRVWaNOnd0sc8mzhZuHzC5EzlEb5E83ihC2DOszUMFnL5799zaqkm7buvzA+WSyUp4amLGJlyr5eoP1fxXao/6F0JbnqkpNavPd+IufNwo5lXFicQnboLfLEV/i0zp8Z7oznnIXNHDbaz/mdw4AWy+kSFX+yBFLYIfD8pBTSLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716478081; c=relaxed/simple;
	bh=azTuqdIFUs8pcYSTR6T1oplsXLl7rGOSaXHdx1OfLPg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZMdQI1/fvMkeCeT1LnLupHIYZZN/B1J0em86QlVJUIGhGo9adX+N5gPtbmHaeMR0zULk1iGJXnO8rAxc8JH5rkGWXb2bkf/YUs0HiTqsd+BEeEqssQ+ECRvmAFYt9lOhLfxrK5qRAi+mu1nyuUgrWlTWB9pPOqLkRmdTOMARBlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLONxLzF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BA34C32782
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716478081;
	bh=azTuqdIFUs8pcYSTR6T1oplsXLl7rGOSaXHdx1OfLPg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CLONxLzFsBDSDllDaSsFn1rvh6I1Dp9mqvnoq1e+KL+NUEkvEVIw3+/7lpNMrqI9g
	 BRPHUcwVNdwgyKiLfPjpo1xPSC+nzYfwjTka8O0coZr2SPD6LekWFx3IWP511x83+o
	 mlNwwUfSl9KuQA4If4kvUVu0uAaHijgLU/luyCEXmZqhpS5hWGm9K8N9qKyWFNfSvN
	 fe+gIZIKZmw5nGnV5+0RirXDufltW/mrQj55hAy40G59YtwYeqm0sCdo7wk+fEAPSz
	 DR7C5VRzHYK53qkiryED7a+XgoDRcOGYxhU23u4t/dAVU11jacPOBjjLifTBhLmSxL
	 DWTEYcENcclkw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 09D66C53B7F; Thu, 23 May 2024 15:28:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Thu, 23 May 2024 15:28:00 +0000
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
Message-ID: <bug-218876-28872-DjenHONQxq@https.bugzilla.kernel.org/>
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

--- Comment #3 from Dan Alderman (dan@danalderman.co.uk) ---
Created attachment 306326
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306326&action=3Dedit
sudo lspci -vvnnk

sudo lspci -vvnnk

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

