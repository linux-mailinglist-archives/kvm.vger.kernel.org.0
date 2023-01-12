Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6FE666FD5
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 11:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjALKjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 05:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjALKiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 05:38:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C085584E
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 02:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673519494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d13KL8x/5My4Hrns01HyF5fP7AwMPPejudzCmpqjaxQ=;
        b=d33MK1WGWFiFRw+9Fyjs/u8BzR+bD5jli8Fws3wIKF4Blqt2h9revzSMoNRpwDDF0Rsj/q
        gHer19OdJ7dUz/1sWpRMNqbUBrQ+TvbmDn9SU8JzEeFPaCoLBp5Dyp/FBEBznRDXlqhmDu
        OWiqtlX0B6pRjxqIh0PtIi8FEfZBlxc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-369-wLum4XC3PvuaMSoBe5oYIg-1; Thu, 12 Jan 2023 05:31:33 -0500
X-MC-Unique: wLum4XC3PvuaMSoBe5oYIg-1
Received: by mail-wm1-f72.google.com with SMTP id q21-20020a7bce95000000b003d236c91639so4116980wmj.8
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 02:31:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d13KL8x/5My4Hrns01HyF5fP7AwMPPejudzCmpqjaxQ=;
        b=JLaeJO3rCokzfkHRMaC4vVUcRWgA3kFT+g9lJfK83Srhs3orbst2IOgrTrsmXUvMU6
         YBxxuHd7aZJkQo0NUDQBkmcHNEzzvarkw3qRHW6p2wIBYGmDjE9i4LzOhmnzJtzNgFyu
         s6iDhPdev6hyA4wlhOdjzllf+kj+C7Y+IoAHU02vokpO/3zHc2dGfq59pm06PKSRMCzo
         A+gO1uc7/ref+lp2a/jdq6BtD5PjnMOW00cipDxr3/AoL+ucmsWXVMj+7c+GbOh8bon6
         GVaJPletewRa4WQ/rUnT+fA+heAmfQOjb8qI9XFHOoeOlzEowcbZTNH2KKj0UHo6ULPc
         tUnQ==
X-Gm-Message-State: AFqh2kpuS3LojsJNoMJ1wtiYKuNr+ExsNSSveM0I2hJvlobDXyMb97ls
        VbrjQtdfPjv/0xdI/foCilp0k0gpiq0nb9WFcB7drq/r+5UhV7nNF/jZGzKR40f01lf4tq7I1Pm
        kE8hbDlZpj0Fu
X-Received: by 2002:a1c:ed19:0:b0:3d3:52bb:3984 with SMTP id l25-20020a1ced19000000b003d352bb3984mr55851474wmh.17.1673519492357;
        Thu, 12 Jan 2023 02:31:32 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv+pSB25y0r7askouK+s08X+9rW7JiV82+G1/D5MIClZENG0NSkfEb8ZDss3pKnnHa168s3uQ==
X-Received: by 2002:a1c:ed19:0:b0:3d3:52bb:3984 with SMTP id l25-20020a1ced19000000b003d352bb3984mr55851459wmh.17.1673519492121;
        Thu, 12 Jan 2023 02:31:32 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id q6-20020a05600c46c600b003d1f3e9df3csm27873970wmo.7.2023.01.12.02.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 02:31:31 -0800 (PST)
Message-ID: <6d989ca2330748ed682c81fc5f43e054a70e70a8.camel@redhat.com>
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jiri Slaby <jirislaby@kernel.org>,
        Pedro Falcato <pedro.falcato@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>, yuzhao@google.com,
        Michal Hocko <MHocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, shy828301@gmail.com
Date:   Thu, 12 Jan 2023 12:31:29 +0200
In-Reply-To: <7aa90802-d25c-baa3-9c03-2502ad3c708a@kernel.org>
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
         <CAKbZUD0Tqct_G9OcO8ocdH1J_YvLSEod-ofr97hsyoHgcvBwuw@mail.gmail.com>
         <7aa90802-d25c-baa3-9c03-2502ad3c708a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-01-12 at 07:07 +0100, Jiri Slaby wrote:
> Hi,
> 
> On 12. 01. 23, 1:37, Pedro Falcato wrote:
> > I just want to chime in and say that I've also hit this regression
> > right as I (Arch) updated to 6.1 a few weeks ago.
> > This completely ruined my qemu workflow such that I had to fallback to
> > using an LTS kernel.
> > 
> > Some data I've gathered:
> > 1) It seems to not happen right after booting - I'm unsure if this is
> > due to memory pressure or less CPU load or any other factor
> 
> +1 as I wrote.
> 
> > 2) It seems to intensify after swapping a fair amount? At least this
> > has been my experience.
> 
> I have no swap.
> 
> > 3) The largest slowdown seems to be when qemu is booting the guest,
> > possibly during heavy memory allocation - problems range from "takes
> > tens of seconds to boot" to "qemu is completely blocked and needs a
> > SIGKILL spam".
> 
> +1
> 
> > 4) While traditional process monitoring tools break (likely due to
> > mmap_lock getting hogged), I can (empirically, using /bin/free) tell
> > that the system seems to be swapping in/out quite a fair bit
> 
> Yes, htop/top/ps and such are stuck at the read of /proc/<pid>/cmdline 
> as I wrote (waiting for the mmap lock).
> 
> > My 4) is particularly confusing to me as I had originally blamed the
> > problem on the MGLRU changes, while you don't seem to be swapping at
> > all.
> > Could this be related to the maple tree patches? Should we CC both the
> > MGLRU folks and the maple folks?
> > 
> > I have little insight into what the kernel's state actually is apart
> > from this - perf seems to break, and I have no kernel debugger as this
> > is my live personal machine :/
> > I would love it if someone hinted to possible things I/we could try in
> > order to track this down. Is this not git-bisectable at all?
> 
> I have rebooted to a fresh kernel which 1) have lockdep enabled, and 2) 
> I have debuginfo for. So next time this happens, I can print held locks 
> and dump a kcore (kdump is set up).
> 
> regards,

It is also possible that I noticed something like that on 6.1:

For me it happens when my system (also no swap, 96G out which 48 are permanetly reserved as 1G hugepages,
and this happens with VMs which don't use this hugepage reserve) 
is somewhat low on memory and qemu tries to lock all memory (I use -overcommit mem-lock=on)

Like it usually happens when I start 32 GB VM while having lot of stuff open in background, but
still not nearly close to 16GB.
As a workaround I lowered the reserved area to 32G.

I also see indication that things like htop or even opening a new shell hang quite hard.

What almost instantly helps is 'echo 3 | sudo tee /proc/sys/vm/drop_caches'
e.g that makes the VM start booting, and unlocks everything.

Best regards,
	Maxim Levitsky

