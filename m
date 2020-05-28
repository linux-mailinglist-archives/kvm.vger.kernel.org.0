Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063D21E6733
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 18:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404937AbgE1QPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 12:15:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20088 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404861AbgE1QPj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 May 2020 12:15:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590682537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VBsBl0zv2+hfAxIShtc2kJO5XBzn0N2aNFybtxxAii0=;
        b=KJ3Qy6//yUBXensZqsEiCxJ2DkFUruZ3/v68KAJYu7RgI418MHlgPwXf5RzuAyZ1cw9HpU
        9/t8vm7KCuZ6WzHE+irhbWJn8UR9Pq3qQT+aT5Nd0FAkHRtnGgUpkrM+f/vDOJ+oadH81X
        pCXFMGVjpAhIFSgZ0SnaMvhZ6gckzUQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-ZFsCkawxOlyRXcQL5giqbg-1; Thu, 28 May 2020 12:15:35 -0400
X-MC-Unique: ZFsCkawxOlyRXcQL5giqbg-1
Received: by mail-wm1-f69.google.com with SMTP id t62so1153165wmt.7
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 09:15:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VBsBl0zv2+hfAxIShtc2kJO5XBzn0N2aNFybtxxAii0=;
        b=Tm+veXPj4cUvm6xqU25IvXomV1Y4ESYNUp5a3xCIgbWzSHsl8+mx/v0GWeL9GzMmKd
         cWJCstDQ3r8O2bqlcUAA7fJYvm76feWygbvhIj9BbzZRHYF/eLLWI/Vjl/WSe4n6djtE
         y3c4IkDPMc0RRTFD5TYUsW2cHtKLzN171i4DPXDNBaOBa78eQGD/0fMPEO2tFZvKClR9
         OyEUTAM6POVM/ZkyYgWN0F22OQwNIIkRaNV84ErF/W7WFSL5HRDZGk8kbZ0PJwXqtraG
         +YYeGibqoLuakdSfxEShQwKIDIFpnWuuTzCQxfkR++Swu8eD0ffTmqVIBgDVzDhwDDHB
         ZkfA==
X-Gm-Message-State: AOAM531ZwWImXvZM+0Aqhp0j79TQsJIw/7zncdJuAnKNn9zGhPcwKgRH
        w/1Sz4Dthh/Dta6xMWMfqg+0qr2DvUrjwB4uklq0N3xKQ/jCvbOdqnrcUmT5yg6ssOI9Jfsg0q9
        mAjIk3qCvUVI8
X-Received: by 2002:a05:6000:4c:: with SMTP id k12mr4161804wrx.215.1590682534393;
        Thu, 28 May 2020 09:15:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwX/wz1XR6Etg3y5Gvk2TtGqcrXI2toGUfxGEMY4rCCjnLMCWyXlwJw/FTBx3W2SauZLjDnYQ==
X-Received: by 2002:a05:6000:4c:: with SMTP id k12mr4161789wrx.215.1590682534164;
        Thu, 28 May 2020 09:15:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id q1sm6458345wmc.12.2020.05.28.09.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 09:15:32 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Call kvm_x86_ops.cpuid_update() after CPUIDs
 fully updated
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200528151927.14346-1-xiaoyao.li@intel.com>
 <b639a333-d7fe-74fd-ee11-6daede184676@redhat.com>
 <1f45de43-af43-24da-b7d3-00b9d2bd517c@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5d8bc1da-f866-4741-7746-1fa2a3cfbafd@redhat.com>
Date:   Thu, 28 May 2020 18:15:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1f45de43-af43-24da-b7d3-00b9d2bd517c@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/20 17:40, Xiaoyao Li wrote:
>>
>>> kvm_x86_ops.cpuid_update() is used to update vmx/svm settings based on
>>> updated CPUID settings. So it's supposed to be called after CPUIDs are
>>> fully updated, not in the middle stage.
>>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> Are you seeing anything bad happening from this?
> 
> Not yet.
> 
> IMO changing the order is more reasonable and less confusing.

Indeed, I just could not decide whether to include it in 5.7 or not.

Paolo

