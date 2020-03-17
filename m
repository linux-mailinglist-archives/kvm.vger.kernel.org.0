Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81A0188C77
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 18:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgCQRuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 13:50:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39646 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726066AbgCQRuN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 13:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584467411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1kZ33/ECBpyu+Myh8NlL2Y8VNV52N9Gf0h2NmxjYXvA=;
        b=h9TYHYg4EZ32N99Xd3Fvw7g0eWWIw+wjX/yyY32P7MBDTC/XOwA/5d2NJlryTOEVeu/ob/
        ne42IEcUqSBNfZnXXtdzGWkVyxbb8vqrg4NWf11G6itAWP3jNZcb5v4LbqRF/OFqc2T74J
        ZQ4t8XYE2EuKVmcXDFRKF7cqFKBPtHo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-Rf91WR-vNFeTI6tvVOB5uA-1; Tue, 17 Mar 2020 13:50:10 -0400
X-MC-Unique: Rf91WR-vNFeTI6tvVOB5uA-1
Received: by mail-wm1-f72.google.com with SMTP id n25so66947wmi.5
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 10:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1kZ33/ECBpyu+Myh8NlL2Y8VNV52N9Gf0h2NmxjYXvA=;
        b=OLIeXfZEVIadtkoL91Uybl5GnC9Z4fKmHzWFlt1e26EQ/JYhQGjNEBZu7P0YHT5rkE
         Idk565h6Xx4LQhgoMMARjJfIO5Nxn4LzVVT5jEX4vbN/TGU7cjBIWPZOxfX6E7MYRQpv
         /ghmkRyKb7aK1Z57qHQmLjDKmaMT1CzM67q98R+gcw5OQ2zlk5LY08IQYy1eAMYVEF39
         q0u1eiRdXZV+FILi++yVE45mHBuEXqrC7WlU4g52ri5UPo2bDi5fqI77A3mxaewqydes
         fWYGExuWdrvenNiIAFA4KkpbM4E6v2QHfgdriV0D11I9XTvA8WOlgk1K/Ad8OIiXTTKv
         9fXg==
X-Gm-Message-State: ANhLgQ3ZcNDysP7NDYBV06rC+PSWNZPVxq9L1JDZElMHg4TyynU+7G1k
        WLSJulq2AnRPCSIGNnVXgKSFJdLJkmEuJywNAhZ73rrpdiO7JnC+z+VikZyogPqHR0HmBk9q3iW
        iKt3906YDi2m3
X-Received: by 2002:a1c:1b0e:: with SMTP id b14mr216917wmb.8.1584467409232;
        Tue, 17 Mar 2020 10:50:09 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtzeQrGSnJfn3mUZPpBZWwtPReAzdcQX+Z/VDKTNHGHTPJT+xIkxueKqU3cPAwKEyy9rHOX+Q==
X-Received: by 2002:a1c:1b0e:: with SMTP id b14mr216894wmb.8.1584467409031;
        Tue, 17 Mar 2020 10:50:09 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.227])
        by smtp.gmail.com with ESMTPSA id n6sm219707wmn.13.2020.03.17.10.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 10:50:08 -0700 (PDT)
Subject: Re: [PATCH 09/10] KVM: VMX: Cache vmx->exit_reason in local u16 in
 vmx_handle_exit_irqoff()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
 <20200312184521.24579-10-sean.j.christopherson@intel.com>
 <87h7ysny6s.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a37d3348-5584-6a34-adfd-830a075dc236@redhat.com>
Date:   Tue, 17 Mar 2020 18:50:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87h7ysny6s.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/03/20 15:09, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
>> Use a u16 to hold the exit reason in vmx_handle_exit_irqoff(), as the
>> checks for INTR/NMI/WRMSR expect to encounter only the basic exit reason
>> in vmx->exit_reason.
>>
> True Sean would also add:
> 
> "No functional change intended."
> 
> "Opportunistically align the params to handle_external_interrupt_irqoff()."

Ahah that's perhaps a bit too much, but "no functional change intended"
makes sense.

Paolo

