Return-Path: <kvm+bounces-38817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEDABA3E95A
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:49:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 620777AB4AF
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BFAF3597F;
	Fri, 21 Feb 2025 00:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ucsd.edu header.i=@ucsd.edu header.b="GdL3awb/";
	dkim=pass (1024-bit key) header.d=ucsd.edu header.i=@ucsd.edu header.b="bnpmtO7p"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016e101.pphosted.com (mx0b-0016e101.pphosted.com [148.163.141.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5177D3595E
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 00:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.141.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740098891; cv=none; b=j5cViajrxwn80Nd7JWah1mPMQD0Rcz0N9hmM21aVcBwfV0zHjV0WLC9KttRcKPtqNjq6zact4ieacJ1Jdmb6JCZZ4EnovUiikg9wY/H39ntyG+bEILkCuK1IWsWE5n9CKaWYjT/Y6S+76roSvlRQbeB/3wEbUcT6PrbImMqPab8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740098891; c=relaxed/simple;
	bh=Rb2hnRoAvBEZP1adk7aCeJEiq64HIBUuQHkJZH32Os0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DoBVG0A/EFh5UuHIqYoMtycd/4IlUQapEzao2C5V8qbHeaI22S2Dvuw5YCERoyHiV4MDkDNKVeQKISFCKR1MNXhEtrInY4k0e4vHsy2IWsNkd6/ltdb+FX9h2WoT+H3sRWWZZ7uCvccDhggaX1M+YHcK0nOObydfZEuJA3oMuMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ucsd.edu; spf=pass smtp.mailfrom=ucsd.edu; dkim=pass (2048-bit key) header.d=ucsd.edu header.i=@ucsd.edu header.b=GdL3awb/; dkim=pass (1024-bit key) header.d=ucsd.edu header.i=@ucsd.edu header.b=bnpmtO7p; arc=none smtp.client-ip=148.163.141.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ucsd.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucsd.edu
Received: from pps.filterd (m0151358.ppops.net [127.0.0.1])
	by mx0b-0016e101.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51KNTwCV026578
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 15:47:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucsd.edu; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=campus;
 bh=RTidP2TmFgjqhsc1g4irQg/mrtI+4iJDGIceeV8Znpk=;
 b=GdL3awb/f+bxPKBT5doM1lO/RoCbruePFwEjYpsmjAHsL4F3duh+0znnaJfn1sERBTUR
 4yg2SZJUjf9qlLWOwJS8TU2d44l2hJOFdwgluAaVcCcOMJs1XyCL0FieAvpevMOefLMR
 m7XTVGJbrReKJU0F6c4hwuYbrGm8fXh7IJbwl333KfzP5SjyT+mHVNasTiIC4nCn7FDI
 2ObvVXyRDtojOwwZkGXSPzJ+KSSqf5OiuQqx5201DLQhGDp+xypgr3+kbjyvkr+2mKt9
 etM3fsrvXl+TmI92FN6kfKSRqzlzCGYPgg0m5CVr5ntnqWtd5qxqi3Pq81ig8el9NpX3 Og== 
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0b-0016e101.pphosted.com (PPS) with ESMTPS id 44w019efds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 15:47:36 -0800
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-220c86b3ef3so52898225ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 15:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucsd.edu; s=google; t=1740095255; x=1740700055; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTidP2TmFgjqhsc1g4irQg/mrtI+4iJDGIceeV8Znpk=;
        b=bnpmtO7pzpU0XedY+QaDpXTllegRHGnqOEfJZ7AQt9TQvmcRvqBrW2zjDMYMdC74ky
         dkTc9y18I+ZwxloFSr3RTmj7RjyZ5JF4chHMYKYPNW6pBtlcxzDB6g7+WNBFAN81W2Bp
         2lkM2BB97P2W3ylJ7WtPtRNeO4Xt2jrqy4jhs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740095255; x=1740700055;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RTidP2TmFgjqhsc1g4irQg/mrtI+4iJDGIceeV8Znpk=;
        b=aUo5No3yUp3OEVzeCXvHBYW7j8ZMIeOK5Ac3Ip804XXjz1UBVTMoJvBuzM7owA0Cpv
         i127GL+Ss1NO3hqo/XcmtJz7tnbxnUxtkCoOBfHT8hmaCWRG6DB/ywoNsc79D8AmynYZ
         YE7r3edkMOmNTEv+YmKxPFmgP89JyvyBSq5o+QXZ/3RlH0MlHE0z7+dBIWcFcsoiq9le
         9Gqn/oByQq8VObCkuQ4yRqKeSvITIpmtYm7h+Rxt/KogafjysU0g+B1hBrV/zIqtm/Gr
         4rCJ53Hed2USjHlAXuebkcjw8TAr02vYKX7BC6jJab3YdDmQMuJTLgZ9B+8p0pF9KIbo
         Yvwg==
X-Gm-Message-State: AOJu0YzZzhZ1GmHfKhLeH3ifqNPpmdqZFpfiMe8vcwhSgGVRZ1tNZQYy
	4ZGbjBkmEwroMzgABg0U+EEpWAGFaZk+zJ6g4r8bv3EboQofFDPLXOHDUVXLEo2TtRyJ+VSdBY4
	99wqjgyJsUzTFdW24OszI7LMmU599fZcszUm2XojU/MJIZDm+ai/RcpohGQ8VhpynP3aRp7bZpc
	/N4+6r8sKryjLrU7RfAEb3wlQ=
X-Gm-Gg: ASbGncuHaMS5FyyttVsUljqAzJy5/dvBRK+Ua5GiC8O+TUJmEXSHMOPBsSq2IUlNhUZ
	s6n+zaRikB4M0RPQV0tOnQr+wef2NL8qRnXuwBElfsoNbV+3bm4V2ShwbL4Rm
X-Received: by 2002:a17:902:db0f:b0:21f:3823:482b with SMTP id d9443c01a7336-2218c765821mr90619365ad.25.1740095255179;
        Thu, 20 Feb 2025 15:47:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8nXYBXBp2u+ydkzGuVzLEwdiiQM0BsRPrzmKD4DMijrqYf2yfFlCxnX6kdZ/yFrrQbdYXb7tYKA/iBJyRWxE=
X-Received: by 2002:a17:902:db0f:b0:21f:3823:482b with SMTP id
 d9443c01a7336-2218c765821mr90619015ad.25.1740095254735; Thu, 20 Feb 2025
 15:47:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CH3P220MB190880164B32300C91BBA037AAE12@CH3P220MB1908.NAMP220.PROD.OUTLOOK.COM>
 <CAK51q6WPAWbmqL=qaiPU1cg1rNAehzUpaZS3K-oWmRU+KD5Gug@mail.gmail.com> <Z7d9KZWpOpUD6TIc@google.com>
In-Reply-To: <Z7d9KZWpOpUD6TIc@google.com>
From: Aaron Ang <a1ang@ucsd.edu>
Date: Thu, 20 Feb 2025 15:47:22 -0800
X-Gm-Features: AWEUYZlyf7rB6vQ4XqdEkhmVTMBKtVEsRGxXA0Nl3BdiDu-iylUdxQNrFvGZl8g
Message-ID: <CAK51q6W_7QTgdK-JxkjrLYpHnHZUujQZQ0tXdpLiaBsD5gc25g@mail.gmail.com>
Subject: Re: Interest in contributing to KVM TODO
To: Sean Christopherson <seanjc@google.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jukaufman@ucsd.edu" <jukaufman@ucsd.edu>,
        "eth003@ucsd.edu" <eth003@ucsd.edu>, Alex Asch <aasch@ucsd.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-campus_gsuite: gsuite_33445511
X-Proofpoint-GUID: 6hOOAP3AyiRwy7aBvJW4Z1Qy1nAj5ZV_
X-Proofpoint-ORIG-GUID: 6hOOAP3AyiRwy7aBvJW4Z1Qy1nAj5ZV_
pp_allow_relay: proofpoint_allowed
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-20_09,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 clxscore=1015 suspectscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=-50 reason=mlx
 scancount=1 engine=8.12.0-2502100000 definitions=main-2502200158

Hi Sean,

Thank you for getting back to us. We are looking at a timeline of
about 3-4 weeks. We are interested in KVM/virtualization in general
and memory management. Ideally, we would work on a fairly scoped task
given our limited experience and timeline. We initially planned to
change the implementation details in `x86/kvm/mmu/mmu.c` to use
approximate LRU, then run some performance benchmarks to compare with
the current FIFO implementation. However, we understand from your
reply that KVM has defaulted to TDP MMU.

Are there any backlog tasks that fit our timeline? We are open to
anything (comparison benchmarks, bug fixes, small features, etc.). Our
solution will probably not be foolproof, but we hope to produce
something actionable for future KVM efforts. Happy to discuss further.

Regards,
Aaron
---------------------------------------------------------------------
From: Sean Christopherson <seanjc@google.com>
Date: Thursday, 20 February 2025 at 11:06=E2=80=AFAM
To: Aaron Ang <a1ang@ucsd.edu>
Cc: kvm@vger.kernel.org <kvm@vger.kernel.org>, jukaufman@ucsd.edu
<jukaufman@ucsd.edu>, eth003@ucsd.edu <eth003@ucsd.edu>, Alex Asch
<aasch@ucsd.edu>
Subject: Re: Interest in contributing to KVM TODO

On Wed, Jan 22, 2025, Aaron Ang wrote:
> Hi KVM team,
>
> We are a group of graduate students from the University of California,
> San Diego, interested in contributing to KVM as part of our class
> project. We have identified a task from the TODO that we would like to

Oof, https://urldefense.com/v3/__https://www.linux-kvm.org/page/TODO__;!!Mi=
h3wA!GHlu-1K3bzLd-0OuL5LV30AtMELMkt6xiZXu7wenC6b28xauSSG0z0BVnF-9bLDpYHD97a=
1YrLov9w$
 is a "bit" stale.

> tackle: Improve mmu page eviction algorithm (currently FIFO, change to
> approximate LRU). May I know if there are any updates on this task,
> and is there room for us to develop in this space?

AFAIK, no one is working on this particular task, but honestly I
wouldn't bother.
There are use cases that still rely on shadow paging[1], but those tend to =
be
highly specialized and either ensure there are always "enough" MMU
pages available,
or in the case of PVM, I suspect there are _significant_ out-of-tree change=
s to
optimize shadow paging as a whole.

With the TDP MMU, KVM completely ignores the MMU page limit (both KVM's def=
ault
and the limit set by KVM_SET_NR_MMU_PAGES.  With TDP, i.e. without
shadow paging,
the number of possible MMU pages is a direct function of the amount of memo=
ry
exposed to the guest, i.e. there is no danger of KVM accumulating too many =
page
tables due shadowing a large number of guest CR3s.

With nested TDP, KVM does employ shadow paging, but the behavior of an
L1 hypervisor
using TDP is wildly different than an L1 kernel managing "legacy" page
tables for
itself and userspace.  If an L1 hypervisor manages to run up against KVM's =
limit
on the number of MMU pages, then in all likelihood it deserves to die :-)

What areas are y'all looking to explore?  E.g. KVM/virtualization in genera=
l,
memory management in particular, something else entirely?  And what timelin=
e are
you operating on, i.e. how big of a problem/project are you looking to tack=
le?

[1] https://urldefense.com/v3/__https://lore.kernel.org/all/20240226143630.=
33643-1-jiangshanlai@gmail.com__;!!Mih3wA!GHlu-1K3bzLd-0OuL5LV30AtMELMkt6xi=
ZXu7wenC6b28xauSSG0z0BVnF-9bLDpYHD97a1KsoVHiQ$

> We also plan to introduce other algorithms and compare their performance
> across various workloads. We would be happy to talk to the engineers owni=
ng
> the MMU code to see how we can coordinate our efforts. Thank you.

