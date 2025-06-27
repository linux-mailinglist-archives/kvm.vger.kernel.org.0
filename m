Return-Path: <kvm+bounces-50988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA11AEB7F6
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 14:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 277F47AF4CA
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3080B2D8777;
	Fri, 27 Jun 2025 12:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GMnlJi+J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62192D3EEC
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 12:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751028291; cv=none; b=pb3yqRYqYBDA57UOEUj3rPkoUlTOQMdz3boJayy6QgrDVX2+EyNPRSz9Zsd/SPJ20Bzs/9K28bpK5lYdUvNLlqGH7y+x1oIfvPBvZrxot1CxbIIqFPAjcCGtuqnd/028wNhXMp5XghtbFHe1e2u4wJRgCUTlYMpGoX4uWkKNaWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751028291; c=relaxed/simple;
	bh=7CxNAB6Ww6ghTcQzdWoMfravHLxKJEA3UU0mfgnUYyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qcxkfAkrfJ+0/5tFn+xZW/6U48EZV+VBqdZ3Mto0VXy5ymsxz1R0ehUSwrp9xbXY9C9FVwZUydByYyXrk9RyZcwY0ln3oSjATBt0qIonR4toF2sQ3BFkhjYoJpezWHbUCgHEzH6ftCrLrK4LXARJfRn0wSpTTc3ahsS/+8VfAEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GMnlJi+J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751028287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TZosY5w17Hxk/zCHJm5+wUbxMTuxq80xOJSHb1b9TZY=;
	b=GMnlJi+JXp4m3uInEcBA24fdHFQfz6AJuYcmK5ItcsT/3btpfw4VkAfQWGVdak3knSNTjh
	wNNlo5pjjblHJyHMfqemdM+kzXEsQtwzFKhQ8eHhv5I0FFmG7dQ/yA1Ez8ejzlfm+BAKyl
	vgyuekgiGczlQb64FQ9/cBMZTtVbu7s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-cYTnpsQsMDKJpuoy6aDuuA-1; Fri, 27 Jun 2025 08:44:46 -0400
X-MC-Unique: cYTnpsQsMDKJpuoy6aDuuA-1
X-Mimecast-MFC-AGG-ID: cYTnpsQsMDKJpuoy6aDuuA_1751028285
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45311704d22so13508085e9.2
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 05:44:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751028285; x=1751633085;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TZosY5w17Hxk/zCHJm5+wUbxMTuxq80xOJSHb1b9TZY=;
        b=LyntY+KPs+Bjy75bbx4RFPe30xHa1MaC+0xyaOpvGHD1uY9e7JEnIG5HVkPGtSsVAx
         pli2deh3LN8vMRaFCANDP0qxHV/K4w2R3ayTd7/9wXBfJ/oCBdFzgRur9pip0H9Zo8Lc
         OBBXAfxH/nO/twtQqW52LONiEqKyeNq7V67N8FYP7J8RZ3sx99G3CgZN/238PQ3S/z5I
         yAk676LW+25rrAofGvtxdu/+WOb/1ZBGnp+YV0F4ycOUSHx07MUGjJxUDivJAAyJn2tW
         C+bZVqgx5OrJgaDyWq35Lw2yXiRxZG5ugmCMFuVSaicGhiAKCh1TLiaLi3WiixslJlOf
         Uk6g==
X-Forwarded-Encrypted: i=1; AJvYcCX2pQ6b/rhcL8sZbyh/YHuHbk8NqMhH+ZpoZJELCH65H4EkMMG3uZbrf6s7wNf1LzKuGX0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpZrzWxMBgdqJKKns4jF2+D+F2IHxAs19cXyAzZeXCz4UaoY/B
	glXP+HdyiQ7GzMhzrjmhyKFw2WgosdBMAUn4nticdEdkeJ7LyDxbjBW15vpIRM8UnHVI5oFo1Sx
	zO7j85sQoxrAJ8UmcftC77ySUYO4ityv8d/ilJeCz0/d2TZqr9nriTA==
