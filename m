Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD225EC8F5
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 18:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiI0QE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 12:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiI0QEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 12:04:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A23E1C99C1
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664294577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WtpRxtCZltp/63OXQYG8Mzy798EcRnh/IHqJ0/4DV1E=;
        b=RomP5WKJlIC+jfzLBLDvrYpCf8AtoWNS648VFn2aCne7pY4VWfla0OvvhMBbAUk9xSwnrU
        2RyRZT1kLcVXeSbRj5yZiA18avqP7KR11uE/qSXfTQV/blSzucrUda3O7MpMKDWPaHpi62
        uHBQJL1J/SKmAdVmZW5A4AdDITikgjA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-385-LrDUQ-bUP_yO4y9iYW3ucw-1; Tue, 27 Sep 2022 12:02:55 -0400
X-MC-Unique: LrDUQ-bUP_yO4y9iYW3ucw-1
Received: by mail-qv1-f71.google.com with SMTP id y7-20020ad45307000000b004ac7fd46495so6145394qvr.23
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=WtpRxtCZltp/63OXQYG8Mzy798EcRnh/IHqJ0/4DV1E=;
        b=SZjn3RUtUDIQuiwqvZ146p7TMo/yHfDXihlVRVk39z54MBg/C0tv4s061BqJLM9oV+
         ECYcdh0IAQke7120WSJfVINJIHoBKsZHu3jAflpom9p5S8l3UjTZQfr6aAH4/WLsVdIB
         vJX09cYoohnSuGfE5iEyqtRQsXrmQTDsalNuju/qJmeJVHF+ISQB+6n+1PsqgtAWSoJK
         ddzBIISqBogvDJVowgE9dclnTGa2fUqWrV0RjIgzlzA8mfUmiA08zfpKX0i76mOFlAIH
         T0i79fTHqCnNM/ll6CbD8BpmnPhqLXK6rEhYUCtY+AOgVnRSl3lL8DIEVNcFFVyuqzQY
         4hvg==
X-Gm-Message-State: ACrzQf20vn8Mhy2QzY15drECaL1PPNWg4FYbgnx3MjAHPf78Kvx3IOls
        tYep3e5kNiAB/V5krA+JyGIxTWFmACeJdG3OJFm6ad42UDM+HmcHtFUCekXweTQy1NWivgJGXwg
        m6UUyQgrGYMSm
X-Received: by 2002:a05:6214:21cb:b0:4aa:b039:35c7 with SMTP id d11-20020a05621421cb00b004aab03935c7mr21789011qvh.60.1664294575447;
        Tue, 27 Sep 2022 09:02:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6lmFS0nvurnTtO5d5O/P/pgdsV3Q8A7e7qy/mOBjQiXB4CjUnTlFBCMrFl3cnsQiwSWkf9+w==
X-Received: by 2002:a05:6214:21cb:b0:4aa:b039:35c7 with SMTP id d11-20020a05621421cb00b004aab03935c7mr21788957qvh.60.1664294575072;
        Tue, 27 Sep 2022 09:02:55 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id n19-20020a05622a041300b003434f7483a1sm1083235qtx.32.2022.09.27.09.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 09:02:54 -0700 (PDT)
Date:   Tue, 27 Sep 2022 12:02:52 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        maz@kernel.org, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory
 tracking
Message-ID: <YzMerD8ZvhvnprEN@x1n>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-4-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220927005439.21130-4-gshan@redhat.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 08:54:36AM +0800, Gavin Shan wrote:
> Enable ring-based dirty memory tracking on arm64 by selecting
> CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL and providing the ring buffer's
> physical page offset (KVM_DIRTY_LOG_PAGE_OFFSET).
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Gavin,

Any decision made on how to tackle with the GIC status dirty bits?

Thanks,

-- 
Peter Xu

