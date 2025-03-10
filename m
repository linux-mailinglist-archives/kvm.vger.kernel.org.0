Return-Path: <kvm+bounces-40649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7531AA5962A
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 14:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6262A16F044
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B90229B01;
	Mon, 10 Mar 2025 13:23:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460ED21E0BF
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 13:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741613034; cv=none; b=OswdecaYJd9HlF6lt1GFnOYjqPHwCigSEnv3lZOJyioyL9tVyxcXDiQgodNdBJxrxQ1kuPr+WW+9kGPBjBX4LiLiH4tTzIYevBLyZ2j2ihyykv+F+eQNe67KTyjEIFHzPbegVziSEGJd+cd0Sc+ul+rYM0/d+8lI+JEI1g9iDDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741613034; c=relaxed/simple;
	bh=diXrk1rplAUzKI80cUzN1oOz+3hA53Jngsy+7v+1V+M=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tk0unOCdchjNFtMjJ2Z3UZY3pLbJm9C3NYqaUAA81yt1d5hJCTNGAOQS3SKB1mPiL3QqAe8knBhiMwaory4my1Wz2tC4AaoHeBcilXULebr8j4itoW6rOiZ1qj/2944/DcGTWtElwYy+8J2csG2+GyHitUFpuqW1ePgwmiN7+yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 1B5624E602E;
	Mon, 10 Mar 2025 14:23:49 +0100 (CET)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
 by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
 with ESMTP id XvkD-BHqHTfr; Mon, 10 Mar 2025 14:23:46 +0100 (CET)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id C9D5B4E6029; Mon, 10 Mar 2025 14:23:46 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id C787874577D;
	Mon, 10 Mar 2025 14:23:46 +0100 (CET)
Date: Mon, 10 Mar 2025 14:23:46 +0100 (CET)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
cc: qemu-devel@nongnu.org, qemu-ppc@nongnu.org, 
    Alistair Francis <alistair.francis@wdc.com>, 
    Richard Henderson <richard.henderson@linaro.org>, 
    Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org, 
    Palmer Dabbelt <palmer@dabbelt.com>, 
    Daniel Henrique Barboza <danielhb413@gmail.com>, kvm@vger.kernel.org, 
    Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
    Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
    David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>, 
    Paul Durrant <paul@xen.org>, 
    "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, 
    =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, 
    Anthony PERARD <anthony@xenproject.org>, 
    Yoshinori Sato <ysato@users.sourceforge.jp>, 
    manos.pitsidianakis@linaro.org, qemu-riscv@nongnu.org, 
    Paolo Bonzini <pbonzini@redhat.com>, xen-devel@lists.xenproject.org, 
    Stefano Stabellini <sstabellini@kernel.org>
Subject: Re: [PATCH 00/16] make system memory API available for common code
In-Reply-To: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
Message-ID: <f231b3be-b308-56cf-53ff-1a6a7fb4da5c@eik.bme.hu>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Sun, 9 Mar 2025, Pierrick Bouvier wrote:
> The main goal of this series is to be able to call any memory ld/st function
> from code that is *not* target dependent.

Why is that needed?

> As a positive side effect, we can
> turn related system compilation units into common code.

Are there any negative side effects? In particular have you done any 
performance benchmarking to see if this causes a measurable slow down? 
Such as with the STREAM benchmark:
https://stackoverflow.com/questions/56086993/what-does-stream-memory-bandwidth-benchmark-really-measure

Maybe it would be good to have some performance tests similiar to 
functional tests that could be run like the CI tests to detect such 
performance changes. People report that QEMU is getting slower and slower 
with each release. Maybe it could be a GSoC project to make such tests but 
maybe we're too late for that.

Regards,
BALATON Zoltan

