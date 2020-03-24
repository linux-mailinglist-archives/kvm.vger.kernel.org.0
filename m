Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC1D8190C4B
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 12:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCXLTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 07:19:12 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:35214 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727207AbgCXLTM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 07:19:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585048750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pgtxWIUqOe7RBV8y1HKFvXo0TcPt4L4/Y/Q8yOwJg8A=;
        b=NTT5PpmbyVx7tbxDQ31t1MxaVYgxt56kV1o7RGjtYqsNA0Q49m1D/4orPYUTORuNki+8Yf
        uXFjuysoOmxXKFVjr7DbYADNtWX3k8bA9EgCccUCWsbt6yKJuCxZHZM1ogOG2lBoqG4t2+
        601nqdXK/NruHGXhWEM8HcZDqmk4ITE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-DXiCh7UZPEmLz94nRmnLkw-1; Tue, 24 Mar 2020 07:19:08 -0400
X-MC-Unique: DXiCh7UZPEmLz94nRmnLkw-1
Received: by mail-wr1-f71.google.com with SMTP id e10so6317854wrm.2
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:19:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pgtxWIUqOe7RBV8y1HKFvXo0TcPt4L4/Y/Q8yOwJg8A=;
        b=tgJFqAPi3AuFTFdbgKH16dUKAlAEKga9h5NQSugi/9obHiwKZ5+qvXW84CB3cua0dk
         b9GxQ1QdxlMZ6SKjWfVH3sAUzjztG6ku4xv1kz5uKyl+gwF8Ly/hlUECgaCL/RdoGtJD
         s6jGldB68pSrJKSbasXff/A+hJEDNDm/X8tuZbbG/IlQ0wGCxnQkJo0XeN9AHZ3z7qKG
         O8VmI1XZudmXEOW7dzB4T9RU9CGnygWRQu4qs1yCpnIR+9359/GH7TpQ8yCXHRRKZHqj
         I8c9jnIHwn/dstbgy2Z98y3Gsjk4W8jvDXXcrldKsfkY/MMN5NLqtMEDb3Ukcm5HSoca
         Va3A==
X-Gm-Message-State: ANhLgQ0EBonFZ09rLISa3t+C4ChvNIuSk08qPrBPxJMikpSA+KRmq2/s
        sqYz8CBHTorGFnjxaI76VapwyW9OMgkdy5BYNEfhPVlxSUf86XhsE7p623M+5NZhgb0lGmU3fsE
        p/Jzbn91LEleR
X-Received: by 2002:a05:600c:581:: with SMTP id o1mr5113379wmd.111.1585048747382;
        Tue, 24 Mar 2020 04:19:07 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtXyFp93ixS0SdKYFgvGRSwDxD5NqQm7QdTATcvy69g/jxwWIl5BkMKFytFLvaIGtv/e8sHJg==
X-Received: by 2002:a05:600c:581:: with SMTP id o1mr5113351wmd.111.1585048747127;
        Tue, 24 Mar 2020 04:19:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id r18sm28608611wro.13.2020.03.24.04.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 04:19:06 -0700 (PDT)
Subject: Re: [PATCH v3 33/37] KVM: nVMX: Skip MMU sync on nested VMX
 transition when possible
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-34-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <51707375-51a6-637e-ebc5-f63f1c81f6b1@redhat.com>
Date:   Tue, 24 Mar 2020 12:19:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200320212833.3507-34-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/20 22:28, Sean Christopherson wrote:
> Skip the MMU sync when reusing a cached root if EPT is enabled or L1
> enabled VPID for L2.
> 
> If EPT is enabled, guest-physical mappings aren't flushed even if VPID
> is disabled, i.e. L1 can't expect stale TLB entries to be flushed if it
> has enabled EPT and L0 isn't shadowing PTEs (for L1 or L2) if L1 has
> EPT disabled.
> 
> If VPID is enabled (and EPT is disabled), then L1 can't expect stale TLB
> entries to be flushed (for itself or L2).
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Great, just a small rephrasing here and there:

/*
 * Returns true if the MMU needs to be sync'd on nested VM-Enter/VM-Exit.
 * tl;dr: the MMU needs a sync if L0 is using shadow paging and L1 didn't
 * enable VPID for L2 (implying it expects a TLB flush on VMX transitions).
 * Here's why.
 *
 * If EPT is enabled by L0 a sync is never needed:
 * - if it is disabled by L1, then L0 is not shadowing L1 or L2 PTEs, there
 *   cannot be unsync'd SPTEs for either L1 or L2.
 *
 * - if it is also enabled by L1, then L0 doesn't need to sync on VM-Enter
 *   VM-Enter as VM-Enter isn't required to invalidate guest-physical mappings
 *   (irrespective of VPID), i.e. L1 can't rely on the (virtual) CPU to flush
 *   stale guest-physical mappings for L2 from the TLB.  And as above, L0 isn't
 *   shadowing L1 PTEs so there are no unsync'd SPTEs to sync on VM-Exit.
 *
 * If EPT is disabled by L0:
 * - if VPID is enabled by L1 (for L2), the situation is similar to when L1
 *   enables EPT: L0 doesn't need to sync as VM-Enter and VM-Exit aren't
 *   required to invalidate linear mappings (EPT is disabled so there are
 *   no combined or guest-physical mappings), i.e. L1 can't rely on the
 *   (virtual) CPU to flush stale linear mappings for either L2 or itself (L1).
 *
 * - however if VPID is disabled by L1, then a sync is needed as L1 expects all
 *   linear mappings (EPT is disabled so there are no combined or guest-physical
 *   mappings) to be invalidated on both VM-Enter and VM-Exit.
 *
 * Note, this logic is subtly different than nested_has_guest_tlb_tag(), which
 * additionally checks that L2 has been assigned a VPID (when EPT is disabled).
 * Whether or not L2 has been assigned a VPID by L0 is irrelevant with respect
 * to L1's expectations, e.g. L0 needs to invalidate hardware TLB entries if L2
 * doesn't have a unique VPID to prevent reusing L1's entries (assuming L1 has
 * been assigned a VPID), but L0 doesn't need to do a MMU sync because L1
 * doesn't expect stale (virtual) TLB entries to be flushed, i.e. L1 doesn't
 * know that L0 will flush the TLB and so L1 will do INVVPID as needed to flush
 * stale TLB entries, at which point L0 will sync L2's MMU.
 */

Paolo

