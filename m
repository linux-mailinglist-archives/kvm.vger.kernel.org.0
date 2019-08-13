Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4AC8C36A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 23:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfHMVPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 17:15:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46919 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbfHMVPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 17:15:41 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so109086069wru.13
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 14:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rjIDCcvAVlmERsdH1YwtAmHf7AZyVkj5Bqg0BqDH0Pk=;
        b=nKmsyLyQunyJZj9FAaT6Bn2J7U9YTK7irTY4Esig5uw/ZmAEXWzXp3/8i5aL3bTgpT
         iCq1mRYqOO2uKkZud/lM8ZoqbIqRfl1Mrd8rvgTSUcdPfaN2GYoKYjsA6MyQzzjayrpA
         2KGC+McC5cVIIsYAcF+jmtc6H2g/9rBSGtDrU1VlqIPNFPtq/XlRsQlUd3vcIqBxT0fF
         b81ELu8zzFllhKf83ulG1p0htIf4+V5fBtPVh/ICvImo8mioaWC9Faom9OHxQBk7tnj/
         l98QyBd/CrYgwAeKqemum/6B3sm8mv83pgb0erbHKV/xKHulIl9aGGxMlY9BUKrpYvE3
         DqUA==
X-Gm-Message-State: APjAAAWlOn2DVkU49Fw093qmAxEN9TmgTdCcZRRlGrqxKw9+r3zWAEzt
        LDSsTQ/8XA45/QkOkTuVAC4VSA==
X-Google-Smtp-Source: APXvYqyBUcDV5nU2dEtiXaAOxFc7iFczJJcbg+3/vSUJtwbbQnYeBWOprX539DPHbxrYh3eTGM236w==
X-Received: by 2002:adf:fc87:: with SMTP id g7mr43915503wrr.319.1565730939289;
        Tue, 13 Aug 2019 14:15:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5193:b12b:f4df:deb6? ([2001:b07:6468:f312:5193:b12b:f4df:deb6])
        by smtp.gmail.com with ESMTPSA id f18sm6056529wrx.85.2019.08.13.14.15.38
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 14:15:38 -0700 (PDT)
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home> <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home> <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
 <cd9e5c9d-a321-b2f3-608d-0b8f74a5075f@redhat.com>
 <20190813151417.2cf979ca@x1.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f8119b68-bf75-9e01-e799-0c1cf965ba83@redhat.com>
Date:   Tue, 13 Aug 2019 23:15:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813151417.2cf979ca@x1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/19 23:14, Alex Williamson wrote:
>> Do we even need the call to slot_handle_all_level?  The rmap update
>> should be done already by kvm_mmu_prepare_zap_page (via
>> kvm_mmu_page_unlink_children -> mmu_page_zap_pte -> drop_spte).
>>
>> Alex, can you replace it with just "flush = false;"?
> Replace the continue w/ flush = false?  I'm not clear on this
> suggestion.  Thanks,

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24843cf49579..382b3ee303e3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5664,7 +5668,7 @@ kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm
 	if (list_empty(&kvm->arch.active_mmu_pages))
 		goto out_unlock;

-	flush = slot_handle_all_level(kvm, slot, kvm_zap_rmapp, false);
+	flush = false;

 	for (i = 0; i < slot->npages; i++) {
 		gfn = slot->base_gfn + i;

