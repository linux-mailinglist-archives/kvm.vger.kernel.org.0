Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC733B2192
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFWUJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 16:09:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbhFWUJj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 16:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624478840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=neF7bHjkt8eYKISsLyJ+tcj35PVPa1INMUV3P696VPc=;
        b=imu05Aw6u6SoX2jTDlajtsZxwmUz8MEPcIwWVGHm7cEreoDhqC+GU6IHcknxG/t4HbSD5B
        FnkHI+7CZi0Bk0G7PO+F3BqshnJsFE8Jd0s4XGmbFMhrz6xZt3sJymaSX41y7RasdDBUv6
        tNpl2xkttFhfAyxgF4/WdukWPekNv0Q=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-gvr3PyOCME6VJmpzQPAWGA-1; Wed, 23 Jun 2021 16:07:17 -0400
X-MC-Unique: gvr3PyOCME6VJmpzQPAWGA-1
Received: by mail-ej1-f70.google.com with SMTP id w22-20020a17090652d6b029048a3391d9f6so1384658ejn.12
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=neF7bHjkt8eYKISsLyJ+tcj35PVPa1INMUV3P696VPc=;
        b=I4tZa1hS1YPrpO9X+XIUWgVQrCFu4dt+9C6r1Lma+b924fNeG4FkwIJjC2uDckqOOo
         rMNz9FaGc7Oh51doYRtJYwchiz1vzJt+gWK9l3L11rQZCG3yMSBCpnumUHHObiWA7T0L
         P/d6y8Cb60s/Sezk1NXTiNDwM/cn+a9xngK4IQhID2oEgt3c+VUjYKYWPcOENJaxZr8/
         +PucpR04vI+mNo2Cm0L6l55CaASq1bqCz1oGhAY6uOZM02btgyG+O7dxyL+mtILGuzYe
         5gIebfJ3GfGkhBHfbNWOb+FbWfuQRzvlo/HisejSC5sJrrfcuVbCQTkY7AZo6F3SJsIy
         oTqw==
X-Gm-Message-State: AOAM530wQAZlvypZ84OpL5xji3UifBEcy9CeDO+6ugaE663PT3592TK3
        Jo+YpmgIAhLz/1pOhfOlazFPJeZfVYIPOJmdFAA/LfURCSJkTUqc5GtRCDFggn7eXM4QreL46KS
        mMXfj6Pmqr4BU
X-Received: by 2002:a50:fb81:: with SMTP id e1mr2024857edq.108.1624478835995;
        Wed, 23 Jun 2021 13:07:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmptMwf95DiiS+2XVGKk2apg0X56qNgcCZFBN3pHQ+jFXLL5u0rTEH8y9YOQ09UVZQh6FRsA==
X-Received: by 2002:a50:fb81:: with SMTP id e1mr2024833edq.108.1624478835870;
        Wed, 23 Jun 2021 13:07:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u17sm582011edt.67.2021.06.23.13.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 13:07:14 -0700 (PDT)
Subject: Re: [PATCH 41/54] KVM: x86/mmu: Consolidate reset_rsvds_bits_mask()
 calls
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-42-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b2b61da6-613c-f3cd-d974-a7e30d356244@redhat.com>
Date:   Wed, 23 Jun 2021 22:07:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-42-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:57, Sean Christopherson wrote:
> Move calls to reset_rsvds_bits_mask() out of the various mode statements
> and under a more generic !CR0.PG check

CR0.PG=1, not =0.

Paolo

