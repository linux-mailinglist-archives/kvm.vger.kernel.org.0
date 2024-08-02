Return-Path: <kvm+bounces-23004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDC97945820
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 08:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18B1CB22A56
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 06:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6655A482FF;
	Fri,  2 Aug 2024 06:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="N41pX7jv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8562C9D
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 06:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722581060; cv=none; b=G8giZUHMAhjseQY764GAafRIcoPe+06TGY/rXOLLBblvHd7ri3Xj4BhUETmX2T7zkdZZA/KbilDXBgX3ggAApVaGXlNVHUTIRTgCR8g2Jcc99AY7fB/NYdYCK1NRLW7AO7TG3gpbTxhvSoFi6t0ZCwCiZBhSAclCcZDOPT1iSs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722581060; c=relaxed/simple;
	bh=4WY00xaiw7PFn9KkVFhhqeJI5wdI3d0bSi0sCx4VnQo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s9/bVU6KFoaMahYoG8LQuepECLOJV+UF4ai7OymlzCIHubCX+5pPBY8Z1DN0br0Jxv23lVUDn/3vpywnvLF14Z+TQKwhsueEg1MsZYVrO+uhtTT5CEu9AvZ5SxiShMHxO8ncsv52MbvPuO2ki4Bv1XQzPByqGhSkoBfbC9hkUEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=N41pX7jv; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-75a6c290528so5384709a12.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 23:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1722581058; x=1723185858; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fMukaNkBN1v8nOhOBQhHq9LJXtSLU4mnt5ced46M+4o=;
        b=N41pX7jvT5iImhSAI5I6ltira/a9TzgyXaxi/AYsHowMs4UyhEyell5pLbNRoDMjET
         Fhaj9pRPCvdbHY4Gp40xU/CHyXzJWIjBs0XEeVG6/mErqmEEtWW4OSn2F9RE9mNkTadY
         78TOZ1DAOGnwYsID0vpqHGsa3cb+PTQW1FwAEEvwkpbmkV56v+AJWOa/ZBeXuHL7VfKp
         CW+J7QDao00euawZ4ft2fuVcaj8dZY87YBQ8kq/OuN0vtWXi5KHXmsLNdBE2L4+WFONl
         zCRF24LhWEwsQ0zR4V/Y/dcUuvBp+tkmFZyoPThZET8XOCjy+5FI1IVSAMPUFmoiUly3
         ntgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722581058; x=1723185858;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fMukaNkBN1v8nOhOBQhHq9LJXtSLU4mnt5ced46M+4o=;
        b=qAMMRaD5D28pqEW5EKKVzZ9TAnlQLjaA2rkwj3nnvSQFJJOwNX4HPc4npK39N0eA0y
         ipmfUiNbQbmPKbDsWjrIXu/B2ODQWXfGgN/ObP2vlXFr59mb3Krl6Z+SQto20jvT0ozD
         3PALBVuYEXxrh7txBh5PJX3BOkPybjGjxHBNO9yE6XSrCX0KFP8o6rZ9WpDC3wgfoPtn
         JZJ4tBbmcL4qYa7kAoBppV2/aEUfsm9fT2zk0ad3/A2aDICpjotRQVVXlbUUxTLwdO97
         6o5+H9PJA3KETmkJv9iMH/esno7jq+x6efWV77phRsyAyYKiSvfcpiWOWWtXEHPxIG2K
         KL4g==
X-Forwarded-Encrypted: i=1; AJvYcCWql2xpFDAr/1EliocXU6d6kw12+iN27/DmXvQUuiVWkaKBiRv4FzztbUQYCUrWu9hE9TbPkRZXOFVVPUuoZ5HaLEMg
X-Gm-Message-State: AOJu0YxWydnDAIBryN2FCYMaX3FKFtdOe7ElH9JCbRp8KoAtrXHPKzDR
	auK/DMP6GnbxXbwJZpPgCiW8WYhG3Wn9T48ajx9MW5922+tv5kvY0DdKSIz95kE=
X-Google-Smtp-Source: AGHT+IGLvb4WFCo2jk3N7o0FYUK66tKq318mzzsGZ0AfW234azPne231OCHg3yxPUpgvjmlieEI62g==
X-Received: by 2002:a17:902:c40e:b0:1fd:8c42:61ca with SMTP id d9443c01a7336-1ff572d9c5fmr31221775ad.25.1722581058280;
        Thu, 01 Aug 2024 23:44:18 -0700 (PDT)
Received: from [157.82.201.15] ([157.82.201.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff592afe6fsm9552095ad.296.2024.08.01.23.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Aug 2024 23:44:17 -0700 (PDT)
Message-ID: <1c98fcd4-0474-4c5f-8f83-ec6b2b6e6c8b@daynix.com>
Date: Fri, 2 Aug 2024 15:44:14 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] hvf: arm: Do not advance PC when raising an
 exception
To: Michael Tokarev <mjt@tls.msk.ru>, Peter Maydell
 <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
 <20240720-pmu-v4-6-2a2b28f6b08f@daynix.com>
 <7bf379b7-eb51-4fe3-a93b-88849a8d1292@tls.msk.ru>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <7bf379b7-eb51-4fe3-a93b-88849a8d1292@tls.msk.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/08/02 15:41, Michael Tokarev wrote:
> 20.07.2024 12:30, Akihiko Odaki wrote:
>> This is identical with commit 30a1690f2402 ("hvf: arm: Do not advance
>> PC when raising an exception") but for writes instead of reads.
>>
>> Fixes: a2260983c655 ("hvf: arm: Add support for GICv3")
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> 
> Is it -stable material (together with 30a1690f2402) ?

The fixed bugs are trivial, and probably nobody is actually impacted by 
them.

Regards,
Akihiko Odaki

