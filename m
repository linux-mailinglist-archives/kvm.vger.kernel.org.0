Return-Path: <kvm+bounces-63882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B084C75540
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:24:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 63DCB4E0F7A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A1D3624D6;
	Thu, 20 Nov 2025 16:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TuIfBSq9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0C4362142
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763655339; cv=none; b=uADTH8LNnc0a8vjYxpJkGS2X9Zo2HrPm/e37kUT7+vmASdPCzs3c7VYYuAD5FxO96VEIygpzzAJbVnfoFfZASV+24u+iq6G7v3h0pTenznN/TsTD8nAIWOhINMk7l26FGRWnGxgZ/vMmysxxKA1+MerIKf6BdwqmaIV7hV6ipK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763655339; c=relaxed/simple;
	bh=x+AJVK3obNH3Mt+i7P/+UHsHFumyeWfW7CNquNQYotM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tPop14icQQcafVBvk/jc1R4xToYOLrtstM/ijb7KKSxmIJPiCNoGXuCzNkZGlD8QcjsHxmFfyjF0je+LiKNDvRQVts5q0B+jMZY3jrle4jcpqcfzny5s/ArMOzAf6mvWH1zOMJFnwpFCC86IsGVuECtt4MQ6PdFo9+e92zgGHPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TuIfBSq9; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so1761349a12.3
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 08:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763655335; x=1764260135; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pPNRYnbjkyS1ahsgMDJMNSyZvjLf47VuYi+Dp4Yl22g=;
        b=TuIfBSq9TSzd1yL8riW+62z9MVyvOYe6deavbG3Y5e50Y9h77EU6AsUiq8AYIVyYdx
         KIW1arlh9cUF9FrzeQF9bq7ejSyy0mRs4YrjdXyTQOXvzUmAl+Y+zJKEAIOj925yhHwG
         8PJfI5ZrOUH8XH2mx1ZEuHVozRifOtKtQUEWPlPjFaW9rVh1b7JqF3JiD3iynsduBeYd
         SU8l6JS366W9301q2mi6dQa0vk25kILt1FYAz+0mwZhHpkhbWl6HAhthDMG/3Fv8yMGo
         0bCyU7KtAvOBIQ8DSxuCl6A+t61kUJHs57iz0435D/bvpuisZ2jjdcHHa6NlefuECtc5
         kzoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763655335; x=1764260135;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pPNRYnbjkyS1ahsgMDJMNSyZvjLf47VuYi+Dp4Yl22g=;
        b=YVUG431Cx0vl5edbOrV3up1AQQ66Ca51Mwgca4JdEYUkqNPE6jOoBpHJ14Yc4gXwV7
         OY7Q1yNYQgQQxqO+7XRjxXUn2pCpfR+XDV5iwkcVsaDZR/XnTNojgFgVAK+A20BkDWL4
         ILg3Q7leOEJMmgpCyq06+0UQWJNSPgv8ZgB+yKp5rd6GwpOeCL9MPQVV7LaqbF+K5FKf
         onFterfdaljM9W0EjELu2zTIj6OYIHLB3mYweMZdwje9sEXxGxDjWTj/Cxdk9TnBOpwz
         yQ4pWpo9swaLlhbgmUzlrPWltPf6shKfoBAwdYR6IbtAc6qPvhcyPvMpOI3vsbn8lojI
         toUg==
X-Forwarded-Encrypted: i=1; AJvYcCV2viYmYdQqWYhyF18Nh59zxKCpKTnEoL1sQoV3StFn5XJcveI+b39YxHHJsFmrKiv9nlo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrSbkJErfQLDhJqx4BHkGk8zrBGxi2FDmgGGTGgvLb/rR8kq4Q
	8vn9IlUTxpJYz0+geoLe1K5OTcoNYmgKS9ia4SnaJaa3wO4UcOKvoiROErEV+Bj4PH4=
X-Gm-Gg: ASbGnculN8HofDtjoa9/HNTSLqMpjS9A4RdPC2mqZL73276EoTWUSQN119JVNqVM8wd
	c870SKlGEHLdLkMAj5YwRTpcNQCcTge138aFidO8wqRfQOJrG1ORufoGUnXmGF51agngVOmDdT6
	ubXNg96it4sgqa8XCtFUo301v+CFU8XKJnh3AXSkbyN2Ojvnn2coIS/AwtvCB/q+inGypQFofsQ
	AYxiq+t4YHJQjK4+4lAagXC1WmK/4+zgKZ8dl7leLmBcE6bnT9YfUW3Wj/epUkCC8GzKHQfvDq5
	/V3eSPB5OoFTBNK/AkNbDf+Sd8Ko+T7tRGBuY+tNrzfp3cTRmd/U9Mv3LiiltNwVAR5awVn/rft
	0k+8MTRkPwoV4u4P5K+qKZqx2GVpvK0dBM9IOhsAkviXvCxEJGZAECE+eRHHYPgIyrUX1zZ1sUg
	R50I1QWhQYhNn+7ALCV+FOTWS8a5HCQ4oL0wKB
