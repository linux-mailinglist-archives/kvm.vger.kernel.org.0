Return-Path: <kvm+bounces-17129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C46B38C1406
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 19:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ABB22815ED
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 17:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB801401E;
	Thu,  9 May 2024 17:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Es+ZAppU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DF310A36
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715275582; cv=none; b=BQPjIkOoXL/I8OVf+3DQfZ+qWFnJ+RJh1S6VtiS/M2VQC/sm5GkNNKSBdDFbG9IYI9n+F8VQ3Uhn4mi0VTIp/UubPDalJgySaIKopyrX1L/uMxdkRW8Zaq2RAaRcuJYTtkoLesgJbbU3hSCcl2dJsoT4n9EXUZCPY4ysSR6GjOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715275582; c=relaxed/simple;
	bh=4Ux6eD5b55D850q/RBE3WjWzxLfsSgdiaRO9j32F3Fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AfRyu48S8/6AZRMKvoUuXEoPvttfsNu98/sn+S7qOqEioxLFSNIq3zRT3h2dyQlYjIAGdCKES/Yn0raYCKilvAiOAghdHgfSuDvMr/02jyS9DULRPiVNBXEi78NM8vf4v07W9xicIk41GkShn4BpMFtuXXWSeMxPibjydxtTLoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Es+ZAppU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715275580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=a5oYbQb1rdNDtc1fvmsD4t6HEKw4WQZbY3Ne8Gt5fSU=;
	b=Es+ZAppU8QP0w+GtkyOFP+d9Wf05nFqtddJrKwcKiNw8yIFKeMAF9b+UW+hIxJM7B7454p
	9hGzhYcfsFZoh2DKSSmOT7P3ar+0L6SXqF1cWPE/hpKsWAUDIiKwynreNbC4YydlMiIdsy
	n1HCeB/rVsnqR1kwKhUZZbq3B1z46g8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-nGO4UFGpON-Wy5g9VTr6Hg-1; Thu, 09 May 2024 13:26:18 -0400
X-MC-Unique: nGO4UFGpON-Wy5g9VTr6Hg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-418a673c191so5427825e9.0
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 10:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715275577; x=1715880377;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a5oYbQb1rdNDtc1fvmsD4t6HEKw4WQZbY3Ne8Gt5fSU=;
        b=IpHE5EGnTZ0awcfiBzcKuu7L6FmuM/tV+7veKPCPE7k4cS02Khiw0pKdC6uHH80qvO
         v3BovGKulrTYgO636Gvc0X570YgUPDp6EakRp+oZrpIaq66xo9lgh9a/DThMkguutVel
         xwCElrXoGetKN1sZBvS/Lh2KvNsaLZi2uPfC8CXTK89fpC/cQSQOaIEhCbH7Kb7UkLi+
         Dv2j9frZxmgoOzKWfVqd2w5YNRBdTMP7m456lSGxQfgtUlPyiBF99jTER024bhLnBJUB
         jR9xPiBNW6w/QnlRAxliSTRNYLtG364pvOt6FJHhMMG3L8DS1FPwPoupaveTJqrqLP35
         88RQ==
X-Forwarded-Encrypted: i=1; AJvYcCUM79GdL0UW8xUUYlMBHIlAfPV/APPY5nlks2hVusH+YvIH4vZFoYnEZ+321WwTUuodtToYssQEDkNj1UBV0U8tTzHd
X-Gm-Message-State: AOJu0Yz+UlujPWDvHr1Q9o2ABjfKI+dFoqYX/Lu9h/xLivoNK5Q4kK5Y
	59nN8dnnvLpulHOtxGkuuA7Bb6vRw0dQqcWhVZ2Omxns5nnpiWij1+kSrq7bBO/rPjfnTCvW6LC
	JbWgIFll923xULaO1jLjG6RASn9JymgT2qnwUUSsftevlFcdiNQ==
X-Received: by 2002:a05:600c:1f90:b0:41c:190:2b94 with SMTP id 5b1f17b1804b1-41feaa2f450mr2544605e9.6.1715275577440;
        Thu, 09 May 2024 10:26:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGn4hVoBDL5JQFyatm+c5hc/yt0ALO877d3U/D/OSQD7L3e7ZEpHfUn0Q6QyF9gi1Q+mqQh5w==
X-Received: by 2002:a05:600c:1f90:b0:41c:190:2b94 with SMTP id 5b1f17b1804b1-41feaa2f450mr2544475e9.6.1715275577030;
        Thu, 09 May 2024 10:26:17 -0700 (PDT)
Received: from ?IPV6:2003:cb:c716:7600:ac6:a414:3c04:6f5a? (p200300cbc71676000ac6a4143c046f5a.dip0.t-ipconnect.de. [2003:cb:c716:7600:ac6:a414:3c04:6f5a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41f86e7e340sm68113495e9.0.2024.05.09.10.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 May 2024 10:26:16 -0700 (PDT)
Message-ID: <393b666b-3f28-439e-92e0-727c7bd529f3@redhat.com>
Date: Thu, 9 May 2024 19:26:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] s390: PG_arch_1+folio cleanups for uv+hugetlb
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Matthew Wilcox <willy@infradead.org>, Thomas Huth <thuth@redhat.com>
References: <20240508182955.358628-1-david@redhat.com>
 <20240509150459.12056-A-hca@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240509150459.12056-A-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.05.24 17:04, Heiko Carstens wrote:
> On Wed, May 08, 2024 at 08:29:45PM +0200, David Hildenbrand wrote:
>> Rebased on 390x/features. Cleanups around PG_arch_1 and folio handling
>> in UV and hugetlb code.
>>
>> One "easy" fix upfront. Another issue I spotted is documented in [1].
>>
>> Once this hits upstream, we can remove HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
>> from core-mm and s390x, so only the folio variant will remain.
>>
>> Compile tested, but not runtime tested with UV, I'll appreciate some
>> testing help from people with UV access and experience.
>>
>> [1] https://lkml.kernel.org/r/20240404163642.1125529-1-david@redhat.com
>>
>> v2 -> v3:
>> * "s390/uv: split large folios in gmap_make_secure()"
>>   -> Spelling fix
>> * "s390/hugetlb: convert PG_arch_1 code to work on folio->flags"
>>   -> Extended patch description
> 
> Added Claudio's Reviewed-by from v2 to the third patch, and fixed a
> typo in the commit message of patch 9.

Ah, I missed on RB, thanks!

-- 
Cheers,

David / dhildenb


