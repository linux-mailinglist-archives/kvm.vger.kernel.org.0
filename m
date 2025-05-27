Return-Path: <kvm+bounces-47787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C49B9AC4D15
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 13:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 864CF17DD98
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 11:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AB4257440;
	Tue, 27 May 2025 11:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fNZIY//T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D461E43ABC
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748344897; cv=none; b=CUR5kB6CfK8tZLVpdB/WC4Ay1tSQ+u7wNjjp761bMzF1ob/GTR0ZYZTVASm7oKupXODSq4PDX6Lz1kFOAUwIAFkFMAAAbblNgoscOXtPHg2VISNv0K7oMWB9JmNx8kOE43grAL2Y3EqliRyQ+iVag0A/4jKwYe7oAote6zmIubU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748344897; c=relaxed/simple;
	bh=QcCxQKvPBWrkcRX2SE9dq5/kuP2a1X39ZhE3AnH/3Sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qiq1zFGDHjmpvGzlilQBDlAH36W0w2NnLZvUTm48D361y/K8xiHwX0nO+CvZqcHXpFqskpoLnLU8ng18yWfKMi9PKbB7flVLl32oi4nvPY+bmQJBoK1JCLG+ekNO187emBF7xmgl4uHgjdzCANhscnmlhU3kpsktBu/TwvDx6Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fNZIY//T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748344894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EW/uzus/41RnnKKkSo0Ol8kuHO90+skVAb2RILvJGYc=;
	b=fNZIY//TEG0eC9m5HbnCGNh99zcaCvZoNJfC3OZf7fuoqGJjlSl0VU/60l6Czawf2XaFkl
	T64chMyuZodvWpdVrheLT2LdcrQeOGt1/htysdNlV9aVfHqM2plnXimJqy7eMsHiczID3W
	ova8+g67SXpZGeUnNbSz8MQrLtwmJlU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-cVhlC4h9MmSpTYAjs1ONLQ-1; Tue, 27 May 2025 07:21:33 -0400
X-MC-Unique: cVhlC4h9MmSpTYAjs1ONLQ-1
X-Mimecast-MFC-AGG-ID: cVhlC4h9MmSpTYAjs1ONLQ_1748344892
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-441c96c1977so19033255e9.0
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 04:21:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748344892; x=1748949692;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EW/uzus/41RnnKKkSo0Ol8kuHO90+skVAb2RILvJGYc=;
        b=r9+4JV0BbnLcpMLgE+U8Cmv8k3uk9z4xcTEsXJvuTVBuloD8GzMCgaJthme8ljqm7N
         qvX0qpX/+oHX88QjdyD1I4hoADG3E+1oNxl1RyNNFCFV7xQPQ+rrLROJsSsd5+puiAhr
         CHZrKadlJr1UghrdHmQPuv1j/4LGiHytyGs+DqTHubLpud6Iu5bBCijQiEGZ7DqdTeef
         ZWIx/jjX4GfEQ2AEF6Gq6cQKe/L1uBaVx2VCKvUD3ieuT2BF0reN1rDHrelioX0PRxDf
         iPc/tTSFgMcYPr64PvLaQBaVK/+1AyDSAD7fsBxyjn5gbnE5hwBACL6m20H58CYIrQEj
         PMxA==
X-Forwarded-Encrypted: i=1; AJvYcCUlGRNNgwZ+rw+41Qeh2owyiIjO0QbgfzwuLTRQ8ocMXDNR+8PqY4W+jjxtshZORum07IE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2NOGTcYmkSsdCpuE+EgzpD7kpDoJOsyVDG5gFIWWaG6IooBsy
	sOAMcHACCFggR0ZxRAcOHMtL2osCcXJkpYCm2yfUcMFaGDOmyxn8YK3I+p8QGkydE7h+uywZMAn
	Ri7qU0BaHsWyVvCsJZvZelGardOCjcLaNIqwamX/NSGXIFUFBUB4mUw==
X-Gm-Gg: ASbGncss/xNHDnWLgsOcCxJObz85QBW1KPbqcpqLbesf8GZm+G5cu+czf1k9QGXJo6Q
	V6CG1mzqSBneZjSBD8gpZlPDfZnOU/0YzkvA23+BQgTLgvljofZj48V7bYPSyIyO53FeEB6jrOX
	21jXimmiemq2Cm7Ynb/4AxzNkKRvpIMY03HESeWhe2kLkP2LU95zMZiQth2wQ5NU6kDJ9Bvt7El
	X5UrhDoScgQZ623avc5o9wk9cHck04JmPenn0wkPecGecGsButG2p7ywZCW6u8qoYnlIpNzsnDR
	esDdyT/82FHYGu27O9KX15vdsMBtTozNJzWHnYW5nnA2
X-Received: by 2002:a05:6000:2503:b0:3a4:d048:125c with SMTP id ffacd0b85a97d-3a4d04813ffmr9814855f8f.35.1748344892296;
        Tue, 27 May 2025 04:21:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHerjQyTu06pnjsk/Y5G1dSbQUFhMGxFGP+lBATkWwRdfx8/UsyMG4cL4H76zCjaTbN/cEfOA==
X-Received: by 2002:a05:6000:2503:b0:3a4:d048:125c with SMTP id ffacd0b85a97d-3a4d04813ffmr9814818f8f.35.1748344891872;
        Tue, 27 May 2025 04:21:31 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4d53ce0b4sm7271868f8f.37.2025.05.27.04.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 04:21:31 -0700 (PDT)
Message-ID: <1a6e36a4-d280-495c-b39d-dbca3fb818e3@redhat.com>
Date: Tue, 27 May 2025 13:21:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/10] ram-block-attribute: Add more error handling
 during state changes
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-11-chenyi.qiang@intel.com>
 <c6013cd5-a202-4bd9-a181-0384ddc305ab@amd.com>
 <475254ca-6da3-4216-8e88-858d42724958@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <475254ca-6da3-4216-8e88-858d42724958@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


>>
>> If something went wrong... well, on my AMD machine this usually means
>> the fw is really unhappy and recovery is hardly possible and the machine
>> needs reboot. Probably stopping the VM would make more sense for now (or
>> stop the device so the user could save work from the VM, dunno).
> 
> My current plan (in next version) is to squash the mixture handling in
> previous patch to always run the code for "unexpected mix", and return
> error without rollback if it fails in kvm_convert_memory(), which will
> cause QEMU to quit. I think it can meet what you want.
> 
> As for the rollback handling, maybe keep it as an attached patch for
> future reference or just remove it.

probably best to remove it for now. The patch is in the mailing list 
archives for future reference :)

-- 
Cheers,

David / dhildenb


