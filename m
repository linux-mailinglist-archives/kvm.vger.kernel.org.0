Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D48F6FA9D1
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 12:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbjEHK4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 06:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbjEHKzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 06:55:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC562784C
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 03:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683543228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I/QJdKr/BKvvG/1VBzKIP6fBILeWCCaqJgDwivgQuTk=;
        b=Cy0PUnC6sdLkfX2WU2vARsvP4NLyfPD4AD8Q+gfUsvc7A32V3z1VmNr+X0jsD51XwfxOgF
        gXdiWKVfC+LLxLx/kph65s4RN83A7ccSCQxS8Tl4dwSVccyvSa3yW/3Vyr5qKTto5/lkr8
        0CEtUo1BMCJ9wPDUukF4+sHqAdNoFEI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-UKKdpPCNPCKx1VBUiWAYYw-1; Mon, 08 May 2023 06:53:47 -0400
X-MC-Unique: UKKdpPCNPCKx1VBUiWAYYw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f1749c63c9so15230045e9.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 03:53:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683543226; x=1686135226;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I/QJdKr/BKvvG/1VBzKIP6fBILeWCCaqJgDwivgQuTk=;
        b=XvdxuFXHr9UEEC2oOa8p0vaY7NkOwmIbKGaGVu3IMjIp1QXLlcKrnAQs7nJ9VKgV0N
         DmvGx9T6CsiuBRzzPnweAY/PAeQgUBM9SXu3Mcl0OXradjW1ITma7ol25qMORITsAjKd
         GoDL1xCcxXUIukEfetTedtlsHigEtCMUv8nDfdcD+5gNyf0pJH+AQZSqyge/IJZ+4nsw
         preTjGWSS2pzsI8E2oT3vNn6I0L48eQRWbQqddIuBcRV7CKu+vKUS7FKWq7czgwsVCAn
         /xPTdyyKe48z3gyoB+ACBj/BAaCM1J3roDfi8sttF4DcB5irScvZyh1V09b19Dy+XvN1
         qsJQ==
X-Gm-Message-State: AC+VfDzKExksw58YpN0ri4n31TJfBcMUQckNIv7Z6+GPEOL59nKrroHH
        p7Go7parUOeYztqvfjBWKKTXMkoSyGg8NLqDZA1GikRtqnIFgk6w1XkVgkpEDtZZl4C52tkF9lz
        x0cZcCu+oTDkY
X-Received: by 2002:a05:600c:d2:b0:3f4:28db:f609 with SMTP id u18-20020a05600c00d200b003f428dbf609mr326423wmm.36.1683543225890;
        Mon, 08 May 2023 03:53:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6tCvqu2ay2+fTqUiqfANltk+6enlKtCK9i2F5odCrnPtYN0oBxuk0QKAiUX8r8vzmtWO/SMw==
X-Received: by 2002:a05:600c:d2:b0:3f4:28db:f609 with SMTP id u18-20020a05600c00d200b003f428dbf609mr326418wmm.36.1683543225648;
        Mon, 08 May 2023 03:53:45 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-179-212.web.vodafone.de. [109.43.179.212])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c294900b003f423508c6bsm4310248wmd.44.2023.05.08.03.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 03:53:45 -0700 (PDT)
Message-ID: <a4c02d73-d5d1-4587-5467-ee6a26d2c612@redhat.com>
Date:   Mon, 8 May 2023 12:53:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v1] lib: s390x: mmu: fix conflicting types
 for get_dat_entry
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230508102426.130768-1-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230508102426.130768-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/2023 12.24, Nico Boehr wrote:
> This causes compilation to fail with GCC 13:
> 
> gcc -std=gnu99 -ffreestanding -I/kut/lib -I/kut/lib/s390x -Ilib -O2 -march=zEC12 -mbackchain -fno-delete-null-pointer-checks -g -MMD -MF lib/s390x/.mmu.d -fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -Wno-missing-braces -Werror  -fomit-frame-pointer  -fno-stack-protector    -Wno-frame-address   -fno-pic  -no-pie  -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes -I/kut/lib -I/kut/lib/s390x -Ilib  -c -o lib/s390x/mmu.o lib/s390x/mmu.c
> lib/s390x/mmu.c:132:7: error: conflicting types for ‘get_dat_entry’ due to enum/integer mismatch; have ‘void *(pgd_t *, void *, enum pgt_level)’ [-Werror=enum-int-mismatch]
>    132 | void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level level)
>        |       ^~~~~~~~~~~~~
> In file included from lib/s390x/mmu.c:16:
> lib/s390x/mmu.h:96:7: note: previous declaration of ‘get_dat_entry’ with type ‘void *(pgd_t *, void *, unsigned int)’
>     96 | void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level);
>        |       ^~~~~~~~~~~~~
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/mmu.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
> index 15f88e4f424e..dadc2e600f9a 100644
> --- a/lib/s390x/mmu.h
> +++ b/lib/s390x/mmu.h
> @@ -93,6 +93,6 @@ static inline void unprotect_page(void *vaddr, unsigned long prot)
>   	unprotect_dat_entry(vaddr, prot, pgtable_level_pte);
>   }
>   
> -void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level);
> +void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level level);
>   
>   #endif /* _ASMS390X_MMU_H_ */

Reviewed-by: Thomas Huth <thuth@redhat.com>

