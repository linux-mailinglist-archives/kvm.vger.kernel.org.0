Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD06554D02
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357452AbiFVO3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbiFVO2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:28:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F13942F01A
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 07:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655908127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x34IRi49NgING8whuhdPrWa3tANXSDCipF9OzN2jvL4=;
        b=KTXOE1ZTOUP8gbxNKFlgx4Hj5P++HdlFHX6WhNau+QeGuOQITie5OsH2GUZqKz+FUsh1Rg
        Xp0D4ssm0Tx0ci4JOUjtO7a6j8iw1VGFabmhBpDJhE7ubQnc1eGTcqH7oLxhkOghx/fW5w
        YcsCY2Mng0I1nIq05ny7yvCNtRgWiCc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-7feHS5mwMcqQpJv1QXH1zQ-1; Wed, 22 Jun 2022 10:28:46 -0400
X-MC-Unique: 7feHS5mwMcqQpJv1QXH1zQ-1
Received: by mail-wm1-f69.google.com with SMTP id j20-20020a05600c1c1400b0039c747a1e5aso7907553wms.9
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 07:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=x34IRi49NgING8whuhdPrWa3tANXSDCipF9OzN2jvL4=;
        b=WDBo+Ev0fxuHnBIW9J8fIa6uQokTbP3hBzbr3QVR6TAjwtZyMNiUszyT2gXJd/IllA
         gVauB+OfMkYDSulSl9LxTcjW56VfgcPex0vnT5baju4hjb1s1rlYvFjgjHvITrMAKbjb
         hl344HsbpBprjgHJaKWLQ8Xlj/q2tAihGNl5SAACmUXNJ1izD2P8p6hbLNKg+eumJBoo
         eUNlLOms2V35Ld5HRBnuTlUZq1ul7sS+ujBjKLSDVv4P9lF0HqUw+wn2MD3QkB4tqHwi
         2jSvUPZzaGGwDhX5T0xF723ibXjAmyM5qxNg69hOSSetkuk1pXX9tK4SqZ6A4SNGO68f
         nRMg==
X-Gm-Message-State: AJIora+Mh4VJ36ss7NFZhFtrFBAyyhNDXHwiKoVHuKvNaFOJn82lrIGn
        rPUQBsrQ0Esd3UygrdeoZq9tjm4JdqlANBNp9saoVQJCwuaKh+2QboxIj5zzEQkbJwdFoRfH07X
        ZMdXgjObrnlpP
X-Received: by 2002:a5d:5984:0:b0:219:e396:d3d1 with SMTP id n4-20020a5d5984000000b00219e396d3d1mr3649477wri.701.1655908124721;
        Wed, 22 Jun 2022 07:28:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vuhyEjREFg3dGcH7vFPn3yakH8vgcXSr8DuJhoDWbuzWlidbf8KyA6iZoKwjJuqao0HuIjng==
X-Received: by 2002:a5d:5984:0:b0:219:e396:d3d1 with SMTP id n4-20020a5d5984000000b00219e396d3d1mr3649464wri.701.1655908124542;
        Wed, 22 Jun 2022 07:28:44 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c130-20020a1c3588000000b0039c798b2dc5sm25959911wma.8.2022.06.22.07.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 07:28:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 10/39] KVM: x86: hyper-v: Don't use
 sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
In-Reply-To: <36f2de4e-43fe-7280-8cac-f44de89b2b98@redhat.com>
References: <20220613133922.2875594-1-vkuznets@redhat.com>
 <20220613133922.2875594-11-vkuznets@redhat.com>
 <17a2e85a-a1f2-99e1-fc69-1baed2275bd5@redhat.com>
 <87zgi640mm.fsf@redhat.com>
 <36f2de4e-43fe-7280-8cac-f44de89b2b98@redhat.com>
Date:   Wed, 22 Jun 2022 16:28:43 +0200
Message-ID: <87tu8cydpg.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 6/21/22 15:17, Vitaly Kuznetsov wrote:
>>>
>>> Just to be clear, PV IPI does*not*  support the VP_ID, right?
>> Hm, with Hyper-V PV IPI hypercall vCPUs are also addressed by their
>> VP_IDs, not by their APIC ids so similar to Hyper-V PV TLB flush we need
>> to convert the supplied set (either flat u64 bitmask of VP_IDs for
>> non-EX hypercall or a sparse set for -EX).
>> 
>
> So this means the series needs a v8, right?
>

No, I was just trying to explaini what the patch is doing in the series,
it looks good to me (but I'm biased, of course).

-- 
Vitaly

