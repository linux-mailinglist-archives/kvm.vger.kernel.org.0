Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF70818705F
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732095AbgCPQtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:49:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:42801 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731713AbgCPQs7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:48:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584377338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qJ0Dh7UwY9/JBhA8PMSrlRvaVmrVnOei0kD1wp+5Gzw=;
        b=gdL0v/ZWNl1KsPa6+NNqOiaNdOGQl8mZ3NArBj9l3A3pN7P3HCHlJkS0RvkCBpCxJZ2Whi
        mhUJeSPpijLKsyEg2Ws12XOvTHR9ZRnktKTpMW6CXzQQJGK8mNaJtQA+2AzfTu2kKmdWzH
        5Dm0NxjHEHV8DNm/G3JKz5jCm+JyYXs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-EYsjc02tMfGimbr1tjDO8A-1; Mon, 16 Mar 2020 12:39:39 -0400
X-MC-Unique: EYsjc02tMfGimbr1tjDO8A-1
Received: by mail-wm1-f71.google.com with SMTP id a13so6046194wme.7
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:39:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qJ0Dh7UwY9/JBhA8PMSrlRvaVmrVnOei0kD1wp+5Gzw=;
        b=gAT+FktMkOWBjMspgkf/aHSR689nETLGh3nLdXpSrlcy6nkMIWrwsPQWRmj/XOC14P
         DuAIbCVK3MxH4MURwAiAJMCJdx8+veA9lFYl+ltwxgJnT0Ck7c7TDOV4XLwOMxxumiPe
         GM8LfgKaQw+KojQZptBrbqb+K828JjEA1/SiQ58GaXie5NTQlXlkgGa+5IE7JVhlooP3
         Ipk8O/j8MIDY1/4YsOQrrkdT1vTobx58nBDKK0yh553Vi9Aebxgk4m+4YVKpsSKMfMaO
         3IzdIUjTJcacOkm9MzhKsKrg2gqjdhyFSs+vzZo3uOrDZZOemSV9sU6BtkHSJYNjO8Va
         4j1w==
X-Gm-Message-State: ANhLgQ2cPT2taXyOXoIxepRU9Wz6TgGMKCoR6ovS2PZ4xQLsuVfoU47d
        s4ij//p1kGPDDMKrEJ/t3apfpnaz3yDwtSd6fvn+NsfbJpnJhfK6P/9U3f2/XtDwzuM9I4+pJam
        6G6gR+mF4+lL3
X-Received: by 2002:adf:9307:: with SMTP id 7mr198225wro.171.1584376778103;
        Mon, 16 Mar 2020 09:39:38 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuKIEKBn5OJ0vxo6JLB1xdXH+6qMUW1IHmoNonOU1p4vkVSNPtTBCf6jdRflKCnpsGtQo6veg==
X-Received: by 2002:adf:9307:: with SMTP id 7mr198208wro.171.1584376777886;
        Mon, 16 Mar 2020 09:39:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7de8:5d90:2370:d1ac? ([2001:b07:6468:f312:7de8:5d90:2370:d1ac])
        by smtp.gmail.com with ESMTPSA id n10sm694062wro.14.2020.03.16.09.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 09:39:37 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: correct meaningless kvm_apicv_activated() check
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linmiaohe@huawei.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1584185480-3556-1-git-send-email-pbonzini@redhat.com>
 <878sk0n1g1.fsf@vitty.brq.redhat.com>
 <20200316152650.GD24267@linux.intel.com>
 <87zhcgl2xc.fsf@vitty.brq.redhat.com>
 <20200316155911.GE24267@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eb1037c8-fdb5-4f4c-4641-915c0e3d01bc@redhat.com>
Date:   Mon, 16 Mar 2020 17:39:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200316155911.GE24267@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/20 16:59, Sean Christopherson wrote:
>>>
>> 	if (!!old == !!new)
>> 		return;
>>
>> to make it clear we're converting them to 1/0 :-)
>
> All I can think of now is the Onion article regarding razor blades...
> 
> 	if (!!!!old == !!!!new)
> 		return;
> 

That would be !!!!!, but seriously I'll go with two.

(Thanks for giving me a chuckle, it's sorely needed these days).

Paolo

