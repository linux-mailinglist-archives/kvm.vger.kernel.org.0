Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90283456BB7
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 09:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhKSIj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 03:39:56 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:56620 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhKSIj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 03:39:56 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9C6FD1FD39;
        Fri, 19 Nov 2021 08:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637311013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ks9COcNFxKQzgqXBap70A20Sb9cIEMl/0mhoBpeYJoo=;
        b=JRNnkaQGN5QYi0vFk1Ex6ce2Dkdg3gwiEMIlHJwoDzJUtisX9oYdNI9KqJ14TrUbdvgKSv
        kwjsN76l49WoRyTAOmyoBy84x0cNI1dVX4HwnbVMisoY0dbfYeqoXKwOwQD+bU/rw+Vtsy
        0fyDO2jQcA/SbTKpZB9QR4d+vEN83sI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637311013;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ks9COcNFxKQzgqXBap70A20Sb9cIEMl/0mhoBpeYJoo=;
        b=/XMlDqKR6OdLGXBTh+U2C1baAjQSEVpEoFuGEcdQ/aFa/BnAI2CMphO28C/mJDT4XjkAEo
        yiICY0cb4vwwTQAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 105D813DD5;
        Fri, 19 Nov 2021 08:36:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K3v8ASVil2ESXgAAMHmgww
        (envelope-from <jroedel@suse.de>); Fri, 19 Nov 2021 08:36:53 +0000
Date:   Fri, 19 Nov 2021 09:36:51 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Michael Sterritt <sterritt@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-coco@lists.linux.dev, marcorr@google.com, pgonda@google.com
Subject: Re: [PATCH] Fix SEV-ES INS/OUTS instructions for word, dword, and
 qword.
Message-ID: <YZdiI8N4+6Xt5b++@suse.de>
References: <20211118021326.4134850-1-sterritt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211118021326.4134850-1-sterritt@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

On Wed, Nov 17, 2021 at 06:13:26PM -0800, Michael Sterritt wrote:
> Properly type the operands being passed to __put_user()/__get_user().
> Otherwise, these routines truncate data for dependent instructions
> (e.g., INSW) and only read/write one byte.
> 
> Tested: Tested by sending a string with `REP OUTSW` to a port and then
> reading it back in with `REP INSW` on the same port. Previous behavior
> was to only send and receive the first char of the size. For example,
> word operations for "abcd" would only read/write "ac". With change, the
> full string is now written and read back.

Thanks for fixing this! When you re-send, please change the subject to

	x86/sev-es: Fix SEV-ES INS/OUTS instructions for word, dword, and qword

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 Nürnberg
Germany
 
(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev

