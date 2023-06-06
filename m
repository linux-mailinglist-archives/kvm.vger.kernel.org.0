Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA964723416
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 02:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbjFFAgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 20:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjFFAgn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 20:36:43 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E9DA6;
        Mon,  5 Jun 2023 17:36:42 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b04949e5baso48296725ad.0;
        Mon, 05 Jun 2023 17:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686011802; x=1688603802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aVI8dupNDIedITeiCx39tP+I11M/SZEr3MwrAYz+yzY=;
        b=dGNYNid0Wp6HFqQolAlALyvrQjYSyEU74cpb8cZyb/Bt0ora6LnGhKCRaJD2qlFjkm
         IM9pT3MOqr2irJXnGCNRNYa7R+J/3xcu2HQkHCH4jO+HsZlEJbSbiG5zddQiLXHxuI+E
         +TFSVjXCOYu1rugAS4opQ2Bca+APv/6ouIWRHb+MgHgRJv513VyuYmu6Ij1Rs93c5Lt3
         OJC0OUgsZSsBysIOnJ0luLzOJ0qJHRfC5VDyPrmH5rp7SduRFHsq4dLJD968tJOD8JSP
         VpWcyDONmujSZdnsKJBwP8W2eXtB7jeMwAhQuQRTn1YRi4MrxvgHFASkUL0OE++n0Lfx
         2J4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686011802; x=1688603802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aVI8dupNDIedITeiCx39tP+I11M/SZEr3MwrAYz+yzY=;
        b=CQ+IqrVQbqylqpYgP0Ot18A2UE4mfJyKMcJw2B32u0+AGEWZebMJTkh4/qFjKpKnLi
         gE3SOCEkDEwue3zC+uLIsSjhCuDBqFG1DnJLEtDW4+7lBTOq5e1334gwtFCjpleVRXFI
         zi3b9vnVVX6tFyQfcTVCBqd/89qqDq6MYAmRG/iySXHlxFRiPMs7+wWz02d7u2cQ+gjX
         8uVQ8JzalT+43HYyPZ3u6HsoW7+K1CAjYDNyvNr6F+2Dq59bLUQO5fbWG9tcFwWlASUB
         vj1XbQC1t07EshEs1+m2RqdluInkn6TXBtDspAWsAqGtQ6l4M/wDmd1c3yRt8+cS87HU
         yaAQ==
X-Gm-Message-State: AC+VfDxbEoy0KbI+3E+NJv01inxKo1Ykzmnijc+LpSTSYhktLGc9KAqE
        OEY8pb0Lw+9fGP0PrnW0C70=
X-Google-Smtp-Source: ACHHUZ47A9aim+b5IhNEHoXo9V1kV7FAiSwO+95+hBWVTQOnbkM9oW1ZP/zYMjIZhQicjTxf2tb08Q==
X-Received: by 2002:a17:903:44b:b0:1a9:b0a3:f03a with SMTP id iw11-20020a170903044b00b001a9b0a3f03amr581108plb.9.1686011802165;
        Mon, 05 Jun 2023 17:36:42 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id x16-20020a1709027c1000b001b04b1bd774sm7140433pll.208.2023.06.05.17.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 17:36:41 -0700 (PDT)
Date:   Mon, 5 Jun 2023 17:36:39 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v11 00/20] TDX host kernel support
Message-ID: <20230606003639.GB2244082@ls.amr.corp.intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:13AM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
> host and certain physical attacks.  TDX specs are available in [1].
> 
> This series is the initial support to enable TDX with minimal code to
> allow KVM to create and run TDX guests.  KVM support for TDX is being
> developed separately[2].  A new "userspace inaccessible memfd" approach
> to support TDX private memory is also being developed[3].  The KVM will
> only support the new "userspace inaccessible memfd" as TDX guest memory.
> 
> This series doesn't aim to support all functionalities, and doesn't aim
> to resolve all things perfectly.  All other optimizations will be posted
> as follow-up once this initial TDX support is upstreamed.
> 
> Also, the patch to add the new kernel comline tdx="force" isn't included
> in this initial version, as Dave suggested it isn't mandatory.  But I
> will add one once this initial version gets merged.
> 
> (For memory hotplug, sorry for broadcasting widely but I cc'ed the
> linux-mm@kvack.org following Kirill's suggestion so MM experts can also
> help to provide comments.)
> 
> Hi Dave, Kirill, Tony, Peter, Thomas, Dan (and Intel reviewers),
> 
> The new relaxed TDX per-cpu initialization flow has been verified.  The
> TDX module can be initialized when there are offline cpus, and the
> TDH.SYS.LP.INIT SEAMCALL can be made successfully later after module
> initialization when the offline cpu is up.
> 
> This series mainly added code to handle the new TDX "partial write
> machine check" erratum (SPR113) in [4].
> 
> And I would appreciate reviewed-by or acked-by tags if the patches look
> good to you.  Thanks in advance!

I've rebased the TDX KVM patch series v14 [1] with this patch series and
uploaded it at [2].  As the rebased TDX KVM patches doesn't have any changes
except trivial rebase fixes, I don't post something like v14.1.

[1] https://lore.kernel.org/lkml/cover.1685333727.git.isaku.yamahata@intel.com/
[2] https://github.com/intel/tdx/tree/kvm-upstream-workaround
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
