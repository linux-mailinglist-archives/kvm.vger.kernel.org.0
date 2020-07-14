Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3B121F391
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 16:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgGNOMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 10:12:06 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22271 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725925AbgGNOMG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 10:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594735924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZlccC2VgtZKkvdcQsdEfleuqF4KQO54hAbgkXaUNTPI=;
        b=DVOYgKl1Cd58d/WLTa/Y3bvghMxFHHG5z1uyDpIEfv8MT3LytUMMCRB2/Lvv3U7l6rcZ00
        jdSg85RZqLU7oW/s3SHFFkQ3Qk4COqFBZjdrN6fCRolwkNmja3okwnvuQv9GAPGrRfyao2
        geYNNH0wztrifJ6flMfKvOrZocwJV3s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-wi-ghHxpPtqS_nH9OxJ1TA-1; Tue, 14 Jul 2020 10:11:56 -0400
X-MC-Unique: wi-ghHxpPtqS_nH9OxJ1TA-1
Received: by mail-wr1-f72.google.com with SMTP id j3so21960310wrq.9
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 07:11:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZlccC2VgtZKkvdcQsdEfleuqF4KQO54hAbgkXaUNTPI=;
        b=amgidzHGx8JvLCEskRPcl8/wpqRW+IpLUD8BLo1/rj223UEBZ2PvBtwjtU5ZUW+4nh
         M4HKmOb9oa3Ww/dpwZTtHLaiP4S6AkVxGkzGnxgHvUrWEuulbOPmvuzYInGLODL1nxh1
         yAp2dLYHxByg2dPRvW5K/C0oc0ZBmRLd+l7eEGYYTLqC3Xfd/dOZwxig/TUH/kXehEEr
         /DbCZJw3QiMuV5GoIhDfYBjOjMtEnG7HZGvL3OfSwEakmkAGIhzkr8GIDKBUCjFcbBd+
         0QQNuMjhc4whHhWfN8uuBWSk2ALXLO97PiSvCS5pdvKb8i2scPRzCMm/q3UwpDNzSC54
         33Ag==
X-Gm-Message-State: AOAM532z1DRQkL0sDHIZUNKf8DJzmw0OHEmih5bYXdNPbk3vVM484saR
        ibXcGHaiisuUigGj26le1uDLqrR0YCNqYDPAgGriCIuOK6pExqvr+T8gsyNz5mrsCFbKV3RbnMI
        LZTks8nmGKRcm
X-Received: by 2002:a5d:4d0b:: with SMTP id z11mr5778513wrt.24.1594735914910;
        Tue, 14 Jul 2020 07:11:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFEojZs2OzIsVnCpzb4g8z6CrvtNNpI2dcvnB21QDx6c3aUW+k3CIoXw7UXlBiYhbfOkNOJw==
X-Received: by 2002:a5d:4d0b:: with SMTP id z11mr5778479wrt.24.1594735914657;
        Tue, 14 Jul 2020 07:11:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b23sm5028357wmd.37.2020.07.14.07.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 07:11:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Don't attempt to load PDPTRs when 64-bit mode is enabled
In-Reply-To: <20200714132120.GA14404@linux.intel.com>
References: <20200714015732.32426-1-sean.j.christopherson@intel.com> <87wo36s3wb.fsf@vitty.brq.redhat.com> <20200714132120.GA14404@linux.intel.com>
Date:   Tue, 14 Jul 2020 16:11:50 +0200
Message-ID: <87tuyarxsp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Tue, Jul 14, 2020 at 02:00:04PM +0200, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> > index 95ef629228691..5f526d94c33f3 100644
>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> > @@ -819,22 +819,22 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>> >  	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
>> >  		return 1;
>> >  
>> > -	if (cr0 & X86_CR0_PG) {
>> >  #ifdef CONFIG_X86_64
>> > -		if (!is_paging(vcpu) && (vcpu->arch.efer & EFER_LME)) {
>> > -			int cs_db, cs_l;
>> > +	if ((vcpu->arch.efer & EFER_LME) && !is_paging(vcpu) &&
>> > +	    (cr0 & X86_CR0_PG)) {
>> 
>> it seems we have more than one occurance of "if (vcpu->arch.efer &
>> EFER_LME)" under "#ifdef CONFIG_X86_64" and we alredy have 
>> 
>> static inline int is_long_mode(struct kvm_vcpu *vcpu)
>> {
>> #ifdef CONFIG_X86_64
>>      return vcpu->arch.efer & EFER_LMA;
>> #else
>>      return 0;
>> #endif
>> }
>> 
>> so if we use this instead, the compilers will just throw away the
>> non-reachable blocks when !(#ifdef CONFIG_X86_64), right?
>
> EFER.LME vs. EFER.LMA.  The kvm_set_cr0() check is specifically looking at
> the case where EFER.LME=1, EFER.LMA=0, and CR0.PG is being toggled on, i.e.
> long mode is being enabled.  EFER_LMA won't be set until vmx_set_cr0() does
> enter_lmode().

Oops, shame on me :-(

Would it make sense to introduce something like is_long_mode()
(e.g. is_efer_lme()) for LME and #ifdef CONFIG_X86_64? I see the
same checks in vmx_set_cr0()/svm_set_cr0())?

-- 
Vitaly

