Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CF63BBA8E
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 11:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhGEJ4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 05:56:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230394AbhGEJ43 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 05:56:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625478832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEJ5Li45XESMm3lquznvdm6Bm6pYhAxf+/pVPbM0AfY=;
        b=CcOosoZUt9Nle/UNC7QYBWbFdRGe04CO9yl17S9X99fTvOb6/zulE8RhO55WhfdtJRON4K
        E88CpTyGcG1o/4a6JVF+eJ4TxE2Sr5sMHXk4p1fjNP1I0D+Zvn/7DS54j+xl8PfoCQNDOi
        pBqhU3UNCdcw3mBytVVF0PdvcVNgLy8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-2-USEZwxP92NCXH5zpK_8Q-1; Mon, 05 Jul 2021 05:53:51 -0400
X-MC-Unique: 2-USEZwxP92NCXH5zpK_8Q-1
Received: by mail-wm1-f71.google.com with SMTP id j184-20020a1c23c10000b0290202b9842bf6so822955wmj.6
        for <kvm@vger.kernel.org>; Mon, 05 Jul 2021 02:53:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cEJ5Li45XESMm3lquznvdm6Bm6pYhAxf+/pVPbM0AfY=;
        b=rKdQv/jvzerD75ekc/pKft/f+HiUT9zwktAM9f+kZkkxAAMsEFwsYSCSl08/EHM6Y1
         UOKNWP6z25DZRKR7YlkLcEreNAZgXWVo5gFFkURY6X/8SFQEFdu0miUOtG8Ql7rs10mk
         7nEMxhPqQMOP1Pmm901XzeTC197s1ZBviw4wuWO8RlN4Ql4M/oSj22NuRITlvp8Hsokn
         wkJXjBZWtCPWVslB+aKFDRMeKZHWl+5c5pcELLNMI5sMbEqswRD5zvBiMGyB/nWnFc0r
         IVVhU4VQU7fb1WMGP7QyBPWA2bzo/5x6VynirkhgrojY3GsNIPrDMteycptjOkC4IM8D
         RXtA==
X-Gm-Message-State: AOAM533qimNmC6XqB7I5S0TeTXJXPY7TO2n79R6xfNlKj+nO972b8fsb
        g71PPKfcZc2kbWuWnQqGpImvx/kxdd67bQOgMqsqbqYQFhZ9GPAiK4F3nA5mJUY2xbX0RTl3iWH
        I6rb6YEP5M2VO
X-Received: by 2002:a05:600c:17cf:: with SMTP id y15mr8575671wmo.19.1625478830624;
        Mon, 05 Jul 2021 02:53:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVKvTYCTHnqRPiw054ae5I1sl+RnTYb5mBH2RY7OFB6ReyqeoKEmfARyjwvJSqURU6GZ6Byg==
X-Received: by 2002:a05:600c:17cf:: with SMTP id y15mr8575654wmo.19.1625478830445;
        Mon, 05 Jul 2021 02:53:50 -0700 (PDT)
Received: from ?IPv6:2003:d8:2f0a:7f00:fad7:3bc9:69d:31f? (p200300d82f0a7f00fad73bc9069d031f.dip0.t-ipconnect.de. [2003:d8:2f0a:7f00:fad7:3bc9:69d:31f])
        by smtp.gmail.com with ESMTPSA id j37sm9279000wms.37.2021.07.05.02.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 02:53:50 -0700 (PDT)
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210701153853.33063-1-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH/RFC] KVM: selftests: introduce P44V64 for z196 and EC12
Message-ID: <bc025447-db53-5472-76b0-0cfa2c3ae996@redhat.com>
Date:   Mon, 5 Jul 2021 11:53:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701153853.33063-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.07.21 17:38, Christian Borntraeger wrote:
> Older machines likes z196 and zEC12 do only support 44 bits of physical
> addresses. Make this the default and check via IBC if we are on a later
> machine. We then add P47V64 as an additional model.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: 1bc603af73dd ("KVM: selftests: introduce P47V64 for s390x")

[...]

> +#ifdef __s390x__
> +	{
> +		int kvm_fd, vm_fd;
> +		struct kvm_s390_vm_cpu_processor info;
> +
> +		kvm_fd = open_kvm_dev_path_or_exit();
> +		vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
> +		kvm_device_access(vm_fd, KVM_S390_VM_CPU_MODEL,
> +				  KVM_S390_VM_CPU_PROCESSOR, &info, false);

Can we always assume to run on a kernel where this won't fail?

> +		close(vm_fd);
> +		close(kvm_fd);
> +		/* Starting with z13 we have 47bits of physical address */

This matches the definition in the QEMU cpu models.

> +		if (info.ibc >= 0x30)
> +			guest_mode_append(VM_MODE_P47V64_4K, true, true);
> +	}
> +#endif


In general, LGTM


-- 
Thanks,

David / dhildenb

