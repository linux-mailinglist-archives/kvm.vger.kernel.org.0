Return-Path: <kvm+bounces-45240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77E53AA76D3
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 18:12:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADC41461F9C
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 16:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 709E625D20C;
	Fri,  2 May 2025 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvmRv1m7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F8525CC47
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 16:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746202363; cv=none; b=t42GxfDNzKHfm9Jz/9ziienMc+C8LuX/Fpy+EAG8GOYXQWr999JPiPfgonJjkArYDzFYCx+BUB+xalRffW/GQwbwULORbv3uJiic2e41sL8eTLtKFPJz6aOfhdI5dtwC79tHjrHHVSw2KQceULkazQCG0t5gHZLXk8sBxpexAbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746202363; c=relaxed/simple;
	bh=+7hrKx0V2lZqrqFis5HfAqMkw8lhrUTVDcMnNu8N54g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PHgVqHB9vwSbhHVy3xhVokcNUHVytKvNTR7zkXfOQRJXdacs8yUw9QFU2o1PFyd7N9OWgmxaYjCJL7gGfFPpKLcB8EbvbeUv6diroA310FW0jmyFmRYXlRjYGG4YCDVWXzBI+tGT2cvAcieMEJyW2Y1zlQvovPdG+nsUYJSsAfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kvmRv1m7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 283BFC4CEEE
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746202362;
	bh=+7hrKx0V2lZqrqFis5HfAqMkw8lhrUTVDcMnNu8N54g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kvmRv1m7s2c6jtdf1UaQffsnfkYafpesnR25qRU4t1uoObLSxbnWoyET5UJJKwF0r
	 DspiGvyQrgYJExBSF/a3t1snMdQsEB2wUp4dAltZyQwT3Nary8VVxxphHCQZYffA5x
	 mLVxvP/hwDRMMqqW4V75b0Q0V4kLXTlUi/HX34SsPsFOdUuJtQoRiqS+Ms1DmQ1GIi
	 rnEV23jXQ1ay9yYtba630T2ObAzhNXEVVQSsufSv6OKKeN7zRrryeRBCz6zn9qqTKr
	 S+AQHplw3t2unIJNR0ax0VKFAaOa2AZzEGllfKogI0UvAP+JEyPtVB1X51l7KMIB97
	 SkWCgHi4hucow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 222B9C41612; Fri,  2 May 2025 16:12:42 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Fri, 02 May 2025 16:12:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-220057-28872-r8rH3DxttF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220057-28872@https.bugzilla.kernel.org/>
References: <bug-220057-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

--- Comment #44 from Alex Williamson (alex.williamson@redhat.com) ---
Created attachment 308071
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308071&action=3Dedit
align faults

Please test this as a potential fix.  It includes the debugging from last t=
ime,
so you'll want to unapply that first to get to a clean 6.14.4 base.

The theory here is that we might be getting a VM_FAULT_OOM due to a race ra=
ther
than an actual -ENOMEM condition, and while the mm should interpret the fai=
lure
differently and handle it, we might avoid the race and use the page table m=
ore
efficiently in this scenario if we actively align mappings to create huge p=
ages
rather than deferring non-huge aligned faults to smaller mappings.

Please report results and also attach dmesg with logging for additional
confirmation.  Thanks

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

