Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EA9391A8F
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhEZOqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:46:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234737AbhEZOqD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 10:46:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622040271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y4JlXUoqOIqKnobUh41tn3vEh7dafg2XJZ7ppKxkYSI=;
        b=FIYWJsNdDJzER44BqS/mWzM7nKDtGpJZ5+V3TZbmNLCP3NMpWuQwzQ1/rx768ND5IIfY6K
        v+pOiAfjyaO7jNDnqrjBeiGeQbQyNIgabGrbV0Z/Mrc/5fHxHjlMEmoSGu66lsh/u034ie
        EC+hkxDlVqS2pQnGBXNwkaMxZZFHi8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-H7Jsr9rvMuuIzGU6AgnbEQ-1; Wed, 26 May 2021 10:44:28 -0400
X-MC-Unique: H7Jsr9rvMuuIzGU6AgnbEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E60510CE781;
        Wed, 26 May 2021 14:44:27 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0227B5C238;
        Wed, 26 May 2021 14:44:24 +0000 (UTC)
Message-ID: <c67f25392377819e4bb38595e58f5aa6f2e12206.camel@redhat.com>
Subject: Re: [PATCH v2 3/7] KVM: nVMX: Ignore 'hv_clean_fields' data when
 eVMCS data is copied in vmx_get_nested_state()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 26 May 2021 17:44:23 +0300
In-Reply-To: <d049467a-e2a9-d888-4217-9261eec4a40b@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
         <20210517135054.1914802-4-vkuznets@redhat.com>
         <48f7950dd6504a9ecc7a5209db264587958cafdf.camel@redhat.com>
         <87zgwk5lqy.fsf@vitty.brq.redhat.com>
         <d049467a-e2a9-d888-4217-9261eec4a40b@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-24 at 15:58 +0200, Paolo Bonzini wrote:
> On 24/05/21 15:01, Vitaly Kuznetsov wrote:
> > With 'need_vmcs12_to_shadow_sync', we treat eVMCS as shadow VMCS which
> > happens to shadow all fields and while it may not be the most optimal
> > solution, it is at least easy to comprehend. We can try drafting
> > something up instead, maybe it will also be good but honestly I'm afraid
> > of incompatible changes in KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE, we
> > can ask Paolo's opinion on that.
> 
> Yes, it's much easier to understand it if the eVMCS is essentially a 
> memory-backed shadow VMCS, than if it's really the vmcs12 format.  I 
> understand that it's bound to be a little slower, but at least the two 
> formats are not all over the place.
> 
> Paolo
> 

Hi!

Please see my other reply to this in patch 1.
 
I understand this concern, but what bugs me is that we sort of 
shouldn't read evmcs while L1 is running.
(e.g its clean bits might be not up to date and
such).
 
Actually instead of thinking of evmcs as a shadow, I am thinking of it
more as a vmcb12 (the SVM one), 
which we load when we do a nested entry and which is then
updated when we do a nested vmexit, and other than that, while
L1 is running, we don't touch it.
 
Yes there is that vm instruction error field in evmcs which I suppose we should
write when we fail a VMX instruction (invept only practically I think) 
while we just run L1, and even that we might just avoid doing, 
which will allow us to avoid even keeping
the evmcs mapped while L1 is running.

Just my 0.2 cents.

Best regards,
	Maxim Levitsky

