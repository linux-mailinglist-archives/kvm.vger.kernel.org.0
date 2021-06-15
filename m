Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B2A3A7981
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 10:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhFOIyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 04:54:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231454AbhFOIy3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 04:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623747145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VF/ZmfCbZXrtp/TxU+D0M+8nTPgnPSHywHQr9VpjZDY=;
        b=PUgVvDNWFp8ojklMOdJJj5PSYHnRNYM7qKEhwNdAadMkKvp9HLZk8zHx3P0xLyyMYnVKwB
        Ociv+CyhcFW+/k4d8nLMDYKSVHsHIz2sXkJF6JsRc9bv1iqMEw0OE2k6eGPNnMXSgaCr4j
        Io6d4xvdNVc0NXeXp1PYDDmrYyLo1gY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-8sVJgImbP4Kb1UVriXBcsg-1; Tue, 15 Jun 2021 04:52:24 -0400
X-MC-Unique: 8sVJgImbP4Kb1UVriXBcsg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E06BC79EEC;
        Tue, 15 Jun 2021 08:52:22 +0000 (UTC)
Received: from starship (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B20B5C1C2;
        Tue, 15 Jun 2021 08:52:21 +0000 (UTC)
Message-ID: <1f4d073cb58370f913a98cdb14127f9991356aa3.camel@redhat.com>
Subject: Re: [RFC] x86: Eliminate VM state changes during KVM_GET_MP_STATE
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>
Date:   Tue, 15 Jun 2021 11:52:20 +0300
In-Reply-To: <CALMp9eRXrXo3HznH7OnwRyPg3NKuH2FK720HYGADNfbWApQeAA@mail.gmail.com>
References: <CALMp9eRWBJQJBE2bxME6FzjhDOadNJW8wty7Gb=QJO8=ndaaEw@mail.gmail.com>
         <50c5d8c2-4849-2517-79c8-bd4e03fd36ad@redhat.com>
         <CALMp9eRXrXo3HznH7OnwRyPg3NKuH2FK720HYGADNfbWApQeAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-14 at 14:19 -0700, Jim Mattson wrote:
> On Fri, Jun 11, 2021 at 3:31 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > On 10/06/21 22:39, Jim Mattson wrote:
> > > But, even worse, it can modify guest memory,
> > > even while all vCPU threads are stopped!
> > 
> > To some extent this is a userspace issue---they could declare vCPU
> > threads stopped only after KVM_GET_MPSTATE is done, and only start the
> > downtime phase of migration after that.  But it is nevertheless a pretty
> > bad excuse.
> 
> I agree that this could be fixed by documenting the behavior. Since I
> don't think there's any existing documentation that says which ioctls
> can modify guest memory, such a documentation change wouldn't actually
> constitute an API breakage.
> 
> BTW, which ioctls can modify guest memory?
> 
> And, while we're at it, can we document the required orderings of the
> various _GET_ and _SET_ ioctls for save and restore?
> 

I strongly vote to make KVM_GET_MP_STATE not change guest state.
It will backfire one day.

Best regards,
	Maxim Levitsky

