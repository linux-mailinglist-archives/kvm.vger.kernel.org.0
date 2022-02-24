Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A18E4C3168
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 17:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiBXQdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 11:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiBXQdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 11:33:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 762E82C0327
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 08:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645720344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vcPtK5juKrQCjxOJebxU3eX3Pl6fam/VQTjX11RWkBk=;
        b=fmNa2M0ExsQuSH3CvfyLgyMRNYRMdRwh4H2auyJgxF6YjnR1g4s5Rf2QYA3/kFiPtHLwI+
        my6EKaMshK3RWMiI3uGjcZDCeUGDVAWpdMCP2vVgKZWZPODEbgtRsXhR9ZrEKTagUlE2O/
        wsIwU3ml2VkQFV1WvphR8BvruCjPnQI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-N6oZOjT2PlSyRcV5D7Aw0Q-1; Thu, 24 Feb 2022 11:32:21 -0500
X-MC-Unique: N6oZOjT2PlSyRcV5D7Aw0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C6A0180CBFB;
        Thu, 24 Feb 2022 16:32:20 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52FF17DE2E;
        Thu, 24 Feb 2022 16:32:07 +0000 (UTC)
Message-ID: <b7c2e257c8080f9724ee2ca96642d45d968a8b00.camel@redhat.com>
Subject: Re: [RFC PATCH 02/13] x86/cpufeatures: Introduce x2AVIC CPUID bit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Feb 2022 18:32:06 +0200
In-Reply-To: <20220221021922.733373-3-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-3-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
> Introduce a new feature bit for virtualized x2APIC (x2AVIC) in
> CPUID_Fn8000000A_EDX [SVM Revision and Feature Identification].
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 6db4e2932b3d..8c91a313668e 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -345,6 +345,7 @@
>  #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
>  #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
>  #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
> +#define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
>  #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
>  #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
>  
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

