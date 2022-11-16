Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1260B62C657
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 18:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbiKPR2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 12:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbiKPR2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 12:28:45 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7589832BA3;
        Wed, 16 Nov 2022 09:28:43 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 144AB229FE;
        Wed, 16 Nov 2022 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1668619722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2+mwqcnu3Dk15IooPi8KuMWj/BV5uluYencW/62PbfE=;
        b=f9vZE3Aavb0yG3AG2jx/CdaOBJGlA5BkMJQI3Vx+g4+9MXsM8CQkW2IXN7tf4Vugy1nnpS
        khfILFr5Eqzyu6qFl7A5v+RWxqK5zF0W5eYqj9CVZO02osMTAd3HG57nfN3ezmRDo5p7bc
        cQMrbpl6a6/opvCCtNvTevEFgN5b8WA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1668619722;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2+mwqcnu3Dk15IooPi8KuMWj/BV5uluYencW/62PbfE=;
        b=V7Mwz9U6WCW7KPIyl9RC6FbITz17YGp8j2IALJP7B6BnXf9XyzU4Bpc3WzImCYYcYVhGRq
        W1RFKktR1M/OGsDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 02AA613480;
        Wed, 16 Nov 2022 17:28:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id v2ecAModdWOzJAAAMHmgww
        (envelope-from <bp@suse.de>); Wed, 16 Nov 2022 17:28:42 +0000
Date:   Wed, 16 Nov 2022 18:28:38 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Peter Gonda <pgonda@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V4] virt: sev: Prevent IV reuse in SNP guest driver
Message-ID: <Y3Udxru8Rivbxsui@zn.tnic>
References: <20221103152318.88354-1-pgonda@google.com>
 <Y258U+8oF/eo14U+@zn.tnic>
 <CAMkAt6o-jcG7u1=zw4jJp5evrO4sFJR-iG_ApF7LhT+7c55_Wg@mail.gmail.com>
 <Y3TVcJnQ/Ym6dGz2@zn.tnic>
 <CAMkAt6qQmkufbuotzMA4bMJaA4uBFMdk8w7a3X+OH3JaOdFepA@mail.gmail.com>
 <bc070ef7-8168-f1fc-f5ec-aeac204f2ef6@amd.com>
 <CAMkAt6rHTgJX1KTjYmbii6dyG7QMxXJxNy1E_eZ8vRWLK9Vc1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMkAt6rHTgJX1KTjYmbii6dyG7QMxXJxNy1E_eZ8vRWLK9Vc1g@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 10:10:58AM -0700, Peter Gonda wrote:
> I think another comment above the first snp_issue_guest_request()
> could help too. Saying once we call this function we either need to
> increment the sequence number or wipe the VMPCK to ensure the
> encryption scheme is safe.

And make that explicit pls:

        /*
         * If the extended guest request fails due to having to small of a
         * certificate data buffer retry the same guest request without the
         * extended data request...

	 ... in order to not have to reuse the IV.


I have to admit, the flow in that function is still not optimal but I
haven't stared at it long enough to have a better idea...

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
