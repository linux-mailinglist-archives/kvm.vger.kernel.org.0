Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF437A12A3
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 02:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjIOA6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 20:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjIOA6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 20:58:17 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4CA1FE8;
        Thu, 14 Sep 2023 17:58:13 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-411f5dd7912so9189961cf.3;
        Thu, 14 Sep 2023 17:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694739492; x=1695344292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aurhsUY805CR/jmu+UYpsE7OM+pAilUc0Fmf5u1fkxM=;
        b=gpUcyKbOuVtxmqM1dX9lmt9NcgLdszJ9CRe7kGFLSPuIBASVLOR5vGsJTmRJydkMm1
         BFQkakG0ClslqkHaPEJpStTmf2MGrYAtbfo4bN3vW7JsDWtEZ26aE3PRWUNEkw43kYcT
         FunXB0mTjrB2g+Ny8YQbTLjjieH3RzauLZd0tZMMaujq+rEXji9nr92xNrku6s58A7J1
         4csmhpKePrqbzL5sX+wYuuIh/leyyLLPK/+5FVh3TXroYDikpjPIcwrIIaI1Y97wUSrz
         sGVyfNxerFZSBqHhA5NQ+G7i6UanCmH+cRCsGRMrIohFqvYRbuLU7BY8RgCt4gZn34WV
         NSGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694739492; x=1695344292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aurhsUY805CR/jmu+UYpsE7OM+pAilUc0Fmf5u1fkxM=;
        b=BzJ7A82cltuVJJdxqLbIN8tRjNZUzPpjs1e1gHTi7quTNWJiIGaHj89cCfUF2SpERK
         z8iPce1p9Vr2/Ue/OF/gltbaweqqhHrHFTCB+QvejjKIETSk2GCRaYmh79FSmaEB9eJD
         LLir7LS/zJVgqCBIzHh+kzyKt/PWyg/z3EBB7P38o985JQWogtJ4dKU2uTGH+psqJdwt
         LAoeBdvc+eStB1oGolJEIPJSvM5oZ+V1NhprVtgqO9nCNbApTqFH3hWSISIzWSCp1mik
         i3jYt+Efybvv5Ary2ePC2f08jkCIyAHjYrExO4hIteRy0AJrRala2odKudEWP96zBjWA
         nZ2Q==
X-Gm-Message-State: AOJu0YzeURQbu1iig9fu81mTiBhfCuBMT5TO11gXSiDex2psjlUvJIBs
        I+UUZLWfp8eikju24zJIkQw=
X-Google-Smtp-Source: AGHT+IE8pQJc168AEGZqrMedTNa29B6IXR094f598Az5cy6AMU58LoQSq4tNHNYyYtK/31h8LuGNXA==
X-Received: by 2002:a05:622a:120b:b0:416:5e11:f7ec with SMTP id y11-20020a05622a120b00b004165e11f7ecmr291078qtx.52.1694739491756;
        Thu, 14 Sep 2023 17:58:11 -0700 (PDT)
Received: from luigi.stachecki.net (pool-108-14-234-238.nycmny.fios.verizon.net. [108.14.234.238])
        by smtp.gmail.com with ESMTPSA id g3-20020ac84803000000b0040331a24f16sm829847qtq.3.2023.09.14.17.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 17:58:11 -0700 (PDT)
Date:   Thu, 14 Sep 2023 20:58:42 -0400
From:   Tyler Stachecki <stachecki.tyler@gmail.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Leonardo Bras <leobras@redhat.com>, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dgilbert@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        bp@alien8.de, Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
Message-ID: <ZQOsQjsa4bEfB28H@luigi.stachecki.net>
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com>
 <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
 <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 10:05:57AM -0700, Dongli Zhang wrote:
> That is:
> 
> 1. Without the commit (src and dst), something bad may happen.
> 
> 2. With the commit on src, issue is fixed.
> 
> 3. With the commit only dst, it is expected that issue is not fixed.
> 
> Therefore, from administrator's perspective, the bugfix should always be applied
> no the source server, in order to succeed the migration.

I fully agree. Though, I think this boils down to:
The commit must be on the source or something bad may happen.

It then follows that you cannot live-migrate guests off the source to patch it
without potentially corrupting the guests currently running on that source...

Regards,
Tyler
