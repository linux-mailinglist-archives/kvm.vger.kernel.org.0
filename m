Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DD4628B5E
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 22:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbiKNVab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 16:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237593AbiKNVaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 16:30:24 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30219192B1
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 13:30:23 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so11980753pjd.4
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 13:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wvi7jckV1mmNMhx4gjnU9C4imhYwalEXctJsv4GFNHw=;
        b=P01+MGoZ8z6OJ6i/I0CeNTrSmLbSvvrqXFBXNMZg9DtXwTRBQypk3uARXLTq0mPVDa
         RUvjstPcs7kyfg4+iq30JFacIPHtD1Rs7hvwWEwB3CRZIEVHV4T5ZLVmC/sa1HLwGFKm
         t0rZyZigG8f/buJV2a/7q3w6S17ODSRD5IVvobROqkVpUQ8ul8OhVvevghcdXvBso/kK
         3hpms+rbY33rLOAs9p0Y5E6Hi6Ah6+IP2wtDbYUcGJ820bH6ILEK6n+ujhMTBjL27I92
         pDpeDD08IVgP16apuVyhdA28n9vD4xUCYKdJOtfSpxo+OqcZRRixJJKVEgUOJzTYbKgG
         ajVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wvi7jckV1mmNMhx4gjnU9C4imhYwalEXctJsv4GFNHw=;
        b=td4VDT+/7didsSbPXjFSwFzPTjLRzoXaEGC0cnmisCWL78rtISymrsTFG99Ea3f2Z3
         dfAXGDBfkNIF9VDuJkz3ZN5V2f0tLJVBHNmeyMmhxdi8SpSgPRPdqFbXovsrFYJpeEmA
         6rtS2t+EKbx1A+0bbk9D9Qj7u1wRW4RgWTTh++XsaywASzBhNg+iZcmy1OaIMQJEJdEm
         89CHAlrCU+z6OGArZydVIdmRp68iEOAX+PAvxJkw5MGCNBkZwyDYH/pqdbgTRor0pZzI
         7T78M03BsBzkd2LN0Kx1G+xfGvCjP4myEREeSpoLyFARz2HkMbRVVuj0ltnnIPPLIDUg
         W2Xg==
X-Gm-Message-State: ANoB5pmVr+sQaseqKA0ndgcWXJD7wh+40Mef0jrwCCAyvdiqpyhELXZ1
        zYq1tMUEKlG8DUPJL8/Tjl+Qcw==
X-Google-Smtp-Source: AA0mqf6wsJljRUFZlqeYlIdX49r/psHgrlAyhVMWPIRzV4/FjRUWK9cb47cT/3890HjLC7xkjizOkw==
X-Received: by 2002:a17:90a:53a6:b0:212:bf31:d00 with SMTP id y35-20020a17090a53a600b00212bf310d00mr15228352pjh.33.1668461422593;
        Mon, 14 Nov 2022 13:30:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x5-20020a63cc05000000b0046ec0ef4a7esm6349479pgf.78.2022.11.14.13.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 13:30:22 -0800 (PST)
Date:   Mon, 14 Nov 2022 21:30:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Greg Edwards <gedwards@ddn.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: x86: Allow APICv APIC ID inhibit to be cleared on
 legacy kernels
Message-ID: <Y3KzarZ5xzExFrj9@google.com>
References: <20221114202037.254176-1-gedwards@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114202037.254176-1-gedwards@ddn.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022, Greg Edwards wrote:
> Legacy kernels prior to commit 4399c03c6780 ("x86/apic: Remove
> verify_local_APIC()") write the xAPIC ID of the boot CPU twice to verify
> a functioning local APIC.  This results in APIC acceleration inhibited
> on these kernels for reason APICV_INHIBIT_REASON_APIC_ID_MODIFIED.
> 
> Allow the APICV_INHIBIT_REASON_APIC_ID_MODIFIED inhibit reason to be
> cleared if/when the xAPIC ID is set back to the expected vcpu_id value.
> This occurs on the second xAPIC ID write in verify_local_APIC().
> 
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> Signed-off-by: Greg Edwards <gedwards@ddn.com>
> ---
>  arch/x86/kvm/lapic.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index d7639d126e6c..4064d0af094d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2075,8 +2075,13 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
>  	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
>  		return;
>  
> -	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
> +	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id) {
> +		/* Legacy kernels prior to 4399c03c6780 write APIC ID twice. */
> +		if (!kvm_apicv_activated(kvm))
> +			kvm_clear_apicv_inhibit(kvm,
> +					APICV_INHIBIT_REASON_APIC_ID_MODIFIED);

This sadly doesn't work because the inhibit is per-VM, i.e. will do the wrong
thing if there are still vCPU's with different APIC IDs.

Does skipping the check if the APIC is disabled help[*]?  At a glance, I can't
tell if the APIC is enabled/disabled at that point in time.  It's not a true fix,
but it's a lot easier to backport if it remedies the issue.

For a proper fix, this entire path should be moved to kvm_recalculate_apic_map()
so that can can safely toggle the inhibit, e.g. the recalc helper already deals
with multiple vCPUs changing their APIC state in parallel.  I don't think the fix
will be too difficult to craft such that it's backport friendly, but it would need
to be slotted into the series containing the aforementioned fix.

[*] https://lore.kernel.org/all/20221001005915.2041642-6-seanjc@google.com

---
 arch/x86/kvm/lapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5de1c7aa1ce9..67260f7ce43a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2072,6 +2072,9 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
 {
 	struct kvm *kvm = apic->vcpu->kvm;
 
+	if (!kvm_apic_hw_enabled(apic))
+		return;
+
 	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
 		return;
 