X-Google-Smtp-Source: AGHT+IFqkV7lMvevUcTeEUpDBuop6rPRv6/J4m2A8RRXNaq9M3ifnhEsRgJ1y/Dnc2tEm7hAFb6Smg==
X-Received: by 2002:a17:907:3e0c:b0:b71:df18:9fba with SMTP id a640c23a62f3a-b76587b1df5mr312696166b.15.1763655334530;
        Thu, 20 Nov 2025 08:15:34 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654fd43a6sm231210666b.32.2025.11.20.08.15.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 08:15:34 -0800 (PST)
Message-ID: <abe6849b-4bed-4ffc-ae48-7bda3ab0c996@suse.com>
Date: Thu, 20 Nov 2025 18:15:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/11] x86/bhi: x86/vmscape: Move LFENCE out of
 clear_bhb_loop()
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-1-1adad4e69ddc@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 xsFNBGcrpvIBEAD5cAR5+qu30GnmPrK9veWX5RVzzbgtkk9C/EESHy9Yz0+HWgCVRoNyRQsZ
 7DW7vE1KhioDLXjDmeu8/0A8u5nFMqv6d1Gt1lb7XzSAYw7uSWXLPEjFBtz9+fBJJLgbYU7G
 OpTKy6gRr6GaItZze+r04PGWjeyVUuHZuncTO7B2huxcwIk9tFtRX21gVSOOC96HcxSVVA7X
 N/LLM2EOL7kg4/yDWEhAdLQDChswhmdpHkp5g6ytj9TM8bNlq9I41hl/3cBEeAkxtb/eS5YR
 88LBb/2FkcGnhxkGJPNB+4Siku7K8Mk2Y6elnkOctJcDvk29DajYbQnnW4nhfelZuLNupb1O
 M0912EvzOVI0dIVgR+xtosp66bYTOpX4Xb0fylED9kYGiuEAeoQZaDQ2eICDcHPiaLzh+6cc
 pkVTB0sXkWHUsPamtPum6/PgWLE9vGI5s+FaqBaqBYDKyvtJfLK4BdZng0Uc3ijycPs3bpbQ
 bOnK9LD8TYmYaeTenoNILQ7Ut54CCEXkP446skUMKrEo/HabvkykyWqWiIE/UlAYAx9+Ckho
 TT1d2QsmsAiYYWwjU8igXBecIbC0uRtF/cTfelNGrQwbICUT6kJjcOTpQDaVyIgRSlUMrlNZ
 XPVEQ6Zq3/aENA8ObhFxE5PLJPizJH6SC89BMKF3zg6SKx0qzQARAQABzSZOaWtvbGF5IEJv
 cmlzb3YgPG5pay5ib3Jpc292QHN1c2UuY29tPsLBkQQTAQoAOxYhBDuWB8EJLBUZCPjT3SRn
 XZEnyhfsBQJnK6byAhsDBQsJCAcCAiICBhUKCQgLAgQWAgMBAh4HAheAAAoJECRnXZEnyhfs
 XbIQAJxuUnelGdXbSbtovBNm+HF3LtT0XnZ0+DoR0DemUGuA1bZAlaOXGr5mvVbTgaoGUQIJ
 3Ejx3UBEG7ZSJcfJobB34w1qHEDO0pN9orGIFT9Bic3lqhawD2r85QMcWwjsZH5FhyRx7P2o
 DTuUClLMO95GuHYQngBF2rHHl8QMJPVKsR18w4IWAhALpEApxa3luyV7pAAqKllfCNt7tmed
 uKmclf/Sz6qoP75CvEtRbfAOqYgG1Uk9A62C51iAPe35neMre3WGLsdgyMj4/15jPYi+tOUX
 Tc7AAWgc95LXyPJo8069MOU73htZmgH4OYy+S7f+ArXD7h8lTLT1niff2bCPi6eiAQq6b5CJ
 Ka4/27IiZo8tm1XjLYmoBmaCovqx5y5Xt2koibIWG3ZGD2I+qRwZ0UohKRH6kKVHGcrmCv0J
 YO8yIprxgoYmA7gq21BpTqw3D4+8xujn/6LgndLKmGESM1FuY3ymXgj5983eqaxicKpT9iq8
 /a1j31tms4azR7+6Dt8H4SagfN6VbJ0luPzobrrNFxUgpjR4ZyQQ++G7oSRdwjfIh1wuCF6/
 mDUNcb6/kA0JS9otiC3omfht47yQnvod+MxFk1lTNUu3hePJUwg1vT1te3vO5oln8lkUo9BU
 knlYpQ7QA2rDEKs+YWqUstr4pDtHzwQ6mo0rqP+zzsFNBGcrpvIBEADGYTFkNVttZkt6e7yA
 LNkv3Q39zQCt8qe7qkPdlj3CqygVXfw+h7GlcT9fuc4kd7YxFys4/Wd9icj9ZatGMwffONmi
 LnUotIq2N7+xvc4Xu76wv+QJpiuGEfCDB+VdZOmOzUPlmMkcJc/EDSH4qGogIYRu72uweKEq
 VfBI43PZIGpGJ7TjS3THX5WVI2YNSmuwqxnQF/iVqDtD2N72ObkBwIf9GnrOgxEyJ/SQq2R0
 g7hd6IYk7SOKt1a8ZGCN6hXXKzmM6gHRC8fyWeTqJcK4BKSdX8PzEuYmAJjSfx4w6DoxdK5/
 9sVrNzaVgDHS0ThH/5kNkZ65KNR7K2nk45LT5Crjbg7w5/kKDY6/XiXDx7v/BOR/a+Ryo+lM
 MffN3XSnAex8cmIhNINl5Z8CAvDLUtItLcbDOv7hdXt6DSyb65CdyY8JwOt6CWno1tdjyDEG
 5ANwVPYY878IFkOJLRTJuUd5ltybaSWjKIwjYJfIXuoyzE7OL63856MC/Os8PcLfY7vYY2LB
 cvKH1qOcs+an86DWX17+dkcKD/YLrpzwvRMur5+kTgVfXcC0TAl39N4YtaCKM/3ugAaVS1Mw
 MrbyGnGqVMqlCpjnpYREzapSk8XxbO2kYRsZQd8J9ei98OSqgPf8xM7NCULd/xaZLJUydql1
 JdSREId2C15jut21aQARAQABwsF2BBgBCgAgFiEEO5YHwQksFRkI+NPdJGddkSfKF+wFAmcr
 pvICGwwACgkQJGddkSfKF+xuuxAA4F9iQc61wvAOAidktv4Rztn4QKy8TAyGN3M8zYf/A5Zx
 VcGgX4J4MhRUoPQNrzmVlrrtE2KILHxQZx5eQyPgixPXri42oG5ePEXZoLU5GFRYSPjjTYmP
 ypyTPN7uoWLfw4TxJqWCGRLsjnkwvyN3R4161Dty4Uhzqp1IkNhl3ifTDYEvbnmHaNvlvvna
 7+9jjEBDEFYDMuO/CA8UtoVQXjy5gtOhZZkEsptfwQYc+E9U99yxGofDul7xH41VdXGpIhUj
 4wjd3IbgaCiHxxj/M9eM99ybu5asvHyMo3EFPkyWxZsBlUN/riFXGspG4sT0cwOUhG2ZnExv
 XXhOGKs/y3VGhjZeCDWZ+0ZQHPCL3HUebLxW49wwLxvXU6sLNfYnTJxdqn58Aq4sBXW5Un0Q
 vfbd9VFV/bKFfvUscYk2UKPi9vgn1hY38IfmsnoS8b0uwDq75IBvup9pYFyNyPf5SutxhFfP
 JDjakbdjBoYDWVoaPbp5KAQ2VQRiR54lir/inyqGX+dwzPX/F4OHfB5RTiAFLJliCxniKFsM
 d8eHe88jWjm6/ilx4IlLl9/MdVUGjLpBi18X7ejLz3U2quYD8DBAGzCjy49wJ4Di4qQjblb2
 pTXoEyM2L6E604NbDu0VDvHg7EXh1WwmijEu28c/hEB6DwtzslLpBSsJV0s1/jE=
