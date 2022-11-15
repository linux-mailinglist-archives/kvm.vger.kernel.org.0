Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE2662A435
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 22:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238722AbiKOVg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 16:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238570AbiKOVgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 16:36:24 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7E424F3D;
        Tue, 15 Nov 2022 13:36:23 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E1381336D8;
        Tue, 15 Nov 2022 21:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1668548181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dlenJjpDzLcxo3DWLnYtaPtdkt0KhciARPTv6BR7Ky0=;
        b=uyz9uSIKl8YjXXq95m/Rf4xRo/PRtAeTRkaCCeBrmWSPpkSoisELGpK7ZgFz6Kq5XCA59C
        1Ndo3iN/KK9/AJkawe5qcGBA0awBaGMbBKFAZwXXhtz9IStzhQWUOR7t+LlP9On03FYDpb
        a5yb7XAMuslCgX2YMPKKmIH9rojuBZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1668548181;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dlenJjpDzLcxo3DWLnYtaPtdkt0KhciARPTv6BR7Ky0=;
        b=fHa3Wajmy0bbb5yUoFvoQZ5nhwtxA7CXUym/vI2atKyujCRdZmw1pxEsNypju/KTFtmiT5
        Q8pFrKOGENR8HlAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C1C6A13A91;
        Tue, 15 Nov 2022 21:36:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dYfXLlUGdGMrMwAAMHmgww
        (envelope-from <bp@suse.de>); Tue, 15 Nov 2022 21:36:21 +0000
Date:   Tue, 15 Nov 2022 22:36:17 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Peter Gonda <pgonda@google.com>
Cc:     thomas.lendacky@amd.com, Dionna Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V4] virt: sev: Prevent IV reuse in SNP guest driver
Message-ID: <Y3QGUb0TVd2M9qow@zn.tnic>
References: <20221103152318.88354-1-pgonda@google.com>
 <Y258U+8oF/eo14U+@zn.tnic>
 <CAMkAt6p2zXnE-ew+pJk_UpZAEFZFdCOPThNn3hSFqYOQG81t-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMkAt6p2zXnE-ew+pJk_UpZAEFZFdCOPThNn3hSFqYOQG81t-g@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022 at 02:11:48PM -0700, Peter Gonda wrote:
> Thanks for detailed review. Working on cleaning up the text for a V5.

Yeah, and I have some questions in my reply which you haven't
addressed...

> > > @@ -676,7 +712,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
> > >       if (!snp_dev->response)
> > >               goto e_free_request;
> > >
> > > -     snp_dev->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
> > > +     snp_dev->certs_data = alloc_shared_pages(dev, sizeof(*snp_dev->certs_data));
> >
> > What's that change for?
> >
> > I went searching for that ->certs_data only ot realize that it is an
> > array of size of SEV_FW_BLOB_MAX_SIZE elems.
> 
> Do you want this change reverted? I liked the extra readability of the
> sizeof(*snp_dev->certs_data) but its unnecessary for this change.

Really?

I think using a define which is a SIZE define is better. Especially if
you look at

	sizeof(*snp_dev->certs_data)

and wonder what type ->certs_data is.

And it's not like it'll go out of sync since it is an array of size,
well, SEV_FW_BLOB_MAX_SIZE.

:-)

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
