Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5CE4A9D84
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 18:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357239AbiBDRPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 12:15:13 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:52770 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbiBDRPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 12:15:11 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E68F11F382;
        Fri,  4 Feb 2022 17:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643994910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s7vNC8CSsCfiI79shKkEJVpiUepdRGycbTiluKJTORA=;
        b=lhL/G3l5phePv45CbppBvNTzj1SXui65JakPjFE5x+Kyq8eFqdPHsPaJOVpt5moFRWdxXt
        CfskR+imJIq7LjUEcOcFL1rMyk1jM8GQ9w3hpAG69NKOR145GNunUsZWYvjSTAI1JXQrK9
        8vLoa2HtDSsqqFsIycmsVL4VaKZiMgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643994910;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s7vNC8CSsCfiI79shKkEJVpiUepdRGycbTiluKJTORA=;
        b=qkKi/nXx9Q+oSti8LEFKGPQx49QtsJKlR8Ypup26I08C5XMXV456F1aHh3w1lpXDnPdACp
        URUBQL951u+zdKDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 67FBD13B29;
        Fri,  4 Feb 2022 17:15:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IZZsFx5f/WEnWgAAMHmgww
        (envelope-from <jroedel@suse.de>); Fri, 04 Feb 2022 17:15:10 +0000
Date:   Fri, 4 Feb 2022 18:15:08 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Marc Orr <marcorr@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bp@suse.de
Subject: Re: [kvm-unit-tests 02/13] x86: AMD SEV-ES: Setup #VC exception
 handler for AMD SEV-ES
Message-ID: <Yf1fHNHakPsaF8Uu@suse.de>
References: <20220120125122.4633-1-varad.gautam@suse.com>
 <20220120125122.4633-3-varad.gautam@suse.com>
 <CAA03e5FbSoRo9tXwJocBtZHEc7xisJ3gEFuOW0FPvchbL9X8PQ@mail.gmail.com>
 <Yf0GO8EydyQSdZvu@suse.de>
 <CAA03e5HnyqZqDOyK8cbJgq_-zMPYEcrAuKr_CF8+=3DeykfV5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA03e5HnyqZqDOyK8cbJgq_-zMPYEcrAuKr_CF8+=3DeykfV5A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Feb 04, 2022 at 07:57:39AM -0800, Marc Orr wrote:
> Regarding code review and testing, I can help with the following:
> - Compare the patches being pulled into kvm-unit-tests to what's in
> the Linux kernel and add my Reviewed-by tags if I don't see any
> meaningful discrepancies.
> - Test the entire series on Google's setup, which doesn't use QEMU and
> add my Tested-by tag accordingly. My previous Tested-by tags were on
> individual patches. I have not yet tested the entire series.
> 
> Please let me know if this is useful. If not, I wouldn't spend the time :-).

I think it is definitly useful to run this in Googles environment too
to get it tested and possible bugs ruled out. That can only help the
upstream integration of these patches :)

Varad discussed an idea with me today where the core VC handling code
could be put into a library and used by the kernel and unit-tests and
possibly others as well. The has the benefit that the kvm-unit-tests
would also test the kernels VC handler paths. But it is probably
something for the future.

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

