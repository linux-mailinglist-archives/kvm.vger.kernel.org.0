Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CA031EE77
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhBRShs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:37:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31262 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231461AbhBRSaa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 13:30:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613672942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=epfvCT9jrqIjj7Il6iW7EYzFb2mh6dSz2os3H/L544Q=;
        b=cK9i2BAOH/bU7A31lKPu8ia7c3Lxqy9rnQjA3fIG3bM+q3iULMBh2oxNkdJJjEPvfsdQcQ
        SfvhYUW3uDDZQHwb6noGdvWe1nPu7/C21IXVLSNvnUn9Hq19RKJfv/e0ZSwtPQAtCuUpvS
        JcmJjxHM8PlldBf2m5gCaZWaLmJQavg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-2ClHIsfpPr6kkfrqlXk9ew-1; Thu, 18 Feb 2021 13:29:00 -0500
X-MC-Unique: 2ClHIsfpPr6kkfrqlXk9ew-1
Received: by mail-wr1-f70.google.com with SMTP id q5so1305319wrs.20
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 10:29:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=epfvCT9jrqIjj7Il6iW7EYzFb2mh6dSz2os3H/L544Q=;
        b=YmUiiyeT2ROq27SaFwKRMKmiV2xvtpoVGxvYqcFC47qgC1irlBLiHA/Zb0nEH/KhTv
         8UfCeHMvYdm1HEEI8xhUj3KxjcfkvWXTW3F/LEv9AjEy1Vvnv77pSjM/I3oVi7io76RM
         CIcVIcAJAabawFv4aiOyexFSLHdUoEatXEbiY9Rij38MtwEoGqVIaIHCNz+oECijN0Hy
         CfmFF98HIFQGQ/MPxOjVNCEW73PYayZkFhHbUOKCtETeMjXSHKN2fMqH6RnLTmkXBYWM
         toF/1bfTTYXAj3DMDUc0fcFb9cbLxEUczsd9J/ih4PhtX0gvkrTgWMsoeNqpMOju5CZP
         rUkw==
X-Gm-Message-State: AOAM530LEqdC7lwxNReOnc2TLNCqOt/J5IBs6s+snlAxEgpSp8lJVpzG
        MQtApEZXuYX9r2nl/2JgOKWAmOYbWWRTNqBG+0XOlbXb43phDVneB4PpuIR2tkjcu3WCxtBWKt3
        4ExD7iydzoRox
X-Received: by 2002:adf:a4c8:: with SMTP id h8mr5713592wrb.286.1613672939537;
        Thu, 18 Feb 2021 10:28:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzH3Meos3s1fNj1v73OLg4ed8bjMQK5hBBhuPoMsOZj43SGrOpZoupj3jdijWQmjlXNAFf1Bw==
X-Received: by 2002:adf:a4c8:: with SMTP id h8mr5713576wrb.286.1613672939309;
        Thu, 18 Feb 2021 10:28:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d23sm9246030wmd.11.2021.02.18.10.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 10:28:58 -0800 (PST)
Subject: Re: [PATCH] KVM: nSVM: prepare guest save area while is_guest_mode is
 true
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jroedel@suse.de,
        mlevitsk@redhat.com
References: <20210218162831.1407616-1-pbonzini@redhat.com>
 <YC6m8xoRUDtn3V+y@google.com>
 <cf1b338c-68bc-6e7e-1a10-98bc653d34ce@redhat.com>
 <YC6uGgKgImRnuhTA@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <50bcc6e3-5f6e-32a3-6975-db7d857e88f3@redhat.com>
Date:   Thu, 18 Feb 2021 19:28:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC6uGgKgImRnuhTA@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/21 19:12, Sean Christopherson wrote:
>> Yeah, the problem is I don't understand why 06fc7772690d fixed things in 11
>> year old KVM instead of breaking them, because effectively this patch is
>> reverting it.
>
> 11 year old KVM didn't grab a different VMCB when updating the intercepts, it
> had already copied/merged L1's stuff to L0's VMCB, and then updated L0's VMCB
> regardless of is_nested().

Ok, so the bug was introduced when adding recalc_intercepts, which threw 
away the intercept manipulations that svm_set_cr0 had done in the 
meanwhile.  That's commit 384c63684397 ("KVM: SVM: Add function to 
recalculate intercept masks", 2011-01-12).

That piece of information makes me feel less uneasy about missing 
something.  recalc_intercepts has been there for a long time, but not as 
long as 06fc7772690d.

Paolo

