Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60036CECB2
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 17:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjC2PWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 11:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjC2PWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 11:22:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B9719B2
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 08:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680103295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9mF1o05GtInf+V8GqJy1xPxMitbv3VN/OAqBL59PN6I=;
        b=ceT7xqhatrqBjsHjVWijAcsstaw4LV4FONxm8/ql5XHMC7tMkPhIG3eGGCFZm1oFT5Cdff
        kiGi+bjg0LDVfrD1hhlLVKQkLyYIpOzOwvgQ8B7GkPrnKUdOudlwREk3j7F+8QR4eFkFwv
        DlJfwrwOwaitRr86bqpmCTHy1VieHjY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-JsW9dZgaNPOFR6CzqEho1w-1; Wed, 29 Mar 2023 11:21:33 -0400
X-MC-Unique: JsW9dZgaNPOFR6CzqEho1w-1
Received: by mail-ed1-f72.google.com with SMTP id t14-20020a056402240e00b004fb36e6d670so22740822eda.5
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 08:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680103292; x=1682695292;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9mF1o05GtInf+V8GqJy1xPxMitbv3VN/OAqBL59PN6I=;
        b=iFSYUYIrLe23BWIePEIhuS3rsRK/CbdZ3NLXJCSJhbWrXbSDgEYDcsoaEbVajAshV1
         pMqD719g8mYO56eaBVzrbzT16Z2GcuDtfSUFDswCGQtYj89IXtLiPkR3J7maVYQh9NQ2
         DerVK/x8k5LUkC2UUDB/PYlAp/2nTIuDnyi1X8zv/yax8Ve/pS7oq+mCzpDpnr98xq1V
         RqKOW5FpG/SK3lW6XPenyOC6UuQ9jeutwaESTAQhMFJ/k41rTejJlP1buYXhg/ClPk3P
         jKdbOLy3WSViiJJ1pSrEY1yYhBUQzusY00tyJuoddE/KOGBtX2342q7i7ee9bn5AjLIy
         V6fw==
X-Gm-Message-State: AAQBX9drlkYzjuHju5jGrrOz9rwvBSKduIyQoFz//1mZmB0WlTDA1rDn
        QAjvOVGI7yQm4VFJpI4a6W0boPt5EDxWw0m+UuCL7XWLDj2T20/TbJmNKoUvxUVuw0pakJKFyUn
        S002PozBx6KPh
X-Received: by 2002:a17:907:a781:b0:93b:2d0b:b60e with SMTP id vx1-20020a170907a78100b0093b2d0bb60emr21656071ejc.74.1680103292002;
        Wed, 29 Mar 2023 08:21:32 -0700 (PDT)
X-Google-Smtp-Source: AKy350bjQIZyBuMXDam/k2OBJsQSohTfvhM3bSTryVMbQFbji6qx0N0a4XKwWesnFOgPZUV2ICp1Bg==
X-Received: by 2002:a17:907:a781:b0:93b:2d0b:b60e with SMTP id vx1-20020a170907a78100b0093b2d0bb60emr21656046ejc.74.1680103291689;
        Wed, 29 Mar 2023 08:21:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id e3-20020a170906504300b00930c6c01c9esm16901665ejk.143.2023.03.29.08.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 08:21:31 -0700 (PDT)
Message-ID: <6ae1d9ca-36fc-b42d-9dd6-28aae7a30116@redhat.com>
Date:   Wed, 29 Mar 2023 17:21:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH][for stable/linux-5.15.y] KVM: VMX: Move preemption timer
 <=> hrtimer dance to common x86
Content-Language: en-US
To:     Tudor Ambarus <tudor.ambarus@linaro.org>, stable@vger.kernel.org,
        seanjc@google.com, joro@8bytes.org
Cc:     vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        suravee.suthikulpanit@amd.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mlevitsk@redhat.com, joneslee@google.com,
        syzbot+b6a74be92b5063a0f1ff@syzkaller.appspotmail.com
References: <20230329151747.2938509-1-tudor.ambarus@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230329151747.2938509-1-tudor.ambarus@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/29/23 17:17, Tudor Ambarus wrote:
> From: Sean Christopherson<seanjc@google.com>
> 
> commit 98c25ead5eda5e9d41abe57839ad3e8caf19500c upstream.
> 
> Handle the switch to/from the hypervisor/software timer when a vCPU is
> blocking in common x86 instead of in VMX.  Even though VMX is the only
> user of a hypervisor timer, the logic and all functions involved are
> generic x86 (unless future CPUs do something completely different and
> implement a hypervisor timer that runs regardless of mode).
> 
> Handling the switch in common x86 will allow for the elimination of the
> pre/post_blocks hooks, and also lets KVM switch back to the hypervisor
> timer if and only if it was in use (without additional params).  Add a
> comment explaining why the switch cannot be deferred to kvm_sched_out()
> or kvm_vcpu_block().
> 
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> Reviewed-by: Maxim Levitsky<mlevitsk@redhat.com>
> Message-Id:<20211208015236.1616697-8-seanjc@google.com>
> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
> [ta: Fix conflicts in vmx_pre_block and vmx_post_block as per Paolo's
> suggestion. Add Reported-by and Link tags.]
> Reported-by:syzbot+b6a74be92b5063a0f1ff@syzkaller.appspotmail.com
> Link:https://syzkaller.appspot.com/bug?id=489beb3d76ef14cc6cd18125782dc6f86051a605
> Tested-by: Tudor Ambarus<tudor.ambarus@linaro.org>
> Signed-off-by: Tudor Ambarus<tudor.ambarus@linaro.org>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

