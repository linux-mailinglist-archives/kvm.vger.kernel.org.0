Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADEF175842
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 11:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgCBKXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 05:23:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55938 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726654AbgCBKXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 05:23:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583144615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hsm7+SXojXahR9k86fUlVXW/t+sTQDzbnU/LvgDLQg8=;
        b=a9AF7xnQv45hZeKc8vKqNpSE0LOg0PSzqOz3Mqk3RLHKg2+Yt2z6Sqg0uDZT+qOgFhnyXJ
        8IuMUmfGyJNoyxgYpk//goS5feVodaXn5/zfkjXfzJ5NaDxCE3bcs4XO5GN5epN2Oy5DqH
        ZLATV6C9M3wkjWMIZ7pKZyLTo795IAw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-cSDqGmDoOd2ZngRr6IqfEQ-1; Mon, 02 Mar 2020 05:23:33 -0500
X-MC-Unique: cSDqGmDoOd2ZngRr6IqfEQ-1
Received: by mail-wr1-f72.google.com with SMTP id c6so5559396wrm.18
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 02:23:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hsm7+SXojXahR9k86fUlVXW/t+sTQDzbnU/LvgDLQg8=;
        b=FE90bErSBvYhf3alzRhD6/ZlAlA6edRs6hG7+g5oKk3PBYI/dPxbZDL4M2bhntdxBb
         HCyD2Tl3m49IesZzkrTsNu/+DBZSmQu/Pb1yujBvk1I+Xn1FvhrpwSAt1zoNW1OtRXnq
         Fv4SCw/+vmGfn9SLNqYQkw33kZmYuVsvKSlxd0tbfysAl9W4DRKnW5ivneHaLLqzTpg7
         YyBUSVQ7mKglsJbhNPywBfCw/Pc5lXRMaqoy9F+7RnP8OO2HCU9UjTFwLn6Ady3ENR4/
         loLlMQEFNTL3RunatKxb9um/5/z6A+YJz+n5hW5OCCIWP8IaJkVS0T4VEeThrwfJ12VS
         UAhg==
X-Gm-Message-State: APjAAAUrrMC5bMo7dimVTlHhr1pzCs16gc6kz6KdVaCcItK6yf8wLUMr
        rcnpPRkfVMvW6s6TrLGYJY64L04VjlcDk0dYIRU5w7lBs98IMb+B+p8O7ej0hhR9ytkrOYaA5IV
        rJcCd9778RFBe
X-Received: by 2002:a7b:c341:: with SMTP id l1mr17958195wmj.146.1583144612667;
        Mon, 02 Mar 2020 02:23:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqw/6CgOo7slBwK2Jq48CR/sL8IDhgk9uUVPGe7+KV+gGqp+oXZHi6n38upCjv+o4zQW8/XjaA==
X-Received: by 2002:a7b:c341:: with SMTP id l1mr17958183wmj.146.1583144612433;
        Mon, 02 Mar 2020 02:23:32 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id q12sm28942456wrg.71.2020.03.02.02.23.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 02:23:31 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: Fix dereference null cpufreq policy
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
References: <1583133336-7832-1-git-send-email-wanpengli@tencent.com>
 <ab51f6c9-a67d-0107-772a-7fe57a2319cf@redhat.com>
 <20200302081207.3kogqwxbkujqgc7z@vireshk-i7>
 <73a7db77-c4c7-029f-fd8a-080911fde41e@redhat.com>
 <20200302091416.od5ag3tokup4ha5m@vireshk-i7>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9edb91b2-de08-bb54-f87a-7ac95eceebbc@redhat.com>
Date:   Mon, 2 Mar 2020 11:23:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302091416.od5ag3tokup4ha5m@vireshk-i7>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/20 10:14, Viresh Kumar wrote:
>> For the same reason why we support kfree(NULL) and kobject_put(NULL)?
>
> These two helpers are used widely within kernel and many a times the
> resource is taken by one routine and dropped by another, and so
> someone needed to check if it can call the resource-free helper safely
> or not. IMO, that's not the case with cpufreq_cpu_put(). It is used
> mostly by the cpufreq core only and not too often by external
> entities. And even in that case we don't need to call
> cpufreq_cpu_put() from a different routine than the one which called
> cpufreq_cpu_get(). Like in your case. And so there is no need of an
> extra check to be made.
> 
> I don't think we need to support cpufreq_cpu_put(NULL), but if Rafael
> wants it to be supported, I won't object to it.

Actually I think kobject_put is wrong in supporting NULL, because
documentation explicitly says to use container_of and not place kobj as
the first item.  However, there is going to be some place in the kernel
that relies on it, so either removing the check or moving all kobjs to
the beginning of the struct is a windmill fight.  I'll just apply
Wanpeng's patch.

Paolo

