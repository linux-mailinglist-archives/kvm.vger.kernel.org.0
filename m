Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836D56BBCF9
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 20:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbjCOTJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 15:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjCOTJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 15:09:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F4437F28
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 12:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678907294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDfDh2cy0uEyhBzmOewe66tnp7n0b3+0oI8Eeui2sqM=;
        b=GDU1XCOJ1jdZE7uVYCZmUA0Gd+eg64NkFRn17vKN4tGaTgkOfLeQMrbTm9X9eUQOyriN6b
        2FjhD/8QTzoZ1dvDrlDvQv6I/iV7iHErsmMLB7bmaVZ8CUw/y1w7etc4w9CDl74mTAMVEp
        /cccCIGsSLpPwt1FwEBLmiY/FZL/AJA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-wME-Lc4KMlO_7No-b-Spxg-1; Wed, 15 Mar 2023 15:08:12 -0400
X-MC-Unique: wME-Lc4KMlO_7No-b-Spxg-1
Received: by mail-wm1-f72.google.com with SMTP id o31-20020a05600c511f00b003ed2ed2acb5so1427575wms.0
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 12:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678907290;
        h=content-transfer-encoding:in-reply-to:subject:content-language
         :references:cc:to:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QDfDh2cy0uEyhBzmOewe66tnp7n0b3+0oI8Eeui2sqM=;
        b=NH1VJ91x29C2AjiPJVW3y20xDB9Ke8ofrgQ8i8dlgLpbSG1Rx72TUxEVjrqup6A8H9
         EqAm3MkdVayFe5zN8M5jDXL5+aaEEEMfHKTP7QtjdHUrfZNQAlMOGG735H6fnh2uIC0p
         fkbrcOYQq/lyKmCJSsGZ7+OEjPuFCT/bjBdejmUxdVH1+kxir4VTyNdQ6yrK1kt+klxT
         tg1cjUirPEcTMaKpExrz56IcZ3kbBGqtt2VBdULZaOSdamYd9UR/QgQko+kUUNH2EiMI
         0F9hjYFB0/TT8DT0gj+6oBFwHl//kWVydFn2a3berIOvDeQbzHWVdsjUHnwfEuEi/gtH
         58rw==
X-Gm-Message-State: AO0yUKUNAGZx4qQ8Q8a9sZuYhKSTozHMtX6b3xAF8S4VCKwrKuto4FM+
        wRJl5bXZ7oym1MGJTgD6gKEdot/kdR/3J6U4tkQ4WuVI+BJlU5OuPwn+t8KorP0j6Ut2h0Uliqr
        QM+2oQdZXQvML5d06fr1YE4g=
X-Received: by 2002:adf:e707:0:b0:2ce:a162:784c with SMTP id c7-20020adfe707000000b002cea162784cmr2679030wrm.65.1678907290695;
        Wed, 15 Mar 2023 12:08:10 -0700 (PDT)
X-Google-Smtp-Source: AK7set/AhZev74OXLPPPCE+9ijEjgg7iDe9+PuA9nmX+Ofo+KtDhLUC+wRe0UY+zUwCKZWvXe363tA==
X-Received: by 2002:adf:e707:0:b0:2ce:a162:784c with SMTP id c7-20020adfe707000000b002cea162784cmr2679021wrm.65.1678907290420;
        Wed, 15 Mar 2023 12:08:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id e25-20020a5d5959000000b002c8ed82c56csm5222780wri.116.2023.03.15.12.08.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 12:08:09 -0700 (PDT)
Message-ID: <199f404d-c08e-3895-6ce3-36b21514f487@redhat.com>
Date:   Wed, 15 Mar 2023 20:08:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>
References: <20230131181820.179033-1-bgardon@google.com>
 <CABgObfaP7P7fk66-EGF-zPEk0H14u3YkM42FRXrEvU=hwFSYgg@mail.gmail.com>
 <CABgObfYAStAC5FgJfGUiJ=BBFtN7drD+NGHLFJY5fP3hQzVOBw@mail.gmail.com>
 <CALzav=c-wtJiz9M6hpPtcoBMFvFP5_2BNYoY66NzF-J+8_W6NA@mail.gmail.com>
 <CABgObfYm6roWVR0myT5rHUWRe7k09TkXgZ7rYAr019QZ80oQXQ@mail.gmail.com>
Content-Language: en-US
Subject: Re: [PATCH V5 0/2] selftests: KVM: Add a test for eager page
 splitting
In-Reply-To: <CABgObfYm6roWVR0myT5rHUWRe7k09TkXgZ7rYAr019QZ80oQXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/23 13:24, Paolo Bonzini wrote:
> On Tue, Mar 14, 2023 at 5:00 PM David Matlack <dmatlack@google.com> wrote:
>> I wonder if pages are getting swapped, especially if running on a
>> workstation. If so, mlock()ing all guest memory VMAs might be
>> necessary to be able to assert exact page counts.
> 
> I don't think so, it's 100% reproducible and the machine is idle and
> only accessed via network. Also has 64 GB of RAM. :)

It also reproduces on Intel with pml=0 and eptad=0; the reason is due
to the different semantics of dirty bits for page-table pages on AMD
and Intel.  Both AMD and eptad=0 Intel treat those as writes, therefore
more pages are dropped before the repopulation phase when dirty logging
is disabled.

The "missing" page had been included in the population phase because it
hosts the page tables for vcpu_args, but repopulation does not need it.

This fixes it:

-------------------- 8< ---------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] selftests: KVM: perform the same memory accesses on every memstress iteration

Perform the same memory accesses including the initialization steps
that read from args and vcpu_args.  This ensures that the state of
KVM's page tables is the same after every iteration, including the
pages that host the guest page tables for args and vcpu_args.

This fixes a failure of dirty_log_page_splitting_test on AMD machines,
as well as on Intel if PML and EPT A/D bits are both disabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 3632956c6bcf..8a429f4c86db 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -56,15 +56,15 @@ void memstress_guest_code(uint32_t vcpu_idx)
  	uint64_t page;
  	int i;
  
-	rand_state = new_guest_random_state(args->random_seed + vcpu_idx);
+	while (true) {
+		rand_state = new_guest_random_state(args->random_seed + vcpu_idx);
  
-	gva = vcpu_args->gva;
-	pages = vcpu_args->pages;
+		gva = vcpu_args->gva;
+		pages = vcpu_args->pages;
  
-	/* Make sure vCPU args data structure is not corrupt. */
-	GUEST_ASSERT(vcpu_args->vcpu_idx == vcpu_idx);
+		/* Make sure vCPU args data structure is not corrupt. */
+		GUEST_ASSERT(vcpu_args->vcpu_idx == vcpu_idx);
  
-	while (true) {
  		for (i = 0; i < pages; i++) {
  			if (args->random_access)
  				page = guest_random_u32(&rand_state) % pages;

Paolo

