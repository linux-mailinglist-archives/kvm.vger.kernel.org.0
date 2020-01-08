Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F5F134BA4
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 20:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgAHToi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 14:44:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47221 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730154AbgAHToh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 14:44:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578512677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xiCJJGPdrtAtVlP+spr66I41euYYZbVu6K0JCOT1APU=;
        b=STf8huWXDMIPDJZZcZozp8PEzF5uJ1A+FVoDcNOOXmQMJyDFQgQddOkcR0PjfzGzOjhp+4
        hNIJqDfPrPwGD/2nbUTdr/2b4/1NuL5AjzpqdHSqDywMKafpeLs9G4WBjJ6/gAvgRc9OMa
        iX9L/6zGbkl/3pEJdIxhxbNI1fWKkbk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-R82HYyWfNPSZo98rg9s68Q-1; Wed, 08 Jan 2020 14:44:35 -0500
X-MC-Unique: R82HYyWfNPSZo98rg9s68Q-1
Received: by mail-wm1-f70.google.com with SMTP id w205so40579wmb.5
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 11:44:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xiCJJGPdrtAtVlP+spr66I41euYYZbVu6K0JCOT1APU=;
        b=WSc/1yljaivVKdrOKlDjXsutesByRxroaNw1psOREMXfDup8tgb28c6+dREmM54hGR
         99MSckLMluCooK8BtEOm1YFHjsqQsk7ZCDjlOqjQI7ot5DA2cYm6qzaZvLh9hkqdDzqf
         6mTGWiTzR8bGtqF74fBGXA4lt6LDtksUqJnvDEyy6iDzb5Pc4QqSGCnvSR8XUBT5slq5
         EfpGMznv5RNLUv2sqWrnZqZKn9eIyaRcMqvr+0A8QIGdmGJy0xikdBlKQ1AmfLNH3q8U
         8tszb0DYLlxQPYOeM4x2ddhwq/pqYrsB58VSK1X88AQrqWNlRT1xuxqf+UJt6n/TeaOF
         HutA==
X-Gm-Message-State: APjAAAU8umRkNXjPnAK3eXxrT3kSg37ww2fDlaclzE31O78lfPnTC+T9
        2gQxxtHIRd53s1cYWgseKcCb/ltIxbkKlUo0UU9eHj5TUs/2sQORpE/F6hhSlqUYc3vNYqB4OKt
        yJu7Oy8AMdjSw
X-Received: by 2002:a1c:e108:: with SMTP id y8mr206187wmg.147.1578512674495;
        Wed, 08 Jan 2020 11:44:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqxbBpucyM3FryruwsnJOFaae2hww/L3q+N0i/YChjVOZBufQZLIjD9QEhcVoO3V1CG6z04xig==
X-Received: by 2002:a1c:e108:: with SMTP id y8mr206177wmg.147.1578512674295;
        Wed, 08 Jan 2020 11:44:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id o4sm5396325wrx.25.2020.01.08.11.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 11:44:33 -0800 (PST)
Subject: Re: [PATCH RESEND v2 08/17] KVM: X86: Implement ring-based dirty
 memory tracking
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-9-peterx@redhat.com> <20200108155210.GA7096@xz-x1>
 <9f7582b1-cfba-d096-2216-c5b06edc6ca9@redhat.com>
 <20200108190639.GE7096@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <03e0cc7c-f47b-bdfa-8266-c77dc0627096@redhat.com>
Date:   Wed, 8 Jan 2020 20:44:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108190639.GE7096@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/20 20:06, Peter Xu wrote:
>> The kvmgt patches were posted, you could just include them in your next
>> series and clean everything up.  You can get them at
>> https://patchwork.kernel.org/cover/11316219/.
> Good to know!
> 
> Maybe I'll simply drop all the redundants in the dirty ring series
> assuming it's there?  Since these patchsets should not overlap with
> each other (so looks more like an ordering constraints for merging).

Just include the patches, we'll make sure to get an ACK from Alex.

Paolo

