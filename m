Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1111D7229EB
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbjFEOzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234176AbjFEOzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:55:17 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFF211B
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 07:55:12 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q6Bbx-00BsX1-PD; Mon, 05 Jun 2023 16:55:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=7Pbf8SsxGF+K+f05cyGtz00cKCtpJ+QFkP0vW0jy+v8=; b=PuaBp+TzTclLdW4D4YLADmvDrR
        eux6B0g+CkMMP+ioNo/CKrxj2d52addDwvSHasRvW7RHithd3Zz+KmkmmLKmqHMKl9MHHXp9zAH/1
        UsB/R5I0RUTVJA1VSf6ONMSmA6L/0wUqHRqzYPXc3d1zc/OtyQCghGt7HmyEfDRIC581FozAxxfCr
        vhOuEPG3Gfr90OF8kRq7Yb/aFXM/Ra6/e4W9V4qiunp/VHLLo57ejNaIC0I16r6VAz766PZDLvmxX
        egRYgHF+HF8VsJtIWzwkx4sr7pPtfoA9WGjLrGQ+fYvLBkb3z5EgWbKQk5eUURCbSutVVyAQ4leQJ
        Y0qrtFRA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q6Bbw-0007Wp-Pw; Mon, 05 Jun 2023 16:55:09 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q6Bbh-0000o9-TA; Mon, 05 Jun 2023 16:54:53 +0200
Message-ID: <585cb687-54e5-90f3-36f2-0c356183db89@rbox.co>
Date:   Mon, 5 Jun 2023 16:54:52 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH] KVM: Clean up kvm_vm_ioctl_create_vcpu()
Content-Language: pl-PL, en-GB
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20230605114852.288964-1-mhal@rbox.co>
 <20230605130333.gzhjx4gbw7nkqbm2@yy-desk-7060>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <20230605130333.gzhjx4gbw7nkqbm2@yy-desk-7060>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/5/23 15:03, Yuan Yao wrote:
> On Mon, Jun 05, 2023 at 01:44:19PM +0200, Michal Luczaj wrote:
>> Since c9d601548603 ("KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond")
>> 'cond' is internally converted to boolean, so caller's explicit conversion
>> from void* is unnecessary.
>>
>> Remove the double bang.
>> ...
>> -	if (KVM_BUG_ON(!!xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
>> +	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> 
> Looks the only one place for KVM_BUG_ON().
> 
> Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> 
> BTW: svm_get_lbr_msr() is using KVM_BUG(false, ...) and
> handle_cr() is using KVM_BUG(1, ...), a chance to
> change them to same style ?

Sure, but KVM_BUG(false, ...) is a no-op, right? Would you like me to fix it
separately with KVM_BUG(1, ...) as a (hardly significant) functional change?

Also, am I correct to assume that (1, ) is the preferred style?
arch/powerpc/kvm/book3s_64_mmu_host.c:kvmppc_mmu_map_page() seems to be the only
exception (within KVM) with a `WARN_ON(true)`.
