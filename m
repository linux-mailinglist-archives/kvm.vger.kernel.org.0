Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA8B63E1A8
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 21:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiK3UOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 15:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiK3UOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 15:14:15 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED4294567
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 12:11:23 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id r7so347601pfl.11
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 12:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DQo2PvCnu5Wc9S4lXOeBoFgv430bLe9pNyrVVyEzJ3g=;
        b=lCO8gV4FPgu8WJ7Bt66GeachwfUe/lATfOyMkaUUdOQofO5V2sqcRAPBqHSBDHj8SJ
         smxDKx0vNxE7lgDI14r+mfDteH/9wbWWOjzPo5od5A0CAhP1K5sTAfXkuXt0SxktvYLG
         4XZ0esy4mCgf4DZEXxW3HchbYDjU0y3Yp69JgQ/1G+PzapjEXb7b9dI7SD2euve6+7DN
         Mq60gcH85ByQ9h31riV5UunROxbSK/jPbDncSXdRLA8IqxY67y+8T7zAwnCFtVJmGq5U
         1Pi3k5BdnfRLXbbZcKXl2XJH9tKHe4VOTDZKn+365MeYhQ58IQb42Kwcxns3syNGp/4q
         3PkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQo2PvCnu5Wc9S4lXOeBoFgv430bLe9pNyrVVyEzJ3g=;
        b=b6MreVUaU0MybNuden2ww9T1bvuxyPHysQ2W9d87MRL/a4xdW9Sod46NoLh64NYQHy
         +E7q5Lm+qEwohETBiVeAmksB80YH+xLG9vpmDiRqc9uX9tmncBEHNFmmdjUSHorPve5F
         UjiUPR7B3k/zQcx63519Byjx1m35qR7PuVQWrJEanN7HYCUpIsTT753UmNl5BhSmKuTP
         IZ1hH/mjchzjfMfNjnujTBI6UPoHWzUxyB8fURZj4NkojUenUUXJiNbleHMceOWwK1kn
         fqKC/M65hqEjE6/jXNLvU5sJGHjN1FWt1JgikVF7S2XgfRMnvLxsj4k+EJbQ+KHWElK9
         lI4Q==
X-Gm-Message-State: ANoB5pnwtWoqHra5kmoIg+xX7JTdihYTrZMAGzDZRcG8HD9cR4uSyYSu
        +fdNjb/Ex7JrFjPTnbv7cc7MvA==
X-Google-Smtp-Source: AA0mqf5O4HcUod5UGDDd80bosaFI+41fh0Vv57D03K+qneRKX84tG+G5JTDyf3FL6nNt+En2xiuq8A==
X-Received: by 2002:a62:fb11:0:b0:56b:dbab:5362 with SMTP id x17-20020a62fb11000000b0056bdbab5362mr64288489pfm.47.1669839082014;
        Wed, 30 Nov 2022 12:11:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o13-20020a170902778d00b00176ba091cd3sm1875384pll.196.2022.11.30.12.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 12:11:21 -0800 (PST)
Date:   Wed, 30 Nov 2022 20:11:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, dmatlack@google.com, ricarkol@google.com
Subject: Re: [PATCH v10 0/4] randomize memory access of dirty_log_perf_test
Message-ID: <Y4e45hEzdW034SCP@google.com>
References: <20221107182208.479157-1-coltonlewis@google.com>
 <Y4eY/Yjj+FP+vf7Y@google.com>
 <87mt88tiqe.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mt88tiqe.wl-maz@kernel.org>
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

On Wed, Nov 30, 2022, Marc Zyngier wrote:
> On Wed, 30 Nov 2022 17:55:09 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Mon, Nov 07, 2022 at 06:22:04PM +0000, Colton Lewis wrote:
> > > Add the ability to randomize parts of dirty_log_perf_test,
> > > specifically the order pages are accessed and whether pages are read
> > > or written.
> > > 
> > > v10:
> > > 
> > > Move setting default random seed to argument parsing code.
> > > 
> > > Colton Lewis (4):
> > >   KVM: selftests: implement random number generator for guest code
> > >   KVM: selftests: create -r argument to specify random seed
> > >   KVM: selftests: randomize which pages are written vs read
> > >   KVM: selftests: randomize page access order
> > 
> > Does someone want to pick this up for 6.2? Also, what tree are we
> > routing these architecture-generic selftests changes through, Paolo's?
> 
> That's the usual route, but I can also take them if that makes
> someone's life easier. Just let me know.

Doh, sorry.  This is already in kvm/queue, I sent Paolo a pull request[*] for 6.2
for a bunch of the generic selftests updates a while back, but forgot to go back and
respond to the individual series to spread the news.

[*] https://lore.kernel.org/all/Y3WKCRJbbvhnyDg1@google.com
