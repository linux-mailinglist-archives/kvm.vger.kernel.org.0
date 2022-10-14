Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70435FF2A8
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 18:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiJNQzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 12:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiJNQzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 12:55:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9536929C9E
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 09:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665766540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=inMtT+hoYNUBiTHjQTMih3j26iePj23of4ePHLqNIX8=;
        b=IImivX0zdH+ls+KlQa5IKOvLvxPaPsP6RxpKFDqC9mBIT1toYqpxEkX6tbpk1jz0mRn4CJ
        IjvEXbIevMfUzWYh/+k7zoWJVQLNH2cgmw5ZZ9jZ8m29Fo8nC3RHOavdz3aqAg6+yUEPtG
        7mmp49K/2kELk1JgUZL1iFuclhwj/xs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-577-zlGdHpGcNDSBz_j2ll_yFg-1; Fri, 14 Oct 2022 12:55:39 -0400
X-MC-Unique: zlGdHpGcNDSBz_j2ll_yFg-1
Received: by mail-qk1-f200.google.com with SMTP id bj1-20020a05620a190100b006eececec791so1705569qkb.15
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 09:55:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=inMtT+hoYNUBiTHjQTMih3j26iePj23of4ePHLqNIX8=;
        b=SK9/QohdCCX/0IOFCDgZUcv7EQ7TWiqHHnrCOcc+nlpJslmEycT0nlfb/z4WX3JfXD
         4e4ngvMavLPEk2k1bk3M4IwNoYEr2CxRw2VHJ+Q2+Cn1mvTss0Uzu1ww+JuMEfjqeyXK
         Y7OuseX3Kq99jPz8FJ/to1d+M7aYhHbMEN1BYDemTkdDeUS9nlJNgF+meWXF8xXQtVik
         +ZUMug41iGwT6n+dpkCXhShhdVKUHyfSsrVcHldNR44OriVuC5a7+jRP+zORPYJ37WrD
         N4GNoF+6FY/ehcYBsbk16AifJIUmxppudvOKt+z9QJXAUF8bQXFhhBSPBUQrGqap5RgU
         bSMw==
X-Gm-Message-State: ACrzQf3LZxm4Ur0dM2AsWKrCwVR2vZ24v0wpkj79ctv6WTibsy0LngO/
        I5ZEFMvY3ovstg40n4dob5LdU3rUlxDqpDgK2N4lU+psA9AanxQ5a5IStb7Q75ffqV8n2ikS/3V
        T9hbuBdAYPevf
X-Received: by 2002:ac8:58c2:0:b0:398:f5c4:9bed with SMTP id u2-20020ac858c2000000b00398f5c49bedmr4982984qta.367.1665766538532;
        Fri, 14 Oct 2022 09:55:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7RWlwjY7fwX0sXAm2JU/iQpzMQf5jfJhmR78proXq2TEBVxm0GapOTir5grGpSntiVMzL4Gw==
X-Received: by 2002:ac8:58c2:0:b0:398:f5c4:9bed with SMTP id u2-20020ac858c2000000b00398f5c49bedmr4982978qta.367.1665766538317;
        Fri, 14 Oct 2022 09:55:38 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id d22-20020a376816000000b006ce0733caebsm2726739qkc.14.2022.10.14.09.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 09:55:37 -0700 (PDT)
Date:   Fri, 14 Oct 2022 12:55:35 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        seanjc@google.com, shan.gavin@gmail.com
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0mUh5dEErRVtfjl@x1n>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com>
 <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n>
 <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local>
 <Y0SxnoT5u7+1TCT+@google.com>
 <Y0S2zY4G7jBxVgpu@xz-m1.local>
 <Y0TDCxfVVme8uPGU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y0TDCxfVVme8uPGU@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 11, 2022 at 01:12:43AM +0000, Oliver Upton wrote:
> The VMM must know something about the architecture it is running on, as
> it calls KVM_DEV_ARM_ITS_SAVE_TABLES after all...

IIUC this is still a kernel impl detail to flush data into guest pages
within this ioctl, or am I wrong?

For example, I'm assuming it's safe to change KVM_DEV_ARM_ITS_SAVE_TABLES
impl one day to not flush data to guest memories, then the kernel should
also disable the ALLOW_BITMAP cap in the same patch, so that any old qemu
binary that supports arm64 dirty ring will naturally skip all the bitmap
ops and becoming the same as what it does with x86 when running on that new
kernel.  With implicit approach suggested, we need to modify QEMU.

Changing impl of KVM_DEV_ARM_ITS_SAVE_TABLES is probably not a good
example.. but just want to show what I meant.  Fundamentally it sounds
cleaner if it's the kernel that tells the user "okay you collected the
ring, but that's not enough; you need to collect the bitmap too", rather
than assuming the user app will always know what kvm did in details.  No
strong opinion though, as I could also have misunderstood how arm works.

-- 
Peter Xu

