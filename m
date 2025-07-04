Return-Path: <kvm+bounces-51594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76824AF8EBD
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 11:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DD851CA38CB
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 09:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87ABC2E7F07;
	Fri,  4 Jul 2025 09:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ynddal.dk header.i=@ynddal.dk header.b="fv4d+/ss"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster2-host12-snip4-10.eps.apple.com [57.103.87.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B830136E
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 09:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.87.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751621689; cv=none; b=nSxbMXFAHw8DtUfWeIAa3duG01zSmGk+xM9eJoZ++LoTXVgDP+lE05vn0mysMSUjwTM6W+0LPuOnQvESxb0wjtMTgIBKyLWFUK4TmrtZRdZ0lWvydmhw1Acol3AiMeq7CS/v5eSSvR2N6EUxSqNdSLORSqD9XvNee/TpBYRT7+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751621689; c=relaxed/simple;
	bh=zCj+Vw0RZVvlh7Wrqj1LSqhABOtf9pPpRKfXDZjtSk0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=frLWich454EeN1IPjm00QvmsCdeppdTSfxxV80aW5EcFTAbezxMS08AYXgGK3hp3oEyBQBMCtc0iwtyrvN1ypkGkccPkOFljOLCWg/WePVEcRdKRKk+sfHZ8GzbvVxOB5EAbdlQWMHuAU8wQrUh5T+8rTqoDuy0hwXr8WMC2f9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ynddal.dk; spf=pass smtp.mailfrom=ynddal.dk; dkim=pass (2048-bit key) header.d=ynddal.dk header.i=@ynddal.dk header.b=fv4d+/ss; arc=none smtp.client-ip=57.103.87.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ynddal.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ynddal.dk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
	bh=jC7wpVSfptGSKQNhfifAQf88TarhTWI3lXHmAPkaLIE=;
	h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme;
	b=fv4d+/ssMjjZRvl+bi2zpn1ICNfnzzmG2pf+BB3syOrG+HLD2UnuHw9UJqfMpn0Cz
	 oCNxQG3iNNDAfVvMLWDOo0J8axx8pDeZA9iwsDphTABCjkHHOTiR60DePOKkzMhA1r
	 w6sqv/KEq4g6KRcEdpV5Fm25TcUL4dAtFDzMqdw2ATaqUqLAyBq0rWfOrV8m5hvkj8
	 8hfnr/Qd63XZYhOzP7VZwRN9noq/FbDkmYggLZP8BsG/4PNxOM0YCSSOfIwAEoDYUy
	 o/ejRzOVXWuwGp1nPBPwa48hsxjf76seYOyPTuerm61lx6CrricdKlBvnpmz3BAztG
	 UjS/kP4MWi5mQ==
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by outbound.qs.icloud.com (Postfix) with ESMTPS id 4B3EE1800146;
	Fri,  4 Jul 2025 09:34:42 +0000 (UTC)
Received: from smtpclient.apple (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by outbound.qs.icloud.com (Postfix) with ESMTPSA id 80C6D1800166;
	Fri,  4 Jul 2025 09:34:39 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v4 58/65] accel: Always register
 AccelOpsClass::get_elapsed_ticks() handler
From: Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <20250702185332.43650-59-philmd@linaro.org>
Date: Fri, 4 Jul 2025 11:34:28 +0200
Cc: qemu-devel@nongnu.org,
 =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Cameron Esfahani <dirty@apple.com>,
 Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Fabiano Rosas <farosas@suse.de>,
 Laurent Vivier <lvivier@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>,
 Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6E85BEC9-8431-4078-AE7D-B39575A0A155@ynddal.dk>
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-59-philmd@linaro.org>
To: =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA0MDA3MyBTYWx0ZWRfX4RhBOv1FtGUi
 paYD8h7EWn4Xf8MRKYylkrEyXc7vsT7b8A8y8ICl5BJ44GCBKuwIMwd8OID7Lt1AmN6Xkbpkhxo
 evhMRfcU7UWhMWy3GNDmwmyoZiLPr6wGzGw2vkkRlXhJ64tqKG5+VrP8KolE79P+YubgkeKiqdy
 tbBKrZiEF/Wf3FDcv/Sk8qOgqjLaGWQvYvcNk2O5OxoM5dZDfsucgJRG9/dVgd1DvfbUy4ULiJO
 P6I5JALT74fCxmhI0WoAHBdkUjQpWs7e3kCzNKhfkcvVb6yQTSkeYbC/0i8HoZ9vCMH6tvFgY=
X-Proofpoint-GUID: koFkGGtkRgsisw6n9qz2oN3WDN2lMeNE
X-Proofpoint-ORIG-GUID: koFkGGtkRgsisw6n9qz2oN3WDN2lMeNE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-04_03,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 adultscore=0 mlxscore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506060001 definitions=main-2507040073


> On 2 Jul 2025, at 20.53, Philippe Mathieu-Daud=C3=A9 =
<philmd@linaro.org> wrote:
>=20
> In order to dispatch over AccelOpsClass::get_elapsed_ticks(),
> we need it always defined, not calling a hidden handler under
> the hood. Make AccelOpsClass::get_elapsed_ticks() mandatory.
> Register the default cpus_kick_thread() for each accelerator.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
> include/system/accel-ops.h        | 1 +
> accel/hvf/hvf-accel-ops.c         | 2 ++
> accel/kvm/kvm-accel-ops.c         | 3 +++
> accel/qtest/qtest.c               | 2 ++
> accel/tcg/tcg-accel-ops.c         | 3 +++
> accel/xen/xen-all.c               | 2 ++
> system/cpus.c                     | 6 ++----
> target/i386/nvmm/nvmm-accel-ops.c | 3 +++
> target/i386/whpx/whpx-accel-ops.c | 3 +++
> 9 files changed, 21 insertions(+), 4 deletions(-)
>=20

Reviewed-by: Mads Ynddal <mads@ynddal.dk>


