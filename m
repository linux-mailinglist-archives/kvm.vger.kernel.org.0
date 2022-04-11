Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075DB4FBAF6
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 13:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345602AbiDKLeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 07:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbiDKLeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 07:34:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD5E945780
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 04:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649676715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hB2hBk95GTkWXMWBYfLe3bO1rW/niBCYyxXv9FcMLps=;
        b=AAD615L5JqjNl8Fc+orqzaUyYYkimfhgQ3aGDAh+fqCB2bgAKhYEMyGhJe0IpvFJ89W8VD
        IRBsQ2JYT+bgmIusaGAsv25/3IJNTbbXsV2m5pF7BeZ+/z3i86/LOjPJ8zhLigDdaWYMyq
        aOZMkjQRks+9YW7t+NyJ3WBdLbRaHiM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-78wmSxTbNKOgfO7P1nZ-Qg-1; Mon, 11 Apr 2022 07:31:54 -0400
X-MC-Unique: 78wmSxTbNKOgfO7P1nZ-Qg-1
Received: by mail-ed1-f70.google.com with SMTP id dn26-20020a05640222fa00b0041d85c7a190so530727edb.22
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 04:31:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hB2hBk95GTkWXMWBYfLe3bO1rW/niBCYyxXv9FcMLps=;
        b=5snN0pNaVaegB+MoHT1N4yYhdI8qtRew+uA8WjxEnWqRV0gUCQ+3vJFdaG3WR6uGWy
         uo30m7rGodHXNajXZPZqXGR23sdBrwp2P/i91QHiAwLnSRZqFK3k/4q0ds9RSfEju8H1
         JO+sqjyxwFHSyC08j/GmEQKEE6AOo+c+lzQ9Ht6JI0w9PDhgDZmWd/iVIGUTFBrCY7Y/
         ziANYMedW6oZXGfZWClJp4VzmWthh+NOLgL32uLX0Sgw4nHYH8lz5OxVpn0WbnEXLstm
         9UPnxVNL9HkncDESJ/er54Wsa+u4cd9w0Hva+NwwIeFdnf61myL9lkSpV52lCfwkRWxY
         tahw==
X-Gm-Message-State: AOAM533BMwdi2n54X06HskepOPA9u/sjH/ZiMPRbvDSwWTbVrKitWP9H
        WI3xi8/2aAmFjykE6pzsW4Rc3USIUH17+YQZ1SSz/9/aaDANpSEHbykURQKVQLGe09NU+pfx3q0
        izOSSMbTlrROB
X-Received: by 2002:aa7:c948:0:b0:413:2bed:e82e with SMTP id h8-20020aa7c948000000b004132bede82emr32743227edt.394.1649676713597;
        Mon, 11 Apr 2022 04:31:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRSkg+D2Qohm3XJcdcxQKbivWModYJTLdUFZ1km//AwjiyajbUyfLCHY00UUBkuk9sIdVnVw==
X-Received: by 2002:aa7:c948:0:b0:413:2bed:e82e with SMTP id h8-20020aa7c948000000b004132bede82emr32743200edt.394.1649676713338;
        Mon, 11 Apr 2022 04:31:53 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z11-20020a50e68b000000b00412ec8b2180sm14959305edm.90.2022.04.11.04.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 04:31:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/31] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
In-Reply-To: <Yk8i+A3E9/JL96A2@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-4-vkuznets@redhat.com>
 <Yk8i+A3E9/JL96A2@google.com>
Date:   Mon, 11 Apr 2022 13:31:51 +0200
Message-ID: <87a6cr7t5k.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
>> @@ -1840,15 +1891,47 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
>>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>> -
>> -	kvm_vcpu_flush_tlb_guest(vcpu);
>> -
>> -	if (!hv_vcpu)
>> +	struct kvm_vcpu_hv_tlbflush_entry *entry;
>> +	int read_idx, write_idx;
>> +	u64 address;
>> +	u32 count;
>> +	int i, j;
>> +
>> +	if (!tdp_enabled || !hv_vcpu) {
>> +		kvm_vcpu_flush_tlb_guest(vcpu);
>>  		return;
>> +	}
>>  
>>  	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
>> +	read_idx = READ_ONCE(tlb_flush_ring->read_idx);
>> +	write_idx = READ_ONCE(tlb_flush_ring->write_idx);
>> +
>> +	/* Pairs with smp_wmb() in hv_tlb_flush_ring_enqueue() */
>> +	smp_rmb();
>>  
>> -	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
>> +	for (i = read_idx; i != write_idx; i = (i + 1) % KVM_HV_TLB_FLUSH_RING_SIZE) {
>> +		entry = &tlb_flush_ring->entries[i];
>> +
>> +		if (entry->flush_all)
>> +			goto out_flush_all;
>> +
>> +		/*
>> +		 * Lower 12 bits of 'address' encode the number of additional
>> +		 * pages to flush.
>> +		 */
>> +		address = entry->addr & PAGE_MASK;
>> +		count = (entry->addr & ~PAGE_MASK) + 1;
>> +		for (j = 0; j < count; j++)
>> +			static_call(kvm_x86_flush_tlb_gva)(vcpu, address + j * PAGE_SIZE);
>> +	}
>> +	++vcpu->stat.tlb_flush;
>> +	goto out_empty_ring;
>> +
>> +out_flush_all:
>> +	kvm_vcpu_flush_tlb_guest(vcpu);
>> +
>> +out_empty_ring:
>> +	tlb_flush_ring->read_idx = write_idx;
>
> Does this need WRITE_ONCE?  My usual "I suck at memory ordering" disclaimer applies.
>

Same here) I *think* we're fine for 'read_idx' as it shouldn't matter at
which point in this function 'tlb_flush_ring->read_idx' gets modified
(relative to other things, e.g. actual TLB flushes) and there's no
concurency as we only have one reader (the vCPU which needs its TLB
flushed). On the other hand, I'm not against adding WRITE_ONCE() here
even if just to aid an unprepared reader (thinking myself couple years
in the future).

-- 
Vitaly

