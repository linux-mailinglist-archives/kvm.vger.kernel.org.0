Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E7B16671E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 20:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgBTT2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 14:28:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54734 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728334AbgBTT2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 14:28:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582226894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NzJcgT/Rs34RnqwLmlFHqcq1uzgSsfmkFX7qWT1GT30=;
        b=GiCqlCF67KmYFa7ypfdgquHyMlrwZd5BmR5c+IJ9j9Ez7SuOCuy+GjWMMibYSa9ZoHyBgB
        /+4AsoBZxUC+IP8hTfhYt2XwYyoe13UchhyZayWhzupRO574r2cru8L8trfuxlvYY2/YBJ
        o/v7DNnurYBYjmmVhYkQcqmDXlTWqKM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-4uR_z_XuOJCdMK30RlFc8g-1; Thu, 20 Feb 2020 14:28:12 -0500
X-MC-Unique: 4uR_z_XuOJCdMK30RlFc8g-1
Received: by mail-qk1-f198.google.com with SMTP id n126so3454006qkc.18
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 11:28:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NzJcgT/Rs34RnqwLmlFHqcq1uzgSsfmkFX7qWT1GT30=;
        b=HpD9z/AvwKAzFdzSSW8S9bAeUrv4DpyJB8I7l7mUupqJqU4WctQh2AzKW7pVeq3JyV
         gatOHRR6+/4nLL2z4ollVNVAgc+vTBgHYfsv4mFJZZETyQoCEARSb//+IsKN4UY5SHNm
         4T81XfMS65qrP7kb78fGiZbS6cV4YjDTsNx2trud4Kh6b71piHx188TepMNOd0P0oW7y
         vqc6rkAGgaUHGvKlmgLOlUKml0+Tt0zzTkU6XUnCyvqU7GS8/Hlhv/11Aqdgry1qt7Gp
         +aAA/JXQm038u3oSRMX22X/DcmcfPBNhtacUXOfSAd0xAWLpH6dcZSL5ampcnWhl/hyP
         mZng==
X-Gm-Message-State: APjAAAVycLpNbrCBznBTzh3RsdvdvGbI5SnzjGkbHiuIWJkwhW63W5ek
        Aah2OWy8De9DIIwqVaJwnYjdcUY798F23RM3Mb4MUM2u4Ch7dLHYobFEE2TzCqtn9KYK3tkpIO+
        I13eXoVIZx/wO
X-Received: by 2002:ac8:51d7:: with SMTP id d23mr27928507qtn.139.1582226891570;
        Thu, 20 Feb 2020 11:28:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqxpILtFi0YN3AdElXg3COr9d3QAyQ82hW3+8ktd/AN9MB0ijTUsf9f5uw2VeKAjFORrsU6csw==
X-Received: by 2002:ac8:51d7:: with SMTP id d23mr27928488qtn.139.1582226891372;
        Thu, 20 Feb 2020 11:28:11 -0800 (PST)
Received: from xz-x1 ([104.156.64.75])
        by smtp.gmail.com with ESMTPSA id u12sm297072qke.67.2020.02.20.11.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 11:28:10 -0800 (PST)
Date:   Thu, 20 Feb 2020 14:28:09 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jay Zhou <jianjay.zhou@huawei.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        wangxinxin.wang@huawei.com, weidong.huang@huawei.com,
        sean.j.christopherson@intel.com, liu.jinsong@huawei.com
Subject: Re: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200220192809.GA15253@xz-x1>
References: <20200220042828.27464-1-jianjay.zhou@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200220042828.27464-1-jianjay.zhou@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 12:28:28PM +0800, Jay Zhou wrote:
> @@ -5865,8 +5865,12 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  	bool flush;
>  
>  	spin_lock(&kvm->mmu_lock);
> -	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
> -				      false);
> +	if (kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET)
> +		flush = slot_handle_large_level(kvm, memslot,
> +						slot_rmap_write_protect, false);
> +	else
> +		flush = slot_handle_all_level(kvm, memslot,
> +						slot_rmap_write_protect, false);

Another extra comment:

I think we should still keep the old behavior for KVM_MEM_READONLY (in
kvm_mmu_slot_apply_flags())) for this...  Say, instead of doing this,
maybe we want kvm_mmu_slot_remove_write_access() to take a new
parameter to decide to which level we do the wr-protect.

Thanks,

>  	spin_unlock(&kvm->mmu_lock);
>  
>  	/*

-- 
Peter Xu

