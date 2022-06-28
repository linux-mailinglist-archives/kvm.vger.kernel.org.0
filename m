Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE00055E42A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344145AbiF1NPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239676AbiF1NPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:15:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5CF872CDC4
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656422105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ZOCb43a6XtspipSZyH021F8n9v8AZtTda7ttlCF3gs=;
        b=Un/FJ9udktWfLaahU9fom+IFPFph1kXW/pB8we3WMJGp/v2yq+c8dWC/m0DLYGMerDrygm
        s1kyoF2gaGuGXVNvLan5ozGAC7XOeZ4ylAGshHg3EPZAs6jz7ytSpH592EYe5cvGy2CVB1
        pRCHbOUCz1GXS0dc/+c5AGNX/2QBUm8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-nlKef17tMHuexN_WhN-YCg-1; Tue, 28 Jun 2022 09:15:02 -0400
X-MC-Unique: nlKef17tMHuexN_WhN-YCg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F9CD811E7A;
        Tue, 28 Jun 2022 13:15:01 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45BEB492C3B;
        Tue, 28 Jun 2022 13:14:59 +0000 (UTC)
Message-ID: <c0051d4701ddcf00a1357f5a108acf655f813b37.camel@redhat.com>
Subject: Re: [PATCH v6 15/17] KVM: SVM: Use target APIC ID to complete
 x2AVIC IRQs when possible
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, joro@8bytes.org, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com
Date:   Tue, 28 Jun 2022 16:14:58 +0300
In-Reply-To: <cc77d885-fdf2-bac8-65d4-ab0994272548@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
         <20220519102709.24125-16-suravee.suthikulpanit@amd.com>
         <b8610296-6fb7-e110-900f-4616e1e39bb4@redhat.com>
         <d761ef283bc91002322f3cd66c124d329c25f04f.camel@redhat.com>
         <9f3ffe16-2516-d4ec-528e-6347ef884ad5@amd.com>
         <df464fd9b3c66059d7065acc52594d27dfe52448.camel@redhat.com>
         <cc77d885-fdf2-bac8-65d4-ab0994272548@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-28 at 19:36 +0700, Suthikulpanit, Suravee wrote:
> Paolo / Maxim
> 
> On 6/28/2022 3:59 PM, Maxim Levitsky wrote:
> > > > Hi Paolo and Suravee Suthikulpanit!
> > > > 
> > > > Note that this patch is not needed anymore, I fixed the avic_kick_target_vcpus_fast function,
> > > > and added the support for x2apic because it was very easy to do
> > > > (I already needed to parse logical id for flat and cluser modes)
> > > > 
> > > > Best regards,
> > > > 	Maxim Levitsky
> > > > 
> > > Understood. I was about to send v7 to remove this patch from the series, but too late. I'll test the current queue branch and provide update.
> > Also this really needs a KVM unit test, to avoid breaking corner cases like
> > sending IPI to 0xFF address, which was the reason I had to fix the
> > avic_kick_target_vcpus_fast.
> > 
> > We do have 'apic' test in kvm unit tests,
> > and I was already looking to extend it to cover more cases and to run it with AVIC's
> > compatible settings. I hope I will be able to do this this week.
> 
> Thanks. Would you please CC me as well once ready?

Of course!
> 
> > Best regards,
> > 	Maxim Levitsky
> 
> I have also submitted a patch to fix the 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast"),
> which was queued previously.

Thank you very much!

Best regards,
	Maxim Levitsky


> 
> Best Regards,
> Suravee Suthikulpanit
> 


