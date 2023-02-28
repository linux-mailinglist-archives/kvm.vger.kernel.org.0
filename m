Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3226A516D
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 03:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjB1Ctf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 21:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB1Cte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 21:49:34 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA6BCA32;
        Mon, 27 Feb 2023 18:49:32 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-172094e10e3so9556358fac.10;
        Mon, 27 Feb 2023 18:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CersIx0kd6XeO/gD5iEHLIOsr4GuTqA4PsWEpd2HTVA=;
        b=d7wYHhkrTxTdtW6atj/z6oxITPp75ihK3afm3ATklMmvD8EKlgxJdo3Z+yiAF8tzw4
         Gpr1thdiHiI0/L+1gG0oZmno9JP/w3RdWAE8tHH/0eC6CjvgR7cv/lE9mF8ts4Lyw8MK
         ElN6UQqrAdJff7toxzCVbhr3/69XJljV7TuKhg/Uq3khDGfHwyqyeIFufPV1UkC4r5hU
         qK0A0/Lzzk0ZH/PMX3me9zAh8FdZnUKe1nYS6cKbaUB8vl3OVqFEWig4VQ8qRYszJS1d
         iNBrFRWmn7fphL/tlBhqJV/U8hI5NphdUQM9BAZpNmZMH3kOsIRyO+0co/o0znG9d/q6
         o38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CersIx0kd6XeO/gD5iEHLIOsr4GuTqA4PsWEpd2HTVA=;
        b=oWAWgTe7ZZGE+vboMYGqsD/f05WalIZD62TZc0Aev7scdUj4EG0gL2dOp29b+ZLqKQ
         9NXmFMbSMgdI9UyZUb+eBkDMatZysdeMEv4B5SIG1TuWkWTHW2Rz8IxebH6za9EW6XgU
         zZERQGdr8TFHzpNJHn/QaNWVpXCObkFbBAPrPi5za/Sunb06PWE0FG0VwMwih/s7mIPt
         ktKRPw3pk6NyPEZYekeR3y6XOOfIoeJFL8mTanIFfxoxRzjYNI2zzdgX2U/F1fkOdg9i
         QTssBHIKzm1mqdmLSMLgWopTfopFOI91puXR2elrKoGSRJGekb+cO1DSvxDl7M/Fx5OU
         3YJg==
X-Gm-Message-State: AO0yUKXXZooFpg87Yjn2A8sUCeYED/xA60e/KP9tGtuo1ty1z1B/Pu/D
        bYDpEVmCHVdgSMsnMK/iHlE=
X-Google-Smtp-Source: AK7set/ZLfanWGn2W5w4Xvp0TN2ajODli+jEfK+pasdVSe3Y9NUEEH2fNVrXxA53KQ6A4bZd5mavnw==
X-Received: by 2002:a05:6870:3125:b0:16e:90d0:e6a3 with SMTP id v37-20020a056870312500b0016e90d0e6a3mr590835oaa.9.1677552571625;
        Mon, 27 Feb 2023 18:49:31 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id e5-20020a056870450500b0013b911d5960sm2873050oao.49.2023.02.27.18.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 18:49:30 -0800 (PST)
Date:   Mon, 27 Feb 2023 18:49:29 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] lib/test_bitmap: increment failure counter properly
Message-ID: <Y/1ruRmnY4eU536Q@yury-laptop>
References: <20230227214524.914050-1-yury.norov@gmail.com>
 <Y/00yaVqK2x3+pP3@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/00yaVqK2x3+pP3@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 12:55:05AM +0200, Andy Shevchenko wrote:
> On Mon, Feb 27, 2023 at 01:45:23PM -0800, Yury Norov wrote:
> > The tests that don't use expect_eq() macro to determine that a test is
> > failured must increment failed_tests explicitly.
> 
> ...
> 
> >  			pr_err("bitmap_copy_arr32(nbits == %d:"
> >  				" tail is not safely cleared: %d\n",
> 
> Usually we don't split string literals (since checkpatch doesn't complain on a
> looong lines with them at the end of the line),
> 
> ...
> 
> >  			pr_err("bitmap_copy_arr64(nbits == %d:"
> >  				" tail is not safely cleared: %d\n", nbits, next_bit);
> 
> Ditto.
> 
> P.S. Seems a material for another patch.

If you're OK with this patch, can you give your review tag please?

Thanks,
Yury
