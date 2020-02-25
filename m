Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F418116C415
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbgBYOiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:38:01 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23590 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729436AbgBYOiB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 09:38:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582641480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MMkMT41Ew2lYqvAVHcg6d6gwui9XO+kqAXnNWxZsaWg=;
        b=gFwe1k02HrtxMfpBpC2o0cFgEB2nK8vvknrliDrlLoUp/UiFV86ygdnkXweZc6MBmabPCa
        NEgdVbG79uvOiozH0thif85R1+HMWDS0PvhvLKFgl6PS6fnlI0/z3uGbH3oVJSpZmQ0c7J
        L5Q0dNp3RsvdSPwmpkjhambof6eE+eU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-ftkSkaQNON2mc_XqiKfx7A-1; Tue, 25 Feb 2020 09:37:58 -0500
X-MC-Unique: ftkSkaQNON2mc_XqiKfx7A-1
Received: by mail-wm1-f70.google.com with SMTP id n17so1119396wmk.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 06:37:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MMkMT41Ew2lYqvAVHcg6d6gwui9XO+kqAXnNWxZsaWg=;
        b=jyHyvYbvC3oMxiYuWfQAFSe6jSBBeiWqjbD56W9wMscpkgf1MVL6LQpPmow201Qt9B
         uLp3RjXjTElhL8TXR5gfcpim8kU6lj7ifdNgsvooFdOANC0Pf/JDaGXU7K7HkemAZW2x
         8uI3duzxlX2yMMuUsI0kotaU0yTYck+pOWtfg6O8W7E1atGieqhh/qP9fD/FcbMgsv8s
         gK6TxpvQKbQ5QdtkucjqMVodtw02LTOWqOqE0hwxt9fNh2ror6oZPFtEr18HG4c+j79M
         UjIgDpk5R7r7p29PBPdXyi7is6P3C04EC0qNBZbwWTYRJWZUPtp79CAUoHqwkvz2P0LU
         FF8Q==
X-Gm-Message-State: APjAAAU9WmKNq+2b0FAI77VUX7mR3dwmP3xOqeZiN0n+OKDNR8sU5zlJ
        yr7wbTeON9G4IuvRlxOUdy4j/QnnZEdTswA7jrk+T1HHJ2hYCANJ6W8xnZtC19335N45SdcqZGz
        xV1eiT4FMQFZx
X-Received: by 2002:a5d:674d:: with SMTP id l13mr72035869wrw.11.1582641477572;
        Tue, 25 Feb 2020 06:37:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqyb1N/WwmYJ6393LEGUUxwEctjfX/NmXku6SX1zknILjB/nDw9XsgbBJwAP0GuDgbhVG0nT+g==
X-Received: by 2002:a5d:674d:: with SMTP id l13mr72035852wrw.11.1582641477374;
        Tue, 25 Feb 2020 06:37:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id p12sm24467412wrx.10.2020.02.25.06.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:37:56 -0800 (PST)
Subject: Re: [PATCH 02/61] KVM: x86: Refactor loop around do_cpuid_func() to
 separate helper
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-3-sean.j.christopherson@intel.com>
 <87sgjng3ru.fsf@vitty.brq.redhat.com> <20200207195301.GM2401@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <04fb4fe9-017a-dcbb-6f18-0f6fd970bc99@redhat.com>
Date:   Tue, 25 Feb 2020 15:37:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200207195301.GM2401@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 20:53, Sean Christopherson wrote:
> 
>> 2) Return -EINVAL instead.
> I agree that it _should_ be -EINVAL, but I just don't think it's worth
> the possibility of breaking (stupid) userspace that was doing something
> like:
> 
> 	for (i = 0; i < max_cpuid_size; i++) {
> 		cpuid.nent = i;
> 
> 		r = ioctl(fd, KVM_GET_SUPPORTED_CPUID, &cpuid);
> 		if (!r || r != -E2BIG)
> 			break;
> 	}
> 

Apart from the stupidity of the above case, why would it be EINVAL?

I can do the change to drop the initializer when applying.

Paolo

