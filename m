Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409F1414752
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 13:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbhIVLLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 07:11:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42226 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235137AbhIVLLd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 07:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632309002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YS03NSztDx6+3yWs4FZ7oPCvTjWDiA2IA0tO6v60nlk=;
        b=h2zWzmFzxjFY+A2/T8sQYcsmpSxtX9N85N7MFP8/jcFTWaMHEzcTLt3V1KnxY0ijEClwp5
        VEuZCc0Cwnw9JnWXsAzCRIYPER6KwDB+TcZTRQ0PatuwSeYEpTaqs/xlsucfUiRFYIG5Y4
        3wPMaKZ7TSCHEuPjq9CqsWitqIJ04n0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-bkutc9thOP28YEJSxQRwbQ-1; Wed, 22 Sep 2021 07:10:01 -0400
X-MC-Unique: bkutc9thOP28YEJSxQRwbQ-1
Received: by mail-wr1-f69.google.com with SMTP id v1-20020adfc401000000b0015e11f71e65so1843185wrf.2
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 04:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YS03NSztDx6+3yWs4FZ7oPCvTjWDiA2IA0tO6v60nlk=;
        b=8KfGVvHC/LmZ+EhoHQYXkaKq00FWc5yFpQnra0dEqOqxQXvix/5iYlLWcAV8AHPYOV
         7NwbPigo+7E9Ky1x1K4eacDzPgGpqiS3lZ4RbRJUfz4qa/bUq0S88gCJrRajX0m4Vx5K
         oY0z58gkhKXlpvqeaPuaRFwefCwaQdeM5Y+DgoiyZvTIBuVIGbQQj3dQ54xXqPFk9VPH
         +mTxtUL/JWrJ6zI4ipq0QrNsmvmgqr4uHgLuq3/EFABvKKg8/Zk8KctVKHbFYeT176Mv
         rF29NCpx3eYrZ7lMW8X6+4vgtzAvDy3+vuaa9H4puEW0aCOVHtP6NwX9NSrUH89g9HgO
         sgXQ==
X-Gm-Message-State: AOAM531zyVYplgxLksr/fq5zfkN5ogXiQwjPn/A4Pa1JZxRbdcBnq9bW
        yGbs7WgaZwh6ZbsDOwv6MCTyZvrzAm9s7wOyeMqQEJoX13vzidc45cHGae3pV4tnUEtAm1bkl5Z
        j+BW6fWM7TRly
X-Received: by 2002:a5d:59a4:: with SMTP id p4mr41446916wrr.149.1632309000281;
        Wed, 22 Sep 2021 04:10:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8ZRFjuq4a9f9AS4mittGl/vxMMCPLoiI+OhUI8ezwF8Dy49QONpD4NRH1x40HOJAalUjMGw==
X-Received: by 2002:a5d:59a4:: with SMTP id p4mr41446884wrr.149.1632308999970;
        Wed, 22 Sep 2021 04:09:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c4sm1932703wrt.23.2021.09.22.04.09.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 04:09:59 -0700 (PDT)
Subject: Re: [PATCH 3/3] KVM: selftests: Fix dirty bitmap offset calculation
To:     Andrew Jones <drjones@redhat.com>, Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>, kvm <kvm@vger.kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>
References: <20210915213034.1613552-1-dmatlack@google.com>
 <20210915213034.1613552-4-dmatlack@google.com>
 <CANgfPd_WkrdXJ3qYmv_DKLbKDsNs8KJK4i9sX3+kR_cwNmbJ_w@mail.gmail.com>
 <20210916084922.x33twpy74auxojrk@gator.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <11b4e1ba-e9cd-8bc7-4c5d-a7b79611c20f@redhat.com>
Date:   Wed, 22 Sep 2021 13:09:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210916084922.x33twpy74auxojrk@gator.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/21 10:49, Andrew Jones wrote:
>> I was a little confused initially because we're allocating only one
>> dirty bitmap in userspace even when we have multiple slots, but that's
>> not a problem.
> It's also confusing to me. Wouldn't it be better to create a bitmap per
> slot? I think the new constraint that host mem must be a multiple of 64
> is unfortunate.

Yeah, I wouldn't mind if someone took a look at that.  Also because 
anyway this patch doesn't apply to master right now, I've queued 1-2 only.

Paolo

