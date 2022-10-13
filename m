Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B65E5FDB20
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 15:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiJMNk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 09:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJMNku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 09:40:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D4241D0C
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:40:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5FF631F86B;
        Thu, 13 Oct 2022 13:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665668445; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wS3vvMJ4U4WZC5hNyYycWQun9eb3ZjLXirkyOzT8smo=;
        b=T3UjOw+TbNIoVwLRPF792XdWNimig+cZWUKgZYzwq1/ty9Cx5hOss9ej7XVH0rRrMEIWiz
        ZF58V/NG5J9PUDr9deXaHeI1aygqUBywIeJw3se71i45M7LAAUHvEZMRYq8NAeAqAa6axL
        vFKMhdx2X4HUHiGVyO/k9PWpxx2+CXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665668445;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wS3vvMJ4U4WZC5hNyYycWQun9eb3ZjLXirkyOzT8smo=;
        b=3ey6RJOSmUFHzQK7iyVW+6r6N+A9VMv+0Vg9yF+rgEiy7aiVm3AIV8++xQSLzWB3UuEFoK
        PMs8HBPqzkn6wgCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2587113AAA;
        Thu, 13 Oct 2022 13:40:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K96hBV0VSGMUPAAAMHmgww
        (envelope-from <vkarasulli@suse.de>); Thu, 13 Oct 2022 13:40:45 +0000
Date:   Thu, 13 Oct 2022 15:40:43 +0200
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] x86: efi: set up the IDT before
 accessing MSRs.
Message-ID: <Y0gVW+wzPSEPeci7@vasant-suse>
References: <20220823094328.8458-1-vkarasulli@suse.de>
 <YwfuxxgGFVDpLOOR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwfuxxgGFVDpLOOR@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
> >  lib/x86/setup.c | 20 ++++++++++++--------
> >  1 file changed, 12 insertions(+), 8 deletions(-)
> >
> > diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> > index 7df0256..712e292 100644
> > --- a/lib/x86/setup.c
> > +++ b/lib/x86/setup.c
> > @@ -192,8 +192,6 @@ static void setup_segments64(void)
> >  	write_gs(KERNEL_DS);
> >  	write_ss(KERNEL_DS);
> >
> > -	/* Setup percpu base */
> > -	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);
> >
> >  	/*
> >  	 * Update the code segment by putting it on the stack before the return
> > @@ -322,7 +320,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
> >  		}
> >  		return status;
> >  	}
> > -
> > +
>
> Huh.  This causes a conflict for me.  My local repo has a tab here that is
> presumably being removed, but this patch doesn't have anything.  If I manually
> add back the tab, all is well.  I suspect your client may be stripping trailing
> whitespace.

Yes, I think my client was stripping trailing whitespaces. Do you want me
to send a new version of the patch with that formatting?


Thanks,
Vasant Karasulli
Kernel generalist
www.suse.com<http://www.suse.com>
[https://www.suse.com/assets/img/social-platforms-suse-logo.png]<http://www.suse.com/>
SUSE - Open Source Solutions for Enterprise Servers & Cloud<http://www.suse.com/>
Modernize your infrastructure with SUSE Linux Enterprise servers, cloud technology for IaaS, and SUSE's software-defined storage.
www.suse.com

