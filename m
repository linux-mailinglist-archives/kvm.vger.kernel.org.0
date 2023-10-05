Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216287BA353
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 17:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbjJEPx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 11:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbjJEPvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 11:51:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD033F00A
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 07:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696514416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/r6/vxDZ7SlHr2MUNh2FMyN5pOqeM6f7KWklCXeGbBg=;
        b=hQxz9iUoKr24M6Pziq/5HfgHT1KWoefDsfpw7MbK+M+A2tOPoWE4x+j1OOE9HW5nl6xraO
        rFAfsnPcdsMMF4rs1PDav7ybDb61hBdXYycB9TP8RCwwhzkD+pSkWE8BMP+z1Kp7/okDyW
        JwgZ4ixzUPONA4iEQ5Bu1qpbzFLoPXY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-iWfQOb7eO9GX9r1Nf5ePLw-1; Thu, 05 Oct 2023 08:58:33 -0400
X-MC-Unique: iWfQOb7eO9GX9r1Nf5ePLw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4065478afd3so6112955e9.0
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 05:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696510712; x=1697115512;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/r6/vxDZ7SlHr2MUNh2FMyN5pOqeM6f7KWklCXeGbBg=;
        b=NMv/fM48khnc1aTUpdHsvP+OaMgxLpuUsnAswYPlsSvaPj0gP9idOVizrvv+pa3OpZ
         bslPTdJiHe7DV9z4mOOrYQU5nRmAfz0A+5M2nOnJpKuve06WdiAVHzXyTO+fFwCS/VTs
         4HUuTy+MF4dbAbVkWNFDLzGbqCjQ9T2mppnMVWNhPB55sLLzkWOhCjjQNRXD+Mi5u5J9
         MnfnE6O8OndxtpZm8Uap6/weR5uOvSUOhQ3nefTXihEzwj54Pi7BoSzRXTYbn1rhL8Z9
         lHXIae8tCO/sGBWIumGqjJDDcu5k99KKYEcvkmaWNULY/WyAjyF9C0TtCsCehKmWo0xM
         gdUQ==
X-Gm-Message-State: AOJu0YwQkXljW8wX7EXHegmC8ku6VZzXSLJGIIQXthRN1pqULhQHSgSr
        HvLLQ54VdjMHgxR7AuqgaNY96uYE/ePoTzQAcwXBTkIXFa0Y5t+laQlmviXCywTi/FygIPdS4a7
        f/zqeoVu2Evn5
X-Received: by 2002:a1c:7914:0:b0:401:1b58:72f7 with SMTP id l20-20020a1c7914000000b004011b5872f7mr4896060wme.38.1696510712648;
        Thu, 05 Oct 2023 05:58:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7lzNVbgVxPFaaWui24YMcE2z6WO73JBOPVtj5jYlX2YjQWj64rpJKORnSmCPW9jT0XGo+RA==
X-Received: by 2002:a1c:7914:0:b0:401:1b58:72f7 with SMTP id l20-20020a1c7914000000b004011b5872f7mr4896043wme.38.1696510712176;
        Thu, 05 Oct 2023 05:58:32 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id y24-20020a7bcd98000000b004064741f855sm1453766wmj.47.2023.10.05.05.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 05:58:31 -0700 (PDT)
Message-ID: <b61bcea5033edfbc558637edb6cb3bbf690b3cf6.camel@redhat.com>
Subject: Re: [PATCH 09/10] KVM: SVM: Drop redundant check in AVIC code on ID
 during vCPU creation
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Thu, 05 Oct 2023 15:58:30 +0300
In-Reply-To: <20230815213533.548732-10-seanjc@google.com>
References: <20230815213533.548732-1-seanjc@google.com>
         <20230815213533.548732-10-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-08-15 у 14:35 -0700, Sean Christopherson пише:
> Drop avic_get_physical_id_entry()'s compatibility check on the incoming
> ID, as its sole caller, avic_init_backing_page(), performs the exact same
> check.  Drop avic_get_physical_id_entry() entirely as the only remaining
> functionality is getting the address of the Physical ID table, and
> accessing the array without an immediate bounds check is kludgy.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 28 ++++++----------------------
>  1 file changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 3b2d00d9ca9b..6803e2d7bc22 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -263,26 +263,12 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
>  		avic_deactivate_vmcb(svm);
>  }
>  
> -static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
> -				       unsigned int index)
> -{
> -	u64 *avic_physical_id_table;
> -	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
> -
> -	if ((!x2avic_enabled && index > AVIC_MAX_PHYSICAL_ID) ||
> -	    (index > X2AVIC_MAX_PHYSICAL_ID))
> -		return NULL;

While removing this code doesn't introduce a bug, it does make it less safe,
because new code just blindly trusts that vcpu_id will never be out of bounds
of the physical id table.

Bugs happen and that can and will someday happen.

> -
> -	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
> -
> -	return &avic_physical_id_table[index];
> -}
> -
>  static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  {
> -	u64 *entry, new_entry;
> +	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	u64 *table, new_entry;
>  	int id = vcpu->vcpu_id;
> -	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	/*
>  	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
> @@ -318,15 +304,13 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	}
>  
>  	/* Setting AVIC backing page address in the phy APIC ID table */
> -	entry = avic_get_physical_id_entry(vcpu, id);
> -	if (!entry)
> -		return -EINVAL;
> +	table = page_address(kvm_svm->avic_physical_id_table_page);
>  
>  	new_entry = avic_get_backing_page_address(svm) |
>  		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
> -	WRITE_ONCE(*entry, new_entry);

Here I prefer to at least have an assert that id is in bounds of a page 
(at least less than 512) so that a bug will not turn into a security
issue by overflowing the buffer.

> +	WRITE_ONCE(table[id], new_entry);
>  
> -	svm->avic_physical_id_cache = entry;
> +	svm->avic_physical_id_cache = &table[id];
>  
>  	return 0;
>  }

Best regards,
	Maxim Levitsky

