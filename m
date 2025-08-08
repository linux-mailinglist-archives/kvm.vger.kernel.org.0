Return-Path: <kvm+bounces-54337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE8BBB1F024
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 23:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 787E93B0954
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 21:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A6C25392D;
	Fri,  8 Aug 2025 21:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNfNnsWD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568A71DE4E0
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 21:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754687110; cv=none; b=lhfUetHrvx0PCRMI5hnBiMzdsXOdJdOtuPBSC2kvOmLu4jmZdtwl5C7b64pGE/r0kk8OE9dqvY0SOqQT1qA3up6gxRfm+ZeozLIRZ1nI+R35ykpOmSl6qDBArGw8GMCTEglXSVU+k0rAe4/ORX9BTSqNP5QqFnV1uqQ9Fw8HaNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754687110; c=relaxed/simple;
	bh=Df1kLqx2ksaeNDIKNKceASY0HeIw9dI+9zC9ZRxgqvU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=thHzvIDuO9y2aYqBG06BHO9dTWev8LJxOep03e3ILFLTQMYypNdDJ9EDmUzp2qYQsetV3pcreAf+LGqMVim6E6CUgkLL/xJt5Y5n9+rqGR7lU25b40hKuo58pMEsbA8dqM29tjuK+obUl/FSQkfHJW5UxuSJWyy9P0KIJFheAgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNfNnsWD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3E18C4CEFA
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 21:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754687109;
	bh=Df1kLqx2ksaeNDIKNKceASY0HeIw9dI+9zC9ZRxgqvU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XNfNnsWDNf9MEhjfCFenT30xDZ/H8coZr9//Ir54BPi8XT5kX/zgkpGTe8vtOo2p9
	 +Y3MKgI5eiPCCpJcsDhL1pkHg7f287HOV8MH3UFwtnKHBN0BeOH77Z9nLr7chdcJxd
	 lzYaH7ZRwRCdokRSYiUpJH/TDg+UZr5FKQBHIPJdPWWOLORvXXBeb+IMDT7gDXO6P9
	 +dpBVcbbAvCcS2AWbDoRUwshsuhRBbyA446WeiTrAM986X3gfDvJRCRGPAK0Yx2sSM
	 BPrXGb08sBh11K7kdvYD7bGwEeGzn2DxjzqLFKQ7vMU17cgg9KhX7NXk2qMX+lGodg
	 Tv63nZ3ami93Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AB294C433E1; Fri,  8 Aug 2025 21:05:09 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218792] Guest call trace with mwait enabled
Date: Fri, 08 Aug 2025 21:05:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lenb@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218792-28872-bVH0MHGv7j@https.bugzilla.kernel.org/>
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

Len Brown (lenb@kernel.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lenb@kernel.org

--- Comment #6 from Len Brown (lenb@kernel.org) ---
Re: intel_idle

I agree that the SDM doesn't guarantee this MSR exists
based on the presence of PC10.

I'm not opposed to _safe().

but...

Why is this "platform" advertising PC10 (or any MWAIT C-states) to intel_id=
le
in the first place?

It seems that it should be advertising none, and the intel_idle driver shou=
ld
not be loading at all, no?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

