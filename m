Return-Path: <kvm+bounces-50533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE652AE6EC2
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:40:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E314F7A4EE1
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708652E6D31;
	Tue, 24 Jun 2025 18:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="DfcWTi+A"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FB83074B5;
	Tue, 24 Jun 2025 18:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750790445; cv=none; b=ocMCRxXQQYIacp6gQ4O9NVeQK9i7J/rAGFH0E7tsPdGXJ7tHSXdJmwI/J/mAR6WbKQJfyy9j/pmiOAAObSHiRDbP+vkYGM3qN3d1rP4bgr2DMwfKk1nsXPT+s6CaV/TI4W+gqGB4A6VqvcOYK9yG2QRL6m1UFjrA7B/2f8h8M8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750790445; c=relaxed/simple;
	bh=RaKMVenHpXTiijDnnUSu51b+dkVcQ43L2EZ2DjqU9Vs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=GNHHcG6YovS3ZBaT76zreql1d7638SNf1WXcbJWKWDSTz05N/ggwz7bBp0YZEPTLJTI3DFXqJAUgKZRl+8Vw2sbfgFQ2UfoDtC8omHW6Zb6jV2HgFsTok7Fe/4G2pMRFa7o8mWr0n8xTeJZpQMd5OIB0c9O9gdasMDoWL2p4xoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=DfcWTi+A; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55OIeEuG1461582
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 24 Jun 2025 11:40:15 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55OIeEuG1461582
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750790415;
	bh=RaKMVenHpXTiijDnnUSu51b+dkVcQ43L2EZ2DjqU9Vs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=DfcWTi+A+bEdns70+O8m6NIOIC9aZTxHpMPbc+vZcjxm2GiPzbI9XGHSQtkfFz0hv
	 2pcL0LTI/Qc8PeRRop9P0n5NY/WvgcZhmxs7SgFGAMdg7joM8uZAYeB5yMJfTbeery
	 Ujgkj4ahzeU+UTlRJs5JZKlCXj+4gn5kJ3fzmkuVUR7+nEYvuqmDJ66zMEzTZIgTJN
	 NqnqVn1ZI9fG47BNbCwZne3Tz9obMlO3TsQrCkM1bZoIcxQ+ArTVRPApiuyCdsWo8w
	 s1TfWMvmOgFp5xVhVQ8gIDKXhsFyyEdCO1HcfpTIHTFGrcjsXXZqeUhLAvKlYdxFcq
	 DZLNok8pN77IQ==
Date: Tue, 24 Jun 2025 11:40:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xin Li <xin@zytor.com>, Sean Christopherson <seanjc@google.com>
CC: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, andrew.cooper3@citrix.com, luto@kernel.org,
        peterz@infradead.org, chao.gao@intel.com, xin3.li@intel.com
Subject: Re: [PATCH v4 00/19] Enable FRED with KVM VMX
User-Agent: K-9 Mail for Android
In-Reply-To: <72cc4e30-1678-49be-8d36-b18287c26966@zytor.com>
References: <20250328171205.2029296-1-xin@zytor.com> <d243d203-7514-4541-9ea2-1200f7116cc1@zytor.com> <aFrbIgouGiZWf51O@google.com> <80ba45cf-2679-471b-ae3d-986697089b75@zytor.com> <D379AE34-58DE-4082-B0DF-1D1AE463D19A@zytor.com> <72cc4e30-1678-49be-8d36-b18287c26966@zytor.com>
Message-ID: <E56DFF0F-8BB8-4E19-805B-B40344E6C750@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 24, 2025 11:02:41 AM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 6/24/2025 10:47 AM, H=2E Peter Anvin wrote:
>> FRED doesn't lean on CET=2E=2E=2E one could argue it leans on LASS, at =
least to a small extent, though=2E
>
>Probably I used a wrong verb "lean", "overlap" is better=2E

I would personally say to the extent there is overlap it is the opposite d=
irection (FRED helps enable kCET, but uCET is pretty much orthogonal=2E)

