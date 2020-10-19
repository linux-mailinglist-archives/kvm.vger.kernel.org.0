Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33334292B27
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 18:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgJSQIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 12:08:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730390AbgJSQIw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 12:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603123731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eMZNW63fDz7EDSDZ18r4MBI7oylTEa1aljU9Ijzvo5Y=;
        b=X78eCQF1U+LwN/+7xXn7PNzlGVy1tNr6b7rrchlj0OahyYDw8qZfInNBXYRHl0YDhxz6Ld
        NEDE24cK4bGAUTMu8lt7l+kn97qo5phuQNlBHTlcprg72m8VdexILYCUIHuUTH81v31Bni
        hRLh/Dx8L944mHH5K8713vYz1NI/avY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-oqD8khmrOfamQStD1rO_Rw-1; Mon, 19 Oct 2020 12:08:49 -0400
X-MC-Unique: oqD8khmrOfamQStD1rO_Rw-1
Received: by mail-wr1-f71.google.com with SMTP id v5so75167wrr.0
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 09:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eMZNW63fDz7EDSDZ18r4MBI7oylTEa1aljU9Ijzvo5Y=;
        b=rzHz04lX36o6iZvJ1V6x0uoW/fZnEcjN9knHIdWVHOL0GU4z2PTxB9+8XEAEo2Glum
         hndNmL1s62poW4+Ppha356ra7jps+KRLV9da+tOereSoCD2u85VbTLoQFOXJWbePWp7E
         SeukoqsSz75OZD76vkJUqWX86gJUtVmHKCDdDMHlSoKIuw8sbPzWOHq/FYPfa0LKz24l
         RYbOGkD4GM8vHNNXGtRm0COVekduuoK3qBP0oda/GqjhEFRTe5Dj6hk8/q3+txul/X0i
         5la0R50ZEhfmhpfjBzL0ZfMW5Y3wNvrmPiZlN5XEgXsKtDvot4u4stKhUnd4xr8ugfU3
         L/2g==
X-Gm-Message-State: AOAM533Xp9G6dmXio1dtUO1JcZlHr0j8FlIsP0/9qeb6ZBGPGpdz106s
        LrtKCqgROdITMBEKTyvl4QK0Jm8Be+t/yql8CBkT1yA4/ScbRVmAb4HyGpi64mAaGh1zwneN5IR
        xnbb73JiEmbhX
X-Received: by 2002:a05:6000:107:: with SMTP id o7mr289951wrx.354.1603123728725;
        Mon, 19 Oct 2020 09:08:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1PNLCPMogczCfCNdeJGwBMq2XQ5aWVpDVGteGvzDOpvytEwbfRxe6gmlxpE6Q37RFzr2S9g==
X-Received: by 2002:a05:6000:107:: with SMTP id o7mr289927wrx.354.1603123728474;
        Mon, 19 Oct 2020 09:08:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j134sm76231wmj.7.2020.10.19.09.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 09:08:47 -0700 (PDT)
Subject: Re: [PATCH 0/4 v3] KVM: nSVM: Add checks for CR3 and CR4 reserved
 bits to svm_set_nested_state() and test CR3 non-MBZ reserved bits
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com
References: <20201006190654.32305-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <83ef9fe9-458c-2856-2eef-3dd9e6bdbe8b@redhat.com>
Date:   Mon, 19 Oct 2020 18:08:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201006190654.32305-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/20 21:06, Krish Sadhukhan wrote:
> v2 -> v3:
> 	Patch# 2: The local variable "nested_vmcb_lma" in
> 		  nested_vmcb_check_cr3_cr4() has been removed.
> 	Patch# 3: Commit message has been enhanced to explain what the test
> 		  is doing and why, when testing the 1-setting of the
> 		  non-MBZ-reserved bits.
> 		  Also, the test for legacy-PAE mode has been added. Commit
> 		  header reflects this addition.
> 
> 
> [PATCH 1/4 v3] KVM: nSVM: CR3 MBZ bits are only 63:52
> [PATCH 2/4 v3] KVM: nSVM: Add check for reserved bits for CR3, CR4, DR6,
> [PATCH 3/4 v3] nSVM: Test non-MBZ reserved bits in CR3 in long mode and
> [PATCH 4/4 v3] KVM: nSVM: nested_vmcb_checks() needs to check all bits
> 
>  arch/x86/kvm/svm/nested.c | 52 ++++++++++++++++++++++++++---------------------
>  arch/x86/kvm/svm/svm.h    |  2 +-
>  2 files changed, 30 insertions(+), 24 deletions(-)
> 
> Krish Sadhukhan (3):
>       KVM: nSVM: CR3 MBZ bits are only 63:52
>       KVM: nSVM: Add check for reserved bits for CR3, CR4, DR6, DR7 and EFER to svm_set_nested_state()
>       KVM: nSVM: nested_vmcb_checks() needs to check all bits of EFER
> 
>  x86/svm.h       |  4 +++-
>  x86/svm_tests.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 63 insertions(+), 7 deletions(-)
> 
> Krish Sadhukhan (1):
>       nSVM: Test non-MBZ reserved bits in CR3 in long mode and legacy PAE mode
> 

Queued, but I don't really like the duplication in patch 2 so I'll
probably punt it to 5.11 and fix it up.

Paolo

