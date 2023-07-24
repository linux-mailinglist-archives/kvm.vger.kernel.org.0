Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269CF75ED95
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 10:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjGXIaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 04:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbjGXIaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 04:30:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B44131
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690187367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6DNzHbGom77n0zpxl+676gi9KyXFJ85R3IBrxW//ask=;
        b=K8kmA+7dSOblqZadST5t/3eJ4VGRbLlp2oUN00eDKQIGR1spm5Nq6A62il1JjEuSuAsXqS
        Ayrgda/ypu7909N1w+mpX/4k8cAz65W8GdjoY+PzWfw8++1t+K8fY9y7XvzynL/Nga5U8u
        zKKZLBt4bcAzaB8KQCQr7xheqKWBmZs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-HwkyBeAJPT2St7bB8gNKiw-1; Mon, 24 Jul 2023 04:29:25 -0400
X-MC-Unique: HwkyBeAJPT2St7bB8gNKiw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fd2dec82a6so11053555e9.3
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690187365; x=1690792165;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6DNzHbGom77n0zpxl+676gi9KyXFJ85R3IBrxW//ask=;
        b=Eujhl5iuPswNblDTafeInFFJncnE7obiBhhQcd+ZKacYjYK1xSd7RMwX02GeyGOsGt
         PDCy+hXyLNKu1XtNMTja8m6MGqeyOsJRjKcALgBfg5KqC5fyvJisA7p2++cyC4ees3jF
         aktI2Zow26D61uk7jqOg9MU+UUL2SzccfaxsZQ9Qy/esIaHkhV3v7Jrh6UeQPN22hDX4
         A3+f3AAuIrCSHS40ucsgEKSJGaFUNSRPz6X4axJc69yRa52SgC1h15bX0MYxpa8CTrho
         VTojOS9iBXDTeffZFm9QAHmxUmJRmOm85yPw8dshw94rJFXR7Uj4yKwy36yyQ4RsEFYp
         0kqA==
X-Gm-Message-State: ABy/qLZQOKxyOEa0wUY6O+FDKS1U+caOu88EAu+gitdbt7A3W3pITJVI
        RLV77XP9TYDLXDLxra1ZVXA4Cx05Wvi2TJXMQR+g481p/oWksXT2eNHqZZlIrY0J+NwRT7rD8mi
        jlcg7Qs0ImIxD
X-Received: by 2002:a05:600c:2308:b0:3f7:3991:e12e with SMTP id 8-20020a05600c230800b003f73991e12emr7402833wmo.1.1690187364802;
        Mon, 24 Jul 2023 01:29:24 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFJflnC/NPtGCRbFCR9C92TkIUPD7R5nWkt94QfcSqyyptU/48AkbkWHtvlGEwx8uIuiIpKVQ==
X-Received: by 2002:a05:600c:2308:b0:3f7:3991:e12e with SMTP id 8-20020a05600c230800b003f73991e12emr7402823wmo.1.1690187364547;
        Mon, 24 Jul 2023 01:29:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f45:d000:62f2:4df0:704a:e859? (p200300d82f45d00062f24df0704ae859.dip0.t-ipconnect.de. [2003:d8:2f45:d000:62f2:4df0:704a:e859])
        by smtp.gmail.com with ESMTPSA id n11-20020a7bcbcb000000b003fba92fad35sm12223151wmi.26.2023.07.24.01.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 01:29:24 -0700 (PDT)
Message-ID: <dbf871ad-1768-18d0-318f-86df33df7446@redhat.com>
Date:   Mon, 24 Jul 2023 10:29:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 5/6] KVM: s390: interrupt: Fix single-stepping ISKE
Content-Language: en-US
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>
References: <20230721120046.2262291-1-iii@linux.ibm.com>
 <20230721120046.2262291-6-iii@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230721120046.2262291-6-iii@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.07.23 13:57, Ilya Leoshkevich wrote:
> kvm_s390_skey_check_enable() does not emulate any instructions, rather,
> it clears CPUSTAT_KSS and arranges for ISKE to run again. Therefore,
> skip the PER check and let ISKE run happen. Otherwise a debugger will
> see two single-step events on the same ISKE.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>   arch/s390/kvm/intercept.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index d2f7940c5d03..8793cec066a6 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -630,8 +630,7 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>   		rc = handle_partial_execution(vcpu);
>   		break;
>   	case ICPT_KSS:
> -		rc = kvm_s390_skey_check_enable(vcpu);
> -		break;
> +		return kvm_s390_skey_check_enable(vcpu);
>   	case ICPT_MCHKREQ:
>   	case ICPT_INT_ENABLE:
>   		/*

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

