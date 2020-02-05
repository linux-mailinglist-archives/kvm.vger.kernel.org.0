Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D12153246
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 14:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgBENuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 08:50:54 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27957 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726822AbgBENuy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 08:50:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580910652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GGAQOrIpQIhMs3J8XUYBIl+EiMIkUVPiFf/XyrmfzK0=;
        b=EtvVsh1TcwsRQltKKdo0f9K0rWNzUG38ItDybBN8ohCWOTBojBDEKzCTpVioczScRdTmGM
        1MPw1Z+L3mn/rsRomliIOHPjeBdDOns+LZrnUmkzstx09Lvvvlf5et4ixzanL/1+Qlx0lQ
        /AlASQFgQGc2JR+Ux42GvC7+driilT8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-cQy2GUdlPbmAYAsd37YIhQ-1; Wed, 05 Feb 2020 08:50:48 -0500
X-MC-Unique: cQy2GUdlPbmAYAsd37YIhQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BCA7800D54;
        Wed,  5 Feb 2020 13:50:47 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34F248CCC5;
        Wed,  5 Feb 2020 13:50:43 +0000 (UTC)
Date:   Wed, 5 Feb 2020 14:50:40 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 19/37] KVM: s390: protvirt: Handle spec exception loops
Message-ID: <20200205145040.4ed01a13.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-20-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-20-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:39 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> SIE intercept code 8 is used only on exception loops for protected
> guests. That means we need stop the guest when we see it.

s/need stop/need to stop/

...which is a task done by userspace?

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  arch/s390/kvm/intercept.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index c22214967214..d63f9cf10360 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -231,6 +231,13 @@ static int handle_prog(struct kvm_vcpu *vcpu)
>  
>  	vcpu->stat.exit_program_interruption++;
>  
> +	/*
> +	 * Intercept 8 indicates a loop of specification exceptions
> +	 * for protected guests

s/guests/guests./

> +	 */
> +	if (kvm_s390_pv_is_protected(vcpu->kvm))
> +		return -EOPNOTSUPP;
> +
>  	if (guestdbg_enabled(vcpu) && per_event(vcpu)) {
>  		rc = kvm_s390_handle_per_event(vcpu);
>  		if (rc)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

