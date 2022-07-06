Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500DA568F84
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbiGFQp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 12:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiGFQpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 12:45:24 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D625428E20
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 09:45:22 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id fz10so9641237pjb.2
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 09:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8qMqNPKdwEB+Xj55W1lFVgPi5kuDOPaSuG9HBIEp++0=;
        b=LmnZ/QbsPiVvbhlR+0zsAWB1dPXgA0N55j2iDxMMu/VF/aLnqXjS2x+LtThefPrNT5
         D50MgQKn+2JgIuBjTsjA2UHACE+WUmOI53oXTyK9ZGWjOCHBcvohtRS/+HBFuagKYQDk
         td1tya88QXz2LPsV8ZOV7r0W46UqVOqh4zo2C/bRTrW8Y+yFSjziQhUgnRb573WyqlHG
         2UCpaF24qJwnhq6xXUUAbaKhmE7JXf/Sr1UWmCDss4rESRHxiOAnI75HsolAgrTiiXQo
         qyQL37dwX16wyKc32eB6XoUb1pRntRYX0eR08vMMgUa+krX7ZzxztJg+gX+hmoml8L52
         HebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8qMqNPKdwEB+Xj55W1lFVgPi5kuDOPaSuG9HBIEp++0=;
        b=06X4SsG3Uglrw0nbtlQRweKyn9fYyVbjy0RaCnd3KmdHHJOgV7vnFAN5ze9FRQNjSW
         uCVHWZYwMO4QtPnGlPuKMl8S0ntySVZMrUW4SjsFs4FtTsBn2JThZPNlazl9KxMgQ+1s
         36KpgsK51du1zv4hxnk9KVGRD3bXQ/eqsDOfkvRQphqvw9ZvI1HFO5wQjSh9yjl+4ImA
         uUjasPPcrYrsIuP2V3e3G73YVgr0w6B20ewMTjmlb5A0iSFvy9TN88PAcifE90SFg4lg
         dwxnke3BEcynXHSiqSeB1YIXFGzxW1i+irUjC9DcjJh4Fx1mrUVSVjuemnrsBDpj38Be
         clVA==
X-Gm-Message-State: AJIora8E2Y+VQM0XnJpUPOTeLgTd7jt59f3nvp3qwG9g58YmWgR5BKNB
        GAKmLlwA8yo3LLG8Rx/BczVFPA==
X-Google-Smtp-Source: AGRyM1sTasdxEfmgq5i+f38pCD1K7Ikdjn0kmJ10W4PbQjK+Jxjw+EkUnz+pSaD/hHsOxyhR1U0sWg==
X-Received: by 2002:a17:902:f543:b0:16a:54c6:78c0 with SMTP id h3-20020a170902f54300b0016a54c678c0mr46544913plf.22.1657125921966;
        Wed, 06 Jul 2022 09:45:21 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id p22-20020a1709027ed600b0016a0fe1a1fbsm26057570plb.220.2022.07.06.09.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 09:45:21 -0700 (PDT)
Date:   Wed, 6 Jul 2022 16:45:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 09/21] KVM: nVMX: Unconditionally clear mtf_pending on
 nested VM-Exit
Message-ID: <YsW8He/1b1xBWLwz@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
 <20220614204730.3359543-10-seanjc@google.com>
 <599b352e16c970885d3f6bfaf7d1a254627ef5dd.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <599b352e16c970885d3f6bfaf7d1a254627ef5dd.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022, Maxim Levitsky wrote:
> On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> > Clear mtf_pending on nested VM-Exit instead of handling the clear on a
> > case-by-case basis in vmx_check_nested_events().  The pending MTF should
> > rever survive nested VM-Exit, as it is a property of KVM's run of the
> ^^ typo: never
> 
> Also it is not clear what the 'case by case' means.
> 
> I see that the vmx_check_nested_events always clears it unless nested run is pending
> or we re-inject an event.

Those two "unless ..." are the "cases".  The point I'm trying to make in the changelog
is that there's no need for any conditional logic whatsoever.

> > @@ -3927,6 +3919,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >  		clear_bit(KVM_APIC_INIT, &apic->pending_events);
> >  		if (vcpu->arch.mp_state != KVM_MP_STATE_INIT_RECEIVED)
> >  			nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
> > +
> > +		/* MTF is discarded if the vCPU is in WFS. */
> > +		vmx->nested.mtf_pending = false;
> >  		return 0;
> 
> I guess MTF should also be discarded if we enter SMM, and I see that
> VMX also enter SMM with a pseudo VM exit (in vmx_enter_smm) which
> will clear the MTF. Good.

No, a pending MTF should be preserved across SMI.  It's not a regression because
KVM incorrectly prioritizes MTF (and trap-like #DBs) over SMI (and because if KVM
did prioritize SMI, the existing code would also drop the pending MTF).  Note, this
isn't the only flaw that needs to be addressed in order to correctly prioritize SMIs,
e.g. KVM_{G,S}ET_NESTED_STATE would need to save/restore a pending MTF if the vCPU is
in SMM after an SMI that arrived while L2 was active.

Tangentially related, KVM's pseudo VM-Exit on SMI emulation is completely wrong[*].

[*] https://lore.kernel.org/all/Yobt1XwOfb5M6Dfa@google.com
