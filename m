Return-Path: <kvm+bounces-68238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB616D2820A
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 20:34:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9A630304D8D5
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 373463191D5;
	Thu, 15 Jan 2026 19:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oasis-open-org.20230601.gappssmtp.com header.i=@oasis-open-org.20230601.gappssmtp.com header.b="TbxlGF1O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF34F45BE3
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 19:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505663; cv=none; b=KB4U8QQq0foDbUY266twK+tcKw9k50I3w08KoBNwT4vZ8lsx0aoH9Xp2yyjW3VcKWNbkqw2tRa+CnNsciBBIlT1s8b0VVDGA9LghxiDqU95+KQ2OOzvf8zHkhviMeUnj+eMnm+vg5c5ZHUjIJ1JjusAspmbockgWY2VB/14/K7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505663; c=relaxed/simple;
	bh=tYswEwB2K4rLxDAOYB6DH7qcWpEd+qmrWgR3vmHfzq4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=hTY2NUJeHlOKMC4ZnV/ahJ7DjVtksqFJbOtSXR101KtggSoflnK2H9YQQKRPhvpG2EPja3PqiFdh7MoN9ZzRKe6R7ysOyecyI/YCwgzeMMUGIjr5Tl8k6njfZnck6C6lODIb6B9prv26M4QlCyPYBRznpttJMNjVFn0+YgdbptI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oasis-open.org; spf=pass smtp.mailfrom=oasis-open.org; dkim=pass (2048-bit key) header.d=oasis-open-org.20230601.gappssmtp.com header.i=@oasis-open-org.20230601.gappssmtp.com header.b=TbxlGF1O; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oasis-open.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oasis-open.org
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50145d27b4cso12398661cf.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 11:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oasis-open-org.20230601.gappssmtp.com; s=20230601; t=1768505660; x=1769110460; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tYswEwB2K4rLxDAOYB6DH7qcWpEd+qmrWgR3vmHfzq4=;
        b=TbxlGF1Odr2ePL1Yx4RGoWHzQ9kIwnKh6uDe1+G5FzHve3AGyefJbkP1VtBLIgtc+8
         W4VnjzR6uW7BN9pCbVLoaPgL48GrbeP5Ylnewu6XNtcMtD/lhxkjpaxa4D9rX9zG3jDx
         2LJcse6km0pMx38meOjI066s7fKSga8IexErJELWd3KqgiIqSMxspa5/3N3nRWaqrSRS
         drloWsP8cmAtYqvm3vVSEOrb8BRS8fGg5kZ5xVPo0YxBJa9fLi1cN1fu6IZKE3F/FSB/
         wSD27RDEDZCiyY7dBC8jwUWcTX30ubCTTkaQW8kt6T0REO0TGJZNtCG0F1T6lMC2d2Ie
         Lr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505660; x=1769110460;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tYswEwB2K4rLxDAOYB6DH7qcWpEd+qmrWgR3vmHfzq4=;
        b=pgU2Wab0AyRKZOZ5B+XghC6ANKMaatJdnODoxFWJ2Jb1q/gHYk9CeBSi6bxeQV28SE
         mWoaj4jDS3DM0wwp75JA5a8EpfPHvTSIQV4ghuDKj/3Etgv8EszRLTRgKm6LfQ+GtWjJ
         RgSKZATKnZy3hAr3s9Lngb7vi31bKy5ZUHCJfUXSGaknK78yrEazfwrwC/fgdNsJq1Oz
         KRSUPEKmwaw+y6GZvPkXujifTZf/ZOLzBKP+oMiIryneM7RHPtEcpoh+bcR7GHnxIwsP
         Hn6L3BA0vLi9k827R1c2nUnlN2ziBIEj8mu3RhfCSQVsLRtrifjNbyYsINfFXpmvmryI
         rV4g==
X-Gm-Message-State: AOJu0YwXyHX/zqRp+W/B4+PKt8aNGCw7VkiCKP8tqxfwiCB64oM96Atf
	PQixsq6BobkYKyjKbWgzdjKKnNLinJcYWKm5l2EVgmmSciYPx1mXxxmT/bi+mjiNh2KKPVi1u3U
	j9O76NGLsuoJgBKeNK3Y9iCRqtCQ0ekkWo+iQDaFZvzFp+lrzIEkLTWw=
