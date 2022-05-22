Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA2E5301F3
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 11:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242411AbiEVJCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 05:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiEVJCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 05:02:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E82A1658A
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 02:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653210130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lHhQz7yGeH9M0bT14FqcQt3xWJJwKp6CTxN9gSJseho=;
        b=EkOVD1tcdvgJjHoKUnYaveKkd0A4zOdSbyh6lc2i5sNJpOs0Q3K58eectNx5K27Wz+ybqu
        kY3IuzWHPiB0lL06rmBYeA4rdPIewTqrwObIhEx05RlNqhYgD+7A//w0IRQA66TZbCr6Jn
        K6Z8zZLb3+vANqpaRi15Af1HVQIF8Xw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-xF3jqyc_NQ-5Tgbu_BvSSQ-1; Sun, 22 May 2022 05:02:05 -0400
X-MC-Unique: xF3jqyc_NQ-5Tgbu_BvSSQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2421D3C02B60;
        Sun, 22 May 2022 09:02:04 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01D1640CF8E7;
        Sun, 22 May 2022 09:01:56 +0000 (UTC)
Message-ID: <d1df82a17e6e89ab58d5f6aa911ee2d532efee31.camel@redhat.com>
Subject: Re: [RFC PATCH v3 03/19] KVM: x86: SVM: remove avic's broken code
 that updated APIC ID
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Date:   Sun, 22 May 2022 12:01:55 +0300
In-Reply-To: <YoZr9wC2KjTFHrQ7@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
         <20220427200314.276673-4-mlevitsk@redhat.com> <YoZr9wC2KjTFHrQ7@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-19 at 16:10 +0000, Sean Christopherson wrote:
> On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> > AVIC is now inhibited if the guest changes apic id, thus remove
> > that broken code.
> 
> Can you explicitly call out what's broken?  Just something short on the code not
> handling the scenario where APIC ID is changed back to vcpu_id to help future
> archaeologists.  I forget if there are other bugs...
> 


Well, the avic_handle_apic_id_update is called each time the AVIC is uninhibited,
because while it is inhibited, the AVIC code doesn't track changes to APIC ID and such.

Also there are many ways it is broken for example

1. a CPU can't move its APIC ID to a free slot due to (!new) check

2. If APIC ID is moved to a used slot, then the CPU that used that overwritten
slot can't correctly move it, since its now not its slot, not to mention races.


BTW, if you see a value in it, I can fix this code instead - a lock + going over all the apic ids,
should be quite easy to implement. In case of two vCPUs using the same APIC ID,
I can write non present entry to the table, so none will be able to be addressed,
hoping that the situation is only temporary.

Same can be done for IPIv.

Best regards,
	Maxim Levitsky

