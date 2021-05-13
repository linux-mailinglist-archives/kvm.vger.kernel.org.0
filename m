Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDE537FB97
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 18:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhEMQg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 12:36:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231426AbhEMQgz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 12:36:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620923745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5HrVbwO+VE4oyzQrEPviFjY8sp2t1UYH70BSy60jRL4=;
        b=PaOwxaLowTYIeEz9QimR5255Ukg2fCX3dehILBSE4vbGKvOkxtG9bJ5C3K4t4LdJ2yg6PO
        nP2DQFj86vqWxTcJOHB97kWr0qk2/3I6UoGFb+I9V3U5IxGeFV0QQ4xa3rgMi1xWA4McoZ
        0jDnAnFzHEu93/PHTw1k4yxoA982uJ0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-CcTnYQZINa-v31E4j5Sa1A-1; Thu, 13 May 2021 12:35:42 -0400
X-MC-Unique: CcTnYQZINa-v31E4j5Sa1A-1
Received: by mail-ej1-f72.google.com with SMTP id x20-20020a1709061354b02903cff4894505so1986001ejb.14
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 09:35:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5HrVbwO+VE4oyzQrEPviFjY8sp2t1UYH70BSy60jRL4=;
        b=NP4pd/lcPf//QQ9nwSHYg1n4C6unAMsLg1wm9RcXrpaVb7PfUSvKQAD/52De8d4bm8
         zuzK8zi0mi/VzHZlqIaUU4Qi3BwoNswT39zXkaanJkzJmw1B9N7tpXpfwYyHFaLyLHEn
         KKASbVJ7Dtiw6J8zZ3AHJeVaW8aQpzn/0F2/yZ4qUCMnd/0+NS+bvBTTuxkBnHDsVu5v
         4WB93/bVOoA7qakKrqubtK7GR0OZ55Mm3MbSou8XaKdqWSX6QeljeOeaAazLh/F7p5TZ
         bgpEr7x4RzbKbQlzYA2SDoMUmjPqy+bhgIgDhQrrq+w3oahPFIP/L0seDW2WCIfmYcuR
         iAQw==
X-Gm-Message-State: AOAM531MVdA60Y6of3i/PZtmg3Tyk/OsI/01jksBmUF5K2UlpV6e6Ang
        kx5sO0HlLOwfaE0BL2p4cG9a75PpgwYLujVcvBhVk8hrNCcdEhYj2v8a7QxGLuyjlSo51R5eVmU
        bn96eO3HvKVwz
X-Received: by 2002:a17:907:ea6:: with SMTP id ho38mr10193323ejc.357.1620923741768;
        Thu, 13 May 2021 09:35:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXb/9QsvsqLto0pGHud1wiAIE7ubr/qD3vpjWKQAlsYp0w3XIiyfbDS7jp+PbvT8HJkC8imA==
X-Received: by 2002:a17:907:ea6:: with SMTP id ho38mr10193312ejc.357.1620923741563;
        Thu, 13 May 2021 09:35:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t9sm2791788edf.70.2021.05.13.09.35.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 09:35:40 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Don't dirty guest memory on every vcpu_put()
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>,
        Kevin Mcgaire <kevinmcgaire@google.com>,
        Oliver Upton <oupton@google.com>
References: <20200116001635.174948-1-jmattson@google.com>
 <FE5AE42B-107F-4D7E-B728-E33780743434@oracle.com>
 <CANgfPd8wFZx977enc+kbbTP1DfMdxkbi5uzhAgpRZhU0yXOzKg@mail.gmail.com>
 <YJxf+ho/iu8Gpw6+@google.com>
 <CANgfPd8cujDpRBdD_XBC9h6Q8ijioXHuBUGZ-mBBGBAGHRBt6A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <788f634a-f0d8-75ab-1b40-ae65ee738879@redhat.com>
Date:   Thu, 13 May 2021 18:35:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd8cujDpRBdD_XBC9h6Q8ijioXHuBUGZ-mBBGBAGHRBt6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/21 18:14, Ben Gardon wrote:
>> A version of this was committed a while ago.  The CVE number makes me think it
>> went stealthily...
> That's great to know. Thanks for digging that up Sean.
> 

I usually try to send CVE/embargoed patches after the fact to the list, 
using with an [FYI PATCH] prefix.

Paolo