In-Reply-To: <20251119-vmscape-bhb-v4-1-1adad4e69ddc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/25 08:17, Pawan Gupta wrote:
> Currently, BHB clearing sequence is followed by an LFENCE to prevent
> transient execution of subsequent indirect branches prematurely. However,
> LFENCE barrier could be unnecessary in certain cases. For example, when
> kernel is using BHI_DIS_S mitigation, and BHB clearing is only needed for
> userspace. In such cases, LFENCE is redundant because ring transitions
> would provide the necessary serialization.
> 
> Below is a quick recap of BHI mitigation options:
> 
>    On Alder Lake and newer
> 
>    - BHI_DIS_S: Hardware control to mitigate BHI in ring0. This has low
>                 performance overhead.
>    - Long loop: Alternatively, longer version of BHB clearing sequence
> 	       on older processors can be used to mitigate BHI. This
> 	       is not yet implemented in Linux.

I find this description of the Long loop on "ALder lake and newer" 
somewhat confusing, as you are also referring "older processors". 
Shouldn't the longer sequence bet moved under "On older CPUs" heading? 
Or perhaps it must be expanded to say that the long sequence could work 
on Alder Lake and newer CPUs as well as on older cpus?

> 
>    On older CPUs
> 
>    - Short loop: Clears BHB at kernel entry and VMexit.

<snip>

