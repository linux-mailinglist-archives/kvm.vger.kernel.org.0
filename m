Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECD66ED4C2
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 20:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjDXSuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 14:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbjDXSts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 14:49:48 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9524AD3D
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 11:48:52 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a950b982d4so295445ad.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 11:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682362128; x=1684954128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6sxwJ2XPFL4yJmvwi9B1Y4hneGwQ5VLqgnkViiEsclA=;
        b=Rm3Lf5HvrWwY7n2wtKUiYWPHacaTO2uoxblgFkjNb01lffKP+q/aAkz+JBrBp8rKyb
         FxvcJQ4aqNcb6xeCwWUlxKd6ltY0X369tk4pTwqg7rp1j7maV2AAXHzNmjCRrC0Yk1kJ
         TSLds/QR0NvBi//fTjYlTETM6IeZRR6tlEpMRqOiqnhu6BMa79vars6PM+Uc5HnpEAne
         ZXgivlF7Txw190HJQroXrKi/kVHp6X8JW2mf3HjqEvAv2b8oPSxt2zuRL5fxU7U6mkE8
         bXLgUXfq7gZzZu1/h9NLaD/3+BP/1l5PQCLsagrYbdT+saeKSZA/faCqS1PukXW7aLbT
         fiVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682362128; x=1684954128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6sxwJ2XPFL4yJmvwi9B1Y4hneGwQ5VLqgnkViiEsclA=;
        b=NhDkY8HZK4kbHvnBFJqpgzzkgm/pdGkbfS12FEZc4AHnPHQhboWvon1Q7YlRr8WDeJ
         aHaONA9B5BG7Ao+8na3oIeHQaPGheb76RyYZs2AUX3u+wHZo7V3zda5V9lRDtRSAc17o
         Skoq+x7mKxHNv7JO3jUXzmIdE9nfP+ZDdLMEndfVmbQd+La9AZKQ7LuExrqW10Xek9u/
         Hx/r6ocIahiv5oEE4gM5zWDwQvNItZahY6h/yWn0GlOkWu4A3hR8SLKMQA3hNhp1V3Mg
         KJcX1KtWV/w5lxMvwNvCgjsgYoX9Dy7zR12scdrmdn1/9pq/kPqVX0MjFLqZmz21216H
         JD6w==
X-Gm-Message-State: AC+VfDw6MpuTaradH5YXIOIQhAeFUwc0G+kINN1FjDeVLKsG20GBL/Cu
        gxBtNaBzFM47aJir+rwKR/XtUA==
X-Google-Smtp-Source: ACHHUZ5Qgk1rMuDlBg9HB18BOZCveMuOE2Fm9KnJuyG52MfVTecSMpx87LhAreSqqm9duF2lfYC50g==
X-Received: by 2002:a17:902:d2cc:b0:198:af4f:de07 with SMTP id n12-20020a170902d2cc00b00198af4fde07mr15721plc.7.1682362128414;
        Mon, 24 Apr 2023 11:48:48 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id l9-20020a170902d34900b001a1c721f7f8sm6864279plk.267.2023.04.24.11.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 11:48:47 -0700 (PDT)
Date:   Mon, 24 Apr 2023 11:48:44 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v7 08/12] KVM: arm64: Add
 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
Message-ID: <ZEbPDI+amuG1cGZ/@google.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-10-ricarkol@google.com>
 <58664917-edfa-8c7a-2833-0664d83277d6@redhat.com>
 <ZEWUvTmdfSOwOPOz@google.com>
 <e3b0baba-dc0d-f634-e53f-59cc0fd99973@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3b0baba-dc0d-f634-e53f-59cc0fd99973@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023 at 07:14:21PM +0800, Gavin Shan wrote:
> On 4/24/23 4:27 AM, Ricardo Koller wrote:
> > On Mon, Apr 17, 2023 at 03:04:47PM +0800, Gavin Shan wrote:
> > > On 4/9/23 2:29 PM, Ricardo Koller wrote:
> > > > Add a capability for userspace to specify the eager split chunk size.
> > > > The chunk size specifies how many pages to break at a time, using a
> > > > single allocation. Bigger the chunk size, more pages need to be
> > > > allocated ahead of time.
> > > > 
> > > > Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> > > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > > ---
> > > >    Documentation/virt/kvm/api.rst       | 28 ++++++++++++++++++++++++++
> > > >    arch/arm64/include/asm/kvm_host.h    | 15 ++++++++++++++
> > > >    arch/arm64/include/asm/kvm_pgtable.h | 18 +++++++++++++++++
> > > >    arch/arm64/kvm/arm.c                 | 30 ++++++++++++++++++++++++++++
> > > >    arch/arm64/kvm/mmu.c                 |  3 +++
> > > >    include/uapi/linux/kvm.h             |  2 ++
> > > >    6 files changed, 96 insertions(+)
> > > > 
> > > 
> > > With the following comments addressed:
> > > 
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > 
> 
> [...]
> 
> > > 
> > > > +static inline bool kvm_is_block_size_supported(u64 size)
> > > > +{
> > > > +	bool is_power_of_two = !((size) & ((size)-1));
> > > > +
> > > > +	return is_power_of_two && (size & kvm_supported_block_sizes());
> > > > +}
> > > > +
> > > 
> > > IS_ALIGNED() maybe used here.
> > 
> > I've been trying to reuse some bitmap related function in the kernel,
> > like IS_ALIGNED(), but can't find anything. Or at least it doesn't occur
> > to me how.
> > 
> > kvm_is_block_size_supported() returns true if @size matches only one of
> > the bits set in kvm_supported_block_sizes(). For example, given these
> > supported sizes: 10000100001000.
> > 
> > kvm_is_block_size_supported(100000000) => true
> > kvm_is_block_size_supported(1100) => false
> > 
> 
> I was actually thinking of @is_power_of_two is replaced by IS_ALIGNED(),
> For example:
> 
> static inline bool kvm_is_block_size_supported(u64 size)
> {
>     return IS_ALIGNED(size, size) && (size & kvm_supported_block_sizes());
> }
> 
> IS_ALIGNED() is defined in include/linux/align.h, as below. It's almost
> similar to '((size) & ((size)-1))'
> 
> #define IS_ALIGNED(x, a)                (((x) & ((typeof(x))(a) - 1)) == 0)

Ah! you are right, yes, will use this instead.

Thanks,
Ricardo

> 
> Thanks,
> Gavin
> 
