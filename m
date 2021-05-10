Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA5D378FAA
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 15:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhEJNwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 09:52:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241430AbhEJNoo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:44:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620654215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3qs5hhTBmGLNt171y/zFd6driJ4EbuYK+YqvBlVy3w=;
        b=JirE+mUFV5zr264J4fdsRca8SGTCTB3UG/hZab1H2vAP88883yC1zoNw0SHoPDjktwXXMS
        /1bCdR5yHyEFAtTjlmfHaTQYchIQAjGrWqjrg2/rgfv8d4wIyMEOLuLYQFTUmHpD0aC6DA
        R19NN2ctFYRjslvdZYzw5zOU6UhRg+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-wp_aSLcHMs6jRc8VaXPXFw-1; Mon, 10 May 2021 09:43:32 -0400
X-MC-Unique: wp_aSLcHMs6jRc8VaXPXFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 535E0189C440;
        Mon, 10 May 2021 13:43:31 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED4C82C14A;
        Mon, 10 May 2021 13:43:23 +0000 (UTC)
Message-ID: <132ed17999bd1464c6c43fbe4e7933ce7cc9eeb9.camel@redhat.com>
Subject: Re: [PATCH 0/8] KVM: VMX: Implement nested TSC scaling
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Stamatis, Ilias" <ilstam@amazon.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "ilstam@mailbox.org" <ilstam@mailbox.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Date:   Mon, 10 May 2021 16:43:22 +0300
In-Reply-To: <fccb8b01aadfb7e53f8711100bc10dc1c98c5cd5.camel@amazon.com>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <CALMp9eSNHf=vmqeer+ZkRa3NhJoLMbEO+OZJaG9qf+2+TQ2grA@mail.gmail.com>
         <fccb8b01aadfb7e53f8711100bc10dc1c98c5cd5.camel@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-06 at 17:48 +0000, Stamatis, Ilias wrote:
> On Thu, 2021-05-06 at 10:16 -0700, Jim Mattson wrote:
> > On Thu, May 6, 2021 at 3:34 AM <ilstam@mailbox.org> wrote:
> > > From: Ilias Stamatis <ilstam@amazon.com>
> > > 
> > > KVM currently supports hardware-assisted TSC scaling but only for L1
> > > and it
> > > doesn't expose the feature to nested guests. This patch series adds
> > > support for
> > > nested TSC scaling and allows both L1 and L2 to be scaled with
> > > different
> > > scaling factors.
> > > 
> > > When scaling and offsetting is applied, the TSC for the guest is
> > > calculated as:
> > > 
> > > (TSC * multiplier >> 48) + offset
> > > 
> > > With nested scaling the values in VMCS01 and VMCS12 need to be
> > > merged
> > > together and stored in VMCS02.
> > > 
> > > The VMCS02 values are calculated as follows:
> > > 
> > > offset_02 = ((offset_01 * mult_12) >> 48) + offset_12
> > > mult_02 = (mult_01 * mult_12) >> 48
> > > 
> > > The last patch of the series adds a KVM selftest.
> > 
> > Will you be doing the same for SVM? The last time I tried to add a
> > nested virtualization feature for Intel only, Paolo rapped my knuckles
> > with a ruler.
> 
> Yes, I can try do this, if it's not much more complicated, once I get
> access to AMD hardware. 

I have access to AMD hardware with regular TSC scaling,
and nested TSC scaling IMHO won't be hard for me to implement 
so I volunteer for this task! 


Best regards,
	Maxim Levitsky

> 
> But I suppose this series is standalone and could be merged separately?
> By taking a quick look it seems that SVM exposes far less features to
> nested guests than VMX does anyway.
> 
> Ilias


