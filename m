Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 917A41537A4
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 19:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgBESVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 13:21:21 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31130 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728006AbgBESVU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 13:21:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580926879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=vIEOV+Yt6ZDVnc8nshj/6nUCGEuSxzTkZ+Yqa3oMuog=;
        b=SDA1/y2xZKwS7qp1RIlowHVOKkxAMM4wMOa4mJWEMHvWrdRrYYlNzGffbVIERSDrTzViPn
        opJUaYmcIBrFaPIoUE6xLznwsA/6h89007FU4Ec9NbMwNImIC2OtIDDsjTXGfXMwI/ofDv
        V6ooS+6E0SWO5nn7cglOGuvo44vetz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-mD0SzEAhP_G0Boyy0yRIpA-1; Wed, 05 Feb 2020 13:21:15 -0500
X-MC-Unique: mD0SzEAhP_G0Boyy0yRIpA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8426561269;
        Wed,  5 Feb 2020 18:21:14 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-186.ams2.redhat.com [10.36.116.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1696D790D4;
        Wed,  5 Feb 2020 18:21:09 +0000 (UTC)
Subject: Re: [RFCv2 30/37] KVM: s390: protvirt: Add diag 308 subcode 8 - 10
 handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-31-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6a751e3d-6e2b-4a80-ddda-d2126b5e0ade@redhat.com>
Date:   Wed, 5 Feb 2020 19:21:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-31-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> If the host initialized the Ultravisor, we can set stfle bit 161
> (protected virtual IPL enhancements facility), which indicates, that
> the IPL subcodes 8, 9 and are valid. These subcodes are used by a
> normal guest to set/retrieve a IPIB of type 5 and transition into
> protected mode.
> 
> Once in protected mode, the Ultravisor will conceal the facility
> bit. Therefore each boot into protected mode has to go through
> non-protected. There is no secure re-ipl with subcode 10 without a
> previous subcode 3.
> 
> In protected mode, there is no subcode 4 available, as the VM has no
> more access to its memory from non-protected mode. I.e. each IPL
> clears.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/diag.c     | 6 ++++++
>  arch/s390/kvm/kvm-s390.c | 5 +++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 3fb54ec2cf3e..b951dbdcb6a0 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -197,6 +197,12 @@ static int __diag_ipl_functions(struct kvm_vcpu *vcpu)
>  	case 4:
>  		vcpu->run->s390_reset_flags = 0;
>  		break;
> +	case 8:
> +	case 9:
> +	case 10:
> +		if (!test_kvm_facility(vcpu->kvm, 161))
> +			return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +		/* fall through */
>  	default:
>  		return -EOPNOTSUPP;

If we don't handle these diags in the kernel anyway, why do you care
about injecting the program interrupt from kernel space? Couldn't that
be done by userspace instead? I.e. could the whole hunk be dropped?

 Thomas

