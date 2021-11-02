Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A69D44343E
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 18:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbhKBREi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 13:04:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231725AbhKBREh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 13:04:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635872522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B/7JyvbnmgvalQJYsoo2YThhI+3HlX8yusZmkgIWHPk=;
        b=cwlG5YU04n/+cDeLxDoyM5CiZS24im04aVRHv7OtckgNpzDNUjY0bJMQtZz90VK/ebI1Sb
        ZFXLL2QVZRiE5o/oaqY2bcslwNw11o08D24xCxjCq14nE0GNwHihMPc5aNz3xykG5tdD+o
        27bnMd7emEtv/OiaAPVHWSqkLfk73zA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-uZD0vfU9M1mdOFrI_ahwDg-1; Tue, 02 Nov 2021 13:02:01 -0400
X-MC-Unique: uZD0vfU9M1mdOFrI_ahwDg-1
Received: by mail-wr1-f71.google.com with SMTP id d13-20020adf9b8d000000b00160a94c235aso7622958wrc.2
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 10:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B/7JyvbnmgvalQJYsoo2YThhI+3HlX8yusZmkgIWHPk=;
        b=LAuFkunTNWtREKVDICuy8nqJsKXrTwfHPyCBIXKE+lieZN8HT/P+b9TfZ+9QbyBL9S
         DJ5vNtajdL3oeZEl/mCTZdsZu1hJqjXhkWSLcT/2TigJYRVRs0tcbrO37CC/i8lsxKXy
         inx10C1cMwrgpkdjkS0mPC9xOck/Ut6E6iVfUfDlI3FnKmWbU8mlMI+Equx6hgQfV6QV
         v/TS66pf1FWEA6xUxh3Sfg3lBIuQer/AJpKP2KX4Ago8m+fP/SZtz1w/J2Mayb32QfFl
         vhnAIhHRp1RzPD0InVXf70JErvd67Wv9Ur0zuaVObERrzZXxGiKxShpSVgJ8lPp6C6gl
         Hl5g==
X-Gm-Message-State: AOAM531sqxV1c9temv50Gwyc6C2ZQzvs5kqRPLJMSCDcfMafbrR4nOXQ
        BYa4rJ0qd66lt5VdU7bSmeHQ9LPwirGl1NWH0iJKJk4fTXWFEJNRPKFnfUh2x+69+k5mSdcX7LG
        v+tKdtLNAm7ha
X-Received: by 2002:a05:600c:1c07:: with SMTP id j7mr8883631wms.12.1635872520062;
        Tue, 02 Nov 2021 10:02:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk599EiV+NQhEhQXSyCoVvxdWsetYXFy0uivu7bXS8uyuAq3spW6vcffFx2C05Nsqz5WlLdQ==
X-Received: by 2002:a05:600c:1c07:: with SMTP id j7mr8883591wms.12.1635872519724;
        Tue, 02 Nov 2021 10:01:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q14sm17311754wrr.28.2021.11.02.10.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 10:01:59 -0700 (PDT)
Message-ID: <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com>
Date:   Tue, 2 Nov 2021 18:01:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2] KVM: x86: Fix recording of guest steal time /
 preempted status
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org>
 <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/11/21 17:38, David Woodhouse wrote:
> This kind of makes a mockery of this
> repeated map/unmap dance which I thought was supposed to avoid pinning
> the page

The map/unmap dance is supposed to catch the moment where you'd look at 
a stale cache, by giving the non-atomic code a chance to update the 
gfn->pfn mapping.

The unmap is also the moment where you can mark the page as dirty.

Paolo

