Return-Path: <kvm+bounces-38885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F08A3FEAE
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 19:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F3118604F1
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 18:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865CE2512F6;
	Fri, 21 Feb 2025 18:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GF+hgb+G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A945B2512DC
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 18:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740162178; cv=none; b=SwNNKo+MQCFUy8tiLBf/1physfwfv5nKYM/b4gpNDaGsM+fFtwibO1HQ/zIQ/Nf6E/ldnv6+PUD2+d1Lk94V+R4ruu3HywEUj2fRJv2jWwd306uxp58g6T7C1g97KIumrVhyzfc/Civ1X4BdC7CElf9rnubQ3l9W3RfffZTwZuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740162178; c=relaxed/simple;
	bh=2Nnde7/EDBAwt9q3ICuGo+CkSQibUmqkoRv9cad0yLc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RF5APnwyu9UPHXm/awJBIZUSHg4Vf+YNNyu+9x90+8JWy+pkWQQ/teHvq/Fl8qmv6UGopYB/TuY7EemG1lhA0kecm/F1vGVHgNB3mVs278pU5AkYS2KfO7x2G0RYm2eKS98uOHPoP0Nduhs3K9HMUOvcr4H0wtIe2lAcmCQEBQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GF+hgb+G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06418C4CED6
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 18:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740162178;
	bh=2Nnde7/EDBAwt9q3ICuGo+CkSQibUmqkoRv9cad0yLc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GF+hgb+GFsHO53Kh1XSwCdq2yeyPcZQds6TqETNoOM8natDlmMB/naq1akrG0q05F
	 7r3j0K5dATbttAVq98BdEcQiUU/T2On7RSZiY/l7Mgf6TgHMdojroQnZRViL0PrAN0
	 H1PsZBXXqFdVQf3ki5M0SYJNzcMrzKjzZUt0I+0uZzDLDa1TxFOGsREdo7ZHbsmtNg
	 kcnho7otCAOSIvzNucN4oKm5rJFVo3jYrDk236bzJZRMNuz8dGrEt/QzlEcwT5QnZV
	 91PCA3kmj9VyNLtfnPqPVA/r1lkb6+otCkZptketgMCNL1VCWZ9Kx81Kbl30jbXTTr
	 bD/tveMyqMFhw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id F2F6FC41616; Fri, 21 Feb 2025 18:22:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Fri, 21 Feb 2025 18:22:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-219787-28872-JWOzhUCMgu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219787-28872@https.bugzilla.kernel.org/>
References: <bug-219787-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219787

--- Comment #14 from Sean Christopherson (seanjc@google.com) ---
Created attachment 307695
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D307695&action=3Dedit
0002-KVM-SVM-Manually-zero-restore-DEBUGCTL-if-LBR-virtua.patch

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

