Return-Path: <kvm+bounces-12866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B89488E6E1
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:45:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D8CB1C2E8BD
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FB015887E;
	Wed, 27 Mar 2024 13:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q+v5/FPb"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBC013D245
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 13:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711546469; cv=none; b=Fs1ZCdX6WUx3IkHQH7fATheywQivjMNGxi4KmbTOddNQpEWzsdj5NUQ06KZJCrHAiGL7hlbOcAa/o+Ljs2UYZ73yqqM//z9dSClpj1RS7d5KljYeGgbiP33UrJS6THer4CJqT9I5k1R8gCpDZ0BcXrvtyR5/YCegnJOcTiQV0cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711546469; c=relaxed/simple;
	bh=a+mnVz+I2LBdh7f3Jeku0JCwAoJyIxFVfnocz+i6RMc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=OJqyZY3QPXsiGlfLSqa+6QA0s6SQswbMMkElGmACbZBEySQD6jRJiRvTgukj81WaglFv6KPwp3x9HYboMLEZGE9Jyz7b12OpmDPLFKH9QmlcvT9TgWAfkH5kM6su34C/iXR+xG+vussbEUOoj+YuDEDDIL1Y1mPB3BPvbxoUk/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q+v5/FPb; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=a+mnVz+I2LBdh7f3Jeku0JCwAoJyIxFVfnocz+i6RMc=; b=q+v5/FPbwtAD6uQ9dCHGbJREjz
	H800nx781N9tH0ZcPPk9yn5Ape1VheAXWcyBkwRNqKh4v/J6DHpXEnVP9Qz74WQNMJbQVIsdax39L
	DlLF3RislEyl4kLLjeTkS7dO2SAN6YZChYNLRkkTF2vkDLvc9T3y0pW/3wF6+9ZO7wnocnQ00G53r
	KBhD2vc3Jo90OAxsDRunIY0TlD0Q9Lwepy7zWNB83EJpkEV4zhYDQ6il5F8K101e8mWUJhr+G9rSb
	4A+Q6ifEF4oA7e6058Z6Vrd6MQkld5/dNz/qhri2QxMR/MFmkWIOk/jAPxDKuKeFdMgjEPMoFD8rB
	Bv2BC0qg==;
Received: from [2a00:23ee:1868:3da7:4441:744d:10c:c781] (helo=[IPv6:::1])
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpTQ2-00000000H0t-3z9v;
	Wed, 27 Mar 2024 13:34:19 +0000
Date: Wed, 27 Mar 2024 13:34:14 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Anthony PERARD <anthony.perard@cloud.com>,
 =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>
CC: David Woodhouse <dwmw@amazon.co.uk>, qemu-devel@nongnu.org,
 =?ISO-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>,
 Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 xen-devel@lists.xenproject.org, qemu-block@nongnu.org, kvm@vger.kernel.org,
 Thomas Huth <thuth@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
 Hanna Reitz <hreitz@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH-for-9=2E0_v2_?=
 =?US-ASCII?Q?09/19=5D_hw/block/xen=5Fblkif=3A?=
 =?US-ASCII?Q?_Align_structs_with_QEMU=5FA?=
 =?US-ASCII?Q?LIGNED=28=29_instead_of_=23pragma?=
User-Agent: K-9 Mail for Android
In-Reply-To: <76ae46e6-c226-49d0-890e-c8fd64172569@perard>
References: <20231114143816.71079-1-philmd@linaro.org> <20231114143816.71079-10-philmd@linaro.org> <76ae46e6-c226-49d0-890e-c8fd64172569@perard>
Message-ID: <F096E89B-FB3B-4E06-B5A4-C28A285C07D6@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 27 March 2024 13:31:52 GMT, Anthony PERARD <anthony=2Eperard@cloud=2Ecom=
> wrote:
>On Tue, Nov 14, 2023 at 03:38:05PM +0100, Philippe Mathieu-Daud=C3=A9 wro=
te:
>> Except imported source files, QEMU code base uses
>> the QEMU_ALIGNED() macro to align its structures=2E
>
>This patch only convert the alignment, but discard pack=2E We need both o=
r
>the struct is changed=2E

Which means we need some build-time asserts on struct size and field offse=
ts=2E That should never have passed a build test=2E


