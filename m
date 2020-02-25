Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233B716E9A6
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 16:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbgBYPJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 10:09:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36635 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730455AbgBYPJy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 10:09:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582643393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gyTVilWU1NTnU+gwoh7gkkLPBvMQOx5tHU2YNNnkGmw=;
        b=K106GnymbFFM3Gsxd4rMCNE6iUTW6JRKlI3AAnHymi/roahZwLbJV6pbKXRgHxup6SmGNL
        I+UTP9bLGBKP/4qLf15MuS2/6zXm9aCSg5Rq2KTTGpa00Iuhtqy4rYdGMkBeR0ijtOKXx/
        bi9b8c8TE2q5H+epmcxuuPxqz7kBb+E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-XSHY9MBDPLaoCkPbr9YIiQ-1; Tue, 25 Feb 2020 10:09:51 -0500
X-MC-Unique: XSHY9MBDPLaoCkPbr9YIiQ-1
Received: by mail-wr1-f69.google.com with SMTP id 90so7443392wrq.6
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 07:09:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gyTVilWU1NTnU+gwoh7gkkLPBvMQOx5tHU2YNNnkGmw=;
        b=gl8Y8U/rabcCF8b7UhKrQplDPYW4IBKge6C9XlSwUmLTqsfTREDAacWPj3zfXGHHpe
         A6Juegyir+RdjN0BV7Uv4VpcEfawrxH3VLskIAvx/S8W+ch5/cCL8PIo9PRA6CyAdgCI
         wIB77c/HyHJUdO2ZkGOIc2kV/Q0ww+hMcCcLAx2wtiNeiTPY2MEwEdD1YtW8wcgn8Pw0
         j+CV9cNnB3EbatMY/ZHCJ2IrLLT7LsUjJwV7mfXaPeneGHjk9KgRWEs6HRuOsw3B/Tcw
         bZ8kxDQ7nweuluR6c5xxZjZFjyBPACI4712kfmYdAZb6ODIkzfqUNUnecUgTCvlsMsBo
         3W8g==
X-Gm-Message-State: APjAAAVkE/T2SyD06avp7VjdEiZsqwJRnxk5J5UA0WOxPOkTUjeGhtP8
        eR4mpyq+9rvozPnxFcZ2tzyxmmETK97h735wFlNnXLTUQ1IB8Vz7VGRETaul8JMWwNTpT9WUhgK
        gSupFnMf5zJNc
X-Received: by 2002:a1c:7215:: with SMTP id n21mr6081882wmc.154.1582643390188;
        Tue, 25 Feb 2020 07:09:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqy/Law1OzKYUVZt2uhlIn4w3N2hJc84Pk770kM8VFpLZmbXFBnuvyrx0KYtY8KMSMKKFgwm0w==
X-Received: by 2002:a1c:7215:: with SMTP id n21mr6081868wmc.154.1582643389949;
        Tue, 25 Feb 2020 07:09:49 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z19sm4455606wmi.43.2020.02.25.07.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 07:09:49 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/61] KVM: x86: Refactor loop around do_cpuid_func() to separate helper
In-Reply-To: <04fb4fe9-017a-dcbb-6f18-0f6fd970bc99@redhat.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-3-sean.j.christopherson@intel.com> <87sgjng3ru.fsf@vitty.brq.redhat.com> <20200207195301.GM2401@linux.intel.com> <04fb4fe9-017a-dcbb-6f18-0f6fd970bc99@redhat.com>
Date:   Tue, 25 Feb 2020 16:09:48 +0100
Message-ID: <87zhd6k8jn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 07/02/20 20:53, Sean Christopherson wrote:
>> 
>>> 2) Return -EINVAL instead.
>> I agree that it _should_ be -EINVAL, but I just don't think it's worth
>> the possibility of breaking (stupid) userspace that was doing something
>> like:
>> 
>> 	for (i = 0; i < max_cpuid_size; i++) {
>> 		cpuid.nent = i;
>> 
>> 		r = ioctl(fd, KVM_GET_SUPPORTED_CPUID, &cpuid);
>> 		if (!r || r != -E2BIG)
>> 			break;
>> 	}
>> 
>
> Apart from the stupidity of the above case, why would it be EINVAL?
>

I suggested -EINVAL because issuing KVM_GET_SUPPORTED_CPUID with nent=0
looks more like a completely invalid input and not 'too many
entries'(-E2BIG) to me (but -E2BIG is already there, let's keep it, it's
not a big deal).

> I can do the change to drop the initializer when applying.

We're agreed with Sean on a few cosmetic changes in other patches of
this series, wait for v2)

-- 
Vitaly

