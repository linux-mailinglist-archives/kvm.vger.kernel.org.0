Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A01948524E
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 13:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbiAEMPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 07:15:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229966AbiAEMPq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 07:15:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641384945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8mehBaQ/gsLMjaKu2FQo9glLJ+6mgsmG8POvf2uFcBU=;
        b=OtVHELyajIwnni0fes9/6F9ycGFYN7FgDclqf8wK/+zXyk0R0tmhVwgkryE4cM8LjJ8Bd5
        6bxrocUGy5EcWGs9R1zk8gErDDD5bQZ/8xEiChtr0JFj12YZg+epHNOR9y9xW9QPAA4/Bm
        GT7ujUE8GXKE0OsclMv4O5zoq/mftAE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-kfGJN1MXN4WTJP8lIqUUgw-1; Wed, 05 Jan 2022 07:15:42 -0500
X-MC-Unique: kfGJN1MXN4WTJP8lIqUUgw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FCAE801962;
        Wed,  5 Jan 2022 12:15:41 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12CF9752DA;
        Wed,  5 Jan 2022 12:15:33 +0000 (UTC)
Message-ID: <2fdc37d84764c2fe1bd4063a2956b2101936f66a.camel@redhat.com>
Subject: Re: [PATCH v2 3/5] KVM: SVM: fix race between interrupt delivery
 and AVIC inhibition
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Wed, 05 Jan 2022 14:15:32 +0200
In-Reply-To: <ee5811a7-55a8-158a-7454-7166c045dbc3@redhat.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
         <20211213104634.199141-4-mlevitsk@redhat.com> <YdTPvdY6ysjXMpAU@google.com>
         <628ac6d9b16c6b3a2573f717df0d2417df7caddb.camel@redhat.com>
         <ee5811a7-55a8-158a-7454-7166c045dbc3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-01-05 at 12:54 +0100, Paolo Bonzini wrote:
> On 1/5/22 12:03, Maxim Levitsky wrote:
> > > Hmm, my preference would be to keep the "return -1" even though apicv_active must
> > > be rechecked.  That would help highlight that returning "failure" after this point
> > > is not an option as it would result in kvm_lapic_set_irr() being called twice.
> > I don't mind either - this will fix the tracepoint I recently added to report the
> > number of interrupts that were delivered by AVIC/APICv - with this patch,
> > all of them count as such.
> 
> Perhaps we can move the tracepoints in the delivery functions.  This 
> also makes them more precise in the rare case where apicv_active changes 
> in the middle of the function.

That is what I was thinking to do as well, but I don't mind returning the 'return -1' as well.
Best regards,
	Maxim Levitsky

> 
> Paolo
> 


