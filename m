Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750E079BDD8
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbjIKUs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242682AbjIKQGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 12:06:37 -0400
X-Greylist: delayed 433 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Sep 2023 09:06:31 PDT
Received: from out-213.mta1.migadu.com (out-213.mta1.migadu.com [IPv6:2001:41d0:203:375::d5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789141B6
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 09:06:31 -0700 (PDT)
Message-ID: <963a899d-d25a-368f-1465-851787c25959@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694447954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UWGx8nOe8UMiBtiPfiV0PpeEd8UXtwFSIc0awgSTnuM=;
        b=PTq8pYHKGyxAQ1Loh2IKxBsBNTnU1jI78EQH7m5D4j7ZaoK3folTH6rtJGyjpE2fcB7SyH
        fkkyU6heVJkLwN5BD2gA48F0Kv9OJihdLzz4iFxMsbKc2TGg4O4wOuyrfj81awE85s4tlz
        xyXERjf+ougQ5lZK4ULixkULhYKsUAE=
Date:   Mon, 11 Sep 2023 23:57:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>
References: <20230907100931.1186690-1-maz@kernel.org>
 <20230907100931.1186690-5-maz@kernel.org>
 <fd96f034-b7ca-c1bd-a94e-06f8e84e52a7@linux.dev>
 <87ledd51tu.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <87ledd51tu.wl-maz@kernel.org>
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

On 2023/9/11 02:18, Marc Zyngier wrote:
> On Sun, 10 Sep 2023 17:25:36 +0100,
> Zenghui Yu <zenghui.yu@linux.dev> wrote:
>>
>> Hi Marc,
>>
>> I asked because it seems that in kvm/arm64 we always use
>> kvm_get_vcpu(kvm, i) to obtain the kvm_vcpu pointer, even if *i* is
>> sometimes essentially provided by userspace..
> 
> Huh, this is incredibly dodgy. I had a go at a few occurrences (see
> below), but this is hardly a complete list.

Another case is all kvm_get_vcpu(kvm, target_addr) in the vgic-its
emulation code. As we expose GITS_TYPER.PTA=0 to guest, which indicates
that the target address corresponds to the PE number specified by
GICR_TYPER.Processor_Number, which is now encoded as vcpu->vcpu_id.

Thanks,
Zenghui
