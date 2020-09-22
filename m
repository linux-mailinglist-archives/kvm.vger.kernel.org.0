Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81FB27432E
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 15:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgIVNdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 09:33:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbgIVNdF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 09:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600781584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=933GUut1+TrG+98/jn2IqlWr/ZWUBB9JCfd+Na9nkPQ=;
        b=QaigIpfz5RiD41/Ua4PY7wOw49+4kWerrNzzD4HtH0nFXKywVgre02Rhnnc5A87VaceAmu
        d3ozZHT5berQx0wz62aaLhiz7Pb7Fm3ZiKx8iESeTxU7VYC+rDmFdNfe/WyFeykGxt8zVo
        mbt/JLiEF7Dzs1p7Zm2mVxLAhthUXVk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-IzHgIZIiOv2I2eMRl21xzg-1; Tue, 22 Sep 2020 09:33:01 -0400
X-MC-Unique: IzHgIZIiOv2I2eMRl21xzg-1
Received: by mail-wr1-f71.google.com with SMTP id i10so7405852wrq.5
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 06:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=933GUut1+TrG+98/jn2IqlWr/ZWUBB9JCfd+Na9nkPQ=;
        b=AlaajIS2d3STjsWzRjWMqeHu8MxzcGREpPqYaabcP29x1x4cwu4G0Fudfx9s4dAqhx
         21v9SF8niEazZpx1MpA9CRUpBC3IC5ppNVfEeu2/iZ5xXzzVFNQNNenayvX8ivZoB7Q/
         cx7uOFLL83WOazniEjn/b+boXfme+o6FVp0T86HYupQ72UAMbUm++wmpfKk8fLhN4X0M
         SjG/FoXzntJ2iFMejkdyqq+GhQo+FPYCzaSGPNQ5j+6f5ga3JKyBGDCWtnwwuvpAR03D
         MmoQ1dKOdPaew+d2SYNtKkoqRcuHDZaJb68TUweNgKthdRbxznpQcNmFZaGi65xtS49A
         YgFw==
X-Gm-Message-State: AOAM533wkcCAt5e0CKqjHcvRzqauUhd6oQsJIMYhGGhjJbMSquCmKKjf
        UbgkV1DS29ycfzGkcmnKjAPX0cFxEtb5ig/qTxLTWLYH/BMjtsFiU1eIaG6bQcOLKRfyYcnD+AA
        l6pqt74SCj1QE
X-Received: by 2002:a5d:5106:: with SMTP id s6mr5808354wrt.166.1600781580059;
        Tue, 22 Sep 2020 06:33:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhjD+M3txWbWvPufHyfaxAIQR1dLZEoDT5w6krghxxjTl8xkF6rqKB2PaudLoHX0rILkQicg==
X-Received: by 2002:a5d:5106:: with SMTP id s6mr5808331wrt.166.1600781579824;
        Tue, 22 Sep 2020 06:32:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id p9sm4444362wma.42.2020.09.22.06.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 06:32:59 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Add kvm_x86_ops hook to short circuit emulation
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200915232702.15945-1-sean.j.christopherson@intel.com>
 <CANRm+Cx85NBnL76VoFV+DNrShp_2o+c4dgQCwNARzrAcmX1KAw@mail.gmail.com>
 <20200916173416.GF10227@sjchrist-ice>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2cacbe0d-703b-cb06-ac5b-96841f145b95@redhat.com>
Date:   Tue, 22 Sep 2020 15:32:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200916173416.GF10227@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/20 19:34, Sean Christopherson wrote:
> 
> The intent of posting the patch standalone is so that SGX, SEV-ES, and/or TDX
> have "ready to go" support in upstream, i.e. can change only the VMX/SVM
> implementation of is_emulated().  I'm a-ok dropping the handle_ud() change,
> or even the whole patch, until one of the above three is actually ready for
> inclusion.

I think it's fine with the "can" in the name.  Hopefully one of the
three will go in soon...

Paolo

