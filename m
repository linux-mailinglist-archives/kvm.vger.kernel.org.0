Return-Path: <kvm+bounces-44225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C81A9B9A4
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C6991B687AF
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 21:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C4128935D;
	Thu, 24 Apr 2025 21:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="b2EYzYod"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBB279F5;
	Thu, 24 Apr 2025 21:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529318; cv=none; b=KTaOh/CE8i6uifWaZHtA7+IKstUg4DhN9BbACunVVoF6uZ0WTeQBGxqcI5BrkXpiP869WqciETtnQP4czU8Zm4O7ap2NB2OnVCSQHM64LwVim5E0QQynbsKpUBd2V3jU+xB+leRoGcEmovk7gBkX4n/hbhCr+pnmJHRNM1PAsmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529318; c=relaxed/simple;
	bh=fbePqpXsVBFA3b05CfQZoudDssWCQj14Vtwe8+dAbac=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=SR5mfJmUWdamu3GPkRu24KGPphcz6AtDYJbZYy8CTcTA24289uJwcJCkW8O//1ruk2OPf08iojlKhEe8JjybcQtOXwPTg2CiHbHXpsNVJ6oq49Xluk/oyoEC1nj71bDhAFRqAOP6vVd07CBzNEFwptdAHn+zP/L6oT+HsfjY6RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=b2EYzYod; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53OLEFGV1614013
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 24 Apr 2025 14:14:15 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53OLEFGV1614013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745529257;
	bh=fbePqpXsVBFA3b05CfQZoudDssWCQj14Vtwe8+dAbac=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=b2EYzYodyQjJ1ivIsEmkKH2t2+MFFTbYKTMXxiq4ngho+EPg7RDeSa2QY0zU3k7I6
	 RN61uEVxuOFyhUwF3mAy8cHv6Z4FYf2CxBcMEmWvdr2DQUvRfPzZM/iNJ2SaZGkcbi
	 UDaP7PXrKVnNJgW3SRLPxFD1BMbGSjssSS7c0i84j+8Jm8fWDnoENz8P5a1Jd5X9AE
	 YeKJLfs/prqdFpmvrMCTt4Lf9g4iZhNiXh9GJorxSh8b9JQoVphIe+5AyBQlhioJ6S
	 KAYln5qQrQumWrckqE9SV5vLlM+oXOd+2n91sqkeXt69I3byDARDpBKA8HfhZxu6f+
	 76vUr76BOVI7A==
Date: Thu, 24 Apr 2025 14:14:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xin Li <xin@zytor.com>, =?ISO-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, acme@kernel.org,
        andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        kan.liang@linux.intel.com, wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: Re: [RFC PATCH v2 12/34] x86/msr: Remove pmu_msr_{read,write}()
User-Agent: K-9 Mail for Android
In-Reply-To: <ca088501-2fbe-4a32-b191-04f7be6a2713@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com> <20250422082216.1954310-13-xin@zytor.com> <8944b510-6d70-472c-99a2-52a60517733d@suse.com> <ca088501-2fbe-4a32-b191-04f7be6a2713@zytor.com>
Message-ID: <018705C7-35CF-406A-85DA-360FF7BCB072@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On April 24, 2025 10:49:59 AM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 4/24/2025 3:05 AM, J=C3=BCrgen Gro=C3=9F wrote:
>>=20
>> May I suggest to get rid of the "emul" parameter of pmu_msr_chk_emulate=
d()?
>> It has no real value, as pmu_msr_chk_emulated() could easily return fal=
se in
>> the cases where it would set *emul to false=2E
>
>Good idea!
>
>The function type is a bit of weird but I didn't think of change it=2E

It is weird in the extreme=2E=20

By the way, this patch should have "xen" in its subject tag=2E

