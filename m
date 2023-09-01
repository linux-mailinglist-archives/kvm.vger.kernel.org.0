Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E7578F9F8
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 10:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345079AbjIAI05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 04:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbjIAI04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 04:26:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1CE10E4
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 01:26:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2CF381F459;
        Fri,  1 Sep 2023 08:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1693556812; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSnEqUK6TOkRVGZMvsXsDI6e3D+2EA7xs6OLjZY2jbY=;
        b=FddY0uS22GqVt0E0xIiRWWLQy4FGtZEthdBODABUMZ9ERpRWC92W3UIiaiunO2pP2GXHEq
        kh9Reb8eeDoXtW6cAHc8w1I/mli/JuJqL6zbtTDDzQnSl/CKbZwoCOokZ3FjG7sqT4bq82
        36wXEut2sxtEzcdfTHFzPyD8dMpjDX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1693556812;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSnEqUK6TOkRVGZMvsXsDI6e3D+2EA7xs6OLjZY2jbY=;
        b=BBBZsqGGiRvj9wiMIaHtmdlzEgo9SMgsqIDMd5tvBHArkAEHNyJhKcJujiyBvbHjoDb83X
        pbKQp53ecLp1akDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DDEE01358B;
        Fri,  1 Sep 2023 08:26:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CvhgNUug8WT8HgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 01 Sep 2023 08:26:51 +0000
Message-ID: <030ede02-074d-98f5-ca71-5540f5b1fbb6@suse.cz>
Date:   Fri, 1 Sep 2023 10:26:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [RFC PATCH v11 00/29] KVM: guest_memfd() and per-page attributes
Content-Language: en-US
To:     Chao Peng <chao.p.peng@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Fuad Tabba <tabba@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jorg Rodel <jroedel@suse.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20230718234512.1690985-1-seanjc@google.com>
 <ZOjpIL0SFH+E3Dj4@google.com> <20230829091233.GA72470@chaop.bj.intel.com>
 <ZPDcAuHcoRfU+yRX@google.com> <20230901011711.GA673287@chaop.bj.intel.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230901011711.GA673287@chaop.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/23 03:17, Chao Peng wrote:
> On Thu, Aug 31, 2023 at 11:29:22AM -0700, Sean Christopherson wrote:
>> On Tue, Aug 29, 2023, Chao Peng wrote:
>> > On Fri, Aug 25, 2023 at 10:47:12AM -0700, Sean Christopherson wrote:
>> > > 
>> > > 
>> > > Filemap vs. xarray
>> > > ------------------
>> > > This is the main item that needs attention.  I don't want to merge guest_memfd()
>> > > without doing this comparison, as not using filemap means we don't need AS_UNMOVABLE.
>> > > Arguably we could merge a filemap implementation without AS_UNMOVABLE and just eat
>> > > the suboptimal behavior, but not waiting a little while longer to do everything we
>> > > can to get this right the first time seems ridiculous after we've been working on
>> > > this for literally years.
>> > > 
>> > > Paolo was going to work on an axarray implementation, but AFAIK he hasn't done
>> > > anything yet.  We (Google) don't have anyone available to work on an xarray
>> > > implementation for several weeks (at best), so if anyone has the bandwidth and
>> > > desire to take stab at an xarray implementation, please speak up.
>> > 
>> > I can do some experiments in the following weeks on the xarray
>> > direction. I'm not quite confident I understood all what Paolo
>> > originally wanted to do, so questions may have.
>> 
>> FYI, I jumped the gun, sounds like Paolo got far enough along to form a strong
>> opinion[*].
> 
> Yeah, I see that, that is a good news actually, then we can go ahead with
> the current filemap one. I personally think these mm touchpoints are not
> a big deal when compared to previous versions, most part we are just using
> the APIs.

I also agree with the outcome, I think staying will filemap will be more
future proof e.g. if migration and swapout becomes possible in the future. I
don't think having to touch some mm/ code is that much of a problem.
Hopefully the AS_UNMOVABLE issue will be sufficiently addressed by this:
https://lore.kernel.org/all/20230901082025.20548-2-vbabka@suse.cz/

>> 
>> Thanks for volunteering though, much appreciated!
> 
> NP, any collaboration is to make this lasting years series merge earlier.
> 
> Chao
>> 
>> [*] https://lore.kernel.org/all/CABgObfay4FKV=foWLZzAWaC2kVHRnF1ib+6NC058QVZVFhGeyA@mail.gmail.com

