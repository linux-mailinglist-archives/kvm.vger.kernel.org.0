Return-Path: <kvm+bounces-23341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1355B948D60
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 13:02:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 459DC1C2093A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 11:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D0E1C0DF8;
	Tue,  6 Aug 2024 11:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkQ5Fh3v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF46143C4B
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 11:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722942132; cv=none; b=SSMUJhRBAiuSfi6nGakKTGsu6uCjL+YQd0arsdTw1Qw/i0V38HcOK1+lG9aItJU2Mou2QaV4CrbwXnA/SajLXqEGwMBYPwEhYf+mrfVkWbFAreWsEakELpF9vOGX7nVDo2U64bW+4i96gRFPQd2dpWXLg59aL5Moi2AIDgMFgaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722942132; c=relaxed/simple;
	bh=oqiT23uDpKUeijSSFEbDth2Jzc3Zi+OLqvslXYLWlXw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u1YeOilI1z07zTDsgNAfyUmi+J6imNx/kBV0bQBSlmQfFcIjxcFVcMi2DsPeUjk+O7KP5RNDgE8zH/fUwwQREhu0/4lxrYujlxLjL+ldq8gb+9RcixucP40E+KnWL8JjhnVPUfzSOKb9aPEFkHuVus+Ii9qs4XQ3THtwn8cwU4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkQ5Fh3v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2599DC4AF10
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 11:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722942132;
	bh=oqiT23uDpKUeijSSFEbDth2Jzc3Zi+OLqvslXYLWlXw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PkQ5Fh3vrlKIogsB2VCdZ5Z+ZQFNdd2bP9iUrmtGO8Cwsp5gcVSH5NQl1rfsj/oz5
	 huY+SVRoz3KDDIcG+IzCPFhOBHRG9rcdKkpLIBkzAad5g8Ac/r4gysgD4IFV6NgiIN
	 SXcYhmFT5nxBBGmzxX9GQAREtPxKh2hRhB9v/z7Ha94SJcLshljP7KbBqYXghToJOx
	 lsUydpuaISAPmghs1dxg2rD7VqcYnp2GZq3LR9/KPKXiJXa0DjH7xe+nHTWgA0X6vq
	 VoaLZgaB79yUOcrr7ej3ZdM8rz9uxJP8LwvS5h+tXC31mQQpas9DVxJeKW4wz1WaCr
	 pOLe7WFONa/XQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1D313C53BBF; Tue,  6 Aug 2024 11:02:12 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple Windows VMs
 hang
Date: Tue, 06 Aug 2024 11:02:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: vkuznets@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218267-28872-W4K1bxeLdP@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218267-28872@https.bugzilla.kernel.org/>
References: <bug-218267-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218267

vkuznets@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |vkuznets@redhat.com

--- Comment #5 from vkuznets@redhat.com ---
(In reply to Chao Gao from comment #3)

> Note that, APICv outperforms Hyper-V's synthetic MSRs; regardless of this
> bug, it is recommended to remove "hv-vapic" if KVM enables APICv.

'hv-vapic' is a prerequisite for some other Hyper-V features, e.g. Enlighte=
ned
VMCS so disabling it may not be desired.

Also, there's 'hv-apicv' (AKA 'hv-avic') feature which prevents AutoEOI
advertisement (can't work with APICv and this KVM inhibits it with
APICV_INHIBIT_REASON_HYPERV). AFAIR, newer Windows versions don't use AutoE=
OI
either way but Win8/Win7 may.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

