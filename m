Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126D567EA68
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 17:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbjA0QH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 11:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjA0QH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 11:07:58 -0500
X-Greylist: delayed 571 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 27 Jan 2023 08:07:53 PST
Received: from out-231.mta0.migadu.com (out-231.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDB616AC5
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 08:07:52 -0800 (PST)
Message-ID: <a4b3ee35-a0d7-80f6-c64f-f9056c5b6110@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674835097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvi6m70GbKqrQkpAzMUr7WtmhWXUZdYOPES9ccn9egI=;
        b=KRE4nOsctuEOl2LC2RDrgOWHYDOICSl9b3eAwTINeDAKX61JelkAi9iTzhDSLN6i0N4x/C
        8V/akap4D9bywbnfxgFBx/MT1rGL7DIrtaCptD2OExsatEpXKZ+6pjRJFX1M9/SrT2CaWU
        v98jc0dGUQ1VNvLSaosQbnwToi+t2Xs=
Date:   Fri, 27 Jan 2023 23:57:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/4] KVM: arm64: Add helper vgic_write_guest_lock()
Content-Language: en-US
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com,
        corbet@lwn.net, maz@kernel.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        yuzhe@nfschina.com, isaku.yamahata@intel.com, seanjc@google.com,
        ricarkol@google.com, eric.auger@redhat.com, renzhengeek@gmail.com,
        reijiw@google.com, shan.gavin@gmail.com
References: <20230126235451.469087-1-gshan@redhat.com>
 <20230126235451.469087-3-gshan@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20230126235451.469087-3-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ just coming back from holiday, sorry for the late reply ]

On 2023/1/27 07:54, Gavin Shan wrote:
> Currently, the unknown no-running-vcpu sites are reported when a
> dirty page is tracked by mark_page_dirty_in_slot(). Until now, the
> only known no-running-vcpu site is saving vgic/its tables through
> KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} command on KVM device
> "kvm-arm-vgic-its". Unfortunately, there are more unknown sites to
> be handled and no-running-vcpu context will be allowed in these
> sites: (1) KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} command
> on KVM device "kvm-arm-vgic-its" to restore vgic/its tables. The
> vgic3 LPI pending status could be restored. (2) Save vgic3 pending

We typically write it as "VGICv3".

> table through KVM_DEV_ARM_{VGIC_GRP_CTRL, VGIC_SAVE_PENDING_TABLES}
> command on KVM device "kvm-arm-vgic-v3".
> 
> In order to handle those unknown cases, we need a unified helper
> vgic_write_guest_lock(). struct vgic_dist::save_its_tables_in_progress
> is also renamed to struct vgic_dist::save_tables_in_progress.

How about renaming it to 'write_tables_in_progress' which would look a
bit more generic? The rest looks good to me.

Thanks,
Zenghui
