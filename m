Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9454C33DE
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 18:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbiBXRl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 12:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiBXRlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 12:41:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 661D61C2F60
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645724482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=70SduNrAiaotDuCIZO647ys8w2/fadsYzkVqmSb6sHw=;
        b=TyYX9oWOqAW6YugnNUsxMTtW6wyFESLlV4ED7b7euRcFTJK9UBFDkPJ6vbqpbMerAmd/UE
        hR+Xeo1jX2uY5MhVmM0huZY3UgpA7NVpr+/tO1XifM3psKkBkjQsyz/pOY8Ar3NCIRcbtP
        s+FmZ47pnZ49AYsKU9MsPIeZmtb1GgU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-Wg3qdFI8OLuymlgHy0vicQ-1; Thu, 24 Feb 2022 12:41:17 -0500
X-MC-Unique: Wg3qdFI8OLuymlgHy0vicQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70B5E80573C;
        Thu, 24 Feb 2022 17:41:14 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E50D51077CBF;
        Thu, 24 Feb 2022 17:41:11 +0000 (UTC)
Message-ID: <55c391a51bf6b7d3927493ff56333e9846e04a4a.camel@redhat.com>
Subject: Re: [RFC PATCH 08/13] KVM: SVM: Do not update logical APIC ID table
 when in x2APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Feb 2022 19:41:10 +0200
In-Reply-To: <20220221021922.733373-9-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-9-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
> In X2APIC mode the Logical Destination Register is read-only,
> which provides a fixed mapping between the logical and physical
> APIC IDs. Therefore, there is no Logical APIC ID table in X2AVIC
> and the processor uses the X2APIC ID in the backing page to create
> a vCPU’s logical ID.
> 
> Therefore, add logic to check x2APIC mode before updating logical
> APIC ID table.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 215d8a7dbc1d..55b3b703b93b 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -417,6 +417,10 @@ static int avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
>  	bool flat;
>  	u32 *entry, new_entry;
>  
> +	/* Note: x2AVIC does not use logical APIC ID table */
> +	if (apic_x2apic_mode(vcpu->arch.apic))
> +		return 0;
> +
>  	flat = kvm_lapic_get_reg(vcpu->arch.apic, APIC_DFR) == APIC_DFR_FLAT;
>  	entry = avic_get_logical_id_entry(vcpu, ldr, flat);
>  	if (!entry)
> @@ -435,8 +439,13 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
> -	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
> +	u32 *entry;
> +
> +	/* Note: x2AVIC does not use logical APIC ID table */
> +	if (apic_x2apic_mode(vcpu->arch.apic))
> +		return;
>  
> +	entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
>  	if (entry)
>  		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
>  }


Here actually the good apic_x2apic_mode was used.

However, shouldn't we inject #GP in avic_ldr_write to make this read realy read-only?
It might be too late to do so here, since most AVIC writes are trap like.

Thus we need to make the msr that corresponds to LDR to be write protected in the msr bitmap,
and inject #GP when write it attempted.

Then we can add WARN_ON in this function for this case instead.

Best regards,
	Maxim Levitsky

