Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B4E27EFC1
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 18:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgI3QzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 12:55:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3QzZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 12:55:25 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601484924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B8EZjCnkyFc1cMjpMH0gu6rS7aovGZS/4aH0BOoM7mI=;
        b=JxD9uODF6ehguRl5nBuD3w8SP2h3SmXuFAdbxURdR+Fu+Qb2IE+fHtTCwq7HNiw/AVw+yR
        YCi+e90OPh/WQkqC6OuAPj/xDA2aMoEkC7h2FmL7EeckZYn6R+v2SXGeWy+yEWpFwaDkWs
        frUTYJ6YrMryqoWJyXO6CBBbSsddR3o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-5UZSkqYZN5KD839hDaBPqw-1; Wed, 30 Sep 2020 12:55:21 -0400
X-MC-Unique: 5UZSkqYZN5KD839hDaBPqw-1
Received: by mail-wm1-f69.google.com with SMTP id l15so57106wmh.9
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 09:55:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B8EZjCnkyFc1cMjpMH0gu6rS7aovGZS/4aH0BOoM7mI=;
        b=tTT8MKqiRDZ5IyC3O6N4GzzwPB2W9zeeJLz/eGViWcLm6AbZ8JdLR5DXBFa97RFhSa
         8Z2Nw0j6G4p6a7YJgRzGeX+owmMlIV17JBN6Ruk1H6vh2+AA3iSVS/CZSVdTHhfakg5Z
         748B5qj551HywrvSDHazBCnFoVJg+vbDadNFjqE836yNR0v1BJMT5UY7xAZec5j6JYzk
         XGxztjKgnHMveaD7+7PGKIBPCEcPJThLF6M04RGstwrteIBv12Styx9zmX1jmJZ+mh+x
         5tu/nh4wnOq7zOkXkVYM0sNlgGZpRwZjN0XhSArqzxXDXRhze7AXN03u+U4A9OdWkahS
         QDnw==
X-Gm-Message-State: AOAM532i+KiVxY/1vRJKr6p7AQ3aaFvMyksXwJHRE9z0bs/V64vpTYhw
        +KTJCXoHqh23iMzLElTbwGQROK0CmJG5N0J6z/2uMO40UFFOS6Jme931USWjxXnFRJuYQHLawI7
        hgI2hThegJOhT
X-Received: by 2002:a1c:b703:: with SMTP id h3mr3915211wmf.131.1601484920443;
        Wed, 30 Sep 2020 09:55:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpqMWMCf8rNOLTb8uVhzIBXgspOLuTByal+8MYiknPL2xBZbFeEcfJ4nRe0PKpiG562hHDqw==
X-Received: by 2002:a1c:b703:: with SMTP id h3mr3915176wmf.131.1601484920155;
        Wed, 30 Sep 2020 09:55:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:75e3:aaa7:77d6:f4e4? ([2001:b07:6468:f312:75e3:aaa7:77d6:f4e4])
        by smtp.gmail.com with ESMTPSA id h4sm4746659wrm.54.2020.09.30.09.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 09:55:19 -0700 (PDT)
Subject: Re: [PATCH 10/22] kvm: mmu: Add TDP MMU PF handler
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-11-bgardon@google.com>
 <20200930163740.GD32672@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4ee2a2cf-625b-3c10-a7da-75677ea37aa3@redhat.com>
Date:   Wed, 30 Sep 2020 18:55:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200930163740.GD32672@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/20 18:37, Sean Christopherson wrote:
>> +
>> +	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
>> +		return RET_PF_RETRY;
> I feel like we should kill off these silly WARNs in the existing code instead
> of adding more.  If they actually fired, I'm pretty sure that they would
> continue firing and spamming the kernel log until the VM is killed as I don't
> see how restarting the guest will magically fix anything.

This is true, but I think it's better to be defensive.  They're
certainly all candidates for KVM_BUG_ON.

Paolo

