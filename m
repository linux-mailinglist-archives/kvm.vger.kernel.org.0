Return-Path: <kvm+bounces-20175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B5D9114BF
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 23:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3A83285B2F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 21:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF2C7FBBD;
	Thu, 20 Jun 2024 21:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NaZi2vON"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394CC7711C
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 21:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919353; cv=none; b=I6ivFbbn56UwI5DyAxxknw7WrTtacfcZReNjm7jWvAQVRuBlN81gMuHSFq3WhlU5OthAhV7w9gSD4Kj20xb0zltGY5U8asK3xFkLXRzE959d07p2D+uRJqs8O0CXo6eJGhG5JQDZpkWyunqmHMVq45zIiO7z8q3dWhJYri4ioZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919353; c=relaxed/simple;
	bh=XmAoiGuCS5hm1x6qb1Nxr9Ms3K4eW5oNlymFyfOa+vw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uHATcRg9DoZ1Rl7xtdAXu/e5PsEVQC3KF9ZbRtQDZTNiVG9wA8po/ZL+u3gLvDaFP+nzBs3ykrvOvolCfnVaFSsYXe3YhO7XyMgkOHN0Ddn6EP6Lh0Av7KpLqa/eU44t+zqYuYXpdx8kbD9WAbrFXBcZkfe7EEJfUDIV60BTOsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NaZi2vON; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3CD6C4AF0B
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 21:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718919352;
	bh=XmAoiGuCS5hm1x6qb1Nxr9Ms3K4eW5oNlymFyfOa+vw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NaZi2vONzOrZQVBLJ7seEML7sO+pWQvsZ4uHwSi1Cy9U6lEyRXUPeM2uFH+4iZ4vd
	 R8Tb2UGULrolOAZQISUpKqjSyLoDwhSkeWQG8uObBGpeQ/AAswS3e0b/o/y8nDFq29
	 7M0SOHIgCAdMpfQAeM38FaOtPTdKMvx33Lji6slWKv0bJ+TWdpz24d1idhwARFIzgT
	 z1d8fqNFJEG0Hioi6XlkWsSIA++6+5LR742UVPF9Zoqd1/2FpDyw1PumNbi/KGRX7W
	 kPxwYf2UQE37p9F6xAxkt0C21ihi5vVVng7AuzbwJTsNtqolwIhKAOGeJtYFsH7aOb
	 ez7aCOYUXlXcw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AA6C6C53BBF; Thu, 20 Jun 2024 21:35:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218739] pmu_counters_test kvm-selftest fails with (count !=
 NUM_INSNS_RETIRED)
Date: Thu, 20 Jun 2024 21:35:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218739-28872-6A1puVoZ4n@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218739-28872@https.bugzilla.kernel.org/>
References: <bug-218739-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218739

--- Comment #6 from mlevitsk@redhat.com ---
Created attachment 306480
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306480&action=3Dedit
Patch to do CLFLUSH on each iteration of the loop

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

