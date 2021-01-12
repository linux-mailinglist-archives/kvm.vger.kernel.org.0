Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A22A2F376E
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 18:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390939AbhALRmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 12:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390844AbhALRmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 12:42:54 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4A5C061794
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 09:42:14 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id b3so1480936pft.3
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 09:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s31IkhAz2nWDObQ5y1qk010QUglbb2JaCz6paHFbgKE=;
        b=ua53268TZsH8TsHxFaEpE3Lg38Obz2bJP4oWXSdDQ3eDw2YOCRWhARGn0Rb1Rf0Auw
         TtLaGqIvDQcsU6PinS85yVOCI23qw0qdoAeiNyFCeUupmIvS/D0EwslofU1OfJp+5Nr9
         RdOfGVyn1o9B3rsJcU1JwJgn895dz+lxPubshGzX0GziRzBrnxat/6eNuHXzhumCQxfQ
         MNEgc4DQT0+5MeEzMPrYC7Dd4HPwoDJi9tgkfW5RAE0qNXK106rmLg9fsOT+om26SptI
         9wA1Gor3x2F4n27lSQ51xEL0motMhUf0C2EZi/42mJqUdH5myNu29lByLdWu6nZzqhKk
         b7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s31IkhAz2nWDObQ5y1qk010QUglbb2JaCz6paHFbgKE=;
        b=gEZQOen26NIt7XCC+nj9esVjQlDHAKf01rO63Ac0kEwOu5GwhJFTsgnHGaKjCfvsjO
         2oNrW9UJxES+O6KkyWwi7wDeSj4l0fmeqho8bqenDt5w0Ewqptbkt1aBqjMSwW3y6HaC
         pcC6nUuNVW7+cxMZBLngbdC0VcDb2zmKGzGEP5FZJTnMSkMA814xDRqxR7KHZeGu2imB
         P6pd4exX/cURl0j5FVhQKuLLG0wOVqNyKJjngjRi0eb7UsCOohTXdl4GXUS1LgI/2qlx
         +d5sLXccPXbPJqgiMl0SMiUS4zyFbB39tkbyBYU2nSmnbB+N/2LFE26/2YlL+vgP6gwu
         SncA==
X-Gm-Message-State: AOAM5305NH8//0JwTdezmIj4+23H0qPROI+2cHlcWaDUWC40kweGSER4
        cf4mpDU7EHSgnGfWcpcD0qo05g==
X-Google-Smtp-Source: ABdhPJzVO5KIL0Bbdp4cP/dveCjEiVGXuDYxY1LjLiCENCJSSZtyZGJ5CtUindfKmib6RkB3GMEZ8g==
X-Received: by 2002:a62:1896:0:b029:197:491c:be38 with SMTP id 144-20020a6218960000b0290197491cbe38mr246893pfy.15.1610473333520;
        Tue, 12 Jan 2021 09:42:13 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a23sm4163925pju.31.2021.01.12.09.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 09:42:12 -0800 (PST)
Date:   Tue, 12 Jan 2021 09:42:05 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, mlevitsk@redhat.com
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
Message-ID: <X/3fbaO1ZarMdjft@google.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
 <090232a9-7a87-beb9-1402-726bb7cab7e6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <090232a9-7a87-beb9-1402-726bb7cab7e6@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Paolo Bonzini wrote:
> On 12/01/21 07:37, Wei Huang wrote:
> >   static int gp_interception(struct vcpu_svm *svm)
> >   {
> >   	struct kvm_vcpu *vcpu = &svm->vcpu;
> >   	u32 error_code = svm->vmcb->control.exit_info_1;
> > -
> > -	WARN_ON_ONCE(!enable_vmware_backdoor);
> > +	int rc;
> >   	/*
> > -	 * VMware backdoor emulation on #GP interception only handles IN{S},
> > -	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
> > +	 * Only VMware backdoor and SVM VME errata are handled. Neither of
> > +	 * them has non-zero error codes.
> >   	 */
> >   	if (error_code) {
> >   		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> >   		return 1;
> >   	}
> > -	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
> > +
> > +	rc = kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
> > +	if (rc > 1)
> > +		rc = svm_emulate_vm_instr(vcpu, rc);
> > +	return rc;
> >   }
> 
> Passing back the third byte is quick hacky.  Instead of this change to
> kvm_emulate_instruction, I'd rather check the instruction bytes in
> gp_interception before calling kvm_emulate_instruction.

Agreed.  And I'd also prefer that any pure refactoring is done in separate
patch(es) so that the actual functional change is better isolated.

On a related topic, it feels like nested should be disabled by default on SVM
until it's truly ready for primetime, with the patch tagged for stable.  That
way we don't have to worry about crafting non-trivial fixes (like this one) to
make them backport-friendly.
