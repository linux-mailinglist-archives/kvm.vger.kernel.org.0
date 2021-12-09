Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5870746E28D
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 07:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhLIGfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 01:35:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231567AbhLIGfr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 01:35:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639031533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YGxYW/i2o6T83DzUiYtpl0Te2wL7mcPMqolUgsjb37E=;
        b=SMPLFbckP9Ju6nTOjpmEiiK6jnQuiDKYBKXQYUQRxUXzcbGGjPaOH9jdNCZEsshGGlx72B
        X8M34xarzhHZzBvjL0kwAidB4k5JddcMl7zTKsUHoAf4BtrPK4Gck5TxGzl0r9GadrttYk
        ttY5KDmVlOKQp6zP5bNMgrpIVG9/v7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-_ueZzm7dNzCiGEkOdZx5OQ-1; Thu, 09 Dec 2021 01:32:08 -0500
X-MC-Unique: _ueZzm7dNzCiGEkOdZx5OQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 771B51006AA2;
        Thu,  9 Dec 2021 06:32:06 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 783FF19C59;
        Thu,  9 Dec 2021 06:31:57 +0000 (UTC)
Message-ID: <864db5fb7528c84b41bc6580eac2a9f1c3485721.camel@redhat.com>
Subject: Re: [PATCH v3 00/26] KVM: x86: Halt and APICv overhaul
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 09 Dec 2021 08:31:56 +0200
In-Reply-To: <YbFdwO3RZf6dg0M5@google.com>
References: <20211208015236.1616697-1-seanjc@google.com>
         <39c885fc6455dd0aa2f8643e725422851430f9ec.camel@redhat.com>
         <8c6c38f3cc201e42629c3b8e5cf8cdb251c9ea8d.camel@redhat.com>
         <YbFdwO3RZf6dg0M5@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-09 at 01:37 +0000, Sean Christopherson wrote:
> On Thu, Dec 09, 2021, Maxim Levitsky wrote:
> > On Thu, 2021-12-09 at 01:00 +0200, Maxim Levitsky wrote:
> > > Probably just luck (can't reproduce this anymore) but
> > > while running some kvm unit tests with this patch series (and few my patches
> > > for AVIC co-existance which shouldn't affect this) I got this
> > > 
> > > (warning about is_running already set)
> 
> ...
>  
> > Also got this while trying a VM with passed through device:
> 
> A tangentially related question: have you seen any mysterious crashes on your AMD
> system?  I've been bisecting (well, attempting to bisect) bizarre crashes that
> AFAICT showed up between v5.15 and v5.16-rc2.  Things like runqueues being NULL
> deep in the scheduler when a CPU is coming out of idle.  I _think_ the issues have
> been fixed as of v5.16-rc4, but I don't have a good reproducer so bisecting in
> either direction has been a complete mess.  I've reproduced on multiple AMD hosts,
> but never on an Intel system.  I have a sinking feeling that the issue is
> relatively unique to our systems :-/

I did had my 3970X lockup hard once on 5.16-rc2. It locked up completely without even
sending anything over a a pcie serial port card I. 

I don't remember what I was doing during the crash but probably had some VMs running.

Since then it didn't happen again, and I am running 5.16-rc3 for some time
with Paolo's kvm/queue merged and my own patches.

> 
> And a request: any testing and bug fixes you can throw at the AVIC changes would be
> greatly appreciated.  I've been partially blocked on testing the AVIC stuff for the
> better part of the week.  If the crashes I'm seeing have been resolved, then I should
> be able to help hunt down the issues, but if not...
> 

This is what I started doing last evening, and I'll go through all of the usual testing
I do soon.

Best regards,
	Maxim Levitsky

