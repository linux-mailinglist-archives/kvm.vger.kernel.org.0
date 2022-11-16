Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBAB62CC9F
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbiKPVXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbiKPVXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:23:17 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B79627CE
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:23:16 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id k22so18694723pfd.3
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XI3flRxAcr7a8D6XkYb5LrTIYauo43Fkflx+GElcf/8=;
        b=KeDg06mR9OW3BaVPOUUPuJktjN0VXrg1Klb/4isAeIvSHdWd19Cd66dnPiu7rwgwA4
         8J9oJNcrEgQvrPvJXpOmZ5YRXB65CpYlYymSMvmYrkKHeWa9ErzDzbuN4LQDsJ3qzgHh
         c/Iwja6lx94jXNWhCiYsQzaoG2BS3nSELrDWMs/moiqHhr2swfmqz8ykZEfjU6bwtbGv
         FQlxYxZuboZukLV5AJ0OKXzlYDxuCvaUj36nDXMys8XrU/a8X2dPt/a9g6rj02GndS7j
         JEFh1ky/1MTtvAZUYN2egguM8/VT+t+v5zcEM8VAdFsyV3M7lhNzUX8Ph12ETb0toOMF
         SUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XI3flRxAcr7a8D6XkYb5LrTIYauo43Fkflx+GElcf/8=;
        b=fZYsM87WY8CxUrnpr8wKfEnL0qFZJeiMrvyDSrvf64wWgynOunJPE3d858rxdzQzET
         PJcI/FpkEwtvE0o3aIC76tmY4m+p1nHJwIF18VhzNnBSPpjAn5uuWk1XaQzf2eqkwafx
         4FNr8tkJiH9Wrg3TPL6GoggjRSObUzJn0T66yfYiB2FmwGQPReJIFvtqvnOGI111ucf0
         ruZAQU6TIWMGIrV/V60gdSiGW22PXNmd0qzpoVYOt13v6hOh7O/7upQj1AI+KcfldNcF
         bz+elMOWx+SUNA1+nr2TMo0eeoo8Vxo8IN0fCHl0N6nkcgg6bWtA2+ARVAhHeBxK8m6G
         7zCQ==
X-Gm-Message-State: ANoB5plwbFLuFxsoUtGunNCmYFehogTaSsJF/cikUGzt6o1X9Bi2nJzn
        Fqm3xjvrVfSvDAnrApe3hFP65w==
X-Google-Smtp-Source: AA0mqf4/zo/G/YMsUhOm2m0gIgxC3Py8wQnBnsPxuDWf8Kc/jHdthJ8Ig2e1OBLVuSS6PWrlf6QxUQ==
X-Received: by 2002:aa7:9ec7:0:b0:56e:3a98:f02 with SMTP id r7-20020aa79ec7000000b0056e3a980f02mr25227890pfq.53.1668633796157;
        Wed, 16 Nov 2022 13:23:16 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v6-20020a626106000000b0056bb6dc882fsm11345319pfb.130.2022.11.16.13.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 13:23:15 -0800 (PST)
Date:   Wed, 16 Nov 2022 21:23:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Greg Edwards <gedwards@ddn.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: Allow APICv APIC ID inhibit to be cleared
Message-ID: <Y3VUwKJlnu+sNnV+@google.com>
References: <20221114202037.254176-1-gedwards@ddn.com>
 <20221116205123.18737-1-gedwards@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116205123.18737-1-gedwards@ddn.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022, Greg Edwards wrote:
> Legacy kernels prior to commit 4399c03c6780 ("x86/apic: Remove
> verify_local_APIC()") write the APIC ID of the boot CPU twice to verify
> a functioning local APIC.  This results in APIC acceleration inhibited
> on these kernels for reason APICV_INHIBIT_REASON_APIC_ID_MODIFIED.
> 
> Allow the APICV_INHIBIT_REASON_APIC_ID_MODIFIED inhibit reason to be
> cleared if/when all APICs in xAPIC mode set their APIC ID back to the
> expected vcpu_id value.
> 
> Fold the functionality previously in kvm_lapic_xapic_id_updated() into
> kvm_recalculate_apic_map(), as this allows us examine all APICs in one
> pass.
> 
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> Signed-off-by: Greg Edwards <gedwards@ddn.com>
> ---
> Changes from v1:
>   * Fold kvm_lapic_xapic_id_updated() into kvm_recalculate_apic_map() and
>     verify no APICs in xAPIC mode have a modified APIC ID before clearing
>     APICV_INHIBIT_REASON_APIC_ID_MODIFIED.  [Sean]
>   * Rebase on top of Sean's APIC fixes+cleanups series.  [Sean]
>     https://lore.kernel.org/all/20221001005915.2041642-1-seanjc@google.com/
> 
>  arch/x86/kvm/lapic.c | 45 +++++++++++++++++++-------------------------
>  1 file changed, 19 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9b3af49d2524..362472da6e7f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -236,6 +236,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  	struct kvm_vcpu *vcpu;
>  	unsigned long i;
>  	u32 max_id = 255; /* enough space for any xAPIC ID */
> +	bool xapic_id_modified = false;

Maybe "xapic_id_mismatch"?  E.g. if KVM ends up back because the xAPIC ID was
modified back to be vcpu_id, then this is somewhat misleading from super pedantic
point of view.  "modified" was ok when the inhibit was a one-way street.

>  	/* Read kvm->arch.apic_map_dirty before kvm->arch.apic_map.  */
>  	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
> @@ -285,6 +286,19 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		xapic_id = kvm_xapic_id(apic);
>  		x2apic_id = kvm_x2apic_id(apic);
>  
> +		if (!apic_x2apic_mode(apic)) {
> +			/*
> +			 * Deliberately truncate the vCPU ID when detecting a
> +			 * modified APIC ID to avoid false positives if the
> +			 * vCPU ID, i.e. x2APIC ID, is a 32-bit value.  If the
> +			 * wrap/truncation results in unwanted aliasing, APICv
> +			 * will be inhibited as part of updating KVM's
> +			 * optimized APIC maps.

Heh, the last sentence is stale since this _is_ the flow updates the optimized
maps.

> +			 */
> +			if (xapic_id != (u8)x2apic_id)

It's more than a bit silly, but I would rather this use vcpu->vcpu_id instead of
x2apic_id.  KVM's requirement is that the xAPIC ID must match the vCPU ID.  The
reason I called out x2APIC in the comment was to hint at why KVM even supports
32-bit vCPU IDs.  The fact that KVM also makes the x2APIC ID immutable is orthogonal,
which makes the above check somewhat confusing (even though they're identical under
the hood).

And we should fold the two if-statements together, then the block comment can be
placed outside of the if and have more less indentation to deal with.

How about:
		/*
		 * Deliberately truncate the vCPU ID when detecting a mismatched
		 * APIC ID to avoid false positives if the vCPU ID, i.e. x2APIC
		 * ID, is a 32-bit value.  Any unwanted aliasing due to
		 * truncation results will be detected below.
		 */
		if (!apic_x2apic_mode(apic) && xapic_id != vcpu->vcpu_id)
			xapic_id_mismatch = true;
