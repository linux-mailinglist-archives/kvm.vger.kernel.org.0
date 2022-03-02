Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9EF4CADB0
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbiCBSg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiCBSg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:36:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AAA5CA30C
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 10:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646246173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O+z7hfIz3tju9l3ISOjUkJ5y2WlvKCbxrD0GfgR9pWQ=;
        b=iI2I4GrQSwgo7bfc+iH0mZ51P0XlJ2619GcH0DZOz/SY/PVFU8MwSAhzlfySbDy8SMskO+
        M2FKOZ3MGOl+w44mQTpP3qIvlrM+bxI25IEH0t9iQ9M4FU7bEGKAA5WHWOAz5lQ8y46zfs
        3GCMAbuTIw3E8GIAE6Ub9IPrDzBde5g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-LHDJT0tXOzGj_CXzc5S00w-1; Wed, 02 Mar 2022 13:36:10 -0500
X-MC-Unique: LHDJT0tXOzGj_CXzc5S00w-1
Received: by mail-wr1-f70.google.com with SMTP id w2-20020adfbac2000000b001ea99ca4c50so950506wrg.11
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 10:36:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=O+z7hfIz3tju9l3ISOjUkJ5y2WlvKCbxrD0GfgR9pWQ=;
        b=bsKEj1zCP8L82theFYErjZHNt8BtkQce2RHYpH8tw2zGeC7XLvGTj4QUMqkv6D3o1A
         FkadrbsDN6xOIW+PmgeQRnTLzz0CPJCuFAseFcfO+XtVf/4hCjjrDbfLJcEPo2YnZx1Y
         eNoUm4KhMr+fdjkq4XlQ9n3rhtswug7nNEVcLSAiI3k08slSiQMO992yG612zrqlmZ+P
         GQTEAVxgabJQiPqKmBAmBz2xTr0PnL1tcfRdOXaqFeDrEipx/QuoWV6AUnyRWUiglBdb
         zpgTA8iUWoqj1JvivzAINoyB2p7QCmq1HelRmlBEucrjBdi7DqfwyLFD2SjEHTi0qqIr
         pdnQ==
X-Gm-Message-State: AOAM531p38QdPPnuloybaKZyfLuOoKPJLGpjxPDSDvSUR1QzkbQ2w8fS
        n01uppur44Di7e1LZibI0vWQMV9yNsb/TtKpaGwgsQdKJyGNlkRRJQQrv+815JzfziinOqIpk+I
        WRp7XYZISyycV
X-Received: by 2002:a1c:ed18:0:b0:37e:7a1d:a507 with SMTP id l24-20020a1ced18000000b0037e7a1da507mr891224wmh.187.1646246168641;
        Wed, 02 Mar 2022 10:36:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzK1LyeBTns5xp8BRVl8tBbJ+tsmFf1e/LJyM7IwboRYO6afj8px0VabpMjJzNMLAUJKms2DQ==
X-Received: by 2002:a1c:ed18:0:b0:37e:7a1d:a507 with SMTP id l24-20020a1ced18000000b0037e7a1da507mr891205wmh.187.1646246168412;
        Wed, 02 Mar 2022 10:36:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id f16-20020adff590000000b001f0122f63e1sm5754207wro.85.2022.03.02.10.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 10:36:07 -0800 (PST)
Message-ID: <43809107-cd8a-21f5-c45b-2f39c1bd037e@redhat.com>
Date:   Wed, 2 Mar 2022 19:36:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via asynchronous
 worker
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-23-seanjc@google.com>
 <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
 <Yh+q59WsjgCdMcP7@google.com>
 <CALzav=dzqOp-css8kgqHhCLJnbUrUZt+e_YStCj2HFy0oD+vGg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALzav=dzqOp-css8kgqHhCLJnbUrUZt+e_YStCj2HFy0oD+vGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 19:33, David Matlack wrote:
> On Wed, Mar 2, 2022 at 9:35 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Wed, Mar 02, 2022, Paolo Bonzini wrote:
>>> However, I think we now need a module_get/module_put when creating/destroying
>>> a VM; the workers can outlive kvm_vm_release and therefore any reference
>>> automatically taken by VFS's fops_get/fops_put.
>>
>> Haven't read the rest of the patch, but this caught my eye.  We _already_ need
>> to handle this scenario.  As you noted, any worker, i.e. anything that takes a
>> reference via kvm_get_kvm() without any additional guarantee that the module can't
>> be unloaded is suspect. x86 is mostly fine, though kvm_setup_async_pf() is likely
>> affected, and other architectures seem to have bugs.
>>
>> Google has an internal patch that addresses this.  I believe David is going to post
>> the fix... David?
> 
> This was towards the back of my queue but I can bump it to the front.
> I'll have the patches out this week.

Thanks!

Paolo

