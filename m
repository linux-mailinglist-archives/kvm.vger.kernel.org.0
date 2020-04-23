Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BAA1B5EB5
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgDWPKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:10:54 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51660 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728978AbgDWPKw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 11:10:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587654650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6IQojHe4J/6k3qfeiWdzY68BgNr3d6Bt4ImpMFFIpDM=;
        b=g0n8gvqByRemSBNfL6MVXTSX6Yw7iUXQlgGd0QuTFAD11wAj3IxeJ9xn1OfAX9PYG86J3D
        60UdX+5m03ITp+6vJZ+Aufj4xbuU/pYise8dKOv5HToca9q2+M/vTlXd2jqwJs6I+6VxyW
        hhKFyisIrIzv+TlWrS4U49hlNEE4LaE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-xoJKBvyUNTaigwU7iTTLPg-1; Thu, 23 Apr 2020 11:10:49 -0400
X-MC-Unique: xoJKBvyUNTaigwU7iTTLPg-1
Received: by mail-wm1-f69.google.com with SMTP id b203so2460853wmd.6
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 08:10:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6IQojHe4J/6k3qfeiWdzY68BgNr3d6Bt4ImpMFFIpDM=;
        b=YMm/4c8I7gfRhzMnZjGxI3a1yOV3DQk8THrL3BOhEdIY4Xwl28R1v0EebqEjRM9RP/
         yQ7kskyLvxtftVQCXMDHyy70CXBcmxWFk+jLxxCb5oluUZZXrUl/0ZhIS5HEhmpUiOko
         7Znwk19ArU7vA/VuzPODKoSKBr0PM3+YaE3IMcwS07vDIN+XOojg95qURFx4ytXA7fg8
         e7BfUgzmPdT3tUeoiv8tLj00y7gmRHb3pRSe9cazC47ktJ79Mdx/O3i7hwdgbohAdfAP
         B2XYs4P7nSk/GHnIpmxD69/AlFtLJa639QZY9kHEL2e3WL8iwR5kbXyZhfF7ZhGSe1h+
         zUFQ==
X-Gm-Message-State: AGi0PuatpMrvaosxX4cyMG4syzN3bJiuvtiie2R2lt7+nTRf8yRwzFeW
        VHBOG2EpPMiCJ06FXHcDI64Vm8OAEr04vzI07hWrqKu8Kj/b1jRAYyPGBrshKUVmveXnJt/RYtl
        YmCyxIFetln5u
X-Received: by 2002:a1c:4989:: with SMTP id w131mr4817215wma.137.1587654647738;
        Thu, 23 Apr 2020 08:10:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypJBRJkol6+EEfdoUivoCv0K3f//jt7ca68U8BmQbf6RxQwuLwAzr8W2Z3WR0idg+KG9HTTMhQ==
X-Received: by 2002:a1c:4989:: with SMTP id w131mr4817197wma.137.1587654647460;
        Thu, 23 Apr 2020 08:10:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id d7sm3994249wrn.78.2020.04.23.08.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 08:10:46 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: check_nested_events if there is an
 injectable NMI
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Cathy Avery <cavery@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, wei.huang2@amd.com
References: <20200414201107.22952-1-cavery@redhat.com>
 <20200414201107.22952-3-cavery@redhat.com>
 <20200423144209.GA17824@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ae2d4f5d-cb96-f63a-7742-a7f46ad0d1a8@redhat.com>
Date:   Thu, 23 Apr 2020 17:10:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423144209.GA17824@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 16:42, Sean Christopherson wrote:
> On Tue, Apr 14, 2020 at 04:11:07PM -0400, Cathy Avery wrote:
>> With NMI intercept moved to check_nested_events there is a race
>> condition where vcpu->arch.nmi_pending is set late causing
> How is nmi_pending set late?  The KVM_{G,S}ET_VCPU_EVENTS paths can't set
> it because the current KVM_RUN thread holds the mutex, and the only other
> call to process_nmi() is in the request path of vcpu_enter_guest, which has
> already executed.
> 

I think the actual cause is priority inversion between NMI and
interrupts, because NMI is added last in patch 1.

Paolo

