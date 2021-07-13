Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406CF3C72BA
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 16:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbhGMPCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 11:02:42 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39510 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236842AbhGMPCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 11:02:42 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7E8B1201E7;
        Tue, 13 Jul 2021 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626188391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eL5IrFxsIN1jnfrXU2pE4OpwDjD9EGxR+WrOd4Q3RU8=;
        b=VhG1AXrU9yAsywr78nLJyrkOYj4FyvRCtA3J1G2pKQ/3A7+0jRpwyai3y9Pk6ApsqNB4MN
        B0xTJRDVytiDcuuqFaVjTak0UuwCmf7/9Kp6JsU7hioKQGko+RaKAKxl2c0CB53I7BB4SW
        s+N6RP+aumRg9XFPK9WpO+f53cniAjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626188391;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eL5IrFxsIN1jnfrXU2pE4OpwDjD9EGxR+WrOd4Q3RU8=;
        b=S1r71k/fSvT7fQON7BrJCog2B61U2lulggZwcI8ae5sT+T6jpaLn/OtCLLgiRzlQ0W60BM
        G+VlVR1hzzo63BCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1DC6513AF0;
        Tue, 13 Jul 2021 14:59:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bRaIBWeq7WDiLQAAMHmgww
        (envelope-from <jroedel@suse.de>); Tue, 13 Jul 2021 14:59:51 +0000
Date:   Tue, 13 Jul 2021 16:59:49 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/3] KVM: SVM: Add support for Hypervisor Feature support
 MSR protocol
Message-ID: <YO2qZXyaiYjKuUe1@suse.de>
References: <20210713093546.7467-1-joro@8bytes.org>
 <20210713093546.7467-3-joro@8bytes.org>
 <3e49625d-93c8-c7fb-2c91-d5bdc3af0fd8@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e49625d-93c8-c7fb-2c91-d5bdc3af0fd8@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 08:35:16AM -0500, Tom Lendacky wrote:
> On 7/13/21 4:35 AM, Joerg Roedel wrote:
> >  #define GHCB_MSR_HV_FT_REQ			0x080
> >  #define GHCB_MSR_HV_FT_RESP			0x081
> >  
> > +/* GHCB Hypervisor Feature Request/Response */
> > +#define GHCB_MSR_HV_FT_REQ			0x080
> > +#define GHCB_MSR_HV_FT_RESP			0x081
> > +
> 
> Looks like some of these definitions are already present, since the new
> lines are the same as the lines above it.

Right, that is a rebasing artifact. Thanks for spotting it, I fix that
up in the next version.

Regards,

	Joerg
