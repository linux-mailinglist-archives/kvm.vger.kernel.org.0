Return-Path: <kvm+bounces-22744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF42942B10
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 11:45:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F224D1C2477E
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23CF31AC42D;
	Wed, 31 Jul 2024 09:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OdEgWGtW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467781AC42A
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 09:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722419069; cv=none; b=sjzxi/hAb3ct1RxwlN2muKk7AznTgqNrQG18GDA2hIIzO31HJIuctJ0shTJR+B7oKAC3IlAtRSWZap4Cu0vOLx13LLLsjKY9x+RAJ95gVvjVRJJDYqg4jsHvILx/hIWT5I6SuvCN+1L4qeX4bkZJKIg6W8cN5JNzXBm3YBjoImU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722419069; c=relaxed/simple;
	bh=Ln0JdJINoWOICfhnOxZ2+dUVWTVNhUAGwfyLKIbUqEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mietdiz2Uypq7CSQCOT/QVVP7HfnBCeOrqkz4+m/tTTEricCb/tXO12xLr8poCiseoFL5Jue1T8pAnaZEVb8q3GyVigGLTgJ89ANBtkWBNq6jKOC/IhSbZ7aYShWpDhMJ7NElijpsiLyKvF2F1AqZh1oXZunueTqVd0uHA4GU6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OdEgWGtW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722419066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NlUG8qVe5wIiIf508RxBtgklVOghS84a6q0P9i32l4w=;
	b=OdEgWGtW6QzLMSj5vCPdn/V+FB6FDNKA34bZxNGzdPWHT+YFRooybDonbBhrNQDa8wxKh0
	k4dm3a/OsLJftLweZK4WiUZ5zJCt6jt3ec38k8ZWNKpawWGwtVZx5Czke2ElueDPeVYbuU
	qNbDy+qSjpHnOhiI+bTEwnOn397CAco=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-r8nXOTFzNsKJlug9DOsdQw-1; Wed,
 31 Jul 2024 05:44:22 -0400
X-MC-Unique: r8nXOTFzNsKJlug9DOsdQw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C65B1955F3B;
	Wed, 31 Jul 2024 09:44:14 +0000 (UTC)
Received: from redhat.com (unknown [10.39.194.1])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8F1519560AA;
	Wed, 31 Jul 2024 09:43:54 +0000 (UTC)
Date: Wed, 31 Jul 2024 11:43:52 +0200
From: Kevin Wolf <kwolf@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, alex.williamson@redhat.com,
	andrew@codeconstruct.com.au, andrew@daynix.com,
	arei.gonglei@huawei.com, berrange@redhat.com, berto@igalia.com,
	borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
	den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
	farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
	idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
	jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com,
	leetroy@gmail.com, marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com, michael.roth@amd.com, mst@redhat.com,
	mtosatti@redhat.com, nsg@linux.ibm.com, pasic@linux.ibm.com,
	pbonzini@redhat.com, peter.maydell@linaro.org, peterx@redhat.com,
	philmd@linaro.org, pizhenwei@bytedance.com, pl@dlhnet.de,
	richard.henderson@linaro.org, stefanha@redhat.com,
	steven_lee@aspeedtech.com, thuth@redhat.com,
	vsementsov@yandex-team.ru, wangyanan55@huawei.com,
	yuri.benditovich@daynix.com, zhao1.liu@intel.com,
	qemu-block@nongnu.org, qemu-arm@nongnu.org, qemu-s390x@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 01/18] qapi: Smarter camel_to_upper() to reduce need for
 'prefix'
Message-ID: <ZqoHWPOeqF7uGncx@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-2-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730081032.1246748-2-armbru@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Am 30.07.2024 um 10:10 hat Markus Armbruster geschrieben:
> camel_to_upper() converts its argument from camel case to upper case
> with '_' between words.  Used for generated enumeration constant
> prefixes.
> 
> When some of the words are spelled all caps, where exactly to insert
> '_' is guesswork.  camel_to_upper()'s guesses are bad enough in places
> to make people override them with a 'prefix' in the schema.
> 
> Rewrite it to guess better:
> 
> 1. Insert '_' after a non-upper case character followed by an upper
>    case character:
> 
>        OneTwo -> ONE_TWO
>        One2Three -> ONE2_THREE
> 
> 2. Insert '_' before the last upper case character followed by a
>    non-upper case character:
> 
>        ACRONYMWord -> ACRONYM_Word
> 
>    Except at the beginning (as in OneTwo above), or when there is
>    already one:
> 
>        AbCd -> AB_CD

Maybe it's just me, but the exception "at the beginning" (in the sense
of "after the first character") seems to be exactly where I thought
"that looks strange" while going through your list below. In particular,
I'd expect X_DBG_* instead of XDBG_*. I also thought that the Q_*
spelling made more sense, though this might be less clear. But in case
of doubt, less exceptions seems like a good choice.

> +    # Copy remainder of ``value`` to ``ret`` with '_' inserted
> +    for ch in value[1:]:
> +        if ch.isupper() == upc:
> +            pass
> +        elif upc:
> +            # ``ret`` ends in upper case, next char isn't: insert '_'
> +            # before the last upper case char unless there is one
> +            # already, or it's at the beginning
> +            if len(ret) > 2 and ret[-2] != '_':
> +                ret = ret[:-1] + '_' + ret[-1]

I think in the code this means I would have expected len(ret) >= 2.

Kevin


