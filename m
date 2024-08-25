Return-Path: <kvm+bounces-25001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B60CD95E271
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 09:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E60971C21572
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 07:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF9C61FFC;
	Sun, 25 Aug 2024 07:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0uSLmte"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99C05F873
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 07:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724570994; cv=none; b=m75MVPph0tQrNLqCH1Kl1Ia0nV2Hm85k5aJI/dQqlcBYl7YNnJD/O5AodbuQST1zIioAqrNxpLcLxLULNxKtFBAG6vULryquwJysHC7SKjH+wKE39rL8HbpfPFjiEByV8rAV5tmODLI85KDIVEvK21LpPmbYephWfDelJfMNRqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724570994; c=relaxed/simple;
	bh=IUP7Dhq7hsemmYIaQRJOSTJWxrW/da9gCmFDtDOXLsU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=svAZkxXNK5Ypa7FB8DugvxfOjh6Prz0b3SpG1qHHGW92SqZdmIuiuUEqQRDHaTxhIlBxQptpyegL4MiUUp/+9+n/xLPNzxMUb0731vyAekS+3WzPuFEViopCZ/0urk5P6L2Uq8iNhd4jjHibQKFXVf94SQL1xhfuQHA7o0t/nE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d0uSLmte; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88AFFC4AF14
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 07:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724570993;
	bh=IUP7Dhq7hsemmYIaQRJOSTJWxrW/da9gCmFDtDOXLsU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=d0uSLmteY1iTbk5f5wQdDW0nSC+gu65yoUXbrARA2frc6tTpEHnrslt33zsIj6dtm
	 6mxzQezvthDFANQE2JiEFDf67NOrQ72WSTFE/E3Vq3Q/5DxJn9AgBRLYzpFI959P5E
	 T57B6WkrLefVfrtqgwK50bAs6VNmfzPxgBj2lxI0g9pewM/jXPHiovHjyqC037Li5Q
	 D7hoyX65mNPmGjny/9UbVYVPa4qQxMs6xw3eNgV+S1EB6LNg8o7ac4uLH+KW8WyuhE
	 y1H5ZMM25iaRPnWDikeTDDwlM5wdW2t9YyqZ45/15sNQ7FKaRpMvBK2Q/qXA6lhgJV
	 mIqa8ncqPpTqw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 84085C53BB7; Sun, 25 Aug 2024 07:29:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date: Sun, 25 Aug 2024 07:29:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mgabriel@inett.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-199727-28872-nihBMizQ46@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #27 from Marco Gabriel (mgabriel@inett.de) ---
Created attachment 306773
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306773&action=3Dedit
inett_logo_150x75_678cb305-4b9d-4816-b8b2-b3d27c917355.png

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

