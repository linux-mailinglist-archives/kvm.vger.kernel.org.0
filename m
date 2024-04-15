Return-Path: <kvm+bounces-14661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6311E8A5212
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:45:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 199D628438A
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F7071B45;
	Mon, 15 Apr 2024 13:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AEmL+NRy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197C25A108
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 13:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713188682; cv=none; b=lTgCuiUT4YescUDnPifPk3oXLzWorlOISlVjyfU1+oPYovNtzf412l9L3s80V8BjBtjEupHgKYcItxRByIttDF25DMQd+poantTXKz/ohu5VnPjYLSpC1HfX7yTen/xLh+BxLwHep+rsqNqC0DnIEjDHwe0dY04Y+lMwpBcH2mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713188682; c=relaxed/simple;
	bh=W6XBYyBUrKFFa6NiRNU6Y8Ha5SDWXcBV9latNIYLvig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UJgGnGpOTkIi8/lXHJWB6Wah35YAeCHf+gYnIlaQ9FjMM605d5aNp4t9Hh1LIdqU7dbX6DtjgwXlptv+FyYvwCXPpcm/ThpQY5ABindk0iVsL+XnM6aodK0cOyT9jO6SfOkW+3nF8Awhvh1nPMt3gGYxPR4eMRIW/aww8Jteugs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AEmL+NRy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713188679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xOqza9Oa++0cIkrLsvcehiPDyb6oXbxz4r3dYceTOfA=;
	b=AEmL+NRyA5tCmVkcf7vbhbCxdFwhD0Txope8OOLGSLha67JtjiXR8K97o6loY43HXrjtu6
	vJbi4wsZDAGmZazHBi3dE9GKtqRlx75M9YrbXgJMGRm9oSmzLgvt3r/Vqyndf7JM2qgO4s
	4INF56w8wH1NQ/mS3dFo2yBLuINRJ3E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-DHwOKcdeOGu4GSKca45deA-1; Mon, 15 Apr 2024 09:44:38 -0400
X-MC-Unique: DHwOKcdeOGu4GSKca45deA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-417df7b0265so12252825e9.3
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713188677; x=1713793477;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xOqza9Oa++0cIkrLsvcehiPDyb6oXbxz4r3dYceTOfA=;
        b=J4/O3FHuQov9CcynlFt97kAa51fW80QDN0rXhAZNdNPzDHyHKxobedPpWfwezoPCCi
         mJkSuwSSl3GWLS+oCqcW/fOezXUV5YVQqrEWlvtXX59jq9AbJzR1j9puyX64DBNkLocU
         9iP0AFjhoEiW4PvwxD2Ms/cEtY6ySuOdEzRqz6ZJdrnuMMM+W6UhQSbIS7x6FD3O/snX
         1YfjnmWPC+QueFtJ9xOFVdVnpyj7yI/bu9mYaEqVKBNJ4BEuJnxEvM8oLTEhWyK46KN0
         SvwgnEk0zcGyTp3De2ZNh/V+dXGz+9aGy0MW29iaG/C66U38TBx9AEzhbK368lDzH+gj
         /o1w==
X-Gm-Message-State: AOJu0YwSx72MNZ7HYVxLiQR9rJpCuUcD8CG8/Vt4jwQe+jFABmAnfNSe
	ZHsz+dTwGIjk3V34MxLDMeNMoeeQYJSS7FWncab3+GZpKiIqBI8hxvvLNElOTKRHFHaFRj1Lpqs
	xmPvbLaTFGmidfaRY3LhMmSQbuC9mePihSfKDuWX5FtEjMyQDMw==
X-Received: by 2002:a05:600c:154e:b0:418:32f7:e87 with SMTP id f14-20020a05600c154e00b0041832f70e87mr3269579wmg.32.1713188677423;
        Mon, 15 Apr 2024 06:44:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHiRwU+/8YylRVVVdwJv5JoSH1o5G+L6ZC2TECa4CMY7dMB0ZAGAj0MKET6gwdYO/nLJbNwng==
X-Received: by 2002:a05:600c:154e:b0:418:32f7:e87 with SMTP id f14-20020a05600c154e00b0041832f70e87mr3269569wmg.32.1713188677002;
        Mon, 15 Apr 2024 06:44:37 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-142.web.vodafone.de. [109.43.179.142])
        by smtp.gmail.com with ESMTPSA id t10-20020a05600c198a00b004186c58a9b5sm2772329wmq.44.2024.04.15.06.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 06:44:36 -0700 (PDT)
Message-ID: <8be4ce83-ce76-4306-b454-93896d68a868@redhat.com>
Date: Mon, 15 Apr 2024 15:44:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci: Fix the cirrus pipelines
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20240415130321.149890-1-thuth@redhat.com>
 <Zh0qAfYWGpORIGTl@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <Zh0qAfYWGpORIGTl@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/04/2024 15.22, Daniel P. Berrangé wrote:
> On Mon, Apr 15, 2024 at 03:03:21PM +0200, Thomas Huth wrote:
>> Pulling the "master" libvirt-ci containers does not work anymore,
>> so we have to switch to the "latest" instead. See also:
> 
> We explicitly changed to publish under the 'latest' tag.
> 
>> https://gitlab.com/libvirt/libvirt/-/commit/5d591421220c850aa64a640
> 
> This commit is the root cause:
> 
>    https://gitlab.com/libvirt/libvirt-ci/-/commit/6e3c5ccac77714be70c0dc52c5210c7cda8fe40f
> 
> The effects were dormant for a year as I didn't delete the old
> ':master' tags until two weeks ago.

Thanks! I added that information to the commit message and pushed the patch 
to the repository.

  Thomas



