Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DB44FDCD3
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 13:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244781AbiDLKmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 06:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354706AbiDLKdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 06:33:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9533B5BD05
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 02:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649756032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WeWevPYgNWBpJXA96t4hpuZdB+k5JbdqpxXMJm2gkXs=;
        b=D55nB700AZTVpCGni03XyaqxdKjF3el8VW+cSl9q5xU+Ma77/iIRo8Own2kBcukhACEM6/
        F0ZD0GWuZ38HSRYVt0e8nYgsybZkSFpodvoBEcW/l5i1F+LKNiSRWMboaTQ3Y3WTj39rSY
        cN+A67JGc25n2wxtUj5wg+RwC2gdTCk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-0i95Nl1PPHun5WbOpSFycA-1; Tue, 12 Apr 2022 05:33:51 -0400
X-MC-Unique: 0i95Nl1PPHun5WbOpSFycA-1
Received: by mail-wr1-f71.google.com with SMTP id q4-20020adfc504000000b002079c9cc1bfso1508011wrf.11
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 02:33:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WeWevPYgNWBpJXA96t4hpuZdB+k5JbdqpxXMJm2gkXs=;
        b=nmYGzeOyxDXrn036530zfHx4vBTF+rdcB9Q0T8WP8v3pFAuSRmVqAuEd2WAMfp97CC
         PJBvdjD6+VJ31sG+U8+jM7bwmyc+i0tzte1sOPnIgbE0wt7T45hRqaov9wSQZt3Axyv8
         WN+2WHipMmwGJact1BannaZcPzzIUF1uUeevMWQb15Cm3j11LkgXSCqvbfbU+eMAhIdr
         7cL+HCeEyfRu+9DqrATVa4lE7t4z8dO8UvHwh8iBNJljgqVlTMrKjX6Ej8NHWT2hnzxz
         hJPgwa9LDeEl5vxDSQxheHwMqTlYdlM0WmSHVkivSsZ8jnzty5E5paKex1G8ZTGjrUnc
         tR3Q==
X-Gm-Message-State: AOAM533UZ+12aXRphV33O5x964ndd1VWZ2x0AegRi4Qo3SloQjscpnXw
        ycD7tPpdxNDUdFvdyYizyxxn1b+meEQxOC9pEqzpWtwolT2px46//qXB+MNYGbb2c9I4pc0jTn4
        GtX/syFneVFmg
X-Received: by 2002:a05:600c:4ecc:b0:38e:354d:909 with SMTP id g12-20020a05600c4ecc00b0038e354d0909mr3381788wmq.33.1649756030227;
        Tue, 12 Apr 2022 02:33:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQZ8YWhTQHJqSTnxz84V1suA86KaCiCkNGpqspOSTk2riKnfCekPnWy6Y4EwJ69895Ace0Cw==
X-Received: by 2002:a05:600c:4ecc:b0:38e:354d:909 with SMTP id g12-20020a05600c4ecc00b0038e354d0909mr3381779wmq.33.1649756030060;
        Tue, 12 Apr 2022 02:33:50 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id v8-20020a1cf708000000b0034d7b5f2da0sm1926370wmh.33.2022.04.12.02.33.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 02:33:49 -0700 (PDT)
Message-ID: <d458e729-1497-b3d7-16fc-eac3e6c54945@redhat.com>
Date:   Tue, 12 Apr 2022 11:33:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: epsw: fix
 report_pop_prefix() when running under non-QEMU
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220412092941.20742-1-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220412092941.20742-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/2022 11.29, Nico Boehr wrote:
> When we don't run in QEMU, we didn't push a prefix, hence pop won't work. Fix
> this by pushing the prefix before the QEMU check.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/epsw.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/epsw.c b/s390x/epsw.c
> index 5b73f4b3db6c..d8090d95a486 100644
> --- a/s390x/epsw.c
> +++ b/s390x/epsw.c
> @@ -97,13 +97,13 @@ static void test_epsw(void)
>   
>   int main(int argc, char **argv)
>   {
> +	report_prefix_push("epsw");
> +
>   	if (!host_is_kvm() && !host_is_tcg()) {
>   		report_skip("Not running under QEMU");
>   		goto done;
>   	}
>   
> -	report_prefix_push("epsw");
> -
>   	test_epsw();
>   
>   done:

Reviewed-by: Thomas Huth <thuth@redhat.com>

