Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAD55EC8D5
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 18:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiI0QBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 12:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiI0QA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 12:00:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1397FB5E62
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664294454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rGIrFLnvZtpmRdhvg+z0yQrnGBkLNXoFwFSYbzeyZTc=;
        b=CuWTqesia7EWm66nMZzsVymThuGOIlj9XvePaYOuhe4RFwhB70+tyC2sHSx1ccJusQJlQv
        AOWbVhg8fHva7vuN5e4mX/hhXX2hQBY4J0O69G/FAaRuFkGB1xZA0tQcnLLWpGeHnttaNk
        VOe0oJMmC9HnNb+u/G5WjGzmTFRURiA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-534-j71lKDQfOMKNfO9E9PcENg-1; Tue, 27 Sep 2022 12:00:53 -0400
X-MC-Unique: j71lKDQfOMKNfO9E9PcENg-1
Received: by mail-qv1-f69.google.com with SMTP id jo23-20020a056214501700b004af8b197efaso1476899qvb.1
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rGIrFLnvZtpmRdhvg+z0yQrnGBkLNXoFwFSYbzeyZTc=;
        b=iqbfQtipBTe7NdaZ/n35ha/T05YVtwHduAG38GAmArwLBynBK0E9WwgMahoGUc/T44
         Dew0ZDlqLwSmWCH44d7fz1YosJUOomOTHw3+JqhLj7kgXtlZC1YMZyxIBQ6erGV00Tdi
         Y5VjWldlffVIVIqLd5mub8U1N91tolEReCk9rPh2c8FcaA4lQ/RBSpuNPC3JsUmWwjNk
         ZS2BWXZ5Bo08sYDIQ5UKDY80bnP7i2RAH7WOybRlcZqidVBxpFrSrffICsxifF/Jmh/v
         siSR8krEKWAjdkoraroTv7cyVnL/2flgbBLwEil/A4CyuHLkBZrSRvmaQW3qULG5aS8M
         Uztg==
X-Gm-Message-State: ACrzQf1riL2RjgwWqH9CzJxrRAKCQDSFAerJ1iimuyczAcDlc6z3VWDV
        IBbXevaKU4swRUMkoKJnzduDoHBeSc8THPbQtTpgggsW2GwZuUwFHIKsaGaLKgXkJOH3ehXDDly
        RXVQcI/9NO6p2
X-Received: by 2002:a05:620a:25d0:b0:6bb:f597:1a3 with SMTP id y16-20020a05620a25d000b006bbf59701a3mr18013944qko.43.1664294450782;
        Tue, 27 Sep 2022 09:00:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM41yCBsVYPgNwbyDuc60G1LQ4+zhPZc9A3FDB9o9gUjW50brkagD39Cv468A4lXwLbldr4rSQ==
X-Received: by 2002:a05:620a:25d0:b0:6bb:f597:1a3 with SMTP id y16-20020a05620a25d000b006bbf59701a3mr18013673qko.43.1664294446386;
        Tue, 27 Sep 2022 09:00:46 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id e2-20020ac84e42000000b00338ae1f5421sm1156520qtw.0.2022.09.27.09.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 09:00:45 -0700 (PDT)
Date:   Tue, 27 Sep 2022 12:00:42 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
Subject: Re: [PATCH v4 1/6] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Message-ID: <YzMeKgmJpUJFc7HJ@x1n>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-2-gshan@redhat.com>
 <86y1u56rku.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86y1u56rku.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 06:26:41AM -0400, Marc Zyngier wrote:
> > +static inline bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu)
> > +{
> > +	return false;
> > +}
> > +
> 
> nit: I don't think this is needed at all. The dirty ring feature is
> not user-selectable, and this is always called from arch code that is
> fully aware of that option.

Agreed.  With the change:

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

