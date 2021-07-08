Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AA93C1808
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 19:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhGHR1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 13:27:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhGHR1i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 13:27:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625765095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gYbu5hFrVhU07xsTrQD/lLzrg/xnBBdhMnFYA3y+lTQ=;
        b=TTBrYo0nbd0P2/erJQccaBbaV4Tiz/J3WnuIrmveLHvXC/v8qPsokmO490mjr5olGJp4FG
        qLt5RaM3j0I/g1pzLdLGspGUmmdWXobPreJRUf1dQmPhZo58ewlJYGjwIK3HAVOThCNNx3
        f53t7kjxGrpdNeQtnf+Yfstf5258i7c=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-OYbnF0DuMQuHONfjvJiBuQ-1; Thu, 08 Jul 2021 13:24:54 -0400
X-MC-Unique: OYbnF0DuMQuHONfjvJiBuQ-1
Received: by mail-ej1-f69.google.com with SMTP id og25-20020a1709071dd9b02904c99c7e61f1so2157081ejc.18
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 10:24:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gYbu5hFrVhU07xsTrQD/lLzrg/xnBBdhMnFYA3y+lTQ=;
        b=A/br7th4AHK3x6KcjRfEMN3tjk/eYW+taqpZ509ts16/o56mZl4XCVoRJPXXtw4ZAL
         XAwiiPGdcB/LFzXyBObmxrhWJk3zRSmMJWd9lAJkWM5H33LB2zl2ejw/jOMRzsokKU0i
         Rm6xVzL7kTYb6yX9ZT8S4wONPLcekjARbXZrIYK9hkzRHtdoasmA7BQb/YzLppdMbMG+
         XBFN57zL1IGzQmcRAabGDOq9ej1H1yUabBhFuSta4Kut6AuRlLKtMjaf5QG2E3oZegoO
         eyhFH5Q2ElcnREhTU6AzaKlWcj5Y5UPYIUG6UI/wnAYWpzltrsPNkHaYjNmIQez7u/yf
         lcwg==
X-Gm-Message-State: AOAM530mwIGi+0NK1Yly62PdC0k4554qAHXMWaVsc5s2sMo9IMxtKIBd
        ILXjPCp9bZbEfyUmBpNW++wy4Oq+JytiRKpJ6N0xT/MAXuvhpl7RnJlc1SDzzLC6RQH+NqVW1+8
        wEr0vK1bcCjsR
X-Received: by 2002:a05:6402:5109:: with SMTP id m9mr39737090edd.297.1625765093482;
        Thu, 08 Jul 2021 10:24:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKnQGediYS6R/H5jXHHVUNLCOWqoVsHk7Z7g4osE6a/73c2rzf34wI2x8WHX1i82VIoOX63g==
X-Received: by 2002:a05:6402:5109:: with SMTP id m9mr39737066edd.297.1625765093339;
        Thu, 08 Jul 2021 10:24:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ee25sm1621735edb.6.2021.07.08.10.24.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 10:24:52 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: SVM: Fix error handling bugs in SEV migration
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steve Rutherford <srutherford@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>
References: <20210506175826.2166383-1-seanjc@google.com>
 <20210707134255.GX26672@kadam>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2cc27835-b3e3-3ef5-9f79-c3f3a3bdb32d@redhat.com>
Date:   Thu, 8 Jul 2021 19:24:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707134255.GX26672@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/21 15:42, Dan Carpenter wrote:
> These patches were never applied.
> 
> regards,
> dan carpenter
> 

Queued now, thanks for the reminder!

Paolo

