Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F2858E3DE
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 01:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiHIXvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 19:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiHIXvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 19:51:46 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB1956B91
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 16:51:45 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 73so12795032pgb.9
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 16:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=t8QA2tksbD31DfrMNyQZwHcagOyGgK4LmqpD2Mjd3ks=;
        b=FdBXj2iya/LVg+aZaZK6+vt3jeh2/o+1xHTSAXVuRM5bMpU8wwW6M5upnJSuoTJE3N
         XdHyZLOBrtQwyPrE9HLYfWwXvCTDOSFz24i5FD1JcS+vb/n1nXURsCzKKDgd1ufCtCT3
         x/rMTrgIYQ9DEqE4PrMRxNKB5XmsP3O3SbkEvnMEVdYrTllJ1Y1M3ml9RHVmHR/bO5Fi
         dNbYbnt30yAwhsHyULeJm+S6UlpDwF2aDzokq2Dm6E0E2RFg/QzuZlkcUSz6K7NT9QlA
         prBFtFUX2rpKlzwCSlprWGn939XugjuzyZ9Lw5w6G/u1FJOLP1HRIDnHRYlBtOXbXVwk
         dKOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=t8QA2tksbD31DfrMNyQZwHcagOyGgK4LmqpD2Mjd3ks=;
        b=8Ipl8VFIqTPOseW6TUtZbX4zVf9tas80zMlxM70AJv0bzW/PR5tecSC/XbSdVaMBG7
         VaDSpJSnpn7elc7WYcsXspMdUTqZwO0StFERzrzB7u64qNFgXnlUrVR1G1ubL4HbqKW9
         Moj5vtOkBxjbVTiUbIT48fLcr0G19tuakjqt3uLaykU4GfMe/hNI7OjOkpCE6dYSHiVR
         UKTPmc0AN1C8m/ITvFVJ06vOIS9l6ajEf3XXABpvpFpDLmoi20qGA58DF5MhjVZljjFO
         ouROahG17H4fg1ebcK62/0QiWk0LYQAltI+B9+sumwXhe/WA3w7THtS7iEt1X6O0ZQ2X
         WEgQ==
X-Gm-Message-State: ACgBeo0tCuUFFQ1HPc+K65FzQqmUPCfLMaMT13GY8+v2gGZn023RLuU0
        xARtUCfuK3f5udPbdHng4S0NYq3+P9ntFA==
X-Google-Smtp-Source: AA6agR7XZH+x6V6XY09gZfStY5OxSK0OFe/hNzxXbUIUUdwPBfyiUJKSdoFPrWHCD5oR1IWqJHaqCg==
X-Received: by 2002:aa7:948b:0:b0:52e:e0cd:183a with SMTP id z11-20020aa7948b000000b0052ee0cd183amr18148655pfk.59.1660089105320;
        Tue, 09 Aug 2022 16:51:45 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g6-20020a1709026b4600b0016edb59f670sm11460869plt.6.2022.08.09.16.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 16:51:44 -0700 (PDT)
Date:   Tue, 9 Aug 2022 23:51:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Make page tables for eager page splitting
 NUMA aware
Message-ID: <YvLzDUjpJHmZtn0i@google.com>
References: <20220801151928.270380-1-vipinsh@google.com>
 <YuhPT2drgqL+osLl@google.com>
 <YuhoJUoPBOu5eMz8@google.com>
 <YulRZ+uXFOE1y2dj@google.com>
 <YuldSf4T2j4rIrIo@google.com>
 <4ccbafb5-9157-ec73-c751-ec71164f8688@redhat.com>
 <Yul3A4CmaAHMui2Z@google.com>
 <cedcced0-b92c-07bd-ef2b-272ae58fdf40@redhat.com>
 <CAHVum0c=s8DH=p8zJcGzYDsfLY_qHEmvD1uF58h5WoUk6ZF8rQ@mail.gmail.com>
 <CALzav=ccxkAWk7ddqbJ_qPL2-=bXVZUEpWgwKpJ1oCtc_8w7WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=ccxkAWk7ddqbJ_qPL2-=bXVZUEpWgwKpJ1oCtc_8w7WQ@mail.gmail.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 09, 2022, David Matlack wrote:
> On Fri, Aug 5, 2022 at 4:30 PM Vipin Sharma <vipinsh@google.com> wrote:
> > Approach B:
> > Ask page from the specific node on fault path with option to fallback
> > to the original cache and default task policy.
> >
> > This is what Sean's rough patch looks like.
> 
> This would definitely be a simpler approach but could increase the
> amount of time a vCPU thread holds the MMU lock when handling a fault,
> since KVM would start performing GFP_NOWAIT allocations under the
> lock. So my preference would be to try the cache approach first and
> see how complex it turns out to be.

Ya, as discussed off-list, I don't like my idea either :-)

The pfn and thus node information is available before mmu_lock is acquired, so I
don't see any reason to defer the allocation other than to reduce the memory
footprint, and that's a solvable problem one way or another.
