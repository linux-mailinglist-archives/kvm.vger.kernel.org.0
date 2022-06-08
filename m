Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3220542B87
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 11:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbiFHJZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 05:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbiFHJZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 05:25:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2C8623A
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 01:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654678021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ILDvM8TSVfNQxAMgKdb/afVduGh6PmUKef1ZkWVk22c=;
        b=P/BvmWq6qpzrDAPopt4AHbaGHnmD348My+VJpd9TODAwSwpouGbR+JKDCZynYv1idMwjDd
        A2a80pFCf+OXrE7NoVzIJHf0KtiRvzuTB+mqr6aAVqgSwI8o3MUaiPCJjPMxKlvxfjiAq1
        mVmJZv++pBe3bjTThDOuFtvr/INfEpo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-DDN_aOWrNC-OANtkarqC3A-1; Wed, 08 Jun 2022 04:47:00 -0400
X-MC-Unique: DDN_aOWrNC-OANtkarqC3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE4EC18A6522;
        Wed,  8 Jun 2022 08:46:59 +0000 (UTC)
Received: from starship (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 137652026D64;
        Wed,  8 Jun 2022 08:46:56 +0000 (UTC)
Message-ID: <2f21ab3ed17c9b2b2d4996bc04c65672b005d8a5.camel@redhat.com>
Subject: Re: [PATCH v6 03/38] KVM: x86: hyper-v: Introduce TLB flush fifo
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 08 Jun 2022 11:46:56 +0300
In-Reply-To: <87bkv3mwag.fsf@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
         <20220606083655.2014609-4-vkuznets@redhat.com>
         <4be614689a902303cef1e5e1889564f965e63baa.camel@redhat.com>
         <87bkv3mwag.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-06-08 at 09:47 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Mon, 2022-06-06 at 10:36 +0200, Vitaly Kuznetsov wrote:
> > > To allow flushing individual GVAs instead of always flushing the
> > > whole
> > > VPID a per-vCPU structure to pass the requests is needed. Use
> > > standard
> > > 'kfifo' to queue two types of entries: individual GVA (GFN + up to
> > > 4095
> > > following GFNs in the lower 12 bits) and 'flush all'.
> > 
> > Honestly I still don't think I understand why we can't just
> > raise KVM_REQ_TLB_FLUSH_GUEST when the guest uses this interface
> > to flush everthing, and then we won't need to touch the ring
> > at all.
> 
> The main reason is that we need to know what to flush: L1 or
> L2. E.g. for VMX, KVM_REQ_TLB_FLUSH_GUEST is basically
> 
> vpid_sync_context(vmx_get_current_vpid(vcpu));
> 
> which means that if the target vCPU transitions from L1 to L2 or vice
> versa before KVM_REQ_TLB_FLUSH_GUEST gets processed we will flush the
> wrong VPID. And actually the writer (the vCPU which processes the TLB
> flush hypercall) is not anyhow synchronized with the reader (the vCPU
> whose TLB needs to be flushed) here so we can't even know if the target
> vCPU is in guest more or not.
> 
> With the newly added KVM_REQ_HV_TLB_FLUSH, we always look at the
> corresponding FIFO and process 'flush all' accordingly. In case the vCPU
> switches between modes, we always raise KVM_REQ_HV_TLB_FLUSH request to
> make sure we check. Note: we can't be raising KVM_REQ_TLB_FLUSH_GUEST
> instead as it always means 'full tlb flush' and we certainly don't want
> that.
> 


OK, that makes sense! Let it be then.

Best regards,
	Maxim Levitsky

