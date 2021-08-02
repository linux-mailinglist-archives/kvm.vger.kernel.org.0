Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0FC3DDD5F
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhHBQRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhHBQRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:17:42 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9AAC06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:17:33 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j3so5101200plx.4
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zU4Km9Xz2ma9TZyEErXSSIBE51kWXW5SA9HioAi4L6w=;
        b=TanlmeFxDfqKEgHv6rA6JXadf7GIYWq6G+jP7gC2o4pSqccLs+fGF21LiqeBdbLVoS
         tuFRBlRk74n5bJ3QL5FhX0km+86iX7QJNRRuPrRB7T37BHrCIixPKqhye92ew5nFEDMD
         gebzpdu73x29vMrmwVAJH7cqhCerANyQaaKHm0/8i3ZEhcH/Z6PHddf9kqQ84AewH+ie
         SuJkB3j0CrcvP7VaEsYSIPfANl9W3rCVLsB6f+LHmRmACL3myZ1VmDlSKD2SNKy2eFlr
         IEJDIRN35z7pxD764u7iV0+VgBBDDQEbD9p1D/i27IQgKXG/MSVjdltI8T1/ML+WIAA+
         iM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zU4Km9Xz2ma9TZyEErXSSIBE51kWXW5SA9HioAi4L6w=;
        b=NH5vgP5QEpoIZ1LQeJkYL9SMCPCEIufaouBb6ufRDstteZf57qHn96JdKpdTTx6G7Z
         gyfAonqe9xwoOWjmp1csl67FZIQCW0mzJYkTDJSr1ly2NU6czHXZ7DK1TBSQ5rhHpYB8
         AHyJ76nRVUlJu/y9+aysneGZmr7sRvcIC6OeoTXfZJvaRBy6SGW4hvkPgDf5DLsPqZw4
         bLrhuYauVwQ+JA2Fzz+gWP3QUPa/bGsoVclL9lFqHg/T0aa3sdcQtFMjOYPa/eUhZDgE
         ti3rUWyCGSzl4ryoU5WnQw62hcSK0fnIQ5+ezzFnGETEuLT/aHwjRlcqMLkCBZUnufFN
         bBCQ==
X-Gm-Message-State: AOAM533yKyxRj3k7YAOLxXxrNqBxzwR75TwZfoHxCmNIrFTVlL2XbXoZ
        0uCKVYvquAwFmWr7jDgR6Ks6ig==
X-Google-Smtp-Source: ABdhPJwpXDOHw8GX9R7BVIzO5EarRMpQvOpYccmckQhR0WqE/Q7ZXGLh7JldSVTDMhXQSuSKr2bRqA==
X-Received: by 2002:a05:6a00:1305:b029:347:676:d38f with SMTP id j5-20020a056a001305b02903470676d38fmr17387018pfu.39.1627921052657;
        Mon, 02 Aug 2021 09:17:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q17sm14503353pgd.39.2021.08.02.09.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 09:17:32 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:17:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Alper Gun <alpergun@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH] KVM: SEV: improve the code readability for ASID
 management
Message-ID: <YQgamDDn6TVY/BoV@google.com>
References: <20210731011304.3868795-1-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210731011304.3868795-1-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021, Mingwei Zhang wrote:
> KVM SEV code uses bitmaps to manage ASID states. ASID 0 was always skipped
> because it is never used by VM. Thus, ASID value and its bitmap postion
> always has an 'offset-by-1' relationship.

That's not necessarily a bad thing, assuming the bitmap is properly sized.

> Both SEV and SEV-ES shares the ASID space, thus KVM uses a dynamic range
> [min_asid, max_asid] to handle SEV and SEV-ES ASIDs separately.
> 
> Existing code mixes the usage of ASID value and its bitmap position by
> using the same variable called 'min_asid'.
> 
> Fix the min_asid usage: ensure that its usage is consistent with its name;
> adjust its value before using it as a bitmap position. Add comments on ASID
> bitmap allocation to clarify the skipping-ASID-0 property.
> 
> Fixes: 80675b3ad45f (KVM: SVM: Update ASID allocation to support SEV-ES guests)

As Joerg commented, Fixes: is not appropriate unless there's an actual bug being
addressed.  And based on the shortlog's "improve the code readability", I would
expect a pure refactoring, i.e. something's got to give.  AFAICT, this is a pure
refactoring, so the Fixes: should be dropped.

> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Alper Gun <alpergun@google.com>
> Cc: Dionna Glaze <dionnaglaze@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vipin Sharma <vipinsh@google.com>
> Ce: Peter Gonda <pgonda@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 8d36f0c73071..e3902283cbf7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -80,7 +80,7 @@ static int sev_flush_asids(int min_asid, int max_asid)
>  	int ret, pos, error = 0;
>  
>  	/* Check if there are any ASIDs to reclaim before performing a flush */
> -	pos = find_next_bit(sev_reclaim_asid_bitmap, max_asid, min_asid);
> +	pos = find_next_bit(sev_reclaim_asid_bitmap, max_asid, min_asid - 1);
>  	if (pos >= max_asid)
>  		return -EBUSY;
>  
> @@ -142,10 +142,10 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>  	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
>  	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
>  	 */
> -	min_asid = sev->es_active ? 0 : min_sev_asid - 1;
> +	min_asid = sev->es_active ? 1 : min_sev_asid;
>  	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
>  again:
> -	pos = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_asid);
> +	pos = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_asid - 1);

IMO, this is only marginally better, as the checks against max_asid are still
misleading, and the "pos + 1" + "min_asid - 1" interaction is subtle.

>  	if (pos >= max_asid) {

This is the check that's misleading/confusing.

Rather than adjusting the bitmap index, what about simply umping the bitmap size?
IIRC, current CPUs have 512 ASIDs, counting ASID 0, i.e. bumping the size won't
consume any additional memory.  And if it does, the cost is 8 bytes...

It'd be a bigger refactoring, but it should completely eliminate the mod-by-1
shenanigans, e.g. a partial patch could look like

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 62926f1a5f7b..7bcdc34546d7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -64,6 +64,7 @@ static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned long sev_me_mask;
+static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;

@@ -81,8 +82,8 @@ static int sev_flush_asids(int min_asid, int max_asid)
        int ret, pos, error = 0;

        /* Check if there are any ASIDs to reclaim before performing a flush */
-       pos = find_next_bit(sev_reclaim_asid_bitmap, max_asid, min_asid);
-       if (pos >= max_asid)
+       pos = find_next_bit(sev_reclaim_asid_bitmap, nr_asids, min_asid);
+       if (pos > max_asid)
                return -EBUSY;

        /*
@@ -115,8 +116,8 @@ static bool __sev_recycle_asids(int min_asid, int max_asid)

        /* The flush process will flush all reclaimable SEV and SEV-ES ASIDs */
        bitmap_xor(sev_asid_bitmap, sev_asid_bitmap, sev_reclaim_asid_bitmap,
-                  max_sev_asid);
-       bitmap_zero(sev_reclaim_asid_bitmap, max_sev_asid);
+                  nr_asids);
+       bitmap_zero(sev_reclaim_asid_bitmap, nr_asids);

        return true;
 }
@@ -143,11 +144,11 @@ static int sev_asid_new(struct kvm_sev_info *sev)
         * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
         * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
         */
-       min_asid = sev->es_active ? 0 : min_sev_asid - 1;
+       min_asid = sev->es_active ? 1 : min_sev_asid;
        max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
 again:
-       pos = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_asid);
-       if (pos >= max_asid) {
+       pos = find_next_zero_bit(sev_asid_bitmap, sev_asid_bitmap_size, min_asid);
+       if (pos > max_asid) {
                if (retry && __sev_recycle_asids(min_asid, max_asid)) {
                        retry = false;
                        goto again;
@@ -161,7 +162,7 @@ static int sev_asid_new(struct kvm_sev_info *sev)

        mutex_unlock(&sev_bitmap_lock);

-       return pos + 1;
+       return pos;
@@ -1855,12 +1942,17 @@ void __init sev_hardware_setup(void)
        min_sev_asid = edx;
        sev_me_mask = 1UL << (ebx & 0x3f);
 
-       /* Initialize SEV ASID bitmaps */
-       sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
+       /*
+        * Initialize SEV ASID bitmaps.  Allocate space for ASID 0 in the
+        * bitmap, even though it's never used, so that the bitmap is indexed
+        * by the actual ASID.
+        */
+       nr_asids = max_sev_asid + 1;
+       sev_asid_bitmap = bitmap_zalloc(nr_asids, GFP_KERNEL);
        if (!sev_asid_bitmap)
                goto out;
 
-       sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
+       sev_reclaim_asid_bitmap = bitmap_zalloc(nr_asids, GFP_KERNEL);
        if (!sev_reclaim_asid_bitmap) {
                bitmap_free(sev_asid_bitmap);
                sev_asid_bitmap = NULL;
