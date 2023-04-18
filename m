Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F326E6AB7
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbjDRROz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjDRROv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:14:51 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADB715478
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 10:14:25 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2fa36231b1cso1258398f8f.2
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 10:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1681838063; x=1684430063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WZc11MEoV1JrWm0UyoOIRAlBssx8JIBOhjzT0xozkHY=;
        b=MBxZVc8bEWalAaspvBxNQW4D3xWeHWtSQ99yB5U0RFM9GXQHnWFIiX4LyM+0qq1rx8
         5HrTH2/9AXhyB4LoePVjFr4Q510MjtFoIHDVS6ZbyKiHfWI0iM+5A0kxICqb0nPwZhFV
         ZiJBF6/A7qvEhqzoVOqlgBUR4JtxGga8iB6PhTPYu2RO/wAb36nwvniq4du2khcGC/S5
         arhWpZ3P/bQYuacT1acSa8oDlVjF7xJPWNBg5O1CJopCk4j8AtsD93W0UPY5vK+Y+Inh
         kUS5Wg0bTogvDRaiQbkyrLtdw6w9NzXMDwZ2XJId1dmakmvkEaZ/DKh27x3oKx9vHUO9
         4rDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681838063; x=1684430063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZc11MEoV1JrWm0UyoOIRAlBssx8JIBOhjzT0xozkHY=;
        b=VafvdqQmVGuTnh1TFioUCDYoqAob6iWslIez5909BuBnSzidKiBoEDz5GC0GvCOSRm
         j+U9WfzG/VCV8svxqOlR2wDc/BB9cc0SNxb5qch/Z6kMOjgRQ42ZqWyjjPbrzqNFWqKi
         a/JgNwqdVQE41YK2ceIVQqJjQ7M9aKsB/6DTiVkwULvjQsM0mFrxJu3z0H3b+BwxjymG
         Ma4BcWeqJjF+tbn4nDn7FybfYH28gAKaBeqIyo1h7Ms5o9ZLuyVx+9pS+DmJFZcqPcmv
         nfJGxnZV2uTPQWCEZpSeaoZQCIRi8O+9UFkvWdG1+2TEqNRtaA/UpMthThSA24rxnwtK
         hQKQ==
X-Gm-Message-State: AAQBX9fuxnTVCsEeHbQcWTtdFG6l5qCKSNRxvgHNeRK7Un45OntwH1SJ
        Q3RQP18RMRdvfPmFxvTyae/KMg==
X-Google-Smtp-Source: AKy350Y5pVt7R+F04NOaFVOwnrRzSEDfSJC7MErzOl+avLnnFNmBk+XlvvRUNl2BkYVtsI8XdatgNQ==
X-Received: by 2002:adf:f10f:0:b0:2f7:efb1:ec8c with SMTP id r15-20020adff10f000000b002f7efb1ec8cmr2230828wro.23.1681838063610;
        Tue, 18 Apr 2023 10:14:23 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id i13-20020a5d438d000000b002cff06039d7sm13479414wrq.39.2023.04.18.10.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 10:14:23 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:14:22 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Ben Dooks <ben.dooks@codethink.co.uk>
Cc:     kvm@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH kvmtool 2/2] riscv: add zicboz support
Message-ID: <rpqhta5gr53y4rub3abgrumzgtsuucefydyhwrkgzjldv3gow2@mpp7rh23nuaa>
References: <20230418142241.1456070-1-ben.dooks@codethink.co.uk>
 <20230418142241.1456070-3-ben.dooks@codethink.co.uk>
 <ub3varg6spvwh5ihma4ossabuvbuvyxst63pra7rm2lfrkychf@4olgfsvgnij2>
 <89499b40-c64e-3c0b-8ab6-ce84e94768d1@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89499b40-c64e-3c0b-8ab6-ce84e94768d1@codethink.co.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 18, 2023 at 06:05:57PM +0100, Ben Dooks wrote:
> On 18/04/2023 16:00, Andrew Jones wrote:
> > On Tue, Apr 18, 2023 at 03:22:41PM +0100, Ben Dooks wrote:
> > > Like ZICBOM, the ZICBOZ extension requires passing extra information to
> > > the guest. Add the control to pass the information to the guest, get it
> > > from the kvm ioctl and pass into the guest via the device-tree info.
> > > 
> > > Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> > > ---
> > >   riscv/fdt.c                         | 11 +++++++++++
> > >   riscv/include/asm/kvm.h             |  2 ++
> > >   riscv/include/kvm/kvm-config-arch.h |  3 +++
> > >   3 files changed, 16 insertions(+)
> > 
> > Hi Ben,
> > 
> > I have a patch almost identical to this one here
> > 
> > https://github.com/jones-drew/kvmtool/commit/f44010451e023b204bb1ef9767de20e0f20aca1c
> > 
> > The differences are that I don't add the header changes in this patch
> > (as they'll come with a proper header update after Linux patches get
> > merged), and I forgot to add the disable-zicboz, which you have.
> > 
> > I was planning on posting after the Linux patches get merged so
> > I could do the proper header update first.
> > 
> 
> I thought they had been, I just cherry-picked them (although I may
> have just used linux-next instead of linux-upstream). I've been testing
> this under qemu so it seems to be working so far with what i've been
> doing.

Yeah, just -next, so far. Thanks for the testing!

drew
