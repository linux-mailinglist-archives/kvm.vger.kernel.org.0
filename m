Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2824A4A67
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 16:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379386AbiAaPUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 10:20:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378963AbiAaPUD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Jan 2022 10:20:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643642402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=51s/H7CPhdBcCYJZdO78Kl5hIb9+WtEbkmwC56ZgtGY=;
        b=Sum1lHBJ0VnnAGz2yO0MGSdZQh0r9tM6onGRLR8Zd2gMuxJwQviAB2UYZ/sSeFf7ldi2V7
        /75hHNTl+dL+Qa4WGwqpArbpTL3pr/tJGfyNtu1HU6q1JMx50IgkyAk7yQJ1OTmnXEUIL9
        S9FyeY1KTNcwA0DsGWNvYu627ZPXq2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-IYhhTc-eNS2u5b808v0H8A-1; Mon, 31 Jan 2022 10:19:59 -0500
X-MC-Unique: IYhhTc-eNS2u5b808v0H8A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A75DF1091DA3;
        Mon, 31 Jan 2022 15:19:56 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8477584D06;
        Mon, 31 Jan 2022 15:19:53 +0000 (UTC)
Message-ID: <864b41e42a88a92586b1c2361bebaf04446a98d5.camel@redhat.com>
Subject: Re: [PATCH 01/22] KVM: x86: Drop unnecessary and confusing
 KVM_X86_OP_NULL macro
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Date:   Mon, 31 Jan 2022 17:19:52 +0200
In-Reply-To: <6979e482-1f07-4148-b9d7-d91cfa98c081@redhat.com>
References: <20220128005208.4008533-1-seanjc@google.com>
         <20220128005208.4008533-2-seanjc@google.com>
         <152db376-b0f3-3102-233c-a0dbb4011d0c@redhat.com>
         <YfQO+ADS1wnefoSr@google.com>
         <6979e482-1f07-4148-b9d7-d91cfa98c081@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-01-31 at 15:56 +0100, Paolo Bonzini wrote:
> On 1/28/22 16:42, Sean Christopherson wrote:
> > On Fri, Jan 28, 2022, Paolo Bonzini wrote:
> > > On 1/28/22 01:51, Sean Christopherson wrote:
> > > > Drop KVM_X86_OP_NULL, which is superfluous and confusing.  The macro is
> > > > just a "pass-through" to KVM_X86_OP; it was added with the intent of
> > > > actually using it in the future, but that obviously never happened.  The
> > > > name is confusing because its intended use was to provide a way for
> > > > vendor implementations to specify a NULL pointer, and even if it were
> > > > used, wouldn't necessarily be synonymous with declaring a kvm_x86_op as
> > > > DEFINE_STATIC_CALL_NULL.
> > > > 
> > > > Lastly, actually using KVM_X86_OP_NULL as intended isn't a maintanable
> > > > approach, e.g. bleeds vendor details into common x86 code, and would
> > > > either be prone to bit rot or would require modifying common x86 code
> > > > when modifying a vendor implementation.
> > > 
> > > I have some patches that redefine KVM_X86_OP_NULL as "must be used with
> > > static_call_cond".  That's a more interesting definition, as it can be used
> > > to WARN if KVM_X86_OP is used with a NULL function pointer.
> > 
> > I'm skeptical that will actually work well and be maintainble.  E.g. sync_pir_to_ir()
> > must be explicitly check for NULL in apic_has_interrupt_for_ppr(), forcing that path
> > to do static_call_cond() will be odd.  Ditto for ops that are wired up to ioctl()s,
> > e.g. the confidential VM stuff, and for ops that are guarded by other stuff, e.g. the
> > hypervisor timer.
> > 
> > Actually, it won't just be odd, it will be impossible to disallow NULL a pointer
> > for KVM_X86_OP and require static_call_cond() for KVM_X86_OP_NULL.  static_call_cond()
> > forces the return to "void", so any path that returns a value needs to be manually
> > guarded and can't use static_call_cond(), e.g.
> 
> You're right and I should have looked up the series instead of going by 
> memory.  What I did was mostly WARNing on KVM_X86_OP that sets NULL, as 
> non-NULL ops are the common case.  I also added KVM_X86_OP_RET0 to 
> remove some checks on kvm_x86_ops for ops that return a value.
> 
> All in all I totally agree with patches 2-11 and will apply them (patch 
> 2 to 5.17 even, as a prerequisite to fix the AVIC race).  Several of 
> patches 13-21 are also mostly useful as it clarifies the code, and the 
> others I guess are okay in the context of a coherent series though 
> probably they would have been rejected as one-offs.  However, patches 12 
> and 22 are unnecessary uses of the C preprocessor in my opinion.
> 

I will send my patches very very soon - I'll rebase on top of this,
and review this patch series soon as well.

Best regards,
	Maxim Levitsky

> Paolo
> 


