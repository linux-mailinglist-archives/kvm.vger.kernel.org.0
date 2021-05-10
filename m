Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5CD377DB5
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhEJIJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:09:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48951 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230093AbhEJIJs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620634123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tWO5o+mnEQWJee4xIdn8XNFfma6hcdcmtBS3JbLPDEk=;
        b=eb53sU2kh6h1nSmnTOkdUll3FQPiqqJehdisYMFHFAUcEmROJZc1NXdBZMNsTeKqk3C088
        pJfh/iR0Hh+BXdfr9Op25WNEeziG3LwaAztY2vRrJ4uUPN4/e/JNL3ubd/LTeb9GBmuHQA
        A4bp4zT/Lcw1x0rdWE/SLNNcBH2L/Yc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-smI0prXuOfmf0isDLk6MRg-1; Mon, 10 May 2021 04:08:40 -0400
X-MC-Unique: smI0prXuOfmf0isDLk6MRg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DB06107ACC7;
        Mon, 10 May 2021 08:08:39 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 483255D9F2;
        Mon, 10 May 2021 08:08:36 +0000 (UTC)
Message-ID: <4a4b9fea4937da7b0b42e6f3179566d73bf022e2.camel@redhat.com>
Subject: Re: [PATCH 03/15] KVM: SVM: Inject #UD on RDTSCP when it should be
 disabled in the guest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:08:34 +0300
In-Reply-To: <CALMp9eSSiPVWDf43Zed3+ukUc+NwMP8z7feoxX0eMmimvrznzA@mail.gmail.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-4-seanjc@google.com>
         <CALMp9eSvXRJm-KxCGKOkgPO=4wJPBi5wDFLbCCX91UtvGJ1qBg@mail.gmail.com>
         <YJHCadSIQ/cK/RAw@google.com>
         <1b50b090-2d6d-e13d-9532-e7195ebffe14@redhat.com>
         <CALMp9eSSiPVWDf43Zed3+ukUc+NwMP8z7feoxX0eMmimvrznzA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 14:58 -0700, Jim Mattson wrote:
> On Tue, May 4, 2021 at 2:57 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > On 04/05/21 23:53, Sean Christopherson wrote:
> > > > Does the right thing happen here if the vCPU is in guest mode when
> > > > userspace decides to toggle the CPUID.80000001H:EDX.RDTSCP bit on or
> > > > off?
> > > I hate our terminology.  By "guest mode", do you mean running the vCPU, or do
> > > you specifically mean running in L2?
> > > 
> > 
> > Guest mode should mean L2.
> > 
> > (I wonder if we should have a capability that says "KVM_SET_CPUID2 can
> > only be called prior to KVM_RUN").
> 
> It would certainly make it easier to reason about potential security issues.
> 
I vote too for this.
Best regards,
	Maxim Levitsky

