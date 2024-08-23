Return-Path: <kvm+bounces-24948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88D9395D850
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AA852842E9
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 21:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81AA1B8EBE;
	Fri, 23 Aug 2024 21:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUASUG7G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F98A189B89
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 21:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724447317; cv=none; b=Ks/ec9tvAo2LZNhG9HmMvZHIyn8PPgSTvQrIzsSqx/3r7mgXFWpbtkP8KrGtdSuY9cRK3+CdOhSFipnVuPidjSt0DnHSdH+BZ8yncYPbDAZ5tJqyN79gkTtlmwqatMas+XhJKyCAAne+fl8wHQoPI25/GzbO+BXbx9lZKspA2UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724447317; c=relaxed/simple;
	bh=ZlDMuU60qmh8OrEAa5SyhzF8yAEkwsb2cwcHuUTJu34=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dfrLhlXXtOe586ytih9LHXIqGWpKNXyi40wSbWbGwfHdvl+MgoH9pMz7Uf3D+FFvbxih7NvQBtx8EThYSfrFEqBfgVN7CUtwDI6ssOAf6T9CeLyoN65x27rYosuHXOlT2HP84UYvi8a9omFVT8+5t3iOFw7XBQPTsURV0xx99ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUASUG7G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E408FC4AF12
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 21:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724447316;
	bh=ZlDMuU60qmh8OrEAa5SyhzF8yAEkwsb2cwcHuUTJu34=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pUASUG7GVRCH547ypS37gGw0JmM30sMK6OBSceuRBKEMVTWVW3nKnvR0egihhA406
	 BnV/qnMxk7F8tDF1D408H/1bsbLXpLMqMF6WKHoliiGLUqCHM1XMlTwOmRe1jyI4YM
	 6SG27AU7YKOxP7EC+ZlPOW5iqFRlowrL5KAfCN8x/E8BOiUfuTnU/2JAsrUtmZZVj1
	 mG/La6JAYaaiDcI9+o1UVESlZjaUKWKikAzrRhIP37M7k6yvosHvBmz7XhauVFMWHa
	 WHXpgwKc3FRw3FKQkdITtZe+rbt5i59hXbhC93ucoP5vJXptwkfzo0CBrqoEJRka60
	 cJJNupC0P3/6Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DF6B1C53BB8; Fri, 23 Aug 2024 21:08:36 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Fri, 23 Aug 2024 21:08:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-7lN7J5gNln@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219009-28872@https.bugzilla.kernel.org/>
References: <bug-219009-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219009

--- Comment #6 from Ben Hirlston (ozonehelix@gmail.com) ---
do we know if Ryzen 9000 has this issue? I know I had this issue on Ryzen 5=
000
but to a lessor extent

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

