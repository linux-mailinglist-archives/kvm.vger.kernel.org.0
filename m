Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2778A2B2B4C
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 05:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgKNEQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 23:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgKNEQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 23:16:36 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88540C0613D1
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 20:16:36 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id h6so8684996pgk.4
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 20:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A9pg18TbAKGWThbDZV/lSnw6ECunYCQj34w2OxbsD28=;
        b=PF9ft6fMnlNP/6Zsbu25kflNnmBKfJOO/H4rjrJ+ql33V44LVFpAQuQmFtilVhoNGy
         Y9ZrE3vibDv+WkakZbF/0ztWkgwwMeb61WAEri4qAVRQx9t+j+QtLF3SwSbU92l005We
         sDSN4NvszMB3KMpUcgrPvhc81wtKtX7FQllX/xYsrejaiM2AiGmJFBU5MuS1Mqpgoy9/
         WuBtiYmAeihC5b5j2t+sfKl50CluaCCsjKzYiOPXOz/p3MjL4IctEhyHyX/DbOlO45wl
         xj0iaBbrOfI0gI4BiCwzg5d3EgRXQ79eVt3vzi2h9kdepcB6fZFSPQ/Y6SyUS+NB3shM
         djsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A9pg18TbAKGWThbDZV/lSnw6ECunYCQj34w2OxbsD28=;
        b=VlpQRvivNax0TWPlINMgliGaoLeeWHRNyyeTakeqYIiMyyAPQ2180F8cGJ8R7wiADI
         oqsJvRT43WXJSHmKltqLZFIhZl3rnSXZV+hjSGyggVDaxKC7duqihxXhSQrf7H52HouJ
         IDl0XqSZzxD9P4OtX4VG88FCJhLiKMwLE+tKCMq1a/Kkg3Od5CYxNkqpLF9RipzZnx/o
         jRbXbFosOAIo45YaCMj8J9leDCsas5BdDKszb4aDFSMlmycfE7RF/1/ZvZi6T5yY9yC8
         EL/MuEyeZom5H93xvEfWgLI9qJ9p6wRPWrB9EWozb1GHMmybfdeaW3620UoLpyG5oNDQ
         rKwg==
X-Gm-Message-State: AOAM533Je4lAjC5EobP/WU4Kx+Cs0p0ZIhlAn+Y96vPA4wHlgC/6Z7m+
        r+DhJZoHipD8tRW5cNEREtJukQ==
X-Google-Smtp-Source: ABdhPJxdtnYpfXnid7lmGwIEALBV3sGEAC/R8OHL5K5BnBiuttodEwRQNcVdi17epQTlF0c/PWefpw==
X-Received: by 2002:a62:768e:0:b029:18a:d54d:3921 with SMTP id r136-20020a62768e0000b029018ad54d3921mr4922461pfc.31.1605327396070;
        Fri, 13 Nov 2020 20:16:36 -0800 (PST)
Received: from [192.168.10.85] (124-171-134-245.dyn.iinet.net.au. [124.171.134.245])
        by smtp.gmail.com with UTF8SMTPSA id 3sm11338509pfv.92.2020.11.13.20.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 20:16:35 -0800 (PST)
Subject: Re: [PATCH kernel] vfio_pci_nvlink2: Do not attempt NPU2 setup on old
 P8's NPU
To:     Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Leonardo Augusto Guimaraes Garcia <lagarcia@br.ibm.com>
References: <20201113050632.74124-1-aik@ozlabs.ru>
 <0b8ceab2-e304-809f-be3c-512b28b25852@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <1f2be6b0-d53a-aa58-9c4f-d55a6a5b1c79@ozlabs.ru>
Date:   Sat, 14 Nov 2020 15:16:30 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:83.0) Gecko/20100101
 Thunderbird/83.0
MIME-Version: 1.0
In-Reply-To: <0b8ceab2-e304-809f-be3c-512b28b25852@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13/11/2020 16:30, Andrew Donnellan wrote:
> On 13/11/20 4:06 pm, Alexey Kardashevskiy wrote:
>> We execute certain NPU2 setup code (such as mapping an LPID to a device
>> in NPU2) unconditionally if an Nvlink bridge is detected. However this
>> cannot succeed on P8+ machines as the init helpers return an error other
>> than ENODEV which means the device is there is and setup failed so
>> vfio_pci_enable() fails and pass through is not possible.
>>
>> This changes the two NPU2 related init helpers to return -ENODEV if
>> there is no "memory-region" device tree property as this is
>> the distinction between NPU and NPU2.
>>
>> Fixes: 7f92891778df ("vfio_pci: Add NVIDIA GV100GL [Tesla V100 SXM2] 
>> subdriver")
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> Should this be Cc: stable?

This depends on whether P8+ + NVLink was ever a  product (hi Leonardo) 
and had actual customers who still rely on upstream kernels to work as 
after many years only the last week I heard form some Redhat test 
engineer that it does not work. May be cc: stable...


-- 
Alexey
