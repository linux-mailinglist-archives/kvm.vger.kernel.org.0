Return-Path: <kvm+bounces-23685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6170C94CCDF
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 11:04:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F11CBB20F6E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 09:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBB218FDC9;
	Fri,  9 Aug 2024 09:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DdND/p2k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC87BA41
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 09:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723194249; cv=none; b=AgxNYPt0T7QKNc8OjR9NLmYTZBtVysfhdR9TWr9AKqdZGhH5TTnp9IiFqe3xp/MHzoi/UWWxquPBKNfttwf4/2hcyBuIGANMzhM/o6Wn4GV+DZDeI+0lnggL0y3gJxh2F1L+zzFbKWQRY2MLkVuSsvEC6dbcqX2LJIustWvm9YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723194249; c=relaxed/simple;
	bh=1lYBxYmj0yP3L5nl4vsLslkpwynKSXWgXkQxvcQasvg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=d+HxLeSgGuPw1GtwWc3gKWfDR5XqKHeJM28H9eib5Lox52VVEUxoOueNeus9c0sKtywn7wiNX+84UW6xys5v/lvOwrVo2vKlex4qLFiHI2yZYg1SyykzKNclFm61h1RIDOUv0zaIDLM96ALSU/MAQnlSeIl4MUp6n1Q+y0v1h+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DdND/p2k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723194246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XET1oSFvQl4264GUGqTzYsP7+4ofJLFq0ARdUYsJBcI=;
	b=DdND/p2khwVJ+jHP4mTphFpBNzhnzaqsFSil98yb79y8lYaYc3ZXEPpGNaM3lmFNo6f+Td
	6OstYnAzOYuyDhYlWGYYckIostJE3awUUKzYxiLcUHTl4zPEQEEuyw3F1gq21qouhaBu6K
	/g0cSiGwDOyXrJelO8oRVaQALEttCKc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-266-kkpEvW6XP1K4uU7bnbTbkg-1; Fri,
 09 Aug 2024 05:04:04 -0400
X-MC-Unique: kkpEvW6XP1K4uU7bnbTbkg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 842DF19772EE;
	Fri,  9 Aug 2024 09:03:56 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.245])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 21FCD300019F;
	Fri,  9 Aug 2024 09:03:47 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id D3A9F21E668B; Fri,  9 Aug 2024 11:03:44 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Kevin Wolf <kwolf@redhat.com>
Cc: qemu-devel@nongnu.org,  alex.williamson@redhat.com,
  andrew@codeconstruct.com.au,  andrew@daynix.com,
  arei.gonglei@huawei.com,  berrange@redhat.com,  berto@igalia.com,
  borntraeger@linux.ibm.com,  clg@kaod.org,  david@redhat.com,
  den@openvz.org,  eblake@redhat.com,  eduardo@habkost.net,
  farman@linux.ibm.com,  farosas@suse.de,  hreitz@redhat.com,
  idryomov@gmail.com,  iii@linux.ibm.com,  jamin_lin@aspeedtech.com,
  jasowang@redhat.com,  joel@jms.id.au,  jsnow@redhat.com,
  leetroy@gmail.com,  marcandre.lureau@redhat.com,
  marcel.apfelbaum@gmail.com,  michael.roth@amd.com,  mst@redhat.com,
  mtosatti@redhat.com,  nsg@linux.ibm.com,  pasic@linux.ibm.com,
  pbonzini@redhat.com,  peter.maydell@linaro.org,  peterx@redhat.com,
  philmd@linaro.org,  pizhenwei@bytedance.com,  pl@dlhnet.de,
  richard.henderson@linaro.org,  stefanha@redhat.com,
  steven_lee@aspeedtech.com,  thuth@redhat.com,  vsementsov@yandex-team.ru,
  wangyanan55@huawei.com,  yuri.benditovich@daynix.com,
  zhao1.liu@intel.com,  qemu-block@nongnu.org,  qemu-arm@nongnu.org,
  qemu-s390x@nongnu.org,  kvm@vger.kernel.org
Subject: Re: [PATCH 01/18] qapi: Smarter camel_to_upper() to reduce need for
 'prefix'
In-Reply-To: <ZqoHWPOeqF7uGncx@redhat.com> (Kevin Wolf's message of "Wed, 31
	Jul 2024 11:43:52 +0200")
References: <20240730081032.1246748-1-armbru@redhat.com>
	<20240730081032.1246748-2-armbru@redhat.com>
	<ZqoHWPOeqF7uGncx@redhat.com>
Date: Fri, 09 Aug 2024 11:03:44 +0200
Message-ID: <87y156kqz3.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Kevin Wolf <kwolf@redhat.com> writes:

> Am 30.07.2024 um 10:10 hat Markus Armbruster geschrieben:
>> camel_to_upper() converts its argument from camel case to upper case
>> with '_' between words.  Used for generated enumeration constant
>> prefixes.
>> 
>> When some of the words are spelled all caps, where exactly to insert
>> '_' is guesswork.  camel_to_upper()'s guesses are bad enough in places
>> to make people override them with a 'prefix' in the schema.
>> 
>> Rewrite it to guess better:
>> 
>> 1. Insert '_' after a non-upper case character followed by an upper
>>    case character:
>> 
>>        OneTwo -> ONE_TWO
>>        One2Three -> ONE2_THREE
>> 
>> 2. Insert '_' before the last upper case character followed by a
>>    non-upper case character:
>> 
>>        ACRONYMWord -> ACRONYM_Word
>> 
>>    Except at the beginning (as in OneTwo above), or when there is
>>    already one:
>> 
>>        AbCd -> AB_CD
>
> Maybe it's just me, but the exception "at the beginning" (in the sense
> of "after the first character") seems to be exactly where I thought
> "that looks strange" while going through your list below.

By "except at the beginning", I mean don't map "One" to "_ONE".

>                                                           In particular,
> I'd expect X_DBG_* instead of XDBG_*.

What's the intent of the X in the XDbgFOO types?  Signify unstable?

If yes: we don't do that elsewhere.  Type names are not part of the
external interface.  We never used an X prefix for names of unstable
types.  We use an x- prefix for names of unstable commands, arguments
and members, but even that is optional today.  Feature flag @unstable is
the source of truth.

The XDbgFOO appear to be used just by x-debug-query-block-graph, which
has feature @unstable.

If the XDBG name bothers you, we can strip the X prefix from the type
names.  Happy to do that in this series.

>                                       I also thought that the Q_*
> spelling made more sense, though this might be less clear.

The crypto subsystem spells its prefix qcrypto_, QCRYPTO_, and QCrypto.
Before this series, it forces QAPI to generate QCRYPTO_ with 'prefix'
with two exceptions, probably oversights.

>                                                            But in case
> of doubt, less exceptions seems like a good choice.

Agree.  I want to be able to predict generated names :)

>> +    # Copy remainder of ``value`` to ``ret`` with '_' inserted
>> +    for ch in value[1:]:
>> +        if ch.isupper() == upc:
>> +            pass
>> +        elif upc:
>> +            # ``ret`` ends in upper case, next char isn't: insert '_'
>> +            # before the last upper case char unless there is one
>> +            # already, or it's at the beginning
>> +            if len(ret) > 2 and ret[-2] != '_':
>> +                ret = ret[:-1] + '_' + ret[-1]
>
> I think in the code this means I would have expected len(ret) >= 2.

I'm not sure I understand what you mean.

With len(ret) > 2, we map "QType" to "QTYPE".

With len(ret) >= 2, we'd map it to "Q_TYPE".


