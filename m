Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C537033C42E
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 18:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235861AbhCORaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 13:30:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22245 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229854AbhCORaF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 13:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615829404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=49lfJRWKKEBpIbOKRaFlvzL+cvb95zX4ZYi+xzBTlg4=;
        b=OYhYzzqfCUPFjQf+qlJ1FIPwPQybjQQ1fhYbDLf41oKzbZz3p6h0uhy7BAisg5oHHxaaRC
        6Fx9dzPhE93BeGS8MudO5qJyVf+0DI+rzxTS2Atvyy57PrfA38Y0m8uvMeP7kfdgVZm0x6
        lZ0aCBn6Bp2IaZzoPp+pWgx5epmTGtY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-lAlWTQKcMpi6kLVGO8zZrw-1; Mon, 15 Mar 2021 13:30:03 -0400
X-MC-Unique: lAlWTQKcMpi6kLVGO8zZrw-1
Received: by mail-ed1-f72.google.com with SMTP id v27so16284686edx.1
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 10:30:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=49lfJRWKKEBpIbOKRaFlvzL+cvb95zX4ZYi+xzBTlg4=;
        b=RsVQWlS8bvAmU0qNrNEZOWDj+Up2STRmZ/jlVrt6IWRtUCCJsW6vCHeVfizWg0H8WM
         GkTPTN2Wv1iAIkohAKLJS9moOC+RZ3uq0F+a46KrKhouKHgGiB+iBPPVoEAd6MsLQSWC
         R7me4O/2BuZ79Wbalj9qWFBoc5C9PAvtEKWnnOTBYvlKYwekXJ7x8YC/IlIoKSvejFws
         U7Xl6hxzD7jHg3oJuUP6FEWwiydb2ZPACmi2wtJhwgNx74NXhZhQakwCziCFyg6x6Csk
         2NN0BW5cILiJIJymBBwLYT+/UlFKXz77Vbb8cm8duVSWeIqJLFQzS2VLHF5NqBjJc8lz
         86Xw==
X-Gm-Message-State: AOAM53362Y2h6Q4JPeRUQ2Jk4B6nmlUM3WnlSK7gYBgGp8aMsmJvMo7Q
        ga7fR+Fnz0ppp/WW2hW6Gi7mpOf6yffoCPw97NYWl0ebkZTzChJN9upqaXAyzeTl4a3esh9vkgX
        fQFdT5Sz/Xxk+
X-Received: by 2002:a17:907:d10:: with SMTP id gn16mr14108905ejc.304.1615829401650;
        Mon, 15 Mar 2021 10:30:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWcyiDNAeGBQsoY9WcHB0zHRZpCln4m3pBXhyKhHaDLYYLjNpzoNz75Ddz7iz/ieveaKhzcw==
X-Received: by 2002:a17:907:d10:: with SMTP id gn16mr14108876ejc.304.1615829401480;
        Mon, 15 Mar 2021 10:30:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id y17sm7810001ejf.116.2021.03.15.10.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 10:30:00 -0700 (PDT)
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
To:     Tobin Feldman-Fitzthum <tobin@linux.ibm.com>, natet@google.com
Cc:     Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com, rientjes@google.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>
References: <20210224085915.28751-1-natet@google.com>
 <7829472d-741c-1057-c61f-321fcfb5bdcd@linux.ibm.com>
 <35dde628-f1a8-c3bf-9c7d-7789166b0ee1@redhat.com>
 <adb84c91-1651-94b6-0084-f86296e96530@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <69004ca1-93a7-6a7e-b349-05f857756334@redhat.com>
Date:   Mon, 15 Mar 2021 18:29:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <adb84c91-1651-94b6-0084-f86296e96530@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/03/21 18:05, Tobin Feldman-Fitzthum wrote:
>>
>> I can answer this part.  I think this will actually be simpler than 
>> with auxiliary vCPUs.  There will be a separate pair of VM+vCPU file 
>> descriptors within the same QEMU process, and some code to set up the 
>> memory map using KVM_SET_USER_MEMORY_REGION.
>>
>> However, the code to run this VM will be very small as the VM does not 
>> have to do MMIO, interrupts, live migration (of itself), etc.  It just 
>> starts up and communicates with QEMU using a mailbox at a 
>> predetermined address.
> 
> We've been starting up our Migration Handler via OVMF. I'm not sure if 
> this would work with a minimal setup in QEMU.

Yeah, the way to start up the migration handler would be completely 
different, you'd have to do so very early (probably SEC).

Paolo

