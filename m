Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12085163FC
	for <lists+kvm@lfdr.de>; Sun,  1 May 2022 13:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345435AbiEALUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 07:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345540AbiEALUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 07:20:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 021C43389E
        for <kvm@vger.kernel.org>; Sun,  1 May 2022 04:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651403807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=40wx7YoNTJq4ruKMh85O/z9tjweHIGnlDUSMaZZvSak=;
        b=DnmrTxBfcgv74ph5SUYJ0IJc05EoYPeqeXb335BN0W+hLuq3rhJWDVLzZcZh0QSMdIorfH
        bM49REvorHrrRrPMN4qUDHcwGk5qREAIkLZuWlXKGgfByLghEdcpcpYtolBnSsZJ1oDdb/
        dIIiFnNhQlgmCagOpfhLTW/FTmhqQ00=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-h7faW0YePPe-nuoJa_hdCQ-1; Sun, 01 May 2022 07:16:44 -0400
X-MC-Unique: h7faW0YePPe-nuoJa_hdCQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDF073C025BC;
        Sun,  1 May 2022 11:16:43 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C83CB2166B26;
        Sun,  1 May 2022 11:16:42 +0000 (UTC)
Message-ID: <1dcfb3d243916a3957d5368c2298e3f8fd79a9f2.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: work around QEMU issue with synthetic CPUID
 leaves
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Sun, 01 May 2022 14:16:41 +0300
In-Reply-To: <20220429192553.932611-1-pbonzini@redhat.com>
References: <20220429192553.932611-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-29 at 15:25 -0400, Paolo Bonzini wrote:
> Synthesizing AMD leaves up to 0x80000021 caused problems with QEMU,
> which assumes the *host* CPUID[0x80000000].EAX is higher or equal
> to what KVM_GET_SUPPORTED_CPUID reports.
> 
> This causes QEMU to issue bogus host CPUIDs when preparing the input
> to KVM_SET_CPUID2.  It can even get into an infinite loop, which is
> only terminated by an abort():
> 
>    cpuid_data is full, no space for cpuid(eax:0x8000001d,ecx:0x3e)
> 
> To work around this, only synthesize those leaves if 0x8000001d exists
> on the host.  The synthetic 0x80000021 leaf is mostly useful on Zen2,
> which satisfies the condition.
> 
> Fixes: f144c49e8c39 ("KVM: x86: synthesize CPUID leaf 0x80000021h if useful")
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b24ca7f4ed7c..598334ed5fbc 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1085,12 +1085,21 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	case 0x80000000:
>  		entry->eax = min(entry->eax, 0x80000021);
>  		/*
> -		 * Serializing LFENCE is reported in a multitude of ways,
> -		 * and NullSegClearsBase is not reported in CPUID on Zen2;
> -		 * help userspace by providing the CPUID leaf ourselves.
> +		 * Serializing LFENCE is reported in a multitude of ways, and
> +		 * NullSegClearsBase is not reported in CPUID on Zen2; help
> +		 * userspace by providing the CPUID leaf ourselves.
> +		 *
> +		 * However, only do it if the host has CPUID leaf 0x8000001d.
> +		 * QEMU thinks that it can query the host blindly for that
> +		 * CPUID leaf if KVM reports that it supports 0x8000001d or
> +		 * above.  The processor merrily returns values from the
> +		 * highest Intel leaf which QEMU tries to use as the guest's
> +		 * 0x8000001d.  Even worse, this can result in an infinite
> +		 * loop if said highest leaf has no subleaves indexed by ECX.

Very small nitpick: It might be useful to add a note that qemu does this only for the
leaf 0x8000001d.

>  		 */
> -		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC)
> -		    || !static_cpu_has_bug(X86_BUG_NULL_SEG))
> +		if (entry->eax >= 0x8000001d &&
> +		    (static_cpu_has(X86_FEATURE_LFENCE_RDTSC)
> +		     || !static_cpu_has_bug(X86_BUG_NULL_SEG)))
>  			entry->eax = max(entry->eax, 0x80000021);
>  		break;
>  	case 0x80000001:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

