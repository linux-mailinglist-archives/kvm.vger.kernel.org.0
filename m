Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF61504F36
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 13:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbiDRLGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 07:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiDRLGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 07:06:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35F4B1A05A
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 04:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650279810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UF0fnA90LasQb7mrfhdBv6sQa3PZEy3d2vDTDD6YZTQ=;
        b=TewXLm1yhcTmdYu6mW2T6ax5y95rMxgYT0ra9tFBBBJ+EqbFKQEpdU+Aw0HtJsQWQPOGS5
        eem/itEYYJTR+2iI2YStVKjTGT0JyFAIT67peQTbtCli+wEyxWceWeqdrgivPtzxeO9jMT
        k0oaYXGRQ8jaMSxScFAu3La6uR/tHD8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-O9-TCYt5OZiarajsh1N4nQ-1; Mon, 18 Apr 2022 07:03:25 -0400
X-MC-Unique: O9-TCYt5OZiarajsh1N4nQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88D1180B710;
        Mon, 18 Apr 2022 11:03:24 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70F2D401472;
        Mon, 18 Apr 2022 11:03:22 +0000 (UTC)
Message-ID: <967628469381c4e1a0d8b9afe5dbb3e40a644c8c.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Introduce trace point for the slow-path
 of avic_kic_target_vcpus
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Mon, 18 Apr 2022 14:03:21 +0300
In-Reply-To: <20220414051151.77710-3-suravee.suthikulpanit@amd.com>
References: <20220414051151.77710-1-suravee.suthikulpanit@amd.com>
         <20220414051151.77710-3-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 00:11 -0500, Suravee Suthikulpanit wrote:
> This can help identify potential performance issues when handles
> AVIC incomplete IPI due vCPU not running.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c |  2 ++
>  arch/x86/kvm/trace.h    | 20 ++++++++++++++++++++
>  arch/x86/kvm/x86.c      |  1 +
>  3 files changed, 23 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 92d8e0de1fb4..e5fb4931a2f1 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -440,6 +440,8 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>  	if (!avic_kick_target_vcpus_fast(kvm, source, icrl, icrh, index))
>  		return;
>  
> +	trace_kvm_avic_kick_vcpu_slowpath(icrh, icrl, index);
> +
>  	/*
>  	 * Wake any target vCPUs that are blocking, i.e. waiting for a wake
>  	 * event.  There's no need to signal doorbells, as hardware has handled
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index e3a24b8f04be..de4762517569 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1459,6 +1459,26 @@ TRACE_EVENT(kvm_avic_ga_log,
>  		  __entry->vmid, __entry->vcpuid)
>  );
>  
> +TRACE_EVENT(kvm_avic_kick_vcpu_slowpath,
> +	    TP_PROTO(u32 icrh, u32 icrl, u32 index),
> +	    TP_ARGS(icrh, icrl, index),
> +
> +	TP_STRUCT__entry(
> +		__field(u32, icrh)
> +		__field(u32, icrl)
> +		__field(u32, index)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->icrh = icrh;
> +		__entry->icrl = icrl;
> +		__entry->index = index;
> +	),
> +
> +	TP_printk("icrh:icrl=%#08x:%08x, index=%u",
> +		  __entry->icrh, __entry->icrl, __entry->index)
> +);
> +
>  TRACE_EVENT(kvm_hv_timer_state,
>  		TP_PROTO(unsigned int vcpu_id, unsigned int hv_timer_in_use),
>  		TP_ARGS(vcpu_id, hv_timer_in_use),
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d0fac57e9996..c2da6c7516b0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12978,6 +12978,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_kick_vcpu_slowpath);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_accept_irq);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
        Maxim Levitsky