X-Gm-Gg: ASbGncui9ymN0PFFYFLP/WVP1m9UYNHPrLhozYfY4UUt6Ul1ITSduPm1TGl2mL8RixU
	kpuGLWKNfXmvx59/OTd7Le/6DSJFPgNpWGq/IymLnMS4xnWVykcLmMcD1YzvO/pDzhSgkS/lWQW
	q2RnuGIdkYOH1a5kHl2IvzaCbO+O2qMGS37GfURjE0hj4oM+d1Jj9tUUU/6mq+YMiHupGAb2xVC
	AlrCQlrMADXB371LsYTIB3AJHOLbUBaKiQhFt8dJmaUeyXULxt3zJAv0kdlHbUfCYy9JFhT7QSX
	NAQwV/SucppY+B2NmjyIv7iEVejf/gvrX7G0mgr74RCqmm7zBDMhH90LLh9yBGd3emwEgw==
X-Received: by 2002:a05:600c:1d1a:b0:43e:afca:808f with SMTP id 5b1f17b1804b1-4538ee790admr36216995e9.31.1751028284985;
        Fri, 27 Jun 2025 05:44:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjzEwFcMeAJ+My3RqiKLbICi2QrUfsZqQCz9lhS78S8Yc02l7InGbh/oVajWJNYQoqdnQtVg==
