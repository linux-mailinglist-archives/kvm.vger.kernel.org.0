Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5768F15381C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 19:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgBES1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 13:27:30 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34520 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727083AbgBES13 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 13:27:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580927248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=fXxp4VoicfKlJKYM9ZikW7Wp6/Hd9BmglmnEkZ1iRrU=;
        b=NiS6B2pWn+kE3wgZY4PFQpMhdfFmaLDKh+skcoPhSZVfY7exaeKixy4oREhQNjfho1ZJFL
        cJz7txPlcX4Gbu2xzojzUtajJzBR7PKzG+LEvaEnrAe4ZQj66KzqOS5I9SZdvBd04Ucfqi
        P5xZq1tP68QjXZsEtQxIhYunHdKOvzM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-Ho7BzVB6MjaYh3fQFyvJNg-1; Wed, 05 Feb 2020 13:27:25 -0500
X-MC-Unique: Ho7BzVB6MjaYh3fQFyvJNg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C05058018A1;
        Wed,  5 Feb 2020 18:27:23 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-186.ams2.redhat.com [10.36.116.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 233135C1B5;
        Wed,  5 Feb 2020 18:27:18 +0000 (UTC)
Subject: Re: [RFCv2 37/37] KVM: s390: protvirt: Add UV cpu reset calls
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-38-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <59cffd48-fa07-9a19-f797-cc6eb05f1ebb@redhat.com>
Date:   Wed, 5 Feb 2020 19:27:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-38-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> For protected VMs, the VCPU resets are done by the Ultravisor, as KVM
> has no access to the VCPU registers.
> 
> As the Ultravisor will only accept a call for the reset that is
> needed, we need to fence the UV calls when chaining resets.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 3e4716b3fc02..f7a3f84be064 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4699,6 +4699,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	void __user *argp = (void __user *)arg;
>  	int idx;
>  	long r;
> +	u32 ret;

I'd maybe name it "uvret" instead to avoid that it gets mixed up easily
with the "r" variable.

Anyway,
Reviewed-by: Thomas Huth <thuth@redhat.com>

