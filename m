Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DFE52519F
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 17:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356124AbiELPvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 11:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353380AbiELPu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 11:50:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6216F1C5E1D
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 08:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652370654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pKT3YUr9qUs5uIKesgT4K81uwyX4AaWN4Ut0eYxyI8g=;
        b=RCo2zMXITe136qThmUio30+rxlhQBbyOXY8N7zxLW1vDDW8Tf+2AfY+HxbIbaN2WTGfW7r
        rwGq2ZmgraKc/sqkay8oFc9hu9csP29kxPBEBizO8cR7IDTvBIBOQBESnBVdb2Ew6oFMmP
        CHooTxUB1ejkvIFNA41GFR0nQTQp8LM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-b6CnZ6RhO_mDYlELNunNoA-1; Thu, 12 May 2022 11:50:53 -0400
X-MC-Unique: b6CnZ6RhO_mDYlELNunNoA-1
Received: by mail-wm1-f70.google.com with SMTP id g14-20020a1c4e0e000000b0039425ef54d6so1830874wmh.9
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 08:50:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=pKT3YUr9qUs5uIKesgT4K81uwyX4AaWN4Ut0eYxyI8g=;
        b=cBwdxvd49vjQc3XCd4A4bPwPbNCz73funy9VySBHE9pUzrucK+jzdzyrbwJXCPyJ3y
         HhewBxMGyp40afnFCOcxz3Wvdm7nIUpaJxPmDhdZQ+uR/FGTM+vjy/0pnXXrG+w9umiX
         zbARjcvQiAEq765GQvhLJoeHyUEmovdEgs6zSqOV7fqcN7cMTWARHvVTEDTtBD2UvR4Q
         cX5uugGoID1LftQT2W9grpQwcOPFM1li2eDM2yO/O6krLvv/bB1Cq5gy/VBHB4Ow5Jgx
         iEIiqoppDQfOQZziSQzbg98NxnaPA42xPlIpF1n/b+lniIlEGuvkEEYNmd08QAxs4nN/
         uxmA==
X-Gm-Message-State: AOAM531WKwuZUhPjFYeEYcPRF7Yfwbkss/fkGDvwlRcl6FrpwKo84XE+
        RmUWaWLB2YvxnUX/7vwMV9jbhavuoFPDbPgKx7yQAlLC1l7mTS4wIwRfaevmrZMnmrMeJk8RAXC
        SGhra1Mxy4oH0
X-Received: by 2002:a05:600c:a06:b0:394:8d3d:de68 with SMTP id z6-20020a05600c0a0600b003948d3dde68mr11078930wmp.18.1652370652075;
        Thu, 12 May 2022 08:50:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIN0NA8Y2YcEbBfem6veLZyH1QzXV7Mghh/dOvzBeccdoKM7ALnBl/DCn2JQvy+04QGx97/Q==
X-Received: by 2002:a05:600c:a06:b0:394:8d3d:de68 with SMTP id z6-20020a05600c0a0600b003948d3dde68mr11078905wmp.18.1652370651822;
        Thu, 12 May 2022 08:50:51 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:d200:ee5d:1275:f171:136d? (p200300cbc701d200ee5d1275f171136d.dip0.t-ipconnect.de. [2003:cb:c701:d200:ee5d:1275:f171:136d])
        by smtp.gmail.com with ESMTPSA id d13-20020a5d4f8d000000b0020c5253d911sm4326778wru.93.2022.05.12.08.50.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 08:50:51 -0700 (PDT)
Message-ID: <701033df-49c5-987e-b316-40835ad83d16@redhat.com>
Date:   Thu, 12 May 2022 17:50:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 1/2] KVM: s390: Don't indicate suppression on dirtying,
 failing memop
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220512131019.2594948-1-scgl@linux.ibm.com>
 <20220512131019.2594948-2-scgl@linux.ibm.com>
 <77f6f5e7-5945-c478-0e41-affed62252eb@redhat.com>
 <4a06e3e8-4453-9204-eb66-d435860c5714@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <4a06e3e8-4453-9204-eb66-d435860c5714@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12.05.22 15:51, Christian Borntraeger wrote:
> 
> 
> Am 12.05.22 um 15:22 schrieb David Hildenbrand:
>> On 12.05.22 15:10, Janis Schoetterl-Glausch wrote:
>>> If user space uses a memop to emulate an instruction and that
>>> memop fails, the execution of the instruction ends.
>>> Instruction execution can end in different ways, one of which is
>>> suppression, which requires that the instruction execute like a no-op.
>>> A writing memop that spans multiple pages and fails due to key
>>> protection may have modified guest memory, as a result, the likely
>>> correct ending is termination. Therefore, do not indicate a
>>> suppressing instruction ending in this case.
>>
>> I think that is possibly problematic handling.
>>
>> In TCG we stumbled in similar issues in the past for MVC when crossing
>> page boundaries. Failing after modifying the first page already
>> seriously broke some user space, because the guest would retry the
>> instruction after fixing up the fault reason on the second page: if
>> source and destination operands overlap, you'll be in trouble because
>> the input parameters already changed.
>>
>> For this reason, in TCG we make sure that all accesses are valid before
>> starting modifications.
>>
>> See target/s390x/tcg/mem_helper.c:do_helper_mvc with access_prepare()
>> and friends as an example.
>>
>> Now, I don't know how to tackle that for KVM, I just wanted to raise
>> awareness that injecting an interrupt after modifying page content is
>> possible dodgy and dangerous.
> 
> this is really special and only for key protection crossing pages.
> Its been done since the 70ies in that way on z/VM. The architecture
> is and was always written in a way to allow termination for this
> case for hypervisors.

Just so I understand correctly: all instructions that a hypervisor with
hardware virtualization is supposed to emulate are "written in a way to
allow termination", correct? That makes things a lot easier.

-- 
Thanks,

David / dhildenb

