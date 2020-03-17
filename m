Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4813D188C44
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 18:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgCQRi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 13:38:26 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:28037 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbgCQRi0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 13:38:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KqXznweBlwjgjbqOmCj0t1wRnXCMMt9Q5oGndDgHqKw=;
        b=Z34wY0SCuTEW/xzClMKgji/PyPKtplXwDSO9AfryKXo0/U1CxzfYBS/ZcvuD9uf+A9Cnhb
        kuRXwsbpCsD3JVG9EFQVGb15Y8/+uwLY150GclkGsyZyznL4K2YGfCHb3rZ/gHJu/3PvCj
        oCSorQ99Vh79Nl3qNts6f7W/S6ATVgM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-P162ccS5Na-gaxWXv6TnXw-1; Tue, 17 Mar 2020 13:38:23 -0400
X-MC-Unique: P162ccS5Na-gaxWXv6TnXw-1
Received: by mail-wm1-f72.google.com with SMTP id n188so58473wmf.0
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 10:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KqXznweBlwjgjbqOmCj0t1wRnXCMMt9Q5oGndDgHqKw=;
        b=tYdMm0M79CLd/GHSHfi14NKriUk5d+6DGkRBID8POTQ3Th6NNdi2wWWuJ6rQ+zKh7X
         xmskbFHc5a+I1DvXOi7qcKfQZmoW4vh5aJ7YBFwYe/bpiUAlg31JQXahkmon9iMQfqkZ
         sSqNSRjReRr+2zyFiG3HhFxqz8/zsWgi07eosShefZJwT3zl8XOsvSCM/DC7CBi8LrjY
         J6afRjOcGEOtPRKJOTDweAECfIOOSny+kYmYJbelxDY32rpW+LOfpupQunWwee5zeU0n
         K/spD8rtSrxxL+SwxJIDM8NSJlNkw2FD3g8AbA/LqDHx3+QaGLzOL9PxUu/bYVWDP4wD
         z6rg==
X-Gm-Message-State: ANhLgQ33WhA9xjSK5EhCxngjFYP+BVgXQojbjh+1PZyrRW1OAcvvDxBW
        tgrMBOZICCwrbdFoFGCCjGcgeWPcMKVBoF9IPsj4sAjJlIUDJgQglDh20jCk3YUgkXdnWHUPoX0
        2rRZX684S4sPt
X-Received: by 2002:a5d:698c:: with SMTP id g12mr109541wru.382.1584466702582;
        Tue, 17 Mar 2020 10:38:22 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vv2+A6tWc5nG/r5JkQ3oWBizSODgSFk5DmsHpehp4pOI8egGtrWh/hnLDHQmJahsWLHxSYI6A==
X-Received: by 2002:a5d:698c:: with SMTP id g12mr109524wru.382.1584466702334;
        Tue, 17 Mar 2020 10:38:22 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.227])
        by smtp.gmail.com with ESMTPSA id k9sm5609036wrd.74.2020.03.17.10.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 10:38:21 -0700 (PDT)
Subject: Re: [PATCH 01/10] KVM: nVMX: Move reflection check into
 nested_vmx_reflect_vmexit()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
 <20200312184521.24579-2-sean.j.christopherson@intel.com>
 <87k13opi6m.fsf@vitty.brq.redhat.com>
 <20200317053327.GR24267@linux.intel.com>
 <20200317161631.GD12526@linux.intel.com>
 <874kum533c.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bd3fec03-c7c3-6c80-2dce-688340a1ae72@redhat.com>
Date:   Tue, 17 Mar 2020 18:38:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <874kum533c.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/20 18:00, Vitaly Kuznetsov wrote:
> 
> On the other hand, I'm a great fan of splitting checkers ('pure'
> functions) from actors (functions with 'side-effects') and
> nested_vmx_exit_reflected() while looking like a checker does a lot of
> 'acting': nested_mark_vmcs12_pages_dirty(), trace printk.

Good idea (trace_printk is not a big deal, but
nested_mark_vmcs12_pages_dirty should be done outside).  I'll send a
patch, just to show that I can still write KVM code. :)

Paolo

