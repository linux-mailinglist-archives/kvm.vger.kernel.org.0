Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9FF533EEA
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 16:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244734AbiEYOO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 10:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiEYOOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 10:14:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91504AE24C
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 07:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653488092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wM9x4B2z5qH/AhZypEbIZLZ9L9qM+TiDof1TvDE3R8I=;
        b=VwLU0rqlj2vBaox1JsWVS2hYDGlKKHYpm4N1X5Of+xn1ccd1qxkZlOTBiJM3uBgw4J8E+0
        dmZP6YkWJ6V3DSpdC6s+HftXhUeU1f0pqkarUYzKFjHSFtM5J5Zgo5+WTcmpxnWOf/oYLU
        fOpBLlx1ELOgViXLr8CptSq2RagLSa0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-aKo3TEKsO7mXUocalVHJtQ-1; Wed, 25 May 2022 10:14:49 -0400
X-MC-Unique: aKo3TEKsO7mXUocalVHJtQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2AE5185A794;
        Wed, 25 May 2022 14:14:48 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9794A1121315;
        Wed, 25 May 2022 14:14:46 +0000 (UTC)
Message-ID: <d50f564071a7d8cc63a25bb9c96317504f021f49.camel@redhat.com>
Subject: Re: [PATCH RESEND v12 00/17] KVM: x86/pmu: Add basic support to
 enable guest PEBS via DS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Wed, 25 May 2022 17:14:45 +0300
In-Reply-To: <eb34985a-3f21-f4d7-f25d-28f24c9794be@redhat.com>
References: <20220411101946.20262-1-likexu@tencent.com>
         <87fsl5u3bg.fsf@redhat.com>
         <e0b96ebd-00ee-ead4-cf35-af910e847ada@gmail.com>
         <d7461fd4-f6ec-1a0b-6768-0008a3092add@gmail.com>
         <874k1ltw9y.fsf@redhat.com>
         <f379a933-15b0-6858-eeef-5fbef6e5529c@gmail.com>
         <0848a2da-c9cf-6973-c774-ff16c3e8a248@redhat.com>
         <289d0c88-36a0-afd4-4d47-f2db3fb63654@gmail.com>
         <48b495c5610d25596a268c71b627b2e2136ac0bd.camel@redhat.com>
         <eb34985a-3f21-f4d7-f25d-28f24c9794be@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-25 at 16:13 +0200, Paolo Bonzini wrote:
> On 5/25/22 16:12, Maxim Levitsky wrote:
> > FYI, this patch series also break 'msr' test in kvm-unit tests.
> > (kvm/queue of today, and master of the kvm-unit-tests repo)
> > 
> > The test tries to set the MSR_IA32_MISC_ENABLE to 0x400c51889 and gets #GP.
> > 
> > 
> > Commenting this out, gets rid of #GP, but test still fails with unexpected result
> > 
> > 		if (!msr_info->host_initiated &&
> > 		    ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
> > 			return 1;
> > 
> > 
> > 
> > 
> > It is very possible that the test is broken, I'll check this later.
> 
> Yes, for that I've sent a patch already:
> 
> https://lore.kernel.org/kvm/20220520183207.7952-1-pbonzini@redhat.com/
> 
> Paolo
> 

Thank you very much!


Best regards,
	Maxim Levitsky

