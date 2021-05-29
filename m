Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04487394B99
	for <lists+kvm@lfdr.de>; Sat, 29 May 2021 12:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhE2KV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 May 2021 06:21:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229575AbhE2KV6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 29 May 2021 06:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622283620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rAj07ZCK5KDIXiVxu56SXtmyW8X/Uzs85mSHd9xMkE0=;
        b=Dy0fz1clsorLO0ZRSOFo+6ye4CNaA9v6MbaCAlidURiwERVAHQCEK4xYrm1hsyZPDF9xNv
        WLVAvRusEvRTjs/3Av9w4aqEMlNfEz4Ymi98Rlqw52eS/mO9brnACjm6pt3BjMZ7/gBVwk
        W9kUzPP0uoEWDitLdkUlbS7R0Pd8i5k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386--hc6BkpUOnKe6wemcU7arA-1; Sat, 29 May 2021 06:20:19 -0400
X-MC-Unique: -hc6BkpUOnKe6wemcU7arA-1
Received: by mail-wm1-f70.google.com with SMTP id v20-20020a05600c2154b029019a6368bfe4so26305wml.2
        for <kvm@vger.kernel.org>; Sat, 29 May 2021 03:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rAj07ZCK5KDIXiVxu56SXtmyW8X/Uzs85mSHd9xMkE0=;
        b=B8jytfHVdrlX+1MsSA67YaC7dPIa3zwdpIDO2u1YjNoG9JG0QOsjLragXEnRA7G7n/
         VT+ZjMNLLN4YH1g7sPlKud7bcpdX5dTWs4lD7vu+yIzpgz46ssqb2DYgVovjYbj4MTa0
         aam9XcwbhjyCPHoRrG8P1B6gJ3m0CgA0MAsCI7gDuUFPsntrzjVWA+817+gijghVT6M8
         abR8YutyeLRB4v52qfhAW1LiojK3xLycsCZktSjWMxWu4cu+2iUQ7j5Ls/aoA0PN+Z2j
         wsEEKPLdlwU4zibJLtMyWjTI9qcxRmzxCHcTUIVtNdJC/ZulmBT2oWLcaDIMwC4aU5n9
         R6sQ==
X-Gm-Message-State: AOAM531eu4oVZrxcFEVIxLTUHTjhtjG+m8U0TKNgV0vqw6PWInpT8OGy
        9f+iQ+uc79Ik/zuGAnKwT6j19HdPD64NFDDB+1S0z306DGSfXC80JS7ejZSiWUfNJqWsR7j8Quo
        fNIXm5aiwoXRYzTrZluafs5b51n+F04EBHuu/6SF/ov25n9is518NwAeQtLfsGZaL
X-Received: by 2002:a1c:4e0b:: with SMTP id g11mr12374218wmh.3.1622283617847;
        Sat, 29 May 2021 03:20:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKTruQR1WsSRzgozbspnFpcPccqWYRWEgR4ui7XPhdvKvdRXAA+HovZdppQC/XVpJjPue7WQ==
X-Received: by 2002:a1c:4e0b:: with SMTP id g11mr12374199wmh.3.1622283617636;
        Sat, 29 May 2021 03:20:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id 92sm7981736wrp.88.2021.05.29.03.20.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 May 2021 03:20:17 -0700 (PDT)
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210528191134.3740950-1-pbonzini@redhat.com>
 <285623f6-52e4-7f8d-fab6-0476a00af68b@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] selftests: kvm: fix overlapping addresses in
 memslot_perf_test
Message-ID: <fc41bfc4-949f-03c5-3b20-2c1563ad7f62@redhat.com>
Date:   Sat, 29 May 2021 12:20:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <285623f6-52e4-7f8d-fab6-0476a00af68b@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/21 21:51, Maciej S. Szmigiero wrote:
> On 28.05.2021 21:11, Paolo Bonzini wrote:
>> The memory that is allocated in vm_create is already mapped close to
>> GPA 0, because test_execute passes the requested memory to
>> prepare_vm.  This causes overlapping memory regions and the
>> test crashes.  For simplicity just move MEM_GPA higher.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> I am not sure that I understand the issue correctly, is vm_create_default()
> already reserving low GPAs (around 0x10000000) on some arches or run
> environments?

It maps the number of pages you pass in the second argument, see
vm_create.

   if (phy_pages != 0)
     vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
                                 0, 0, phy_pages, 0);

In this case:

   data->vm = vm_create_default(VCPU_ID, mempages, guest_code);

called here:

   if (!prepare_vm(data, nslots, maxslots, tdata->guest_code,
                   mem_size, slot_runtime)) {

where mempages is mem_size, which is declared as:

         uint64_t mem_size = tdata->mem_size ? : MEM_SIZE_PAGES;

but actually a better fix is just to pass a small fixed value (e.g. 
1024) to vm_create_default, since all other regions are added by hand.

Paolo

