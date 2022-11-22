Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8B2634543
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 21:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbiKVULV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 15:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbiKVULS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 15:11:18 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15548AEBE4
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 12:11:18 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso14746877pjt.0
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 12:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yDPEucTodArSYSHJ0NWAAvcuywA9eajDLEL2AcMW+BM=;
        b=bLIKtiNhgJ230VU8HQa9PLCn2xK+pmvJRCQnXTctFUI7HYAp8WI5MuEXmJUcWBf4zw
         j5tHJF7Jiwlfh7EGXjAL760GZsbEl167VpvCe4j/SsetJD7kxDRr1paDHjZyJtvAReES
         VekQq5KcWFOd9TwaPTkPucqkUNDc7dcuCV/PLnATIoGwIWG6/a52vqu2P5133isRg9ac
         9HQNxi0lyEAfujQp6//pvKB22owPOhNypRg8djL0gjnQdzT7OS0TYesapRgTbj0+M46n
         eBlw/XDM96FsRKu8/Kr+jgfRqK9oX68ipWIEwY1dBNBNvIv6SxHzQj9ROXokTXgj/xMj
         Qq7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yDPEucTodArSYSHJ0NWAAvcuywA9eajDLEL2AcMW+BM=;
        b=m0WfOL7V2ERSkBBQt2h845oyGbDpwkKh0VRlgHVV4jvzwSLRV7xswKDakiefKePxuw
         /ay01qaCJJu4lnW0r6ruTFwsTnqN/x23z/1pAgcaIW7/1dSIbAECTw4FtT0uu7ThuJVz
         qgPR9sJKR0OW2hxIAZcsNefH4mdkgqxgMgRrfD1affqfHQgjTliu0KIU0nOvJguTKgLw
         DyQLG1QuPGy0PDwNavhra+IPWYSp9WeaPtKURo2qwhRSKq3JgPbkqo1noNr8hWhJxoku
         PoVpBx8LbAQ8CeAWepneFhpgZaxVPyqMrKJYRZOZo9IuocHiXbTZNyd7l1oSuh/pOo9H
         XmAg==
X-Gm-Message-State: ANoB5plFuPPWSKYH5q7JDfylEiUeKjCsWxvosYS/y4Ho07AvfaFnPjXA
        TbtZJhgV2EY9hGd4QYAz37gezg==
X-Google-Smtp-Source: AA0mqf5SYXD4DSxgRrsLuGcVmlyxR/zZDVPJ0uyRz6RpZwYeCcMKjFp9sp7uqjkNcoM07SRUBm29FQ==
X-Received: by 2002:a17:90b:3c85:b0:218:4a32:1924 with SMTP id pv5-20020a17090b3c8500b002184a321924mr27991504pjb.24.1669147877513;
        Tue, 22 Nov 2022 12:11:17 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 19-20020a621513000000b0056c0b98617esm11104113pfv.0.2022.11.22.12.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 12:11:16 -0800 (PST)
Date:   Tue, 22 Nov 2022 20:11:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Message-ID: <Y30s4fZhjnEUBRth@google.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
 <Y3yQKDZFC8+oCyqK@hirez.programming.kicks-ass.net>
 <87edtvgu1l.ffs@tglx>
 <19d93ff0-df0d-dc9d-654b-a9ca6f7be1d0@intel.com>
 <87mt8ig3ja.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mt8ig3ja.ffs@tglx>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022, Thomas Gleixner wrote:
> On Tue, Nov 22 2022 at 07:35, Dave Hansen wrote:
> 
> > On 11/22/22 02:31, Thomas Gleixner wrote:
> >> Nothing in the TDX specs and docs mentions physical hotplug or a
> >> requirement for invoking seamcall on the world.
> >
> > The TDX module source is actually out there[1] for us to look at.  It's
> > in a lovely, convenient zip file, but you can read it if sufficiently
> > motivated.
> 
> zip file? Version control from the last millenium?
> 
> The whole thing wants to be @github with a proper change history if
> Intel wants anyone to trust this and take it serious.
> 
> /me refrains from ranting about the outrageous license choice.

Let me know if you grab pitchforcks and torches, I'll join the mob :-)
