Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8066780B2
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 17:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjAWQBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 11:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbjAWQBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 11:01:08 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7D0B769
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 08:01:07 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so14825896pjq.0
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 08:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5D/c5XUJd5uKmbPOsz5AkcZFWVubvIBqfc2z6/WMNB4=;
        b=eeOISEGEF7RgxutWTeUWPmcdVV/H9eskdXTbkTP9NCl7xT+A50TZDpnoNfYygFpbJR
         JY1eBct85K5LbwjpqJhMWbQ9peOfOqYIBNBemVzIJ36xoQ3pUjgf96utl8J90bP3WKKJ
         GbVPJFrT7cCFVbzFL6c/MJyAIrH8qVim0HIC03sWQI/cyvfPAN4L5bzdPODAzdxisaPO
         uF46rKuYISnCgDupDPfvcYE3Cm/rORoFTcjoM6huFsbYg2XOw7hSAqB5LNWJJY8gO97X
         JzCZ7gTpSuhRhk61tuBsA/lhKFE3LbeypSIeXoHr1MrJXNGUlA874ONiSNxYZ3tWzdSe
         cH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5D/c5XUJd5uKmbPOsz5AkcZFWVubvIBqfc2z6/WMNB4=;
        b=MtOPoqbEdKsqk9mjIaIPZlPrwMFxE1wXMQKjjTfqmpVMwyrdSWfgiYKsrMd2Fg+GUw
         sGzHmVUtWYYvS8+h5Xvj/RMhvCNHOMX+0+beCIuIviEZy80+xYhxR6OQ2R1dOr5m9fjC
         OOBt5dMHBFD9K8qberZTecV5ac0VplAERTFyYMs1ksE2UuUb4wFkwU7DTn5PbJyTOThp
         fiXjANCfOTKie/lR3qhiI2FBvsDyn8GGAUwJqy7KgCHi8al9fLHE4OFDpAxqOvYVoqb1
         k9CaLSSY5jb98UlARcNTDFIowk0Avqz+qWMiNAuPd6Ph7V5ZXF9E/JQCTnLSbrsyvu80
         cUig==
X-Gm-Message-State: AFqh2krNd1vIvSKYukJYSstF1J6wA2voVFGcRxB+cithvM6buB221FfF
        B3d+Pg0dN+WTdmwfP2L7NXfLpw==
X-Google-Smtp-Source: AMrXdXsrFTdZevP8ElF/qCY5flJEu7hnpxUE8YQ/fXBW6AK6dmdHbGOqkMpViqthVPOrI4ivI/jngQ==
X-Received: by 2002:a05:6a20:4b06:b0:a4:efde:2ed8 with SMTP id fp6-20020a056a204b0600b000a4efde2ed8mr561648pzb.0.1674489666427;
        Mon, 23 Jan 2023 08:01:06 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y13-20020a63e24d000000b00478eb777d18sm27791258pgj.72.2023.01.23.08.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 08:01:05 -0800 (PST)
Date:   Mon, 23 Jan 2023 16:01:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH v2] KVM: VMX: Fix crash due to uninitialized current_vmcs
Message-ID: <Y86vPo7vcKm9VBD8@google.com>
References: <20230123124641.4138-1-alexandru.matei@uipath.com>
 <87edrlcrk1.fsf@ovpn-194-126.brq.redhat.com>
 <e591f716-cc3b-a997-95a0-dc02c688c8ec@uipath.com>
 <Y86uaYL2JOPxMzn/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y86uaYL2JOPxMzn/@google.com>
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

On Mon, Jan 23, 2023, Sean Christopherson wrote:
> On Mon, Jan 23, 2023, Alexandru Matei wrote:
> > > .. or, alternatively, you can directly pass 
> > > (struct hv_enlightened_vmcs *)vmx->vmcs01.vmcs as e.g. 'current_evmcs'
> > > and avoid the conversion here.
> > 
> > OK, sounds good, I'll pass hv_enlightened_vmcs * directly.
> 
> Passing the eVMCS is silly, if we're going to bleed eVMCS details into vmx.c then
> we should just commit and expose all details.  For this feature specifically, KVM
> already handles the enabling in vmx.c / vmx_vcpu_create():
> 
> 	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
> 	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
> 		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
> 
> 		evmcs->hv_enlightenments_control.msr_bitmap = 1;
> 	}
> 
> And if we handle this fully in vmx_msr_bitmap_l01_changed(), then there's no need
> for a comment explaining that the feature is only enabled for vmcs01.

Oh, and the sanity check on a null pointer also goes away.

> If we want to maintain better separate between VMX and Hyper-V code, then just make
> the helper non-inline in hyperv.c, modifying MSR bitmaps will never be a hot path
> for any sane guest.
> 
> I don't think I have a strong preference either way.  In a perfect world we'd keep
> Hyper-V code separate, but practically speaking I think trying to move everything
> into hyperv.c would result in far too many stubs and some weird function names.
> 
> Side topic, we should really have a wrapper for static_branch_unlikely(&enable_evmcs)
> so that the static key can be defined iff CONFIG_HYPERV=y.  I'll send a patch.

I.e.

---
 arch/x86/kvm/vmx/hyperv.h | 11 -----------
 arch/x86/kvm/vmx/vmx.c    |  9 +++++++--
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index ab08a9b9ab7d..bac614e40078 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -250,16 +250,6 @@ static inline u16 evmcs_read16(unsigned long field)
 	return *(u16 *)((char *)current_evmcs + offset);
 }
 
-static inline void evmcs_touch_msr_bitmap(void)
-{
-	if (unlikely(!current_evmcs))
-		return;
-
-	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
-		current_evmcs->hv_clean_fields &=
-			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
-}
-
 static inline void evmcs_load(u64 phys_addr)
 {
 	struct hv_vp_assist_page *vp_ap =
@@ -280,7 +270,6 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
 static inline u32 evmcs_read32(unsigned long field) { return 0; }
 static inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
-static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 #define EVMPTR_INVALID (-1ULL)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c788aa382611..ed4051b54412 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3936,8 +3936,13 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
 	 * bitmap has changed.
 	 */
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)) {
+		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
+
+		if (evmcs->hv_enlightenments_control.msr_bitmap)
+			evmcs->hv_clean_fields &=
+				~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
+	}
 
 	vmx->nested.force_msr_bitmap_recalc = true;
 }

base-commit: 68bfbbf518a25856c2a3f07ea9d0c626f1b001fb
-- 

