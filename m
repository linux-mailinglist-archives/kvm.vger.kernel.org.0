Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861736BF15D
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 20:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCQTDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 15:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCQTDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 15:03:20 -0400
Received: from out-38.mta1.migadu.com (out-38.mta1.migadu.com [IPv6:2001:41d0:203:375::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255CA18B1C
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 12:03:15 -0700 (PDT)
Date:   Fri, 17 Mar 2023 19:03:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679079794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYk329oimIyoyr6HEV187xsnoHnlkvYP7PzGhsvf1kY=;
        b=IamHNS7lY2b4v2cJjnMLU6gVKcV4+KXtB2QUB1B/NaPr1+t7lL0TpNWq0Z6PtJsYs8B6wB
        gNvipNnhZRE0D0y6kPZeNRYo5JLekke+moYUvi8grah1eZ8afHws9XFZZTPQnhOwmvfR9+
        3uIf0KVdYb2Vb9QLZ/0Nuj0/+4nSXSQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, jthoughton@google.com, kvm@vger.kernel.org
Subject: Re: [WIP Patch v2 12/14] KVM: arm64: Implement
 KVM_CAP_MEMORY_FAULT_NOWAIT
Message-ID: <ZBS5bzNRheg3g3kX@linux.dev>
References: <20230315021738.1151386-1-amoorthy@google.com>
 <20230315021738.1151386-13-amoorthy@google.com>
 <ZBSw/jh/WfAwu3ga@linux.dev>
 <CAF7b7mrG_jmrUohr9rXLBXS-uzJCwK6=BC5pyxE8O=Ov77WZ3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF7b7mrG_jmrUohr9rXLBXS-uzJCwK6=BC5pyxE8O=Ov77WZ3w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 12:00:30PM -0700, Anish Moorthy wrote:
> On Fri, Mar 17, 2023 at 11:27 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> 
> > > +     pfn = __gfn_to_pfn_memslot(
> > > +             memslot, gfn, exit_on_memory_fault, false, NULL,
> > > +             write_fault, &writable, NULL);
> >
> > As stated before [*], this google3-esque style does not match the kernel style
> > guide. You may want to check if your work machine is setting up a G3-specific
> > editor configuration behind your back.
> >
> > [*] https://lore.kernel.org/kvm/Y+0QRsZ4yWyUdpnc@google.com/
> 
> If you're referring to the indentation, then that was definitely me.
> I'll give the style guide another readthrough before I submit the next
> version then, since checkpatch.pl doesn't seem to complain here.
> 
> > > +     if (exit_on_memory_fault && pfn == KVM_PFN_ERR_FAULT) {
> >
> > nit: I don't think the local is explicitly necessary. I still find this
> > readable:
> 
> The local was for keeping a consistent value between the two blocks of code here
> 
>     pfn = __gfn_to_pfn_memslot(
>         memslot, gfn, exit_on_memory_fault, false, NULL,
>         write_fault, &writable, NULL);
> 
>     if (exit_on_memory_fault && pfn == KVM_PFN_ERR_FAULT) {
>         // Set up vCPU exit and return 0
>     }
> 
> I wanted to avoid the possibility of causing an early
> __gfn_to_pfn_memslot exit but then not populating the vCPU exit.

Ignore me, I didn't see the other use of the local.

-- 
Thanks,
Oliver
