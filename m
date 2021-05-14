Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D98E38077C
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 12:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhENKjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 06:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhENKjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 06:39:44 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5EDC061574;
        Fri, 14 May 2021 03:38:33 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0b2c00e75fd5d24a8a460d.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:2c00:e75f:d5d2:4a8a:460d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 092671EC03A0;
        Fri, 14 May 2021 12:38:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620988712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rLpwvEOD+SNcjjXRD4phEAovRMr9hdeOp4DAy+p8b70=;
        b=LkMUW4pF2xxHQYTCTnka0bu5Wz9HyZm2q49dv7dJinrd3+TwB3aBK4lXadYs8DDmEVUz2U
        F0hsFhKj4CLsJ/kG5zDikpqQHGtb6UUiGiKcpnqPxaYKWvq+PvLfpqd/NSrq/BHIXDlgkB
        8+TeVAvDSD9oTvljXGDLRcYCU97MKJI=
Date:   Fri, 14 May 2021 12:38:27 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <YJ5TI2LD2PB35QYE@zn.tnic>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
 <20210513043441.GA28019@ashkalra_ubuntu_server>
 <YJ4n2Ypmq/7U1znM@zn.tnic>
 <7ac12a36-5886-cb07-cc77-a96daa76b854@redhat.com>
 <20210514090523.GA21627@ashkalra_ubuntu_server>
 <YJ5EKPLA9WluUdFG@zn.tnic>
 <20210514100519.GA21705@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210514100519.GA21705@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 10:05:19AM +0000, Ashish Kalra wrote:
> No, actually notify_addr_enc_status_changed() is called whenever a range
> of memory is marked as encrypted or decrypted, so it has nothing to do
> with migration as such. 
> 
> This is basically modifying the encryption attributes on the page tables
> and correspondingly also making the hypercall to inform the hypervisor about
> page status encryption changes. The hypervisor will use this information
> during an ongoing or future migration, so this information is maintained
> even though migration might never be initiated here.

Doh, ofcourse. This doesn't make it easier.

> The error value cannot be propogated up the callchain directly
> here,

Yeah, my thinking was way wrong here - sorry about that.

> but one possibility is to leverage the hypercall and use Sean's
> proposed hypercall interface to notify the host/hypervisor to block/stop
> any future/ongoing migration.
>
> Or as from Paolo's response, writing 0 to MIGRATION_CONTROL MSR seems
> more ideal.

Ok.

So to sum up: notify_addr_enc_status_changed() should warn but not
because of migration but because regardless, we should tell the users
when page enc attributes updating fails as that is potentially hinting
at a bigger problem so we better make sufficient noise here.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
