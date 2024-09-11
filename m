Return-Path: <kvm+bounces-26558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 056AB9757F7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 18:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87FF01F22F00
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 16:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E901AC42A;
	Wed, 11 Sep 2024 16:09:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D8719CC05
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 16:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726070947; cv=none; b=tiv2IbB709n8qiWbXUyevgq2Wu8axdPccFesPV1Vv4i4Dd7wVUAsPuPNhxadN43ufsgG0rt/ZURkAIKecz9rh/ocM2Xrycjx4D91Ss1ijk2x5xTRtwYT4zKBj5XJLnEfjW1gAgAy1EpeHuwkcVXMrr4/JQ9Rok78fgfmYIoIqcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726070947; c=relaxed/simple;
	bh=nm1CeJyYBieD1E1/5qigB/OZZZR0KzilE+yVlrGdDgM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=JHvtMNZpH5cJaXfQhYEvYDgrS2HGXgThG3uIjUP38mo+hTIkY5e2ZGJeckUN137QJSkjALNAhObfPMiV5IgrxVd/eVCgTZ3RqX78KvzklxnWWqw0tMspYua47wS2PIDnT3rOPOybZ5J9GcZ+0zoRwKdw1AVjBtYZ2CkVK1ulZF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id AAE1D4E6010;
	Wed, 11 Sep 2024 18:09:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
 by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
 with ESMTP id aoKD5nEAFJwI; Wed, 11 Sep 2024 18:08:59 +0200 (CEST)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id B61AD4E6004; Wed, 11 Sep 2024 18:08:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id B2618746F60;
	Wed, 11 Sep 2024 18:08:59 +0200 (CEST)
Date: Wed, 11 Sep 2024 18:08:59 +0200 (CEST)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
cc: qemu-devel@nongnu.org, Zhao Liu <zhao1.liu@intel.com>, 
    "Richard W.M. Jones" <rjones@redhat.com>, Joel Stanley <joel@jms.id.au>, 
    Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
    qemu-arm@nongnu.org, Corey Minyard <minyard@acm.org>, 
    Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, 
    Keith Busch <kbusch@kernel.org>, WANG Xuerui <git@xen0n.name>, 
    Hyman Huang <yong.huang@smartx.com>, 
    Stefan Berger <stefanb@linux.vnet.ibm.com>, 
    Michael Rolnik <mrolnik@gmail.com>, 
    Alistair Francis <alistair.francis@wdc.com>, 
    =?ISO-8859-15?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>, 
    Markus Armbruster <armbru@redhat.com>, 
    Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org, 
    Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, 
    Jesper Devantier <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>, 
    Peter Maydell <peter.maydell@linaro.org>, 
    Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org, 
    =?ISO-8859-15?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, 
    Richard Henderson <richard.henderson@linaro.org>, 
    Fam Zheng <fam@euphon.net>, qemu-s390x@nongnu.org, 
    Hanna Reitz <hreitz@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
    Eduardo Habkost <eduardo@habkost.net>, Laurent Vivier <lvivier@redhat.com>, 
    Rob Herring <robh@kernel.org>, 
    Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org, 
    "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org, 
    Daniel Henrique Barboza <danielhb413@gmail.com>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    Harsh Prateek Bora <harshpb@linux.ibm.com>, 
    =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, 
    Nina Schoetterl-Glausch <nsg@linux.ibm.com>, 
    "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>, 
    Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>, 
    Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
    Akihiko Odaki <akihiko.odaki@daynix.com>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    David Gibson <david@gibson.dropbear.id.au>, 
    Aurelien Jarno <aurelien@aurel32.net>, 
    Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
    Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>, 
    Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>, 
    Klaus Jensen <its@irrelevant.dk>, 
    Jean-Christophe Dubois <jcd@tribudubois.net>, 
    Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 20/39] hw/ppc: replace assert(false) with
 g_assert_not_reached()
In-Reply-To: <45c6a39b-9c16-4580-ad6b-99973b5e6b0f@linaro.org>
Message-ID: <cb4298a0-eb1f-be02-18d5-b9ce87a4c550@eik.bme.hu>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org> <20240910221606.1817478-21-pierrick.bouvier@linaro.org> <232858c7-6270-f763-adfc-b6c8259bf021@eik.bme.hu> <45c6a39b-9c16-4580-ad6b-99973b5e6b0f@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 11 Sep 2024, Pierrick Bouvier wrote:
> On 9/11/24 07:10, BALATON Zoltan wrote:
>> 
>> 
>> On Tue, 10 Sep 2024, Pierrick Bouvier wrote:
>> 
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>> hw/ppc/spapr_events.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>> 
>>> diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
>>> index cb0eeee5874..38ac1cb7866 100644
>>> --- a/hw/ppc/spapr_events.c
>>> +++ b/hw/ppc/spapr_events.c
>>> @@ -645,7 +645,7 @@ static void spapr_hotplug_req_event(uint8_t hp_id, 
>>> uint8_t hp_action,
>>>          /* we shouldn't be signaling hotplug events for resources
>>>           * that don't support them
>>>           */
>>> -        g_assert(false);
>>> +        g_assert_not_reached();
>>>          return;
>>>      }
>> 
>> If break does not make sense after g_assert_not_reached() and removed then
>> return is the same here.
>> 
>> It may make the series shorter and easier to check that none of these are
>> missed if this is done in the same patch where the assert is changed
>> instead of separate patches. It's unlikely that the assert change and
>> removal of the following break or return would need to be reverted
>> separately so it's a simple enough change to put in one patch in my
>> opinion but I don't mink if it's kept separate either.
>> 
>> Regards,
>> BALATON Zoltan
>
> Mostly done this way because it's easy for creating many commits.

As I said I don't mind either way. Now that part of this series is queued 
it's easier to add another patch to remove the return.

Regards,
BALATON Zoltan

