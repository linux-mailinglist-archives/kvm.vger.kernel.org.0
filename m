Return-Path: <kvm+bounces-18272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8BD8D34B6
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:43:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B27F41F2528C
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 10:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B604317B4FB;
	Wed, 29 May 2024 10:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kdmb3w7K"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB3C167DB1
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 10:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716979378; cv=none; b=dQMEs48J9TqwioImNrkLfRPO+Qv2nGqzh6Cb60QRLzsr8oQjZb2dcreqKAC8232BLPkYgjabU4dh9McNizKfBqfHJ+iTVT7m3vYQ3YL87wMcxbo/qhMPRtfvSXHr37gPw/SByZeERx5FPfQ7+SkIRf9SUn3knWR3QXNcW27vlUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716979378; c=relaxed/simple;
	bh=Lwtsthiak+mSyZCYvDiJgtdSoIC4iwaPESbOY4YC+KI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bNxhT9KJuE+241GgsOnqmAu7yVqpvTK7IlYNw+2PvCya9BijMnHe6enAegXLSO3hjPE2sPoowaUfMxUHnfx8GUKqBe5By0rN1XWlwwoNZCPy23/HcRz1VjhphzFITkIClWNX4NdlVveBqMRIdbu2WZVtnZ/HfmI2LE9UO54CRPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kdmb3w7K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6AB45C4AF09
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 10:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716979377;
	bh=Lwtsthiak+mSyZCYvDiJgtdSoIC4iwaPESbOY4YC+KI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Kdmb3w7Kmc2pcGAOEt/5QWHDzduz9I5X7QZJ/DtXQGAGceJ1NjCY8yTqxl3CjDh8r
	 /xN4QsvBPfWhvkvdt/x8N1MxspHiyPiXaCU7WQNEDVJvewO4RDYhF7LNGQY9qAYo0Y
	 PM5YpFAnojdfsYIa2+vnROBdY25/lYKmIyRCYi2ASP5E+m3rpAERD1q1KNMObhUA7/
	 4kZhXzLhp0LQ0yrjb2WinvzHOWEwLOjdi+/4E0oL0qOgXr3Y4mLL+58Eo65M0k0iBk
	 lAeG1rnrEFu6Erdaj4klmTBwZJU52CNs5nGTKE0rXeTkuc1Gz2fjD0C2mIctqUGNXH
	 l/0Q7pa3F3few==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6488AC53BB7; Wed, 29 May 2024 10:42:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Wed, 29 May 2024 10:42:56 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218876-28872-Na7LqHZkwf@https.bugzilla.kernel.org/>
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

--- Comment #10 from Dan Alderman (dan@danalderman.co.uk) ---
I tried with adding the module options but I still get the same behaviour.

cat /etc/modprobe.d/vfio.conf
options vfio-pci disable_idle_d3=3D1

(reboot)

cat /proc/modules | cut -f 1 -d " " | while read module; do echo "Module:
$module"; if [ -d "/sys/module/$module/parameters" ]; then ls
/sys/module/$module/parameters/ | while read parameter; do echo -n "Paramet=
er:
$parameter --> "; cat /sys/module/$module/parameters/$parameter; done; fi;
echo; done | grep -A 5 vfio

[snip]

Parameter: disable_idle_d3 --> Y

[snip]

Try launching the VM with the PCI device passed through and I get the same
retrain failure.

I have this card to try next.

https://www.amazon.co.uk/dp/B087G7T234

Sorry for being a little slow - I have disabilities that can put a stop to =
my
activities regardless of what my brain thinks about it.

Thanks for all the help.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