X-Gm-Gg: AY/fxX57zcTdG1ysXqAyomUgUaiigVK1ag/eUU6qVgv14pKN6X3WaPAWH7FY2yIrzkH
	FsHllvTTPsID8HLNFfL86oCNLpZnXY1Uy42ytIi6M8gFJhNw3ZhyjpFiYy9xjcDp2uYMupKI+YD
	aALGfQILo6xH6HZNINja24uIuwwg7H+P2J9ejCSGCicBEL4WJwOBN+obw/c9OBoa9Fqg4bWpOSd
	YwjNvkFl3apcnz8zlg+ZEE+7iBqLOe8d8iZKtPbPDiWnMwFnuEWNQ0wDWPw2EX4W7cYlU9280+e
	UBg8/pgW9//G/neBM0sbEnJ+blf0NUnM65GWwqWRmdvUutIHt66l5aaSPjLU
X-Received: by 2002:ad4:5ba9:0:b0:880:5001:17d1 with SMTP id
 6a1803df08f44-8942dd6f83dmr8568456d6.37.1768505660541; Thu, 15 Jan 2026
 11:34:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Kelly Cullinane <kelly.cullinane@oasis-open.org>
Date: Thu, 15 Jan 2026 14:33:44 -0500
X-Gm-Features: AZwV_QjLgjKCdNMgBTREr6rRU8V0tNOOzS4mPABgnuD1SxuS7hshRoGAKcyTr9E
Message-ID: <CAAiF601+3Qj+=4FA_SK7A1s_d6X2eDhhRgE5JBL3gcVQNQ+a8A@mail.gmail.com>
Subject: Invitation to comment on VIRTIO v1.4 CSD01
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ASIS members and other interested parties,

OASIS and the VIRTIO TC are pleased to announce that VIRTIO v1.4 CSD01
is now available for public review and comment.

VIRTIO TC aims to enhance the performance of virtual devices by
standardizing key features of the VIRTIO (Virtual I/O) Device
Specification.

Virtual I/O Device (VIRTIO) Version 1.4
Committee Specification Draft 01 / Public Review Draft 01
09 December 2025

TEX: https://docs.oasis-open.org/virtio/virtio/v1.4/csprd01/virtio-v1.4-csp=
rd01.html
(Authoritative)
HTML: https://docs.oasis-open.org/virtio/virtio/v1.4/csprd01/virtio-v1.4-cs=
prd01.html
PDF: https://docs.oasis-open.org/virtio/virtio/v1.4/csprd01/virtio-v1.4-csp=
rd01.pdf

The ZIP containing the complete files of this release is found in the direc=
tory:
https://docs.oasis-open.org/virtio/virtio/v1.4/csprd01/virtio-v1.4-csprd01.=
zip

How to Provide Feedback
OASIS and the VIRTIO TC value your feedback. We solicit input from
developers, users and others, whether OASIS members or not, for the
sake of improving the interoperability and quality of its technical
work.

The public review is now open and ends Friday, February 13 2026 at 23:59 UT=
C.

Comments may be submitted to the project=E2=80=99s comment mailing list at
virtio-comment@lists.linux.dev. You can subscribe to the list by
sending an email to
virtio-comment+subscribe@lists.linux.dev.

All comments submitted to OASIS are subject to the OASIS Feedback
License, which ensures that the feedback you provide carries the same
obligations at least as the obligations of the TC members. In
connection with this public review, we call your attention to the
OASIS IPR Policy applicable especially to the work of this technical
committee. All members of the TC should be familiar with this
document, which may create obligations regarding the disclosure and
availability of a member's patent, copyright, trademark and license
rights that read on an approved OASIS specification.

OASIS invites any persons who know of any such claims to disclose
these if they may be essential to the implementation of the above
specification, so that notice of them may be posted to the notice page
for this TC's work.

Additional information about the specification and the VIRTIO TC can
be found at the TC=E2=80=99s public homepage.

