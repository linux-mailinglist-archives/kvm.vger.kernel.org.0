Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B230E62BDAA
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 13:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiKPMYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 07:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbiKPMX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 07:23:58 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EFA2F389;
        Wed, 16 Nov 2022 04:20:07 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1099A336F0;
        Wed, 16 Nov 2022 12:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1668601206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U5CoxrssX3lwO2yTdR28sH82ZL6YuWSWRKEuuR+bTSg=;
        b=1KQ9vl9AZ3Xi2ks+r3Tcd7Kt6XHbCFYASKFZ0N10cT8ptZznJhYf3Jig7tmgWYfk+2a78D
        abAy3zOZF+vEVxb6EWrp2tvqrgw4XVMH/R+NMl3kTfRMWH0CcmeWkgYfZyKTx1EryqS6fp
        90fuqtFZCtBAOcexE52g2J7yLWgF3cQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1668601206;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U5CoxrssX3lwO2yTdR28sH82ZL6YuWSWRKEuuR+bTSg=;
        b=CCTAQzUMyrC4rnInTPc4mAiJf2AstLr6KjyaFFw87i+FMST7AQHNaie5KWBElvpFspJaPh
        i10PPdpYQErXifBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 05A92134CE;
        Wed, 16 Nov 2022 12:20:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZUxdAXbVdGNFEwAAMHmgww
        (envelope-from <bp@suse.de>); Wed, 16 Nov 2022 12:20:06 +0000
Date:   Wed, 16 Nov 2022 13:20:00 +0100
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
Message-ID: <Y3TVcJnQ/Ym6dGz2@zn.tnic>
References: <20221103152318.88354-1-pgonda@google.com>
 <Y258U+8oF/eo14U+@zn.tnic>
 <CAMkAt6o-jcG7u1=zw4jJp5evrO4sFJR-iG_ApF7LhT+7c55_Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMkAt6o-jcG7u1=zw4jJp5evrO4sFJR-iG_ApF7LhT+7c55_Wg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 02:47:31PM -0700, Peter Gonda wrote:
> > > +      * certificate data buffer retry the same guest request without the
> > > +      * extended data request.
> > > +      */
> > > +     if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
> > > +         err == SNP_GUEST_REQ_INVALID_LEN) {
> > > +             const unsigned int certs_npages = snp_dev->input.data_npages;
> > > +
> > > +             exit_code = SVM_VMGEXIT_GUEST_REQUEST;
> > > +             rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
> > > +
> > > +             err = SNP_GUEST_REQ_INVALID_LEN;
> >
> > Huh, why are we overwriting err here?
> 
> I have added a comment for the next revision.
> 
> We are overwriting err here so that userspace is alerted that they
> supplied a buffer too small.

Sure but you're not checking rc either. What if that reissue fails for
whatever other reason? -EIO for example...

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
