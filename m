Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166935F359F
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 20:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiJCSaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 14:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiJCSaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 14:30:03 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379D01B9CC;
        Mon,  3 Oct 2022 11:30:02 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x6so5148542pll.11;
        Mon, 03 Oct 2022 11:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=quIgCgRAvmLnWJPCTbrEcsbNq5GjcI65KpXXTyJEpPI=;
        b=VJo8ZgGEiUfkm23RawqcDochrjJ54YaEUFiM9EgCv/9dWyVPnauYNYBiSL6wmd9xbp
         5kEXDnzYIHs4oTz91xwxsgNQBP1wPVdfn6q8WR6BG/XkiB4Z6VGwAzlQRWwUG9whqEKc
         uf7J8B5kX5jHMQ3o5SPasg2CQLs4uVMj2BJPlaLkWhw+ILySMgNEFScuunbfqT2xWcvZ
         dzYR8WnAxg9qBCHU+szAqApyuV1A5nrozzRYQ/cJU8P6ZmGQDYiI5RqnU3aaHmoWaNwU
         3d5E4gskAYfoYxEDsMyp+TijwAhX9Stj/GvI4pE1QEGP6nTXxPm6DdZhyWZCWXigTILs
         a4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=quIgCgRAvmLnWJPCTbrEcsbNq5GjcI65KpXXTyJEpPI=;
        b=od8f2F7Dh2BOF46sfsElzjKTmtJ8zjoY/r+W0NM+VPHv76EioU+DYBQOm17Q5KQgR2
         TfW8UTLH8BYPK/io/HUhDbO23cngRDk3YgBp8CAeJ7Iem13lkuNoolvB0GZRW4+8CRBY
         +Eem00NlHa5IytOMCRLbdibeAOlKuhM7xuuF02QdOwhDacRreY849g8rObXFot3hTOBX
         ExJJxBux0Kv0uFIuPfF/o6hNpOAHZvf/xsblC8maQnvxT+bZhFNKC8Nbta5tUb2kBQYh
         5BvfeLwwTn/SoxJXZTY75veGzgbMnGlD8WOpjRbZzHhRWXtASwFx2x10aKOuAmlc9uVs
         5vlA==
X-Gm-Message-State: ACrzQf14uR+/eyZ4UCEjXNr7H8Iis+pS6xh8spvo/zcEo1gz3Hu8Ov5B
        gkhiXkUffnHgzTDr38hGIxw=
X-Google-Smtp-Source: AMsMyM6fuFP0t7eskMGY/4IPQ+1SGu/XRA4xxdhe2wIENOab7R7fxC8kGn2S1naKJyWw12CQV2OSsg==
X-Received: by 2002:a17:902:ce0c:b0:179:ffc1:eb1b with SMTP id k12-20020a170902ce0c00b00179ffc1eb1bmr22983518plg.41.1664821801612;
        Mon, 03 Oct 2022 11:30:01 -0700 (PDT)
Received: from localhost (c-107-3-154-88.hsd1.ca.comcast.net. [107.3.154.88])
        by smtp.gmail.com with ESMTPSA id m188-20020a6258c5000000b0054087e1aeb4sm7687147pfb.111.2022.10.03.11.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 11:30:00 -0700 (PDT)
Date:   Mon, 3 Oct 2022 11:29:59 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v9 000/105] KVM TDX basic feature support
Message-ID: <20221003182959.GA654699@private.email.ne.jp>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
 <Yzf6tD9HZasmPVvY@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yzf6tD9HZasmPVvY@debian.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 01, 2022 at 03:30:44PM +0700,
Bagas Sanjaya <bagasdotme@gmail.com> wrote:

> On Fri, Sep 30, 2022 at 03:16:54AM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > KVM TDX basic feature support
> > 
> > Hello.  This is v9 the patch series vof KVM TDX support.
> > This is based on v6.0-rc7 + the following patch series with minor update like
> > compile fix.
> > 
> > - TDX host kernel support v5
> >   https://lore.kernel.org/lkml/cover.1655894131.git.kai.huang@intel.com/
> > - kvm hardware initialization v5
> >   https://lore.kernel.org/lkml/cover.1663869838.git.isaku.yamahata@intel.com/
> > - fd-based approach for supporing KVM v8
> >   https://lore.kernel.org/lkml/20220915142913.2213336-1-chao.p.peng@linux.intel.com/
> > 
> > The tree can be found at https://github.com/intel/tdx/tree/kvm-upstream
> > How to run/test: It's describe at https://github.com/intel/tdx/wiki/TDX-KVM
> > 
> > Major changes from v8:
> > - rebased to v6.0-rc7
> > - Integrated with kvm hardware initialization.  Check all packages has at least
> >   one online CPU when creating guest TD and refuse cpu offline during guest TDs
> >   are running.
> > - Integrated fd-based private page v8 as prerequisite.
> > - TDP MMU: Introduced more callbacks instead of single callback.
> > 
> > Thanks,
> > Isaku Yamahata
> > 
> 
> Hi Isaku,
> 
> I'm still getting the same htmldocs warnings as in v8 (see [1]). It seems
> like the fixup there has not been applied to this version.
> [1]: https://lore.kernel.org/lkml/YvCHRuq8B69UMSuq@debian.me/

Hi. Thanks for testing it.

Those errors came from TDX host kernel support patch. [2]. Added Kai, the author
of the patch series.  As You've already pointed out, it will be fixed by the
next respin of the patch series.

[2] https://lore.kernel.org/lkml/0712bc0b05a0c6c42437fba68f82d9268ab3113e.1655894131.git.kai.huang@intel.com/

thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
