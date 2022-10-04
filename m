Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE665F497B
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 20:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJDSwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 14:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiJDSwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 14:52:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8F95FAE0
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 11:52:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id lx7so13669738pjb.0
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 11:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=rYCDQIEO1BytiJvNb4KrK7OXwPNVF1zBkOZqYI8W+wg=;
        b=XI983VX0rP9TzCvTQxG/TrM5KyQqscj2Sg/6cjkQERb2IyUKZ30WyyiBg5TnmrwHNd
         zd0Yw3sfJlmgIFIdIqpcw/0GNt1qbZmrwfYSvdeW9iFSO/lemM3EouIcyjkFHx8LnlQX
         n90gk268+RdFBnz1GBumaIezt3vVVVw1ZRGR23xfT5AHOg6HeSe++K6lJsomzll5OKPx
         RnhzNAecNKP3Gs5hKC/PQrs4227CR4NF6MbGy3VsmpDoUErCWgZPxSmNX1FdkQxNRBW1
         CrcfAyW6NCajgssFAPctnYplCa22UPdbURUMaAQ/6XzoyRbfPengtEZqiDoBcqUwOg4j
         FAUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rYCDQIEO1BytiJvNb4KrK7OXwPNVF1zBkOZqYI8W+wg=;
        b=vzZL+ezDCoISStW5K1Mf9OgptYX7N5+HyN0WXDxAK9EAFumtX3UyHHNhyoJNlguJwn
         5X6gnkXNx7b3tOuPhNM729aoiDMgPyzpQ/3WHm9FmXUVWiQAdjzoQvPrusxHjSjmlNur
         NP82OGJXXsg5+68BrwDGPdgo1Fr1JIuaHYoy2n1jOaP7h+9YT4qh1a2pAxkMTxZufm90
         WdUof2fPhbc73NLtEqcDz23Ann1hS2xgDU3xXeghitS359dElXyGtxzRCk4TeR0NcMTf
         g+1eUanWCv0VrlnRgKi2Any+3Cq+bZ/hEhCZGS6iVlmoUhbLIvvR+kz+8bACbMv8NHN7
         mspw==
X-Gm-Message-State: ACrzQf1md2nLkm7XrIG85BJz/ASBRm/6rTEWLKqzVIl37F3D9kOCvJfO
        0i7j/p7HfgN87RwOw2POqecbng==
X-Google-Smtp-Source: AMsMyM7q+Gvdtp2lPM9HHjHeSrfGlMdknkmXOLCzFIMhn3eWEmlZZgbWKbUXs8fgFT8WEHLtyJTt/w==
X-Received: by 2002:a17:90b:1b06:b0:202:cce0:2148 with SMTP id nu6-20020a17090b1b0600b00202cce02148mr1112036pjb.84.1664909519682;
        Tue, 04 Oct 2022 11:51:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mr9-20020a17090b238900b002001c9bf22esm1392320pjb.8.2022.10.04.11.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 11:51:58 -0700 (PDT)
Date:   Tue, 4 Oct 2022 18:51:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Carlos Bilbao <carlos.bilbao@amd.com>
Cc:     tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        venu.busireddy@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bilbao@vt.edu
Subject: Re: [PATCH] KVM: SVM: Fix reserved fields of struct sev_es_save_area
Message-ID: <YzyAyiZGyooB0A8e@google.com>
References: <986a5886-4ddc-aa88-db52-e8781ec95aed@amd.com>
 <dd357565-d428-499f-fa0e-e35aa043449f@amd.com>
 <YzxfdQ7DrT9X6t7j@google.com>
 <49227bcd-3e54-4a4d-5416-dcb9315a1802@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49227bcd-3e54-4a4d-5416-dcb9315a1802@amd.com>
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

On Tue, Oct 04, 2022, Carlos Bilbao wrote:
> 
> On 10/4/22 11:29, Sean Christopherson wrote:
> > On Tue, Oct 04, 2022, Carlos Bilbao wrote:
> > > On 10/4/22 09:05, Carlos Bilbao wrote:
> > > 
> > > > Reserved fields of struct sev_es_save_area are named by their order of
> > > > appearance, but right now they jump from reserved_5 to reserved_7. Rename
> > > > them with the correct order.
> > > > 
> > > > Fixes: 6d3b3d34e39eb ("KVM: SVM: Update the SEV-ES save area mapping")
> > > Actually, there is no bug, so this Fix tag could go. Thanks!!
> > Fixes: is appropriate, if we think it's worth fixing.  Personally, I don't think
> > it's worth the churn/effort to keep the reserved numbers accurate, e.g. if the
> > two bytes in reserved_1 are used, then every other field will need to be updated
> > just to accomodate a tiny change.  We'll find ourselves in a similar situation if
> > field is added in the middle of reserved_3,
> > 
> > If we really want to the number to have any kind of meaning without needing a pile
> > of churn for every update, the best idea I can think of is to name them reserved_<offset>.
> > That way only the affected reserved field needs to be modified when adding new
> > legal fields.  But that has it's own flavor of maintenance burden as calculating
> > and verifying the offset is a waste of everyone's time.
> > 
> > TL;DR: I vote to sweep this under the rug and live with arbitrary/bad numbers.
> Well, the discussion on what is the most appropriate way to name reserved
> fields is orthogonal to this patch, IMO.

