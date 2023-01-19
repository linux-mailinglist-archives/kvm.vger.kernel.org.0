Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E5F672E03
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 02:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjASBUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 20:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjASBSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 20:18:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71021689DA
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 17:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674090929;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZv107PEoZ7dUU2ogNbtUnijM5vb3Ufn5L+9+EzCAVI=;
        b=gNZKScsRs77NkMQgP8OUrIEsRdNzxbVAxsXKoROgThTvOewbalnSwJP9Y/i4cW4erk3fki
        mWn97D1imXgbegi40g0kCJJZejcOET/lwwSVKqH/kM+Us0R7V84sCbsNBuoGqUrTlp6MJN
        PyRtf28QcQ6RUf/6cj37kT+Y8Ppn1NI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-sWqiQAGPNpGZJVwQZ2CABw-1; Wed, 18 Jan 2023 20:15:26 -0500
X-MC-Unique: sWqiQAGPNpGZJVwQZ2CABw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BE1F8A0109;
        Thu, 19 Jan 2023 01:15:25 +0000 (UTC)
Received: from [10.64.54.98] (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A89452026D4B;
        Thu, 19 Jan 2023 01:15:18 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 4/4] KVM: Improve warning report in
 mark_page_dirty_in_slot()
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, corbet@lwn.net,
        james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        ardb@kernel.org, peterx@redhat.com, shan.gavin@gmail.com
References: <20230116040405.260935-1-gshan@redhat.com>
 <20230116040405.260935-5-gshan@redhat.com> <Y8bBzKF17IdZP9eF@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <d8e63ad9-e0e3-dbb1-b646-a1b5771d4c4b@redhat.com>
Date:   Thu, 19 Jan 2023 12:15:16 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y8bBzKF17IdZP9eF@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 1/18/23 2:42 AM, Sean Christopherson wrote:
> On Mon, Jan 16, 2023, Gavin Shan wrote:
>> There are two warning reports about the dirty ring in the function.
>> We have the wrong assumption that the dirty ring is always enabled when
>> CONFIG_HAVE_KVM_DIRTY_RING is selected.
> 
> No, it's not a wrong assumption, becuase it's not an assumption.  The intent is
> to warn irrespective of dirty ring/log enabling.  The orignal code actually warned
> irrespective of dirty ring support[1], again intentionally.  The
> CONFIG_HAVE_KVM_DIRTY_RING check was added because s390 can mark pages dirty from
> an worker thread[2] and s390 has no plans to support the dirty ring.
> 
> The reason for warning even if dirty ring isn't enabled is so that bots can catch
> potential KVM bugs without having to set up a dirty ring or enable dirty logging.
> 
> [1] 2efd61a608b0 ("KVM: Warn if mark_page_dirty() is called without an active vCPU")
> [2] e09fccb5435d ("KVM: avoid warning on s390 in mark_page_dirty")
> 

Thanks for the linker. I was confused when looking at the code, but now it's clear to
me. Thanks for your explanation. How about to add a comment there?

   /*
    * The warning is expected when the dirty ring is configured,
    * but not enabled.
    */

Thanks,
Gavin

