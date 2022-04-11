Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962464FBAAD
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 13:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344023AbiDKLSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 07:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238878AbiDKLSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 07:18:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57B3F1A05A
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 04:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649675746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=msXNJ8h0FYhrCrAYwO7HXeuuoij9Poi1tkT6dYtR+PA=;
        b=RA3JnloqGdKbwv0Xqs2Z7mEI5HS6uaD7rBbli3cqVR1Az98BQsFKvK9JSKV8UwWOWZenrt
        YrFmwTAQ3dn6268POpXJragut8zMp5IvgUTU8Dab2R5gxBv55BaRCPaeWkde8Rcu1zo7eO
        ezq56djY24hkXsc/yb0f2MoVmcfnlg0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-cyQHAX1YN6imWV2DL--P_w-1; Mon, 11 Apr 2022 07:15:45 -0400
X-MC-Unique: cyQHAX1YN6imWV2DL--P_w-1
Received: by mail-ed1-f72.google.com with SMTP id w8-20020a50d788000000b00418e6810364so8718727edi.13
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 04:15:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=msXNJ8h0FYhrCrAYwO7HXeuuoij9Poi1tkT6dYtR+PA=;
        b=eXLmJ22S4P5Z2ojqreh9Wd0KVu7avgDleLggzIvLJAh+jlZ7PvhTHis1DcGW0RDwN9
         F5KCAygTFWwlYjJLUcRcRVZSpfomoEXftu/SxzBAfl0iwY5Xd2qjo0fx09arxGu5JRYn
         46zk7Xn9ADp46vi7yaSCofsdXMwS72pSVZtuJN2EOmuMBRAgok79KzzexMAdrQCrfnKd
         cDUxplUQ51cfcbN2rWMgBeFdUp+ixDAeQOE/CYQVBbvEtuLOmf+An8n7iIZvJbv4V+Gq
         HSVcvuxgPCARbojevaEaWRUkT2qiMz7xc0ji0YN+ezUl8gl6O+ItQlekj3d1hPWCde7v
         QxCA==
X-Gm-Message-State: AOAM532IPy4dYcrI4WUbzHfUoAOcNuq2PddDaIDKmPcHCRa2MpXqsoC2
        6eYC3+edCpuRUcsFvFMrUm1T2/YEBJho9+1MaOTl7+8LeiTwJgM6MPZRRAYrn4q88qugXQq8wjT
        FXNj6SiVfkEOt
X-Received: by 2002:a17:907:7810:b0:6e7:ef73:8326 with SMTP id la16-20020a170907781000b006e7ef738326mr28715901ejc.429.1649675743601;
        Mon, 11 Apr 2022 04:15:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6SQkwbzBJ5GEmB126naOTwG4eR/zEXAMc9jswD0Z3i0ETMI1ZnBKUbmI9OlVL/DWbdnUWgg==
X-Received: by 2002:a17:907:7810:b0:6e7:ef73:8326 with SMTP id la16-20020a170907781000b006e7ef738326mr28715849ejc.429.1649675742799;
        Mon, 11 Apr 2022 04:15:42 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id br14-20020a170906d14e00b006e88db05620sm1488070ejb.146.2022.04.11.04.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 04:15:42 -0700 (PDT)
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
In-Reply-To: <Yk8gTB+x2UVE34Ds@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-4-vkuznets@redhat.com>
 <Yk8gTB+x2UVE34Ds@google.com>
Date:   Mon, 11 Apr 2022 13:15:41 +0200
Message-ID: <87h76z7twi.fsf@redhat.com>
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

...

Thanks a lot for the review! I'll incorporate your feedback into v3.

>>  
>>  static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>> @@ -1857,12 +1940,13 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  	struct hv_tlb_flush_ex flush_ex;
>>  	struct hv_tlb_flush flush;
>>  	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
>> +	u64 entries[KVM_HV_TLB_FLUSH_RING_SIZE - 2];
>
> What's up with the -2?

(This should probably be a define or at least a comment somewhere)

Normally, we can only put 'KVM_HV_TLB_FLUSH_RING_SIZE - 1' entries on
the ring as when read_idx == write_idx we percieve this as 'ring is
empty' and not as 'ring is full'. For the TLB flush ring we must always
leave one free entry to put "flush all" request when we run out of
free space to avoid blocking the writer. I.e. when a request flies in,
we check if we have enough space on the ring to put all the entries and
if not, we just put 'flush all' there. In case 'flush all' is already on
the ring, ignoring the request is safe.

So, long story short, there's no point in fetching more than
'KVM_HV_TLB_FLUSH_RING_SIZE - 2' entries from the guest as we can't
possibly put them all on the ring.

[snip]

-- 
Vitaly

