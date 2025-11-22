Return-Path: <kvm+bounces-64283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A79C7CF45
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 13:02:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D6CE3A9DEC
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 12:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B9F2FF15F;
	Sat, 22 Nov 2025 12:02:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D462F533E
	for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 12:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763812950; cv=none; b=SZW5zAT2LPwmlWwavBKPJgNKNaXiLLBJuCMZ6kotM+HoZGaVyhnKK3PwPl8hWc6f8yeiAOg5i1IcJgo8pZ/mBR4KG4zPJgu4/Nw2b70HXykkIi5wbk6lZChqkAhNj101NbP5BTaXyMn/9ha0susTxRxyPkzekNAaYmD57KgXRAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763812950; c=relaxed/simple;
	bh=6GDdy7hB6Op6wnJNpZMtpOONAI41GETtPiqyt2aGTpg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Tl5gGt6q+0kdjQ72CCH/CRoyNmVdPyjUgUqtnHhXLZ6HTToAV0n3haexCg6eemOslDxNWLyNGrOnXBXc2M4KyhRNoP+EPztr6XFFQDoU3nG0WuTItXKDaQt4DrGBUFnzyc13J6tN20SkfFwsueWOp7q5QiVjimY/VZoZCK4pYRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 911CE5969FB;
	Sat, 22 Nov 2025 12:53:39 +0100 (CET)
X-Virus-Scanned: amavis at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
 by localhost (zero.eik.bme.hu [127.0.0.1]) (amavis, port 10028) with ESMTP
 id zyO5GX3vEdkz; Sat, 22 Nov 2025 12:53:37 +0100 (CET)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id 74C9B5969FA; Sat, 22 Nov 2025 12:53:37 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 70C3A5969F7;
	Sat, 22 Nov 2025 12:53:37 +0100 (CET)
Date: Sat, 22 Nov 2025 12:53:37 +0100 (CET)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: Markus Armbruster <armbru@redhat.com>
cc: "Dr. David Alan Gilbert" <dave@treblig.org>, qemu-devel@nongnu.org, 
    arei.gonglei@huawei.com, pizhenwei@bytedance.com, alistair.francis@wdc.com, 
    stefanb@linux.vnet.ibm.com, kwolf@redhat.com, hreitz@redhat.com, 
    sw@weilnetz.de, qemu_oss@crudebyte.com, groug@kaod.org, mst@redhat.com, 
    imammedo@redhat.com, anisinha@redhat.com, kraxel@redhat.com, 
    shentey@gmail.com, npiggin@gmail.com, harshpb@linux.ibm.com, 
    sstabellini@kernel.org, anthony@xenproject.org, paul@xen.org, 
    edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com, jag.raman@oracle.com, 
    sgarzare@redhat.com, pbonzini@redhat.com, fam@euphon.net, 
    philmd@linaro.org, alex@shazbot.org, clg@redhat.com, peterx@redhat.com, 
    farosas@suse.de, lizhijian@fujitsu.com, jasowang@redhat.com, 
    samuel.thibault@ens-lyon.org, michael.roth@amd.com, kkostiuk@redhat.com, 
    zhao1.liu@intel.com, mtosatti@redhat.com, rathc@linux.ibm.com, 
    palmer@dabbelt.com, liwei1518@gmail.com, dbarboza@ventanamicro.com, 
    zhiwei_liu@linux.alibaba.com, marcandre.lureau@redhat.com, 
    qemu-block@nongnu.org, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org, 
    kvm@vger.kernel.org, qemu-riscv@nongnu.org
Subject: Re: [PATCH 09/14] error: Use error_setg_file_open() for simplicity
 and consistency
In-Reply-To: <87ecpqtt6f.fsf@pond.sub.org>
Message-ID: <05ef43e5-cc42-8e1c-2619-eb1dea12b02b@eik.bme.hu>
References: <20251120191339.756429-1-armbru@redhat.com> <20251120191339.756429-10-armbru@redhat.com> <aR-q2YeegIEPmk2R@gallifrey> <87see8q6qm.fsf@pond.sub.org> <aSClUIvI2W-PVv6B@gallifrey> <87ecpqtt6f.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Sat, 22 Nov 2025, Markus Armbruster wrote:
> "Dr. David Alan Gilbert" <dave@treblig.org> writes:
>
>> * Markus Armbruster (armbru@redhat.com) wrote:
>>> "Dr. David Alan Gilbert" <dave@treblig.org> writes:
>>>
>>>> * Markus Armbruster (armbru@redhat.com) wrote:
>>>>> Replace
>>>>>
>>>>>     error_setg_errno(errp, errno, MSG, FNAME);
>>>>>
>>>>> by
>>>>>
>>>>>     error_setg_file_open(errp, errno, FNAME);
>>>>>
>>>>> where MSG is "Could not open '%s'" or similar.
>>>>>
>>>>> Also replace equivalent uses of error_setg().
>>>>>
>>>>> A few messages lose prefixes ("net dump: ", "SEV: ", __func__ ": ").
>>>>> We could put them back with error_prepend().  Not worth the bother.
>>>>
>>>> Yeh, I guess you could just do it with another macro using
>>>> the same internal function just with string concatenation.
>>>
>>> I'm no fan of such prefixes.  A sign of developers not caring enough to
>>> craft a good error message for *users*.  *Especially* in the case of
>>> __func__.
>>>
>>> The error messages changes in question are:
>>>
>>>     net dump: can't open DUMP-FILE: REASON
>>>     Could not open 'DUMP-FILE': REASON
>>>
>>>     SEV: Failed to open SEV-DEVICE: REASON
>>>     Could not open 'SEV-DEVICE': REASON
>>>
>>>     sev_common_kvm_init: Failed to open SEV_DEVICE 'REASON'
>>>     Could not open 'SEV-DEVICE': REASON
>>>
>>> I think these are all improvements, and the loss of the prefix is fine.
>>
>> Yeh, although I find the error messages aren't just for users;
>> they're often for the first dev to see it to guess which other
>> dev to pass the problem to, so a hint about where it's coming
>> from can be useful.
>
> I agree!  But I think an error message must be make sense to users
> *first* and help developers second, and once they make sense to users,
> they're often good enough for developers.
>
> The common failures I see happen when developers remain caught in the
> developer's perspective, and write something that makes sense to *them*.
> Strawman form:
>
>    prefix: failed op[: reason]
>
> where "prefix" is a subsystem tag, or even __func__, and "reason" is
> strerror() or similar.
>
> To users, this tends to read as
>
>    gobbledygook: techbabble[: reason]
>
> When we care to replace "failed op" (developer's perspective) by
> something that actually makes sense to users, "prefix" often becomes
> redundant.
>
> The error messages shown above aren't bad to begin with.  "failed to
> open FILE", where FILE is something the user specified, should make
> sense to the user.  It should also be good enough for developers even
> without a prefix: connecting trouble with the DUMP-FILE to dump /
> trouble with the SEV-DEVICE to SEV should be straightforward.
>
> [...]

I think that

net dump: can't open random-filename: because of some error

shows better where to look for the problem than just

Could not open 'random-filename': because of some error

as the latter does not tell where the file name comes from or what is it. 
It could be added by a management application or added by the users 
randomly without really knowing what they are doing so repeating the 
option or part in the message that the error comes from can help to find 
out where to correct it. Otherwise it might be difficult to guess what 
random-filename is related to if it's not named something you'd expect.

Regards,
BALATON Zoltan

