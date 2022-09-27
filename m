Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0CC5EC222
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 14:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiI0MNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 08:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiI0MNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 08:13:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA88AB1B5
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 05:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664280794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vYau3oORiMNyBrvVH7UDB5CsI1W1nZ38yRKzoJl4tIg=;
        b=OoXtha6Rl0Pcah4Q0eHHBaYE1v8KQQ09dUv9dw+KzKPBQtH4ZOMf+Pder4OZXqKsFyqBQ8
        IpQBd0Gq8CY36DSyk1aIMy+7+f713937oSxT4rlwz3PdKQHYME55rcVsTbCPh6od8mUlgb
        /PSnZGwnQ19STfCZc6Cwsd56MzahNzg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-163-evdZGeCFN7Sn8kQAHkNfHA-1; Tue, 27 Sep 2022 08:13:13 -0400
X-MC-Unique: evdZGeCFN7Sn8kQAHkNfHA-1
Received: by mail-ed1-f72.google.com with SMTP id i17-20020a05640242d100b0044f18a5379aso7757957edc.21
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 05:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=vYau3oORiMNyBrvVH7UDB5CsI1W1nZ38yRKzoJl4tIg=;
        b=mB25qPVu4KB6YYbpY//w3LwLKmdzFASsM2iaDCzV8uf/Ijm/G95eg1LphX8eZcRvmU
         ShArJ8iiVdeRhDHGwFkl1QC1kv2ZsZyN5PLLbz3uF3v2fbS9EEW5Smhtg5Zi+m9ufzqG
         t9ecn9c7oZls1S64D3819yL0xyOhNjLyBazTQQWUfzoXNMgSJEu4AAMR8xNXOqgUzheE
         hN1BuuZUzBNALcHJdhtXj7c6wVW/KZ1/4RDGtwCY3XxrobNofWoNYy3ydfw2yrnMKYoa
         MTITKYUvI6RnZqFq3CTYf5JeieOtJnHnTFPR1M0pyj8eyuU3NdQjgbW4q/X0eSieMp+m
         /Evw==
X-Gm-Message-State: ACrzQf02gP9hriMPhVNm1ezyVl3ez0El34XxInS6CnFXUNRIk52MQD4O
        E6lAd/4PfEaAz535wkofiHvJlzQZrcVC/rvnsSsqVRbC86j3yDJ/kYkprSlw0rBoSb+4AFdyi9R
        Yx8Ay35Gfkyr5
X-Received: by 2002:a17:907:7206:b0:783:1d78:6249 with SMTP id dr6-20020a170907720600b007831d786249mr12227812ejc.9.1664280792586;
        Tue, 27 Sep 2022 05:13:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7xr33At7nySVsumCJLy3ZTO2bLFK77gRRz4aquaieSslpOcx8N1C9Wt7hZ1af4e78H4agGvA==
X-Received: by 2002:a17:907:7206:b0:783:1d78:6249 with SMTP id dr6-20020a170907720600b007831d786249mr12227795ejc.9.1664280792264;
        Tue, 27 Sep 2022 05:13:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id y15-20020a50bb0f000000b0043bbb3535d6sm1144104ede.66.2022.09.27.05.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 05:13:11 -0700 (PDT)
Message-ID: <d0fc4ef7-6e7c-3734-225b-411c57b4acaa@redhat.com>
Date:   Tue, 27 Sep 2022 14:13:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: selftests: Fix nx_huge_pages_test on TDP-disabled
 hosts
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Xu <peterx@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
References: <20220926175219.605113-1-dmatlack@google.com>
 <YzIlxmMOeSZHsnOu@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YzIlxmMOeSZHsnOu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/22 00:20, Sean Christopherson wrote:
> void __virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> 		uint64_t nr_bytes, size_t page_size)
> {
> 	uint64_t nr_pages = DIV_ROUND_UP(nr_bytes, page_size);
> 
> 	TEST_ASSERT(vaddr + size > vaddr, "Vaddr overflow");
> 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
> 
> 	while (npages--) {
> 		virt_pg_map(vm, vaddr, paddr);
> 		vaddr += page_size;
> 		paddr += page_size;
> 	}
> }
> 
> void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> 	      uint64_t nr_bytes)
> {
> 	__virt_map(vm, vaddr, paddr, nr_bytes, vm->page_size);
> }

I would just keep nr_pages in virt_map to begin with, for the sake of 
this patch.  Changing virt_map can be done later (and should be separate 
anyway).

>> -	virt_map(vm, HPAGE_GVA, HPAGE_GPA, HPAGE_SLOT_NPAGES);
>> +	/*
>> +	 * Use 2MiB virtual mappings so that KVM can map the region with huge
>> +	 * pages even if TDP is disabled.
>> +	 */
>> +	virt_map_2m(vm, HPAGE_GVA, HPAGE_GPA, HPAGE_SLOT_2MB_PAGES);
> 
> Hmm, what about probing TDP support and deliberately using 4KiB pages when TDP is
> enabled?  That would give a bit of bonus coverage by verifying that KVM creates
> huge pages irrespective of guest mapping level.

Nice idea indeed.

Paolo

