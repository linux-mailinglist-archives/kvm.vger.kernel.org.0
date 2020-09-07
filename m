Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D4225FF5A
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 18:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgIGQa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 12:30:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44310 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730423AbgIGQam (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 12:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599496240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=503jdRShNeXJBj5etNIKp6BGryYcmN2VmjoESlRLKlM=;
        b=jNVqvpW9pyr1EKidk9wRVagTJAXP4SCSJILJt7RphhTym8TxyAT23r2m9pjsOwnd+MM28X
        oOPPHBwFKad5Wgz+8a1cT0prIE0qitG2r06g1F+vyvlaxAu3ehvP75v6n9ltlxJrtVhS+Q
        Vki6makjiZvr9QGi6YZXlIBbCleHC/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-Yt8nzi7aOWCn-soEKTch9g-1; Mon, 07 Sep 2020 12:30:38 -0400
X-MC-Unique: Yt8nzi7aOWCn-soEKTch9g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE50D800471;
        Mon,  7 Sep 2020 16:30:37 +0000 (UTC)
Received: from gondolin (ovpn-112-249.ams2.redhat.com [10.36.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7490510027AB;
        Mon,  7 Sep 2020 16:30:33 +0000 (UTC)
Date:   Mon, 7 Sep 2020 18:30:30 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2] KVM: s390: Introduce storage key removal facility
Message-ID: <20200907183030.07333af7.cohuck@redhat.com>
In-Reply-To: <20200907143352.96618-1-frankja@linux.ibm.com>
References: <b34e559a-8292-873f-8d33-1e7ce819f4d5@de.ibm.com>
        <20200907143352.96618-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  7 Sep 2020 10:33:52 -0400
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
> v2:
> 	* Removed the likely
> 	* Updated and re-shuffeled the comments which had the wrong information
> 
> ---
>  arch/s390/kvm/intercept.c | 40 ++++++++++++++++++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.c  |  5 +++++
>  arch/s390/kvm/priv.c      | 26 ++++++++++++++++++++++---
>  3 files changed, 67 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index e7a7c499a73f..983647ea2abe 100644
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
> @@ -565,7 +566,44 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>  		rc = handle_partial_execution(vcpu);
>  		break;
>  	case ICPT_KSS:
> -		rc = kvm_s390_skey_check_enable(vcpu);
> +		if (!test_kvm_facility(vcpu->kvm, 169)) {
> +			rc = kvm_s390_skey_check_enable(vcpu);
> +		} else {

<bikeshed>Introduce a helper function? This is getting a bit hard to
read.</bikeshed>

> +			/*
> +			 * Storage key removal facility emulation.
> +			 *
> +			 * KSS is the same priority as an instruction
> +			 * interception. Hence we need handling here
> +			 * and in the instruction emulation code.
> +			 *
> +			 * KSS is nullifying (no psw forward), SKRF
> +			 * issues suppressing SPECIAL OPS, so we need
> +			 * to forward by hand.
> +			 */
> +			switch (vcpu->arch.sie_block->ipa) {
> +			case 0xb2b2:
> +				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
> +				rc = kvm_s390_handle_b2(vcpu);
> +				break;
> +			case 0x8200:

Can we have speaking names? I can only guess that this is an lpsw...

> +				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
> +				rc = kvm_s390_handle_lpsw(vcpu);
> +				break;
> +			case 0:
> +				/*
> +				 * Interception caused by a key in a
> +				 * exception new PSW mask. The guest
> +				 * PSW has already been updated to the
> +				 * non-valid PSW so we only need to
> +				 * inject a PGM.
> +				 */
> +				rc = kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +				break;
> +			default:
> +				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
> +				rc = kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
> +			}
> +		}
>  		break;
>  	case ICPT_MCHKREQ:
>  	case ICPT_INT_ENABLE:

