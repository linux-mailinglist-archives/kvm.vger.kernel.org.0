Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E45D190237
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 00:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgCWXq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 19:46:59 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52322 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727011AbgCWXq7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 19:46:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585007218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tSyvbG0jRJgoukd8LcpY1HnHy+eiw9SXpaYRxe+R7cU=;
        b=U8EsLZBzxkOeC+eNCMRZderVA7HFHYE9n6DVSwPywY1bBEXwwQS7n3qI/zdNBPXqpfL32c
        Zp4mHc8s+iZ/HV6LiY9Ax2tiFbSY/6szRj4txZj0gO3YxrrnTCfxH2t0l9/mTwY/amNV2T
        8gp84P5CPl1px9jxEYz0fIxJUDKEaUs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-SiLX-fcpPG6GL-F8TX3JIA-1; Mon, 23 Mar 2020 19:46:56 -0400
X-MC-Unique: SiLX-fcpPG6GL-F8TX3JIA-1
Received: by mail-wm1-f70.google.com with SMTP id g26so632875wmk.6
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 16:46:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tSyvbG0jRJgoukd8LcpY1HnHy+eiw9SXpaYRxe+R7cU=;
        b=B/Hi/d5nmvfNBASzP6iWGZPFbcsccKMEusVTF+Y0rLtUKzGE6UrvBy7g4M6ByqO1E9
         VEY819YzFbprXY1jj2VWjn6GgHXE+YQyM9XyxdjJ9p4uCdW2kG5/UKIpC3lOhKbqSlbo
         INHETxAle8Xitua6NRq1voLBPlPbwODcn1f8ePo3P+Snh9YImq9x/s7TzCyF6Am6Y8MV
         9coCmATslzEoyUhz8rRcVOc+QPDgFzph1fXyWzAClJj/tcDn1RMpKW6TtxDNWwESWZrP
         mW3h++IWRGgg0dbmtG6svgRUl0ao6RIin+4fvTMnYwTnAM+7gjBAVNp4HTHcfaANGEvb
         t6ow==
X-Gm-Message-State: ANhLgQ1D3Qbh4JO+aVMKaNCOBhzOFjcv6bWw+yXtXqK2hmYmBy5H3e5l
        Q6Dr1PFFJtRNITjUTYjMsQgyo991EoKHv8RmHhEZCccgEr9rUPvrnIzaxDuUlG8l8KhzEEZxf8M
        xZWIKQPdZkPgN
X-Received: by 2002:adf:f7cb:: with SMTP id a11mr23524109wrq.79.1585007215284;
        Mon, 23 Mar 2020 16:46:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvZlGwBX5VRkEHJbRyonc3teesA7wqRwm+dtkXJfD8MCIKgHyy5njk4cisOjUOk59hS+iM0yg==
X-Received: by 2002:adf:f7cb:: with SMTP id a11mr23524089wrq.79.1585007214986;
        Mon, 23 Mar 2020 16:46:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id k9sm26815366wrd.74.2020.03.23.16.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 16:46:54 -0700 (PDT)
Subject: Re: [PATCH v3 02/37] KVM: nVMX: Validate the EPTP when emulating
 INVEPT(EXTENT_CONTEXT)
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-3-sean.j.christopherson@intel.com>
 <871rpj9lay.fsf@vitty.brq.redhat.com>
 <20200323154555.GH28711@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b6fdc5db-2d50-5e4d-cfe8-4d4624c046e0@redhat.com>
Date:   Tue, 24 Mar 2020 00:46:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200323154555.GH28711@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/20 16:45, Sean Christopherson wrote:
>> My question, however, transforms into "would it
>> make sense to introduce nested_vmx_fail() implementing the logic from
>> SDM:
>>
>> VMfail(ErrorNumber):
>> 	IF VMCS pointer is valid
>> 		THEN VMfailValid(ErrorNumber);
>> 	ELSE VMfailInvalid;
>> 	FI;
>>
> Hmm, I wouldn't be opposed to such a wrapper.  It would pair with
> nested_vmx_succeed().
> 

Neither would I.

Paolo

