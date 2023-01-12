Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F95666FE8
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 11:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237435AbjALKmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 05:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbjALKlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 05:41:24 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D1550E6B
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 02:35:29 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E518B3FB9C;
        Thu, 12 Jan 2023 10:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673519726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BUVmg7NGHndbDWIy/H+0rPDMMgMi+epK1rYp+m3mbJw=;
        b=H4VWT2yBKVYJ62gR93K6HDFZJXMsEbUT23XNl0/W2/sVjYoZDBfEnGGjqBFNuqxPgcyWs3
        ZAL4rRKRENtJ2GgsvA84qTnsBaHoH+xMsBssHofM02cIksVw/KTm24W83f9AP1tRVqTxO+
        eq2vLv3H9PLX3xjMu/dE08/2Hpoibxo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673519726;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BUVmg7NGHndbDWIy/H+0rPDMMgMi+epK1rYp+m3mbJw=;
        b=g5So4v2cWk+0WhY3mWEnt5Ya2kZDUof+QmIWtB1RxKLJy/fPs2MeXUEio7fV6qvgcCDM7z
        boEPGm6qf2ae44Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B7F8613776;
        Thu, 12 Jan 2023 10:35:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1vUxLG7iv2MmKQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 12 Jan 2023 10:35:26 +0000
Message-ID: <1d278b52-5c75-1f95-adf8-3e9c699cf6ca@suse.cz>
Date:   Thu, 12 Jan 2023 11:35:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Pedro Falcato <pedro.falcato@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>, yuzhao@google.com,
        Michal Hocko <MHocko@suse.com>, shy828301@gmail.com,
        Mel Gorman <mgorman@techsingularity.net>
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
 <CAKbZUD0Tqct_G9OcO8ocdH1J_YvLSEod-ofr97hsyoHgcvBwuw@mail.gmail.com>
 <7aa90802-d25c-baa3-9c03-2502ad3c708a@kernel.org>
 <6d989ca2330748ed682c81fc5f43e054a70e70a8.camel@redhat.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <6d989ca2330748ed682c81fc5f43e054a70e70a8.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/23 11:31, Maxim Levitsky wrote:
> On Thu, 2023-01-12 at 07:07 +0100, Jiri Slaby wrote:
>> 
>> I have rebooted to a fresh kernel which 1) have lockdep enabled, and 2) 
>> I have debuginfo for. So next time this happens, I can print held locks 
>> and dump a kcore (kdump is set up).
>> 
>> regards,
> 
> It is also possible that I noticed something like that on 6.1:
> 
> For me it happens when my system (also no swap, 96G out which 48 are permanetly reserved as 1G hugepages,
> and this happens with VMs which don't use this hugepage reserve) 
> is somewhat low on memory and qemu tries to lock all memory (I use -overcommit mem-lock=on)
> 
> Like it usually happens when I start 32 GB VM while having lot of stuff open in background, but
> still not nearly close to 16GB.
> As a workaround I lowered the reserved area to 32G.
> 
> I also see indication that things like htop or even opening a new shell hang quite hard.
> 
> What almost instantly helps is 'echo 3 | sudo tee /proc/sys/vm/drop_caches'
> e.g that makes the VM start booting, and unlocks everything.

Note it's possible that temporary+recoverable things like that have a
different cause caused by compaction caught in a loop, as discussed here:

https://lore.kernel.org/all/a032e3bf-8470-095a-2262-791f5678e590@suse.cz/

> Best regards,
> 	Maxim Levitsky
> 

