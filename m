Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3163A4E720F
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 12:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351663AbiCYLRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 07:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345679AbiCYLRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 07:17:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAB61D1CF7
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 04:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648206928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XwoB2DdMS8Re/gd/jZzrIHA3Gl2fwa+gau/YeDMTlPs=;
        b=gT02l1kEjIBxhWXmTYmQ4SaaBFJMCmFMdHdkQoRZsM7ylBK33DXEoxCVtGMqnZ7oxNzho+
        Enkl/h+KkeXOM3bE+1Or1QGP3BcrESxLNmMeOAnn+4bInWQnCyunPDfmOirfkZ8QAkgY7x
        daOua7uoXjpEPaV1LwOUV/rZhjR+pv8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-32rx6RLHPQKjv4QLyU_R0w-1; Fri, 25 Mar 2022 07:15:24 -0400
X-MC-Unique: 32rx6RLHPQKjv4QLyU_R0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 499263C01B8E;
        Fri, 25 Mar 2022 11:15:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3B5340D296B;
        Fri, 25 Mar 2022 11:15:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Don't rebuild page when the page is synced and no tlb flushing is required
Date:   Fri, 25 Mar 2022 07:14:34 -0400
Message-Id: <20220325111432.2959162-1-pbonzini@redhat.com>
In-Reply-To: <0dabeeb789f57b0d793f85d073893063e692032d.1647336064.git.houwenlong.hwl@antgroup.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Before Commit c3e5e415bc1e6 ("KVM: X86: Change kvm_sync_page()
> to return true when remote flush is needed"), the return value
> of kvm_sync_page() indicates whether the page is synced, and
> kvm_mmu_get_page() would rebuild page when the sync fails.
> But now, kvm_sync_page() returns false when the page is
> synced and no tlb flushing is required, which leads to
> rebuild page in kvm_mmu_get_page(). So return the return
> value of mmu->sync_page() directly and check it in
> kvm_mmu_get_page(). If the sync fails, the page will be
> zapped and the invalid_list is not empty, so set flush as
> true is accepted in mmu_sync_children().
> 
> Fixes: c3e5e415bc1e6 ("KVM: X86: Change kvm_sync_page() to return true when remote flush is needed")
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>

Queued and Cc'ed to stable@, thanks.

Paolo


