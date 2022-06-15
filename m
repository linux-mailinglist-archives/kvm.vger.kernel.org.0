Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0338D54CABE
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 16:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243453AbiFOOB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 10:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355685AbiFOOB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 10:01:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 995B144767
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655301684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkqA8lXM7RGqvrGS7f6UnaLKbk7wXVD0P9vKbHcd5hs=;
        b=UBUoDGvbd7HIrRrYqaZdvirDy/THMkWPyGP7l8u9KlOCI9kEFdRyrUzstoSLyHKEzWCe0o
        QQCn3l5NO13yqIYzxB6Fp/M3zQBPGFgP2RUirO4nFPjkbKhqTiBL7DPB0NLNZjmMkdsLyY
        swtAGjpYmNNFakr2hXFVrwzzVjJDiQA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-qvVpFnHHM8OMKgaCH4EbNg-1; Wed, 15 Jun 2022 10:01:23 -0400
X-MC-Unique: qvVpFnHHM8OMKgaCH4EbNg-1
Received: by mail-wm1-f72.google.com with SMTP id l17-20020a05600c4f1100b0039c860db521so1261600wmq.5
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:01:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fkqA8lXM7RGqvrGS7f6UnaLKbk7wXVD0P9vKbHcd5hs=;
        b=fZFXLCZ8Q+99jrzxCInyMEwa8yqWz1qr9JRRuyq4KOSHXj3zg8Bd0WuUFDg6FISiv6
         7Vam6flX3u5k8HAW9CaTx1wmaLN5eYCgrc5jeF9o4pfpOAmzZrSy2DqOpfW1utBaZvGj
         Lbwy5wOm2+gZopS7Vf+GJvgrrvalna3j82GbKTdSaTEqLZPYLIgrLz50A2ljEyHa/ImC
         qYgW22NOSDDs5LzRP5sHs1pupa+j5KlQMlc/bByJBRlDE7h6PFy/iWQvv0HpsnxfK/y3
         fK3i8yMjfOnPrfcdNc4y7TXR2nMpJNl/6unDWIQXbEfMvjhE66aVpq6lrxQSGUyrin78
         qjNA==
X-Gm-Message-State: AOAM531KQs0tWLkyuwREdxm9/D6isbnTgthyLJ8/ORdwAKXdcqmcz8ZN
        Yx3huOekYYPa78oBbPZh8OwVVivzYCR/tkyGN7nd8XN47Gv87v386O3HceKNbpJYL1BIGU5D6ha
        1NvC939D/TJBS
X-Received: by 2002:a05:600c:1f0c:b0:39c:600e:6d51 with SMTP id bd12-20020a05600c1f0c00b0039c600e6d51mr9930067wmb.3.1655301682010;
        Wed, 15 Jun 2022 07:01:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYHsXkYT3PfPo0qLxobsWOVSY9s4CmbO+huQNlARM5lycW74V6oc28+X3LTyQ84YUmoNq99Q==
X-Received: by 2002:a05:600c:1f0c:b0:39c:600e:6d51 with SMTP id bd12-20020a05600c1f0c00b0039c600e6d51mr9930045wmb.3.1655301681743;
        Wed, 15 Jun 2022 07:01:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id d6-20020adff2c6000000b002100e86319asm14663442wrp.78.2022.06.15.07.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 07:01:20 -0700 (PDT)
Message-ID: <090e701d-6893-ea25-1237-233ff3dd01ee@redhat.com>
Date:   Wed, 15 Jun 2022 16:01:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 5/8] KVM: x86/mmu: Use separate namespaces for guest
 PTEs and shadow PTEs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
References: <20220614233328.3896033-1-seanjc@google.com>
 <20220614233328.3896033-6-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220614233328.3896033-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/15/22 01:33, Sean Christopherson wrote:
> Separate the macros for KVM's shadow PTEs (SPTE) from guest 64-bit PTEs
> (PT64).  SPTE and PT64 are _mostly_ the same, but the few differences are
> quite critical, e.g. *_BASE_ADDR_MASK must differentiate between host and
> guest physical address spaces, and SPTE_PERM_MASK (was PT64_PERM_MASK) is
> very much specific to SPTEs.
> 
> Opportunistically (and temporarily) move most guest macros into paging.h
> to clearly associate them with shadow paging, and to ensure that they're
> not used as of this commit.  A future patch will eliminate them entirely.
> 
> Sadly, PT32_LEVEL_BITS is left behind in mmu_internal.h because it's
> needed for the quadrant calculation in kvm_mmu_get_page().  The quadrant
> calculation is hot enough (when using shadow paging with 32-bit guests)
> that adding a per-context helper is undesirable, and burying the
> computation in paging_tmpl.h with a forward declaration isn't exactly an
> improvement.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

A better try:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 54b3e39d07b3..cd561b49cc84 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2011,8 +2011,21 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
  	role.direct = direct;
  	role.access = access;
  	if (role.has_4_byte_gpte) {
+		/*
+		 * The "quadrant" value corresponds to those bits of the address
+		 * that have already been used by the 8-byte shadow page table
+		 * lookup, but not yet in the 4-byte guest page tables.  Having
+		 * the quadrant as part of the role ensures that each upper sPTE
+		 * points to the the correct portion of the guest page table
+		 * structure.
+		 *
+		 * For example, a 4-byte PDE consumes bits 31:22 and an 8-byte PDE
+		 * consumes bits 29:21.  Each guest PD must be expanded into four
+		 * shadow PDs, one for each value of bits 31:30, and the PDPEs
+		 * will use the four quadrants in round-robin fashion.
+		 */
  		quadrant = gaddr >> (PAGE_SHIFT + (SPTE_LEVEL_BITS * level));
-		quadrant &= (1 << ((PT32_LEVEL_BITS - SPTE_LEVEL_BITS) * level)) - 1;
+		quadrant &= (1 << level) - 1;
  		role.quadrant = quadrant;
  	}
  	if (level <= vcpu->arch.mmu->cpu_role.base.level)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index cb9d4d358335..5e1e3c8f8aaa 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -20,9 +20,6 @@ extern bool dbg;
  #define MMU_WARN_ON(x) do { } while (0)
  #endif
  
-/* The number of bits for 32-bit PTEs is to needed compute the quandrant. */
-#define PT32_LEVEL_BITS 10
-
  /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
  #define __PT_LEVEL_SHIFT(level, bits_per_level)	\
  	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 6c29aef4092b..e4655056e651 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -38,7 +38,7 @@
  	#define pt_element_t u32
  	#define guest_walker guest_walker32
  	#define FNAME(name) paging##32_##name
-	#define PT_LEVEL_BITS PT32_LEVEL_BITS
+	#define PT_LEVEL_BITS 10
  	#define PT_MAX_FULL_LEVELS 2
  	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
  	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT

Paolo

