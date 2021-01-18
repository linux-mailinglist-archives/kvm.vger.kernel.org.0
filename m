Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8332FA8BC
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393182AbhARS0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:26:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407561AbhARSZy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 13:25:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610994268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eWykzve3UBcllvD35C3br937OB5w9uaX2YUqimi9UUM=;
        b=N4DuBkq7qWvtFZ4VQ6VHzs1eVPUuriRA6pcziAjm1C9vuIuMKcrbbg/ZWTAS7sKqv2HCnt
        Gb8FW7b4Ppk8IXAywe9XpiCrnhvVlype1qwko6Fz7xGjEY3gM/gh4rBtdjoD8wih23B710
        XdQAUUjKxhZR4V6ZW1a4ULrzLKQzQTY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-MfAxwk18M4SO7YWLnr0WRA-1; Mon, 18 Jan 2021 13:24:26 -0500
X-MC-Unique: MfAxwk18M4SO7YWLnr0WRA-1
Received: by mail-wr1-f69.google.com with SMTP id u14so8732129wrr.15
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 10:24:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eWykzve3UBcllvD35C3br937OB5w9uaX2YUqimi9UUM=;
        b=qoGgLcC0y4F6QAI4aVE6lZeYSKKQxA+2TXg++zE0U7DsXD8OcoUBPKfNZsi9sjHmSW
         V1rgQi8o3i1XTVLndlBxp8NO4+xbxy1GkSPfsRQuGmT7Ck7Zxazq/l+OJsuT/p2LvX9j
         bEc4y8WdZmobfFp2BQ+ZlZG5meBJLQY11G8bmQ9TVgtonzJhSM+KJUvuJEqBpXBym7EF
         civp5HTTkm+jiqb+2kWpMJyCsN+wp1OsuQt/lEYmAwRLXwkygpw/b5ZCiugEr4ROOxOL
         pUei52vihjwjP1ehmNCpC14PpPoH20ASF7XnMzFUEnvFktp/qkBl6bJrPyMVtHt9VB2L
         zxng==
X-Gm-Message-State: AOAM532ud5krt9GHc04lksX1ADhcnozYc67Ke772mnHUVtncA2rdxLWy
        tRoQKQkRbOfy2is5cAMvGAkeqxhQw/IEp2icUkw0e1RNo+sZW8yD0g+dCvloZFkH4VZnSzZPt0j
        8mrDOLTEZe2Go
X-Received: by 2002:a05:600c:618:: with SMTP id o24mr625755wmm.82.1610994265118;
        Mon, 18 Jan 2021 10:24:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx49lMoWqrOmyl2CbqcL+DnBsCRYRP77yi3LtDI3+61TNIpnRPHLY/Tm082FtK8UnGCy68ymw==
X-Received: by 2002:a05:600c:618:: with SMTP id o24mr625743wmm.82.1610994264945;
        Mon, 18 Jan 2021 10:24:24 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h9sm286767wme.11.2021.01.18.10.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 10:24:24 -0800 (PST)
Subject: Re: [PATCH 0/2] KVM: VMX: Avoid RDMSRs in PI x2APIC checks
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, luferry <luferry@163.com>
References: <20210115220354.434807-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d9d59280-0f68-6af0-82d0-87d1eda69a07@redhat.com>
Date:   Mon, 18 Jan 2021 19:24:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115220354.434807-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/21 23:03, Sean Christopherson wrote:
> Resurrect a patch[*] from over a year ago to avoid RDMSR in a fairly hot
> path in KVM's posted interrupt support.  Note, in my response to that
> patch, I suggested checking x2apic_supported() as well as x2apic_mode.  I
> have no idea why I suggested that; unless I'm missing something,
> x2apic_mode can never be set if x2apic_supported() is false.
> 
> [*] https://lkml.kernel.org/r/20190723130608.26528-1-luferry@163.com/
> 
> Sean Christopherson (2):
>    x86/apic: Export x2apic_mode for use by KVM in "warm" path
>    KVM: VMX: Use x2apic_mode to avoid RDMSR when querying PI state
> 
>   arch/x86/kernel/apic/apic.c    | 1 +
>   arch/x86/kvm/vmx/posted_intr.c | 6 +++---
>   2 files changed, 4 insertions(+), 3 deletions(-)
> 

Queued, thanks.

Paolo

