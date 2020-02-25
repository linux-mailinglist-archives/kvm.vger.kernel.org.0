Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2F216C206
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 14:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgBYNWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 08:22:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44616 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726019AbgBYNWC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 08:22:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582636920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CgI9By+dCauhTHrpAeBQ1fw90ZTTslYyf1B2IVkbd0A=;
        b=KcHywfa5w/LsUdRNLJQTmdePsG1HuscwRb8OLzpmTOoI/HGLT8R787SC+8Ap29NUeastCT
        rxvsq0Tq6yhODgV63z/8qpXHeCxOLuiCr7so7U55P9exIXOnxXeF0QY6tsWqeQmMUpamPa
        biB/jiFJYdewvCq2xzXOsbgcLrNSfeI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-09j1IEN5PcKWY58LJ4Sn-w-1; Tue, 25 Feb 2020 08:21:56 -0500
X-MC-Unique: 09j1IEN5PcKWY58LJ4Sn-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 300CA107ACC5;
        Tue, 25 Feb 2020 13:21:55 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 942DF60BF7;
        Tue, 25 Feb 2020 13:21:50 +0000 (UTC)
Date:   Tue, 25 Feb 2020 14:21:29 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 29/36] KVM: s390: protvirt: Support cmd 5 operation
 state
Message-ID: <20200225142129.4e525ec6.cohuck@redhat.com>
In-Reply-To: <60d428de-4fd2-ae13-ddad-5a7399290063@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-30-borntraeger@de.ibm.com>
        <99363e0d-494b-59ab-93dd-ccda4f25ef6d@redhat.com>
        <60d428de-4fd2-ae13-ddad-5a7399290063@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 08:53:01 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 24.02.20 20:08, David Hildenbrand wrote:
> > On 24.02.20 12:41, Christian Borntraeger wrote:  
> >> From: Janosch Frank <frankja@linux.ibm.com>
> >>
> >> Code 5 for the set cpu state UV call tells the UV to load a PSW from
> >> the SE header (first IPL) or from guest location 0x0 (diag 308 subcode
> >> 0/1). Also it sets the cpu into operating state afterwards, so we can
> >> start it.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> Reviewed-by: Thomas Huth <thuth@redhat.com>
> >> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> >> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> ---
> >>  arch/s390/include/asm/uv.h | 1 +
> >>  arch/s390/kvm/kvm-s390.c   | 6 ++++++
> >>  2 files changed, 7 insertions(+)
> >>
> >> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> >> index 99e1a14ef909..4945e44e1528 100644
> >> --- a/arch/s390/include/asm/uv.h
> >> +++ b/arch/s390/include/asm/uv.h
> >> @@ -169,6 +169,7 @@ struct uv_cb_unp {
> >>  #define PV_CPU_STATE_OPR	1
> >>  #define PV_CPU_STATE_STP	2
> >>  #define PV_CPU_STATE_CHKSTP	3
> >> +#define PV_CPU_STATE_OPR_LOAD	5
> >>  
> >>  struct uv_cb_cpu_set_state {
> >>  	struct uv_cb_header header;
> >> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> >> index f10cce6fc5e0..9c0ab66128fd 100644
> >> --- a/arch/s390/kvm/kvm-s390.c
> >> +++ b/arch/s390/kvm/kvm-s390.c
> >> @@ -3728,6 +3728,12 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >>  		rc = kvm_s390_vcpu_start(vcpu);
> >>  		break;
> >>  	case KVM_MP_STATE_LOAD:
> >> +		if (!kvm_s390_pv_cpu_is_protected(vcpu)) {
> >> +			rc = -ENXIO;
> >> +			break;
> >> +		}
> >> +		rc = kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR_LOAD);
> >> +		break;
> >>  	case KVM_MP_STATE_CHECK_STOP:
> >>  		/* fall through - CHECK_STOP and LOAD are not supported yet */
> >>  	default:
> >>  
> > 
> > Fits in nicely :)
> > 
> > Reviewed-by: David Hildenbrand <david@redhat.com>  
> 
> Thanks. FWIW, I will drop Thomas and Conny RB as this was for the older version.

You can have mine back:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

