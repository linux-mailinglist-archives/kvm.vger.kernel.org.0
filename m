Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867CA519FA6
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 14:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349683AbiEDMi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 08:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349527AbiEDMiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 08:38:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0230225EA0
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 05:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651667686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ct2PlEY6QQ3N5sgB9Tu4Cg6jVTTmJssD5F6j4gnRtK4=;
        b=Zqjwc8y1XoKyMbpkNQyGnuloePQroBae8x2TbHoECmRTdWR94+1zJyKyuQ7pHYBjLjx4MK
        sxGYTkTMO3Jz529VnwBpArrkeBPfJfYAQOoZJYertpCZx/ZIdDpza5eIYpRBAblbENZx4o
        ThKTJT7LoJop9G++gGGKTUrqudpaeE0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-TFrKv3fMMoeKwU5CoYnd8w-1; Wed, 04 May 2022 08:34:42 -0400
X-MC-Unique: TFrKv3fMMoeKwU5CoYnd8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3DBE185A7BA;
        Wed,  4 May 2022 12:34:41 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F7B640CF8F8;
        Wed,  4 May 2022 12:34:39 +0000 (UTC)
Message-ID: <93e65bad6bbb8b1c198aa4da295d4d48ad5e24f3.camel@redhat.com>
Subject: Re: [PATCH v3 13/14] KVM: SVM: Use target APIC ID to complete
 x2AVIC IRQs when possible
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Wed, 04 May 2022 15:34:38 +0300
In-Reply-To: <20220504073128.12031-14-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
         <20220504073128.12031-14-suravee.suthikulpanit@amd.com>
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

On Wed, 2022-05-04 at 02:31 -0500, Suravee Suthikulpanit wrote:
> For x2AVIC, the index from incomplete IPI #vmexit info is invalid
> for logical cluster mode. Only ICRH/ICRL values can be used
> to determine the IPI destination APIC ID.
> 
> Since QEMU defines guest physical APIC ID to be the same as
> vCPU ID, it can be used to quickly identify the target vCPU to deliver IPI,
> and avoid the overhead from searching through all vCPUs to match the target
> vCPU.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 3b6a96043633..a526fbc60bbd 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -377,7 +377,26 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  			/* For xAPIC logical mode, the index is for logical APIC table. */
>  			apic_id = avic_logical_id_table[index] & 0x1ff;
>  		} else {
> -			return -EINVAL;
> +			/* For x2APIC logical mode, cannot leverage the index.
> +			 * Instead, calculate physical ID from logical ID in ICRH.
> +			 */
> +			int apic;
> +			int first = ffs(icrh & 0xffff);
> +			int last = fls(icrh & 0xffff);
> +			int cluster = (icrh & 0xffff0000) >> 16;
> +
> +			/*
> +			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0]) contains zero
> +			 * or more than 1 bits, we cannot match just one vcpu to kick for
> +			 * fast path.
> +			 */
> +			if (!first || (first != last))
> +				return -EINVAL;
> +
> +			apic = first - 1;
> +			if ((apic < 0) || (apic > 15) || (cluster >= 0xfffff))
> +				return -EINVAL;
> +			apic_id = (cluster << 4) + apic;
>  		}
>  	}
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
        Maxim Levitsky

