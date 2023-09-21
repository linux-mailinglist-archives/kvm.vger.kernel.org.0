Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E85C7A9F09
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjIUUQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbjIUUQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:16:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4F23A90
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695317221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ezr0+JdqWLObeUgH87ZU7ZI/AoX/QkG2cOlcCw4fJa4=;
        b=c87VRnF9l5/513PkAAUPLQu2THUKUZ1pdUQsv+/Loce797Gp6yyj/FGbI7LkmtjcIwxBNU
        9x5fuVXalelenTIXNKxIFnRjOaScwI8TLnN8Eyd6Bzaqi0xiuosyplr5zBvDYH/HPy8S1q
        eFtoaCp2nEdFIlhM6XhAs8MBqolJVvE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-nn0akXQSPB-IiG4sHIJsWw-1; Thu, 21 Sep 2023 06:02:36 -0400
X-MC-Unique: nn0akXQSPB-IiG4sHIJsWw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-315af0252c2so504055f8f.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 03:02:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695290555; x=1695895355;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ezr0+JdqWLObeUgH87ZU7ZI/AoX/QkG2cOlcCw4fJa4=;
        b=g8PYAiVcpJAxapsiKEZ8xSsoQRQ+1gV4tGZW4SpjDKPGK1zFmAwKrcRkG7Y/0O5QRq
         Sgv/VHRvNkNaRvYsZ5+sTsnrFnXmI4VcXFkXEPX8O9XpMb1Q2b0h92rJv8NRaXPp1fJk
         OTfQ/n7BUQxYKb+GUDvdgIn2TuedPoB+obgcpywQudsKa9qmArt42esMSNNm8u3W1qbx
         iuWGPxU4+3zCNQ2cjFNYuyIfpqypCC9QoHQnd4keodadjCuNfNhuL7MFGEB0uPUpCoIV
         f+UyNNxsas1HqnjGl5xI2htxYhsQfsU4MX/1LpCC9D1warS0JAiTGt3BS4bgxi1KepRQ
         CYIw==
X-Gm-Message-State: AOJu0YzV0k0I5XEx0C5DeNecQ4UuT5LNufVMGXZycRL9SFmFuW9hsuG/
        mvBBFIQBMsVlDoGUXFcQUJ0vKctl83gcuyBuYd81mzHzXkrXciGsUhLahKk3MZk1Ma6oOA0FR7I
        ub2f7o4ViIaTd
X-Received: by 2002:a5d:4fcd:0:b0:319:6327:6adb with SMTP id h13-20020a5d4fcd000000b0031963276adbmr4150487wrw.70.1695290555393;
        Thu, 21 Sep 2023 03:02:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKn3U8phEp2lRVhfBVwCapzkAkvov2pptdEyYRJgbLZYSOWwWAIC6sYPl2VmGkNW3jTQt3ew==
X-Received: by 2002:a5d:4fcd:0:b0:319:6327:6adb with SMTP id h13-20020a5d4fcd000000b0031963276adbmr4150457wrw.70.1695290555045;
        Thu, 21 Sep 2023 03:02:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id p5-20020a5d4585000000b0031ad5470f89sm1311972wrq.18.2023.09.21.03.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 03:02:34 -0700 (PDT)
Message-ID: <9ebf281f-7379-ba37-2867-8918da813c19@redhat.com>
Date:   Thu, 21 Sep 2023 12:02:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>
References: <20230916003916.2545000-1-seanjc@google.com>
 <20230916003916.2545000-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: Stop zapping invalidated TDP MMU roots
 asynchronously
In-Reply-To: <20230916003916.2545000-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/16/23 02:39, Sean Christopherson wrote:
> +		if (!root->tdp_mmu_scheduled_root_to_zap)
> +			continue;
> +
> +		root->tdp_mmu_scheduled_root_to_zap = false;

This is protected by slots_lock... tricky.

Worth squashing in a comment and also a small update to another comment:

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 93b9d50c24ad..decc1f153669 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -60,6 +60,8 @@ struct kvm_mmu_page {
  	bool unsync;
  	union {
  		u8 mmu_valid_gen;
+
+		/* Only accessed under slots_lock.  */
  		bool tdp_mmu_scheduled_root_to_zap;
  	};
  
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ca3304c2c00c..070ee5b2c271 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -246,7 +246,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
  	 * by a memslot update or by the destruction of the VM.  Initialize the
  	 * refcount to two; one reference for the vCPU, and one reference for
  	 * the TDP MMU itself, which is held until the root is invalidated and
-	 * is ultimately put by tdp_mmu_zap_root_work().
+	 * is ultimately put by kvm_tdp_mmu_zap_invalidated_roots().
  	 */
  	refcount_set(&root->tdp_mmu_root_count, 2);
  

Paolo

> +		KVM_BUG_ON(!root->role.invalid, kvm);

