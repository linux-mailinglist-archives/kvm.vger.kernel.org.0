Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385FE611C2B
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 23:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiJ1VHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 17:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiJ1VHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 17:07:19 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A31F2498BC
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 14:07:18 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 78so5834420pgb.13
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 14:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UDvnt6hJdC85bIIuyvRtSYc6T/Aw/x8KSS4OPVp7Eu0=;
        b=MQdzFTdHFNso6vpqJNoM5/T9OKSHQtkb3cg1GKIer3JgNE/bl274M2j+TzTTY07b7P
         0Gl7rHwrTfAZqDM3v6w5sper3i0kBwx5dNkSe+go/kF0IV3dMR74zutbFgvTZPsnEbqa
         nlVkt88XTiRJFNSqEKgZ4KPu+AM/9tqZGV4nL6+HonRnwRHv+0z/jcQuP0F/rI858Sns
         zAMFvqt0/HpbuJa/6EfQuW9RWyShcg66Lu8smU/kupwt1JeyigYEx78IDHJIHlg2JOdX
         GQ+igiUb2D2Ufr2pah/4vYgjOan6RGjJNLnpAnRTF3o4ish5wneUXRCdt+p5coJfrdfb
         +C3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UDvnt6hJdC85bIIuyvRtSYc6T/Aw/x8KSS4OPVp7Eu0=;
        b=nEzgj+xBXc3+c6XX7dnVaE74+94RfnZmxom0AIj719suw+yUZJa7fngGj6YO9K7p+b
         SZbCXS3eM6LwZc/4zK7Gw0ThfUqK0uj562mrPn96oZFP5a0u2NoehPahvrT9LjQkUIi+
         1bdNB/ugDjJPGucTJSEckZw4rwUXt4HbSlsjpJeUoFvJA01HrsLYAv+tMAU4fSYwnZIG
         3oplVYVEThSWED4rsxdT9dr8tyZ2dvaN9QXIZf2teBwoZ/Vgkd7YIkaixjAAlwSPDetE
         XoEwSGqyxf9hSyDIP0gxAtLah61AMFsJTjbHWmG86fjNpagX0zR/vqHtLPFscFEubpPB
         AkzA==
X-Gm-Message-State: ACrzQf2Tq8O03sfwZUGQYCnIW2HjEWrAveCNl/Yr0BTWdleCseQ3y2KQ
        fy1rGRirmyVrou4XtvMbh6By3w==
X-Google-Smtp-Source: AMsMyM7IumcAaQM2gitHovs4h6XPqASaO9QtAkEzDSdxFj6zCIixnvxLVhNlZmJ/gDdBVDtgY/7mdw==
X-Received: by 2002:a05:6a00:21d6:b0:569:9de2:f169 with SMTP id t22-20020a056a0021d600b005699de2f169mr1370105pfj.9.1666991238052;
        Fri, 28 Oct 2022 14:07:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jl17-20020a170903135100b00186a437f4d7sm3477689plb.147.2022.10.28.14.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:07:17 -0700 (PDT)
Date:   Fri, 28 Oct 2022 21:07:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Do not recover NX Huge Pages when
 dirty logging is enabled
Message-ID: <Y1xEggz1oeNObHuP@google.com>
References: <20221027200316.2221027-1-dmatlack@google.com>
 <7314b8f3-0bda-e52d-1134-02387815a6f8@redhat.com>
 <CALzav=e-gJ77LCo7HsL4X37B96njySebw8DGbPV_xcHbhaCBag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=e-gJ77LCo7HsL4X37B96njySebw8DGbPV_xcHbhaCBag@mail.gmail.com>
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

On Fri, Oct 28, 2022, David Matlack wrote:
> I'll experiment with a more accurate solution. i.e. have the recovery
> worker lookup the memslot for each SP and check if it has dirty
> logging enabled. Maybe the increase in CPU usage won't be as bad as I
> thought.

If you end up grabbing the memslot, use kvm_mmu_max_mapping_level() instead of
checking only dirty logging.  The way KVM will avoid zapping shadow pages that
could have been NX huge pages when they were created, but can no longer be NX huge
pages due to something other than dirty logging, e.g. because the gfn is being
shadow for nested TDP.
