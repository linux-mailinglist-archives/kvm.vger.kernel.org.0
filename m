Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C864A9810
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 11:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244661AbiBDKz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 05:55:59 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:47922 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiBDKz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 05:55:58 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BE8FF210FD;
        Fri,  4 Feb 2022 10:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643972157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lA8/BPXaj3Ztagr/EuUEXvaARoqPppd3lbBHOZf1thM=;
        b=xtQ6BxaJ7GBm3q2CxOmOP6zQdsZvQUi6qJFjHuh6ASyi+UnliqoaR2EtLp1v1XhLZiN7xw
        wkIzGZ6sgDkBDGLdnhTcGW9ohUrvQ0pmlHkN7fbtHwywf7f2W2mYWzw+oDG0/Ypuh7xXcc
        9hN5ZZYNzmsebAkmlgvR123LhufWd44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643972157;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lA8/BPXaj3Ztagr/EuUEXvaARoqPppd3lbBHOZf1thM=;
        b=lO/VTPuECTgp1fk3cwyWVCTTvVJmGqHnht/H6ffjGL9AsTsxY7P3zkRZ2S6gCDuZNY3Rgz
        s6mgBl9ooZnWaoAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5A39113A84;
        Fri,  4 Feb 2022 10:55:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fA9ZFD0G/WE2JwAAMHmgww
        (envelope-from <jroedel@suse.de>); Fri, 04 Feb 2022 10:55:57 +0000
Date:   Fri, 4 Feb 2022 11:55:55 +0100
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
Message-ID: <Yf0GO8EydyQSdZvu@suse.de>
References: <20220120125122.4633-1-varad.gautam@suse.com>
 <20220120125122.4633-3-varad.gautam@suse.com>
 <CAA03e5FbSoRo9tXwJocBtZHEc7xisJ3gEFuOW0FPvchbL9X8PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA03e5FbSoRo9tXwJocBtZHEc7xisJ3gEFuOW0FPvchbL9X8PQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Sun, Jan 30, 2022 at 12:36:48PM -0800, Marc Orr wrote:
> Please let me know if I'm mis-understanding this rationale or missing
> any reasons for why folks want a built-in #VC handler.

There are a couple of reasons which come all come down to one goal:
Robustnes of the kvm-unit-tests.

If kvm-unit-tests continue to use the firmware #VC handler after
ExitBootServices there needs to be a contract between the test
framework and the firmware about:

	1) Page-table layout - The page table needs to map the firmware
	   and the shared GHCB used by the firmware.

	2) The firmware is required to keep its #VC handler in the
	   current IDT for kvm-unit-tests to find it and copy the #VC
	   entry into its own IDT.

	3) The firmware #VC handler might use state which is not
	   available anymore after ExitBootServices.

	4) If the firmware uses the kvm-unit-test GHCB after
	   ExitBootServices, it has the get the GHCB address from the
	   GHCB MSR, requiring an identity mapping.
	   Moreover it requires to keep the address of the GHCB in the
	   MSR at all times where a #VC could happen. This could be a
	   problem when we start to add SEV-ES specific tests to the
	   unit-tests, explcitily testing the MSR protocol.

It is easy to violate this implicit protocol and breaking kvm-unit-tests
just by a new version of OVMF being used. I think that is not a very
robust approach and a separate #VC handler in the unit-test framework
makes sense even now.

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

