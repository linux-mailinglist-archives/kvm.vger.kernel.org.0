Return-Path: <kvm+bounces-63884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 44185C755EB
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id F011D2EB7B
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA565366DC7;
	Thu, 20 Nov 2025 16:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SQjD+lqb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B9836C0C2
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 16:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763656138; cv=none; b=lzHt4Ljp5iCO/c4dctDL28ZnobN05eoN3cIE208+Abzt7U45cIh3a1gg3KFdf5TE0/rLQyWMd7BfkJIoKb+x17tL7EFcEINEnxYy+iRc52KBAfgkBsaB5liUWEPjm+XpA3E8k4XLyDYlnJu1GSW4+V1I+yOGNlR1TJOuSCo/ZE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763656138; c=relaxed/simple;
	bh=v5W73UYNVi1b1lwv4VRoiztWf3NjAmzQsuhHHsdfkbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kAA9LZ5Z6Y8DREIuKjcpFMyvvA816Wu2OtsBY2lXcMqkE4g9TNLZTGeMeYegkJofu6v7jv/pSjL5e97F+4ymDanG+fnIvTp9M5Z0g+cOYgQ2CnhZMVDM5fHtzPPu2llXG/2ed96Vm2fmHpmrz+ZAU/hiOZOH5g4YcBRlfL4weEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SQjD+lqb; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b735b89501fso122644966b.0
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 08:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763656134; x=1764260934; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CCkBHPhS2QzBuP810jkT6K8D9fwANPUeGSGm00q6Xdc=;
        b=SQjD+lqb1AQj4qr1NpSJk1mKtiBdwZJjlOwCgP1455g7KHJthspO8rigetLluaCbhI
         8U8zgX+kxF5tZLGaJretbLojtz04rL9+oUExkS6xH0Q0oWiTfxMITWUlD5FijV+SDxIq
         KSA0EBNUobfO7MkEQSJ4O6wXKOIpGtXy9mRjxA0CfupdRdk25Gn/G8oysqnVC7XdNeVT
         zg14xfUQNhJSl+nqRK6anqqy0k8EFdfY7R/rHn8yGONpvwGkyrSuo8xzj5lghtj6v9NX
         8srGx3lLQrtoTnzLJw35wlh1vT5JxcJWmeVab8BrR3dCwW46YMyzYijZYiom4vMvSdCM
         yxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763656134; x=1764260934;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CCkBHPhS2QzBuP810jkT6K8D9fwANPUeGSGm00q6Xdc=;
        b=Qa7JHxZ5xQ9f8DrvkYiCMax+7Si0Fpyc1/KLzqwGl9bQczQ9pyblXV8G9EKfaoQHgd
         /JhSAre4YbVLfN1OD08JUfR+Ka467Q4hzCvO3ehI9JTTUcbI+pRtzm0nPN+P98vH8FSr
         b2hZ+gWMlRvK0chrvAvJYDFUvEvAI2bOClWBDwA1H961y9SVVORlMPsK9PPzB1I+U9i1
         e8zmmUDeCQQ3fLUioDmKvM2A45M4BHIZlA3aX+TTKwrPmE69NMO3GvY5Rv4S9adSB0Lz
         RFz7vlAQ/TYR0Xjft7l6irCwSQm7pbnB7a/54ybtGyuEXa2zmoKRlEmaHks+TNWWoY1B
         HCog==
X-Forwarded-Encrypted: i=1; AJvYcCUU2tuoL/YlSbiNC5cADA3/hwGpw7jYs44EpwWRujHXGWK9h1Dc0pY+Alq3WpqItxHriAM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx0Epi4dYi49Yug36xgWXfsnYYGSJFdvgynVZpq2EsRi+F9Q2a
	KmndAVvHeXTIFef3FOo70Jpz2ZIVo5941NTjcSFkgOkiz/zmh6k5X+M5BN/5SMXN5KQ=
X-Gm-Gg: ASbGncvsGLu/p3OESgS8qZdrSfn3YX9L46CvcFlvsN3Bru+M9ssu0h2OHY6dms94iXZ
	95hChaP6inJnF6cBSEsnjbHRNrM8dldHzBPL2LoLP5J7+oYfNUTrQW995MW6i9Xe8SQ2zILoF53
	0o6cbYHNdk3RmWrj4linJkekQW4XsoBPxpHqaKQxyZ+mTQrywJeeqDxQZd4UusQ18zDQizqxMWH
	9kM9xZgevvowjEbZVqNfCgMtQPiTLdDqF2prBg0ok1VSt/zDUT6zt8Y2ghNPA7SAGDfawKscEZd
	Fe0VF0d3H3+8RVKge2YCBempRZVgR4f8yqFd+ieXNoKTsAxzT0UpktGisco0LuIGgw7HbXOUTIA
	tw9dMF07HoIeFJKt+hdmU4boxk+74r3J5IaPePNNhKDtejWZLydbQDwxh5IdL/dGMQtdEnZwuYA
	OeMY82MVfkzdSofbeD7bxbBobB3dnTf9CpzT9P
X-Google-Smtp-Source: AGHT+IHKHzLeVLzaSu4aY9m+g1e/Qc718Big7iFSujI2Pi8qO5fqxMImoYxWncUTG48h5b+B49tNcg==
X-Received: by 2002:a17:907:3f1c:b0:b73:792c:6326 with SMTP id a640c23a62f3a-b7654d86d9amr344528066b.11.1763656133782;
        Thu, 20 Nov 2025 08:28:53 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7655029543sm241311366b.61.2025.11.20.08.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 08:28:53 -0800 (PST)
Message-ID: <f7a380bb-88fa-4dd2-ba75-977b2e22bbb0@suse.com>
Date: Thu, 20 Nov 2025 18:28:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/11] x86/bhi: Move the BHB sequence to a macro for
 reuse
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-2-1adad4e69ddc@linux.intel.com>
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
In-Reply-To: <20251119-vmscape-bhb-v4-2-1adad4e69ddc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/25 08:18, Pawan Gupta wrote:
> In preparation to make clear_bhb_loop() work for CPUs with larger BHB, move
> the sequence to a macro. This will allow setting the depth of BHB-clearing
> easily via arguments.
> 
> No functional change intended.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

