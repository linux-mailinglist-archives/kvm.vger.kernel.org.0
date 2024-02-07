Return-Path: <kvm+bounces-8243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F24D984CE4F
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 16:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D4DFB27818
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D2680051;
	Wed,  7 Feb 2024 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Op00i3nj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18E280027
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 15:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707320633; cv=none; b=OX/pgqUnHUP9aFyMxeUvDZzmKTGkyJpqAAX6IGfCulx4E0PDnTu482sKgMCyvPaeh+Jghxa52qB5evchJH9Pkk4N2qPOFz/ZoMEn9V0ymDxGel08wegEL7kN/7a0Qfk0smcGGtcFiaZeJCRlD2RT/mt76qI9zS6/lcGAHD+LZuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707320633; c=relaxed/simple;
	bh=oMhnQDhbzTftoXe32RQIwWtdO96us4xrhjolZAiZHHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kFcTU8Br5vIvH9EgwXG1Y0rkWmoEu4z9pB7oT+h5hossvEnZmGLITjXml9eL3d8vkYwiDZXOMJlN0jqJfeT/D6OUs0qjOLhRYPONK23NSJuRvOmQtKlM0LKOGJkMyAPDvAgRz/g4LlknnnZO1T8/CaQdVsMGm0tNmHK8RqFc998=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Op00i3nj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707320630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=29GmU0WJVI81RRCnUaroCVhXsQRA2hKi8oNlrxbN5n0=;
	b=Op00i3njd/isuJufBgGDsHUtYOZtR9sCNmFQbb1B8JUzYQe72KCPI/6Ds+V900wf/dMAxo
	M1cITTh9Y0z/4zl8eC7WgDJNGB+fO28OgMDD6WJmQMuISAWU1y7vJgnlWET44e4Y+sNt3o
	pZohn9MYW0i0MpE+jKv8iXZRT4KJY7s=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-bojjcFqYMTCs760OJ2-W9w-1; Wed, 07 Feb 2024 10:43:47 -0500
X-MC-Unique: bojjcFqYMTCs760OJ2-W9w-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7816e45f957so90765985a.1
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 07:43:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707320626; x=1707925426;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=29GmU0WJVI81RRCnUaroCVhXsQRA2hKi8oNlrxbN5n0=;
        b=Sg3uzGTazzi4daabwpl7CMkNxag/LIqadtTRpRdKHKKCi7U3vE8YxnYpoU5X0rSkRg
         MnMiEmixKXkyoXKkYz+aVHdLYb0ROZensM2cmUC4NqEVigb15v3n4OP9VL6iKfJzVnrI
         sHQIQPKap1ZkJa+bQ8KP9Wp39/lWkX41sIMWLVOFcyN06F60Hr1ADWFTPh0JuD9MUVPE
         Qmea2VF7ife5ujr3hufktIxX0WgoWWoUcApF2v2VF5jQV9zcH9nLOTGedbJODeTzsJEV
         0dRmF4r7B5eNb3Gv9bWl0nWyAlCf9z/HlyieTKj7pCaEysutZz02pSBU/XinVB4ytF59
         G/FQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVSF+CQ8dlQ2prPefBCv8gXAv5HIPXwa5/QuvlrC6hZIfyVoVYjD6uOyhkefSLOxnqmKWRGY2LZKTFdsh6m1rqmeBk
X-Gm-Message-State: AOJu0YzzY/NMurXh/Jx9F9ovZ+G/PBzd8+hqGIZ718IEurLLgzG0GxjM
	9q9OAzvHEKuIDHh3m/mCNT9dA5qRAaBer+HIAg4BYSse8cwabJdTUXO09mcLAHnyY40wYx9f9Pr
	MDTWZOH76q1uv6GVFR2E7eNXoJzZ0z8sG/1iyqaAkKefFiL4jig==
X-Received: by 2002:a05:620a:612a:b0:785:5a45:c051 with SMTP id oq42-20020a05620a612a00b007855a45c051mr6515422qkn.10.1707320626038;
        Wed, 07 Feb 2024 07:43:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzonaLyrIAVvkXXGpzqr7TSJxC/KB7KAItXbWifbvzd/5hFgwnWuI+eWmu0G+TxPkW33FFBw==
X-Received: by 2002:a05:620a:612a:b0:785:5a45:c051 with SMTP id oq42-20020a05620a612a00b007855a45c051mr6515406qkn.10.1707320625752;
        Wed, 07 Feb 2024 07:43:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVgFggNyOqEwxOXsDjt+zIkkPwv8yHX3cH+PDA0TmIe69kGLkevANZZURzsWtBSkRjifEbwcO45Bik2TVz2YxAnGDWnwEQaoZsKO+hNcSocl2F0yGwet8AwPH/pjLOpqws9Eh5ra/ikZE5Qmtb7WRLGMg9SjHxw
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d15-20020a05620a158f00b007859d590478sm602828qkk.64.2024.02.07.07.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Feb 2024 07:43:44 -0800 (PST)
Message-ID: <86c33c28-77a8-46ed-9c5c-2ae0acbf5b3b@redhat.com>
Date: Wed, 7 Feb 2024 16:43:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Fix a semaphore imbalance in the dirty
 ring logging test
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>
References: <20240202231831.354848-1-seanjc@google.com>
 <170724566758.385340.17150738546447592707.b4-ty@google.com>
 <6fdbeed0-980e-4371-a448-0c215c4bc48e@redhat.com>
 <ZcOXSZ2OPL5WCcRM@google.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <ZcOXSZ2OPL5WCcRM@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/7/24 15:44, Sean Christopherson wrote:
> On Wed, Feb 07, 2024, Eric Auger wrote:
>> Hi Sean,
>>
>> On 2/6/24 22:36, Sean Christopherson wrote:
>>> On Fri, 02 Feb 2024 15:18:31 -0800, Sean Christopherson wrote:
>>>> When finishing the final iteration of dirty_log_test testcase, set
>>>> host_quit _before_ the final "continue" so that the vCPU worker doesn't
>>>> run an extra iteration, and delete the hack-a-fix of an extra "continue"
>>>> from the dirty ring testcase.  This fixes a bug where the extra post to
>>>> sem_vcpu_cont may not be consumed, which results in failures in subsequent
>>>> runs of the testcases.  The bug likely was missed during development as
>>>> x86 supports only a single "guest mode", i.e. there aren't any subsequent
>>>> testcases after the dirty ring test, because for_each_guest_mode() only
>>>> runs a single iteration.
>>>>
>>>> [...]
>>>
>>> Applied to kvm-x86 selftests, thanks!
>> Do you plan to send this branch to Paolo for v6.8?
> 
> That wasn't my initial plan, but looking at what's in there, the only thing that
> isn't a fix is Andrew's series to remove redundant newlines.  So yeah, I'll send
> this along for 6.8.
> 

OK. Many thanks!

Eric


