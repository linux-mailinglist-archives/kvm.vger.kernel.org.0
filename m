Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F91168505
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 18:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgBURc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 12:32:57 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50757 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726066AbgBURc5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 12:32:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582306376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o96Yvzi87DPePCMyKdFlIusrR00b35JbPu9d8slr560=;
        b=aXtayFz7oDLrtuZJ+w0OlOjX68eTYuW+goE4UL0e3dRX49/AzAj7JLe+nVcYcZcLDcYFT9
        ZI3krBdLn2WCKkWA1bvCSvXSHOErP/i+55lqcOh9C0cqQoiXQ+thf/PZhCffNpXAA7NDM3
        D3Gu//70az2lDvq98rqOYtUKQ5WMmPs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-BNv1xBD4Px2uTh0H0iIh3A-1; Fri, 21 Feb 2020 12:32:54 -0500
X-MC-Unique: BNv1xBD4Px2uTh0H0iIh3A-1
Received: by mail-wm1-f71.google.com with SMTP id f207so856839wme.6
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 09:32:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o96Yvzi87DPePCMyKdFlIusrR00b35JbPu9d8slr560=;
        b=VpTN0NJ01ctbkDQGDINkyX8Ia+SqxftnnqqbRrYFGMuix48pYr+aEcPK1chgwlB8ew
         z+Ej6xls/2CCz5H4gfW9zY6AwkrT15AXcfrPstP0lj56F2wLSXKZQuLwStTTuwTtC5J3
         TVbFtYeagjm/lxBave0ZITbJxirYhBQeZ+XhZ2eUA4Z9yhLZih/z1oImnFD8k7LrtP4g
         QN7LypJUgS8kKR3uG8zhKbPTHFagX7RYt5xTtPE2R0LdJuqJoyCPbCSKXHWBFVj93j/E
         7Y6C540dAw9xonoWX3aEGTOhQSwDhngvZ2CgsnJPv0VIeofe5QONHn8HHRQM+wAF8y45
         G7oQ==
X-Gm-Message-State: APjAAAV7uPG53fQCpRMg1VpFOl5eFFlU8EwclPeKRCetn1iDvatrFycj
        sGoXi4EaKwdMvheCTZv4lxu6S7OQwQFydC7wwu68vW8mlnj9OxLC7R26M5BoscZVD6eM5tebyvS
        R41QBBVjZgvcy
X-Received: by 2002:a1c:a4c3:: with SMTP id n186mr4955225wme.25.1582306373146;
        Fri, 21 Feb 2020 09:32:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxayLNZ1h9vLVc5mYWPuuY1cdEKYHllZpJcPEvt3/MdMtEG+xA001YejVgYA0jVDbPLZm/vlg==
X-Received: by 2002:a1c:a4c3:: with SMTP id n186mr4955201wme.25.1582306372831;
        Fri, 21 Feb 2020 09:32:52 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id x11sm4493300wmg.46.2020.02.21.09.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:32:52 -0800 (PST)
Subject: Re: [PATCH 06/10] KVM: x86: Move "flush guest's TLB" logic to
 separate kvm_x86_ops hook
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
 <20200220204356.8837-7-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ca7bcbc2-d7eb-bc7c-4e15-a77831af8a73@redhat.com>
Date:   Fri, 21 Feb 2020 18:32:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200220204356.8837-7-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/02/20 21:43, Sean Christopherson wrote:
> Add a dedicated hook to handle flushing TLB entries on behalf of the
> guest, i.e. for a paravirtualized TLB flush, and use it directly instead
> of bouncing through kvm_vcpu_flush_tlb().  Change the effective VMX
> implementation to never do INVEPT, i.e. to always flush via INVVPID.
> The INVEPT performed by __vmx_flush_tlb() when @invalidate_gpa=false and
> enable_vpid=0 is unnecessary, as it will only flush GPA->HPA mappings;
> GVA->GPA and GVA->HPA translations are flushed by VM-Enter when VPID is
> disabled, and changes in the guest pages tables only affect GVA->*PA
> mappings.
> 
> When EPT and VPID are enabled, doing INVVPID is not required (by Intel's
> architecture) to invalidate GPA mappings, i.e. TLB entries that cache
> GPA->HPA translations can live across INVVPID as GPA->HPA mappings are
> associated with an EPTP, not a VPID.  The intent of @invalidate_gpa is
> to inform vmx_flush_tlb() that it needs to "invalidate gpa mappings",
> i.e. do INVEPT and not simply INVVPID.  Other than nested VPID handling,
> which now calls vpid_sync_context() directly, the only scenario where
> KVM can safely do INVVPID instead of INVEPT (when EPT is enabled) is if
> KVM is flushing TLB entries from the guest's perspective, i.e. is
> invalidating GLA->GPA mappings.

Since you need a v2, can you replace the name of mappings with "linear",
"guest-physical" and "combined" as in the SDM?  It takes a little to get
used to them but it avoids three-letter acronym soup.

Paolo

