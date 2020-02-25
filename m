Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E3016BB7C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 09:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgBYIHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 03:07:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55895 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729043AbgBYIHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 03:07:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582618025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oyV65P0wJT/QVCIMbi37mnuxu4JL3T8Bnc6cBnFgy0o=;
        b=QWNbVOZfatPX523AkEdNWQ4fRkdTd9jl9D8GTFBw+Lye37X/tZ4qCvlJo0JMwJjQlbrj1H
        b58xWE/KR0rM/18c25+NA7Njx15vE5K0KxF5mgF/Jt8Vh1g7pF8rByNDl1n47GH6xAgT4I
        xHF37FLPE22qVupHA/AxAZlCV3qFCDw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-KKDV8I2mO2SSFK_Yj_i4-A-1; Tue, 25 Feb 2020 03:07:03 -0500
X-MC-Unique: KKDV8I2mO2SSFK_Yj_i4-A-1
Received: by mail-wr1-f69.google.com with SMTP id h4so1689644wrp.13
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 00:07:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oyV65P0wJT/QVCIMbi37mnuxu4JL3T8Bnc6cBnFgy0o=;
        b=OSoKMxw76jsUJJ7ypHAJ7xZhshwVO3KXVtcSZWlBIl7yQbVasOlWSJ7aXye9GlXpkK
         LpIBqJEY62yFkYKYa4Ygt4DzZFmNRIuY4sLJlVO3voMvsxRuM7ZO7DPnWyeeYjprx39I
         olcKJAm5fVryMswj+XGCEZHRCqjI3f17x24qMA/+LFbc+xj6z0ffmBE4jSro5z+3kLzA
         MhFXsToo7CeVD4/yjZXeQtuJ2YojD2R1q8kG4g7wYLpgiBbNkEF5DFtaPSyn7ajThX2Y
         ai7HIRKe4W6fVYab29D8ocyfSAdQ0I6La+vxB+hNyNnXci3AZQO4/dwhdsDmqOXNlM1u
         p28A==
X-Gm-Message-State: APjAAAXdZukfob991uDFcU8STEcWlj/zHfEA8epXGUSyZVchRBhdsX1k
        hq6vfCh29uUCHdKw2i43HCUtlifH08Ce+Hn7XQNX70/J6Dvzqw/LNvURN3FMqLV6skB2lRzPL9p
        mDXH2AoO3iJ33
X-Received: by 2002:adf:cc8b:: with SMTP id p11mr21179193wrj.8.1582618022681;
        Tue, 25 Feb 2020 00:07:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqyIVScXiu1RVWc//crX4pYvYp3oCYcgROaw86pP31PI4FMtJoAhCFDPukMCIBNUsmAJ+M+F9w==
X-Received: by 2002:adf:cc8b:: with SMTP id p11mr21179169wrj.8.1582618022431;
        Tue, 25 Feb 2020 00:07:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:60c6:7e02:8eeb:a041? ([2001:b07:6468:f312:60c6:7e02:8eeb:a041])
        by smtp.gmail.com with ESMTPSA id b67sm3133434wmc.38.2020.02.25.00.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 00:07:01 -0800 (PST)
Subject: Re: [PATCH] KVM: LAPIC: Recalculate apic map in batch
To:     Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1582022829-27032-1-git-send-email-wanpengli@tencent.com>
 <87zhdg84n6.fsf@vitty.brq.redhat.com>
 <CANRm+Cyx+J+YK8FzFBV8LRNPeCaXPc93vjFdpA0D_hA+wrpywQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f433ff7e-72de-e2fd-5b71-a9ac92769c03@redhat.com>
Date:   Tue, 25 Feb 2020 09:07:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CANRm+Cyx+J+YK8FzFBV8LRNPeCaXPc93vjFdpA0D_hA+wrpywQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/02/20 01:47, Wanpeng Li wrote:
>> An alternative idea: instead of making every caller return bool and
>> every call site handle the result (once) just add a
>> KVM_REQ_APIC_MAP_RECALC flag or a boolean flag to struct kvm. I
>> understand it may not be that easy as it sounds as we may be conunting
>> on valid mapping somewhere before we actually get to handiling
> Yes.
> 
>> KVM_REQ_APIC_MAP_RECALC but we may preserve *some*
>> recalculate_apic_map() calls (and make it reset KVM_REQ_APIC_MAP_RECALC).
> Paolo, keep the caller return bool or add a booleen flag to struct
> kvm, what do you think?

A third possibility: add an apic_map field to struct kvm_lapic, so that
you don't have to add bool return values everywhere.

Paolo

