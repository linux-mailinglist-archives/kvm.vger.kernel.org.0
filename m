Return-Path: <kvm+bounces-4441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 767798128E2
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 08:15:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FC3CB2112D
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 07:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A90DDD4;
	Thu, 14 Dec 2023 07:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZR21vmF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28648D52B
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 07:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F190C433C8
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 07:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702538097;
	bh=Se9x4a4ij8zv5cOHcYMVXvSPw8yRlIsUqAPDoyY053Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HZR21vmFSA6RBFN6OntCJmMyM5PF0cVV6DVe6mvpi/trvnTshoFwLMzaPjTgnWNHq
	 rkhAOZVGlcnc0hcRn04/3jwlKRRvKm1H4Td9bE5+9MfchYEy/YZuIdY4sWRSSF+mAc
	 y+gM3h/ePbNzG6FhO1uJtqVtJ/hSKuiq7uRGeuf33+TPZRpaOusRsMGGGbrc6H3/dV
	 XNTjwFrSwsp2Wc9OppLwgg0kOrMWQPj40/AADwByEAkGl8FLEo2awrrch7OymCWyIc
	 UEPKDxSKAt4sl6AoDDoS+QBMhqOwJpOjH3DzdJ8EIpj9v4Zw6Hk/J+GkHan5Jm5OhT
	 twFnASZ90cYog==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7FE2EC53BD1; Thu, 14 Dec 2023 07:14:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Thu, 14 Dec 2023 07:14:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernelbugs2012@joern-heissler.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218259-28872-UltznLAvHS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218259-28872@https.bugzilla.kernel.org/>
References: <bug-218259-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218259

--- Comment #2 from Joern Heissler (kernelbugs2012@joern-heissler.de) ---
Hi,

1. KSM is already disabled. Didn't try to enable it.
2. NUMA autobalancing was enabled on the host (value 1), not in the guest. =
When
disabled, I can't see the issue anymore.
3. tdp_mmu was "Y", disabling it seems to make no difference.

So might be related to NUMA. On older kernels, the flag is 1 as well.

There's one difference in the kernel messages that I hadn't noticed before.=
 The
newer one prints "pci_bus 0000:7f: Unknown NUMA node; performance will be
reduced" (same with ff again). The older ones don't. No idea what this mean=
s,
if it's important, and can't find info on the web regarding it.


I think the kernel is preemptible:

"uname -a" shows: "Linux vm123 6.1.0-15-amd64 #1 SMP PREEMPT_DYNAMIC Debian
6.1.66-1 (2023-12-09) x86_64 GNU/Linux"

"grep -i" on the config shows:
CONFIG_PREEMPT_BUILD=3Dy
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=3Dy
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=3Dy
CONFIG_PREEMPTION=3Dy
CONFIG_PREEMPT_DYNAMIC=3Dy
CONFIG_PREEMPT_RCU=3Dy
CONFIG_HAVE_PREEMPT_DYNAMIC=3Dy
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=3Dy
CONFIG_PREEMPT_NOTIFIERS=3Dy
CONFIG_DRM_I915_PREEMPT_TIMEOUT=3D640
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set

Attaching output of "dmesg" and "lspci -v". Perhaps there's something usefu=
l in
there.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