It's not orthogonal, because how this "bug" is fixed determines the ongoing
maintenance cost.  If we're going to deal with code churn to clean things up, then
we want to churn the code exactly once.  If this was a one-line change then I
wouldn't care as much, but since it requires modifying half the reserved fields,
I'd rather we take an all-or-nothing approach.

> This change just follows the prior approach (reserved_x), but correctly.
> Keep in mind that the existence of reserved_{1,5} and reserved_{7,11}
> implies there's a reserved_6 (there isn't). Why knowingly keep something
> that's wrong, even if small?

Because the cost of maintaining the ordering far outweighs the benefits.  It's
not just about this patch, it's about all the future patches and reviews that will
be needed to keep the ordering correct.  On the benefits side, the fields are never
referenced and the names are effectively arbitrary, i.e. there's no real value in
keeping a sequence.

A simple "fix" would be to add a comment that the names are arbitrary and have
no meaning.  If really want to avoid ordering/skipping issues, then the we could
assign truly arbitrary names, e.g. something silly like this:

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..e55299a733b3 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -332,7 +332,10 @@ struct vmcb_save_area {
        u32 spec_ctrl;          /* Guest version of SPEC_CTRL at 0x2E0 */
 } __packed;
 
-/* Save area definition for SEV-ES and SEV-SNP guests */
+/*
+ * Save area definition for SEV-ES and SEV-SNP guests.  Note the names of the
+ * reserved fields are arbitrary and have no meaning.
+ */
 struct sev_es_save_area {
        struct vmcb_seg es;
        struct vmcb_seg cs;
@@ -349,12 +352,12 @@ struct sev_es_save_area {
        u64 vmpl2_ssp;
        u64 vmpl3_ssp;
        u64 u_cet;
-       u8 reserved_1[2];
+       u8 reserved_beef[2];
        u8 vmpl;
        u8 cpl;
-       u8 reserved_2[4];
+       u8 reserved_cafe[4];
        u64 efer;
-       u8 reserved_3[104];
+       u8 reserved_feed[104];
        u64 xss;
        u64 cr4;
        u64 cr3;
@@ -371,7 +374,7 @@ struct sev_es_save_area {
        u64 dr1_addr_mask;
        u64 dr2_addr_mask;
        u64 dr3_addr_mask;
-       u8 reserved_4[24];
+       u8 reserved_fee[24];
        u64 rsp;
        u64 s_cet;
        u64 ssp;
@@ -386,21 +389,21 @@ struct sev_es_save_area {
        u64 sysenter_esp;
        u64 sysenter_eip;
        u64 cr2;
-       u8 reserved_5[32];
+       u8 reserved_deaf[32];
        u64 g_pat;
        u64 dbgctl;
        u64 br_from;
        u64 br_to;
        u64 last_excp_from;
        u64 last_excp_to;
-       u8 reserved_7[80];
+       u8 reserved_dead[80];
        u32 pkru;
-       u8 reserved_8[20];
-       u64 reserved_9;         /* rax already available at 0x01f8 */
+       u8 reserved_bed[20];
+       u64 reserved_bead;              /* rax already available at 0x01f8 */
        u64 rcx;
        u64 rdx;
        u64 rbx;
-       u64 reserved_10;        /* rsp already available at 0x01d8 */
+       u64 reserved_cab;       /* rsp already available at 0x01d8 */
        u64 rbp;
        u64 rsi;
        u64 rdi;
@@ -412,7 +415,7 @@ struct sev_es_save_area {
        u64 r13;
        u64 r14;
        u64 r15;
-       u8 reserved_11[16];
+       u8 reserved_face[16];
        u64 guest_exit_info_1;
        u64 guest_exit_info_2;
        u64 guest_exit_int_info;
@@ -425,7 +428,7 @@ struct sev_es_save_area {
        u64 pcpu_id;
        u64 event_inj;
        u64 xcr0;
-       u8 reserved_12[16];
+       u8 reserved_fade[16];
 
        /* Floating point area */
        u64 x87_dp;


