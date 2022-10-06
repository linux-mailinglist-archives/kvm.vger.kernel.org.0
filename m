Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D430E5F6F27
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 22:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiJFU3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 16:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbiJFU26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 16:28:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA62BEAF1
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 13:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665088133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PzDMEFf3RvC/4HsJdVTaIeB4nK1mYRC18rZsRN9dEDk=;
        b=YJfqeW3sXP8g69SYnC1k/jZ19/FFaX1eUW9THcKQypOnDiBgBurXJLHMRpIQ32S0I1Yiel
        amWaJ7kaqUBKUDozx2qfY2zOvvM7fGFOWyGkcAYlwOb1BVcRtZGrz8sncpMZZVl4deb3ar
        T5clE12evMtDbe+E//Jjh2RzMkFVbho=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-413-8OD7enKuMCiyTFqLHL0ikw-1; Thu, 06 Oct 2022 16:28:52 -0400
X-MC-Unique: 8OD7enKuMCiyTFqLHL0ikw-1
Received: by mail-qt1-f197.google.com with SMTP id d1-20020ac80601000000b00388b0fc84beso1827157qth.3
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 13:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PzDMEFf3RvC/4HsJdVTaIeB4nK1mYRC18rZsRN9dEDk=;
        b=5+6dJWPHPwUu4eR+RWl1QaQx3kY5vLxc+1x6ciIm7asQciLrhUZHTX5kF9WwDKpYzU
         N+4jQWOSRd/Zg/MU3VE3oeJe9hObUGy96r7t2/QXGBSyMn/ptYjZbQCzGUAe4tSF438h
         6gvW72dBGiLqwNflSZr67wZynySj7kcG7KUgiHXy16zQo81zNLwZyWf5/XLmG9P1ppSn
         ADAD4PENuGjIQsEBMSFjgVBNochH1pOeTJCQyQZs+aB81wvo4uo7B4BnsXtKrhLqihmz
         Gcy3nhmOleiNC2nKbMUjjOmYnNxWc1jVxEMm/gmH+7VeL2AEDiQe5cAO0/oZqkHrVTLf
         uUXQ==
X-Gm-Message-State: ACrzQf2vZ0ekmLOuAa9qgpryKJ4dTWbhqZmEaVE2sVCIGoN13fmAtTfd
        F1p/ZIyxNsdixPkyCXdqEPXEkwYTjlKyL2zoRDVUA4Nwu23V1y2UmSLxXZ2RvvP24SC3Tu1nT3R
        44DUek8nFAgPb
X-Received: by 2002:a05:6214:d8b:b0:4b2:f6f4:bf5b with SMTP id e11-20020a0562140d8b00b004b2f6f4bf5bmr471077qve.91.1665088131463;
        Thu, 06 Oct 2022 13:28:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7wdSO+0rTVDOZDD3Csrns1eNjrxa7fASHygvAI0zZa7rTZmRLseTk486PcRmkPdgJRBXB+uw==
X-Received: by 2002:a05:6214:d8b:b0:4b2:f6f4:bf5b with SMTP id e11-20020a0562140d8b00b004b2f6f4bf5bmr471062qve.91.1665088131285;
        Thu, 06 Oct 2022 13:28:51 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id o19-20020a05620a2a1300b006cddf59a600sm74769qkp.34.2022.10.06.13.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 13:28:50 -0700 (PDT)
Date:   Thu, 6 Oct 2022 16:28:48 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        seanjc@google.com, shan.gavin@gmail.com
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Yz86gEbNflDpC8As@x1n>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221005004154.83502-4-gshan@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 05, 2022 at 08:41:50AM +0800, Gavin Shan wrote:
> -8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> -----------------------------------------------------------
> +8.29 KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL, RING_ALLOW_BITMAP}
> +--------------------------------------------------------------

Shall we make it a standalone cap, just to rely on DIRTY_RING[_ACQ_REL]
being enabled first, instead of making the three caps at the same level?

E.g. we can skip creating bitmap for DIRTY_RING[_ACQ_REL] && !_ALLOW_BITMAP
(x86).

> @@ -2060,10 +2060,6 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
>  	unsigned long n;
>  	unsigned long any = 0;
>  
> -	/* Dirty ring tracking is exclusive to dirty log tracking */
> -	if (kvm->dirty_ring_size)
> -		return -ENXIO;

Then we can also have one dirty_ring_exclusive(), with something like:

bool dirty_ring_exclusive(struct kvm *kvm)
{
        return kvm->dirty_ring_size && !kvm->dirty_ring_allow_bitmap;
}

Does it make sense?  Thanks,

-- 
Peter Xu