X-Received: by 2002:a05:600c:1d1a:b0:43e:afca:808f with SMTP id 5b1f17b1804b1-4538ee790admr36216495e9.31.1751028284425;
        Fri, 27 Jun 2025 05:44:44 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:244f:bd10:2bd0:124a:622c:badb? ([2a0d:3344:244f:bd10:2bd0:124a:622c:badb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538a423abbsm50841375e9.39.2025.06.27.05.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jun 2025 05:44:43 -0700 (PDT)
Message-ID: <9a940f1d-da2e-4400-909b-36c5d72c950a@redhat.com>
Date: Fri, 27 Jun 2025 14:44:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 net-next 4/9] vhost-net: allow configuring extended
 features
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowang@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Yuri Benditovich <yuri.benditovich@daynix.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Jonathan Corbet <corbet@lwn.net>,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org
References: <23e46bff5333015d92bf0876033750d9fbf555a0.1750753211.git.pabeni@redhat.com>
 <202506271443.G9cAx8PS-lkp@intel.com>
 <d172caa9-6d31-45a3-929c-d3927ba6702e@redhat.com>
 <20250627075441-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250627075441-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/25 2:18 PM, Michael S. Tsirkin wrote:
> On Fri, Jun 27, 2025 at 12:28:00PM +0200, Paolo Abeni wrote:
>> On 6/27/25 8:41 AM, kernel test robot wrote:
>>> kernel test robot noticed the following build warnings:
>>>
>>> [auto build test WARNING on net-next/main]
>>>
>>> url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Abeni/scripts-kernel_doc-py-properly-handle-VIRTIO_DECLARE_FEATURES/20250624-221751
>>> base:   net-next/main
>>> patch link:    https://lore.kernel.org/r/23e46bff5333015d92bf0876033750d9fbf555a0.1750753211.git.pabeni%40redhat.com
>>> patch subject: [PATCH v6 net-next 4/9] vhost-net: allow configuring extended features
>>> config: csky-randconfig-001-20250627 (https://download.01.org/0day-ci/archive/20250627/202506271443.G9cAx8PS-lkp@intel.com/config)
>>> compiler: csky-linux-gcc (GCC) 15.1.0
>>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250627/202506271443.G9cAx8PS-lkp@intel.com/reproduce)
>>>
>>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>>> the same patch/commit), kindly add following tags
>>> | Reported-by: kernel test robot <lkp@intel.com>
>>> | Closes: https://lore.kernel.org/oe-kbuild-all/202506271443.G9cAx8PS-lkp@intel.com/
>>>
>>> All warnings (new ones prefixed by >>):
>>>
>>>    In file included from include/linux/uaccess.h:12,
>>>                     from include/linux/sched/task.h:13,
>>>                     from include/linux/sched/signal.h:9,
>>>                     from include/linux/rcuwait.h:6,
>>>                     from include/linux/percpu-rwsem.h:7,
>>>                     from include/linux/fs.h:34,
>>>                     from include/linux/compat.h:17,
>>>                     from drivers/vhost/net.c:8:
>>>    arch/csky/include/asm/uaccess.h: In function '__get_user_fn.constprop':
>>>>> arch/csky/include/asm/uaccess.h:147:9: warning: 'retval' is used uninitialized [-Wuninitialized]
>>>      147 |         __asm__ __volatile__(                           \
>>>          |         ^~~~~~~
>>>    arch/csky/include/asm/uaccess.h:187:17: note: in expansion of macro '__get_user_asm_64'
>>>      187 |                 __get_user_asm_64(x, ptr, retval);
>>>          |                 ^~~~~~~~~~~~~~~~~
>>>    arch/csky/include/asm/uaccess.h:170:13: note: 'retval' was declared here
>>>      170 |         int retval;
>>>          |             ^~~~~~
>>>
>>>
>>> vim +/retval +147 arch/csky/include/asm/uaccess.h
>>>
>>> da551281947cb2c Guo Ren 2018-09-05  141  
>>> e58a41c2226847f Guo Ren 2021-04-21  142  #define __get_user_asm_64(x, ptr, err)			\
>>> da551281947cb2c Guo Ren 2018-09-05  143  do {							\
>>> da551281947cb2c Guo Ren 2018-09-05  144  	int tmp;					\
>>> e58a41c2226847f Guo Ren 2021-04-21  145  	int errcode;					\
>>> e58a41c2226847f Guo Ren 2021-04-21  146  							\
>>> e58a41c2226847f Guo Ren 2021-04-21 @147  	__asm__ __volatile__(				\
>>> e58a41c2226847f Guo Ren 2021-04-21  148  	"1:   ldw     %3, (%2, 0)     \n"		\
>>> da551281947cb2c Guo Ren 2018-09-05  149  	"     stw     %3, (%1, 0)     \n"		\
>>> e58a41c2226847f Guo Ren 2021-04-21  150  	"2:   ldw     %3, (%2, 4)     \n"		\
>>> e58a41c2226847f Guo Ren 2021-04-21  151  	"     stw     %3, (%1, 4)     \n"		\
>>> e58a41c2226847f Guo Ren 2021-04-21  152  	"     br      4f              \n"		\
>>> e58a41c2226847f Guo Ren 2021-04-21  153  	"3:   mov     %0, %4          \n"		\
>>> e58a41c2226847f Guo Ren 2021-04-21  154  	"     br      4f              \n"		\
>>> da551281947cb2c Guo Ren 2018-09-05  155  	".section __ex_table, \"a\"   \n"		\
>>> da551281947cb2c Guo Ren 2018-09-05  156  	".align   2                   \n"		\
>>> e58a41c2226847f Guo Ren 2021-04-21  157  	".long    1b, 3b              \n"		\
>>> e58a41c2226847f Guo Ren 2021-04-21  158  	".long    2b, 3b              \n"		\
>>> da551281947cb2c Guo Ren 2018-09-05  159  	".previous                    \n"		\
>>> e58a41c2226847f Guo Ren 2021-04-21  160  	"4:                           \n"		\
>>> e58a41c2226847f Guo Ren 2021-04-21  161  	: "=r"(err), "=r"(x), "=r"(ptr),		\
>>> e58a41c2226847f Guo Ren 2021-04-21  162  	  "=r"(tmp), "=r"(errcode)			\
>>> e58a41c2226847f Guo Ren 2021-04-21  163  	: "0"(err), "1"(x), "2"(ptr), "3"(0),		\
>>> e58a41c2226847f Guo Ren 2021-04-21  164  	  "4"(-EFAULT)					\
>>> da551281947cb2c Guo Ren 2018-09-05  165  	: "memory");					\
>>> da551281947cb2c Guo Ren 2018-09-05  166  } while (0)
>>> da551281947cb2c Guo Ren 2018-09-05  167  
>>
>> AFAICS the issue reported here is in the arch-specific uaccess helpers
>> and not related to this series.
>>
>> /P
> 
> I think it's due to code like this in your patch:
> 
> +                       if (get_user(features, featurep + 1 + i))
> +                               return -EFAULT;
> 
> the specific arch might have a bug that this is unconvering,
> or a limitation, I can't say.
> 
> Seems worth fixing, though.
> 
> Poke the mainatiners?

FTR, I tried the boot reproducer locally, and does not trigger here.

The above statement is AFAICS legit, and the issue, if any, is present
into such arch. I would not say this patch is 'uncovering' anything, as
the relevant pattern is very common.

Possibly the test robot added support for csky only recently?

I will ping the arch maintainers, but I suggest/argue not blocking this
series for this thing.

Thanks,

Paolo


