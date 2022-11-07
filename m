Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD93861F61C
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 15:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbiKGOdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 09:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiKGOdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 09:33:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A35C1DDE0
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 06:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667831344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=humq6rQ40+uCr1dmaqj2I5gLtIPMUKzBIm5JAKLU5kM=;
        b=aKvlic6VPiEtzOueIUBnYGtYNqwy6tpAx8Gs0m6ApYap4v1phE/aFVNJ8cN7p7NlijzxFD
        W6RuzQKCS3JLnPnAALoSD13PU4w2SNmOLQh7pjnmbgEqapMdvJfZlS/560+GPQ+ZSOWjOm
        ywUmWxXNetn0InCLvHdzNVNb5pgvFmg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-621-BWTfquBzPUupolwW9O-hjw-1; Mon, 07 Nov 2022 09:29:03 -0500
X-MC-Unique: BWTfquBzPUupolwW9O-hjw-1
Received: by mail-qt1-f200.google.com with SMTP id g3-20020ac84b63000000b003a529c62a92so8293681qts.23
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 06:29:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=humq6rQ40+uCr1dmaqj2I5gLtIPMUKzBIm5JAKLU5kM=;
        b=PzCcU/sPS9Mm7ZQfwmXc2hevtOFY1WE+QUm8omBJXH1vuOMl0/5w8BzhJj5kd+p2pO
         j56bZcZE1vx+KU2Xw+PMLq43e28NdBpAEIsAUbD5sQ8BK0sDiCukC6Ct8+NjOpfGZehT
         7qjnAcUaKkViXQlypNaSOFOWr19ezSPSN2JBmSVtgtd7u/qP1wyFTRm1tM+XlglnCJVu
         RKcg8jdoeo2LZSKS5M0VVxQoasx2OqqIMR7R3NbIMv1z9vDhVloNWtyjG7FdN9lyLZH9
         3JSmBQa43pgiDw509pfzMK37RUdTfLMb0nqfqiVvnonQgI6+T3ntwIshbV3ZPbzFQung
         hUeQ==
X-Gm-Message-State: ACrzQf1FBZx8qv8n6qpXzjQ0BKj9lK3ddCvyU24zt9bPbYhpdmVkpqVE
        2meY2HRzgRUgHKyMLSlPc2jUap6AwH7q8Jmf2/fHI3QhrUEIbAehwepPYzKO9TojpaSBOtXD8om
        Foygj5xGmkf6i
X-Received: by 2002:a05:620a:d55:b0:6f9:fadd:4762 with SMTP id o21-20020a05620a0d5500b006f9fadd4762mr35863883qkl.335.1667831342866;
        Mon, 07 Nov 2022 06:29:02 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6QWKXb1TWdkP9qu08deog1NKsig/FMQot7OkY7UfMNUpgr2zjUhL2SrUPx+ND9wgrgFSLMDw==
X-Received: by 2002:a05:620a:d55:b0:6f9:fadd:4762 with SMTP id o21-20020a05620a0d5500b006f9fadd4762mr35863853qkl.335.1667831342661;
        Mon, 07 Nov 2022 06:29:02 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id cg5-20020a05622a408500b0035cf31005e2sm6150909qtb.73.2022.11.07.06.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 06:29:02 -0800 (PST)
Date:   Mon, 7 Nov 2022 09:29:00 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, seanjc@google.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2kWLMMTho0+/BLR@x1n>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <87o7tkf5re.wl-maz@kernel.org>
 <Y2ffRYoqlQOxgVtk@x1n>
 <87iljrg7vd.wl-maz@kernel.org>
 <Y2gh4x4MD8BJvogH@x1n>
 <35d005f3-655a-88f5-2de3-848576a26e42@redhat.com>
 <865yfrqf3j.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <865yfrqf3j.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 09:38:24AM +0000, Marc Zyngier wrote:
> Peter said there is an undefined behaviour. I want to understand
> whether this is the case or not. QEMU is only one of the users of this
> stuff, as all the vendors have their own custom VMM, and they do
> things in funny ways.

It's not, as we don't special case this case in KVM_CLEAR_DIRTY_LOG.  If
that's confusing, we can drop it in the document.  Thanks.

-- 
Peter Xu

