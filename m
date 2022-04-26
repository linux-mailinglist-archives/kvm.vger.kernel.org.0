Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E7C50F95F
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 11:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347882AbiDZKBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 06:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347670AbiDZKAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 06:00:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D221651325
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 02:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650964775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iBRkEviS1YNjQ13b+V4Agg/J+uYrF542VyGq785gczs=;
        b=Aij1D81/amyn503Q6EoNu3e9BdGcDRPWvETSSwLPwAcV01Xylhget6L/hgFn+mPHccTO7r
        GZqKSL/29zvAnjVG/HCZOIW6QadccogcQnTtG3HTfDKCjt3FtmDk5J5XENVQa3ig94E3br
        wr/j+ZrDB5RbgmFqEjlC9Mx8yKVs77c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-J6QDuBTzPs-ldmn9YUQYPA-1; Tue, 26 Apr 2022 05:19:34 -0400
X-MC-Unique: J6QDuBTzPs-ldmn9YUQYPA-1
Received: by mail-wr1-f70.google.com with SMTP id t17-20020adfa2d1000000b0020ac519c222so3139576wra.4
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 02:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iBRkEviS1YNjQ13b+V4Agg/J+uYrF542VyGq785gczs=;
        b=ThNB8mQ00u/unyIq07ZYSSCzoWV3FY58nuCBA6wevTdzybYtaWw+1UIh7NTaW0EV4L
         da2HyKvaXVKPTagzTfIrk99gfokwqUOtiFDeKG3HEnBJ9bxtWtEpb+3eoJj9/R3lYqDf
         XmafOOFtXHzvacfnBwGQS0fm8VClQgG58J0OSguvpKlpqdrX4/jxs3wCk/UndB0iE01O
         4s1mdMAeOv/D/rI77Sr63iTkFAcNUoJxxFjFYRe3pUU+nMiaNcbjfnOuXAP/k4nH9h+u
         KJKkkVMfUF8ss69jIO/cPfIkgZTS1aMqe6oCKnLtsrkzPGsTO1Hi/UigIDdk9ndEJM+2
         A41w==
X-Gm-Message-State: AOAM5301G5/xGS9lSQOvyYSU2T95ykXPm7Hov9B/sn3EGEmZVJD3g9FP
        A9z2wk5EdF8tMGAiPi3y6OXZVmTqQU/UC5YviruLA/HyxoU7VM46+WDEL3whlhTZ/E1s6J6flIH
        ALWpu/LAy+9hk
X-Received: by 2002:a05:600c:34c7:b0:392:8d86:b148 with SMTP id d7-20020a05600c34c700b003928d86b148mr31128125wmq.117.1650964773189;
        Tue, 26 Apr 2022 02:19:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3g0T+/FCLjJ0bZ+M07PU+5ayGTcn33K/tOBGzxCqziai/a8wZXZpvP8ep38k8ROKZjCBQKw==
X-Received: by 2002:a05:600c:34c7:b0:392:8d86:b148 with SMTP id d7-20020a05600c34c700b003928d86b148mr31128107wmq.117.1650964772945;
        Tue, 26 Apr 2022 02:19:32 -0700 (PDT)
Received: from [10.33.192.232] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id c3-20020a05600c148300b0038ebc8ad740sm14574063wmh.1.2022.04.26.02.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 02:19:30 -0700 (PDT)
Message-ID: <ae34a497-a471-8db9-ca0f-2a82e6803f45@redhat.com>
Date:   Tue, 26 Apr 2022 11:19:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v5] s390x: Test effect of storage keys on
 some instructions
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220425161731.1575742-1-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220425161731.1575742-1-scgl@linux.ibm.com>
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

On 25/04/2022 18.17, Janis Schoetterl-Glausch wrote:
> Some instructions are emulated by KVM. Test that KVM correctly emulates
> storage key checking for two of those instructions (STORE CPU ADDRESS,
> SET PREFIX).
> Test success and error conditions, including coverage of storage and
> fetch protection override.
> Also add test for TEST PROTECTION, even if that instruction will not be
> emulated by KVM under normal conditions.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>
Reviewed-by: Thomas Huth <thuth@redhat.com>

