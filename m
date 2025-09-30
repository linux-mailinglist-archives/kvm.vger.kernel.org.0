Return-Path: <kvm+bounces-59226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0A6BAE88C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 22:27:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DA99188E6A2
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 20:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005A8244669;
	Tue, 30 Sep 2025 20:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c1DKmxzk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7AE4C81
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 20:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759264069; cv=none; b=NV7HubIkK7zNQb7lHFlydFWWOcslEuJKF+vztmUikPl9yxI3A/ihl8b4TNaClLDYHrT9UxeOLFXep3ykaaGD6s1UfXP5fhWiubIDQ8NOc7l7O8Ylr+a3v8TSLx7TUULdMm3CR+UVLaZquy2CD8dM7E5/pTr90Wjl/MrLDc/AEZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759264069; c=relaxed/simple;
	bh=i9IyjM8L6AGWv5MJbdjRzaeSQ7hp1tMvP/a98lt0BZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=txUd1MWqRGQFQVFZzEK72c5wckjWTgsFcWhURtSXEkoabk6rQw7PSeuhLqoByF8mz0MY78toj2oRhPyBjm7jmG+cXnzYDue5O11QMgwmUAe+KhkRw6F8SF8fT43SlkhAQgalw7tYc33kor8rECu7oqwRem1tzs/f82jerFMjGNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c1DKmxzk; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-789fb76b466so854067b3a.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 13:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759264067; x=1759868867; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/mRpoLgFc8U26Jlg/SSZYXO8nFhlzFTCTlSmEDP24rk=;
        b=c1DKmxzkNIEy4OfIKvVlnRJm4NIeCHMlTxCPd5gV7rWIEWnHPjy5rEFtRI30f1nQY3
         KPzzXUpE6d8x7eGQFAqnmSRmBNS6eJNg1ErmbkIkXx/UdP293ECYs5ghnGIiv7ILmupQ
         EQXaCmodsZelkuYsWfAIu1fpgAG/T2uXnBJG6OYxqpiOckOQN1E5FLYGa1UxLLCaSLld
         LUMEpMKuBa8u5nFGhMwqvXpYLorxaxM74bgFMCm5qaHbY7CRcTJafckCC+oSoveZrOas
         11i3LNq6EZry2G4LYX6kGnq4ECgfLuyiENj9RBP2PzyT+mMONvJBuJUJJwVpL9bdvdli
         cDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759264067; x=1759868867;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/mRpoLgFc8U26Jlg/SSZYXO8nFhlzFTCTlSmEDP24rk=;
        b=n0mbRz5jF8AG6n5je4NWnjtuqcoQBXbpssjumu+fkBWl3Sms1P/zTuzTx7MM4vWkLI
         SV1utFkj8wOhPzjPqqBdsFfrGvdQh2NhfaMQN5Pk4pgZ2rCKueY4mzlGk0JCKRHy/MnR
         EV2BcDQFGDfwRhpHIB4IXt/vucqrjIPc4jIPMryhreqvsgsKk7n/bgQilptB+2/aJamS
         JH/m0c7dlc08q1z2OoHoIRLE0UKl7GlMip5SobGpUxsPnj8lZ6ZsQjvIsEBYNSsKJvTK
         8WcKXAs5fp6dA33/ife+WcOYrOyywk60Wjht/BZ9elwOTdL5MwKocTU3EPGXJwliOiq3
         RzZw==
X-Forwarded-Encrypted: i=1; AJvYcCVRFNaS8NKkwK+pGxULFMCqegVlsBaqYy6+mE+d+3Kbg8LvmGEy5KSdY3VqaTQUkBqb2ZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqHgnhkR9M5ZF2XubvvQ4aVTjfQzBY3D6uzITlWnIeHtf8mMs+
	KFwKjojSB5B4H8YI2eYtnUfmu/UwQ/Pe0mNWtBV+l74wYsLcWSUQK52uQ7iFyh9M+II=
X-Gm-Gg: ASbGncs62QGNvZPbo3XMugkwIqnyocL1YDhhgU9TuvlTVXXlbc0v/HKxIkXXocRb9ze
	oYEA15GueLsO4LO6u+5wjxOhFWE6Y5FxeWJOurdJgmS7W2yeasi/7D0GnJtDGUXgdOGmcMFaKUq
	9+4a7AFzRM3NdDubwvQ9xSCdHgAHfcxhkZYzfCXwEsChjssrW5i0eGBhw+Dt4LuSbATZChb5iqL
	GyYHV9Fykqmdy43HpQ5j5u49dY3VBF6A/HM+nLKR9Syo7G36kLMo87On3yjma/fxc/SCpr+/yXS
	dvykiNUrwoQJ5GZzsR8C4LWb1GGLtzf+nvZ8U46bKnhhFU1xRzR9/AkT0Yy9z9KRdsIcc00PetM
	6zQpd+b73eV7leu5IwE/tBrMPGwE2X7BUAb6aXmjyJYt8vK+YrzMuL7FJ8CjrDLdFwvT+YyQ=
X-Google-Smtp-Source: AGHT+IGHwGdaI9/7x3FSGjAll2aiAsXQ51koCXbRJnhtoa+Tb/JHj9ZGjhNKi09HfL4J9l5mVWb8dA==
X-Received: by 2002:a05:6a00:1146:b0:781:2320:5a33 with SMTP id d2e1a72fcca58-78af3ffe1e5mr846993b3a.9.1759264066784;
        Tue, 30 Sep 2025 13:27:46 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.157.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102b64a87sm14613842b3a.69.2025.09.30.13.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 13:27:46 -0700 (PDT)
Message-ID: <429e61aa-a9af-4a97-a549-d7d782e34fe5@linaro.org>
Date: Tue, 30 Sep 2025 13:27:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/18] system/physmem: Un-inline
 cpu_physical_memory_read/write()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Reinoud Zandijk <reinoud@netbsd.org>,
 Peter Xu <peterx@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 David Hildenbrand <david@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 kvm@vger.kernel.org, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 xen-devel@lists.xenproject.org, Stefano Garzarella <sgarzare@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org,
 Paul Durrant <paul@xen.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Jason Herne
 <jjherne@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>
References: <20250930082126.28618-1-philmd@linaro.org>
 <20250930082126.28618-15-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20250930082126.28618-15-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/30/25 01:21, Philippe Mathieu-Daudé wrote:
> In order to remove cpu_physical_memory_rw() in a pair of commits,
> and due to a cyclic dependency between "exec/cpu-common.h" and
> "system/memory.h", un-inline cpu_physical_memory_read() and
> cpu_physical_memory_write() as a prerequired step.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/exec/cpu-common.h | 12 ++----------
>   system/physmem.c          | 10 ++++++++++
>   2 files changed, 12 insertions(+), 10 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

