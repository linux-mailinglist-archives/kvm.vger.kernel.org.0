Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99E44C3158
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 17:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiBXQbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 11:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiBXQbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 11:31:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 264EA1F6340
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 08:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645720239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=prgZNdV4s/mPu6PlnmJr/hT5U+BTnmvKi0C0dZguK/8=;
        b=YLpBltOEnyXqzsjhQWnvDLFHAZVZaNF0IKHtePrFeGGHaDvauxVsLCI1QMMAgv8yOXqD7h
        zqYfPUjLdQug/8AGhxq8sS0GKO2lxbvexoMBlcCpdyB7SQcgvOmB0MP5h0kW+AgjEWXUNk
        vji3xGhj3FnxOibYTy85O6xxD+h63Eo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-wNvCV_4TOIWtOCStLWJrxA-1; Thu, 24 Feb 2022 11:30:36 -0500
X-MC-Unique: wNvCV_4TOIWtOCStLWJrxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEE551854E21;
        Thu, 24 Feb 2022 16:30:34 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B5AF10016F2;
        Thu, 24 Feb 2022 16:30:31 +0000 (UTC)
Message-ID: <c9e8ca945fc08f502701c4df7c9fffa1f5f0c001.camel@redhat.com>
Subject: Re: [RFC PATCH 01/13] KVM: SVM: Add warning when encounter invalid
 APIC ID
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Feb 2022 18:30:30 +0200
In-Reply-To: <20220221021922.733373-2-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-2-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
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
> Current logic checks if avic_get_physical_id_entry() fails to
> get the entry, and return error. This could silently cause
> AVIC to fail to operate.  Therefore, add WARN_ON to help
> report this error.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index f07956f15d3b..472445aaaf42 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -447,8 +447,10 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
>  
>  	old = avic_get_physical_id_entry(vcpu, vcpu->vcpu_id);
>  	new = avic_get_physical_id_entry(vcpu, id);
> -	if (!new || !old)
> +	if (!new || !old) {
> +		WARN_ON(1);
>  		return 1;
> +	}
>  
>  	/* We need to move physical_id_entry to new offset */
>  	*new = *old;

I about to purge all of this code, and disallow setting the apicid regardles
if x2apic, or plain xapic was used at least when AVIC is enabled.
I really hope for this to be accepted, so we won't need to fix this code.

Best regards,
	Maxim Levitsky

