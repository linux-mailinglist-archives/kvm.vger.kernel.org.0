Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413AF67DA3A
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 01:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjA0AKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 19:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjA0AKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 19:10:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A316173744
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 16:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674778129;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y8tu4FUXrv8fAcstYpX6IME70IzdWPt02A+oJYgnvh0=;
        b=ZXPtgePxFVuaqnmdo/lztQigziGgKKoiPUOGfUHTHQ597vusy/QyKSY6abachVjo7wgm8A
        c6ZxkdV4wjHpFJEo9D7Lc/kZdGeMMjMhJ8uwgkSjKGwVc4ICh2WbuylEf+2tpg+LVtvAbt
        /XnHPsgVvN573ZiAZL7v9JJAXMv5PjY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-YFNY7T9aOOyBrsh6G2wukA-1; Thu, 26 Jan 2023 19:08:46 -0500
X-MC-Unique: YFNY7T9aOOyBrsh6G2wukA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2FFA802C1D;
        Fri, 27 Jan 2023 00:08:45 +0000 (UTC)
Received: from [10.64.54.98] (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5950F2026D4B;
        Fri, 27 Jan 2023 00:08:42 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Remove duplicate VM in
 memslot_perf_test
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
        maz@kernel.org, oliver.upton@linux.dev, seanjc@google.com,
        shan.gavin@gmail.com
References: <20230118092133.320003-1-gshan@redhat.com>
 <20230118092133.320003-2-gshan@redhat.com>
 <b5a6f902-2d43-a7d6-5840-669760b6c9d7@maciej.szmigiero.name>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <844b0302-ddb4-22b4-e807-08eca9ac8dee@redhat.com>
Date:   Fri, 27 Jan 2023 11:08:39 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <b5a6f902-2d43-a7d6-5840-669760b6c9d7@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maciej,

On 1/24/23 10:56 AM, Maciej S. Szmigiero wrote:
> On 18.01.2023 10:21, Gavin Shan wrote:
>> There are two VMs created in prepare_vm(), which isn't necessary.
>> To remove the second created and unnecessary VM.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
> 
> It's weird that we ended with two __vm_create_with_one_vcpu() calls,
> it looks like the second one was accidentally (re-)introduced during
> 'kvmarm-6.2' merge, so maybe?:
> Fixes: eb5618911af0 ("Merge tag 'kvmarm-6.2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")
> 
> Anyway, thanks for spotting this:
> Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 

Thanks for your review. Right, it'd better to have the fix tag as your suggested.
I think I probably needn't respin. I guess Paolo, Marc or Oliver may help
to add the fix tag when it's merged.

Thanks,
Gavin




