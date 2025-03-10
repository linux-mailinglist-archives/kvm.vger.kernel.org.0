Return-Path: <kvm+bounces-40647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BE2DA59545
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:55:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF2087A6A7A
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE3C2288C6;
	Mon, 10 Mar 2025 12:54:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F112D227E99
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 12:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741611293; cv=none; b=gE47ArVDnDrvLUT+cE0KKA53VzyFBMPZtAL20ePXnUJW8n6jDSWeXjtM1/9eoD81KjeeBM+rUegMY1vcjRBO/4UL5kwmLc7asbe5XLrri3TcpTIoSLPqKdgzCzqPOLzJmI8lSHpKTgGIWa+QGIiAB9Y/p3h3Oxdp8vI3KZ30YDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741611293; c=relaxed/simple;
	bh=W3/9O1Y0xJrnCEvAJcPmVWqBzYcdq2h/xZElW405+C0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=S2OQYpuDycjF8+vKCY5h553JGv9ALxXGULyO61NaN2zdV7EXRDT+rYxY6mvLOQL5f8E0GR2/nlgYA2vSX7NSw1vyyNCh3huNb/q80Fk3s+Yg/1bXvtvMtjPKOj8W8GFjcAefzIgBaA54hFkaPcq1q+wf4IYFeM1/noh8rNuSpFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 4A2234E6030;
	Mon, 10 Mar 2025 13:54:42 +0100 (CET)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
 by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
 with ESMTP id eEgzcnJ1JlRt; Mon, 10 Mar 2025 13:54:40 +0100 (CET)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id 5C90B4E602E; Mon, 10 Mar 2025 13:54:40 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 58FC474577C;
	Mon, 10 Mar 2025 13:54:40 +0100 (CET)
Date: Mon, 10 Mar 2025 13:54:40 +0100 (CET)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: Eric Auger <eric.auger@redhat.com>
cc: =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, 
    qemu-devel@nongnu.org, Yi Liu <yi.l.liu@intel.com>, 
    Pierrick Bouvier <pierrick.bouvier@linaro.org>, 
    Alex Williamson <alex.williamson@redhat.com>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    =?ISO-8859-15?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, 
    Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, 
    Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, 
    David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>, 
    Matthew Rosato <mjrosato@linux.ibm.com>, 
    Tomita Moeko <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org, 
    Daniel Henrique Barboza <danielhb413@gmail.com>, 
    Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, 
    Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org, 
    Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org, 
    Paolo Bonzini <pbonzini@redhat.com>, 
    Harsh Prateek Bora <harshpb@linux.ibm.com>, 
    =?ISO-8859-15?Q?C=E9dric_Le_Goater?= <clg@redhat.com>, 
    Ilya Leoshkevich <iii@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
    =?ISO-8859-15?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>, 
    Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v2 09/21] hw/vfio/pci: Convert CONFIG_KVM check to runtime
 one
In-Reply-To: <28c102c1-d157-4d22-a351-9fcc8f4260fd@redhat.com>
Message-ID: <2d44848e-01c1-25c5-dfcb-99f5112fcbd7@eik.bme.hu>
References: <20250308230917.18907-1-philmd@linaro.org> <20250308230917.18907-10-philmd@linaro.org> <28c102c1-d157-4d22-a351-9fcc8f4260fd@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3866299591-1686296412-1741611280=:72286"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--3866299591-1686296412-1741611280=:72286
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 10 Mar 2025, Eric Auger wrote:
> Hi Philippe,
>
> On 3/9/25 12:09 AM, Philippe Mathieu-Daudé wrote:
>> Use the runtime kvm_enabled() helper to check whether
>> KVM is available or not.
>
> Miss the "why" of this patch.
>
> By the way I fail to remember/see where kvm_allowed is set.

It's in include/system/kvm.h

> I am also confused because we still have some code, like in
> vfio/common.c which does both checks:
> #ifdef CONFIG_KVM
>         if (kvm_enabled()) {
>             max_memslots = kvm_get_max_memslots();
>         }
> #endif

I think this is because if KVM is not available the if cannot be true so 
it can be left out altogether. This may make sense on platforms like 
Windows and macOS where QEMU is compiled without KVM so basically 
everywhere except Linux.

Regards,
BALATON Zoltan
--3866299591-1686296412-1741611280=:72286--

