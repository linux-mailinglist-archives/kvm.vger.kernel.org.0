Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EDF5786FB
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 18:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbiGRQHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 12:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiGRQHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 12:07:38 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E6A193F6
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 09:07:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x18-20020a17090a8a9200b001ef83b332f5so18745455pjn.0
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 09:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9TtjPFua9h2nXvdI295iIvL1KzKHe3EXSfFcAruP83w=;
        b=B1Vkgcwjmw7wF5OIqM2gALnGlnAyAG2yQwQgXfjRGkFUma/YPHJARaaTbp8wa8XRog
         pi3U2WHIL4JMGTI+Zv6aZiB6++EXbxB3vvgnUGeAwsiBqntL6dRUfOLSo7+sLb0c81/g
         U5QYnMbZfJrA377IZT504TiE60Ki5Vv39eUJG/NHOStwhRr+9aGua9xCVJsqxV/uWs2L
         9zlcIITsUvYq3cMWOCrBIUGIbj4xdKDFvaAsNyVPAzJVJlhNlHAJxTBp8rP7W9n4fdlx
         Iy7cNHfe12sNoT0KG0JgFeVDPH5TNda7JAhcfxiNHGQINO8TSKIB6K9EKAqNhtHXKAHM
         xu7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9TtjPFua9h2nXvdI295iIvL1KzKHe3EXSfFcAruP83w=;
        b=15yMox1uXe7QfRuFYCViv6OJDP78j6bqAXfarHqr5olW9fsGBLFH+FQ9665FBnU+hZ
         jajbZzOIxiPh1fQA39dLlCE2pUE0Nn6/hKNQlb1BpH8lFPYWN5W9GsKyoWU012rnQIIq
         Zk//+yjIpVwnzyn8j5HXkm7400BWgo8lAxgdUe9WOvGC7IiAo4Nx2/DNC8bV4cRtL88B
         ObTo91Zza4eVLylPoB8h0A/oxGdKF362XJqDBIB4ydIcgTBLcNh5lz9lC8umMT6dOvaD
         wI4QyN+RUQq1XMsspjIuLOJWvpWT/7OAXDGSPFZCRGTVZbU+YwODgiHbzQvrZe2doNos
         9tiA==
X-Gm-Message-State: AJIora9DKuRfZ7udx6WIdOtG7ozCgt9yWcYsRSBK2qyHpJTwxBX6BPHf
        BVbNSY75RIAVxDYftzgpAAJqxQ==
X-Google-Smtp-Source: AGRyM1sIk3+b4iopeDoB9IY63nrGzfKZs7lewxCPMQpTqmN00GDEE8+iAFs4O2M8lemnUJ7n5XYrrQ==
X-Received: by 2002:a17:90b:3a84:b0:1f0:56d5:4604 with SMTP id om4-20020a17090b3a8400b001f056d54604mr32203421pjb.41.1658160457262;
        Mon, 18 Jul 2022 09:07:37 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b0016bc947c5b7sm9669163pls.38.2022.07.18.09.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 09:07:36 -0700 (PDT)
Date:   Mon, 18 Jul 2022 16:07:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Add shadow mask for effective host
 MTRR memtype
Message-ID: <YtWFRTg4Is7XFld9@google.com>
References: <20220715230016.3762909-1-seanjc@google.com>
 <20220715230016.3762909-4-seanjc@google.com>
 <580a46b4623309474bb3207ea994eb9b5a3603a7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <580a46b4623309474bb3207ea994eb9b5a3603a7.camel@redhat.com>
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

On Mon, Jul 18, 2022, Maxim Levitsky wrote:
> On Fri, 2022-07-15 at 23:00 +0000, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index ba3dccb202bc..cabe3fbb4f39 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -147,6 +147,7 @@ extern u64 __read_mostly shadow_mmio_value;
> >  extern u64 __read_mostly shadow_mmio_mask;
> >  extern u64 __read_mostly shadow_mmio_access_mask;
> >  extern u64 __read_mostly shadow_present_mask;
> > +extern u64 __read_mostly shadow_memtype_mask;
> >  extern u64 __read_mostly shadow_me_value;
> >  extern u64 __read_mostly shadow_me_mask;
> >  
> 
> 
> So if I understand correctly:
> 
> 
> VMX:
> 
> - host MTRRs are ignored.
> 
> - all *host* mmio ranges (can only be VFIO's pci BARs), are mapped UC in EPT,
>  but guest can override this with its PAT to WC)
> 
> 
> - all regular memory is mapped WB + guest PAT ignored unless there is noncoherent dma,
>  (an older Intel's IOMMU? I think current Intel's IOMMLU are coherent?)

Effectively, yes.

My understanding is that on x86, everything is cache-coherent by default, but devices
can set a no-snoop flag, which breaks cache coherency.  But then the IOMMU, except for
old Intel IOMMUs, can block such packets, and VFIO forces the block setting in the IOMMU
when it's supported by hardware.

Note, at first glance, commit e8ae0e140c05 ("vfio: Require that devices support DMA
cache coherence") makes it seem like exposing non-coherent DMA to KVM is impossible,
but IIUC that's just enforcing that the _default_ device behavior provides coherency.
I.e. VFIO will still allow an old Intel IOMMU plus a device that sets no-snoop.
