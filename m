Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236E77CAD1F
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbjJPPPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbjJPPPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:15:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FC7F1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697469287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=AVbGnTxHIfBxV5ar+uOFvSn31zZCTLwW6peH+riUAMc=;
        b=i9vxzWj/BmD9035+xZAkBtMkocLzHwTwIsljUbJoC/D+Sxz90oryDNJN/PMrDNu+7jAdxk
        otjigqTryXMkX4rHG3iwNCK+xKO8G4TT0y+NgJKDoydej0FwOEJGFYJVHP47d+UjeYPsaW
        vRYsKQ5EX8oreZRifqliCRVblJfPKeo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-RYLwCDTHOdeA20mKK1kvnw-1; Mon, 16 Oct 2023 11:14:45 -0400
X-MC-Unique: RYLwCDTHOdeA20mKK1kvnw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-99bcb13d8ddso346900366b.0
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:14:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697469284; x=1698074084;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AVbGnTxHIfBxV5ar+uOFvSn31zZCTLwW6peH+riUAMc=;
        b=HZ20g14w7yC0AdoBQAomD/L56jg1ry1DlmERRbLNttEU3lmXuocuhmwy+uEn50BzTe
         BPgnyeX+aEtUN3o+s4+UAf8PbPDqMe7uxobX1pMhEH8fZ3x2kHqA+hbFFsQqvulRGaaR
         avRe8Gm2n5jImf3VIpWJU7gC1NWK+sitfGr+CCu4FgPmJMBvjJ5oYM7fFYaupjFGrpBU
         x4uE4k7VtJgZcqEaAgqaLkphuQfYc+DzM5ovkCAa6ITas5VvFMxp7kqtkqgV5st0xFIV
         JWmSkr5ndsLt1ajuW6lZuLV69mz+Zpuu9ZRxu5Cs5n8v6hSXYgBGzK7n7DN5YMHnIQNR
         H3DA==
X-Gm-Message-State: AOJu0YwfgNvFxWNjKbx+cj2N3SrES1DbXf/JhXbo0yht4PclG8ZBjP1b
        kB6UFKGHM6OltpgTMAqg0/TIgnoxaUAjO7W73MhSIM2fh5PrIeA83mCCxKUdNXrlW4H51L6cqmA
        QXOU2Y5e3/R9l
X-Received: by 2002:a17:906:c10e:b0:9bf:d70b:986d with SMTP id do14-20020a170906c10e00b009bfd70b986dmr3683299ejc.77.1697469284338;
        Mon, 16 Oct 2023 08:14:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHQjVoOl0YMVhdZjG5b09PwEKWF6Tm2BoXsM+VWMJkqKeR48ZJzib+4YYClZrMCFNdROzIVg==
X-Received: by 2002:a17:906:c10e:b0:9bf:d70b:986d with SMTP id do14-20020a170906c10e00b009bfd70b986dmr3683281ejc.77.1697469284015;
        Mon, 16 Oct 2023 08:14:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id vb7-20020a170907d04700b0099ccee57ac2sm4209223ejc.194.2023.10.16.08.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 08:14:42 -0700 (PDT)
Message-ID: <359d7c57-2a71-419d-b63f-4c5610f48b0f@redhat.com>
Date:   Mon, 16 Oct 2023 17:14:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/50] KVM: SVM: INTERCEPT_RDTSCP is never intercepted
 anyway
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, stable@vger.kernel.org
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-2-michael.roth@amd.com>
 <2023101627-species-unscrew-2730@gregkh>
From:   Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <2023101627-species-unscrew-2730@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/23 17:12, Greg KH wrote:
> On Mon, Oct 16, 2023 at 08:27:30AM -0500, Michael Roth wrote:
>> From: Paolo Bonzini <pbonzini@redhat.com>
>>
>> svm_recalc_instruction_intercepts() is always called at least once
>> before the vCPU is started, so the setting or clearing of the RDTSCP
>> intercept can be dropped from the TSC_AUX virtualization support.
>>
>> Extracted from a patch by Tom Lendacky.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> (cherry picked from commit e8d93d5d93f85949e7299be289c6e7e1154b2f78)
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 5 +----
>>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> What stable tree(s) are you wanting this applied to (same for the others
> in this series)?  It's already in the 6.1.56 release, and the Fixes tag
> is for 5.19, so I don't see where it could be missing from?

I tink it's missing in the (destined for 6.7) tree that Michael is 
basing this series on, so he's cherry picking it from Linus's tree.

Paolo

