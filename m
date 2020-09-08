Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8501626106D
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 13:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgIHLGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 07:06:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41568 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729538AbgIHLBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 07:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599562889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j8FrwxyoS3UOPyBBrpb+SxDIPN8JxjKtNQqfng3d1cU=;
        b=En7u8b6qSZhI0g/rqL/UwJH2875C5eti2iyfIiZu8Z/HhOC7IAef5v0T6FzahwHe30ZyxY
        PWr/bE6hKMORWGK4F0HcfRHtmjyPlBCAa/YOtiuQEQnmIc6z97ptqpHhHUoFwBqPXUcNXy
        25ZHPxInLEIwpJfaDJ5lznckqICv4jY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-cgHk6IHIN264oiUSOu8L1w-1; Tue, 08 Sep 2020 07:01:27 -0400
X-MC-Unique: cgHk6IHIN264oiUSOu8L1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A5A110BBECD;
        Tue,  8 Sep 2020 11:01:26 +0000 (UTC)
Received: from gondolin (ovpn-112-243.ams2.redhat.com [10.36.112.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DBBC27CC2;
        Tue,  8 Sep 2020 11:01:20 +0000 (UTC)
Date:   Tue, 8 Sep 2020 13:01:17 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3] KVM: s390: Introduce storage key removal facility
Message-ID: <20200908130117.1a8fd4ea.cohuck@redhat.com>
In-Reply-To: <20200908100249.23150-1-frankja@linux.ibm.com>
References: <20200908100249.23150-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  8 Sep 2020 06:02:49 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> The storage key removal facility makes skey related instructions
> result in special operation program exceptions. It is based on the
> Keyless Subset Facility.
> 
> The usual suspects are iske, sske, rrbe and their respective
> variants. lpsw(e), pfmf and tprot can also specify a key and essa with
> an ORC of 4 will consult the change bit, hence they all result in
> exceptions.
> 
> Unfortunately storage keys were so essential to the architecture, that
> there is no facility bit that we could deactivate. That's why the
> removal facility (bit 169) was introduced which makes it necessary,
> that, if active, the skey related facilities 10, 14, 66, 145 and 149
> are zero. Managing this requirement and migratability has to be done
> in userspace, as KVM does not check the facilities it receives to be
> able to easily implement userspace emulation.
> 
> Removing storage key support allows us to circumvent complicated
> emulation code and makes huge page support tremendously easier.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
> 
> v3:
> 	* Put kss handling into own function
> 	* Removed some unneeded catch statements and converted others to ifs
> 
> v2:
> 	* Removed the likely
> 	* Updated and re-shuffeled the comments which had the wrong information
> 
> ---
>  arch/s390/kvm/intercept.c | 34 +++++++++++++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.c  |  5 +++++
>  arch/s390/kvm/priv.c      | 26 +++++++++++++++++++++++---
>  3 files changed, 61 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index e7a7c499a73f..9c699c3fcf84 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -33,6 +33,7 @@ u8 kvm_s390_get_ilen(struct kvm_vcpu *vcpu)
>  	case ICPT_OPEREXC:
>  	case ICPT_PARTEXEC:
>  	case ICPT_IOINST:
> +	case ICPT_KSS:
>  		/* instruction only stored for these icptcodes */
>  		ilen = insn_length(vcpu->arch.sie_block->ipa >> 8);
>  		/* Use the length of the EXECUTE instruction if necessary */
> @@ -531,6 +532,37 @@ static int handle_pv_notification(struct kvm_vcpu *vcpu)
>  	return handle_instruction(vcpu);
>  }
>  
> +static int handle_kss(struct kvm_vcpu *vcpu)
> +{
> +	if (!test_kvm_facility(vcpu->kvm, 169))
> +		return kvm_s390_skey_check_enable(vcpu);
> +
> +	/*
> +	 * Storage key removal facility emulation.
> +	 *
> +	 * KSS is the same priority as an instruction
> +	 * interception. Hence we need handling here

s/here/both here/ ?

(I think you can also format this slightly wider, now that indentation
is not so deep anymore.)

> +	 * and in the instruction emulation code.
> +	 *
> +	 * KSS is nullifying (no psw forward), SKRF
> +	 * issues suppressing SPECIAL OPS, so we need
> +	 * to forward by hand.
> +	 */
> +	if  (vcpu->arch.sie_block->ipa == 0) {
> +		/*
> +		 * Interception caused by a key in a
> +		 * exception new PSW mask. The guest
> +		 * PSW has already been updated to the
> +		 * non-valid PSW so we only need to
> +		 * inject a PGM.
> +		 */
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +	}
> +
> +	kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
> +	return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
> +}
> +
>  int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>  {
>  	int rc, per_rc = 0;
> @@ -565,7 +597,7 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>  		rc = handle_partial_execution(vcpu);
>  		break;
>  	case ICPT_KSS:
> -		rc = kvm_s390_skey_check_enable(vcpu);
> +		rc = handle_kss(vcpu);
>  		break;
>  	case ICPT_MCHKREQ:
>  	case ICPT_INT_ENABLE:

(...)

> @@ -257,7 +264,7 @@ static int handle_iske(struct kvm_vcpu *vcpu)
>  
>  	rc = try_handle_skey(vcpu);
>  	if (rc)
> -		return rc != -EAGAIN ? rc : 0;
> +		return (rc != -EAGAIN || rc != -EOPNOTSUPP) ? rc : 0;

As noticed by David, this probably needs to be &&, or maybe flipped to

		return (rc == -EAGAIN || rc == -EOPNOTSUPP) ? 0 : rc;

>  
>  	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
>  

