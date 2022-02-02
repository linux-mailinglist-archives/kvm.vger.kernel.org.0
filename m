Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8234A756B
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 17:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344315AbiBBQFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 11:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345730AbiBBQFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 11:05:38 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE1AC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 08:05:37 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id j10so18678970pgc.6
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 08:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yqK5MLTl2xNuINrlf3fO99F6jKkeeqpnAsyOTq/QdsY=;
        b=omj6doHtoJY17veFe8sQU7Cmg6x2J8MqoUhsX7k7C63TNCbhW5x9y1bGWckN2qif/x
         6iScQHtPmlsw+gqCRU6ez4J0V9RC5VaOptJYWYILu98gte5z58yT//P7HodOcq+KNpLi
         Rff7r7N9VCPAPcQG17PJxJzQXBegojuVs2kda+1oUA9QxzvBfQnVPpU4aiKYRN+D2DWw
         462vBzLQlCF7x+vbgHdPl3wwkxDwmjxHt4sH/mFjxvDi3U2DNvn9FkEPu3OeCoa7cDdj
         FyrnNxveN3s3SQBAWH963d9CuI45mNC40JSHM8W69GouMa3hBp0Gd3invDF8aHFrUu2n
         kgwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yqK5MLTl2xNuINrlf3fO99F6jKkeeqpnAsyOTq/QdsY=;
        b=E2sRfgi2WSrAP3Hz455Cki9Wt4Jry0WELqKKirf2MOntAifXWET7ZkaHgdinN5DxSZ
         spgb3k4JDcSuEOl4pxKB85AEVSGbwj+KHGWA59w87rmkwrC+v6+CeoWatdiMPSCQs8YK
         x/FrFf9XICDOjYWfzuhQyaBnq3UUjBA/l+XhN47OTYo1HIwjG1TLZu1TeWH2pweLu8dJ
         NIlJFp1be/pKmiHKXD/tOF6O9SmJCnHpCDXe0H6emSsFVtvRTHiUbyVjNhuZRP/TWKXm
         +stQy/4q2tCL9eBiOIIgfqdnzCGo7KhKh0mchNz8Q1r7thjwMIR70nUdOKqR7rLAkPuN
         DIcg==
X-Gm-Message-State: AOAM530CE2FWLzUcTrH2DoW2ivEqu9Bk32sasBfNUmI7t50WX/TIgkhE
        ibvVt5gcdkHmORdf8/G3f7gsIQ==
X-Google-Smtp-Source: ABdhPJyVuMgXy9sJ7c475B0/eoyoSeQgJcgUEYfrNF1AwDQH/tPYoLN1ijQ6+BjavEGag97f30Pbqg==
X-Received: by 2002:a62:52d4:: with SMTP id g203mr30348392pfb.19.1643817936918;
        Wed, 02 Feb 2022 08:05:36 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 12sm6902701pjd.33.2022.02.02.08.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 08:05:36 -0800 (PST)
Date:   Wed, 2 Feb 2022 16:05:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, mlevitsk@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
Subject: Re: [PATCH v3 3/3] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
Message-ID: <YfqrzHc0cbuiKKt0@google.com>
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
 <20211213113110.12143-4-suravee.suthikulpanit@amd.com>
 <Yc3qt/x1YPYKe4G0@google.com>
 <34a47847-d80d-e93d-a3fe-c22382977c1c@amd.com>
 <Yfms5evHbN8JVbVX@google.com>
 <9d2ca4ab-b945-6356-5e4b-265b1a474657@amd.com>
 <YfqpFt5raCd/LZzr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfqpFt5raCd/LZzr@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022, Sean Christopherson wrote:
> On Wed, Feb 02, 2022, Suthikulpanit, Suravee wrote:
> > As I mentioned, the APM will be corrected to remove the word "x2APIC".
> 
> Ah, I misunderstood what part was being amended.
> 
> > Essentially, it will be changed to:
> > 
> >  * 7:0  - For systems w/ max APIC ID upto 255 (a.k.a old system)
> >  * 11:8 - For systems w/ max APIC ID 256 and above (a.k.a new system). Otherwise, reserved and should be zero.
> > 
> > As for the required number of bits, there is no good way to tell what's the max
> > APIC ID would be on a particular system. Hence, we utilize the apic_get_max_phys_apicid()
> > to figure out how to properly program the table (which is leaving the reserved field
> > alone when making change to the table).
> > 
> > The avic_host_physical_id_mask is not just for protecting APIC ID larger than
> > the allowed fields. It is also currently used for clearing the old physical APIC ID table entry
> > before programing it with the new APIC ID.
> 
> Just clear 11:0 unconditionally, the reserved bits are Should Be Zero.

Actually, that needs to be crafted a bug fix that's sent to stable@, otherwise
running old kernels on new hardware will break.  I'm pretty sure this is the
entirety of what's needed.

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 90364d02f22a..e4cfd8bf4f24 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -974,17 +974,12 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
        u64 entry;
-       /* ID = 0xff (broadcast), ID > 0xff (reserved) */
        int h_physical_id = kvm_cpu_get_apicid(cpu);
        struct vcpu_svm *svm = to_svm(vcpu);

        lockdep_assert_preemption_disabled();

-       /*
-        * Since the host physical APIC id is 8 bits,
-        * we can support host APIC ID upto 255.
-        */
-       if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
+       if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
                return;

        /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 73525353e424..a157af1cce6a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -560,7 +560,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT                        31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK               (1 << 31)

-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK   (0xFFULL)
+#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK   GENMASK_ULL(11:0)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK       (0xFFFFFFFFFFULL << 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK         (1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK              (1ULL << 63)
