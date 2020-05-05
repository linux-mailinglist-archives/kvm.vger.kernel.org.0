Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49061C504A
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 10:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgEEI3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 04:29:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35205 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728556AbgEEI3E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 04:29:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588667343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tEMlfqWVFKOqZSe1ugGA+hpEFb+mKSy4G8wcXNM339E=;
        b=a+ocrsWg11yqEHSsrYgCGXVoFZq1OTYLWKCDgx5wwc3EO2Kx8j/qg5ly+faqJz+TcAUn0+
        jfb0p4OJNmmaNA9OacdrRJKIj08LhltnooLVIA/llKihwkbPXgroXY8nHTh6BS8PRx++hr
        AR43mJoEWCRW7HCqGCJzbs2p99uY1bo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-KUyFRwldOyqJFNFqfSXowQ-1; Tue, 05 May 2020 04:28:59 -0400
X-MC-Unique: KUyFRwldOyqJFNFqfSXowQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65A9A107ACF5;
        Tue,  5 May 2020 08:28:58 +0000 (UTC)
Received: from gondolin (ovpn-112-219.ams2.redhat.com [10.36.112.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A3735D9D3;
        Tue,  5 May 2020 08:28:53 +0000 (UTC)
Date:   Tue, 5 May 2020 10:21:39 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Qian Cai <cailca@icloud.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: Remove false WARN_ON_ONCE for the PQAP
 instruction
Message-ID: <20200505101739.137393dc.cohuck@redhat.com>
In-Reply-To: <f3512a63-91dc-ab9a-a9ab-3e2a6e24fea3@de.ibm.com>
References: <20200505073525.2287-1-borntraeger@de.ibm.com>
        <20200505095332.528254e5.cohuck@redhat.com>
        <f3512a63-91dc-ab9a-a9ab-3e2a6e24fea3@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 5 May 2020 09:55:36 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 05.05.20 09:53, Cornelia Huck wrote:
> > On Tue,  5 May 2020 09:35:25 +0200
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> In LPAR we will only get an intercept for FC==3 for the PQAP
> >> instruction. Running nested under z/VM can result in other intercepts as
> >> well, for example PQAP(QCI). So the WARN_ON_ONCE is not right. Let
> >> us simply remove it.  
> > 
> > While I agree with removing the WARN_ON_ONCE, I'm wondering why z/VM
> > gives us intercepts for those fcs... is that just a result of nesting
> > (or the z/VM implementation), or is there anything we might want to do?  
> 
> Yes nesting. 
> The ECA bit for interpretion is an effective one. So if the ECA bit is off
> in z/VM (no crypto cards) our ECA bit is basically ignored as these bits
> are ANDed.

Ok, that makes sense, even if it is rather ugly.

With the comment tweaked,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>

> I asked Tony to ask the z/VM team if that is the case here.
> 
> >   
> >>
> >> Cc: Pierre Morel <pmorel@linux.ibm.com>
> >> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> >> Reported-by: Qian Cai <cailca@icloud.com>
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> ---
> >>  arch/s390/kvm/priv.c | 4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> >> index 69a824f9ef0b..bbe46c6aedbf 100644
> >> --- a/arch/s390/kvm/priv.c
> >> +++ b/arch/s390/kvm/priv.c
> >> @@ -626,10 +626,12 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
> >>  	 * available for the guest are AQIC and TAPQ with the t bit set
> >>  	 * since we do not set IC.3 (FIII) we currently will only intercept
> >>  	 * the AQIC function code.
> >> +	 * Note: running nested under z/VM can result in intercepts, e.g.  
> > 
> > s/intercepts/intercepts for other function codes/
> >   
> >> +	 * for PQAP(QCI). We do not support this and bail out.
> >>  	 */
> >>  	reg0 = vcpu->run->s.regs.gprs[0];
> >>  	fc = (reg0 >> 24) & 0xff;
> >> -	if (WARN_ON_ONCE(fc != 0x03))
> >> +	if (fc != 0x03)
> >>  		return -EOPNOTSUPP;
> >>  
> >>  	/* PQAP instruction is allowed for guest kernel only */  
> >   
> 

