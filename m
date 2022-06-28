Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC71555E427
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345622AbiF1NOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344102AbiF1NOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:14:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E43F255A5
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656422060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=akalRBv8rSXwTfwuxqw08LsnmFGrOfMBind/GarjuNw=;
        b=J8dhRQwXIphtkJh0uRI/eCEB/nKit7Nrx5Fco1dlCANkE8liG65tTSkKyB97Vu1NyxKNAl
        Kg7ipxIsDrDTixvrT57PA/rxrPVqHA0BUGEEwUXrC/R+bqP5PbwtCRRuaqCr8KY5QW6U+4
        r88kfe0W/Fbf4hqSg8z7xLChwKzPBL0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-b-YdLMubOnKH5qUii0tOtg-1; Tue, 28 Jun 2022 09:14:17 -0400
X-MC-Unique: b-YdLMubOnKH5qUii0tOtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9AC31C01B43;
        Tue, 28 Jun 2022 13:14:16 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 940432166B26;
        Tue, 28 Jun 2022 13:14:14 +0000 (UTC)
Message-ID: <3e91bffa4323535349cc003af3ef808653ea4682.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Fix x2APIC Logical ID calculation for
 avic_kick_target_vcpus_fast
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Tue, 28 Jun 2022 16:14:13 +0300
In-Reply-To: <20220628123314.486001-1-suravee.suthikulpanit@amd.com>
References: <20220628123314.486001-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-28 at 07:33 -0500, Suravee Suthikulpanit wrote:
> For X2APIC ID in cluster mode, the logical ID is bit [15:0].
> 
> Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index a830468d9cee..29f393251c4c 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -378,7 +378,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  
>  		if (apic_x2apic_mode(source)) {
>  			/* 16 bit dest mask, 16 bit cluster id */
> -			bitmap = dest & 0xFFFF0000;
> +			bitmap = dest & 0xFFFF;
>  			cluster = (dest >> 16) << 4;
>  		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
>  			/* 8 bit dest mask*/

Ouch, sorry about that :(

It just shows how much this code needs a test, I will write one really soon.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky

