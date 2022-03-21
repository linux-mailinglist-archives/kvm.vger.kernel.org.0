Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4627D4E3250
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 22:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiCUVZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 17:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiCUVZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 17:25:23 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256AB30A8A0
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 14:23:29 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id k25so18189285iok.8
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 14:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V23Av844hT2iFSeIr93jDSQK2woq0bdnV8wCQgIMoaE=;
        b=BqfRdd0MToidp4NjdCpAich3wttPHJSpHpciVyLjQYcZsQkijxHSCAHv+HkEZIGTgl
         nePdD/fu9HssIKM3/iRRr9O6Q850Xdt2xyBdSd0KrQWpILVWMvIqbr3SL1b5J2mYLhQF
         q7dKEofLVqNIVA/2J+/T+33KhsyBWLMNjUMwYFAXmxXdNUGSMMJHL3N+agbrFjKv9lyp
         gaOGglAqzzIHE5DU5FSazp96uv06kGagV0SeCVj+/JyZMQ9q5rZnZFh/I0ESw4wpwaWq
         PK/B817iaPIH0ofKG1ZeWyOuxSc/Pr0atnQ9tEOZf0wO3pd25Qz79ZiCiXjPPlpERWZh
         +cGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V23Av844hT2iFSeIr93jDSQK2woq0bdnV8wCQgIMoaE=;
        b=s6k9BIwFvlhqhmgGOkh4tlL1xhD3fIClZuTBHAxy0E0Jfm3kYNyRXxgT/xgnFfWQdI
         oLnB5HDr9+uzW4JJiw0lq3VAsDsTV3CetTHQPwr/H+R8izTa7IM/AcJKkhsezkO6zcb9
         lXjbIGsQDSWqzsasZmbplXE8zLtKjqLH0pPnTY8uJrL0TwRZclBgC8a00J663M1eMbqc
         SMmcHVdVlabdfj9rGMCo0oWdIu4Rv09q4NHPq2UiyyGY02HwpidU+plNClDhon2q9D3D
         XyOOBmvJhakkhL8ygugag3/1rjGmU5gl7sQaVtcNvbz5Jhv8igFrDRxQnED+VKoGYrVu
         PHJA==
X-Gm-Message-State: AOAM532zCL+9MSI1lOLc8qVJUC5G/1hQ4Wh65lfIcDStBK6os1+5GebD
        G8dG9+/FRVxWBZwbFYF4AqrLDA==
X-Google-Smtp-Source: ABdhPJw7am/OXOHnmmLihwjh5ITdfwrRXoAaHgvjiimS2VG0z8UWBPOXUWWvgxTYXi6hRapDf+jkMA==
X-Received: by 2002:a05:6638:1352:b0:321:547b:daa2 with SMTP id u18-20020a056638135200b00321547bdaa2mr572926jad.128.1647897808224;
        Mon, 21 Mar 2022 14:23:28 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id x4-20020a056e021bc400b002c8360eda7asm1181740ilv.88.2022.03.21.14.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 14:23:27 -0700 (PDT)
Date:   Mon, 21 Mar 2022 21:23:24 +0000
From:   Oliver Upton <oupton@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     "Franke, Daniel" <dff@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Message-ID: <YjjszGb+svKpgADH@google.com>
References: <YjWNfQThS4URRMZC@google.com>
 <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
 <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
 <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
 <100b54469a8d59976bbd96f50dd4cd33.squirrel@twosheds.infradead.org>
 <9ca10e3a-cd99-714a-76ad-6f1b83bb0abf@redhat.com>
 <YjbrOz+yT4R7FaX1@google.com>
 <1680281fee4384d27bd97dba117f391a.squirrel@twosheds.infradead.org>
 <YjfI/Sl3lFEFOIWc@google.com>
 <42cde62812d47489a4017c8cc2ca1397e1ad1d66.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42cde62812d47489a4017c8cc2ca1397e1ad1d66.camel@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022 at 07:43:21PM +0000, David Woodhouse wrote:
> On Mon, 2022-03-21 at 00:38 +0000, Oliver Upton wrote:
> > On Sun, Mar 20, 2022 at 09:46:35AM -0000, David Woodhouse wrote:
> > > But coincidentally since then I have started having conversations with
> > > people who really want the guest to have an immediate knowledge of the
> > > adjtimex maxerror etc. on the new host immediately after the migration.
> > > Maybe the "if the migration isn't fast enough then let the guest know it's
> > > now unsynced" is OK, but I'll need to work out what "immediately" means
> > > when we have a guest userspace component involved in it.
> > 
> > This has also been an area of interest to me. I think we've all seen the
> > many ways in which doing migrations behind the guest's can put software
> > in an extremely undesirable state on the other end. If those
> > conversations are taking place on the mailing lists, could you please CC
> > me?
> > 
> > Our (Google) TSC adjustment clamping and userspace notification mechanism
> > was a halfway kludge to keep things happy on the other end. And it
> > generally has worked well, but misses a fundamental point.
> > 
> > The hypervisor should tell the guest kernel about time travel and let it
> > cascade that information throughout the guest system. Regardless of what
> > we do to the TSC, we invariably destroy one of the two guest clocks along
> > the way. If we told the guest "you time traveled X seconds", it could
> > fold that into its own idea of real time. Guest kernel can then fire off
> > events to inform software that wants to keep up with clock changes, and
> > even a new event to let NTP know its probably running on different
> > hardware.
> > 
> > Time sucks :-)
> 
> So, we already have PVCLOCK_GUEST_STOPPED which tells the guest that
> its clock may have experienced a jump. Linux guests will use this to
> kick various watchdogs to prevent them whining. Shouldn't we *also* be
> driving the NTP reset from that same signal?

Right, but I'd argue that interface has some problems too. It
depends on the guest polling instead of an interrupt from the
hypervisor. It also has no way of informing the kernel exactly how much
time has elapsed.

The whole point of all these hacks that we've done internally is that we,
the hypervisor, know full well how much real time hasv advanced during the
VM blackout. If we can at least let the guest know how much to fudge real
time, it can then poke NTP for better refinement. I worry about using NTP
as the sole source of truth for such a mechanism, since you'll need to go
out to the network and any reads until the response comes back are hosed.

--
Thanks,
Oliver
