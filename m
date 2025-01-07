Return-Path: <kvm+bounces-34676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 006BCA040A8
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 14:16:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EBC53A19D9
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 13:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF2F1F03C6;
	Tue,  7 Jan 2025 13:16:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276DD1F03E0
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 13:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736255807; cv=none; b=cyw+jOYC9Q9ajW3Pb3iXSE4cgEsQDP5G/C3yS/tNJfb0X8U+6ihnjfaOmOeUrhLrCrozniJRp7Fr5NnacjqF8o+bSijwv5aCFoFnVIlqdiYnw07Zi3KMgiXQhDFs1QC95FpPWRzy1xpLS1NvjS8Zj/6mXcWPbkmcBpRYxve3DuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736255807; c=relaxed/simple;
	bh=prC47+6QXvTu8W0NaSO4rYCu/f9B2b9TITOPyGPuRCc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=b3ALq4ZbfWFQ+wlgDw33paPyBbFwGi07jSFDfaDN9LcIsnmVYibiygUypB1+dgTa3xQnDv2oNx6BNZ8J8ZUBT8lARQrxJG178ydWOjj7oP36voXZpBJTk161JPLlMu5V6nyk50pmjrLtltq8gIWfInQFVB/P3D3G1LLY5tAcy8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 5741C4E6000;
	Tue, 07 Jan 2025 14:09:32 +0100 (CET)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
 by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
 with ESMTP id U0rxOlpL8Io9; Tue,  7 Jan 2025 14:09:30 +0100 (CET)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id 62FA44E6010; Tue, 07 Jan 2025 14:09:30 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 60242746F60;
	Tue, 07 Jan 2025 14:09:30 +0100 (CET)
Date: Tue, 7 Jan 2025 14:09:30 +0100 (CET)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>
cc: Daniel Henrique Barboza <dbarboza@ventanamicro.com>, qemu-devel@nongnu.org, 
    =?ISO-8859-15?Q?Fr=E9d=E9ric_Barrat?= <fbarrat@linux.ibm.com>, 
    Stefano Stabellini <sstabellini@kernel.org>, 
    Ilya Leoshkevich <iii@linux.ibm.com>, Cameron Esfahani <dirty@apple.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
    Alexander Graf <agraf@csgraf.de>, Paul Durrant <paul@xen.org>, 
    David Hildenbrand <david@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, 
    Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
    xen-devel@lists.xenproject.org, qemu-arm@nongnu.org, 
    =?ISO-8859-15?Q?C=E9dric_Le_Goater?= <clg@redhat.com>, 
    Yanan Wang <wangyanan55@huawei.com>, Reinoud Zandijk <reinoud@netbsd.org>, 
    Peter Maydell <peter.maydell@linaro.org>, qemu-s390x@nongnu.org, 
    Riku Voipio <riku.voipio@iki.fi>, Anthony PERARD <anthony@xenproject.org>, 
    Alistair Francis <alistair.francis@wdc.com>, 
    Sunil Muthuswamy <sunilmut@microsoft.com>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    Nicholas Piggin <npiggin@gmail.com>, 
    Richard Henderson <richard.henderson@linaro.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, Thomas Huth <thuth@redhat.com>, 
    Roman Bolshakov <rbolshakov@ddn.com>, 
    "Edgar E . Iglesias" <edgar.iglesias@amd.com>, 
    Zhao Liu <zhao1.liu@intel.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
    David Woodhouse <dwmw2@infradead.org>, 
    Harsh Prateek Bora <harshpb@linux.ibm.com>, 
    Nina Schoetterl-Glausch <nsg@linux.ibm.com>, 
    "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, 
    Eduardo Habkost <eduardo@habkost.net>, qemu-ppc@nongnu.org, 
    Daniel Henrique Barboza <danielhb413@gmail.com>, 
    "Michael S. Tsirkin" <mst@redhat.com>, Anton Johansson <anjo@rev.ng>
Subject: Re: [RFC PATCH 6/7] accel/hvf: Use CPU_FOREACH_HVF()
In-Reply-To: <6df59c2c-e29d-4b86-8908-4cb9093bad13@linaro.org>
Message-ID: <4abe9825-ff86-5e7d-1170-3677d5494879@eik.bme.hu>
References: <20250106200258.37008-1-philmd@linaro.org> <20250106200258.37008-7-philmd@linaro.org> <bd8168fe-c774-4f75-8a94-1a67ec31e38d@ventanamicro.com> <6df59c2c-e29d-4b86-8908-4cb9093bad13@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3866299591-1325344726-1736255370=:80373"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--3866299591-1325344726-1736255370=:80373
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 6 Jan 2025, Philippe Mathieu-Daudé wrote:
> On 6/1/25 21:33, Daniel Henrique Barboza wrote:
>> 
>> 
>> On 1/6/25 5:02 PM, Philippe Mathieu-Daudé wrote:
>>> Only iterate over HVF vCPUs when running HVF specific code.
>>> 
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>> ---
>>>   include/system/hvf_int.h  | 4 ++++
>>>   accel/hvf/hvf-accel-ops.c | 9 +++++----
>>>   target/arm/hvf/hvf.c      | 4 ++--
>>>   3 files changed, 11 insertions(+), 6 deletions(-)
>>> 
>>> diff --git a/include/system/hvf_int.h b/include/system/hvf_int.h
>>> index 42ae18433f0..3cf64faabd1 100644
>>> --- a/include/system/hvf_int.h
>>> +++ b/include/system/hvf_int.h
>>> @@ -11,6 +11,8 @@
>>>   #ifndef HVF_INT_H
>>>   #define HVF_INT_H
>>> +#include "system/hw_accel.h"
>>> +
>>>   #ifdef __aarch64__
>>>   #include <Hypervisor/Hypervisor.h>
>>>   typedef hv_vcpu_t hvf_vcpuid;
>>> @@ -74,4 +76,6 @@ int hvf_put_registers(CPUState *);
>>>   int hvf_get_registers(CPUState *);
>>>   void hvf_kick_vcpu_thread(CPUState *cpu);
>>> +#define CPU_FOREACH_HVF(cpu) CPU_FOREACH_HWACCEL(cpu)
>> 
>> 
>> Cosmetic comment: given that this is HVF specific code and we only support 
>> one hw
>> accelerator at a time, I'd skip this alias and use CPU_FOREACH_HWACCEL(cpu) 
>> directly.
>> It would make it easier when grepping to see where and how the macro is 
>> being used.
>
> I find it more useful to grep for a particular accelerator, or for
> all of them:
>
> $ git grep CPU_FOREACH_
> accel/hvf/hvf-accel-ops.c:507:    CPU_FOREACH_HVF(cpu) {
> accel/hvf/hvf-accel-ops.c:546:    CPU_FOREACH_HVF(cpu) {
> accel/kvm/kvm-all.c:875:        CPU_FOREACH_KVM(cpu) {
> accel/kvm/kvm-all.c:938:    CPU_FOREACH_KVM(cpu) {
> accel/tcg/cputlb.c:372:    CPU_FOREACH_TCG(cpu) {
> accel/tcg/cputlb.c:650:        CPU_FOREACH_TCG(dst_cpu) {

But then you need to define a new macro for every new accelerator. Maybe 
it's simpler to have CPU_FOREACH take the queue as a parameter so no 
separate macro is needed for each accel (and they cannot get inconsistent 
by changing only one of them in the future).

Regards,
BALATON Zoltan
--3866299591-1325344726-1736255370=:80373--

