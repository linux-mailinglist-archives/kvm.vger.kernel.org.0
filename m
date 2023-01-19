Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E267674700
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjASXOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjASXNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:13:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DA5A95A3
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674169506;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zOEJRVUCnaSTu3apvVVhayxrqQN65NFZYiVFw16tleY=;
        b=Gcv4vxYN5rHb0/LhARRi8OAml4chv1vYrXSTh2PlxyMnQ9gkRRe0iGeP6e3JTuzs4RIJPo
        f1OMSu1PoX6Gh7/9aCrHCziX4I/0pXQpKSz/POmv9Zw5TAfpFWrnbtrtTQlI9kt8H1467D
        Cevlly6YFgwopjk6LFxKE9ik9pEhk7c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-QQjCKQRFPT6Xs2gyRAdLDA-1; Thu, 19 Jan 2023 18:05:01 -0500
X-MC-Unique: QQjCKQRFPT6Xs2gyRAdLDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69B7D1C05154;
        Thu, 19 Jan 2023 23:05:00 +0000 (UTC)
Received: from [10.64.54.98] (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33EED40C6EC4;
        Thu, 19 Jan 2023 23:04:52 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 1/4] KVM: arm64: Allow saving vgic3 LPI pending status in
 no running vcpu context
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        ardb@kernel.org, peterx@redhat.com, seanjc@google.com,
        shan.gavin@gmail.com
References: <20230116040405.260935-1-gshan@redhat.com>
 <20230116040405.260935-2-gshan@redhat.com> <Y8cKQRIbpLWVcdcw@google.com>
 <0626e135-5d6b-8d09-ccd1-068e42a052f6@redhat.com>
 <86v8l2msqk.wl-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <685ae61a-951f-e611-7491-948f19f1827e@redhat.com>
Date:   Fri, 20 Jan 2023 10:04:50 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <86v8l2msqk.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/20/23 2:47 AM, Marc Zyngier wrote:
> On Thu, 19 Jan 2023 01:11:44 +0000,
> Gavin Shan <gshan@redhat.com> wrote:
>>
>> I will have vgic_write_guest_lock() in v2. Note that those 3 paths can't be
>> running in parallel since one switch is shared by them. Alternatively, we
>> extend struct vgic_dist::save_tables_in_progress from 'bool' to 'unsigned long'.
>> Several bit is defined for each site as below. In this way, the 3 paths can be
>> running in parallel:
>>
>>    unsigned long struct vgic_dist::save_tables_in_progress
>>
>>    #define VGIC_DIST_SAVE_ITS_ITE		0	/* ITS Translation Entry */
>>    #define VGIC_DIST_SAVE_ITS_DTE		1	/* ITS Device Table Entry */
>>    #define VGIC_DIST_SAVE_ITS_CTE		2	/* ITS Collection Table Entry */
>>    #define VGIC_DIST_SAVE_ITS_CT			3	/* ITS Collection Table */
>>    #define VGIC_DIST_SAVE_VGIC3_LPI		4	/* VGIC3 LPI Pending Status */
>>    #define VGIC_DIST_SAVE_VGIC3_PENDING_TABLE	5	/* VGIC3 Pending Table */
>>
>> The drawback is the calls are limited to 64. If those 3 paths can't be running
>> in parallel, we needn't the extension at all.
> 
> It should all be completely sequential. KVM_DEV_ARM_ITS_SAVE_TABLES
> runs in a context where everything is locked, and so is
> VGIC_DIST_SAVE_VGIC3_PENDING_TABLE.
> 

Thanks for your confirm. Yeah, it's sequential because 'kvm->lock' is
hold on KVM_DEV_ARM_ITS_SAVE_TABLES and VGIC_DIST_SAVE_VGIC3_PENDING_TABLE.
So all good to have one shared switch. v2 will be posted pretty soon.

Thanks,
Gavin

