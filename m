Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA1C4E885D
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 17:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235828AbiC0PQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 11:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235824AbiC0PQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 11:16:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D40650B1E
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 08:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648394098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aO0HGjT7ZCP54sd0nyJvdO8KKuk8vcPL3oF3GsN92ZE=;
        b=iTZWhd2Cw+EpClHtTj9x6GAQ82rDWJ6NAHuzOk02Pe8hSbqooJXkWUxDMln6kRuJpH4zFf
        zHIuMRP3u+d4ESefdz5KMVVqwq3EjK5/V7SHLNPkI2L7PKTNKjbicWXHpMrlg+l0GCwWtG
        ++XZzxYS/QtdgAJjT7xI3wM/YWIVak8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-ORdutjHEP4arkCb2xFdKWg-1; Sun, 27 Mar 2022 11:14:53 -0400
X-MC-Unique: ORdutjHEP4arkCb2xFdKWg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44DD0185A79C;
        Sun, 27 Mar 2022 15:14:53 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D9531402404;
        Sun, 27 Mar 2022 15:14:50 +0000 (UTC)
Message-ID: <d71378091e7a410ce56947b72d6e59deccaa65bd.camel@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: x86: nSVM: support PAUSE filtering when L0
 doesn't intercept PAUSE
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Sun, 27 Mar 2022 18:14:49 +0300
In-Reply-To: <848bba1a-66f2-a3eb-510e-9322b729c8ec@redhat.com>
References: <20220322174050.241850-1-mlevitsk@redhat.com>
         <20220322174050.241850-4-mlevitsk@redhat.com>
         <848bba1a-66f2-a3eb-510e-9322b729c8ec@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-24 at 19:24 +0100, Paolo Bonzini wrote:
> On 3/22/22 18:40, Maxim Levitsky wrote:
> > Allow L1 to use PAUSE filtering if L0 doesn't use it.
> > 
> > Signed-off-by: Maxim Levitsky<mlevitsk@redhat.com>
> 
> Can you enlarge the commit message to explain the logic in 
> nested_vmcb02_prepare_control?

No problem, I will do in the next version.

How about this:

KVM: x86: nSVM: support nested PAUSE filtering when possible           
 
Expose the pause filtering and threshold in the guest CPUID 
and support PAUSE filtering when possible:

- If the L0 doesn't intercept PAUSE
  (cpu_pm=on, or pause_filter_count kvm_amd's parameter is 0),
  then allow L1 to have full control over PAUSE filtering.
 
- Otherwise if the L1 doesn't intercept PAUSE, 
  use KVM's PAUSE thresholds, and update them even 
  when running nested.
 
- Otherwise ignore both	host and guest PAUSE thresholds,
  because it is	not really possible to merge them correctly.

  It is	expected that in this case, userspace hypervisor (e.g qemu)
  will not enable this feature in the guest CPUID, to avoid
  having the guest to update both thresholds pointlessly.


Best regards,
	Maxim Levitsky

> 
> Thanks,
> 
> Paolo
> 


